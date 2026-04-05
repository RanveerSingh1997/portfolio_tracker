import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';

class HoldingListTile extends StatelessWidget {
  const HoldingListTile({required this.holding, this.onTap, super.key});

  final Holding holding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.profitLoss >= 0;
    final changeColor = isPositive
        ? const Color(0xFF15803D)
        : const Color(0xFFB91C1C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              holding.symbol.substring(0, 1),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.holdingSubtitle(holding.name, holding.quantity),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.l10n.formatCurrency(holding.marketValue),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                '${isPositive ? '+' : ''}${holding.profitLossPercentage.toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
