import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all three i18n catalogs have matching keys and placeholders', () {
    const locales = ['id', 'en', 'zh', 'zh_Hans'];
    final catalogs = <String, Map<String, Object?>>{};
    for (final locale in locales) {
      final file = File('lib/i18n/arb/app_$locale.arb');
      expect(file.existsSync(), isTrue, reason: locale);
      catalogs[locale] =
          jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    }
    final expected = (catalogs['id'] ?? <String, Object?>{}).keys
        .where((key) => !key.startsWith('@'))
        .toSet();
    for (final locale in locales) {
      final catalog = catalogs[locale] ?? <String, Object?>{};
      expect(
        catalog.keys.where((key) => !key.startsWith('@')).toSet(),
        expected,
        reason: locale,
      );
      for (final key in expected) {
        final value = (catalog[key] as String?) ?? '';
        expect(value.isNotEmpty, isTrue, reason: '$locale:$key');
        final tokens = RegExp(r'\{arg\d+\}')
            .allMatches(value)
            .map((match) => match.group(0))
            .toSet();
        final originalTokens = RegExp(r'\{arg\d+\}')
            .allMatches(
              ((catalogs['id'] ?? <String, Object?>{})[key] as String?) ?? '',
            )
            .map((match) => match.group(0))
            .toSet();
        expect(tokens, originalTokens, reason: '$locale:$key');
      }
    }
  });
}
