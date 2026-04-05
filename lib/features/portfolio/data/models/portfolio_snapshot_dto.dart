import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_snapshot.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';

part 'portfolio_snapshot_dto.g.dart';

/// Data Transfer Object for the `/portfolio` API response.
///
/// This file now follows Flutter's generated JSON serialization approach using
/// `json_serializable`, while still keeping explicit validation and domain
/// conversion in one place.
@JsonSerializable(explicitToJson: true, checked: true)
class PortfolioSnapshotDto {
  const PortfolioSnapshotDto({
    required this.overview,
    required this.holdings,
    required this.transactions,
  });

  final PortfolioOverviewDto overview;
  final List<HoldingDto> holdings;
  final List<PortfolioTransactionDto> transactions;

  /// Entry point used by the network layer after an HTTP response is received.
  factory PortfolioSnapshotDto.fromResponse(Object? data) {
    if (data is! Map<String, dynamic>) {
      throw ArgumentError.value(
        data,
        'data',
        'Portfolio response must be a JSON object.',
      );
    }

    return PortfolioSnapshotDto.fromJson(data);
  }

  factory PortfolioSnapshotDto.fromJson(Map<String, dynamic> json) {
    try {
      final dto = _$PortfolioSnapshotDtoFromJson(json);
      dto._validate();
      return dto;
    } on CheckedFromJsonException catch (error) {
      throw FormatException(error.message ?? 'Invalid portfolio payload.');
    } on TypeError {
      throw const FormatException('Invalid portfolio payload.');
    }
  }

  factory PortfolioSnapshotDto.fromDomain(PortfolioSnapshot snapshot) {
    return PortfolioSnapshotDto(
      overview: PortfolioOverviewDto.fromDomain(snapshot.overview),
      holdings: snapshot.holdings.map(HoldingDto.fromDomain).toList(),
      transactions: snapshot.transactions
          .map(PortfolioTransactionDto.fromDomain)
          .toList(),
    );
  }

  PortfolioSnapshot toDomain() {
    return PortfolioSnapshot(
      overview: overview.toDomain(),
      holdings: holdings.map((holding) => holding.toDomain()).toList(),
      transactions: transactions
          .map((transaction) => transaction.toDomain())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$PortfolioSnapshotDtoToJson(this);

  void _validate() {
    overview._validate();
    for (final holding in holdings) {
      holding._validate();
    }
    for (final transaction in transactions) {
      transaction._validate();
    }
  }
}

@JsonSerializable(checked: true)
class PortfolioOverviewDto {
  const PortfolioOverviewDto({
    required this.totalValue,
    required this.totalInvested,
    required this.cashBalance,
    required this.dayChange,
  });

  final double totalValue;
  final double totalInvested;
  final double cashBalance;
  final double dayChange;

  factory PortfolioOverviewDto.fromJson(Map<String, dynamic> json) {
    try {
      final dto = _$PortfolioOverviewDtoFromJson(json);
      dto._validate();
      return dto;
    } on CheckedFromJsonException catch (error) {
      throw FormatException(error.message ?? 'Invalid portfolio overview.');
    } on TypeError {
      throw const FormatException('Invalid portfolio overview.');
    }
  }

  factory PortfolioOverviewDto.fromDomain(PortfolioOverview overview) {
    return PortfolioOverviewDto(
      totalValue: overview.totalValue,
      totalInvested: overview.totalInvested,
      cashBalance: overview.cashBalance,
      dayChange: overview.dayChange,
    );
  }

  Map<String, dynamic> toJson() => _$PortfolioOverviewDtoToJson(this);

  PortfolioOverview toDomain() {
    return PortfolioOverview(
      totalValue: totalValue,
      totalInvested: totalInvested,
      cashBalance: cashBalance,
      dayChange: dayChange,
    );
  }

  void _validate() {
    _requireNonNegative(totalValue, 'totalValue');
    _requireNonNegative(totalInvested, 'totalInvested');
    _requireNonNegative(cashBalance, 'cashBalance');
  }
}

@JsonSerializable(checked: true)
class HoldingDto {
  const HoldingDto({
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

  factory HoldingDto.fromJson(Map<String, dynamic> json) {
    try {
      final dto = _$HoldingDtoFromJson(json);
      dto._validate();
      return dto;
    } on CheckedFromJsonException catch (error) {
      throw FormatException(error.message ?? 'Invalid holding payload.');
    } on TypeError {
      throw const FormatException('Invalid holding payload.');
    }
  }

  factory HoldingDto.fromDomain(Holding holding) {
    return HoldingDto(
      symbol: holding.symbol,
      name: holding.name,
      quantity: holding.quantity,
      averageCost: holding.averageCost,
      currentPrice: holding.currentPrice,
      sector: holding.sector,
    );
  }

  Map<String, dynamic> toJson() => _$HoldingDtoToJson(this);

  Holding toDomain() {
    return Holding(
      symbol: symbol,
      name: name,
      quantity: quantity,
      averageCost: averageCost,
      currentPrice: currentPrice,
      sector: sector,
    );
  }

  void _validate() {
    _requireNonEmpty(symbol, 'symbol');
    _requireNonEmpty(name, 'name');
    _requirePositive(quantity, 'quantity');
    _requireNonNegative(averageCost, 'averageCost');
    _requireNonNegative(currentPrice, 'currentPrice');
    _requireNonEmpty(sector, 'sector');
  }
}

@JsonSerializable(checked: true)
class PortfolioTransactionDto {
  const PortfolioTransactionDto({
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

  factory PortfolioTransactionDto.fromJson(Map<String, dynamic> json) {
    try {
      final dto = _$PortfolioTransactionDtoFromJson(json);
      dto._validate();
      return dto;
    } on CheckedFromJsonException catch (error) {
      throw FormatException(error.message ?? 'Invalid transaction payload.');
    } on TypeError {
      throw const FormatException('Invalid transaction payload.');
    }
  }

  factory PortfolioTransactionDto.fromDomain(PortfolioTransaction transaction) {
    return PortfolioTransactionDto(
      assetSymbol: transaction.assetSymbol,
      assetName: transaction.assetName,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      quantity: transaction.quantity,
    );
  }

  Map<String, dynamic> toJson() => _$PortfolioTransactionDtoToJson(this);

  PortfolioTransaction toDomain() {
    return PortfolioTransaction(
      assetSymbol: assetSymbol,
      assetName: assetName,
      type: type,
      amount: amount,
      date: date,
      quantity: quantity,
    );
  }

  void _validate() {
    _requireNonEmpty(assetSymbol, 'assetSymbol');
    _requireNonEmpty(assetName, 'assetName');
    _requireNonNegative(amount, 'amount');
    if (quantity != null) {
      _requirePositive(quantity!, 'quantity');
    }
  }
}

void _requireNonEmpty(String value, String fieldName) {
  if (value.trim().isEmpty) {
    throw FormatException('Expected "$fieldName" to be a non-empty string.');
  }
}

void _requireNonNegative(double value, String fieldName) {
  if (value < 0) {
    throw FormatException('Expected "$fieldName" to be zero or greater.');
  }
}

void _requirePositive(double value, String fieldName) {
  if (value <= 0) {
    throw FormatException('Expected "$fieldName" to be greater than zero.');
  }
}
