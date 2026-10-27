import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/checkout_page.dart';
import 'package:pangankita/features/discovery/demo_addon.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/payment_status_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets(
    'demo payment requires acknowledgement and leaves cart unchanged',
    (tester) async {
      final cart = DemoCart();
      addTearDown(cart.dispose);
      expect(
        cart.add(
          DemoFood.examples.first,
          quantity: 2,
          addons: {DemoAddon.cheese},
        ),
        isTrue,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: PanganKitaTheme.light,
          home: CheckoutPage(cart: cart),
          routes: {
            AppRoutes.paymentStatus: (context) => PaymentStatusPage(cart: cart),
          },
        ),
      );
      await tester.pumpAndSettle();
      final payment = find.widgetWithText(FilledButton, 'Bayar Sekarang');
      expect(tester.widget<FilledButton>(payment).onPressed, isNull);
      expect(find.text('Rp84.000'), findsWidgets);
      await tester.scrollUntilVisible(find.byType(Checkbox), 150);
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('ketentuan pengambilan.'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ketentuan pengambilan.'));
      await tester.pumpAndSettle();
      expect(find.text('Ketentuan pengambilan (demo)'), findsOneWidget);
      expect(
        find.textContaining('Ketentuan layanan sebenarnya belum tersedia.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(payment).onPressed, isNull);
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(payment).onPressed, isNotNull);
      await tester.tap(payment);
      await tester.pumpAndSettle();
      expect(find.byType(PaymentStatusPage), findsOneWidget);
      expect(find.text('Pembayaran belum tersedia'), findsOneWidget);
      expect(cart.itemCount, 2);
      expect(cart.subtotal, 84000);
      expect(cart.lines.single.addons, [DemoAddon.cheese]);
    },
  );

  testWidgets(
    'checkout reflects current cart totals and handles an empty cart',
    (tester) async {
      final cart = DemoCart();
      addTearDown(cart.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: PanganKitaTheme.light,
          home: CheckoutPage(cart: cart),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Keranjang kosong.'), findsOneWidget);
      expect(find.text('Bayar Sekarang'), findsNothing);
      expect(cart.add(DemoFood.examples.first), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Rp32.000'), findsWidgets);
      cart.setQuantity(cart.lines.first.id, 3);
      await tester.pumpAndSettle();
      expect(find.text('Rp96.000'), findsWidgets);
      cart.clear();
      await tester.pumpAndSettle();
      expect(find.textContaining('Keranjang kosong.'), findsOneWidget);
      expect(find.text('Bayar Sekarang'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('checkout fits $width with text scale $scale', (
        tester,
      ) async {
        final cart = DemoCart();
        addTearDown(cart.dispose);
        expect(
          cart.add(DemoFood.examples.first, addons: DemoAddon.values.toSet()),
          isTrue,
        );
        expect(cart.add(DemoFood.examples[1]), isTrue);
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
            home: CheckoutPage(cart: cart),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('Rincian pesanan'), 150);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.byType(Checkbox), 150);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
