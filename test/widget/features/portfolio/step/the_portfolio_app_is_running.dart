import 'package:flutter_test/flutter_test.dart';

import '../../../../support/pump_portfolio_app.dart';

/// Usage: the portfolio app is running
Future<void> thePortfolioAppIsRunning(WidgetTester tester) async {
  await pumpPortfolioApp(tester);
}
