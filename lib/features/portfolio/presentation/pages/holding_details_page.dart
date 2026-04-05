import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';

class HoldingDetailsPage extends StatelessWidget {
  const HoldingDetailsPage({required this.symbol, super.key});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        final holding = _findHolding(state.holdings, symbol);
        if (holding == null) {
          return Center(child: Text(context.l10n.routeNotFoundError(symbol)));
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              holding.symbol,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.holdingSubtitle(holding.name, holding.quantity),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      label: context.l10n.totalValue,
                      value: context.l10n.formatCurrency(holding.marketValue),
                    ),
                    _DetailRow(
                      label: context.l10n.invested,
                      value: context.l10n.formatCurrency(holding.totalCost),
                    ),
                    _DetailRow(
                      label: context.l10n.totalGainLoss,
                      value: context.l10n.formatCurrency(holding.profitLoss),
                    ),
                    _DetailRow(
                      label: context.l10n.unitsLabel(holding.quantity),
                      value: holding.sector,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Holding? _findHolding(List<Holding> holdings, String symbol) {
    for (final holding in holdings) {
      if (holding.symbol == symbol) {
        return holding;
      }
    }

    return null;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
