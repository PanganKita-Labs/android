import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/cart_page.dart';
import 'package:pangankita/features/discovery/demo_addon.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('cart updates totals, removes lines and shows the empty state', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    expect(cart.add(DemoFood.examples.first), isTrue);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: CartPage(cart: cart),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ambil di toko'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Jadwal contoh Mawar Bakery'), findsOneWidget);
    await tester.tap(find.byTooltip('Tambah ${DemoFood.examples.first.title}'));
    await tester.pumpAndSettle();
    expect(cart.subtotal, 64000);
    expect(find.text('Rp64.000'), findsWidgets);
    await tester.tap(find.text('Lanjut Checkout'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Checkout belum tersedia.'), findsOneWidget);
    await tester.tap(find.byTooltip('Hapus ${DemoFood.examples.first.title}'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjangmu masih kosong'), findsOneWidget);
    expect(find.text('Lanjut Checkout'), findsNothing);
  });

  testWidgets('cart survives route changes and the Home cart button opens it', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final navigator = tester.state<NavigatorState>(find.byType(Navigator))
      ..pushNamed<void>(AppRoutes.product(DemoFood.examples.first.id));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Tambah ke Keranjang (Demo)'),
      200,
    );
    await tester.ensureVisible(find.text('Tambah ke Keranjang (Demo)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah ke Keranjang (Demo)'));
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
    navigator
      ..pop()
      ..pop()
      ..pushNamed<void>(AppRoutes.home);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text(DemoFood.examples.first.title), findsOneWidget);
    await tester.tap(find.text('Hapus Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjangmu masih kosong'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('cart fits $width with text scale $scale and keyboard', (
        tester,
      ) async {
        final cart = DemoCart();
        addTearDown(cart.dispose);
        expect(
          cart.add(DemoFood.examples.first, addons: DemoAddon.values.toSet()),
          isTrue,
        );
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        await tester.pumpWidget(
          MaterialApp(
            theme: PanganKitaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                viewInsets: const EdgeInsets.only(bottom: 240),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            home: CartPage(cart: cart),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.byType(TextField),
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(find.byType(TextField), 'Kemasan dipisah');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Ringkasan pesanan'),
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
