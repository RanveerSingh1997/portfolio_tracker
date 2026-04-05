import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';

class OverviewMetricCard extends StatelessWidget {
  const OverviewMetricCard({
    required this.label,
    required this.value,
    this.highlightPositive = true,
    super.key,
  });

  final String label;
  final double value;
  final bool highlightPositive;

  @override
  Widget build(BuildContext context) {
    final changeColor = highlightPositive
        ? const Color(0xFF15803D)
        : const Color(0xFFB91C1C);

    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              Text(
                context.l10n.formatCurrency(value),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
