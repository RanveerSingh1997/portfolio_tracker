import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_insights.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

void main() {
  test('PortfolioPerformanceAnalytics derives key dashboard insights', () {
    final analytics = PortfolioPerformanceAnalytics.fromSnapshot(_snapshot);

    expect(analytics.bestPerformer?.symbol, 'MSFT');
    expect(analytics.biggestPosition?.symbol, 'MSFT');
    expect(analytics.sectorCount, 2);
    expect(analytics.cashAllocationRatio, closeTo(0.25, 0.001));
  });

  test(
    'PortfolioTaxSummary estimates yearly dividend and realized gain totals',
    () {
      final summary = PortfolioTaxSummary.fromSnapshot(
        _snapshot,
        taxYear: 2026,
      );

      expect(summary.dividendIncome, 25);
      expect(summary.sellProceeds, 390);
      expect(summary.estimatedRealizedGain, 70);
      expect(summary.taxableEventCount, 2);
      expect(summary.sellEventCount, 1);
    },
  );
}

final _snapshot = PortfolioSnapshot(
  overview: const PortfolioOverview(
    totalValue: 4800,
    totalInvested: 4000,
    cashBalance: 1200,
    dayChange: 60,
  ),
  holdings: const [
    Holding(
      symbol: 'AAPL',
      name: 'Apple',
      quantity: 2,
      averageCost: 160,
      currentPrice: 180,
      sector: 'Technology',
    ),
    Holding(
      symbol: 'MSFT',
      name: 'Microsoft',
      quantity: 4,
      averageCost: 240,
      currentPrice: 310,
      sector: 'Technology',
    ),
    Holding(
      symbol: 'KO',
      name: 'Coca-Cola',
      quantity: 5,
      averageCost: 58,
      currentPrice: 56,
      sector: 'Consumer Staples',
    ),
  ],
  transactions: [
    PortfolioTransaction(
      assetSymbol: 'AAPL',
      assetName: 'Apple',
      type: PortfolioTransactionType.buy,
      amount: 320,
      quantity: 2,
      date: DateTime(2025, 12, 15),
    ),
    PortfolioTransaction(
      assetSymbol: 'AAPL',
      assetName: 'Apple',
      type: PortfolioTransactionType.sell,
      amount: 390,
      quantity: 2,
      date: DateTime(2026, 2, 10),
    ),
    PortfolioTransaction(
      assetSymbol: 'MSFT',
      assetName: 'Microsoft',
      type: PortfolioTransactionType.buy,
      amount: 960,
      quantity: 4,
      date: DateTime(2026, 1, 5),
    ),
    PortfolioTransaction(
      assetSymbol: 'KO',
      assetName: 'Coca-Cola',
      type: PortfolioTransactionType.dividend,
      amount: 25,
      date: DateTime(2026, 3, 20),
    ),
  ],
);
