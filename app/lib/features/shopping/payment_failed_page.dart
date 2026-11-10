import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/features/shopping/payment_method_sheet.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const Color _green = PanganKitaColors.brandPrimaryStrong;
const _orange = Color(0xFFE88913);
const Color _ink = PanganKitaColors.inkDeep;
const _cardRadius = 20.0;
const _merchantRadius = 20.0;
const _productRadius = 12.0;
const _productSize = 72.0;
const _methodWidth = 145.0;
const _statusWidth = 125.0;
const _badgeRadius = 24.0;
const _adviceIconRadius = 24.0;
const _detailSpacing = 18.0;
const _detailRunSpacing = 12.0;

Set<String> _merchantNames(DemoCart cart) =>
    cart.lines.map((line) => line.food.merchant).toSet();

/// Displays the unsuccessful-payment reference without a real payment attempt.
class PaymentFailedPage extends StatelessWidget {
  /// Uses the session cart only to populate the example order card.
  const new({required this.cart, super.key});

  /// Cart contents are never charged or cleared by this page.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, child) => Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      appBar: AppBar(
        leading: const BackButton(),
        title: const I18nText('Pembayaran'),
      ),
      body: cart.lines.isEmpty
          ? const Center(
              child: I18nText('Keranjang kosong. Tidak ada contoh pembayaran.'),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                const _FailedHeader(),
                const SizedBox(height: 20),
                _ExampleOrderCard(cart: cart),
                const SizedBox(height: 16),
                const _NextStepsCard(),
              ],
            ),
      bottomNavigationBar: cart.lines.isEmpty ? null : const _FailedActions(),
    ),
  );
}

class _FailedHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const CircleAvatar(
        radius: 54,
        backgroundColor: Color(0xFFF7DFC3),
        child: Icon(Icons.error_outline, size: 76, color: _orange),
      ),
      const SizedBox(height: 16),
      I18nText(
        'Contoh pembayaran belum berhasil',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium
            ?.copyWith(color: _ink),
      ),
      const SizedBox(height: 6),
      const I18nText(
        'Belum ada pembayaran yang diproses atau dikonfirmasi. '
        'Ini hanya contoh tampilan.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class _ExampleOrderCard extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.shade300),
      borderRadius: const BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FailedMerchantRow(cart: cart),
          const SizedBox(height: 16),
          for (final line in cart.lines) ...[
            _FailedOrderLine(line: line),
            const SizedBox(height: 10),
          ],
          const Divider(height: 24),
          const _FailedDetails(),
        ],
      ),
    ),
  );
}

class _FailedMerchantRow extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _merchantRadius,
        backgroundImage: _merchantNames(cart).length == 1
            ? AssetImage(cart.lines.first.food.image)
            : null,
        child: _merchantNames(cart).length == 1
            ? null
            : const Icon(Icons.storefront_outlined),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: I18nText(
          _merchantNames(cart).join(', '),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ],
  );
}

class _FailedOrderLine extends StatelessWidget {
  const new({required this.line});

  final DemoCartLine line;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_productRadius)),
        child: SizedBox.square(
          dimension: _productSize,
          child: Image.asset(line.food.image, fit: BoxFit.cover),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              line.food.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            I18nText(line.food.merchant),
            const SizedBox(height: 4),
            I18nText('${line.quantity} x ${formatRupiah(line.unitPrice)}'),
          ],
        ),
      ),
    ],
  );
}

class _FailedDetails extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: _detailSpacing,
    runSpacing: _detailRunSpacing,
    children: [
      SizedBox(
        width: _methodWidth,
        child: _CardDetail(label: 'Metode pembayaran', value: 'QRIS contoh'),
      ),
      SizedBox(
        width: _statusWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText('Status'),
            SizedBox(height: 6),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFFCE8E5),
                borderRadius: BorderRadius.all(Radius.circular(_badgeRadius)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: I18nText('Belum tersedia'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _CardDetail extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      I18nText(label),
      const SizedBox(height: 6),
      I18nText(value, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _NextStepsCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.shade300),
      borderRadius: const BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          I18nText(
            'Yang bisa kamu lakukan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const _AdviceRow(
            icon: Icons.wifi,
            title: 'Periksa koneksi internet',
            description: 'Pastikan koneksi stabil sebelum mencoba lagi.',
          ),
          const Divider(height: 20),
          const _AdviceRow(
            icon: Icons.receipt_long_outlined,
            title: 'Cek riwayat transaksi',
            description: 'Periksa aplikasi pembayaranmu sebelum mencoba lagi.',
          ),
        ],
      ),
    ),
  );
}

class _AdviceRow extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _adviceIconRadius,
        backgroundColor: const Color(0xFFE3F1E8),
        child: Icon(icon, color: _green),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(title, style: Theme.of(context).textTheme.titleSmall),
            I18nText(description),
          ],
        ),
      ),
    ],
  );
}

class _FailedActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.refresh),
            label: const I18nText('Coba Bayar Lagi'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => showPaymentMethodSheet(context),
            icon: const Icon(Icons.credit_card_outlined),
            label: const I18nText('Ganti Metode Pembayaran'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed<void>(context, AppRoutes.support),
            child: const I18nText('Butuh bantuan?'),
          ),
        ],
      ),
    ),
  );
}
