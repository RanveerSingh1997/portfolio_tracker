import 'package:equatable/equatable.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

class PortfolioSnapshot extends Equatable {
  const PortfolioSnapshot({
    required this.overview,
    required this.holdings,
    required this.transactions,
  });

  final PortfolioOverview overview;
  final List<Holding> holdings;
  final List<PortfolioTransaction> transactions;

  @override
  List<Object> get props => [overview, holdings, transactions];
}
