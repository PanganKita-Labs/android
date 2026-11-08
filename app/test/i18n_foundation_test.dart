import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/i18n/i18n.dart';

void main() {
  test('The app declares Indonesian, English, and Simplified Chinese', () {
    expect(AppLocalizations.supportedLocales, contains(const Locale('id')));
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
    expect(
      AppLocalizations.supportedLocales,
      contains(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ),
    );
  });

  testWidgets('Indonesian remains the default application language', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('id'));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('The app accepts a saved English locale', (tester) async {
    await tester.pumpWidget(const PanganKitaApp(initialLocale: Locale('en')));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('en'));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
