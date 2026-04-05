import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_insights.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';

part 'portfolio_state.dart';

/// Presentation controller for the portfolio feature.
///
/// A junior-friendly way to read this class:
/// 1. UI asks the Cubit to load data.
/// 2. Cubit tells the UI it is loading.
/// 3. Cubit asks the repository for a portfolio snapshot.
/// 4. On success, Cubit emits ready-to-render state.
/// 5. On failure, Cubit reports the error and emits a user-safe error state.
class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit({
    required PortfolioRepository repository,
    AppErrorHandler? errorHandler,
  }) : _repository = repository,
       _errorHandler = errorHandler ?? AppErrorHandler(),
       super(const PortfolioState());

  final PortfolioRepository _repository;
  final AppErrorHandler _errorHandler;
  bool _isLoading = false;

  /// Loads the latest portfolio snapshot for the dashboard, holdings, and
  /// transactions screens.
  Future<void> loadPortfolio({bool forceRefresh = false}) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    // First tell the UI to show a loading state and clear any old error.
    emit(
      state.copyWith(
        status: state.status == PortfolioStatus.success && forceRefresh
            ? PortfolioStatus.success
            : PortfolioStatus.loading,
        isRefreshing: state.status == PortfolioStatus.success && forceRefresh,
        overviewStatus: state.status == PortfolioStatus.success && forceRefresh
            ? PortfolioSectionStatus.success
            : PortfolioSectionStatus.loading,
        holdingsStatus: state.status == PortfolioStatus.success && forceRefresh
            ? PortfolioSectionStatus.success
            : PortfolioSectionStatus.loading,
        transactionsStatus:
            state.status == PortfolioStatus.success && forceRefresh
            ? PortfolioSectionStatus.success
            : PortfolioSectionStatus.loading,
        clearError: true,
        clearOverviewError: true,
        clearHoldingsError: true,
        clearTransactionsError: true,
      ),
    );

    try {
      // The repository hides where the data comes from (mock API today, maybe
      // database or remote API later).
      final snapshot = await _repository.fetchPortfolio();
      final watchlist = await _repository.fetchWatchlist();

      // Emit a single success state with everything the UI needs to render.
      emit(
        state.copyWith(
          status: PortfolioStatus.success,
          overview: snapshot.overview,
          holdings: snapshot.holdings,
          transactions: snapshot.transactions,
          watchlist: watchlist,
          isRefreshing: false,
          overviewStatus: PortfolioSectionStatus.success,
          holdingsStatus: PortfolioSectionStatus.success,
          transactionsStatus: PortfolioSectionStatus.success,
          lastUpdatedAt: DateTime.now(),
          clearError: true,
          clearOverviewError: true,
          clearHoldingsError: true,
          clearTransactionsError: true,
        ),
      );
    } catch (error, stackTrace) {
      // Report the raw technical error for debugging/inspection.
      _errorHandler.report(error, stackTrace, reason: 'Portfolio load failed');

      // Convert the low-level exception into an app-specific error that the UI
      // can show safely.
      emit(
        state.copyWith(
          status: PortfolioStatus.failure,
          isRefreshing: false,
          overviewStatus: PortfolioSectionStatus.failure,
          holdingsStatus: PortfolioSectionStatus.failure,
          transactionsStatus: PortfolioSectionStatus.failure,
          error: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
          overviewError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
          holdingsError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
          transactionsError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
        ),
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refreshPortfolio() => loadPortfolio(forceRefresh: true);

  Future<AppError?> addTransaction(PortfolioTransactionDraft draft) async {
    try {
      final snapshot = await _repository.addTransaction(draft);
      _emitLoadedSnapshot(snapshot);
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Transaction save failed',
      );
    }
  }

  Future<AppError?> depositCash(double amount) async {
    try {
      final snapshot = await _repository.depositCash(amount);
      _emitLoadedSnapshot(snapshot);
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Cash deposit failed',
      );
    }
  }

  Future<AppError?> withdrawCash(double amount) async {
    try {
      final snapshot = await _repository.withdrawCash(amount);
      _emitLoadedSnapshot(snapshot);
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Cash withdrawal failed',
      );
    }
  }

  Future<({String? rawJson, AppError? error})> exportPortfolio() async {
    try {
      final rawJson = await _repository.exportPortfolio();
      return (rawJson: rawJson, error: null);
    } catch (error, stackTrace) {
      final appError = _handleMutationError(
        error,
        stackTrace,
        reason: 'Portfolio export failed',
      );
      return (rawJson: null, error: appError);
    }
  }

  Future<AppError?> importPortfolio(String rawJson) async {
    try {
      final snapshot = await _repository.importPortfolio(rawJson);
      _emitLoadedSnapshot(snapshot);
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Portfolio import failed',
      );
    }
  }

  Future<AppError?> addWatchlistItem(WatchlistItemDraft draft) async {
    try {
      final watchlist = await _repository.addWatchlistItem(draft);
      emit(state.copyWith(watchlist: watchlist));
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Watchlist add failed',
      );
    }
  }

  Future<AppError?> removeWatchlistItem(String symbol) async {
    try {
      final watchlist = await _repository.removeWatchlistItem(symbol);
      emit(state.copyWith(watchlist: watchlist));
      return null;
    } catch (error, stackTrace) {
      return _handleMutationError(
        error,
        stackTrace,
        reason: 'Watchlist remove failed',
      );
    }
  }

  Future<void> refreshOverview() async {
    emit(
      state.copyWith(
        overviewStatus: PortfolioSectionStatus.loading,
        clearOverviewError: true,
      ),
    );

    try {
      final overview = await _repository.fetchOverview();
      emit(
        state.copyWith(
          overview: overview,
          overviewStatus: PortfolioSectionStatus.success,
          lastUpdatedAt: DateTime.now(),
          clearOverviewError: true,
        ),
      );
    } catch (error, stackTrace) {
      _errorHandler.report(
        error,
        stackTrace,
        reason: 'Overview refresh failed',
      );
      emit(
        state.copyWith(
          overviewStatus: PortfolioSectionStatus.failure,
          overviewError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
        ),
      );
    }
  }

  Future<void> refreshHoldings() async {
    emit(
      state.copyWith(
        holdingsStatus: PortfolioSectionStatus.loading,
        clearHoldingsError: true,
      ),
    );

    try {
      final holdings = await _repository.fetchHoldings();
      emit(
        state.copyWith(
          holdings: holdings,
          holdingsStatus: PortfolioSectionStatus.success,
          lastUpdatedAt: DateTime.now(),
          clearHoldingsError: true,
        ),
      );
    } catch (error, stackTrace) {
      _errorHandler.report(
        error,
        stackTrace,
        reason: 'Holdings refresh failed',
      );
      emit(
        state.copyWith(
          holdingsStatus: PortfolioSectionStatus.failure,
          holdingsError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
        ),
      );
    }
  }

  Future<void> refreshTransactions() async {
    emit(
      state.copyWith(
        transactionsStatus: PortfolioSectionStatus.loading,
        clearTransactionsError: true,
      ),
    );

    try {
      final transactions = await _repository.fetchTransactions();
      emit(
        state.copyWith(
          transactions: transactions,
          transactionsStatus: PortfolioSectionStatus.success,
          lastUpdatedAt: DateTime.now(),
          clearTransactionsError: true,
        ),
      );
    } catch (error, stackTrace) {
      _errorHandler.report(
        error,
        stackTrace,
        reason: 'Transactions refresh failed',
      );
      emit(
        state.copyWith(
          transactionsStatus: PortfolioSectionStatus.failure,
          transactionsError: _errorHandler.toAppError(
            error,
            fallbackType: AppErrorType.portfolioLoad,
          ),
        ),
      );
    }
  }

  void updateHoldingsSearchQuery(String query) {
    emit(state.copyWith(holdingsSearchQuery: query));
  }

  void updateHoldingsSectorFilter(String? sector) {
    emit(
      state.copyWith(
        holdingsSectorFilter: sector,
        clearHoldingsSectorFilter: sector == null,
      ),
    );
  }

  void updateHoldingsSortOption(HoldingsSortOption sortOption) {
    emit(state.copyWith(holdingsSortOption: sortOption));
  }

  void updateTransactionsSearchQuery(String query) {
    emit(state.copyWith(transactionsSearchQuery: query));
  }

  void updateTransactionsTypeFilter(PortfolioTransactionType? type) {
    emit(
      state.copyWith(
        transactionsTypeFilter: type,
        clearTransactionsTypeFilter: type == null,
      ),
    );
  }

  void updateTransactionsYearFilter(TransactionYearFilter filter) {
    emit(state.copyWith(transactionsYearFilter: filter));
  }

  void _emitLoadedSnapshot(PortfolioSnapshot snapshot) {
    emit(
      state.copyWith(
        status: PortfolioStatus.success,
        overview: snapshot.overview,
        holdings: snapshot.holdings,
        transactions: snapshot.transactions,
        isRefreshing: false,
        overviewStatus: PortfolioSectionStatus.success,
        holdingsStatus: PortfolioSectionStatus.success,
        transactionsStatus: PortfolioSectionStatus.success,
        lastUpdatedAt: DateTime.now(),
        clearError: true,
        clearOverviewError: true,
        clearHoldingsError: true,
        clearTransactionsError: true,
      ),
    );
  }

  AppError _handleMutationError(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) {
    _errorHandler.report(error, stackTrace, reason: reason);
    final appError = _errorHandler.toAppError(error);
    emit(
      state.copyWith(
        error: appError,
        overviewError: appError,
        holdingsError: appError,
        transactionsError: appError,
      ),
    );
    return appError;
  }
}
