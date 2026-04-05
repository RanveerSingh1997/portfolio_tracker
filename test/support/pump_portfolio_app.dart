import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/app/app.dart';
import 'package:portfolio_tracker/app/routes/app_router.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';
import 'package:portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';

import 'fake_portfolio_repository.dart';

Future<void> pumpPortfolioApp(
  WidgetTester tester, {
  String? initialLocation,
  PortfolioRepository repository = const FakePortfolioRepository(),
}) async {
  final errorHandler = AppErrorHandler();

  await tester.pumpWidget(
    PortfolioApp(
      repository: repository,
      errorHandler: errorHandler,
      router: createAppRouter(
        initialLocation: initialLocation,
        errorHandler: errorHandler,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
