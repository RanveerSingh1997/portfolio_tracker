import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Tracker'**
  String get appTitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Overview'**
  String get dashboardTitle;

  /// No description provided for @holdingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdingsTitle;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @dashboardTab.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTab;

  /// No description provided for @holdingsTab.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdingsTab;

  /// No description provided for @transactionsTab.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTab;

  /// No description provided for @portfolioOverviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Overview'**
  String get portfolioOverviewHeading;

  /// No description provided for @portfolioOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your current value, gains, and recent activity from one place.'**
  String get portfolioOverviewSubtitle;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get totalValue;

  /// No description provided for @invested.
  ///
  /// In en, this message translates to:
  /// **'Invested'**
  String get invested;

  /// No description provided for @cashBalance.
  ///
  /// In en, this message translates to:
  /// **'Cash Balance'**
  String get cashBalance;

  /// No description provided for @dayChange.
  ///
  /// In en, this message translates to:
  /// **'Day Change'**
  String get dayChange;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @totalGainLoss.
  ///
  /// In en, this message translates to:
  /// **'Total Gain/Loss'**
  String get totalGainLoss;

  /// No description provided for @holdings.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdings;

  /// No description provided for @topHoldings.
  ///
  /// In en, this message translates to:
  /// **'Top Holdings'**
  String get topHoldings;

  /// No description provided for @routeUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'This screen is unavailable'**
  String get routeUnavailableTitle;

  /// No description provided for @backToPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Back to portfolio'**
  String get backToPortfolio;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @dividend.
  ///
  /// In en, this message translates to:
  /// **'Dividend'**
  String get dividend;

  /// No description provided for @allocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocation by sector'**
  String get allocationTitle;

  /// No description provided for @cashActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash management'**
  String get cashActionsTitle;

  /// No description provided for @addTransactionAction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransactionAction;

  /// No description provided for @depositCashAction.
  ///
  /// In en, this message translates to:
  /// **'Deposit cash'**
  String get depositCashAction;

  /// No description provided for @withdrawCashAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw cash'**
  String get withdrawCashAction;

  /// No description provided for @transactionFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual transaction entry'**
  String get transactionFormTitle;

  /// No description provided for @transactionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction type'**
  String get transactionTypeLabel;

  /// No description provided for @symbolLabel.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get symbolLabel;

  /// No description provided for @assetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Asset name'**
  String get assetNameLabel;

  /// No description provided for @sectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Sector'**
  String get sectorLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @selectDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get selectDateLabel;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @searchHoldingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search holdings by symbol or name'**
  String get searchHoldingsHint;

  /// No description provided for @searchTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions by symbol or asset name'**
  String get searchTransactionsHint;

  /// No description provided for @allSectorsLabel.
  ///
  /// In en, this message translates to:
  /// **'All sectors'**
  String get allSectorsLabel;

  /// No description provided for @sortByLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortByLabel;

  /// No description provided for @sortBySymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get sortBySymbol;

  /// No description provided for @sortByMarketValue.
  ///
  /// In en, this message translates to:
  /// **'Market value'**
  String get sortByMarketValue;

  /// No description provided for @sortByProfitLoss.
  ///
  /// In en, this message translates to:
  /// **'Gain/Loss'**
  String get sortByProfitLoss;

  /// No description provided for @noHoldingsMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No holdings match the current filters.'**
  String get noHoldingsMatchFilters;

  /// No description provided for @transactionFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction type filter'**
  String get transactionFilterLabel;

  /// No description provided for @allTransactionTypesLabel.
  ///
  /// In en, this message translates to:
  /// **'All transaction types'**
  String get allTransactionTypesLabel;

  /// No description provided for @allYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get allYearsLabel;

  /// No description provided for @currentYearOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get currentYearOnlyLabel;

  /// No description provided for @noTransactionsMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No transactions match the current filters.'**
  String get noTransactionsMatchFilters;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @bestPerformerLabel.
  ///
  /// In en, this message translates to:
  /// **'Best performer'**
  String get bestPerformerLabel;

  /// No description provided for @biggestPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Biggest position'**
  String get biggestPositionLabel;

  /// No description provided for @cashAllocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash allocation'**
  String get cashAllocationLabel;

  /// No description provided for @sectorDiversificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Sector diversification'**
  String get sectorDiversificationLabel;

  /// No description provided for @taxSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax summary {year}'**
  String taxSummaryTitle(Object year);

  /// No description provided for @dividendIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dividend income'**
  String get dividendIncomeLabel;

  /// No description provided for @sellProceedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sell proceeds'**
  String get sellProceedsLabel;

  /// No description provided for @estimatedRealizedGainLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated realized gain'**
  String get estimatedRealizedGainLabel;

  /// No description provided for @taxableEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Taxable events'**
  String get taxableEventsLabel;

  /// No description provided for @noTaxEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'No taxable events recorded for this year.'**
  String get noTaxEventsLabel;

  /// No description provided for @portfolioDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio data'**
  String get portfolioDataTitle;

  /// No description provided for @exportPortfolioAction.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportPortfolioAction;

  /// No description provided for @importPortfolioAction.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get importPortfolioAction;

  /// No description provided for @exportPortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Export portfolio data'**
  String get exportPortfolioTitle;

  /// No description provided for @importPortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Import portfolio data'**
  String get importPortfolioTitle;

  /// No description provided for @copyJsonAction.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON'**
  String get copyJsonAction;

  /// No description provided for @importPortfolioHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a previously exported portfolio JSON snapshot.'**
  String get importPortfolioHint;

  /// No description provided for @portfolioCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Portfolio JSON copied to clipboard.'**
  String get portfolioCopiedMessage;

  /// No description provided for @portfolioImportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Portfolio data imported successfully.'**
  String get portfolioImportedMessage;

  /// No description provided for @watchlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlistTitle;

  /// No description provided for @addWatchlistAction.
  ///
  /// In en, this message translates to:
  /// **'Add symbol'**
  String get addWatchlistAction;

  /// No description provided for @watchlistFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Add watchlist item'**
  String get watchlistFormTitle;

  /// No description provided for @targetPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Target price'**
  String get targetPriceLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @noWatchlistItems.
  ///
  /// In en, this message translates to:
  /// **'No watchlist items yet.'**
  String get noWatchlistItems;

  /// No description provided for @removeWatchlistAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from watchlist'**
  String get removeWatchlistAction;

  /// No description provided for @dividendTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Dividend tracking'**
  String get dividendTrackingTitle;

  /// No description provided for @yearToDateIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Year-to-date income'**
  String get yearToDateIncomeLabel;

  /// No description provided for @trailingIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Trailing 12 months'**
  String get trailingIncomeLabel;

  /// No description provided for @topIncomeSymbolLabel.
  ///
  /// In en, this message translates to:
  /// **'Top income symbol'**
  String get topIncomeSymbolLabel;

  /// No description provided for @dividendEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Dividend events'**
  String get dividendEventsLabel;

  /// No description provided for @noDividendEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'No dividend events recorded yet.'**
  String get noDividendEventsLabel;

  /// No description provided for @recentDividendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent dividends'**
  String get recentDividendsLabel;

  /// No description provided for @topSectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Top sector'**
  String get topSectorLabel;

  /// No description provided for @dividendRunRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Dividend run rate'**
  String get dividendRunRateLabel;

  /// No description provided for @requiredFieldError.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredFieldError;

  /// No description provided for @positiveNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a value greater than zero.'**
  String get positiveNumberError;

  /// No description provided for @portfolioLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load portfolio data.'**
  String get portfolioLoadError;

  /// No description provided for @networkTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again.'**
  String get networkTimeoutError;

  /// No description provided for @networkConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect right now. Check your connection and try again.'**
  String get networkConnectionError;

  /// No description provided for @httpError.
  ///
  /// In en, this message translates to:
  /// **'The server returned an error ({statusCode}).'**
  String httpError(Object statusCode);

  /// No description provided for @unknownStatusCode.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get unknownStatusCode;

  /// No description provided for @parseError.
  ///
  /// In en, this message translates to:
  /// **'The app received data in an unexpected format.'**
  String get parseError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @routeNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'The route \"{route}\" could not be opened.'**
  String routeNotFoundError(Object route);

  /// No description provided for @holdingSubtitleTemplate.
  ///
  /// In en, this message translates to:
  /// **'{name} • {quantity} shares'**
  String holdingSubtitleTemplate(Object name, Object quantity);

  /// No description provided for @transactionTitleTemplate.
  ///
  /// In en, this message translates to:
  /// **'{symbol} • {typeLabel}'**
  String transactionTitleTemplate(Object symbol, Object typeLabel);

  /// No description provided for @transactionSubtitleTemplate.
  ///
  /// In en, this message translates to:
  /// **'{assetName} • {formattedDate}'**
  String transactionSubtitleTemplate(Object assetName, Object formattedDate);

  /// No description provided for @unitsLabelTemplate.
  ///
  /// In en, this message translates to:
  /// **'{quantity} units'**
  String unitsLabelTemplate(Object quantity);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
