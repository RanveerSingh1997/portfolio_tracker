import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({required this.transaction, super.key});

  final PortfolioTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.type == PortfolioTransactionType.dividend;
    final amountPrefix = isPositive ? '+' : '-';
    final color = isPositive ? const Color(0xFF15803D) : null;
    final transactionLabel = switch (transaction.type) {
      PortfolioTransactionType.buy => context.l10n.buy,
      PortfolioTransactionType.sell => context.l10n.sell,
      PortfolioTransactionType.dividend => context.l10n.dividend,
    };

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(_iconForType(transaction.type)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.transactionTitle(
                  transaction.assetSymbol,
                  transactionLabel,
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.transactionSubtitle(
                  transaction.assetName,
                  transaction.date,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$amountPrefix${context.l10n.formatCurrency(transaction.amount)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (transaction.quantity != null)
              Text(
                context.l10n.unitsLabel(transaction.quantity!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ],
    );
  }

  IconData _iconForType(PortfolioTransactionType type) {
    switch (type) {
      case PortfolioTransactionType.buy:
        return Icons.arrow_downward_rounded;
      case PortfolioTransactionType.sell:
        return Icons.arrow_upward_rounded;
      case PortfolioTransactionType.dividend:
        return Icons.attach_money_rounded;
    }
  }
}
