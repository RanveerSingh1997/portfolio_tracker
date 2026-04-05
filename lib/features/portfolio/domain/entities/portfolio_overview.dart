import 'package:equatable/equatable.dart';

class PortfolioOverview extends Equatable {
  const PortfolioOverview({
    required this.totalValue,
    required this.totalInvested,
    required this.cashBalance,
    required this.dayChange,
  });

  final double totalValue;
  final double totalInvested;
  final double cashBalance;
  final double dayChange;

  double get totalGainLoss => totalValue - totalInvested;

  double get totalGainLossPercentage {
    if (totalInvested == 0) {
      return 0;
    }

    return (totalGainLoss / totalInvested) * 100;
  }

  @override
  List<Object> get props => [totalValue, totalInvested, cashBalance, dayChange];
}
