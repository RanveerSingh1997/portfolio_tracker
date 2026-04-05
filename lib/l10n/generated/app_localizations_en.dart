// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Portfolio Tracker';

  @override
  String get dashboardTitle => 'Portfolio Overview';

  @override
  String get holdingsTitle => 'Holdings';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get dashboardTab => 'Dashboard';

  @override
  String get holdingsTab => 'Holdings';

  @override
  String get transactionsTab => 'Transactions';

  @override
  String get portfolioOverviewHeading => 'Portfolio Overview';

  @override
  String get portfolioOverviewSubtitle =>
      'Track your current value, gains, and recent activity from one place.';

  @override
  String get totalValue => 'Total Value';

  @override
  String get invested => 'Invested';

  @override
  String get cashBalance => 'Cash Balance';

  @override
  String get dayChange => 'Day Change';

  @override
  String get performance => 'Performance';

  @override
  String get totalGainLoss => 'Total Gain/Loss';

  @override
  String get holdings => 'Holdings';

  @override
  String get topHoldings => 'Top Holdings';

  @override
  String get routeUnavailableTitle => 'This screen is unavailable';

  @override
  String get backToPortfolio => 'Back to portfolio';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get dividend => 'Dividend';

  @override
  String get allocationTitle => 'Allocation by sector';

  @override
  String get cashActionsTitle => 'Cash management';

  @override
  String get addTransactionAction => 'Add transaction';

  @override
  String get depositCashAction => 'Deposit cash';

  @override
  String get withdrawCashAction => 'Withdraw cash';

  @override
  String get transactionFormTitle => 'Manual transaction entry';

  @override
  String get transactionTypeLabel => 'Transaction type';

  @override
  String get symbolLabel => 'Symbol';

  @override
  String get assetNameLabel => 'Asset name';

  @override
  String get sectorLabel => 'Sector';

  @override
  String get amountLabel => 'Amount';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get selectDateLabel => 'Transaction date';

  @override
  String get saveAction => 'Save';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get searchHoldingsHint => 'Search holdings by symbol or name';

  @override
  String get searchTransactionsHint =>
      'Search transactions by symbol or asset name';

  @override
  String get allSectorsLabel => 'All sectors';

  @override
  String get sortByLabel => 'Sort by';

  @override
  String get sortBySymbol => 'Symbol';

  @override
  String get sortByMarketValue => 'Market value';

  @override
  String get sortByProfitLoss => 'Gain/Loss';

  @override
  String get noHoldingsMatchFilters => 'No holdings match the current filters.';

  @override
  String get transactionFilterLabel => 'Transaction type filter';

  @override
  String get allTransactionTypesLabel => 'All transaction types';

  @override
  String get allYearsLabel => 'All years';

  @override
  String get currentYearOnlyLabel => 'This year';

  @override
  String get noTransactionsMatchFilters =>
      'No transactions match the current filters.';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get bestPerformerLabel => 'Best performer';

  @override
  String get biggestPositionLabel => 'Biggest position';

  @override
  String get cashAllocationLabel => 'Cash allocation';

  @override
  String get sectorDiversificationLabel => 'Sector diversification';

  @override
  String taxSummaryTitle(Object year) {
    return 'Tax summary $year';
  }

  @override
  String get dividendIncomeLabel => 'Dividend income';

  @override
  String get sellProceedsLabel => 'Sell proceeds';

  @override
  String get estimatedRealizedGainLabel => 'Estimated realized gain';

  @override
  String get taxableEventsLabel => 'Taxable events';

  @override
  String get noTaxEventsLabel => 'No taxable events recorded for this year.';

  @override
  String get portfolioDataTitle => 'Portfolio data';

  @override
  String get exportPortfolioAction => 'Export JSON';

  @override
  String get importPortfolioAction => 'Import JSON';

  @override
  String get exportPortfolioTitle => 'Export portfolio data';

  @override
  String get importPortfolioTitle => 'Import portfolio data';

  @override
  String get copyJsonAction => 'Copy JSON';

  @override
  String get importPortfolioHint =>
      'Paste a previously exported portfolio JSON snapshot.';

  @override
  String get portfolioCopiedMessage => 'Portfolio JSON copied to clipboard.';

  @override
  String get portfolioImportedMessage =>
      'Portfolio data imported successfully.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get addWatchlistAction => 'Add symbol';

  @override
  String get watchlistFormTitle => 'Add watchlist item';

  @override
  String get targetPriceLabel => 'Target price';

  @override
  String get noteLabel => 'Note';

  @override
  String get noWatchlistItems => 'No watchlist items yet.';

  @override
  String get removeWatchlistAction => 'Remove from watchlist';

  @override
  String get dividendTrackingTitle => 'Dividend tracking';

  @override
  String get yearToDateIncomeLabel => 'Year-to-date income';

  @override
  String get trailingIncomeLabel => 'Trailing 12 months';

  @override
  String get topIncomeSymbolLabel => 'Top income symbol';

  @override
  String get dividendEventsLabel => 'Dividend events';

  @override
  String get noDividendEventsLabel => 'No dividend events recorded yet.';

  @override
  String get recentDividendsLabel => 'Recent dividends';

  @override
  String get topSectorLabel => 'Top sector';

  @override
  String get dividendRunRateLabel => 'Dividend run rate';

  @override
  String get requiredFieldError => 'This field is required.';

  @override
  String get positiveNumberError => 'Enter a value greater than zero.';

  @override
  String get portfolioLoadError => 'Unable to load portfolio data.';

  @override
  String get networkTimeoutError => 'The request timed out. Please try again.';

  @override
  String get networkConnectionError =>
      'Unable to connect right now. Check your connection and try again.';

  @override
  String httpError(Object statusCode) {
    return 'The server returned an error ($statusCode).';
  }

  @override
  String get unknownStatusCode => 'unknown';

  @override
  String get parseError => 'The app received data in an unexpected format.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String routeNotFoundError(Object route) {
    return 'The route \"$route\" could not be opened.';
  }

  @override
  String holdingSubtitleTemplate(Object name, Object quantity) {
    return '$name • $quantity shares';
  }

  @override
  String transactionTitleTemplate(Object symbol, Object typeLabel) {
    return '$symbol • $typeLabel';
  }

  @override
  String transactionSubtitleTemplate(Object assetName, Object formattedDate) {
    return '$assetName • $formattedDate';
  }

  @override
  String unitsLabelTemplate(Object quantity) {
    return '$quantity units';
  }
}
