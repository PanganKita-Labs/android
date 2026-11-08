import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const Color _green = PanganKitaColors.brandPrimaryStrong;
const Color _ink = PanganKitaColors.inkDeep;
const Color _orange = PanganKitaColors.referenceOrange;
const _cardRadius = 16.0;
const _photoRadius = 10.0;
const _photoSize = 66.0;
const _merchantRadius = 26.0;

Set<String> _merchantNames(DemoCart cart) =>
    cart.lines.map((line) => line.food.merchant).toSet();

String _pickupTimeLabel(DemoCart cart) {
  final merchants = _merchantNames(cart);
  final times = cart.lines.map((line) => line.food.pickupTime).toSet();
  if (merchants.length == 1 && times.length == 1) {
    return times.single;
  }
  return 'per produk, lihat Checkout';
}

/// A success-layout example without payment or order confirmation.
class PaymentSuccessPage extends StatelessWidget {
  /// Reads the session cart solely to populate the example layout.
  const new({required this.cart, super.key});

  /// App-owned preview cart; it is never charged or cleared here.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, child) => Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Pembayaran'),
      ),
      body: SafeArea(
        top: false,
        child: cart.lines.isEmpty
            ? const Center(
                child: Text('Keranjang kosong. Tidak ada contoh pembayaran.'),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  const _SuccessHeader(),
                  const SizedBox(height: 12),
                  _PaymentSummary(cart: cart),
                  const SizedBox(height: 12),
                  _PickupNotice(time: _pickupTimeLabel(cart)),
                  const SizedBox(height: 12),
                  Text(
                    'Rincian pesanan contoh',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: _ink),
                  ),
                  const SizedBox(height: 8),
                  for (final line in cart.lines) ...[
                    _ProductCard(line: line),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
      ),
      bottomNavigationBar: cart.lines.isEmpty ? null : const _SuccessActions(),
    ),
  );
}

class _SuccessHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const CircleAvatar(
        radius: 42,
        backgroundColor: Color(0xFFDDF3E6),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: _green,
          child: Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Contoh pembayaran berhasil',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium
            ?.copyWith(color: _ink),
      ),
      const SizedBox(height: 4),
      const Text(
        'Pratinjau tampilan setelah pembayaran.\n'
        'Belum ada transaksi atau pesanan yang dibuat.',
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class _PaymentSummary extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _merchantNames(cart).join(', '),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Text('Merchant contoh'),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          _SummaryRow(
            label: 'Total contoh',
            value: formatRupiah(cart.subtotal),
          ),
          const SizedBox(height: 4),
          const _SummaryRow(
            label: 'Metode pembayaran',
            value: 'Belum tersedia',
          ),
          const SizedBox(height: 4),
          const _SummaryRow(
            label: 'Status pembayaran',
            value: 'Belum tersedia',
          ),
          const SizedBox(height: 4),
          const _SummaryRow(label: 'Waktu pembayaran', value: 'Belum tersedia'),
          const SizedBox(height: 4),
          const _SummaryRow(label: 'ID pesanan', value: 'Belum tersedia'),
        ],
      ),
    ),
  );
}

class _PickupNotice extends StatelessWidget {
  const new({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Color(0xFFFFEBD3),
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.schedule_outlined, size: 34, color: _orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batas pickup contoh: $time',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: _orange),
                ),
                const Text('Jadwal ini bukan konfirmasi pesanan.'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProductCard extends StatelessWidget {
  const new({required this.line});

  final DemoCartLine line;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(_photoRadius)),
            child: SizedBox.square(
              dimension: _photoSize,
              child: Image.asset(line.food.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.food.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(line.food.merchant),
                Text('${line.quantity} x ${formatRupiah(line.unitPrice)}'),
              ],
            ),
          ),
          Text(
            formatRupiah(line.total),
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: _green),
          ),
        ],
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Text(label)),
      const SizedBox(width: 8),
      Flexible(child: Text(value, textAlign: TextAlign.end)),
    ],
  );
}

class _SuccessActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.orders).ignore(),
              child: const Text('Lihat contoh pesanan'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ).ignore(),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
