import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Restores the UI locale, registers font licenses, and starts the demo.
///
/// Reads `pangankita.ui.locale` before creating [PanganKitaApp].
///
/// Indonesian is used for absent, unknown, or unreadable preferences.
/// English and Simplified Chinese (`zh_Hans`) are restored when recognized.
/// Cart contents and the selected example area are not restored.
Future<void> main() async {
  final _ = WidgetsFlutterBinding.ensureInitialized();

  var initialLocale = const Locale('id');
  try {
    final stored = await SharedPreferencesAsync().getString(
      'pangankita.ui.locale',
    );
    initialLocale = switch (stored) {
      'en' => const Locale('en'),
      'zh_Hans' => const Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hans',
      ),
      _ => const Locale('id'),
    };
  } on Exception catch (error) {
    debugPrint('Unable to load language preference: $error');
  }
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Geist-OFL.txt');
    yield LicenseEntryWithLineBreaks(['Geist'], license);
    final satoshiLicense = await rootBundle.loadString(
      'assets/fonts/Satoshi-FFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Satoshi'], satoshiLicense);
  });
  runApp(PanganKitaApp(initialLocale: initialLocale));
}
