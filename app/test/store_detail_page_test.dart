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
    expect(find.text('2'), findsOneWidget);
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

  testWidgets('non-Mawar store does not show garlic-bread copy', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: StoreDetailPage(food: DemoFood.examples[1], cart: cart),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Soto Kesawan'), findsOneWidget);
    expect(find.textContaining('garlic butter'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('store hero and garlic photo assets decode', (tester) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: StoreDetailPage(food: DemoFood.examples.first, cart: cart),
      ),
    );
    final context = tester.element(find.byType(StoreDetailPage));
    await tester.runAsync(() async {
      await precacheImage(
        const AssetImage('assets/prototype/store-croissants.webp'),
        context,
      );
      await precacheImage(
        const AssetImage('assets/prototype/garlic-bread.webp'),
        context,
      );
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/prototype/store-croissants.webp',
      ),
      findsOneWidget,
    );
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
