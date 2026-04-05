import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/features/portfolio/data/models/portfolio_snapshot_dto.dart';

void main() {
  group('PortfolioSnapshotDto.fromJson', () {
    test('throws FormatException for invalid holding quantity', () {
      expect(
        () => PortfolioSnapshotDto.fromJson({
          'overview': {
            'totalValue': 1000,
            'totalInvested': 900,
            'cashBalance': 100,
            'dayChange': 10,
          },
          'holdings': [
            {
              'symbol': 'AAPL',
              'name': 'Apple',
              'quantity': -1,
              'averageCost': 100,
              'currentPrice': 120,
              'sector': 'Technology',
            },
          ],
          'transactions': const [],
        }),
        throwsFormatException,
      );
    });

    test('throws FormatException for invalid transaction date', () {
      expect(
        () => PortfolioSnapshotDto.fromJson({
          'overview': {
            'totalValue': 1000,
            'totalInvested': 900,
            'cashBalance': 100,
            'dayChange': 10,
          },
          'holdings': const [],
          'transactions': [
            {
              'assetSymbol': 'AAPL',
              'assetName': 'Apple',
              'type': 'buy',
              'amount': 100,
              'date': '',
              'quantity': 1,
            },
          ],
        }),
        throwsFormatException,
      );
    });
  });
}
