import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';

const _logoWidthFraction = .78;

/// Brief brand introduction; the entire screen can also be tapped to continue.
class SplashPage extends StatefulWidget {
  /// Creates the introduction.
  const new({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1700), _continue);
  }

  void _continue() {
    if (!mounted || _leaving) return;
    _leaving = true;
    _timer?.cancel();
    Navigator.pushReplacement<void, void>(
      context,
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: AppRoutes.welcome),
        transitionDuration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WelcomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ).ignore();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Semantics(
        button: true,
        label: 'Lanjut ke sambutan',
        child: InkWell(
          onTap: _continue,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: _logoWidthFraction,
              child: Image.asset(
                'assets/prototype/splash.webp',
                semanticLabel: 'Logo PanganKita',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
