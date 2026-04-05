import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/app/routes/app_pages.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';
import 'package:portfolio_tracker/app/routes/route_error_page.dart';
import 'package:portfolio_tracker/app/routes/route_guards.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the single app-wide [GoRouter] instance.
///
/// This keeps route registration, redirects, and route-level error handling in
/// one place instead of spreading navigation logic across widgets.
///
/// Example:
///
/// ```dart
/// final router = createAppRouter(
///   initialLocation: AppRoute.holdings.location,
///   errorHandler: AppErrorHandler(),
/// );
/// ```
GoRouter createAppRouter({
  String? initialLocation,
  AppErrorHandler? errorHandler,
}) {
  final resolvedErrorHandler = errorHandler ?? AppErrorHandler();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation ?? AppRoute.dashboard.location,
    routes: appPages,
    redirect: appRouteGuard,
    errorBuilder: (context, state) {
      return RouteErrorPage(
        error: resolvedErrorHandler.routeNotFound(state.uri.toString()),
      );
    },
  );
}
