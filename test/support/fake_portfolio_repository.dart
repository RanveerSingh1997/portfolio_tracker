import 'dart:convert';

import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';

class FakePortfolioRepository implements PortfolioRepository {
  const FakePortfolioRepository();

  @override
  Future<PortfolioSnapshot> fetchPortfolio() async {
    return PortfolioSnapshot(
      overview: const PortfolioOverview(
        totalValue: 16432.55,
        totalInvested: 15310.35,
        cashBalance: 4250.75,
        dayChange: 268.14,
      ),
      holdings: const [
        Holding(
          symbol: 'AAPL',
          name: 'Apple',
          quantity: 12,
          averageCost: 172.40,
          currentPrice: 191.80,
          sector: 'Technology',
        ),
        Holding(
          symbol: 'MSFT',
          name: 'Microsoft',
          quantity: 8,
          averageCost: 388.30,
          currentPrice: 417.15,
          sector: 'Technology',
        ),
      ],
      transactions: [
        PortfolioTransaction(
          assetSymbol: 'AAPL',
          assetName: 'Apple',
          type: PortfolioTransactionType.buy,
          amount: 1034.40,
          quantity: 6,
          date: DateTime(2026, 3, 18),
        ),
        PortfolioTransaction(
          assetSymbol: 'AAPL',
          assetName: 'Apple',
          type: PortfolioTransactionType.dividend,
          amount: 18.22,
          date: DateTime(2026, 2, 14),
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
  Future<String> exportPortfolio() async {
    final snapshot = await fetchPortfolio();
    return const JsonEncoder.withIndent(
      '  ',
    ).convert(PortfolioSnapshotDto.fromDomain(snapshot).toJson());
  }

  @override
  Future<PortfolioSnapshot> importPortfolio(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Portfolio import must be a JSON object.');
    }

    return PortfolioSnapshotDto.fromJson(decoded).toDomain();
  }

  @override
  Future<List<WatchlistItem>> fetchWatchlist() async {
    return [
      WatchlistItem(
        symbol: 'GOOGL',
        name: 'Alphabet',
        sector: 'Technology',
        addedAt: DateTime(2026, 4, 1),
        targetPrice: 180,
      ),
    ];
  }

  @override
  Future<List<WatchlistItem>> addWatchlistItem(WatchlistItemDraft draft) {
    throw UnimplementedError();
  }

  @override
  Future<List<WatchlistItem>> removeWatchlistItem(String symbol) {
    throw UnimplementedError();
  }
}
