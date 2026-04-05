import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/core/di/service_locator.config.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';
import 'package:portfolio_tracker/core/network/local_mock_api_server.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  asExtension: true,
  initializerName: 'init',
  preferRelativeImports: true,
)
/// Boots the generated Injectable graph.
///
/// Example:
///
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await setupServiceLocator();
///   runApp(const PortfolioApp());
/// }
/// ```
///
/// Passing `reset: true` is mainly useful in tests so the mock API server and
/// registered singletons start from a clean state.
Future<void> setupServiceLocator({bool reset = false}) async {
  if (reset) {
    if (getIt.isRegistered<AppErrorHandler>()) {
      getIt<AppErrorHandler>().dispose();
    }
    if (getIt.isRegistered<LocalMockApiServer>()) {
      await getIt<LocalMockApiServer>().close();
    }
    await getIt.reset();
  }

  await getIt.init();
  getIt<AppErrorHandler>().initialize();
}
