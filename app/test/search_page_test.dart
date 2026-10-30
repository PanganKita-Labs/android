import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';
import 'package:pangankita/features/discovery/search_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Home search submission opens local results and filters', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {
          AppRoutes.search: (context) => SearchPage(
            initialQuery:
                ModalRoute.of(context)?.settings.arguments as String? ?? '',
          ),
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'Roti');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Hasil untuk “Roti”'), findsOneWidget);
    expect(find.text('Best Cheesy Garlic Bread'), findsOneWidget);
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsOneWidget);
    await tester.tap(find.byTooltip('Filter pencarian'));
    await tester.pumpAndSettle();
    expect(find.text('Filter Pencarian'), findsOneWidget);
    expect(find.textContaining('Filter jarak belum tersedia'), findsOneWidget);
    await tester.ensureVisible(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Hasil untuk “Roti”'), findsOneWidget);
  });

  testWidgets('empty search offers actions and recommendations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SearchPage(initialQuery: 'Sushi'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Belum ketemu makananmu'), findsOneWidget);
    expect(find.text('Ubah Pencarian'), findsOneWidget);
    expect(find.text('Reset Filter'), findsOneWidget);
    expect(find.text('Mungkin Kamu Suka'), findsOneWidget);
    await tester.tap(find.text('Ubah Pencarian'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byType(TextField).first)
          .focusNode
          ?.hasFocus,
      isTrue,
    );
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Mawar Coconut Buns (Isi 5 pcs)'));
    await tester.tap(find.text('Mawar Coconut Buns (Isi 5 pcs)'));
    await tester.pumpAndSettle();
    expect(find.text('1 makanan contoh ditemukan'), findsOneWidget);
  });

  testWidgets('bakery search result opens its product example', (tester) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SearchPage(initialQuery: 'Garlic'),
        routes: {
          AppRoutes.product(DemoFood.garlicBread.id): (context) =>
              ProductDetailPage(food: DemoFood.garlicBread, cart: cart),
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Best Cheesy Garlic Bread'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('price filter and reset update local results', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SearchPage(initialQuery: 'Roti'),
      ),
    );
    await tester.tap(find.byTooltip('Filter pencarian'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '30000');
    await tester.ensureVisible(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('2 makanan contoh ditemukan'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter pencarian'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.ensureVisible(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('3 makanan contoh ditemukan'), findsOneWidget);
  });

  testWidgets('price filter rejects negative and reversed ranges', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SearchPage(initialQuery: 'Roti'),
      ),
    );
    await tester.tap(find.byTooltip('Filter pencarian'));
    await tester.pumpAndSettle();
    final minimum = find.byType(TextField).at(1);
    final maximum = find.byType(TextField).at(2);
    await tester.enterText(minimum, '-1');
    await tester.ensureVisible(find.text('Tampilkan Hasil'));
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan rentang harga yang valid.'), findsOneWidget);
    await tester.enterText(minimum, '10000');
    await tester.enterText(maximum, '-5');
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan rentang harga yang valid.'), findsOneWidget);
    await tester.enterText(minimum, '50000');
    await tester.enterText(maximum, '10000');
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan rentang harga yang valid.'), findsOneWidget);
    await tester.enterText(minimum, '10000');
    await tester.enterText(maximum, '50000');
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Filter Pencarian'), findsNothing);
  });

  testWidgets('empty result reset restores locally filtered cards', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const SearchPage(initialQuery: 'Roti'),
      ),
    );
    await tester.tap(find.byTooltip('Filter pencarian'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '90000');
    await tester.ensureVisible(find.text('Tampilkan Hasil'));
    await tester.tap(find.text('Tampilkan Hasil'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ketemu makananmu'), findsOneWidget);
    await tester.tap(find.text('Reset Filter'));
    await tester.pumpAndSettle();
    expect(find.text('3 makanan contoh ditemukan'), findsOneWidget);
    expect(find.text('Jarak belum tersedia'), findsWidgets);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('search fits $width at scale $scale', (tester) async {
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
            home: const SearchPage(initialQuery: 'Roti'),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Filter pencarian'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
