import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/cart_line_card.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _panelGap = 16.0;
const _labelGap = 4.0;
const _cartGap = 12.0;
const _notesLimit = 200;

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
        title: const Text('Keranjang'),
        actions: [
          TextButton(
            onPressed: cart.lines.isEmpty ? null : cart.clear,
            child: const Text('Hapus Semua'),
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
                    child: Text(
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
          Text(
            'Keranjangmu masih kosong',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text(
            'Pilih makanan dari Beranda untuk melihat ringkasan di sini.',
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Kembali Belanja'),
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
                      Text(
                        merchant,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
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
            label: const Text('Tambah menu lain'),
          ),
        ],
      ),
    );
  }
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
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFFFEDD0),
                child: Icon(
                  Icons.schedule_outlined,
                  size: 28,
                  color: PanganKitaColors.brandAccent,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _labelGap,
                  children: [
                    Text(
                      'Ambil di toko',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Batas pickup: $pickupTimes',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAD5200),
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
  Widget build(BuildContext context) => const Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _cartGap,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.receipt_long_outlined, size: 20),
              Expanded(
                child: Text(
                  'Catatan untuk toko',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          TextField(
            minLines: 2,
            maxLines: 3,
            maxLength: _notesLimit,
            style: TextStyle(fontSize: 14, height: 1.35),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: PanganKitaColors.brandPrimary),
              ),
              hintText: 'Contoh: kemasan dipisah, jangan terlalu manis, dll.',
              counterText: '',
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7B8698)),
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
          Text(
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
              child: Text(
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
      Text(
        label,
        style: emphasized ? Theme.of(context).textTheme.titleSmall : null,
      ),
      Text(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: _labelGap,
                children: [
                  const Text(
                    'Total pembayaran',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    formatRupiah(cart.subtotal),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
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
                onPressed: () => DemoNotice.show(
                  context,
                  'Checkout belum tersedia. '
                  'Tidak ada pesanan atau pembayaran dibuat.',
                ),
                child: const Text(
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
