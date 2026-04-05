import 'package:flutter/widgets.dart';
import 'package:portfolio_tracker/app/app.dart';
import 'package:portfolio_tracker/core/di/service_locator.dart';
import 'package:portfolio_tracker/core/errors/bootstrap_error_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupServiceLocator();
    runApp(const PortfolioApp());
  } catch (error) {
    runApp(BootstrapErrorApp(error: error));
  }
}
