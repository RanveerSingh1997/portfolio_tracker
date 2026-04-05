import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';

/// Domain boundary for everything the portfolio feature can do.
///
/// Presentation code depends on this contract instead of directly calling Dio,
/// shared preferences, or DTOs. That keeps UI/state code stable while the data
/// layer evolves.
abstract class PortfolioRepository {
  Future<PortfolioSnapshot> fetchPortfolio();
  Future<PortfolioOverview> fetchOverview();
  Future<List<Holding>> fetchHoldings();
  Future<List<PortfolioTransaction>> fetchTransactions();
  Future<List<WatchlistItem>> fetchWatchlist();
  Future<PortfolioSnapshot> addTransaction(PortfolioTransactionDraft draft);
  Future<PortfolioSnapshot> depositCash(double amount);
  Future<PortfolioSnapshot> withdrawCash(double amount);
  Future<String> exportPortfolio();
  Future<PortfolioSnapshot> importPortfolio(String rawJson);
  Future<List<WatchlistItem>> addWatchlistItem(WatchlistItemDraft draft);
  Future<List<WatchlistItem>> removeWatchlistItem(String symbol);
}
