import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({required this.error, super.key});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 56),
                const SizedBox(height: 16),
                Text(
                  context.l10n.routeUnavailableTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.errorMessage(error),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    context.go(AppRoute.dashboard.location);
                  },
                  child: Text(context.l10n.backToPortfolio),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
