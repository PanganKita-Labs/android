import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/messaging/merchant_chat_page.dart';
import 'package:pangankita/features/orders/orders_page.dart';
import 'package:pangankita/shared/models/demo_food.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Chat Toko opens selected merchant and keeps messages local', (
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
          AppRoutes.merchantChat: (context) {
            final example =
                ModalRoute.of(context)!.settings.arguments!
                    as ({DemoFood food, String? message});
            return MerchantChatPage(
              food: example.food,
              previewMessage: example.message,
            );
          },
        },
      ),
    );
    await tester.ensureVisible(find.text('Chat Toko').first);
    await tester.tap(find.text('Chat Toko').first);
    await tester.pumpAndSettle();
    expect(find.byType(MerchantChatPage), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsOneWidget);
    expect(find.textContaining('tidak dikirim atau disimpan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Saya datang pukul 19.30');
    await tester.tap(find.byTooltip('Tambahkan pesan contoh'));
    await tester.pumpAndSettle();
    expect(find.text('Saya datang pukul 19.30'), findsOneWidget);
    expect(find.text('Pesan lokal, tidak terkirim'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Chat Toko').first);
    await tester.tap(find.text('Chat Toko').first);
    await tester.pumpAndSettle();
    expect(find.text('Saya datang pukul 19.30'), findsNothing);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    testWidgets('merchant chat fits $width with enlarged text', (tester) async {
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
          home: MerchantChatPage(
            food: DemoFood.examples.first,
            previewMessage: 'Pesan toko contoh',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
