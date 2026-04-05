import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';

class PortfolioAllocationCard extends StatelessWidget {
  const PortfolioAllocationCard({required this.holdings, super.key});

  final List<Holding> holdings;

  @override
  Widget build(BuildContext context) {
    final totalsBySector = <String, double>{};
    for (final holding in holdings) {
      totalsBySector.update(
        holding.sector,
        (value) => value + holding.marketValue,
        ifAbsent: () => holding.marketValue,
      );
    }

    final allocations = totalsBySector.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));
    final totalValue = allocations.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );
    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF7C3AED),
      const Color(0xFFEA580C),
      const Color(0xFF15803D),
      const Color(0xFFB91C1C),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.allocationTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < allocations.length; index++) ...[
              _AllocationRow(
                label: allocations[index].key,
                amount: allocations[index].value,
                progress: totalValue == 0
                    ? 0
                    : allocations[index].value / totalValue,
                color: colors[index % colors.length],
              ),
              if (index != allocations.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({
    required this.label,
    required this.amount,
    required this.progress,
    required this.color,
  });

  final String label;
  final double amount;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text(
              context.l10n.formatCurrency(amount),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
