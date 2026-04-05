import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/pages/holding_details_page.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/pages/dashboard_page.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/pages/holdings_page.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/pages/portfolio_shell_page.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/pages/transactions_page.dart';

final List<RouteBase> appPages = [
  ShellRoute(
    builder: (context, state, child) {
      return PortfolioShellPage(
        currentRoute: AppRoute.fromLocation(state.uri.toString()),
        onDestinationSelected: (route) => context.goToRoute(route),
        child: child,
      );
    },
    routes: [
      GoRoute(
        name: AppRoute.dashboard.name,
        path: AppRoute.dashboard.location,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        name: AppRoute.holdings.name,
        path: AppRoute.holdings.location,
        builder: (context, state) => const HoldingsPage(),
      ),
      GoRoute(
        name: AppRoute.holdingDetails.name,
        path: AppRoute.holdingDetails.location,
        builder: (context, state) =>
            HoldingDetailsPage(symbol: state.pathParameters['symbol'] ?? ''),
      ),
      GoRoute(
        name: AppRoute.transactions.name,
        path: AppRoute.transactions.location,
        builder: (context, state) => const TransactionsPage(),
      ),
    ],
  ),
];
