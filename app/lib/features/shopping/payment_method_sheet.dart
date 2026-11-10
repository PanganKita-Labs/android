import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';

const _logoWidth = 48.0;
const _logoHeight = 24.0;

/// Shows the only illustrative payment method in the offline prototype.
Future<void> showPaymentMethodSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _PaymentMethodContent(),
    );

class _PaymentMethodContent extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          I18nText(
            'Pilih metode pembayaran',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const I18nText(
            'Saat ini hanya QRIS sebagai contoh tampilan. '
            'Tidak ada pembayaran atau kode QR yang dibuat.',
          ),
          const SizedBox(height: 16),
          const _QrisOption(),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const I18nText('Gunakan QRIS (contoh)'),
          ),
        ],
      ),
    ),
  );
}

class _QrisOption extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      leading: Image.asset(
        'assets/prototype/qris-logo-black.png',
        width: _logoWidth,
        height: _logoHeight,
        semanticLabel: translateDisplayText(context, 'Logo QRIS'),
      ),
      title: const I18nText('QRIS'),
      subtitle: const I18nText('Metode contoh yang ditampilkan'),
      trailing: const Icon(
        Icons.check_circle,
        color: PanganKitaColors.brandPrimaryStrong,
      ),
    ),
  );
}
