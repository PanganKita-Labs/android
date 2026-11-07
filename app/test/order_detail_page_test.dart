import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/orders/order_detail_page.dart';
import 'package:pangankita/features/orders/orders_page.dart';
import 'package:pangankita/shared/models/demo_food.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('active example opens its own detail without a pickup code', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const OrdersPage(),
        routes: {
          AppRoutes.orderDetail: (context) => OrderDetailPage(
            food: ModalRoute.of(context)!.settings.arguments! as DemoFood,
          ),
        },
      ),
    );
    await tester.ensureVisible(find.text('Detail Pesanan').first);
    await tester.tap(find.text('Detail Pesanan').first);
    await tester.pumpAndSettle();
    expect(find.byType(OrderDetailPage), findsOneWidget);
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsWidgets);
    expect(find.text('MWR-028'), findsNothing);
    await tester.tap(find.byTooltip('Buka Bantuan Pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Bantuan Pesanan'), findsWidgets);
    expect(find.text('ID pesanan belum tersedia'), findsOneWidget);
    expect(find.textContaining('Pengambilan belum tersedia'), findsOneWidget);
    await tester.tap(find.text('Pesanan belum siap'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Status persiapan belum tersedia'),
      findsOneWidget,
    );
    await tester.tap(find.text('Hubungi Customer Service'));
    await tester.pump();
    expect(
      find.text('Fitur ini belum tersedia dalam demo offline.'),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Tutup Bantuan Pesanan'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('detail fits $width at scale $scale', (tester) async {
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
            home: OrderDetailPage(food: DemoFood.examples.first),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(ListView), const Offset(0, -1000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Bantuan Pesanan'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
