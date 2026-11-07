import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/orders/pickup_page.dart';
import 'package:pangankita/features/orders/review_page.dart';
import 'package:pangankita/shared/models/demo_food.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('app route opens review from completed orders', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .pushNamed(AppRoutes.orders)
        .ignore();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Beri Ulasan').first);
    await tester.tap(find.text('Beri Ulasan').first);
    await tester.pumpAndSettle();
    expect(find.text('Contoh ulasan tidak tersedia.'), findsNothing);
    expect(find.text('Pesanan'), findsNothing);
    expect(find.byType(ReviewPage), findsOneWidget);
  });

  testWidgets('pickup opens a local review form without submitting', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: PickupPage(food: DemoFood.examples.first, quantity: 1),
        routes: {
          AppRoutes.review: (context) {
            final example =
                ModalRoute.of(context)!.settings.arguments!
                    as ({DemoFood food, int quantity});
            return ReviewPage(food: example.food, quantity: example.quantity);
          },
        },
      ),
    );
    await tester.ensureVisible(find.text('Beri Ulasan'));
    await tester.tap(find.text('Beri Ulasan'));
    await tester.pumpAndSettle();
    expect(find.byType(ReviewPage), findsOneWidget);
    await tester.tap(find.byTooltip('Beri rating 5 bintang'));
    await tester.pump();
    expect(find.text('5 dari 5 bintang · contoh'), findsOneWidget);
    await tester.tap(find.text('Rasa enak'));
    await tester.pump();
    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kirim Ulasan'));
    await tester.pump();
    expect(
      find.text('Fitur ini belum tersedia dalam demo offline.'),
      findsOneWidget,
    );
  });

  testWidgets('review tags form two equal columns', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: ReviewPage(food: DemoFood.examples.first, quantity: 1),
      ),
    );
    final firstTag = find.byKey(const ValueKey('review-tag-Rasa enak'));
    final secondTag = find.byKey(const ValueKey('review-tag-Porsi pas'));
    final thirdTag = find.byKey(const ValueKey('review-tag-Kemasan rapi'));
    final fourthTag = find.byKey(const ValueKey('review-tag-Toko ramah'));
    expect(firstTag, findsOneWidget);
    expect(secondTag, findsOneWidget);
    expect(thirdTag, findsOneWidget);
    expect(fourthTag, findsOneWidget);
    final first = tester.getSize(firstTag);
    final second = tester.getSize(secondTag);
    expect(first.width, second.width);
    expect(tester.getTopLeft(firstTag).dy, tester.getTopLeft(secondTag).dy);
    expect(tester.getSize(thirdTag).width, tester.getSize(fourthTag).width);
    await tester.tap(firstTag);
    await tester.pump();
    expect(
      tester
          .widget<OutlinedButton>(firstTag)
          .style!
          .backgroundColor!
          .resolve({}),
      const Color(0xFFE7F5ED),
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    testWidgets('review fits $width with enlarged text', (tester) async {
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
          home: ReviewPage(food: DemoFood.examples.first, quantity: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
