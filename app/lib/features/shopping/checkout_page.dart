import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/shopping/checkout_order_details.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/features/shopping/payment_method_sheet.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _qrisLogoWidth = 48.0;
const _qrisLogoHeight = 24.0;
const _checkoutNoticeTitleSize = 15.0;
const _checkoutPersonTitleSize = 16.0;
const _personVerticalPadding = 14.0;
const _checkoutGap = 12.0;
const _checkoutLabelGap = 4.0;
const _checkoutPanelGap = 16.0;
const Color _pickupTextColor = PanganKitaColors.attentionText;

/// Pickup checkout preview; never submits an order or initiates payment.
class CheckoutPage extends StatefulWidget {
  /// Uses the same cart as Home, product details and the cart route.
  const new({required this.cart, super.key});

  /// App-session preview state.
  final DemoCart cart;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

/// Owns the local checkout acknowledgment state.
///
/// Checkout remains a read-only preview and creates no server order.
class _CheckoutPageState extends State<CheckoutPage> {
  bool _understood = false;

/// Updates the local pickup acknowledgment checkbox state.
  void _setUnderstood(bool? value) =>
      setState(() => _understood = value ?? false);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.cart,
    builder: (context, child) => Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const I18nText('Checkout'),
      ),
      body: SafeArea(
        top: false,
        child: widget.cart.lines.isEmpty
            ? const _CheckoutEmpty()
            : ListView(
                padding: const EdgeInsets.all(_checkoutGap),
                children: [
                  const _PickupNotice(),
                  const SizedBox(height: _checkoutGap),
                  for (final merchant
                      in widget.cart.lines
                          .map((line) => line.food.merchant)
                          .toSet()) ...[
                    _CheckoutMerchant(cart: widget.cart, merchant: merchant),
                    const SizedBox(height: _checkoutGap),
                  ],
                  const _PickupPerson(),
                  const SizedBox(height: _checkoutGap),
                  CheckoutOrderDetails(cart: widget.cart),
                  const SizedBox(height: _checkoutGap),
                  const _PaymentMethod(),
                  const SizedBox(height: _checkoutGap),
                  _PaymentSummary(cart: widget.cart),
                  _PickupAgreement(
                    value: _understood,
                    onChanged: _setUnderstood,
                  ),
                  const I18nText(
                    'Demo offline. Toko, jadwal, profil, harga, dan QRIS '
                    'hanya contoh. Tidak ada pembayaran atau pesanan dibuat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: widget.cart.lines.isEmpty
          ? null
          : _CheckoutFooter(cart: widget.cart, enabled: _understood),
    ),
  );
}

/// Shows the checkout fallback when no cart lines are selected.
class _CheckoutEmpty extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: I18nText(
        'Keranjang kosong. Tambahkan produk sebelum checkout.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );
}

/// Explains that pickup times and fulfillment are illustrative.
class _PickupNotice extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFF0FBF4),
      border: Border.all(color: const Color(0xFFD9EEE0)),
      borderRadius: const BorderRadius.all(Radius.circular(14)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        spacing: _checkoutGap,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFD6F1DF),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: PanganKitaColors.brandPrimaryStrong,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _checkoutLabelGap,
              children: [
                I18nText(
                  'Pesanan diambil langsung di toko',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontSize: _checkoutNoticeTitleSize),
                ),
                const I18nText(
                  'Tidak ada biaya antar, lebih hemat!',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Displays the example merchant name and preview badge.
class _CheckoutMerchantName extends StatelessWidget {
  const new({required this.merchant});

  final String merchant;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _checkoutLabelGap,
    children: [
      Flexible(
        child: I18nText(
          merchant,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      Semantics(
        label: 'Badge contoh; merchant belum diverifikasi',
        child: const Icon(
          Icons.check_circle,
          size: 14,
          color: PanganKitaColors.brandPrimary,
        ),
      ),
    ],
  );
}

/// Shows a fixture pickup window without a live deadline.
class _CheckoutPickupTime extends StatelessWidget {
  const new({required this.pickupTimes});

  final String pickupTimes;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _checkoutLabelGap,
    children: [
      const Icon(
        Icons.schedule_outlined,
        size: 14,
        color: PanganKitaColors.brandAccent,
      ),
      Expanded(
        child: I18nText(
          'Pickup hingga $pickupTimes',
          style: const TextStyle(fontSize: 12, color: _pickupTextColor),
        ),
      ),
    ],
  );
}

/// Displays the in-memory cart subtotal in whole rupiah.
class _CheckoutTotalLabel extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: _checkoutLabelGap,
    children: [
      const I18nText('Total pembayaran', style: TextStyle(fontSize: 12)),
      I18nText(
        formatRupiah(cart.subtotal),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  );
}

/// Groups fixture merchant identity, location, and pickup window.
class _CheckoutMerchant extends StatelessWidget {
  const new({required this.cart, required this.merchant});
  final DemoCart cart;
  final String merchant;
  @override
  Widget build(BuildContext context) {
    final lines = cart.lines.where((line) => line.food.merchant == merchant);
    final pickupTimes = lines
        .map((line) => line.food.pickupTime)
        .toSet()
        .join(', ');
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: _checkoutGap,
          children: [
            CircleAvatar(backgroundImage: AssetImage(lines.first.food.image)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: _checkoutLabelGap,
                children: [
                  _CheckoutMerchantName(merchant: merchant),
                  _MerchantLocation(address: lines.first.food.pickupAddress),
                  _CheckoutPickupTime(pickupTimes: pickupTimes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays the merchant address supplied in fixture data.
class _MerchantLocation extends StatelessWidget {
  const new({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _checkoutLabelGap,
    children: [
      const Icon(
        Icons.location_on_outlined,
        size: 16,
        color: PanganKitaColors.brandPrimary,
      ),
      Expanded(
        child: I18nText(
          address,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => DemoNotice.show(
          context,
          'Lokasi ini contoh tampilan. Peta dan lokasi nyata belum tersedia.',
        ),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.chevron_right, size: 18),
        label: const I18nText('Detail lokasi'),
      ),
    ],
  );
}

/// Shows the example pickup-person section.
class _PickupPerson extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      minVerticalPadding: _personVerticalPadding,
      leading: const CircleAvatar(
        radius: 24,
        backgroundColor: PanganKitaColors.surfaceWarm,
        child: Icon(Icons.person_outline, color: PanganKitaColors.brandPrimary),
      ),
      title: I18nText(
        'Vincent',
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontSize: _checkoutPersonTitleSize),
      ),
      subtitle: const I18nText(
        'Pengambil pesanan',
        style: TextStyle(fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => DemoNotice.show(
        context,
        'Profil pengambil belum terhubung ke akun. Nama ini hanya contoh.',
      ),
    ),
  );
}

/// Presents an illustrative payment choice without charging a card.
class _PaymentMethod extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _checkoutLabelGap,
        children: [
          I18nText(
            'Metode pembayaran',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            spacing: _checkoutGap,
            children: [
              Image.asset(
                'assets/prototype/qris-logo-black.png',
                width: _qrisLogoWidth,
                height: _qrisLogoHeight,
                fit: BoxFit.contain,
                semanticLabel: translateDisplayText(
                  context,
                  'Logo QRIS, metode pembayaran contoh',
                ),
              ),
              const Expanded(child: I18nText('QRIS')),
              TextButton.icon(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: () => showPaymentMethodSheet(context),
                label: const I18nText('Ubah'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Lists the local totals and preview payment metadata.
class _PaymentSummary extends StatelessWidget {
  const new({required this.cart});
  final DemoCart cart;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _checkoutGap,
        children: [
          I18nText(
            'Ringkasan pembayaran',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _PaymentRow(
            label: 'Subtotal (${cart.itemCount} item)',
            amount: formatRupiah(cart.subtotal),
          ),
          const _PaymentRow(label: 'Biaya layanan', amount: 'Rp0'),
          const Divider(height: 1, color: PanganKitaColors.borderNeutral),
          _PaymentRow(
            label: 'Total pembayaran',
            amount: formatRupiah(cart.subtotal),
            emphasized: true,
          ),
        ],
      ),
    ),
  );
}

/// Displays one label and value in the checkout summary.
class _PaymentRow extends StatelessWidget {
  const new({
    required this.label,
    required this.amount,
    this.emphasized = false,
  });
  final String label;
  final String amount;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: _checkoutGap,
    runSpacing: _checkoutLabelGap,
    children: [
      I18nText(
        label,
        style: emphasized ? Theme.of(context).textTheme.titleSmall : null,
      ),
      I18nText(
        amount,
        style: emphasized
            ? Theme.of(context).textTheme.titleMedium
            : const TextStyle(
                fontFamily: PanganKitaTheme.emphasisFontFamily,
                fontWeight: FontWeight.w600,
              ),
      ),
    ],
  );
}

/// Collects a local acknowledgment, not a legal or server consent.
class _PickupAgreement extends StatelessWidget {
  const new({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

/// Opens the reference terms preview rather than official binding terms.
  void _showTerms(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const I18nText('Ketentuan pengambilan (demo)'),
          content: const I18nText(
            'Halaman ini hanya simulasi. Toko, lokasi, dan jadwal '
            'adalah contoh. Tidak ada pembayaran, pesanan, '
            'atau reservasi dibuat. '
            'Ketentuan layanan sebenarnya belum tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const I18nText('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        semanticLabel: translateDisplayText(
          context,
          'Saya setuju dengan ketentuan pengambilan demo',
        ),
        activeColor: PanganKitaColors.brandPrimaryStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      Expanded(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const I18nText(
              'Saya setuju dengan ',
              style: TextStyle(fontSize: 14),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontFamily: PanganKitaTheme.bodyFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => _showTerms(context),
              child: const I18nText('ketentuan pengambilan.'),
            ),
          ],
        ),
      ),
    ],
  );
}

/// Offers navigation to the display-only payment-status preview.
class _CheckoutFooter extends StatelessWidget {
  const new({required this.cart, required this.enabled});
  final DemoCart cart;
  final bool enabled;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: _checkoutPanelGap,
          children: [
            Expanded(child: _CheckoutTotalLabel(cart: cart)),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 18,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: PanganKitaTheme.emphasisFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: enabled
                    ? () => Navigator.pushNamed<void>(
                        context,
                        AppRoutes.paymentStatus,
                      )
                    : null,
                child: const I18nText(
                  'Bayar Sekarang',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
