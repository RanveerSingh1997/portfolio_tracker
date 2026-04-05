import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';

void main() {
  test(
    'refreshOverview failure keeps holdings data while only failing the overview section',
    () async {
      final cubit = PortfolioCubit(repository: _SectionedPortfolioRepository());

      await cubit.loadPortfolio();
      await cubit.refreshOverview();

      expect(cubit.state.holdings, isNotEmpty);
      expect(cubit.state.holdingsStatus, PortfolioSectionStatus.success);
      expect(cubit.state.overviewStatus, PortfolioSectionStatus.failure);
      expect(cubit.state.overviewError?.type, AppErrorType.networkTimeout);
    },
  );

  test(
    'holdings filters search, sector, and sort in the derived visible list',
    () async {
      final cubit = PortfolioCubit(repository: _SectionedPortfolioRepository());

      await cubit.loadPortfolio();
      cubit.updateHoldingsSearchQuery('a');
      cubit.updateHoldingsSectorFilter('Technology');
      cubit.updateHoldingsSortOption(HoldingsSortOption.symbol);

      expect(
        cubit.state.visibleHoldings.map((holding) => holding.symbol).toList(),
        ['AAPL', 'NVDA'],
      );
    },
  );

  test(
    'addTransaction refreshes the state with the locally updated snapshot',
    () async {
      final repository = _MutablePortfolioRepository();
      final cubit = PortfolioCubit(repository: repository);

      await cubit.loadPortfolio();
      final error = await cubit.addTransaction(
        PortfolioTransactionDraft(
          symbol: 'TSLA',
          assetName: 'Tesla',
          type: PortfolioTransactionType.buy,
          amount: 720,
          quantity: 3,
          sector: 'Automotive',
          date: DateTime(2026, 4, 2),
        ),
      );

      expect(error, isNull);
      expect(cubit.state.transactions.first.assetSymbol, 'TSLA');
      expect(
        cubit.state.holdings.map((holding) => holding.symbol),
        contains('TSLA'),
      );
      expect(cubit.state.overview?.cashBalance, 780);
    },
  );

  test(
    'transactions filters search, type, and current-year activity in the derived visible list',
    () async {
      final cubit = PortfolioCubit(repository: _SectionedPortfolioRepository());

      await cubit.loadPortfolio();
      cubit.updateTransactionsSearchQuery('nvi');
      cubit.updateTransactionsTypeFilter(PortfolioTransactionType.dividend);
      cubit.updateTransactionsYearFilter(TransactionYearFilter.currentYear);

      expect(
        cubit.state.visibleTransactions
            .map((transaction) => transaction.assetSymbol)
            .toList(),
        ['NVDA'],
      );
    },
  );

  test(
    'addWatchlistItem updates the locally tracked watchlist state',
    () async {
      final repository = _MutablePortfolioRepository();
      final cubit = PortfolioCubit(repository: repository);

      await cubit.loadPortfolio();
      final error = await cubit.addWatchlistItem(
        const WatchlistItemDraft(
          symbol: 'AMZN',
          name: 'Amazon',
          sector: 'Consumer Discretionary',
          targetPrice: 210,
        ),
      );

      expect(error, isNull);
      expect(
        cubit.state.watchlist.map((item) => item.symbol),
        contains('AMZN'),
      );
    },
  );
}

class _SectionedPortfolioRepository implements PortfolioRepository {
  @override
  Future<PortfolioSnapshot> fetchPortfolio() async {
    return _portfolioSnapshot();
  }

  @override
  Future<List<Holding>> fetchHoldings() async {
    return (await fetchPortfolio()).holdings;
  }

  @override
  Future<PortfolioOverview> fetchOverview() {
    throw const AppError(
      type: AppErrorType.networkTimeout,
      details: 'overview timeout',
    );
  }

  @override
  Future<List<PortfolioTransaction>> fetchTransactions() async {
    return (await fetchPortfolio()).transactions;
  }

  @override
  Future<PortfolioSnapshot> addTransaction(PortfolioTransactionDraft draft) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioSnapshot> depositCash(double amount) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioSnapshot> withdrawCash(double amount) {
    throw UnimplementedError();
  }

  @override
  Future<String> exportPortfolio() {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioSnapshot> importPortfolio(String rawJson) {
    throw UnimplementedError();
  }

  @override
  Future<List<WatchlistItem>> fetchWatchlist() async => const [];

  @override
  Future<List<WatchlistItem>> addWatchlistItem(WatchlistItemDraft draft) {
    throw UnimplementedError();
  }

  @override
  Future<List<WatchlistItem>> removeWatchlistItem(String symbol) {
    throw UnimplementedError();
  }
}

class _MutablePortfolioRepository implements PortfolioRepository {
  _MutablePortfolioRepository()
    : _snapshot = _portfolioSnapshot(),
      _watchlist = [];

  PortfolioSnapshot _snapshot;
  List<WatchlistItem> _watchlist;

  @override
  Future<PortfolioSnapshot> fetchPortfolio() async => _snapshot;

  @override
  Future<List<Holding>> fetchHoldings() async => _snapshot.holdings;

  @override
  Future<PortfolioOverview> fetchOverview() async => _snapshot.overview;

  @override
  Future<List<PortfolioTransaction>> fetchTransactions() async {
    return _snapshot.transactions;
  }

  @override
  Future<PortfolioSnapshot> addTransaction(
    PortfolioTransactionDraft draft,
  ) async {
    _snapshot = PortfolioSnapshot(
      overview: PortfolioOverview(
        totalValue: _snapshot.overview.totalValue,
        totalInvested: _snapshot.overview.totalInvested,
        cashBalance: _snapshot.overview.cashBalance - draft.amount,
        dayChange: _snapshot.overview.dayChange,
      ),
      holdings: [
        ..._snapshot.holdings,
        Holding(
          symbol: draft.symbol,
          name: draft.assetName,
          quantity: draft.quantity ?? 0,
          averageCost: draft.amount / (draft.quantity ?? 1),
          currentPrice: draft.amount / (draft.quantity ?? 1),
          sector: draft.sector ?? 'Unknown',
        ),
      ],
      transactions: [
        PortfolioTransaction(
          assetSymbol: draft.symbol,
          assetName: draft.assetName,
          type: draft.type,
          amount: draft.amount,
          quantity: draft.quantity,
          date: draft.date,
        ),
        ..._snapshot.transactions,
      ],
    );

    return _snapshot;
  }

  @override
  Future<PortfolioSnapshot> depositCash(double amount) async {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioSnapshot> withdrawCash(double amount) async {
    throw UnimplementedError();
  }

  @override
  Future<String> exportPortfolio() {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioSnapshot> importPortfolio(String rawJson) {
    throw UnimplementedError();
  }

  @override
  Future<List<WatchlistItem>> fetchWatchlist() async => _watchlist;

  @override
  Future<List<WatchlistItem>> addWatchlistItem(WatchlistItemDraft draft) async {
    _watchlist = [
      ..._watchlist,
      WatchlistItem(
        symbol: draft.symbol,
        name: draft.name,
        sector: draft.sector,
        addedAt: DateTime.now(),
        targetPrice: draft.targetPrice,
        note: draft.note,
      ),
    ];
    return _watchlist;
  }

  @override
  Future<List<WatchlistItem>> removeWatchlistItem(String symbol) async {
    _watchlist = _watchlist.where((item) => item.symbol != symbol).toList();
    return _watchlist;
  }
}

PortfolioSnapshot _portfolioSnapshot() {
  final currentYear = DateTime.now().year;

  return PortfolioSnapshot(
    overview: const PortfolioOverview(
      totalValue: 12000,
      totalInvested: 10000,
      cashBalance: 1500,
      dayChange: 90,
    ),
    holdings: const [
      Holding(
        symbol: 'AAPL',
        name: 'Apple',
        quantity: 4,
        averageCost: 170,
        currentPrice: 190,
        sector: 'Technology',
      ),
      Holding(
        symbol: 'NVDA',
        name: 'NVIDIA',
        quantity: 2,
        averageCost: 240,
        currentPrice: 300,
        sector: 'Technology',
      ),
      Holding(
        symbol: 'JPM',
        name: 'JPMorgan Chase',
        quantity: 3,
        averageCost: 145,
        currentPrice: 155,
        sector: 'Financials',
      ),
    ],
    transactions: [
      PortfolioTransaction(
        assetSymbol: 'AAPL',
        assetName: 'Apple',
        type: PortfolioTransactionType.buy,
        amount: 680,
        quantity: 4,
        date: DateTime(currentYear, 3, 1),
      ),
      PortfolioTransaction(
        assetSymbol: 'NVDA',
        assetName: 'NVIDIA',
        type: PortfolioTransactionType.dividend,
        amount: 48,
        date: DateTime(currentYear, 4, 1),
      ),
      PortfolioTransaction(
        assetSymbol: 'JPM',
        assetName: 'JPMorgan Chase',
        type: PortfolioTransactionType.sell,
        amount: 465,
        quantity: 3,
        date: DateTime(currentYear - 1, 12, 20),
      ),
    ],
  );
}
