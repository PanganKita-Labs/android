import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/onboarding/social_sign_in.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);
  testWidgets('social artwork matches the reference and stays demo-only', (
    tester,
  ) async {
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
    final caption = find.text('Lanjutkan dengan');
    final captionStyle = DefaultTextStyle.of(tester.element(caption)).style
        .merge(tester.widget<Text>(caption).style);
    expect(captionStyle.fontFamily, 'Satoshi');
    expect(captionStyle.fontWeight, FontWeight.w500);
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byType(RepaintBoundary).last,
    );
    final providerRow = tester.renderObject<RenderBox>(
      find.descendant(
        of: find.byType(SocialSignIn),
        matching: find.byType(Row),
      ),
    );
    final origin = providerRow.localToGlobal(Offset.zero, ancestor: boundary);
    final layer = boundary.debugLayer! as OffsetLayer;
    final artwork = await tester.runAsync(
      () => layer.toImage(origin & providerRow.size),
    );
    try {
      await expectLater(
        artwork,
        matchesGoldenFile('goldens/social_provider_buttons.png'),
      );
    } finally {
      artwork?.dispose();
    }
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
