import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/food_card.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);
  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('pickup cards fit $width at text scale $scale', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final food in DemoFood.examples) {
          await tester.pumpWidget(
            MaterialApp(
              theme: PanganKitaTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child ?? const SizedBox.shrink(),
              ),
              home: Scaffold(
                body: ListView(
                  padding: const EdgeInsets.all(23),
                  children: [FoodCard(food: food)],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: food.id);
          expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
          expect(
            find.bySemanticsLabel(
              RegExp('Badge contoh; merchant belum diverifikasi'),
            ),
            findsWidgets,
          );
          expect(find.byIcon(Icons.check_circle), findsOneWidget);
          expect(
            find.textContaining(food.pickupTime, findRichText: true),
            findsOneWidget,
          );
          expect(find.textContaining('Ongkir'), findsNothing);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });
    }
  }
}
