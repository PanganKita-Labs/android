import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

const _successTopFraction = .19;

/// Confirmation for the simulated password recovery flow.
class PasswordSuccessPage extends StatelessWidget {
  /// Creates the confirmation screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(30).copyWith(
          top: MediaQuery.sizeOf(context).height * _successTopFraction,
        ),
        children: [
          const Icon(
            Icons.verified,
            size: 134,
            color: PanganKitaColors.brandPrimary,
          ),
          const SizedBox(height: 21),
          const Text(
            'Password Berhasil Diperbarui!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: PanganKitaTheme.emphasisFontFamily,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            'Silakan masuk kembali menggunakan\npassword baru.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19.5),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            ),
            child: const Text('Kembali ke Login'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Simulasi lokal. Tidak ada password atau akun yang disimpan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    ),
  );
}
