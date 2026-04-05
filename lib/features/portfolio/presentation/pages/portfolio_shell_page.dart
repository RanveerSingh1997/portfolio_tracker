import 'package:flutter/material.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';

class PortfolioShellPage extends StatelessWidget {
  const PortfolioShellPage({
    required this.currentRoute,
    required this.onDestinationSelected,
    required this.child,
    super.key,
  });

  final AppRoute currentRoute;
  final ValueChanged<AppRoute> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentRoute.title(context)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.pie_chart_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentRoute.navigationIndex,
        onDestinationSelected: (index) {
          onDestinationSelected(AppRoute.navigationRouteAt(index));
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: AppRoute.dashboard.navigationLabel(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: AppRoute.holdings.navigationLabel(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: AppRoute.transactions.navigationLabel(context),
          ),
        ],
      ),
    );
  }
}
