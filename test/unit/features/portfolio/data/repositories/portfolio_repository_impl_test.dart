import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/features/portfolio/data/datasources/portfolio_api_data_source.dart';
import 'package:portfolio_tracker/features/portfolio/data/datasources/portfolio_cache_data_source.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/watchlist_item_dto.dart';
import 'package:portfolio_tracker/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';

void main() {
  test('falls back to cached portfolio when the network fetch fails', () async {
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      _MutablePortfolioCacheDataSource(),
    );

    final snapshot = await repository.fetchPortfolio();

    expect(snapshot.overview.totalValue, 4250);
    expect(snapshot.holdings, hasLength(1));
  });

  test(
    'addTransaction persists a local buy and updates portfolio totals',
    () async {
      final cache = _MutablePortfolioCacheDataSource();
      final repository = PortfolioRepositoryImpl(
        _FailingPortfolioApiDataSource(),
        cache,
      );

      final snapshot = await repository.addTransaction(
        PortfolioTransactionDraft(
          symbol: 'NVDA',
          assetName: 'NVIDIA',
          type: PortfolioTransactionType.buy,
          amount: 600,
          quantity: 2,
          sector: 'Technology',
          date: DateTime(2026, 4, 1),
        ),
      );

      expect(
        snapshot.holdings.map((holding) => holding.symbol),
        contains('NVDA'),
      );
      expect(snapshot.transactions.first.assetSymbol, 'NVDA');
      expect(snapshot.overview.cashBalance, 1900);
      expect(snapshot.overview.totalValue, 4250);
      expect(cache.savedSnapshots, isNotEmpty);
    },
  );

  test(
    'withdrawCash rejects amounts larger than the available balance',
    () async {
      final repository = PortfolioRepositoryImpl(
        _FailingPortfolioApiDataSource(),
        _MutablePortfolioCacheDataSource(),
      );

      expect(
        () => repository.withdrawCash(3000),
        throwsA(
          isA<AppError>().having(
            (error) => error.details,
            'details',
            'Not enough cash available for this withdrawal.',
          ),
        ),
      );
    },
  );

  test('exportPortfolio serializes the cached snapshot as JSON', () async {
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      _MutablePortfolioCacheDataSource(),
    );

    final rawJson = await repository.exportPortfolio();
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;

    expect(decoded['overview'], isA<Map<String, dynamic>>());
    expect(decoded['holdings'], isA<List<dynamic>>());
    expect(decoded['transactions'], isA<List<dynamic>>());
  });

  test('importPortfolio validates and persists an imported snapshot', () async {
    final cache = _MutablePortfolioCacheDataSource();
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      cache,
    );

    final rawJson = jsonEncode(
      PortfolioSnapshotDto(
        overview: PortfolioOverviewDto(
          totalValue: 5100,
          totalInvested: 4200,
          cashBalance: 900,
          dayChange: 120,
        ),
        holdings: [
          HoldingDto(
            symbol: 'AAPL',
            name: 'Apple',
            quantity: 5,
            averageCost: 160,
            currentPrice: 180,
            sector: 'Technology',
          ),
        ],
        transactions: [
          PortfolioTransactionDto(
            assetSymbol: 'AAPL',
            assetName: 'Apple',
            type: PortfolioTransactionType.buy,
            amount: 800,
            quantity: 5,
            date: DateTime(2026, 4, 5),
          ),
        ],
      ).toJson(),
    );

    final snapshot = await repository.importPortfolio(rawJson);

    expect(snapshot.overview.totalValue, 5100);
    expect(snapshot.holdings.single.symbol, 'AAPL');
    expect(cache.savedSnapshots.last.overview.totalValue, 5100);
  });

  test('addWatchlistItem persists a sorted local watchlist', () async {
    final cache = _MutablePortfolioCacheDataSource();
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      cache,
    );

    final watchlist = await repository.addWatchlistItem(
      const WatchlistItemDraft(
        symbol: 'NVDA',
        name: 'NVIDIA',
        sector: 'Technology',
        targetPrice: 950,
      ),
    );

    expect(watchlist.single.symbol, 'NVDA');
    expect(cache.savedWatchlists.last.single.symbol, 'NVDA');
  });

  test('removeWatchlistItem deletes the requested symbol', () async {
    final cache = _MutablePortfolioCacheDataSource(
      watchlist: [
        WatchlistItemDto(
          symbol: 'GOOGL',
          name: 'Alphabet',
          sector: 'Technology',
          addedAt: DateTime(2026, 4, 1),
        ),
      ],
    );
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      cache,
    );

    final watchlist = await repository.removeWatchlistItem('GOOGL');

    expect(watchlist, isEmpty);
    expect(cache.savedWatchlists.last, isEmpty);
  });

  test('fetchWatchlist handles an empty cached watchlist', () async {
    final repository = PortfolioRepositoryImpl(
      _FailingPortfolioApiDataSource(),
      _MutablePortfolioCacheDataSource(watchlist: const []),
    );

    final watchlist = await repository.fetchWatchlist();

    expect(watchlist, isEmpty);
  });
}

class _FailingPortfolioApiDataSource implements PortfolioApiDataSource {
  @override
  Future<PortfolioSnapshotDto> fetchPortfolio() {
    throw const AppError(
      type: AppErrorType.networkConnection,
      details: 'offline',
    );
  }
}

class _MutablePortfolioCacheDataSource implements PortfolioCacheDataSource {
  _MutablePortfolioCacheDataSource({
    PortfolioSnapshotDto? snapshot,
    List<WatchlistItemDto>? watchlist,
  }) : _snapshot = snapshot ?? _initialSnapshot,
       _watchlist = watchlist ?? [];

  static final PortfolioSnapshotDto _initialSnapshot = PortfolioSnapshotDto(
    overview: const PortfolioOverviewDto(
      totalValue: 4250,
      totalInvested: 8000,
      cashBalance: 2500,
      dayChange: 40,
    ),
    holdings: const [
      HoldingDto(
        symbol: 'MSFT',
        name: 'Microsoft',
        quantity: 5,
        averageCost: 300,
        currentPrice: 350,
        sector: 'Technology',
      ),
    ],
    transactions: [
      PortfolioTransactionDto(
        assetSymbol: 'MSFT',
        assetName: 'Microsoft',
        type: PortfolioTransactionType.buy,
        amount: 1500,
        quantity: 5,
        date: DateTime(2026, 1, 1),
      ),
    ],
  );

  PortfolioSnapshotDto? _snapshot;
  List<WatchlistItemDto> _watchlist;
  final savedSnapshots = <PortfolioSnapshotDto>[];
  final savedWatchlists = <List<WatchlistItemDto>>[];

  @override
  Future<PortfolioSnapshotDto?> loadPortfolio() async => _snapshot;

  @override
  Future<void> savePortfolio(PortfolioSnapshotDto snapshot) async {
    _snapshot = snapshot;
    savedSnapshots.add(snapshot);
  }

  @override
  Future<List<WatchlistItemDto>> loadWatchlist() async => _watchlist;

  @override
  Future<void> saveWatchlist(List<WatchlistItemDto> watchlist) async {
    _watchlist = watchlist;
    savedWatchlists.add(watchlist);
  }
}
