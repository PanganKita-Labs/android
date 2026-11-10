import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const _inset = 16.0;
const _heroHeight = 185.0;
const _panelOverlap = 18.0;
const _avatarRadius = 26.0;
const _productPhoto = 88.0;
const _productPhotoHeight = 87.0;
const _navHeight = 60.0;
const _tabIndicatorHeight = 3.0;
const _priceGap = 5.0;
const _cardTopGap = 10.0;

/// Returns the category label displayed for the fixture store.
String _storeCategory(DemoFood food) =>
    food.id == 'buns' ? 'Roti & Pastry' : food.category;

/// Store preview based on the shopping design, using sample merchant data.
class StoreDetailPage extends StatefulWidget {
  /// Receives one sample merchant and the app-session cart.
  const new({required this.food, required this.cart, super.key});

  /// Product used to identify the sample merchant.
  final DemoFood food;

  /// Local cart; additions do not reserve inventory.
  final DemoCart cart;

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

/// Owns the selected example store tab and local cart actions.
///
/// No merchant records, availability, or checkout state are fetched remotely.
class _StoreDetailPageState extends State<StoreDetailPage> {
  bool _favorite = false;
  int _tab = 0;

  /// Adds one illustrative store item to the session cart, subject to its limit.
  void _add(DemoFood food) {
    final added = widget.cart.add(food);
    final notice = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: I18nText(
          added
              ? 'Produk contoh ditambahkan ke keranjang lokal.'
              : 'Batas jumlah contoh dalam keranjang sudah tercapai.',
        ),
      ),
    );
    unawaited(notice.closed);
  }

  /// Copies the example merchant information for sharing.
  void _copyMerchant() {
    unawaited(Clipboard.setData(ClipboardData(text: widget.food.merchant)));
    final notice = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: I18nText('Nama toko contoh disalin.')),
    );
    unawaited(notice.closed);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const I18nText('Detail Toko'),
      actions: [
        IconButton(
          tooltip: _favorite
              ? 'Hapus favorit sementara'
              : 'Favoritkan sementara',
          onPressed: () => setState(() => _favorite = !_favorite),
          icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border),
        ),
        IconButton(
          tooltip: translateDisplayText(context, 'Salin nama toko'),
          onPressed: _copyMerchant,
          icon: const Icon(Icons.copy_outlined),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _StoreTop(food: widget.food),
          _StoreTabs(
            selected: _tab,
            onSelected: (tab) => setState(() => _tab = tab),
          ),
          if (_tab == 0) ...[
            _StoreProduct(food: widget.food, onAdd: () => _add(widget.food)),
            if (widget.food.id == 'buns')
              _StoreProduct(
                food: DemoFood.garlicBread,
                onAdd: () => _add(DemoFood.garlicBread),
              ),
          ] else if (_tab == 1)
            _StoreReviews(food: widget.food)
          else
            _StoreAbout(food: widget.food),
        ],
      ),
    ),
    bottomNavigationBar: _CartFooter(cart: widget.cart),
  );
}

/// Displays store imagery and page-level navigation actions.
class _StoreTop extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Image.asset(
        food.id == 'buns'
            ? 'assets/prototype/store-croissants.webp'
            : food.image,
        height: _heroHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.only(top: _heroHeight - _panelOverlap),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _inset,
              vertical: 13,
            ),
            child: Column(
              children: [
                _MerchantSummary(food: food),
                const SizedBox(height: 12),
                _PickupSummary(food: food),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

/// Shows fixture merchant identity and review information.
class _MerchantSummary extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _avatarRadius,
        backgroundColor: PanganKitaColors.savingsSurface,
        backgroundImage: food.id == 'buns'
            ? const AssetImage('assets/prototype/mawar-mark.webp')
            : null,
        child: food.id == 'buns'
            ? null
            : I18nText(food.merchant.substring(0, 1)),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              food.merchant,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            I18nText(
              '${_storeCategory(food)} · contoh',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            _StoreRating(food: food),
            I18nText(
              'Jarak belum tersedia',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      const _StoreDemoBadge(),
    ],
  );
}

/// Displays the static rating of the selected example store.
class _StoreRating extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.star, size: 14, color: PanganKitaColors.brandAccent),
      const SizedBox(width: 3),
      Flexible(
        child: I18nText(
          '${food.rating} · contoh',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ],
  );
}

/// Marks merchant information as illustrative.
class _StoreDemoBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: PanganKitaColors.savingsSurface,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: I18nText('Contoh'),
    ),
  );
}

/// Displays sample pickup information without live geolocation.
class _PickupSummary extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: PanganKitaColors.borderNeutral),
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: PanganKitaColors.brandPrimary,
            ),
            const SizedBox(width: 7),
            Expanded(child: I18nText('${food.pickupAddress} · contoh')),
            TextButton(
              onPressed: () => DemoNotice.unavailable(context),
              child: const I18nText('Lihat peta ›'),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 18,
              color: PanganKitaColors.brandAccent,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: I18nText(
                food.id == 'buns'
                    ? 'Ambil 19.30–20.30 · contoh'
                    : 'Batas pickup contoh: ${food.pickupTime}',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Selects one of the local merchant detail sections.
class _StoreTabs extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Row(
      children: [
        for (final (index, label) in ['Produk', 'Ulasan', 'Tentang'].indexed)
          Expanded(
            child: Column(
              children: [
                TextButton(
                  onPressed: () => onSelected(index),
                  child: I18nText(
                    label,
                    style: TextStyle(
                      color: selected == index
                          ? PanganKitaColors.brandPrimaryStrong
                          : PanganKitaColors.textPrimary,
                      fontWeight: selected == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  height: _tabIndicatorHeight,
                  color: selected == index
                      ? PanganKitaColors.brandPrimaryStrong
                      : Colors.transparent,
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Displays a fixture listing offered in the example store.
class _StoreProduct extends StatelessWidget {
  const new({required this.food, required this.onAdd});

  final DemoFood food;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: _inset)
        .copyWith(top: _cardTopGap),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              food.image,
              width: _productPhoto,
              height: _productPhotoHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _ProductText(food: food)),
          IconButton.filled(
            tooltip: translateDisplayText(
              context,
              'Tambah produk contoh ke keranjang',
            ),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    ),
  );
}

/// Renders food name, price, and stock preview metadata.
class _ProductText extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      I18nText(
        food.id == 'buns'
            ? food.title.replaceFirst(' (Isi 5 pcs)', '')
            : food.title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      if (food.id == 'buns')
        const I18nText('Isi 5 pcs', style: TextStyle(color: Colors.black54))
      else if (food.id == 'garlic-bread')
        const I18nText(
          'Roti panggang dengan garlic butter dan keju · contoh',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black54),
        ),
      Wrap(
        spacing: _priceGap,
        children: [
          I18nText(
            food.price,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
          ),
          if (food.id == 'buns')
            I18nText(
              food.original,
              style: const TextStyle(
                color: Colors.black45,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      ),
      if (food.id == 'buns')
        DecoratedBox(
          decoration: const BoxDecoration(
            color: PanganKitaColors.urgencySurface,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            child: I18nText('${food.stock} · contoh'),
          ),
        ),
    ],
  );
}

/// Shows review previews without submitting or fetching reviews.
class _StoreReviews extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.all(_inset),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          I18nText(
            'Ulasan toko',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: PanganKitaColors.brandAccent),
              const SizedBox(width: 8),
              I18nText(food.rating),
            ],
          ),
          const SizedBox(height: 16),
          const I18nText('Rating contoh, belum diverifikasi.'),
          const SizedBox(height: 8),
          const I18nText('Belum ada ulasan toko dalam demo offline.'),
        ],
      ),
    ),
  );
}

/// Displays reference information about the example store.
class _StoreAbout extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.all(_inset),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          I18nText(
            'Tentang toko',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          I18nText(
            food.merchant,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          I18nText('Kategori: ${_storeCategory(food)}'),
          const SizedBox(height: 8),
          I18nText('Lokasi pickup contoh: ${food.pickupAddress}'),
          const SizedBox(height: 8),
          I18nText('Batas pickup contoh: ${food.pickupTime}'),
          const SizedBox(height: 16),
          const I18nText(
            'Informasi toko ini berasal dari data contoh demo offline.',
          ),
        ],
      ),
    ),
  );
}

/// Provides the local cart action and preview summary.
class _CartFooter extends StatelessWidget {
  const new({required this.cart});

  final DemoCart cart;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: cart,
    builder: (context, child) => SafeArea(
      top: false,
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _inset, vertical: 7),
          child: SizedBox(
            height: _navHeight,
            child: FilledButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.cart).ignore(),
              child: Row(
                children: [
                  Expanded(
                    child: I18nText(
                      '${cart.itemCount} item · ${formatRupiah(cart.subtotal)}',
                      maxLines: 2,
                    ),
                  ),
                  const Icon(Icons.shopping_bag_outlined),
                  const SizedBox(width: 7),
                  const Flexible(child: I18nText('Lihat Keranjang')),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
