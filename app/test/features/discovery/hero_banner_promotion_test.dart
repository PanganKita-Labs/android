import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/hero_banner.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';

import '../../helpers/font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets(
    'croissant CTA reports unavailable promotion without unrelated details',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PanganKitaTheme.light,
          home: const Scaffold(body: HeroBanner()),
        ),
      );
      await tester.tap(find.text('Pesan Sekarang!'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Promo croissant belum tersedia'),
        findsOneWidget,
      );
      expect(find.byType(ProductDetailPage), findsNothing);
    },
  );
}
