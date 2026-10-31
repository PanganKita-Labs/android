import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/profile_page.dart';
import 'package:pangankita/features/discovery/settings_page.dart';
import 'package:pangankita/features/discovery/support_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Profile help opens support example and composer stays local', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const ProfilePage(),
        routes: {AppRoutes.support: (_) => const SupportPage()},
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Pusat Bantuan'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();
    expect(find.text('Bantuan PanganKita'), findsOneWidget);
    expect(find.text('Customer Service • contoh'), findsOneWidget);
    expect(find.text('19.42 • contoh'), findsOneWidget);
    await tester.tap(find.text('Pesanan belum siap'));
    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Pesanan belum siap',
    );
    await tester.tap(find.byTooltip('Kirim pesan contoh'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Pesan tidak dikirim'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali ke Profil Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Saya'), findsOneWidget);
  });

  testWidgets('Settings help opens the same support route', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SettingsPage(),
        routes: {AppRoutes.support: (_) => const SupportPage()},
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Pusat Bantuan'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();
    expect(find.byType(SupportPage), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('support fits $width at scale $scale', (tester) async {
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
            home: const SupportPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
