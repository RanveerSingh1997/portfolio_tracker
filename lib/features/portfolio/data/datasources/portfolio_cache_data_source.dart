import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/watchlist_item_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight local persistence contract for portfolio and watchlist data.
///
/// The app currently uses shared preferences because the project is still in an
/// MVP/local-first phase. This interface keeps the repository insulated from
/// that storage choice so the implementation can later move to SQLite or Drift
/// without changing Cubits or widgets.
abstract class PortfolioCacheDataSource {
  Future<void> savePortfolio(PortfolioSnapshotDto snapshot);
  Future<PortfolioSnapshotDto?> loadPortfolio();
  Future<void> saveWatchlist(List<WatchlistItemDto> watchlist);
  Future<List<WatchlistItemDto>> loadWatchlist();
}

@LazySingleton(as: PortfolioCacheDataSource)
class SharedPrefsPortfolioCacheDataSource implements PortfolioCacheDataSource {
  static const _portfolioCacheKey = 'portfolio_snapshot_cache';
  static const _watchlistCacheKey = 'portfolio_watchlist_cache';

  @override
  Future<PortfolioSnapshotDto?> loadPortfolio() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawSnapshot = sharedPreferences.getString(_portfolioCacheKey);
    if (rawSnapshot == null) {
      return null;
    }

    final decoded = jsonDecode(rawSnapshot);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    try {
      return PortfolioSnapshotDto.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> savePortfolio(PortfolioSnapshotDto snapshot) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawSnapshot = jsonEncode(snapshot.toJson());
    await sharedPreferences.setString(_portfolioCacheKey, rawSnapshot);
  }

  @override
  Future<List<WatchlistItemDto>> loadWatchlist() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawWatchlist = sharedPreferences.getString(_watchlistCacheKey);
    if (rawWatchlist == null) {
      return [];
    }

    final decoded = jsonDecode(rawWatchlist);
    if (decoded is! List) {
      return [];
    }

    try {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(WatchlistItemDto.fromJson)
          .toList();
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> saveWatchlist(List<WatchlistItemDto> watchlist) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawWatchlist = jsonEncode(
      watchlist.map((item) => item.toJson()).toList(),
    );
    await sharedPreferences.setString(_watchlistCacheKey, rawWatchlist);
  }
}
