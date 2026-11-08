import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/features/onboarding/splash_page.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android launches and transitions from splash to welcome', (
    tester,
  ) async {
    await tester.pumpWidget(const PanganKitaApp());
    expect(find.byType(SplashPage), findsOneWidget);

    // The real splash uses a 1700 ms timer and a short fade transition.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
