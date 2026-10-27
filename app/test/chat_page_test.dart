import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/chat_page.dart';
import 'package:pangankita/features/discovery/home_page.dart';

import 'font_test_utils.dart';

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
        },
      ),
    );
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.textContaining('belum ada percakapan nyata'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Soto');
    await tester.pumpAndSettle();
    expect(find.text('Soto Kesawan'), findsOneWidget);
    expect(find.text('Mawar Bakery & Cake'), findsNothing);
    await tester.tap(find.text('Soto Kesawan'));
    await tester.pump();
    expect(
      find.text('Fitur ini belum tersedia dalam demo offline.'),
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
      });
    }
  }
}
