import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';

import '../../helpers/font_test_utils.dart';

Future<void> _openWelcome(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.padding = const FakeViewPadding(top: 24, bottom: 24);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetPadding);
  await tester.pumpWidget(const PanganKitaApp());
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  for (final size in const [Size(320, 640), Size(360, 640), Size(390, 700)]) {
    testWidgets('welcome actions are initially visible at $size', (
      tester,
    ) async {
      await _openWelcome(tester, size);
      final register = find.widgetWithText(FilledButton, 'Daftar');
      final login = find.widgetWithText(TextButton, 'Login');
      for (final action in [register, login]) {
        expect(action.hitTestable(), findsOneWidget);
        expect(tester.getRect(action).top, greaterThanOrEqualTo(24));
        expect(
          tester.getRect(action).bottom,
          lessThanOrEqualTo(size.height - 24),
        );
      }
      expect(tester.takeException(), isNull);
      await tester.tap(login);
      await tester.pumpAndSettle();
      expect(find.byType(AuthPage), findsOneWidget);
    });
  }

  testWidgets('welcome registration is reachable without scrolling', (
    tester,
  ) async {
    await _openWelcome(tester, const Size(360, 640));
    await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });

  testWidgets('welcome remains scrollable in a constrained large-text window', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _openWelcome(tester, const Size(320, 480));
    final login = find.widgetWithText(TextButton, 'Login');
    await tester.scrollUntilVisible(login, 150);
    await tester.pumpAndSettle();
    expect(login.hitTestable(), findsOneWidget);
    expect(
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels,
      greaterThan(0),
    );
    expect(tester.takeException(), isNull);
  });
}
