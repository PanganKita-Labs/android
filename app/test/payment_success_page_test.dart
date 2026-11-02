import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/payment_status_page.dart';
import 'package:pangankita/features/discovery/payment_success_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('payment page opens an honest success-layout example', (
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
          AppRoutes.paymentSuccessPreview: (context) =>
              PaymentSuccessPage(cart: cart),
          AppRoutes.orders: (context) => const Scaffold(body: Text('Orders')),
        },
      ),
    );
    await tester.tap(find.text('Lihat contoh pembayaran berhasil'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentSuccessPage), findsOneWidget);
    expect(find.text('Contoh pembayaran berhasil'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsNWidgets(4));
    expect(find.text('Lunas'), findsNothing);
    expect(find.text('Rp32.000'), findsWidgets);
    expect(cart.itemCount, 1);
    await tester.tap(find.text('Lihat contoh pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Orders'), findsOneWidget);
    expect(cart.itemCount, 1);
  });

  testWidgets('empty cart has no success claim', (tester) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentSuccessPage(cart: cart),
      ),
    );
    expect(find.textContaining('Keranjang kosong.'), findsOneWidget);
    expect(find.text('Contoh pembayaran berhasil'), findsNothing);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    testWidgets('success preview fits $width with enlarged text', (
      tester,
    ) async {
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
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child ?? const SizedBox.shrink(),
          ),
          home: PaymentSuccessPage(cart: cart),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -800));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
