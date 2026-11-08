import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/i18n/i18n.dart';

void main() {
  testWidgets('Indonesian display text is preserved without a delegate', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: I18nText('Daftar'))),
    );
    expect(find.text('Daftar'), findsOneWidget);
  });

  for (final pair in <({Locale locale, String expected})>[
    (locale: const Locale('en'), expected: 'Sign Up'),
    (locale: const Locale('zh', 'CN'), expected: '注册'),
  ]) {
    testWidgets('Registration label is translated in ${pair.locale}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: pair.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: I18nText('Daftar')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(pair.expected), findsOneWidget);
    });
  }

  testWidgets('Dynamic values are preserved when localizing a cart label', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: I18nText('2 item · Rp30.000')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 items · Rp30.000'), findsOneWidget);
  });
}
