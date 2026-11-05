import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/payment_failed_page.dart';
import 'package:pangankita/features/discovery/payment_status_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('payment preview opens failed-layout example without charging', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    cart.add(DemoFood.examples.first);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentStatusPage(cart: cart),
        routes: {
          AppRoutes.paymentFailedPreview: (context) =>
              PaymentFailedPage(cart: cart),
        },
      ),
    );
    await tester.tap(find.text('Lihat contoh pembayaran belum berhasil'));
    await tester.pumpAndSettle();
    expect(find.text('Contoh pembayaran belum berhasil'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsOneWidget);
    expect(find.text('Gagal'), findsNothing);
    expect(cart.itemCount, 1);
    await tester.tap(find.text('Coba Bayar Lagi'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentStatusPage), findsOneWidget);
    expect(cart.itemCount, 1);
  });

  testWidgets('multi-merchant failed preview shows every merchant', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    expect(cart.add(DemoFood.examples[0]), isTrue);
    expect(cart.add(DemoFood.examples[1]), isTrue);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentFailedPage(cart: cart),
      ),
    );
    expect(
      find.text(
        '${DemoFood.examples[0].merchant}, ${DemoFood.examples[1].merchant}',
      ),
      findsOneWidget,
    );
    expect(find.text(DemoFood.examples[0].merchant), findsOneWidget);
    expect(find.text(DemoFood.examples[1].merchant), findsOneWidget);
    expect(cart.itemCount, 2);
  });

  testWidgets('empty cart cannot show a failed-payment claim', (tester) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentFailedPage(cart: cart),
      ),
    );
    expect(find.textContaining('Keranjang kosong.'), findsOneWidget);
    expect(find.text('Contoh pembayaran belum berhasil'), findsNothing);
  });

  testWidgets('Ganti Metode Pembayaran shows available preview method', (
    tester,
  ) async {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    cart.add(DemoFood.examples.first);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PaymentFailedPage(cart: cart),
      ),
    );
    await tester.tap(find.text('Ganti Metode Pembayaran'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih metode pembayaran'), findsOneWidget);
    expect(find.text('Metode contoh yang ditampilkan'), findsOneWidget);
    await tester.tap(find.text('Gunakan QRIS (contoh)'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih metode pembayaran'), findsNothing);
    expect(cart.itemCount, 1);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    testWidgets('failed preview fits $width with enlarged text', (
      tester,
    ) async {
      final cart = DemoCart();
      addTearDown(cart.dispose);
      cart.add(DemoFood.examples.first);
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
          home: PaymentFailedPage(cart: cart),
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
