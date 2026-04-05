import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';

enum AppRoute {
  dashboard(name: 'dashboard', location: '/portfolio'),
  holdings(name: 'holdings', location: '/portfolio/holdings'),
  holdingDetails(
    name: 'holding-details',
    location: '/portfolio/holdings/:symbol',
  ),
  transactions(name: 'transactions', location: '/portfolio/transactions');

  const AppRoute({required this.name, required this.location});

  final String name;
  final String location;

  String title(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case AppRoute.dashboard:
        return l10n.dashboardTitle;
      case AppRoute.holdings:
      case AppRoute.holdingDetails:
        return l10n.holdingsTitle;
      case AppRoute.transactions:
        return l10n.transactionsTitle;
    }
  }

  String navigationLabel(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case AppRoute.dashboard:
        return l10n.dashboardTab;
      case AppRoute.holdings:
      case AppRoute.holdingDetails:
        return l10n.holdingsTab;
      case AppRoute.transactions:
        return l10n.transactionsTab;
    }
  }

  static AppRoute fromLocation(String location) {
    final normalizedLocation = Uri.parse(location).path;

    if (normalizedLocation.startsWith('/portfolio/holdings/')) {
      return AppRoute.holdingDetails;
    }

    return switch (normalizedLocation) {
      '/portfolio' => AppRoute.dashboard,
      '/portfolio/holdings' => AppRoute.holdings,
      '/portfolio/transactions' => AppRoute.transactions,
      _ => AppRoute.dashboard,
    };
  }

  static String holdingDetailsLocation(String symbol) {
    return '/portfolio/holdings/${Uri.encodeComponent(symbol)}';
  }

  int get navigationIndex {
    return switch (this) {
      AppRoute.dashboard => 0,
      AppRoute.holdings || AppRoute.holdingDetails => 1,
      AppRoute.transactions => 2,
    };
  }

  static AppRoute navigationRouteAt(int index) {
    return switch (index) {
      0 => AppRoute.dashboard,
      1 => AppRoute.holdings,
      2 => AppRoute.transactions,
      _ => AppRoute.dashboard,
    };
  }
}

extension AppRouteNavigation on BuildContext {
  void goToRoute(AppRoute route) {
    goNamed(route.name);
  }

  void goToHoldingDetails(String symbol) {
    goNamed(AppRoute.holdingDetails.name, pathParameters: {'symbol': symbol});
  }
}
