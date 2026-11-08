import 'package:flutter/services.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

/// Loads the actual brand faces so layout tests use production font metrics.
Future<void> loadBrandFonts() async {
  await (FontLoader(PanganKitaTheme.emphasisFontFamily)
        ..addFont(rootBundle.load('assets/fonts/Geist-SemiBold.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Geist-Bold.ttf')))
      .load();
  await (FontLoader(PanganKitaTheme.bodyFontFamily)
        ..addFont(rootBundle.load('assets/fonts/Satoshi-Regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Satoshi-Medium.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Satoshi-Bold.ttf')))
      .load();
}
