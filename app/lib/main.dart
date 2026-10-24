import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/pangan_kita_app.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Liberation Sans'], license);
    final satoshiLicense = await rootBundle.loadString(
      'assets/fonts/Satoshi-FFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Satoshi'], satoshiLicense);
  });
  runApp(const PanganKitaApp());
}
