import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/nearby_stores_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Home merchant banner opens searchable store examples', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {AppRoutes.nearbyStores: (context) => const NearbyStoresPage()},
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Mau lihat berdasarkan toko?'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Mau lihat berdasarkan toko?'));
    await tester.pumpAndSettle();
    expect(find.text('Toko di Sekitarmu'), findsOneWidget);
    expect(find.textContaining('belum memakai lokasi'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Soto');
    await tester.pumpAndSettle();
    expect(find.text('Soto Kesawan'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsNothing);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(find.text('Mau lihat berdasarkan toko?'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('Stores fit $width at text scale $scale', (tester) async {
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
            home: const NearbyStoresPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Hisana Fried Chicken'),
          120,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
