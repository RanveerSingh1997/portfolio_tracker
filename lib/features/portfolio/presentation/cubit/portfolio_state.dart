part of 'portfolio_cubit.dart';

enum PortfolioStatus { initial, loading, success, failure }

enum PortfolioSectionStatus { initial, loading, success, failure }

enum HoldingsSortOption { symbol, marketValue, profitLoss }

enum TransactionYearFilter { all, currentYear }

class PortfolioState extends Equatable {
  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.isRefreshing = false,
    this.overviewStatus = PortfolioSectionStatus.initial,
    this.holdingsStatus = PortfolioSectionStatus.initial,
    this.transactionsStatus = PortfolioSectionStatus.initial,
    this.overview,
    this.holdings = const [],
    this.transactions = const [],
    this.watchlist = const [],
    this.error,
    this.overviewError,
    this.holdingsError,
    this.transactionsError,
    this.lastUpdatedAt,
    this.holdingsSearchQuery = '',
    this.holdingsSectorFilter,
    this.holdingsSortOption = HoldingsSortOption.marketValue,
    this.transactionsSearchQuery = '',
    this.transactionsTypeFilter,
    this.transactionsYearFilter = TransactionYearFilter.all,
  });

  final PortfolioStatus status;
  final bool isRefreshing;
  final PortfolioSectionStatus overviewStatus;
  final PortfolioSectionStatus holdingsStatus;
  final PortfolioSectionStatus transactionsStatus;
  final PortfolioOverview? overview;
  final List<Holding> holdings;
  final List<PortfolioTransaction> transactions;
  final List<WatchlistItem> watchlist;
  final AppError? error;
  final AppError? overviewError;
  final AppError? holdingsError;
  final AppError? transactionsError;
  final DateTime? lastUpdatedAt;
  final String holdingsSearchQuery;
  final String? holdingsSectorFilter;
  final HoldingsSortOption holdingsSortOption;
  final String transactionsSearchQuery;
  final PortfolioTransactionType? transactionsTypeFilter;
  final TransactionYearFilter transactionsYearFilter;

  PortfolioState copyWith({
    PortfolioStatus? status,
    bool? isRefreshing,
    PortfolioSectionStatus? overviewStatus,
    PortfolioSectionStatus? holdingsStatus,
    PortfolioSectionStatus? transactionsStatus,
    PortfolioOverview? overview,
    List<Holding>? holdings,
    List<PortfolioTransaction>? transactions,
    List<WatchlistItem>? watchlist,
    AppError? error,
    AppError? overviewError,
    AppError? holdingsError,
    AppError? transactionsError,
    DateTime? lastUpdatedAt,
    String? holdingsSearchQuery,
    String? holdingsSectorFilter,
    HoldingsSortOption? holdingsSortOption,
    String? transactionsSearchQuery,
    PortfolioTransactionType? transactionsTypeFilter,
    TransactionYearFilter? transactionsYearFilter,
    bool clearLastUpdatedAt = false,
    bool clearError = false,
    bool clearOverviewError = false,
    bool clearHoldingsError = false,
    bool clearTransactionsError = false,
    bool clearHoldingsSectorFilter = false,
    bool clearTransactionsTypeFilter = false,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      overviewStatus: overviewStatus ?? this.overviewStatus,
      holdingsStatus: holdingsStatus ?? this.holdingsStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      overview: overview ?? this.overview,
      holdings: holdings ?? this.holdings,
      transactions: transactions ?? this.transactions,
      watchlist: watchlist ?? this.watchlist,
      error: clearError ? null : error ?? this.error,
      overviewError: clearOverviewError
          ? null
          : overviewError ?? this.overviewError,
      holdingsError: clearHoldingsError
          ? null
          : holdingsError ?? this.holdingsError,
      transactionsError: clearTransactionsError
          ? null
          : transactionsError ?? this.transactionsError,
      lastUpdatedAt: clearLastUpdatedAt
          ? null
          : lastUpdatedAt ?? this.lastUpdatedAt,
      holdingsSearchQuery: holdingsSearchQuery ?? this.holdingsSearchQuery,
      holdingsSectorFilter: clearHoldingsSectorFilter
          ? null
          : holdingsSectorFilter ?? this.holdingsSectorFilter,
      holdingsSortOption: holdingsSortOption ?? this.holdingsSortOption,
      transactionsSearchQuery:
          transactionsSearchQuery ?? this.transactionsSearchQuery,
      transactionsTypeFilter: clearTransactionsTypeFilter
          ? null
          : transactionsTypeFilter ?? this.transactionsTypeFilter,
      transactionsYearFilter:
          transactionsYearFilter ?? this.transactionsYearFilter,
    );
  }

  List<String> get availableHoldingSectors {
    final sectors = holdings.map((holding) => holding.sector).toSet().toList()
      ..sort();
    return sectors;
  }

  List<Holding> get visibleHoldings {
    final normalizedQuery = holdingsSearchQuery.trim().toLowerCase();

    final filtered = holdings.where((holding) {
      final matchesSector = holdingsSectorFilter == null
          ? true
          : holding.sector == holdingsSectorFilter;
      final matchesQuery = normalizedQuery.isEmpty
          ? true
          : holding.symbol.toLowerCase().contains(normalizedQuery) ||
                holding.name.toLowerCase().contains(normalizedQuery);
      return matchesSector && matchesQuery;
    }).toList();

    filtered.sort((left, right) {
      return switch (holdingsSortOption) {
        HoldingsSortOption.symbol => left.symbol.compareTo(right.symbol),
        HoldingsSortOption.marketValue => right.marketValue.compareTo(
          left.marketValue,
        ),
        HoldingsSortOption.profitLoss => right.profitLoss.compareTo(
          left.profitLoss,
        ),
      };
    });

    return filtered;
  }

  List<PortfolioTransaction> get visibleTransactions {
    final normalizedQuery = transactionsSearchQuery.trim().toLowerCase();
    final currentYear = DateTime.now().year;

    final filtered = transactions.where((transaction) {
      final matchesQuery = normalizedQuery.isEmpty
          ? true
          : transaction.assetSymbol.toLowerCase().contains(normalizedQuery) ||
                transaction.assetName.toLowerCase().contains(normalizedQuery);
      final matchesType = transactionsTypeFilter == null
          ? true
          : transaction.type == transactionsTypeFilter;
      final matchesYear = transactionsYearFilter == TransactionYearFilter.all
          ? true
          : transaction.date.year == currentYear;

      return matchesQuery && matchesType && matchesYear;
    }).toList()..sort((left, right) => right.date.compareTo(left.date));

    return filtered;
  }

  PortfolioSnapshot? get snapshot {
    final resolvedOverview = overview;
    if (resolvedOverview == null) {
      return null;
    }

    return PortfolioSnapshot(
      overview: resolvedOverview,
      holdings: holdings,
      transactions: transactions,
    );
  }

  PortfolioPerformanceAnalytics? get performanceAnalytics {
    final resolvedSnapshot = snapshot;
    if (resolvedSnapshot == null) {
      return null;
    }

    return PortfolioPerformanceAnalytics.fromSnapshot(resolvedSnapshot);
  }

  PortfolioTaxSummary? currentYearTaxSummary({DateTime? now}) {
    final resolvedSnapshot = snapshot;
    if (resolvedSnapshot == null) {
      return null;
    }

    return PortfolioTaxSummary.fromSnapshot(
      resolvedSnapshot,
      taxYear: (now ?? DateTime.now()).year,
    );
  }

  PortfolioDividendSummary? dividendSummary({DateTime? now}) {
    final resolvedSnapshot = snapshot;
    if (resolvedSnapshot == null) {
      return null;
    }

    return PortfolioDividendSummary.fromSnapshot(resolvedSnapshot, now: now);
  }

  @override
  List<Object?> get props => [
    status,
    isRefreshing,
    overviewStatus,
    holdingsStatus,
    transactionsStatus,
    overview,
    holdings,
    transactions,
    watchlist,
    error,
    overviewError,
    holdingsError,
    transactionsError,
    lastUpdatedAt,
    holdingsSearchQuery,
    holdingsSectorFilter,
    holdingsSortOption,
    transactionsSearchQuery,
    transactionsTypeFilter,
    transactionsYearFilter,
  ];
}
