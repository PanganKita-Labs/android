import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _pageGap = 12.0;
const _cardGap = 14.0;
const _stepGap = 10.0;
const _wrapRunGap = 8.0;
const _merchantAvatarRadius = 26.0;
const _stepRadius = 14.0;
const _qrisLogoWidth = 48.0;
const _qrisLogoHeight = 24.0;
const _orange = Color(0xFFE98412);
const _orangePale = Color(0xFFFFEED8);
const _orangeSoft = Color(0xFFFFF5E8);
const _qrPlaceholderSize = 166.0;

/// Payment layout preview without a transaction, QR code, or order.
class PaymentStatusPage extends StatelessWidget {
  /// Reads the session cart without changing inventory or charging anyone.
  const new({required this.cart, super.key});

  /// App-owned preview cart.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, child) => Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Pembayaran'),
        actions: [
          IconButton(
            tooltip: 'Tentang pratinjau pembayaran',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Pembayaran belum tersedia'),
                content: const Text(
                  'Layar ini hanya contoh. Tidak ada kode QR, tagihan, '
                  'transaksi, atau pesanan yang dibuat.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: cart.lines.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Keranjang kosong. Belum ada status pembayaran.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(_pageGap),
                children: [
                  const _PaymentNotice(),
                  const SizedBox(height: _pageGap),
                  _PaymentPreviewCard(cart: cart),
                ],
              ),
      ),
      bottomNavigationBar: cart.lines.isEmpty ? null : const _PaymentActions(),
    ),
  );
}

class _PaymentNotice extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: _orangeSoft,
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: _pageGap,
        children: [
          Row(
            spacing: _pageGap,
            children: [
              const Icon(Icons.schedule_outlined, size: 40, color: _orange),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pembayaran belum tersedia',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: _orange),
                    ),
                    const Text('Belum ada tagihan yang perlu diselesaikan.'),
                  ],
                ),
              ),
            ],
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              color: _orangePale,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text('Batas waktu pembayaran'),
                    Text(
                      'Belum tersedia',
                      style: TextStyle(
                        fontFamily: PanganKitaTheme.emphasisFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: _orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PaymentPreviewCard extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _cardGap,
        children: [
          _PaymentMerchant(cart: cart),
          const Divider(height: 1),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: _pageGap,
            runSpacing: _wrapRunGap,
            children: [
              const Text('Total pembayaran'),
              Text(
                formatRupiah(cart.subtotal),
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: PanganKitaColors.brandPrimary),
              ),
            ],
          ),
          const Center(child: _UnavailableQr()),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: _pageGap,
            runSpacing: _wrapRunGap,
            children: [
              const Text('Metode pembayaran'),
              Image.asset(
                'assets/prototype/qris-logo-black.png',
                width: _qrisLogoWidth,
                height: _qrisLogoHeight,
                semanticLabel: 'Logo QRIS, metode pembayaran contoh',
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Simpan QR'),
          ),
          Text(
            'Status pratinjau',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const _PreviewStep(
            number: '1',
            text: 'Kode QR pembayaran belum diterbitkan.',
          ),
          const _PreviewStep(
            number: '2',
            text: 'Tidak ada transaksi yang bisa diperiksa.',
          ),
          const _PreviewStep(
            number: '3',
            text: 'Keranjang tetap tersimpan selama sesi ini.',
          ),
          const Divider(height: 1),
          const Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: _pageGap,
            runSpacing: _wrapRunGap,
            children: [Text('ID Pesanan'), Text('Belum tersedia')],
          ),
        ],
      ),
    ),
  );
}

class _PaymentMerchant extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _pageGap,
    children: [
      CircleAvatar(
        radius: _merchantAvatarRadius,
        backgroundImage: AssetImage(cart.lines.first.food.image),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.lines.map((line) => line.food.merchant).toSet().join(', '),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text(
              'ID pesanan belum tersedia',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    ],
  );
}

class _UnavailableQr extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: _qrPlaceholderSize,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: PanganKitaColors.surfaceWarm,
        border: Border.all(color: PanganKitaColors.borderNeutral),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2_outlined, size: 56, color: Colors.black38),
          Text('QR belum tersedia', style: TextStyle(color: Colors.black54)),
        ],
      ),
    ),
  );
}

class _PreviewStep extends StatelessWidget {
  const new({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _stepGap,
    children: [
      CircleAvatar(
        radius: _stepRadius,
        backgroundColor: PanganKitaColors.brandPrimary,
        child: Text(number, style: const TextStyle(color: Colors.white)),
      ),
      Expanded(child: Text(text)),
    ],
  );
}

class _PaymentActions extends StatelessWidget {
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
          spacing: _pageGap,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Checkout'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil<void>(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
