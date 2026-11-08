import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/messaging/chat_page.dart';
import 'package:pangankita/features/messaging/merchant_chat_page.dart';
import 'package:pangankita/shared/models/demo_food.dart';

import '../../helpers/font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Chat opens from Home and filters example conversations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.chat: (context) => const ChatPage(),
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
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.textContaining('belum ada percakapan nyata'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsOneWidget);
    expect(find.text('10.42'), findsNWidgets(2));
    expect(find.text('Kemarin'), findsOneWidget);
    expect(find.text('22 Okt'), findsOneWidget);
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Soto');
    await tester.pumpAndSettle();
    expect(find.text('Soto Kesawan'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsNothing);
    await tester.tap(find.text('Soto Kesawan'));
    await tester.pumpAndSettle();
    expect(find.byType(MerchantChatPage), findsOneWidget);
    expect(
      find.text('Baik, kak. Pesanan sedang kami siapkan.'),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('Chat fits $width at text scale $scale', (tester) async {
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
            home: const ChatPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Belum dibaca'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Kemarin'), findsNothing);
        expect(find.text('10.42'), findsNWidgets(2));
      });
    }
  }
}
