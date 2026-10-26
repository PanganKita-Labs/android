import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';
import 'package:pangankita/features/onboarding/password_success_page.dart';
import 'package:pangankita/features/onboarding/splash_page.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';

/// Application composition for the native Flutter reference conversion.
class PanganKitaApp extends StatelessWidget {
  /// Creates the local prototype without server authentication or payments.
  const new({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PanganKita',
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.splash,
    theme: PanganKitaTheme.light,
    routes: {
      AppRoutes.splash: (context) => const SplashPage(),
      AppRoutes.welcome: (context) => const WelcomePage(),
      AppRoutes.login: (context) => const AuthPage.login(),
      AppRoutes.register: (context) => const AuthPage.register(),
      AppRoutes.verify: (context) => const OtpPage(),
      AppRoutes.recover: (context) => const OtpPage(recovery: true),
      AppRoutes.password: (context) => const AuthPage.password(),
      AppRoutes.success: (context) => const PasswordSuccessPage(),
      AppRoutes.home: (context) => const HomePage(),
      for (final food in DemoFood.examples)
        AppRoutes.product(food.id): (context) => ProductDetailPage(food: food),
    },
  );
}
