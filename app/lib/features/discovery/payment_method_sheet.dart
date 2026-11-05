import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

const _logoWidth = 48.0;
const _logoHeight = 24.0;

/// Shows the only illustrative payment method in the offline prototype.
Future<void> showPaymentMethodSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih metode pembayaran',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Saat ini hanya QRIS sebagai contoh tampilan. '
                'Tidak ada pembayaran atau kode QR yang dibuat.',
              ),
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Image.asset(
                    'assets/prototype/qris-logo-black.png',
                    width: _logoWidth,
                    height: _logoHeight,
                    semanticLabel: 'Logo QRIS',
                  ),
                  title: const Text('QRIS'),
                  subtitle: const Text('Metode contoh yang ditampilkan'),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: PanganKitaColors.brandPrimaryStrong,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Gunakan QRIS (contoh)'),
              ),
            ],
          ),
        ),
      ),
    );
