import 'dart:convert';
import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/features/portfolio/data/datasources/portfolio_api_data_source.dart';
import 'package:portfolio_tracker/features/portfolio/data/datasources/portfolio_cache_data_source.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/watchlist_item_dto.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';

/// Concrete repository used by the portfolio feature.
///
/// Repositories are the boundary the rest of the app depends on. The Cubit only
/// knows it can ask for a [PortfolioSnapshot]; it does not know whether that
/// data came from localhost HTTP, SQLite, a remote backend, or cached memory.
@LazySingleton(as: PortfolioRepository)
class PortfolioRepositoryImpl implements PortfolioRepository {
  PortfolioRepositoryImpl(this._apiDataSource, this._cacheDataSource);

  final PortfolioApiDataSource _apiDataSource;
  final PortfolioCacheDataSource _cacheDataSource;

  @override
  Future<PortfolioSnapshot> fetchPortfolio() async {
    final cachedPortfolio = await _cacheDataSource.loadPortfolio();
    if (cachedPortfolio != null) {
      return cachedPortfolio.toDomain();
    }

    try {
      // The data source returns a DTO because it is still shaped like data.
      final portfolio = await _apiDataSource.fetchPortfolio();
      await _cacheDataSource.savePortfolio(portfolio);

      // The repository converts that DTO into the domain entity used by the rest
      // of the app. Domain entities should feel natural to business logic and UI.
      return portfolio.toDomain();
    } on AppError {
      final cachedPortfolio = await _cacheDataSource.loadPortfolio();
      if (cachedPortfolio != null) {
        return cachedPortfolio.toDomain();
      }

      rethrow;
    }
  }

  @override
  Future<PortfolioOverview> fetchOverview() async {
    return (await fetchPortfolio()).overview;
  }

  @override
  Future<List<Holding>> fetchHoldings() async {
    return (await fetchPortfolio()).holdings;
  }

  @override
  Future<List<PortfolioTransaction>> fetchTransactions() async {
    return (await fetchPortfolio()).transactions;
  }

  @override
  Future<List<WatchlistItem>> fetchWatchlist() async {
    final watchlist = [...await _cacheDataSource.loadWatchlist()];
    watchlist.sort((left, right) => left.symbol.compareTo(right.symbol));
    return watchlist.map((item) => item.toDomain()).toList();
  }

  @override
  Future<PortfolioSnapshot> addTransaction(
    PortfolioTransactionDraft draft,
  ) async {
    final snapshot = await fetchPortfolio();
    _validateDraft(draft);

    final updatedTransactions = [
      ...snapshot.transactions,
      _toTransaction(draft),
    ]..sort((left, right) => right.date.compareTo(left.date));
    final updatedHoldings = _applyDraftToHoldings(snapshot.holdings, draft);
    final updatedOverview = _rebuildOverview(
      previous: snapshot.overview,
      holdings: updatedHoldings,
      transaction: draft,
      cashDelta: _cashDeltaForTransaction(draft),
      investedDelta: 0,
    );

    final updatedSnapshot = PortfolioSnapshot(
      overview: updatedOverview,
      holdings: updatedHoldings,
      transactions: updatedTransactions,
    );

    await _saveSnapshot(updatedSnapshot);
    return updatedSnapshot;
  }

  @override
  Future<PortfolioSnapshot> depositCash(double amount) async {
    _requirePositive(amount, 'Amount must be greater than zero.');
    final snapshot = await fetchPortfolio();
    final updatedOverview = _rebuildOverview(
      previous: snapshot.overview,
      holdings: snapshot.holdings,
      cashDelta: amount,
      investedDelta: amount,
    );
    final updatedSnapshot = PortfolioSnapshot(
      overview: updatedOverview,
      holdings: snapshot.holdings,
      transactions: snapshot.transactions,
    );
    await _saveSnapshot(updatedSnapshot);
    return updatedSnapshot;
  }

  @override
  Future<PortfolioSnapshot> withdrawCash(double amount) async {
    _requirePositive(amount, 'Amount must be greater than zero.');
    final snapshot = await fetchPortfolio();
    if (snapshot.overview.cashBalance < amount) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Not enough cash available for this withdrawal.',
      );
    }

    final updatedOverview = _rebuildOverview(
      previous: snapshot.overview,
      holdings: snapshot.holdings,
      cashDelta: -amount,
      investedDelta: -math.min(snapshot.overview.totalInvested, amount),
    );
    final updatedSnapshot = PortfolioSnapshot(
      overview: updatedOverview,
      holdings: snapshot.holdings,
      transactions: snapshot.transactions,
    );
    await _saveSnapshot(updatedSnapshot);
    return updatedSnapshot;
  }

  @override
  Future<String> exportPortfolio() async {
    final snapshot = await fetchPortfolio();
    final dto = PortfolioSnapshotDto.fromDomain(snapshot);
    return const JsonEncoder.withIndent('  ').convert(dto.toJson());
  }

  @override
  Future<PortfolioSnapshot> importPortfolio(String rawJson) async {
    if (rawJson.trim().isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Portfolio import data cannot be empty.',
      );
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Portfolio import must be a JSON object.');
      }

      final dto = PortfolioSnapshotDto.fromJson(decoded);
      final snapshot = dto.toDomain();
      await _saveSnapshot(
        PortfolioSnapshot(
          overview: snapshot.overview,
          holdings: snapshot.holdings,
          transactions: [...snapshot.transactions]
            ..sort((left, right) => right.date.compareTo(left.date)),
        ),
      );
      return fetchPortfolio();
    } on FormatException catch (error) {
      throw AppError(type: AppErrorType.parseError, details: error.message);
    } on AppError {
      rethrow;
    } catch (_) {
      throw const AppError(
        type: AppErrorType.parseError,
        details: 'Portfolio import data is not valid JSON.',
      );
    }
  }

  @override
  Future<List<WatchlistItem>> addWatchlistItem(WatchlistItemDraft draft) async {
    final normalizedSymbol = draft.symbol.trim().toUpperCase();
    final normalizedName = draft.name.trim();
    final normalizedSector = draft.sector.trim();
    final normalizedNote = draft.note?.trim();

    if (normalizedSymbol.isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Symbol is required.',
      );
    }
    if (normalizedName.isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Asset name is required.',
      );
    }
    if (normalizedSector.isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Sector is required.',
      );
    }
    if (draft.targetPrice != null && draft.targetPrice! <= 0) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Target price must be greater than zero.',
      );
    }

    final watchlist = await _cacheDataSource.loadWatchlist();
    if (watchlist.any((item) => item.symbol == normalizedSymbol)) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'This symbol is already on the watchlist.',
      );
    }

    final updatedWatchlist = [
      ...watchlist,
      WatchlistItemDto(
        symbol: normalizedSymbol,
        name: normalizedName,
        sector: normalizedSector,
        addedAt: DateTime.now(),
        targetPrice: draft.targetPrice,
        note: normalizedNote == null || normalizedNote.isEmpty
            ? null
            : normalizedNote,
      ),
    ]..sort((left, right) => left.symbol.compareTo(right.symbol));

    await _cacheDataSource.saveWatchlist(updatedWatchlist);
    return updatedWatchlist.map((item) => item.toDomain()).toList();
  }

  @override
  Future<List<WatchlistItem>> removeWatchlistItem(String symbol) async {
    final normalizedSymbol = symbol.trim().toUpperCase();
    final watchlist = await _cacheDataSource.loadWatchlist();
    final updatedWatchlist =
        watchlist.where((item) => item.symbol != normalizedSymbol).toList()
          ..sort((left, right) => left.symbol.compareTo(right.symbol));
    await _cacheDataSource.saveWatchlist(updatedWatchlist);
    return updatedWatchlist.map((item) => item.toDomain()).toList();
  }

  Future<void> _saveSnapshot(PortfolioSnapshot snapshot) {
    return _cacheDataSource.savePortfolio(
      PortfolioSnapshotDto.fromDomain(snapshot),
    );
  }

  void _validateDraft(PortfolioTransactionDraft draft) {
    if (draft.symbol.trim().isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Symbol is required.',
      );
    }
    if (draft.assetName.trim().isEmpty) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Asset name is required.',
      );
    }
    _requirePositive(draft.amount, 'Amount must be greater than zero.');
    if (draft.type != PortfolioTransactionType.dividend) {
      final quantity = draft.quantity;
      if (quantity == null || quantity <= 0) {
        throw const AppError(
          type: AppErrorType.unknown,
          details: 'Quantity must be greater than zero.',
        );
      }
    }
  }

  List<Holding> _applyDraftToHoldings(
    List<Holding> holdings,
    PortfolioTransactionDraft draft,
  ) {
    if (draft.type == PortfolioTransactionType.dividend) {
      return holdings;
    }

    final updatedHoldings = [...holdings];
    final existingIndex = updatedHoldings.indexWhere(
      (holding) => holding.symbol == draft.symbol,
    );
    final transactionQuantity = draft.quantity!;
    final transactionUnitPrice = draft.amount / transactionQuantity;

    if (draft.type == PortfolioTransactionType.buy) {
      if (existingIndex == -1) {
        if ((draft.sector ?? '').trim().isEmpty) {
          throw const AppError(
            type: AppErrorType.unknown,
            details: 'Sector is required for a new holding.',
          );
        }
        updatedHoldings.add(
          Holding(
            symbol: draft.symbol.trim().toUpperCase(),
            name: draft.assetName.trim(),
            quantity: transactionQuantity,
            averageCost: transactionUnitPrice,
            currentPrice: transactionUnitPrice,
            sector: draft.sector!.trim(),
          ),
        );
        return updatedHoldings;
      }

      final holding = updatedHoldings[existingIndex];
      final newQuantity = holding.quantity + transactionQuantity;
      final newAverageCost =
          ((holding.averageCost * holding.quantity) + draft.amount) /
          newQuantity;
      updatedHoldings[existingIndex] = Holding(
        symbol: holding.symbol,
        name: draft.assetName.trim().isEmpty
            ? holding.name
            : draft.assetName.trim(),
        quantity: newQuantity,
        averageCost: newAverageCost,
        currentPrice: transactionUnitPrice,
        sector: (draft.sector ?? '').trim().isEmpty
            ? holding.sector
            : draft.sector!.trim(),
      );
      return updatedHoldings;
    }

    if (existingIndex == -1) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'You cannot sell a holding that is not in the portfolio.',
      );
    }

    final holding = updatedHoldings[existingIndex];
    if (holding.quantity < transactionQuantity) {
      throw const AppError(
        type: AppErrorType.unknown,
        details:
            'Sell quantity is greater than the available holding quantity.',
      );
    }

    final remainingQuantity = holding.quantity - transactionQuantity;
    if (remainingQuantity == 0) {
      updatedHoldings.removeAt(existingIndex);
      return updatedHoldings;
    }

    updatedHoldings[existingIndex] = Holding(
      symbol: holding.symbol,
      name: holding.name,
      quantity: remainingQuantity,
      averageCost: holding.averageCost,
      currentPrice: transactionUnitPrice,
      sector: holding.sector,
    );
    return updatedHoldings;
  }

  PortfolioOverview _rebuildOverview({
    required PortfolioOverview previous,
    required List<Holding> holdings,
    PortfolioTransactionDraft? transaction,
    double cashDelta = 0,
    double investedDelta = 0,
  }) {
    final nextCashBalance = previous.cashBalance + cashDelta;
    if (nextCashBalance < 0) {
      throw const AppError(
        type: AppErrorType.unknown,
        details: 'Not enough cash available for this transaction.',
      );
    }

    final nextTotalInvested = math
        .max(0, previous.totalInvested + investedDelta)
        .toDouble();
    final totalHoldingsValue = holdings.fold<double>(
      0,
      (sum, holding) => sum + holding.marketValue,
    );

    return PortfolioOverview(
      totalValue: totalHoldingsValue + nextCashBalance,
      totalInvested: nextTotalInvested,
      cashBalance: nextCashBalance,
      dayChange: previous.dayChange,
    );
  }

  PortfolioTransaction _toTransaction(PortfolioTransactionDraft draft) {
    return PortfolioTransaction(
      assetSymbol: draft.symbol.trim().toUpperCase(),
      assetName: draft.assetName.trim(),
      type: draft.type,
      amount: draft.amount,
      date: draft.date,
      quantity: draft.quantity,
    );
  }

  double _cashDeltaForTransaction(PortfolioTransactionDraft draft) {
    return switch (draft.type) {
      PortfolioTransactionType.buy => -draft.amount,
      PortfolioTransactionType.sell => draft.amount,
      PortfolioTransactionType.dividend => draft.amount,
    };
  }

  void _requirePositive(double value, String message) {
    if (value <= 0) {
      throw AppError(type: AppErrorType.unknown, details: message);
    }
  }
}
