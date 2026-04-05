import 'package:equatable/equatable.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

class PortfolioTransactionDraft extends Equatable {
  const PortfolioTransactionDraft({
    required this.symbol,
    required this.assetName,
    required this.type,
    required this.amount,
    required this.date,
    this.quantity,
    this.sector,
  });

  final String symbol;
  final String assetName;
  final PortfolioTransactionType type;
  final double amount;
  final DateTime date;
  final double? quantity;
  final String? sector;

  @override
  List<Object?> get props => [
    symbol,
    assetName,
    type,
    amount,
    date,
    quantity,
    sector,
  ];
}
