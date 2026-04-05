import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/app/routes/app_router.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';
import 'package:portfolio_tracker/core/network/local_mock_api_server.dart';
import 'package:portfolio_tracker/core/network/network_config.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  NetworkConfig networkConfig() => const NetworkConfig();

  @lazySingleton
  Dio dio(LocalMockApiServer server, NetworkConfig config) => Dio(
    BaseOptions(
      baseUrl: server.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
    ),
  );

  @lazySingleton
  AppErrorHandler appErrorHandler() => AppErrorHandler();

  @preResolve
  Future<LocalMockApiServer> localMockApiServer(NetworkConfig config) async {
    Object? lastError;

    for (var attempt = 0; attempt < config.serverStartRetryCount; attempt++) {
      final server = LocalMockApiServer();

      try {
        await server.start().timeout(config.serverStartTimeout);
        return server;
      } catch (error) {
        lastError = error;
        await server.close();
      }
    }

    throw StateError(
      'Failed to start local mock API server: ${lastError ?? 'unknown error'}',
    );
  }

  @lazySingleton
  GoRouter goRouter(AppErrorHandler errorHandler) {
    return createAppRouter(errorHandler: errorHandler);
  }
}
