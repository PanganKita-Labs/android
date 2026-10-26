import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _ratingWidth = 82.0;
const _contentGap = 10.0;
const _bodyGap = 8.0;
const _captionSize = 12.0;
const _controlGap = 16.0;
const _detailCorner = 24.0;
const _pageBottom = 32.0;
const _pageGutter = 23.0;
const _sectionGap = 20.0;
const _photoRatio = 2.3;
const _titleSize = 22.0;
const _priceSize = 24.0;
const _previewQuantityLimit = 10;

/// Full-screen details for a selected offline listing example.
class ProductDetailPage extends StatefulWidget {
  /// Displays the same product data as its home card.
  const new({required this.food, super.key});

  /// Illustrative listing, not authoritative inventory or a live offer.
  final DemoFood food;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _favorite = false;
  int _quantity = 1;

  void _toggleFavorite() => setState(() => _favorite = !_favorite);
  void _decrease() => setState(() => _quantity--);
  void _increase() => setState(() => _quantity++);

  Future<void> _copyProduct() async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${widget.food.title} — ${widget.food.merchant}\n'
            '${widget.food.price} '
            '(contoh demo PanganKita, bukan penawaran aktif)',
      ),
    );
    if (!mounted) return;
    DemoNotice.show(context, 'Informasi produk demo disalin.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackButton(),
      actions: [
        IconButton(
          tooltip: _favorite
              ? 'Hapus favorit sementara'
              : 'Favoritkan sementara',
          isSelected: _favorite,
          onPressed: _toggleFavorite,
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(
            Icons.favorite,
            color: PanganKitaColors.danger,
          ),
        ),
        IconButton(
          tooltip: 'Salin informasi produk',
          onPressed: () {
            unawaited(_copyProduct());
          },
          icon: const Icon(Icons.ios_share),
        ),
        const SizedBox(width: 12),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: _pageGutter)
            .copyWith(top: _captionSize, bottom: _pageBottom),
        children: [
          _MerchantSummary(food: widget.food),
          const SizedBox(height: _sectionGap),
          _ProductSummary(food: widget.food),
          const Divider(height: 32),
          const _ProductInformation(),
          const Divider(height: 32),
          const _ProductReviews(),
          const SizedBox(height: _sectionGap),
          _QuantityPicker(
            quantity: _quantity,
            onDecrease: _quantity > 1 ? _decrease : null,
            onIncrease: _quantity < _previewQuantityLimit ? _increase : null,
          ),
          const SizedBox(height: _sectionGap),
          const _CartAction(),
        ],
      ),
    ),
  );
}

class _MerchantSummary extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _contentGap,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CircleAvatar(
        backgroundColor: Colors.white,
        child: ReferenceIcon('store', color: PanganKitaColors.brandPrimary),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: PanganKitaSpacing.xs,
          children: [
            Text(
              food.merchant,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text(
              'Lokasi toko belum tersedia dalam demo',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
      SizedBox(
        width: _ratingWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const ReferenceIcon(
              'star',
              size: _captionSize,
              color: PanganKitaColors.brandAccent,
            ),
            Text(
              '${food.rating}\nRating contoh',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: _contentGap,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ProductSummary extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: _contentGap,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_detailCorner)),
        child: AspectRatio(
          aspectRatio: _photoRatio,
          child: Image.asset(
            food.image,
            fit: BoxFit.cover,
            semanticLabel: food.title,
          ),
        ),
      ),
      Text(
        food.title,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontSize: _titleSize, fontWeight: FontWeight.w700),
      ),
      const Text(
        'Contoh penawaran surplus untuk diambil di toko. '
        'Deskripsi dari merchant belum tersedia.',
      ),
      Wrap(
        spacing: _bodyGap,
        runSpacing: PanganKitaSpacing.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            food.price,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _priceSize,
              color: PanganKitaColors.brandPrimary,
            ),
          ),
          Text(
            food.original,
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Chip(
            label: Text.rich(
              TextSpan(
                text: 'Hemat ',
                children: [
                  TextSpan(
                    text: food.saving.replaceFirst('Hemat ', ''),
                    style: const TextStyle(
                      fontFamily: PanganKitaTheme.emphasisFontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Text(
        'Pickup contoh: ${food.pickupTime} · ${food.stock}',
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

class _ProductInformation extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: _bodyGap,
    children: [
      Text('Pilih Tambahan', style: Theme.of(context).textTheme.titleMedium),
      const Text('Belum ada pilihan tambahan untuk produk demo ini.'),
      const Text(
        'Informasi bahan, alergen, dan penyimpanan belum tersedia. '
        'Data produk ini bukan penawaran aktif.',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ],
  );
}

class _ProductReviews extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: _captionSize,
    children: [
      Text('Ulasan Pelanggan', style: Theme.of(context).textTheme.titleMedium),
      const Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Belum ada ulasan nyata dalam demo offline ini.'),
        ),
      ),
    ],
  );
}

class _QuantityPicker extends StatelessWidget {
  const new({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });
  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) => Column(
    spacing: _bodyGap,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: _controlGap,
        children: [
          IconButton.filledTonal(
            tooltip: 'Kurangi jumlah contoh',
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
          ),
          Semantics(
            liveRegion: true,
            label: 'Jumlah contoh $quantity',
            excludeSemantics: true,
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Tambah jumlah contoh',
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      const Text(
        'Pratinjau 1–10 item; tidak mengubah stok.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}

class _CartAction extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: _contentGap,
    children: [
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: PanganKitaColors.brandAccent,
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
        ),
        onPressed: () => DemoNotice.show(
          context,
          'Keranjang belum tersedia. Tidak ada pesanan atau reservasi dibuat.',
        ),
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Tambah ke Keranjang (Demo)'),
      ),
      const Text(
        'Demo offline · Favorit hanya berlaku selama halaman terbuka. '
        'Harga, rating, dan stok adalah contoh.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ],
  );
}
