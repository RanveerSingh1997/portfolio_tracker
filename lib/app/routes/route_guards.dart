import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';

String? appRouteGuard(BuildContext context, GoRouterState state) {
  if (state.uri.path == '/') {
    return AppRoute.dashboard.location;
  }

  return null;
}
