import 'package:equatable/equatable.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

/// Derived analytics used by the dashboard to summarize portfolio health.
///
/// This keeps summary math out of widgets so UI code can stay focused on layout
/// and interaction rather than domain calculations.
class PortfolioPerformanceAnalytics extends Equatable {
  const PortfolioPerformanceAnalytics({
    required this.bestPerformer,
    required this.worstPerformer,
    required this.biggestPosition,
    required this.holdingsValue,
    required this.cashAllocationRatio,
    required this.investedAllocationRatio,
    required this.sectorCount,
    required this.positionCount,
    required this.largestSector,
    required this.largestSectorWeight,
    required this.trailingTwelveMonthsDividendIncome,
  });

  final Holding? bestPerformer;
  final Holding? worstPerformer;
  final Holding? biggestPosition;
  final double holdingsValue;
  final double cashAllocationRatio;
  final double investedAllocationRatio;
  final int sectorCount;
  final int positionCount;
  final String? largestSector;
  final double largestSectorWeight;
  final double trailingTwelveMonthsDividendIncome;

  /// Builds performance insights from the current snapshot state.
  factory PortfolioPerformanceAnalytics.fromSnapshot(
    PortfolioSnapshot snapshot, {
    DateTime? now,
  }) {
    final holdings = snapshot.holdings;
    final holdingsValue = holdings.fold<double>(
      0,
      (sum, holding) => sum + holding.marketValue,
    );
    final totalValue = snapshot.overview.totalValue;
    final sectorTotals = <String, double>{};
    final resolvedNow = now ?? DateTime.now();
    final trailingStart = resolvedNow.subtract(const Duration(days: 365));

    Holding? bestPerformer;
    Holding? worstPerformer;
    Holding? biggestPosition;

    for (final holding in holdings) {
      // We calculate the same pass once so analytics stay cheap even when the
      // dashboard rebuilds frequently.
      if (bestPerformer == null ||
          holding.profitLoss > bestPerformer.profitLoss) {
        bestPerformer = holding;
      }
      if (worstPerformer == null ||
          holding.profitLoss < worstPerformer.profitLoss) {
        worstPerformer = holding;
      }
      if (biggestPosition == null ||
          holding.marketValue > biggestPosition.marketValue) {
        biggestPosition = holding;
      }
      sectorTotals.update(
        holding.sector,
        (value) => value + holding.marketValue,
        ifAbsent: () => holding.marketValue,
      );
    }

    String? largestSector;
    var largestSectorValue = 0.0;
    for (final entry in sectorTotals.entries) {
      if (entry.value > largestSectorValue) {
        largestSector = entry.key;
        largestSectorValue = entry.value;
      }
    }

    final trailingDividendIncome = snapshot.transactions
        .where(
          (transaction) =>
              transaction.type == PortfolioTransactionType.dividend &&
              transaction.date.isAfter(trailingStart),
        )
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    return PortfolioPerformanceAnalytics(
      bestPerformer: bestPerformer,
      worstPerformer: worstPerformer,
      biggestPosition: biggestPosition,
      holdingsValue: holdingsValue,
      cashAllocationRatio: totalValue == 0
          ? 0
          : snapshot.overview.cashBalance / totalValue,
      investedAllocationRatio: totalValue == 0 ? 0 : holdingsValue / totalValue,
      sectorCount: holdings.map((holding) => holding.sector).toSet().length,
      positionCount: holdings.length,
      largestSector: largestSector,
      largestSectorWeight: holdingsValue == 0
          ? 0
          : largestSectorValue / holdingsValue,
      trailingTwelveMonthsDividendIncome: trailingDividendIncome,
    );
  }

  @override
  List<Object?> get props => [
    bestPerformer,
    worstPerformer,
    biggestPosition,
    holdingsValue,
    cashAllocationRatio,
    investedAllocationRatio,
    sectorCount,
    positionCount,
    largestSector,
    largestSectorWeight,
    trailingTwelveMonthsDividendIncome,
  ];
}

class PortfolioDividendSummary extends Equatable {
  const PortfolioDividendSummary({
    required this.currentYearIncome,
    required this.trailingTwelveMonthsIncome,
    required this.recentDividends,
    required this.topIncomeSymbol,
    required this.dividendEventCount,
  });

  final double currentYearIncome;
  final double trailingTwelveMonthsIncome;
  final List<PortfolioTransaction> recentDividends;
  final String? topIncomeSymbol;
  final int dividendEventCount;

  bool get hasDividends => dividendEventCount > 0;

  /// Builds dividend-focused insights from the transaction stream.
  ///
  /// Dividend tracking is derived rather than stored so it always stays in sync
  /// with imported data, manual entries, and future server-backed payloads.
  factory PortfolioDividendSummary.fromSnapshot(
    PortfolioSnapshot snapshot, {
    DateTime? now,
  }) {
    final resolvedNow = now ?? DateTime.now();
    final year = resolvedNow.year;
    final trailingStart = resolvedNow.subtract(const Duration(days: 365));
    final dividends =
        snapshot.transactions
            .where(
              (transaction) =>
                  transaction.type == PortfolioTransactionType.dividend,
            )
            .toList()
          ..sort((left, right) => right.date.compareTo(left.date));
    final incomeBySymbol = <String, double>{};

    final currentYearIncome = dividends
        .where((transaction) => transaction.date.year == year)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
    final trailingIncome = dividends
        .where((transaction) => transaction.date.isAfter(trailingStart))
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    for (final dividend in dividends) {
      incomeBySymbol.update(
        dividend.assetSymbol,
        (value) => value + dividend.amount,
        ifAbsent: () => dividend.amount,
      );
    }

    String? topIncomeSymbol;
    var topIncomeAmount = 0.0;
    for (final entry in incomeBySymbol.entries) {
      if (entry.value > topIncomeAmount) {
        topIncomeSymbol = entry.key;
        topIncomeAmount = entry.value;
      }
    }

    return PortfolioDividendSummary(
      currentYearIncome: currentYearIncome,
      trailingTwelveMonthsIncome: trailingIncome,
      recentDividends: dividends.take(3).toList(),
      topIncomeSymbol: topIncomeSymbol,
      dividendEventCount: dividends.length,
    );
  }

  @override
  List<Object?> get props => [
    currentYearIncome,
    trailingTwelveMonthsIncome,
    recentDividends,
    topIncomeSymbol,
    dividendEventCount,
  ];
}

class PortfolioTaxSummary extends Equatable {
  const PortfolioTaxSummary({
    required this.taxYear,
    required this.dividendIncome,
    required this.sellProceeds,
    required this.estimatedRealizedGain,
    required this.taxableEventCount,
    required this.sellEventCount,
  });

  final int taxYear;
  final double dividendIncome;
  final double sellProceeds;
  final double estimatedRealizedGain;
  final int taxableEventCount;
  final int sellEventCount;

  bool get hasTaxableEvents => taxableEventCount > 0;

  /// Estimates tax-relevant activity for a given calendar year.
  ///
  /// The calculation walks transactions chronologically so sell gains can reuse
  /// the running average cost built from earlier buy transactions.
  factory PortfolioTaxSummary.fromSnapshot(
    PortfolioSnapshot snapshot, {
    required int taxYear,
  }) {
    final orderedTransactions = [...snapshot.transactions]
      ..sort((left, right) => left.date.compareTo(right.date));
    final positions = <String, _TrackedPosition>{};

    var dividendIncome = 0.0;
    var sellProceeds = 0.0;
    var estimatedRealizedGain = 0.0;
    var taxableEventCount = 0;
    var sellEventCount = 0;

    for (final transaction in orderedTransactions) {
      final symbol = transaction.assetSymbol;
      final position = positions[symbol] ?? const _TrackedPosition();

      switch (transaction.type) {
        case PortfolioTransactionType.buy:
          final quantity = transaction.quantity ?? 0;
          if (quantity <= 0) {
            continue;
          }
          final totalCost =
              (position.averageCost * position.quantity) + transaction.amount;
          final nextQuantity = position.quantity + quantity;
          positions[symbol] = _TrackedPosition(
            quantity: nextQuantity,
            averageCost: nextQuantity == 0 ? 0 : totalCost / nextQuantity,
          );
        case PortfolioTransactionType.sell:
          final quantity = transaction.quantity ?? 0;
          if (quantity <= 0) {
            continue;
          }
          final availableQuantity = position.quantity < quantity
              ? position.quantity
              : quantity;
          final realizedGain =
              transaction.amount - (position.averageCost * availableQuantity);
          final remainingQuantity = (position.quantity - availableQuantity)
              .clamp(0.0, double.infinity);
          positions[symbol] = _TrackedPosition(
            quantity: remainingQuantity,
            averageCost: remainingQuantity == 0 ? 0 : position.averageCost,
          );

          if (transaction.date.year == taxYear) {
            sellProceeds += transaction.amount;
            estimatedRealizedGain += realizedGain;
            taxableEventCount++;
            sellEventCount++;
          }
        case PortfolioTransactionType.dividend:
          if (transaction.date.year == taxYear) {
            dividendIncome += transaction.amount;
            taxableEventCount++;
          }
      }
    }

    return PortfolioTaxSummary(
      taxYear: taxYear,
      dividendIncome: dividendIncome,
      sellProceeds: sellProceeds,
      estimatedRealizedGain: estimatedRealizedGain,
      taxableEventCount: taxableEventCount,
      sellEventCount: sellEventCount,
    );
  }

  @override
  List<Object> get props => [
    taxYear,
    dividendIncome,
    sellProceeds,
    estimatedRealizedGain,
    taxableEventCount,
    sellEventCount,
  ];
}

class _TrackedPosition {
  const _TrackedPosition({this.quantity = 0, this.averageCost = 0});

  final double quantity;
  final double averageCost;
}
