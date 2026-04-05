import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension PortfolioAppLocalizationsX on AppLocalizations {
  String formatCurrency(double value) {
    return NumberFormat.currency(
      locale: localeName,
      symbol: '\$',
      decimalDigits: 2,
    ).format(value);
  }

  String formatPercent(double value, {int decimalDigits = 0}) {
    final formatter = NumberFormat.percentPattern(localeName)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  String errorMessage(AppError error) {
    switch (error.type) {
      case AppErrorType.portfolioLoad:
        return portfolioLoadError;
      case AppErrorType.networkTimeout:
        return networkTimeoutError;
      case AppErrorType.networkConnection:
        return networkConnectionError;
      case AppErrorType.httpError:
        return httpError(error.statusCode?.toString() ?? unknownStatusCode);
      case AppErrorType.parseError:
        return parseError;
      case AppErrorType.routeNotFound:
        return routeNotFoundError(error.details ?? '');
      case AppErrorType.unknown:
        return genericError;
    }
  }

  String holdingSubtitle(String name, double quantity) {
    return holdingSubtitleTemplate(name, quantity.toStringAsFixed(0));
  }

  String transactionTitle(String symbol, String typeLabel) {
    return transactionTitleTemplate(symbol, typeLabel);
  }

  String transactionSubtitle(String assetName, DateTime date) {
    return transactionSubtitleTemplate(
      assetName,
      DateFormat.yMMMd(localeName).format(date),
    );
  }

  String unitsLabel(double quantity) {
    return unitsLabelTemplate(quantity.toStringAsFixed(0));
  }
}
