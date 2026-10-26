import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('all named product routes preserve selected listing data', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    for (final food in DemoFood.examples) {
      navigator.pushNamed<void>(AppRoutes.product(food.id));
      await tester.pumpAndSettle();
      expect(find.text(food.title), findsOneWidget);
      expect(find.text(food.merchant), findsOneWidget);
      expect(find.text(food.price), findsOneWidget);
      expect(tester.takeException(), isNull);
      navigator.pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('favorite, quantity bounds and unavailable cart are honest', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: ProductDetailPage(food: DemoFood.examples.first),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Favoritkan sementara'));
    await tester.pump();
    expect(find.byTooltip('Hapus favorit sementara'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.widgetWithIcon(IconButton, Icons.add),
      150,
    );
    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.remove))
          .onPressed,
      isNull,
    );
    for (var index = 0; index < 9; index++) {
      await tester.tap(find.byTooltip('Tambah jumlah contoh'));
      await tester.pump();
    }
    expect(find.text('10'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.add))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('Kurangi jumlah contoh'));
    await tester.pump();
    expect(find.text('9'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Tambah ke Keranjang (Demo)'),
      100,
    );
    await tester.tap(find.text('Tambah ke Keranjang (Demo)'));
    await tester.pump();
    expect(
      find.text(
        'Keranjang belum tersedia. '
        'Tidak ada pesanan atau reservasi dibuat.',
      ),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('detail fits $width at scale $scale', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: PanganKitaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                padding: const EdgeInsets.only(top: 24, bottom: 24),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            home: ProductDetailPage(food: DemoFood.examples[3]),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Tambah ke Keranjang (Demo)'),
          150,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Ulasan Pelanggan'), findsOneWidget);
      });
    }
  }
}
