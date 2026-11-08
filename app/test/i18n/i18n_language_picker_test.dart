import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Settings language row opens the real language picker', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PanganKitaApp());
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pushNamed<void>(AppRoutes.settings).ignore();
    await tester.pumpAndSettle();

    final languageRow = find.text('Bahasa');
    expect(languageRow, findsOneWidget);
    await tester.ensureVisible(languageRow);
    await tester.tap(languageRow);
    await tester.pumpAndSettle();

    expect(find.text('Bahasa Indonesia'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Mandarin Sederhana'), findsOneWidget);
    expect(
      find.text('Fitur ini belum tersedia dalam demo offline.'),
      findsNothing,
    );

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('en'));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
