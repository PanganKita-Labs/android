import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';

/// Illustrated introduction from the supplied HTML reference.
class WelcomePage extends StatelessWidget {
  /// Creates the introduction.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Image.asset(
            'assets/prototype/welcome.webp',
            excludeFromSemantics: true,
            fit: BoxFit.fitWidth,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 29, top: 20, right: 29),
            child: Column(
              children: [
                Text(
                  'Makanan Berkualitas,\nHarga Lebih Bersahabat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29, top: 24, right: 29),
            child: FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text(
                'Daftar',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun?'),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
