import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';

/// Dashboard card for watchlist creation and quick review.
///
/// The watchlist is intentionally separate from holdings so users can track
/// ideas and target prices without needing to own the asset first.
class WatchlistCard extends StatelessWidget {
  const WatchlistCard({
    required this.watchlist,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<WatchlistItem> watchlist;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.watchlistTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.addWatchlistAction),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (watchlist.isEmpty)
              Text(context.l10n.noWatchlistItems)
            else
              for (final item in watchlist) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.symbol,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(item.name),
                          const SizedBox(height: 2),
                          Text(item.sector),
                          if (item.targetPrice != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${context.l10n.targetPriceLabel}: ${context.l10n.formatCurrency(item.targetPrice!)}',
                            ),
                          ],
                          if (item.note != null && item.note!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(item.note!),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => onRemove(item.symbol),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: context.l10n.removeWatchlistAction,
                    ),
                  ],
                ),
                if (item != watchlist.last) const Divider(height: 20),
              ],
          ],
        ),
      ),
    );
  }
}
