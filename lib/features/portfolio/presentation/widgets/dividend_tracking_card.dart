import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_insights.dart';

/// Dashboard card that summarizes dividend income and recent payouts.
class DividendTrackingCard extends StatelessWidget {
  const DividendTrackingCard({required this.summary, super.key});

  final PortfolioDividendSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.dividendTrackingTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (!summary.hasDividends)
              Text(context.l10n.noDividendEventsLabel)
            else ...[
              _DividendRow(
                label: context.l10n.yearToDateIncomeLabel,
                value: context.l10n.formatCurrency(summary.currentYearIncome),
              ),
              const SizedBox(height: 10),
              _DividendRow(
                label: context.l10n.trailingIncomeLabel,
                value: context.l10n.formatCurrency(
                  summary.trailingTwelveMonthsIncome,
                ),
              ),
              const SizedBox(height: 10),
              _DividendRow(
                label: context.l10n.topIncomeSymbolLabel,
                value: summary.topIncomeSymbol ?? '--',
              ),
              const SizedBox(height: 10),
              _DividendRow(
                label: context.l10n.dividendEventsLabel,
                value: summary.dividendEventCount.toString(),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.recentDividendsLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final dividend in summary.recentDividends) ...[
                _DividendRow(
                  label: dividend.assetSymbol,
                  value: context.l10n.formatCurrency(dividend.amount),
                ),
                if (dividend != summary.recentDividends.last)
                  const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _DividendRow extends StatelessWidget {
  const _DividendRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
