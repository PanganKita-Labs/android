import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/location_selection_page.dart';
import 'package:pangankita/features/discovery/profile_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Home avatar opens profile and back returns Home', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {AppRoutes.profile: (_) => const ProfilePage()},
      ),
    );
    await tester.tap(find.byTooltip('Buka profil contoh'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Riwayat Pesanan'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali ke Beranda'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('area selected from Profile updates Home session location', (
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
    await tester.tap(find.byTooltip('Buka profil contoh'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Lokasi Saya'),
      180,
      scrollable: find
          .descendant(
            of: find.byType(ProfilePage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lokasi Saya'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationSelectionPage), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Medan Tembung'),
      180,
      scrollable: find
          .descendant(
            of: find.byType(LocationSelectionPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Medan Tembung'));
    await tester.tap(find.text('Gunakan Lokasi Ini'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byTooltip('Kembali ke Beranda'),
      -180,
      scrollable: find
          .descendant(
            of: find.byType(ProfilePage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byTooltip('Kembali ke Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Medan Tembung'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('profile fits $width at scale $scale', (tester) async {
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
            home: const ProfilePage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
