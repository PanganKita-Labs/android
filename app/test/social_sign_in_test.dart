import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/onboarding/social_sign_in.dart';

void main() {
  testWidgets('social artwork matches the reference and stays demo-only', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final font = FontLoader(PanganKitaTheme.referenceFontFamily)
        ..addFont(rootBundle.load('assets/fonts/LiberationSans-Regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/LiberationSans-Bold.ttf'));
      await font.load();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 332,
              height: 100,
              child: RepaintBoundary(
                child: ColoredBox(
                  color: PanganKitaColors.surfaceWarm,
                  child: SocialSignIn(register: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final provider in ['facebook', 'google', 'apple']) {
        await precacheImage(
          AssetImage('assets/prototype/social-$provider.png'),
          tester.element(find.byType(SocialSignIn)),
        );
      }
    });
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(RepaintBoundary).last,
      matchesGoldenFile(
        // Text rasterization differs on Windows; keep both exact baselines.
        Platform.isWindows
            ? 'goldens/social_sign_in.windows.png'
            : 'goldens/social_sign_in.png',
      ),
    );
    expect(find.text('G'), findsNothing);
    final google = find.descendant(
      of: find.byType(SocialSignIn),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.endsWith(
              'social-google.png',
            ),
      ),
    );
    await tester.tap(google);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Login Google belum terhubung.'),
      findsOneWidget,
    );
  });
}
