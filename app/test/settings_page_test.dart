import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/profile_page.dart';
import 'package:pangankita/features/discovery/settings_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('profile opens settings and switches reset on return', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const ProfilePage(),
        routes: {AppRoutes.settings: (_) => const SettingsPage()},
      ),
    );
    await tester.tap(find.byTooltip('Buka Pengaturan'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(2)).value,
      isFalse,
    );
    await tester.tap(find.text('Promo & penawaran'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(2)).value,
      isTrue,
    );
    await tester.tap(find.byTooltip('Kembali ke Profil Saya'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buka Pengaturan'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(2)).value,
      isFalse,
    );
  });

  testWidgets('account links explain unavailable integration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const SettingsPage()),
    );
    await tester.scrollUntilVisible(
      find.text('Ubah Password'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Ubah Password'));
    await tester.pumpAndSettle();
    expect(
      find.text('Fitur ini belum tersedia dalam demo offline.'),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('settings fits $width at scale $scale', (tester) async {
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
            home: const SettingsPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
