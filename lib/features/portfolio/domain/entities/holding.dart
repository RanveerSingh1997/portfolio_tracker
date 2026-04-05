import 'package:equatable/equatable.dart';

class Holding extends Equatable {
  const Holding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averageCost,
    required this.currentPrice,
    required this.sector,
  });

  final String symbol;
  final String name;
  final double quantity;
  final double averageCost;
  final double currentPrice;
  final String sector;

  double get marketValue => quantity * currentPrice;

  double get totalCost => quantity * averageCost;

  double get profitLoss => marketValue - totalCost;

  double get profitLossPercentage {
    if (totalCost == 0) {
      return 0;
    }

    return (profitLoss / totalCost) * 100;
  }

  @override
  List<Object> get props => [
    symbol,
    name,
    quantity,
    averageCost,
    currentPrice,
    sector,
  ];
}
