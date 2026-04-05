import 'package:flutter_test/flutter_test.dart';
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
    '''
Given an investor has holdings and available cash
When the portfolio loads
Then the dashboard state exposes total value and holdings
''',
    () async {
      final cubit = PortfolioCubit(repository: _FakePortfolioRepository());

      await cubit.loadPortfolio();

      expect(cubit.state.status, PortfolioStatus.success);
      expect(cubit.state.overview?.totalValue, 7500);
      expect(cubit.state.overview?.cashBalance, 1200);
      expect(cubit.state.holdings, hasLength(1));
    },
  );
}

class _FakePortfolioRepository implements PortfolioRepository {
  @override
  Future<PortfolioSnapshot> fetchPortfolio() async {
    return PortfolioSnapshot(
      overview: const PortfolioOverview(
        totalValue: 7500,
        totalInvested: 6800,
        cashBalance: 1200,
        dayChange: 140,
      ),
      holdings: const [
        Holding(
          symbol: 'AAPL',
          name: 'Apple',
          quantity: 10,
          averageCost: 160,
          currentPrice: 185,
          sector: 'Technology',
        ),
      ],
      transactions: [
        PortfolioTransaction(
          assetSymbol: 'AAPL',
          assetName: 'Apple',
          type: PortfolioTransactionType.buy,
          amount: 1600,
          date: DateTime(2026, 3, 10),
          quantity: 10,
        ),
      ],
    );
  }

  @override
  Future<List<Holding>> fetchHoldings() async {
    return (await fetchPortfolio()).holdings;
  }

  @override
  Future<PortfolioOverview> fetchOverview() async {
    return (await fetchPortfolio()).overview;
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
