import 'package:equatable/equatable.dart';

/// One symbol the user wants to monitor even if it is not currently held.
///
/// Watchlist items are intentionally lightweight so they can live in local
/// preferences without requiring the full portfolio snapshot schema to change.
class WatchlistItem extends Equatable {
  const WatchlistItem({
    required this.symbol,
    required this.name,
    required this.sector,
    required this.addedAt,
    this.targetPrice,
    this.note,
  });

  final String symbol;
  final String name;
  final String sector;
  final DateTime addedAt;
  final double? targetPrice;
  final String? note;

  @override
  List<Object?> get props => [symbol, name, sector, addedAt, targetPrice, note];
}
