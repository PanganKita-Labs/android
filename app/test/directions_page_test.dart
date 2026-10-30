import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/directions_page.dart';
import 'package:pangankita/features/discovery/nearby_map_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('map opens illustrative directions and changes travel mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const NearbyMapPage(),
        routes: {
          AppRoutes.directions('buns'): (_) =>
              DirectionsPage(food: DemoFood.examples[0]),
        },
      ),
    );
    await tester.tap(find.text('Petunjuk Arah'));
    await tester.pumpAndSettle();
    expect(find.byType(DirectionsPage), findsOneWidget);
    expect(find.text('Rute ilustrasi'), findsOneWidget);
    await tester.tap(find.text('Motor'));
    await tester.pumpAndSettle();
    expect(find.text('Motor • jarak dan waktu belum tersedia'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali ke peta toko'));
    await tester.pumpAndSettle();
    expect(find.byType(NearbyMapPage), findsOneWidget);
    expect(find.byType(DirectionsPage), findsNothing);
  });

  testWidgets('back opens the map when directions has no previous route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: DirectionsPage(food: DemoFood.examples[0]),
        routes: {AppRoutes.nearbyMap: (_) => const NearbyMapPage()},
      ),
    );
    await tester.tap(find.byTooltip('Kembali ke peta toko'));
    await tester.pumpAndSettle();
    expect(find.byType(NearbyMapPage), findsOneWidget);
  });

  testWidgets('system back opens map from a direct directions preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: DirectionsPage(food: DemoFood.examples[0]),
        routes: {AppRoutes.nearbyMap: (_) => const NearbyMapPage()},
      ),
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(NearbyMapPage), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('directions fits $width at scale $scale', (tester) async {
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
            home: DirectionsPage(food: DemoFood.examples[0]),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
