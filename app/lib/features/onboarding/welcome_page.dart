import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

const _headingSize = 30.0;
const _narrowWidth = 320.0;
const _compactWidth = 360.0;
const _narrowContentBudget = 420.0;
const _compactContentBudget = 370.0;
const _regularContentBudget = 360.0;
const _minimumArtworkHeight = 80.0;
const _maximumArtworkHeight = 400.0;

/// Illustrated introduction with reachable actions on shorter phones.
class WelcomePage extends StatelessWidget {
  /// Creates the introduction.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Reserve room for the heading, copy, actions, and bottom padding.
          // Large text or genuinely constrained windows can still scroll.
          final contentBudget = switch (constraints.maxWidth) {
            <= _narrowWidth => _narrowContentBudget,
            <= _compactWidth => _compactContentBudget,
            _ => _regularContentBudget,
          };
          final textScale =
              MediaQuery.textScalerOf(context).scale(_headingSize) /
              _headingSize;
          final artworkHeight =
              (constraints.maxHeight - contentBudget * textScale).clamp(
                _minimumArtworkHeight,
                _maximumArtworkHeight,
              );
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              SizedBox(
                width: double.infinity,
                height: artworkHeight,
                child: Image.asset(
                  'assets/prototype/welcome.webp',
                  excludeFromSemantics: true,
                  fit: BoxFit.contain,
                ),
              ),
              const _WelcomeCopy(),
              const _WelcomeActions(),
            ],
          );
        },
      ),
    ),
  );
}

class _WelcomeCopy extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(left: 29, top: 20, right: 29),
    child: Column(
      children: [
        Text(
          'Makanan Berkualitas,\nHarga Lebih Bersahabat.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontSize: _headingSize,
            height: 1.25,
            fontWeight: FontWeight.w700,
            letterSpacing: -.65,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Temukan makanan surplus berkualitas dari bisnis '
          'terpercaya di sekitarmu sebelum waktu pengambilannya '
          'berakhir.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.5, height: 1.2),
        ),
      ],
    ),
  );
}

class _WelcomeActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 29, top: 24, right: 29),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text(
              'Daftar',
              style: TextStyle(
                fontFamily: PanganKitaTheme.emphasisFontFamily,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Sudah punya akun?'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            child: const Text('Login'),
          ),
        ],
      ),
    ],
  );
}
