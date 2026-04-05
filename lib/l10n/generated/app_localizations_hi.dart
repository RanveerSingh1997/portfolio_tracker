// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'पोर्टफोलियो ट्रैकर';

  @override
  String get dashboardTitle => 'पोर्टफोलियो अवलोकन';

  @override
  String get holdingsTitle => 'होल्डिंग्स';

  @override
  String get transactionsTitle => 'लेन-देन';

  @override
  String get dashboardTab => 'डैशबोर्ड';

  @override
  String get holdingsTab => 'होल्डिंग्स';

  @override
  String get transactionsTab => 'लेन-देन';

  @override
  String get portfolioOverviewHeading => 'पोर्टफोलियो अवलोकन';

  @override
  String get portfolioOverviewSubtitle =>
      'अपनी कुल वैल्यू, लाभ और हाल की गतिविधियों को एक ही जगह ट्रैक करें।';

  @override
  String get totalValue => 'कुल वैल्यू';

  @override
  String get invested => 'निवेश';

  @override
  String get cashBalance => 'कैश बैलेंस';

  @override
  String get dayChange => 'आज का बदलाव';

  @override
  String get performance => 'प्रदर्शन';

  @override
  String get totalGainLoss => 'कुल लाभ/हानि';

  @override
  String get holdings => 'होल्डिंग्स';

  @override
  String get topHoldings => 'शीर्ष होल्डिंग्स';

  @override
  String get routeUnavailableTitle => 'यह स्क्रीन उपलब्ध नहीं है';

  @override
  String get backToPortfolio => 'पोर्टफोलियो पर वापस जाएं';

  @override
  String get buy => 'खरीद';

  @override
  String get sell => 'बेचें';

  @override
  String get dividend => 'डिविडेंड';

  @override
  String get allocationTitle => 'सेक्टर के अनुसार आवंटन';

  @override
  String get cashActionsTitle => 'कैश प्रबंधन';

  @override
  String get addTransactionAction => 'लेन-देन जोड़ें';

  @override
  String get depositCashAction => 'कैश जमा करें';

  @override
  String get withdrawCashAction => 'कैश निकालें';

  @override
  String get transactionFormTitle => 'मैन्युअल लेन-देन प्रविष्टि';

  @override
  String get transactionTypeLabel => 'लेन-देन प्रकार';

  @override
  String get symbolLabel => 'सिंबल';

  @override
  String get assetNameLabel => 'एसेट नाम';

  @override
  String get sectorLabel => 'सेक्टर';

  @override
  String get amountLabel => 'राशि';

  @override
  String get quantityLabel => 'मात्रा';

  @override
  String get selectDateLabel => 'लेन-देन की तारीख';

  @override
  String get saveAction => 'सहेजें';

  @override
  String get cancelAction => 'रद्द करें';

  @override
  String get searchHoldingsHint => 'सिंबल या नाम से होल्डिंग खोजें';

  @override
  String get searchTransactionsHint => 'सिंबल या एसेट नाम से लेन-देन खोजें';

  @override
  String get allSectorsLabel => 'सभी सेक्टर';

  @override
  String get sortByLabel => 'क्रमबद्ध करें';

  @override
  String get sortBySymbol => 'सिंबल';

  @override
  String get sortByMarketValue => 'मार्केट वैल्यू';

  @override
  String get sortByProfitLoss => 'लाभ/हानि';

  @override
  String get noHoldingsMatchFilters =>
      'वर्तमान फ़िल्टर से कोई होल्डिंग मेल नहीं खाती।';

  @override
  String get transactionFilterLabel => 'लेन-देन प्रकार फ़िल्टर';

  @override
  String get allTransactionTypesLabel => 'सभी लेन-देन प्रकार';

  @override
  String get allYearsLabel => 'सभी वर्ष';

  @override
  String get currentYearOnlyLabel => 'यह वर्ष';

  @override
  String get noTransactionsMatchFilters =>
      'वर्तमान फ़िल्टर से कोई लेन-देन मेल नहीं खाता।';

  @override
  String get analyticsTitle => 'विश्लेषण';

  @override
  String get bestPerformerLabel => 'सर्वश्रेष्ठ प्रदर्शन';

  @override
  String get biggestPositionLabel => 'सबसे बड़ी पोज़िशन';

  @override
  String get cashAllocationLabel => 'कैश आवंटन';

  @override
  String get sectorDiversificationLabel => 'सेक्टर विविधीकरण';

  @override
  String taxSummaryTitle(Object year) {
    return 'टैक्स सारांश $year';
  }

  @override
  String get dividendIncomeLabel => 'डिविडेंड आय';

  @override
  String get sellProceedsLabel => 'बिक्री प्राप्ति';

  @override
  String get estimatedRealizedGainLabel => 'अनुमानित realized gain';

  @override
  String get taxableEventsLabel => 'कर योग्य घटनाएं';

  @override
  String get noTaxEventsLabel =>
      'इस वर्ष के लिए कोई कर योग्य घटना दर्ज नहीं है।';

  @override
  String get portfolioDataTitle => 'पोर्टफोलियो डेटा';

  @override
  String get exportPortfolioAction => 'JSON एक्सपोर्ट करें';

  @override
  String get importPortfolioAction => 'JSON इम्पोर्ट करें';

  @override
  String get exportPortfolioTitle => 'पोर्टफोलियो डेटा एक्सपोर्ट करें';

  @override
  String get importPortfolioTitle => 'पोर्टफोलियो डेटा इम्पोर्ट करें';

  @override
  String get copyJsonAction => 'JSON कॉपी करें';

  @override
  String get importPortfolioHint =>
      'पहले एक्सपोर्ट किया गया पोर्टफोलियो JSON यहां पेस्ट करें।';

  @override
  String get portfolioCopiedMessage =>
      'पोर्टफोलियो JSON क्लिपबोर्ड पर कॉपी हो गया।';

  @override
  String get portfolioImportedMessage =>
      'पोर्टफोलियो डेटा सफलतापूर्वक इम्पोर्ट हो गया।';

  @override
  String get watchlistTitle => 'वॉचलिस्ट';

  @override
  String get addWatchlistAction => 'सिंबल जोड़ें';

  @override
  String get watchlistFormTitle => 'वॉचलिस्ट आइटम जोड़ें';

  @override
  String get targetPriceLabel => 'लक्ष्य मूल्य';

  @override
  String get noteLabel => 'नोट';

  @override
  String get noWatchlistItems => 'अभी कोई वॉचलिस्ट आइटम नहीं है।';

  @override
  String get removeWatchlistAction => 'वॉचलिस्ट से हटाएं';

  @override
  String get dividendTrackingTitle => 'डिविडेंड ट्रैकिंग';

  @override
  String get yearToDateIncomeLabel => 'वर्ष-से-अब तक की आय';

  @override
  String get trailingIncomeLabel => 'पिछले 12 महीने';

  @override
  String get topIncomeSymbolLabel => 'सबसे अधिक आय वाला सिंबल';

  @override
  String get dividendEventsLabel => 'डिविडेंड घटनाएं';

  @override
  String get noDividendEventsLabel => 'अभी तक कोई डिविडेंड घटना दर्ज नहीं है।';

  @override
  String get recentDividendsLabel => 'हाल के डिविडेंड';

  @override
  String get topSectorLabel => 'शीर्ष सेक्टर';

  @override
  String get dividendRunRateLabel => 'डिविडेंड रन रेट';

  @override
  String get requiredFieldError => 'यह फ़ील्ड आवश्यक है।';

  @override
  String get positiveNumberError => 'शून्य से अधिक मान दर्ज करें।';

  @override
  String get portfolioLoadError => 'पोर्टफोलियो डेटा लोड नहीं हो सका।';

  @override
  String get networkTimeoutError =>
      'अनुरोध का समय समाप्त हो गया। कृपया फिर से प्रयास करें।';

  @override
  String get networkConnectionError =>
      'अभी कनेक्ट नहीं हो सका। अपना कनेक्शन जांचें और फिर प्रयास करें।';

  @override
  String httpError(Object statusCode) {
    return 'सर्वर ने त्रुटि लौटाई ($statusCode)।';
  }

  @override
  String get unknownStatusCode => 'अज्ञात';

  @override
  String get parseError => 'ऐप को अप्रत्याशित प्रारूप में डेटा मिला।';

  @override
  String get genericError => 'कुछ गलत हो गया। कृपया फिर से प्रयास करें।';

  @override
  String routeNotFoundError(Object route) {
    return 'रूट \"$route\" नहीं खुल सका।';
  }

  @override
  String holdingSubtitleTemplate(Object name, Object quantity) {
    return '$name • $quantity शेयर';
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
    return '$quantity यूनिट';
  }
}
