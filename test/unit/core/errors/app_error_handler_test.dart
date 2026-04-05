import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/errors/app_error_handler.dart';

void main() {
  group('AppErrorHandler.toAppError', () {
    test('returns AppError instances without wrapping them again', () {
      const error = AppError(
        type: AppErrorType.httpError,
        details: 'Request failed',
        statusCode: 500,
      );

      final result = AppErrorHandler().toAppError(error);

      expect(result, error);
    });

    test('maps FormatException to parse error', () {
      final result = AppErrorHandler().toAppError(
        const FormatException('Invalid payload'),
      );

      expect(result.type, AppErrorType.parseError);
      expect(result.details, 'Invalid payload');
    });
  });
}
