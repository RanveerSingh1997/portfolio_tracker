import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';

/// Dashboard card exposing local JSON import and export actions.
class PortfolioTransferCard extends StatelessWidget {
  const PortfolioTransferCard({
    required this.onExport,
    required this.onImport,
    super.key,
  });

  final VoidCallback onExport;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.portfolioDataTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.file_upload_outlined),
                    label: Text(context.l10n.exportPortfolioAction),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onImport,
                    icon: const Icon(Icons.file_download_outlined),
                    label: Text(context.l10n.importPortfolioAction),
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
