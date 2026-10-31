import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/favorites_page.dart';
import 'package:pangankita/features/discovery/profile_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Profile opens favorites and local removal resets on reopen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const ProfilePage(),
        routes: {AppRoutes.favorites: (_) => const FavoritesPage()},
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Favorit Saya'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Favorit Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsOneWidget);
    await tester.tap(
      find.byTooltip(
        'Hapus Mawar Coconut Buns (Isi 5 pcs) dari favorit contoh',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsNothing);
    await tester.tap(find.byTooltip('Kembali ke Profil Saya'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorit Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsOneWidget);
  });

  testWidgets('Makanan and Toko tabs show local examples', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const FavoritesPage()),
    );
    await tester.tap(find.text('Toko'));
    await tester.pumpAndSettle();
    expect(find.text('Toko favorit contoh'), findsOneWidget);
    await tester.tap(
      find.byTooltip('Hapus Mawar Bakery & Cake dari favorit contoh'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada toko favorit contoh.'), findsOneWidget);
    await tester.tap(find.text('Makanan'));
    await tester.pumpAndSettle();
    expect(find.text('Roti Abon Ayam'), findsOneWidget);
  });

  testWidgets('food card opens its existing detail route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const FavoritesPage(),
        routes: {
          AppRoutes.product('buns'): (_) =>
              const Scaffold(body: Text('Detail produk contoh')),
        },
      ),
    );
    await tester.tap(find.text('Mawar Coconut Buns (Isi 5 pcs)'));
    await tester.pumpAndSettle();
    expect(find.text('Detail produk contoh'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('favorites fits $width at scale $scale', (tester) async {
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
            home: const FavoritesPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
