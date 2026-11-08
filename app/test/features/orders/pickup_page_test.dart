import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/orders/orders_page.dart';
import 'package:pangankita/features/orders/pickup_page.dart';
import 'package:pangankita/shared/models/demo_food.dart';

import '../../helpers/font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('completed example opens pickup and returns to orders', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const OrdersPage(),
        routes: {
          AppRoutes.pickup: (context) {
            final example =
                ModalRoute.of(context)!.settings.arguments!
                    as ({DemoFood food, int quantity});
            return PickupPage(food: example.food, quantity: example.quantity);
          },
        },
      ),
    );
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lihat Detail').first);
    await tester.tap(find.text('Lihat Detail').first);
    await tester.pumpAndSettle();
    expect(find.byType(PickupPage), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsNothing);
    expect(find.textContaining('Belum ada pengambilan nyata'), findsOneWidget);
    expect(find.text('Belum tersedia'), findsWidgets);
    expect(find.text('MWR-028'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    testWidgets('pickup fits $width with enlarged text', (tester) async {
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
          home: PickupPage(food: DemoFood.examples.first, quantity: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
