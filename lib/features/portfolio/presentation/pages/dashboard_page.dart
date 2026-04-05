import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_tracker/app/routes/app_routes.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/cash_management_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/dividend_tracking_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/holding_list_tile.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/overview_metric_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_action_forms.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_allocation_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_analytics_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_tax_summary_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/portfolio_transfer_card.dart';
import 'package:portfolio_tracker/features/portfolio/presentation/widgets/watchlist_card.dart';

/// Main dashboard surface for portfolio health, actions, and supporting insights.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        switch (state.overviewStatus) {
          case PortfolioSectionStatus.initial:
          case PortfolioSectionStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PortfolioSectionStatus.failure:
            return Center(
              child: Text(
                context.l10n.errorMessage(
                  state.overviewError ??
                      const AppError(type: AppErrorType.portfolioLoad),
                ),
              ),
            );
          case PortfolioSectionStatus.success:
            final overview = state.overview!;
            final topHoldings = state.holdings.take(3).toList();
            final analytics = state.performanceAnalytics!;
            final dividendSummary = state.dividendSummary();
            final taxSummary = state.currentYearTaxSummary();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  context.l10n.portfolioOverviewHeading,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.portfolioOverviewSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OverviewMetricCard(
                      label: context.l10n.totalValue,
                      value: overview.totalValue,
                    ),
                    OverviewMetricCard(
                      label: context.l10n.invested,
                      value: overview.totalInvested,
                    ),
                    OverviewMetricCard(
                      label: context.l10n.cashBalance,
                      value: overview.cashBalance,
                    ),
                    OverviewMetricCard(
                      label: context.l10n.dayChange,
                      value: overview.dayChange,
                      highlightPositive: overview.dayChange >= 0,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CashManagementCard(
                  cashBalance: overview.cashBalance,
                  onDeposit: () async {
                    final amount = await showCashAmountDialog(
                      context,
                      title: context.l10n.depositCashAction,
                      actionLabel: context.l10n.depositCashAction,
                    );
                    if (!context.mounted || amount == null) {
                      return;
                    }
                    final error = await context
                        .read<PortfolioCubit>()
                        .depositCash(amount);
                    if (!context.mounted) {
                      return;
                    }
                    showActionMessage(context, error);
                  },
                  onWithdraw: () async {
                    final amount = await showCashAmountDialog(
                      context,
                      title: context.l10n.withdrawCashAction,
                      actionLabel: context.l10n.withdrawCashAction,
                    );
                    if (!context.mounted || amount == null) {
                      return;
                    }
                    final error = await context
                        .read<PortfolioCubit>()
                        .withdrawCash(amount);
                    if (!context.mounted) {
                      return;
                    }
                    showActionMessage(context, error);
                  },
                ),
                const SizedBox(height: 20),
                PortfolioAnalyticsCard(analytics: analytics),
                const SizedBox(height: 20),
                if (dividendSummary != null) ...[
                  DividendTrackingCard(summary: dividendSummary),
                  const SizedBox(height: 20),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.performance,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _PerformanceTile(
                                label: context.l10n.totalGainLoss,
                                value:
                                    '${overview.totalGainLoss >= 0 ? '+' : ''}${overview.totalGainLossPercentage.toStringAsFixed(2)}%',
                                positive: overview.totalGainLoss >= 0,
                              ),
                            ),
                            Expanded(
                              child: _PerformanceTile(
                                label: context.l10n.holdings,
                                value: state.holdings.length.toString(),
                                positive: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (taxSummary != null) ...[
                  PortfolioTaxSummaryCard(summary: taxSummary),
                  const SizedBox(height: 20),
                ],
                WatchlistCard(
                  watchlist: state.watchlist,
                  onAdd: () async {
                    final draft = await showWatchlistEntrySheet(context);
                    if (!context.mounted || draft == null) {
                      return;
                    }
                    final error = await context
                        .read<PortfolioCubit>()
                        .addWatchlistItem(draft);
                    if (!context.mounted) {
                      return;
                    }
                    showActionMessage(context, error);
                  },
                  onRemove: (symbol) async {
                    final error = await context
                        .read<PortfolioCubit>()
                        .removeWatchlistItem(symbol);
                    if (!context.mounted) {
                      return;
                    }
                    showActionMessage(context, error);
                  },
                ),
                const SizedBox(height: 20),
                PortfolioTransferCard(
                  onExport: () async {
                    final result = await context
                        .read<PortfolioCubit>()
                        .exportPortfolio();
                    if (!context.mounted) {
                      return;
                    }
                    if (result.error != null) {
                      showActionMessage(context, result.error);
                      return;
                    }
                    await showPortfolioExportSheet(
                      context,
                      rawJson: result.rawJson ?? '',
                    );
                  },
                  onImport: () async {
                    final rawJson = await showPortfolioImportSheet(context);
                    if (!context.mounted || rawJson == null) {
                      return;
                    }
                    final error = await context
                        .read<PortfolioCubit>()
                        .importPortfolio(rawJson);
                    if (!context.mounted) {
                      return;
                    }
                    if (error != null) {
                      showActionMessage(context, error);
                      return;
                    }
                    showStatusMessage(
                      context,
                      context.l10n.portfolioImportedMessage,
                    );
                  },
                ),
                const SizedBox(height: 20),
                PortfolioAllocationCard(holdings: state.holdings),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.topHoldings,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        for (final holding in topHoldings) ...[
                          HoldingListTile(
                            holding: holding,
                            onTap: () =>
                                context.goToHoldingDetails(holding.symbol),
                          ),
                          if (holding != topHoldings.last)
                            const Divider(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({
    required this.label,
    required this.value,
    required this.positive,
  });

  final String label;
  final String value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF15803D) : const Color(0xFFB91C1C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
