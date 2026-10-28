import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/nearby_stores_page.dart';
import 'package:pangankita/features/discovery/store_detail_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('store card opens detail and adds a sample product', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const NearbyStoresPage(),
        routes: {
          AppRoutes.store('buns'): (context) =>
              StoreDetailPage(food: DemoFood.examples.first, cart: cart),
          AppRoutes.cart: (context) => const Scaffold(body: Text('Keranjang')),
        },
      ),
    );
    await tester.tap(find.text('Mawar Bakery & Cake'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Toko'), findsOneWidget);
    expect(find.text('Contoh'), findsOneWidget);
    expect(find.text('Mawar Coconut Buns'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -260));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Tambah produk contoh ke keranjang').first);
    await tester.pumpAndSettle();
    expect(cart.itemCount, 1);
    await tester.tap(find.text('Ulasan'));
    await tester.pumpAndSettle();
    expect(find.text('Ulasan toko belum tersedia.'), findsOneWidget);
    await tester.tap(find.textContaining('Lihat Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('store detail fits $width at scale $scale', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final cart = DemoCart();
        addTearDown(cart.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: PanganKitaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            ),
            home: StoreDetailPage(food: DemoFood.examples.first, cart: cart),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Mawar Coconut Buns'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
