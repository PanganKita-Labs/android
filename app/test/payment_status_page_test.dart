import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/payment_status_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('status stays a preview and reads the current cart', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    expect(cart.add(DemoFood.examples.first), isTrue);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentStatusPage(cart: cart),
        routes: {
          AppRoutes.home: (context) => const Scaffold(body: Text('Home')),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran belum tersedia'), findsOneWidget);
    expect(
      find.text('Belum ada tagihan yang perlu diselesaikan.'),
      findsOneWidget,
    );
    expect(find.text('Rp32.000'), findsWidgets);
    expect(find.text(DemoFood.examples.first.merchant), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Status pratinjau'), 150);
    await tester.pumpAndSettle();
    expect(find.text('QR belum tersedia'), findsOneWidget);
    expect(find.text('ID Pesanan'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsWidgets);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Simpan QR'),
          )
          .onPressed,
      isNull,
    );
    expect(cart.itemCount, 1);
    expect(cart.subtotal, 32000);
    expect(find.text('Lunas'), findsNothing);
    expect(find.text('Kode pengambilan'), findsNothing);

    cart.setQuantity(cart.lines.single.id, 2);
    await tester.pumpAndSettle();
    expect(find.text('Rp64.000'), findsWidgets);
    expect(cart.itemCount, 2);
    await tester.tap(find.text('Kembali ke Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(cart.itemCount, 2);
  });

  testWidgets('empty cart has no payment actions', (tester) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentStatusPage(cart: cart),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Keranjang kosong.'), findsOneWidget);
    expect(find.text('Kembali ke Checkout'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('status fits $width at text scale $scale', (tester) async {
        final cart = DemoCart();
        addTearDown(cart.dispose);
        expect(cart.add(DemoFood.examples.first), isTrue);
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
                padding: const EdgeInsets.only(top: 24, bottom: 24),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            home: PaymentStatusPage(cart: cart),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('ID Pesanan'), 150);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
