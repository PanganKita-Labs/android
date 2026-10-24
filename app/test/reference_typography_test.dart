import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';

void main() {
  testWidgets('login heading preserves the HTML Arial metrics', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.runAsync(() async {
      final fonts = FontLoader(PanganKitaTheme.referenceFontFamily)
        ..addFont(rootBundle.load('assets/fonts/LiberationSans-Regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/LiberationSans-Bold.ttf'));
      await fonts.load();
    });
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const AuthPage.login()),
    );
    await tester.pumpAndSettle();
    final heading = find.text('Selamat datang kembali!');
    final widget = tester.widget<Text>(heading);
    final inheritedStyle = DefaultTextStyle.of(tester.element(heading)).style;
    final painter = TextPainter(
      text: TextSpan(
        text: widget.data,
        style: inheritedStyle.merge(widget.style),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 332);
    addTearDown(painter.dispose);
    expect(painter.computeLineMetrics(), hasLength(1));
    // Chromium's supplied HTML measures 303.96875 px for the same heading.
    // Allow rasterizer rounding; Roboto is about 20px narrower.
    expect(painter.width, closeTo(303.96875, 1));
    tester.view.physicalSize = const Size(360, 844);
    await tester.pumpAndSettle();
    expect(
      tester.getSize(heading).height,
      lessThan(34),
      reason: 'The HTML keeps this heading on one line at 360px.',
    );
  });
}
