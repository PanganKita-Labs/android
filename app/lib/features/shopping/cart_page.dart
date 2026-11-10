import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/shopping/cart_line_card.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _panelGap = 16.0;
const _labelGap = 4.0;
const _cartGap = 12.0;
const _notesLimit = 200;
const _notesMaxLines = 3;

/// Session-only cart preview matching the supplied shopping reference.
class CartPage extends StatelessWidget {
  /// Receives state owned by the application, never by a global singleton.
  const new({required this.cart, super.key});

  /// Local demo cart; no backend or inventory authority.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, child) => Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const I18nText('Keranjang'),
        actions: [
          TextButton(
            onPressed: cart.lines.isEmpty ? null : cart.clear,
            child: const I18nText('Hapus Semua'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: cart.lines.isEmpty
            ? const _EmptyCart()
            : ListView(
                padding: const EdgeInsets.all(_cartGap),
                children: [
                  for (final merchant
                      in cart.lines
                          .map((line) => line.food.merchant)
                          .toSet()) ...[
                    _MerchantCart(cart: cart, merchant: merchant),
                    const SizedBox(height: _cartGap),
                    _PickupCard(cart: cart, merchant: merchant),
                    const SizedBox(height: _cartGap),
                  ],
                  const _CartNotes(),
                  const SizedBox(height: _cartGap),
                  _CartSummary(cart: cart),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: I18nText(
                      'Demo offline. Harga, tambahan, lokasi, dan jadwal '
                      'adalah contoh. '
                      'Keranjang hilang saat aplikasi ditutup. '
                      'Tidak ada stok yang dipesan atau pembayaran dibuat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: cart.lines.isEmpty ? null : _CartFooter(cart: cart),
    ),
  );
}

class _EmptyCart extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: _panelGap,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 56,
            color: PanganKitaColors.brandPrimary,
          ),
          I18nText(
            'Keranjangmu masih kosong',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const I18nText(
            'Pilih makanan dari Beranda untuk melihat ringkasan di sini.',
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: () => Navigator.maybePop(context),
            child: const I18nText('Kembali Belanja'),
          ),
        ],
      ),
    ),
  );
}

class _MerchantCart extends StatelessWidget {
  const new({required this.cart, required this.merchant});
  final DemoCart cart;
  final String merchant;

  @override
  Widget build(BuildContext context) {
    final lines = cart.lines.where((line) => line.food.merchant == merchant);
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: _cartGap,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(lines.first.food.image),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: _labelGap,
                    children: [
                      I18nText(
                        merchant,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const I18nText(
                        'Lokasi toko contoh',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: PanganKitaColors.borderNeutral),
          for (final line in lines) CartLineCard(line: line, cart: cart),
          const Divider(height: 1, color: PanganKitaColors.borderNeutral),
          TextButton.icon(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.add),
            label: const I18nText('Tambah menu lain'),
          ),
        ],
      ),
    );
  }
}

class _CartPickupClock extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const CircleAvatar(
    radius: 24,
    backgroundColor: Color(0xFFFFEDD0),
    child: Icon(
      Icons.schedule_outlined,
      size: 28,
      color: PanganKitaColors.brandAccent,
    ),
  );
}

class _CartNoteHeading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Row(
    spacing: 8,
    children: [
      Icon(Icons.receipt_long_outlined, size: 20),
      Expanded(
        child: I18nText(
          'Catatan untuk toko',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

class _CartTotalLabel extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: _labelGap,
    children: [
      const I18nText('Total pembayaran', style: TextStyle(fontSize: 12)),
      I18nText(
        formatRupiah(cart.subtotal),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  );
}

class _PickupCard extends StatelessWidget {
  const new({required this.cart, required this.merchant});
  final DemoCart cart;
  final String merchant;

  @override
  Widget build(BuildContext context) {
    final pickupTimes = cart.lines
        .where((line) => line.food.merchant == merchant)
        .map((line) => line.food.pickupTime)
        .toSet()
        .join(', ');
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () => DemoNotice.show(
          context,
          'Jadwal contoh $merchant: pickup hingga $pickupTimes. '
          'Jadwal aktual belum tersedia.',
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            spacing: _cartGap,
            children: [
              const _CartPickupClock(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _labelGap,
                  children: [
                    I18nText(
                      'Ambil di toko',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    I18nText(
                      'Batas pickup: $pickupTimes',
                      style: const TextStyle(
                        fontSize: 14,
                        color: PanganKitaColors.attentionText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartNotes extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _cartGap,
        children: [
          const _CartNoteHeading(),
          TextField(
            minLines: 2,
            maxLines: _notesMaxLines,
            maxLength: _notesLimit,
            style: const TextStyle(fontSize: 14, height: 1.35),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: PanganKitaColors.brandPrimary),
              ),
              hintText: translateDisplayText(
                context,
                'Contoh: kemasan dipisah, jangan terlalu manis, dll.',
              ),
              counterText: '',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7B8698),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CartSummary extends StatelessWidget {
  const new({required this.cart});
  final DemoCart cart;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _cartGap,
        children: [
          I18nText(
            'Ringkasan pesanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _SummaryRow(
            label: 'Subtotal (${cart.itemCount} item)',
            value: formatRupiah(cart.subtotal),
          ),
          const _SummaryRow(label: 'Biaya layanan (demo)', value: 'Rp0'),
          const Divider(height: 1, color: PanganKitaColors.borderNeutral),
          _SummaryRow(
            label: 'Total pembayaran',
            value: formatRupiah(cart.subtotal),
            emphasized: true,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFF0DC),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: I18nText(
                'Pastikan kamu bisa datang sesuai jadwal. '
                'Jadwal aktual belum tersedia dalam demo.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label;
  final String value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: _cartGap,
    runSpacing: _labelGap,
    children: [
      I18nText(
        label,
        style: emphasized ? Theme.of(context).textTheme.titleSmall : null,
      ),
      I18nText(
        value,
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

class _CartFooter extends StatelessWidget {
  const new({required this.cart});
  final DemoCart cart;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: _panelGap,
          children: [
            Expanded(
              child: _CartTotalLabel(cart: cart),
            ),
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
                onPressed: () =>
                    Navigator.pushNamed<void>(context, AppRoutes.checkout),
                child: const I18nText(
                  'Lanjut Checkout',
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
