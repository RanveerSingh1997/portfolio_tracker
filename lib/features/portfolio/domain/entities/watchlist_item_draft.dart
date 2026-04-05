import 'package:equatable/equatable.dart';

/// Input model collected from the watchlist form before persistence.
///
/// Keeping a dedicated draft type lets the UI gather optional fields like
/// target price and note without depending on storage-specific defaults such as
/// `addedAt`.
class WatchlistItemDraft extends Equatable {
  const WatchlistItemDraft({
    required this.symbol,
    required this.name,
    required this.sector,
    this.targetPrice,
    this.note,
  });

  final String symbol;
  final String name;
  final String sector;
  final double? targetPrice;
  final String? note;

  @override
  List<Object?> get props => [symbol, name, sector, targetPrice, note];
}
