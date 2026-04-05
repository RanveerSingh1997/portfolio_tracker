import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_insights.dart';

/// Dashboard card for a lightweight tax-oriented summary of recent activity.
class PortfolioTaxSummaryCard extends StatelessWidget {
  const PortfolioTaxSummaryCard({required this.summary, super.key});

  final PortfolioTaxSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.taxSummaryTitle(summary.taxYear.toString()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (!summary.hasTaxableEvents)
              Text(context.l10n.noTaxEventsLabel)
            else ...[
              _TaxRow(
                label: context.l10n.dividendIncomeLabel,
                value: context.l10n.formatCurrency(summary.dividendIncome),
              ),
              const SizedBox(height: 10),
              _TaxRow(
                label: context.l10n.sellProceedsLabel,
                value: context.l10n.formatCurrency(summary.sellProceeds),
              ),
              const SizedBox(height: 10),
              _TaxRow(
                label: context.l10n.estimatedRealizedGainLabel,
                value: context.l10n.formatCurrency(
                  summary.estimatedRealizedGain,
                ),
              ),
              const SizedBox(height: 10),
              _TaxRow(
                label: context.l10n.taxableEventsLabel,
                value: summary.taxableEventCount.toString(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaxRow extends StatelessWidget {
  const _TaxRow({required this.label, required this.value});

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
