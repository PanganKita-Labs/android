import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

void main() {
  testWidgets('fresh Flutter bootstrap preserves the PanganKita brand', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'PanganKita');
    expect(app.theme?.colorScheme.primary, PanganKitaColors.brandPrimary);
    expect(find.text('UI belum diimplementasikan'), findsOneWidget);
  });
}
