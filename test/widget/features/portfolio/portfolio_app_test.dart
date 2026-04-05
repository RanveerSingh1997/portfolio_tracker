import 'package:flutter_test/flutter_test.dart';

import '../../../support/pump_portfolio_app.dart';

void main() {
  testWidgets('renders the portfolio dashboard by default', (
    WidgetTester tester,
  ) async {
    await pumpPortfolioApp(tester);

    expect(find.text('Portfolio Overview'), findsAtLeastNWidgets(1));
    expect(find.text('Total Value'), findsOneWidget);
    expect(find.text('Cash management'), findsOneWidget);
  });

  testWidgets('navigates to transactions from the bottom navigation', (
    WidgetTester tester,
  ) async {
    await pumpPortfolioApp(tester);

    await tester.tap(find.text('Transactions'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Transactions'), findsWidgets);
  });

  testWidgets('supports deep linking to holdings', (WidgetTester tester) async {
    await pumpPortfolioApp(tester, initialLocation: '/portfolio/holdings');

    expect(find.text('Holdings'), findsWidgets);
  });

  testWidgets('supports deep linking to holding details', (
    WidgetTester tester,
  ) async {
    await pumpPortfolioApp(tester, initialLocation: '/portfolio/holdings/AAPL');

    expect(find.text('AAPL'), findsWidgets);
    expect(find.textContaining('Apple'), findsOneWidget);
  });

  testWidgets('shows a route error page for an unknown deep link', (
    WidgetTester tester,
  ) async {
    await pumpPortfolioApp(tester, initialLocation: '/unknown');

    expect(find.text('This screen is unavailable'), findsOneWidget);
    expect(find.textContaining('/unknown'), findsOneWidget);
  });
}
