import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
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

  testWidgets('selected area survives selector reopening and tab changes', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .pushReplacementNamed(AppRoutes.home)
        .ignore();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mandala by Pass, Medan').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Medan Tembung'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Medan Tembung'));
    await tester.tap(find.text('Gunakan Lokasi Ini'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Medan Tembung').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Medan Tembung'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Medan Tembung'), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesanan').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beranda').last);
    await tester.pumpAndSettle();
    expect(find.text('Medan Tembung'), findsOneWidget);
  });

  testWidgets('search includes selected area and reports no matches', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const LocationSelectionPage(),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Mandala');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Mandala by Pass, Medan'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Mandala by Pass, Medan'), findsOneWidget);
    expect(find.text('Area contoh tidak ditemukan.'), findsNothing);
    await tester.scrollUntilVisible(
      find.byType(TextField),
      -180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byType(TextField), 'Tidak Ada Area');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Area contoh tidak ditemukan.'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Area contoh tidak ditemukan.'), findsOneWidget);
    expect(find.text('Mandala by Pass, Medan'), findsNothing);
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
