// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_portfolio_app_is_running.dart';
import './step/i_see_text.dart';

void main() {
  group('''Portfolio dashboard''', () {
    testWidgets('''Investor sees portfolio overview on app launch''', (
      tester,
    ) async {
      await thePortfolioAppIsRunning(tester);
      await iSeeText(tester, 'Total Value');
      await iSeeText(tester, 'Cash management');
    });
  });
}
