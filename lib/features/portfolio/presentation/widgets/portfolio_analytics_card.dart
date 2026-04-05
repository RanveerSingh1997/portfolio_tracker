import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_insights.dart';

/// Dashboard card for high-level performance and concentration insights.
class PortfolioAnalyticsCard extends StatelessWidget {
  const PortfolioAnalyticsCard({required this.analytics, super.key});

  final PortfolioPerformanceAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.analyticsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _AnalyticsTile(
                  label: context.l10n.bestPerformerLabel,
                  primary: analytics.bestPerformer?.symbol ?? '--',
                  secondary: analytics.bestPerformer == null
                      ? '--'
                      : context.l10n.formatCurrency(
                          analytics.bestPerformer!.profitLoss,
                        ),
                ),
                _AnalyticsTile(
                  label: context.l10n.biggestPositionLabel,
                  primary: analytics.biggestPosition?.symbol ?? '--',
                  secondary: analytics.biggestPosition == null
                      ? '--'
                      : context.l10n.formatCurrency(
                          analytics.biggestPosition!.marketValue,
                        ),
                ),
                _AnalyticsTile(
                  label: context.l10n.cashAllocationLabel,
                  primary: context.l10n.formatPercent(
                    analytics.cashAllocationRatio,
                  ),
                  secondary: context.l10n.formatPercent(
                    analytics.investedAllocationRatio,
                  ),
                ),
                _AnalyticsTile(
                  label: context.l10n.topSectorLabel,
                  primary: analytics.largestSector ?? '--',
                  secondary: context.l10n.formatPercent(
                    analytics.largestSectorWeight,
                  ),
                ),
                _AnalyticsTile(
                  label: context.l10n.dividendRunRateLabel,
                  primary: context.l10n.formatCurrency(
                    analytics.trailingTwelveMonthsDividendIncome,
                  ),
                  secondary: analytics.positionCount.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsTile extends StatelessWidget {
  const _AnalyticsTile({
    required this.label,
    required this.primary,
    required this.secondary,
  });

  final String label;
  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              primary,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(secondary, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
