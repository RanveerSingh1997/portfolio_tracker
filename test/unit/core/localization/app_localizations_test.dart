import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'returns Hindi localized route errors for route-not-found failures',
    (tester) async {
      late String message;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) {
              message = context.l10n.errorMessage(
                const AppError(
                  type: AppErrorType.routeNotFound,
                  details: '/missing',
                ),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(message, contains('/missing'));
      expect(message, contains('रूट'));
    },
  );
}
