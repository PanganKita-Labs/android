import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/orders_page.dart';
import 'package:pangankita/features/discovery/review_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('home orders tab opens an honest preview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.review: (context) {
            final example =
                ModalRoute.of(context)!.settings.arguments!
                    as ({DemoFood food, int quantity});
            return ReviewPage(food: example.food, quantity: example.quantity);
          },
        },
      ),
    );
    await tester.tap(find.text('Pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Contoh pesanan aktif'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsWidgets);
    expect(find.text('Siap diambil'), findsNothing);
    expect(find.text('MWR-28'), findsNothing);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.textContaining('belum ada pesanan selesai'), findsOneWidget);
    expect(find.text('Rp57.000'), findsOneWidget);
    expect(find.text('Waktu diambil: Belum tersedia'), findsWidgets);
    expect(find.text('Sudah diulas'), findsNothing);
    await tester.ensureVisible(find.text('Beri Ulasan').first);
    await tester.tap(find.text('Beri Ulasan').first);
    await tester.pumpAndSettle();
    expect(find.byType(ReviewPage), findsOneWidget);
    expect(find.text('2 × Rp28.500'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dibatalkan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('belum ada pesanan dibatalkan'), findsOneWidget);
    expect(find.text('Alasan pembatalan: Belum tersedia'), findsOneWidget);
    expect(find.text('Pembayaran melewati batas waktu.'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    await tester.ensureVisible(find.text('Cari Menu Lain'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cari Menu Lain'));
    await tester.pumpAndSettle();
    expect(find.text('Kategori'), findsOneWidget);
  });

  testWidgets('Cari pesanan filters local order examples', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const OrdersPage()),
    );
    await tester.tap(find.byTooltip('Cari pesanan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Mawar');
    await tester.pumpAndSettle();
    expect(find.text('Mawar Bakery & Cake'), findsOneWidget);
    expect(find.text('Soto Kesawan'), findsNothing);
    await tester.enterText(find.byType(TextField), 'tidak ada');
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada pesanan contoh yang cocok.'), findsOneWidget);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada pesanan contoh yang cocok.'), findsOneWidget);
    await tester.tap(find.text('Dibatalkan'));
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada pesanan contoh yang cocok.'), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('orders fit $width at text scale $scale', (tester) async {
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
            home: const OrdersPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('Detail Pesanan').last, 120);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView), const Offset(0, 1000));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Selesai'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('Beri Ulasan').last, 120);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView), const Offset(0, 1000));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Dibatalkan'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Pesanan yang dibatalkan akan muncul di sini.'),
          120,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
