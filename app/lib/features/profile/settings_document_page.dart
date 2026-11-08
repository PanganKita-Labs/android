import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';

/// Honest placeholder until an approved privacy document is available.
class SettingsDocumentPage extends StatelessWidget {
  /// Shows the privacy status without inventing a data policy.
  const new privacy({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(title: const I18nText('Kebijakan Privasi')),
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 48,
                color: PanganKitaColors.brandPrimaryStrong,
              ),
              const SizedBox(height: 16),
              I18nText(
                'Kebijakan Privasi belum tersedia',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const I18nText(
                'Dokumen resmi belum tersedia dalam contoh aplikasi ini.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const I18nText('Kembali ke Pengaturan'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
