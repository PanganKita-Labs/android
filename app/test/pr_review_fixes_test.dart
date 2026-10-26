import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/hero_banner.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';

import 'font_test_utils.dart';

String _digit(WidgetTester tester, int index) => tester
    .widget<TextField>(find.byType(TextField).at(index))
    .controller!
    .text
    .replaceAll(RegExp('[^0-9]'), '');

bool _focused(WidgetTester tester, int index) => tester
    .widget<TextField>(find.byType(TextField).at(index))
    .focusNode!
    .hasFocus;

Future<void> _openOtp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: PanganKitaTheme.light,
      home: const OtpPage(),
      routes: {
        AppRoutes.home: (context) => const Scaffold(body: Text('Demo home')),
      },
    ),
  );
  await tester.pumpAndSettle();
}

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

  testWidgets('OTP paste and replacement edit preserve one digit per cell', (
    tester,
  ) async {
    await _openOtp(tester);
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, '5102');
    await tester.pump();
    expect(
      [for (var i = 0; i < 4; i++) _digit(tester, i)],
      ['5', '1', '0', '2'],
    );
    await tester.tap(fields.at(1));
    await tester.pump();
    expect(
      tester.widget<TextField>(fields.at(1)).controller!.selection,
      const TextSelection(baseOffset: 0, extentOffset: 1),
    );
    await tester.enterText(fields.at(1), '9');
    await tester.pump();
    expect(
      [for (var i = 0; i < 4; i++) _digit(tester, i)],
      ['5', '9', '0', '2'],
    );
    expect(_focused(tester, 2), isTrue);
    await tester.ensureVisible(find.text('Verifikasi'));
    await tester.tap(find.text('Verifikasi'));
    await tester.pump();
    expect(find.textContaining('Kode demo tidak cocok'), findsOneWidget);
    await tester.enterText(fields.at(1), '1');
    await tester.ensureVisible(find.text('Verifikasi'));
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Demo home'), findsOneWidget);
  });

  testWidgets('OTP full-code autofill works from a middle cell', (
    tester,
  ) async {
    await _openOtp(tester);
    await tester.enterText(find.byType(TextField).at(2), '5102');
    await tester.pump();
    expect(
      [for (var i = 0; i < 4; i++) _digit(tester, i)],
      ['5', '1', '0', '2'],
    );
    await tester.ensureVisible(find.text('Verifikasi'));
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Demo home'), findsOneWidget);
  });

  testWidgets('OTP software deletion moves back only from an empty cell', (
    tester,
  ) async {
    await _openOtp(tester);
    await tester.enterText(find.byType(TextField).first, '51');
    await tester.pump();
    expect(_focused(tester, 2), isTrue);
    tester.testTextInput.updateEditingValue(TextEditingValue.empty);
    await tester.pump();
    expect(_focused(tester, 1), isTrue);
    expect(_digit(tester, 1), '1');
    tester.testTextInput.updateEditingValue(TextEditingValue.empty);
    await tester.pump();
    expect(_focused(tester, 1), isTrue);
    expect(_digit(tester, 1), isEmpty);
    tester.testTextInput.updateEditingValue(TextEditingValue.empty);
    await tester.pump();
    expect(_focused(tester, 0), isTrue);
    expect(_digit(tester, 0), '5');
  });

  testWidgets(
    'OTP hardware backspace handles empty cells and the first boundary',
    (tester) async {
      await _openOtp(tester);
      await tester.enterText(find.byType(TextField).first, '51');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(_focused(tester, 1), isTrue);
      expect(_digit(tester, 1), '1');
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(_digit(tester, 1), isEmpty);
      expect(_focused(tester, 1), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(_focused(tester, 0), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(_digit(tester, 0), isEmpty);
      expect(_focused(tester, 0), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('OTP supports filtered paste from the middle and resend reset', (
    tester,
  ) async {
    await _openOtp(tester);
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, '5');
    await tester.enterText(fields.at(1), '10 2x');
    await tester.pump();
    expect(
      [for (var i = 0; i < 4; i++) _digit(tester, i)],
      ['5', '1', '0', '2'],
    );
    await tester.ensureVisible(find.text('Kirim Ulang'));
    await tester.tap(find.text('Kirim Ulang'));
    await tester.pumpAndSettle();
    expect([for (var i = 0; i < 4; i++) _digit(tester, i)], ['', '', '', '']);
    expect(_focused(tester, 0), isTrue);
  });

  testWidgets(
    'croissant CTA reports unavailable promotion without unrelated details',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PanganKitaTheme.light,
          home: const Scaffold(body: HeroBanner()),
        ),
      );
      await tester.tap(find.text('Pesan Sekarang!'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Promo croissant belum tersedia'),
        findsOneWidget,
      );
      expect(find.byType(ProductDetailPage), findsNothing);
    },
  );
}
