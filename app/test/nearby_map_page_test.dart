import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/nearby_map_page.dart';
import 'package:pangankita/features/discovery/nearby_stores_page.dart';
import 'package:pangankita/features/discovery/store_detail_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('nearby list opens map and selected merchant detail', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const NearbyStoresPage(),
        routes: {
          AppRoutes.nearbyMap: (_) => const NearbyMapPage(),
          AppRoutes.store('soto'): (_) =>
              StoreDetailPage(food: DemoFood.examples[1], cart: cart),
        },
      ),
    );
    await tester.tap(find.text('Lihat Peta'));
    await tester.pumpAndSettle();
    expect(find.byType(NearbyMapPage), findsOneWidget);
    expect(find.textContaining('Peta ilustrasi'), findsOneWidget);
    await tester.tap(find.text('Soto Kesawan').first);
    await tester.pumpAndSettle();
    expect(find.text('1 produk contoh'), findsOneWidget);
    await tester.tap(find.text('Lihat Toko'));
    await tester.pumpAndSettle();
    expect(find.byType(StoreDetailPage), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('map fits $width at text scale $scale', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        await tester.pumpWidget(
          MaterialApp(
            theme: PanganKitaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            ),
            home: const NearbyMapPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
