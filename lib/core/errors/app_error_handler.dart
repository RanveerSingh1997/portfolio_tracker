import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';

/// Central place for error reporting and app-safe error mapping.
///
/// Use this in Cubits, route handling, and app bootstrap so failures are
/// reported consistently and translated into user-facing [AppError] values.
class AppErrorHandler {
  FlutterExceptionHandler? _previousFlutterErrorHandler;
  bool Function(Object, StackTrace)? _previousPlatformErrorHandler;
  bool _isInitialized = false;

  /// Installs top-level Flutter and platform error hooks.
  ///
  /// Widget tests are intentionally skipped because overriding the global test
  /// binding error handler interferes with Flutter's test runner.
  void initialize() {
    if (_isInitialized) {
      return;
    }

    final bindingType = WidgetsBinding.instance.runtimeType.toString();
    if (bindingType.contains('TestWidgetsFlutterBinding')) {
      return;
    }

    _previousFlutterErrorHandler = FlutterError.onError;
    _previousPlatformErrorHandler = PlatformDispatcher.instance.onError;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      report(error, stackTrace, reason: 'Unhandled platform error');
      return true;
    };

    _isInitialized = true;
  }

  /// Restores any global handlers replaced during [initialize].
  void dispose() {
    if (!_isInitialized) {
      return;
    }

    FlutterError.onError = _previousFlutterErrorHandler;
    PlatformDispatcher.instance.onError = _previousPlatformErrorHandler;
    _previousFlutterErrorHandler = null;
    _previousPlatformErrorHandler = null;
    _isInitialized = false;
  }

  /// Reports an error through Flutter's error presentation pipeline.
  void report(
    Object error,
    StackTrace stackTrace, {
    String reason = 'Unhandled app error',
  }) {
    FlutterError.presentError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'portfolio_tracker',
        context: ErrorDescription(reason),
      ),
    );
  }

  /// Converts a low-level exception into an [AppError] that the UI can render.
  AppError toAppError(
    Object error, {
    AppErrorType fallbackType = AppErrorType.unknown,
    String? details,
  }) {
    if (error is AppError) {
      return error;
    }

    if (error is FormatException) {
      return AppError(
        type: AppErrorType.parseError,
        details: details ?? error.message,
      );
    }

    return AppError(type: fallbackType, details: details ?? error.toString());
  }

  /// Creates a route-not-found error for centralized navigation failure UI.
  AppError routeNotFound(String location) {
    return AppError(type: AppErrorType.routeNotFound, details: location);
  }
}
