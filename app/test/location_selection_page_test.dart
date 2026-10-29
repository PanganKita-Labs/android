import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/location_selection_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Home opens local area selector and shows chosen example', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {AppRoutes.location: (_) => const LocationSelectionPage()},
      ),
    );
    await tester.tap(find.text('Mandala by Pass, Medan').first);
    await tester.pumpAndSettle();
    expect(find.text('Pilih Lokasi'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Medan Tembung'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Medan Tembung'));
    await tester.tap(find.text('Gunakan Lokasi Ini'));
    await tester.pumpAndSettle();
    expect(find.text('Medan Tembung'), findsOneWidget);
  });

  testWidgets('search narrows example areas without claiming GPS', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const LocationSelectionPage(),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Tembung');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Medan Tembung'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Medan Tembung'), findsOneWidget);
    expect(find.text('Medan Kota'), findsNothing);
    expect(find.textContaining('bukan lokasi langsung'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('location fits $width at text scale $scale', (tester) async {
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
            home: const LocationSelectionPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
