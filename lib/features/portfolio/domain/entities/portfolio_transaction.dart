import 'package:equatable/equatable.dart';

enum PortfolioTransactionType { buy, sell, dividend }

class PortfolioTransaction extends Equatable {
  const PortfolioTransaction({
    required this.assetSymbol,
    required this.assetName,
    required this.type,
    required this.amount,
    required this.date,
    this.quantity,
  });

  final String assetSymbol;
  final String assetName;
  final PortfolioTransactionType type;
  final double amount;
  final DateTime date;
  final double? quantity;

  @override
  List<Object?> get props => [
    assetSymbol,
    assetName,
    type,
    amount,
    date,
    quantity,
  ];
}
