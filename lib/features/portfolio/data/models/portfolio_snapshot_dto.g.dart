// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_snapshot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioSnapshotDto _$PortfolioSnapshotDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PortfolioSnapshotDto', json, ($checkedConvert) {
  final val = PortfolioSnapshotDto(
    overview: $checkedConvert(
      'overview',
      (v) => PortfolioOverviewDto.fromJson(v as Map<String, dynamic>),
    ),
    holdings: $checkedConvert(
      'holdings',
      (v) => (v as List<dynamic>)
          .map((e) => HoldingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    transactions: $checkedConvert(
      'transactions',
      (v) => (v as List<dynamic>)
          .map(
            (e) => PortfolioTransactionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PortfolioSnapshotDtoToJson(
  PortfolioSnapshotDto instance,
) => <String, dynamic>{
  'overview': instance.overview.toJson(),
  'holdings': instance.holdings.map((e) => e.toJson()).toList(),
  'transactions': instance.transactions.map((e) => e.toJson()).toList(),
};

PortfolioOverviewDto _$PortfolioOverviewDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PortfolioOverviewDto', json, ($checkedConvert) {
  final val = PortfolioOverviewDto(
    totalValue: $checkedConvert('totalValue', (v) => (v as num).toDouble()),
    totalInvested: $checkedConvert(
      'totalInvested',
      (v) => (v as num).toDouble(),
    ),
    cashBalance: $checkedConvert('cashBalance', (v) => (v as num).toDouble()),
    dayChange: $checkedConvert('dayChange', (v) => (v as num).toDouble()),
  );
  return val;
});

Map<String, dynamic> _$PortfolioOverviewDtoToJson(
  PortfolioOverviewDto instance,
) => <String, dynamic>{
  'totalValue': instance.totalValue,
  'totalInvested': instance.totalInvested,
  'cashBalance': instance.cashBalance,
  'dayChange': instance.dayChange,
};

HoldingDto _$HoldingDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('HoldingDto', json, ($checkedConvert) {
  final val = HoldingDto(
    symbol: $checkedConvert('symbol', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    quantity: $checkedConvert('quantity', (v) => (v as num).toDouble()),
    averageCost: $checkedConvert('averageCost', (v) => (v as num).toDouble()),
    currentPrice: $checkedConvert('currentPrice', (v) => (v as num).toDouble()),
    sector: $checkedConvert('sector', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$HoldingDtoToJson(HoldingDto instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'quantity': instance.quantity,
      'averageCost': instance.averageCost,
      'currentPrice': instance.currentPrice,
      'sector': instance.sector,
    };

PortfolioTransactionDto _$PortfolioTransactionDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PortfolioTransactionDto', json, ($checkedConvert) {
  final val = PortfolioTransactionDto(
    assetSymbol: $checkedConvert('assetSymbol', (v) => v as String),
    assetName: $checkedConvert('assetName', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$PortfolioTransactionTypeEnumMap, v),
    ),
    amount: $checkedConvert('amount', (v) => (v as num).toDouble()),
    date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
    quantity: $checkedConvert('quantity', (v) => (v as num?)?.toDouble()),
  );
  return val;
});

Map<String, dynamic> _$PortfolioTransactionDtoToJson(
  PortfolioTransactionDto instance,
) => <String, dynamic>{
  'assetSymbol': instance.assetSymbol,
  'assetName': instance.assetName,
  'type': _$PortfolioTransactionTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'quantity': instance.quantity,
};

const _$PortfolioTransactionTypeEnumMap = {
  PortfolioTransactionType.buy: 'buy',
  PortfolioTransactionType.sell: 'sell',
  PortfolioTransactionType.dividend: 'dividend',
};
