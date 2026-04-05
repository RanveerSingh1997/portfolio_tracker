import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';

class CashManagementCard extends StatelessWidget {
  const CashManagementCard({
    required this.cashBalance,
    required this.onDeposit,
    required this.onWithdraw,
    super.key,
  });

  final double cashBalance;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.cashActionsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.formatCurrency(cashBalance),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDeposit,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: Text(context.l10n.depositCashAction),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onWithdraw,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    label: Text(context.l10n.withdrawCashAction),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
