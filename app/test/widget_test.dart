import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_app.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/food_detail_sheet.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/auth_validation.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';
import 'package:pangankita/features/onboarding/password_success_page.dart';
import 'package:pangankita/features/onboarding/splash_page.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';

void main() {
  Future<void> welcome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PanganKitaApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  test('validation rejects malformed email and weak passwords', () {
    expect(AuthValidation.email('example@food.id'), isNull);
    expect(AuthValidation.email('bad address@food.id'), isNotNull);
    expect(AuthValidation.email('bad@food'), isNotNull);
    expect(AuthValidation.password('short1'), isNotNull);
    expect(AuthValidation.password('onlyletters'), isNotNull);
    expect(AuthValidation.password('GoodPassword1'), isNull);
  });

  testWidgets('splash continues to welcome and preserves the brand', (
    tester,
  ) async {
    await welcome(tester);
    expect(find.byType(WelcomePage), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'PanganKita');
    expect(app.theme?.textTheme.bodyMedium?.fontFamily, 'Liberation Sans');
    expect(app.theme?.textTheme.headlineLarge?.fontFamily, 'Liberation Sans');
    expect(
      app.theme?.filledButtonTheme.style?.textStyle?.resolve({})?.fontFamily,
      'Liberation Sans',
    );
    expect(app.theme?.colorScheme.primary, PanganKitaColors.brandPrimary);
  });

  testWidgets('opening logo stays visible then fades to Daftar', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PanganKitaApp());
    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.bySemanticsLabel('Logo PanganKita'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.byType(WelcomePage), findsNothing);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 175));
    final fade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.byType(WelcomePage),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(fade.opacity.value, closeTo(.5, .05));
    await tester.pumpAndSettle();
    expect(find.byType(SplashPage), findsNothing);
    expect(find.text('Daftar'), findsOneWidget);
    final registerLabel = tester.widget<Text>(find.text('Daftar'));
    expect(registerLabel.style?.fontFamily, 'Satoshi');
    expect(registerLabel.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('login validates input and opens the local feed', (tester) async {
    await welcome(tester);
    await tester.ensureVisible(find.text('Login'));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Kolom wajib diisi.'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).at(0), 'demo@food.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'DemoPass1');
    await tester.tap(find.byTooltip('Tampilkan password'));
    await tester.pump();
    expect(find.byTooltip('Sembunyikan password'), findsOneWidget);
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('registration requires matching passwords and the demo OTP', (
    tester,
  ) async {
    await welcome(tester);
    await tester.ensureVisible(find.text('Daftar'));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Demo');
    await tester.enterText(fields.at(1), 'demo@food.id');
    await tester.enterText(fields.at(2), 'DemoPass1');
    await tester.enterText(fields.at(3), 'WrongPass1');
    await tester.ensureVisible(find.text('Daftar').first);
    await tester.tap(find.text('Daftar').first);
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi password tidak cocok.'), findsOneWidget);
    await tester.enterText(fields.at(3), 'DemoPass1');
    await tester.ensureVisible(find.text('Daftar').first);
    await tester.tap(find.text('Daftar').first);
    await tester.pumpAndSettle();
    expect(find.byType(OtpPage), findsOneWidget);
    await tester.tap(find.text('Verifikasi'));
    await tester.pump();
    expect(find.text('Kode demo tidak cocok. Gunakan 5102.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '5102');
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('password recovery verifies OTP and returns to login', (
    tester,
  ) async {
    await welcome(tester);
    await tester.ensureVisible(find.text('Login'));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lupa Password?'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '5102');
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'NewPassword1');
    await tester.enterText(find.byType(TextFormField).at(1), 'NewPassword1');
    await tester.tap(find.text('Simpan Password'));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordSuccessPage), findsOneWidget);
    await tester.ensureVisible(find.text('Kembali ke Login'));
    await tester.tap(find.text('Kembali ke Login'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang kembali!'), findsOneWidget);
  });

  testWidgets('search, category filters, empty results and details work', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const HomePage()),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Mawar');
    await tester.pumpAndSettle();
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsOneWidget);
    await tester.ensureVisible(find.text('Mawar Coconut Buns (Isi 5 pcs)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mawar Coconut Buns (Isi 5 pcs)'));
    await tester.pumpAndSettle();
    expect(find.byType(FoodDetailSheet), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Simulasi Saja — Tidak Bisa Dipesan'),
      100,
      scrollable: find.descendant(
        of: find.byType(FoodDetailSheet),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Simulasi Saja — Tidak Bisa Dipesan'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byTooltip('Tutup detail'),
      -100,
      scrollable: find.descendant(
        of: find.byType(FoodDetailSheet),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Tutup detail'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(TextField),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'no such food');
    await tester.pumpAndSettle();
    expect(
      find.text('Tidak ada makanan yang cocok dengan pencarianmu.'),
      findsWidgets,
    );
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.byTooltip('Filter makanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Roti & Pastry'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Roti Abon Ayam'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Roti Abon Ayam'), findsOneWidget);
    expect(find.text('Mawar Coconut Buns (Isi 5 pcs)'), findsNothing);
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('screens fit width $width at text scale $scale', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        for (final page in <Widget>[
          const WelcomePage(),
          const AuthPage.login(),
          const AuthPage.register(),
          const OtpPage(),
          const AuthPage.password(),
          const PasswordSuccessPage(),
          const HomePage(),
        ]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: PanganKitaTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                  viewInsets: const EdgeInsets.only(bottom: 280),
                ),
                child: child ?? const SizedBox.shrink(),
              ),
              home: page,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$page');
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });
    }
  }
}
