import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_action_forms.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/transaction_list_tile.dart';

/// Transaction history page with manual entry plus client-side filtering.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        switch (state.transactionsStatus) {
          case PortfolioSectionStatus.initial:
          case PortfolioSectionStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PortfolioSectionStatus.failure:
            return Center(
              child: Text(
                context.l10n.errorMessage(
                  state.transactionsError ??
                      const AppError(type: AppErrorType.portfolioLoad),
                ),
              ),
            );
          case PortfolioSectionStatus.success:
            final visibleTransactions = state.visibleTransactions;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    final draft = await showTransactionEntrySheet(
                      context,
                      existingHoldings: state.holdings,
                    );
                    if (!context.mounted || draft == null) {
                      return;
                    }

                    final error = await context
                        .read<PortfolioCubit>()
                        .addTransaction(draft);
                    if (!context.mounted) {
                      return;
                    }
                    showActionMessage(context, error);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.addTransactionAction),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: context
                      .read<PortfolioCubit>()
                      .updateTransactionsSearchQuery,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: context.l10n.searchTransactionsHint,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<PortfolioTransactionType?>(
                  initialValue: state.transactionsTypeFilter,
                  decoration: InputDecoration(
                    labelText: context.l10n.transactionFilterLabel,
                  ),
                  items: [
                    DropdownMenuItem<PortfolioTransactionType?>(
                      value: null,
                      child: Text(context.l10n.allTransactionTypesLabel),
                    ),
                    ...PortfolioTransactionType.values.map((type) {
                      return DropdownMenuItem<PortfolioTransactionType?>(
                        value: type,
                        child: Text(_typeLabel(context, type)),
                      );
                    }),
                  ],
                  onChanged: context
                      .read<PortfolioCubit>()
                      .updateTransactionsTypeFilter,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(context.l10n.allYearsLabel),
                      selected:
                          state.transactionsYearFilter ==
                          TransactionYearFilter.all,
                      onSelected: (_) {
                        context
                            .read<PortfolioCubit>()
                            .updateTransactionsYearFilter(
                              TransactionYearFilter.all,
                            );
                      },
                    ),
                    ChoiceChip(
                      label: Text(context.l10n.currentYearOnlyLabel),
                      selected:
                          state.transactionsYearFilter ==
                          TransactionYearFilter.currentYear,
                      onSelected: (_) {
                        context
                            .read<PortfolioCubit>()
                            .updateTransactionsYearFilter(
                              TransactionYearFilter.currentYear,
                            );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (visibleTransactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(context.l10n.noTransactionsMatchFilters),
                    ),
                  ),
                for (
                  var index = 0;
                  index < visibleTransactions.length;
                  index++
                ) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TransactionListTile(
                        transaction: visibleTransactions[index],
                      ),
                    ),
                  ),
                  if (index != visibleTransactions.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            );
        }
      },
    );
  }

  String _typeLabel(BuildContext context, PortfolioTransactionType type) {
    return switch (type) {
      PortfolioTransactionType.buy => context.l10n.buy,
      PortfolioTransactionType.sell => context.l10n.sell,
      PortfolioTransactionType.dividend => context.l10n.dividend,
    };
  }
}
