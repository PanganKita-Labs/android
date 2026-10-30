import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/edit_profile_page.dart';
import 'package:pangankita/features/discovery/profile_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('profile opens edit form and back discards local input', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const ProfilePage(),
        routes: {AppRoutes.editProfile: (_) => const EditProfilePage()},
      ),
    );
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Contoh Baru');
    await tester.tap(find.byTooltip('Kembali ke Profil Saya'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Vincent'), findsOneWidget);
    expect(find.text('Contoh Baru'), findsNothing);
  });

  testWidgets('save validates input and reports unavailable persistence', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const EditProfilePage()),
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'invalid');
    await tester.scrollUntilVisible(
      find.text('Simpan Perubahan'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan email yang valid.'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'vincent@example.com',
    );
    await tester.scrollUntilVisible(
      find.text('Simpan Perubahan'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();
    expect(
      find.text('Perubahan contoh belum dapat disimpan ke akun.'),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('edit profile fits $width at scale $scale', (tester) async {
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
            home: const EditProfilePage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
