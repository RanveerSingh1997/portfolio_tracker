import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/holding_list_tile.dart';

class HoldingsPage extends StatelessWidget {
  const HoldingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        switch (state.holdingsStatus) {
          case PortfolioSectionStatus.initial:
          case PortfolioSectionStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PortfolioSectionStatus.failure:
            return Center(
              child: Text(
                context.l10n.errorMessage(
                  state.holdingsError ??
                      const AppError(type: AppErrorType.portfolioLoad),
                ),
              ),
            );
          case PortfolioSectionStatus.success:
            final visibleHoldings = state.visibleHoldings;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextField(
                  onChanged: context
                      .read<PortfolioCubit>()
                      .updateHoldingsSearchQuery,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: context.l10n.searchHoldingsHint,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: state.holdingsSectorFilter,
                        decoration: InputDecoration(
                          labelText: context.l10n.sectorLabel,
                        ),
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(context.l10n.allSectorsLabel),
                          ),
                          ...state.availableHoldingSectors.map((sector) {
                            return DropdownMenuItem<String?>(
                              value: sector,
                              child: Text(sector),
                            );
                          }),
                        ],
                        onChanged: context
                            .read<PortfolioCubit>()
                            .updateHoldingsSectorFilter,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<HoldingsSortOption>(
                        initialValue: state.holdingsSortOption,
                        decoration: InputDecoration(
                          labelText: context.l10n.sortByLabel,
                        ),
                        items: HoldingsSortOption.values.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(_sortLabel(context, option)),
                          );
                        }).toList(),
                        onChanged: (option) {
                          if (option != null) {
                            context
                                .read<PortfolioCubit>()
                                .updateHoldingsSortOption(option);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (visibleHoldings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(context.l10n.noHoldingsMatchFilters),
                    ),
                  ),
                for (
                  var index = 0;
                  index < visibleHoldings.length;
                  index++
                ) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: HoldingListTile(
                        holding: visibleHoldings[index],
                        onTap: () => context.goToHoldingDetails(
                          visibleHoldings[index].symbol,
                        ),
                      ),
                    ),
                  ),
                  if (index != visibleHoldings.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            );
        }
      },
    );
  }

  String _sortLabel(BuildContext context, HoldingsSortOption option) {
    return switch (option) {
      HoldingsSortOption.symbol => context.l10n.sortBySymbol,
      HoldingsSortOption.marketValue => context.l10n.sortByMarketValue,
      HoldingsSortOption.profitLoss => context.l10n.sortByProfitLoss,
    };
  }
}
