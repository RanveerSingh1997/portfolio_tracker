import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item.dart';

/// Serializable local-storage shape for a [WatchlistItem].
///
/// This DTO is kept separate from the domain entity so persistence concerns like
/// ISO date parsing and input validation stay away from UI and Cubit code.
class WatchlistItemDto {
  const WatchlistItemDto({
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

  /// Parses one persisted watchlist JSON object and validates required fields.
  factory WatchlistItemDto.fromJson(Map<String, dynamic> json) {
    final symbol = json['symbol'];
    final name = json['name'];
    final sector = json['sector'];
    final addedAt = json['addedAt'];
    final targetPrice = json['targetPrice'];
    final note = json['note'];

    if (symbol is! String || symbol.trim().isEmpty) {
      throw const FormatException('Watchlist symbol is required.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Watchlist name is required.');
    }
    if (sector is! String || sector.trim().isEmpty) {
      throw const FormatException('Watchlist sector is required.');
    }
    if (addedAt is! String) {
      throw const FormatException('Watchlist addedAt is required.');
    }

    final parsedTargetPrice = switch (targetPrice) {
      null => null,
      num value => value.toDouble(),
      _ => throw const FormatException('Watchlist targetPrice is invalid.'),
    };
    if (parsedTargetPrice != null && parsedTargetPrice <= 0) {
      throw const FormatException('Watchlist targetPrice must be positive.');
    }
    if (note != null && note is! String) {
      throw const FormatException('Watchlist note is invalid.');
    }

    final normalizedNote = switch (note) {
      String value when value.trim().isNotEmpty => value.trim(),
      _ => null,
    };

    return WatchlistItemDto(
      symbol: symbol.trim().toUpperCase(),
      name: name.trim(),
      sector: sector.trim(),
      addedAt: DateTime.parse(addedAt),
      targetPrice: parsedTargetPrice,
      note: normalizedNote,
    );
  }

  factory WatchlistItemDto.fromDomain(WatchlistItem item) {
    return WatchlistItemDto(
      symbol: item.symbol,
      name: item.name,
      sector: item.sector,
      addedAt: item.addedAt,
      targetPrice: item.targetPrice,
      note: item.note,
    );
  }

  /// Encodes the item to the map shape stored in shared preferences.
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'sector': sector,
      'addedAt': addedAt.toIso8601String(),
      'targetPrice': targetPrice,
      'note': note,
    };
  }

  /// Converts the storage model back into the domain entity used by the app.
  WatchlistItem toDomain() {
    return WatchlistItem(
      symbol: symbol,
      name: name,
      sector: sector,
      addedAt: addedAt,
      targetPrice: targetPrice,
      note: note,
    );
  }
}
