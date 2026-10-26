import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_addon.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _reviewStarCount = 5;
const _merchantPhoto = 40.0;
const _metadataGap = 3.0;
const _badgeInset = 14.0;
const _savingsGap = 4.0;
const _reviewAvatar = 18.0;
const _reviewGap = 6.0;
const _ratingWidth = 62.0;
const _contentGap = 10.0;
const _bodyGap = 8.0;
const _captionSize = 12.0;
const _controlGap = 16.0;
const _detailCorner = 24.0;
const _pageBottom = 32.0;
const _pageGutter = 23.0;
const _sectionGap = 20.0;
const _photoRatio = 2.32;
const _titleSize = 20.0;
const _priceSize = 22.0;

/// Full-screen details for a selected offline listing example.
class ProductDetailPage extends StatefulWidget {
  /// Displays the same product data as its home card.
  const new({required this.food, required this.cart, super.key});

  /// Illustrative listing, not authoritative inventory or a live offer.
  final DemoFood food;

  /// App-owned demo cart shared with the home cart entry.
  final DemoCart cart;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _favorite = false;
  int _quantity = 1;
  Set<DemoAddon> _addons = {};

  void _selectAddons(Set<DemoAddon> addons) => setState(() => _addons = addons);

  void _addToCart() {
    final added = widget.cart.add(
      widget.food,
      quantity: _quantity,
      addons: _addons,
    );
    if (!added) {
      DemoNotice.show(
        context,
        'Batas pratinjau 10 item per pilihan. Ubah jumlah di keranjang.',
      );
      return;
    }
    Navigator.pushNamed<void>(context, AppRoutes.cart);
  }

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
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: _pageGutter)
            .copyWith(top: _captionSize, bottom: _pageBottom),
        children: [
          _DetailToolbar(
            favorite: _favorite,
            onFavorite: _toggleFavorite,
            onCopy: () {
              unawaited(_copyProduct());
            },
          ),
          const SizedBox(height: _sectionGap),
          _MerchantSummary(food: widget.food),
          const SizedBox(height: _sectionGap),
          _ProductSummary(food: widget.food),
          const Divider(height: 32, color: PanganKitaColors.borderNeutral),
          _ProductAddons(selected: _addons, onChanged: _selectAddons),
          const Divider(height: 32, color: PanganKitaColors.borderNeutral),
          const _ProductReviews(),
          const SizedBox(height: 36),
          _QuantityPicker(
            quantity: _quantity,
            onDecrease: _quantity > 1 ? _decrease : null,
            onIncrease: _quantity < DemoCart.quantityLimit ? _increase : null,
          ),
          const SizedBox(height: 32),
          _CartAction(onAdd: _addToCart),
        ],
      ),
    ),
  );
}

class _DetailToolbar extends StatelessWidget {
  const new({
    required this.favorite,
    required this.onFavorite,
    required this.onCopy,
  });
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      BackButton(style: _toolbarStyle),
      const Spacer(),
      IconButton(
        style: _toolbarStyle,
        tooltip: favorite ? 'Hapus favorit sementara' : 'Favoritkan sementara',
        onPressed: onFavorite,
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: favorite ? PanganKitaColors.danger : Colors.black,
        ),
      ),
      const SizedBox(width: 12),
      IconButton(
        style: _toolbarStyle,
        tooltip: 'Salin informasi produk',
        onPressed: onCopy,
        icon: const Icon(Icons.share_outlined),
      ),
    ],
  );
}

final ButtonStyle _toolbarStyle = IconButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  minimumSize: const Size.square(48),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

class _MerchantSummary extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    spacing: _bodyGap,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: SizedBox.square(
          dimension: _merchantPhoto,
          child: Image.asset(
            food.image,
            fit: BoxFit.cover,
            semanticLabel: 'Foto produk contoh dari ${food.merchant}',
          ),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: PanganKitaSpacing.xs,
          children: [
            Text(
              food.merchant,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const Row(
              spacing: _metadataGap,
              children: [
                ReferenceIcon('pin', size: 12),
                Expanded(
                  child: Text(
                    'Mandala by Pass, Medan',
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        width: _ratingWidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: _metadataGap,
              children: [
                const ReferenceIcon(
                  'star',
                  size: 13,
                  color: PanganKitaColors.brandAccent,
                ),
                Text(
                  food.rating.split(' ').first,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PanganKitaColors.brandAccent,
                  ),
                ),
              ],
            ),
            Text(
              food.rating.substring(food.rating.indexOf(' ') + 1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Colors.black54),
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
      _ProductPhoto(food: food),
      Text(
        food.title,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontSize: _titleSize, fontWeight: FontWeight.w700),
      ),
      Text(
        '${food.title} dari ${food.merchant}. '
        'Pilihan contoh untuk diambil langsung di toko.',
        style: const TextStyle(fontSize: 12, height: 1.35),
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
          _SavingsPill(food: food),
        ],
      ),
      Text(
        'Pickup contoh: ${food.pickupTime} · ${food.stock}',
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

class _ProductPhoto extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(_detailCorner)),
    child: AspectRatio(
      aspectRatio: _photoRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(food.image, fit: BoxFit.cover, semanticLabel: food.title),
          const Positioned(
            top: _captionSize,
            left: _badgeInset,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: PanganKitaColors.brandAccent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  'Produk contoh',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ),
          ),
          const Positioned(
            right: 14,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text('1/1', style: TextStyle(fontSize: 10)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SavingsPill extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: PanganKitaColors.borderNeutral),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _savingsGap,
      children: [
        const ReferenceIcon(
          'badge',
          size: 17,
          color: PanganKitaColors.brandPrimary,
        ),
        Text.rich(
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
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class _ProductAddons extends StatelessWidget {
  const new({required this.selected, required this.onChanged});
  final Set<DemoAddon> selected;
  final ValueChanged<Set<DemoAddon>> onChanged;

  void _select(DemoAddon option, bool value) => onChanged(
    value
        ? {...selected, option}
        : selected.where((item) => item != option).toSet(),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Pilih Tambahan', style: Theme.of(context).textTheme.titleMedium),
      const Text(
        'Bikin rasanya makin nikmat! (contoh)',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 16),
      DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: PanganKitaColors.borderNeutral),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            for (final option in DemoAddon.values)
              CheckboxListTile(
                value: selected.contains(option),
                onChanged: (value) => _select(option, value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: PanganKitaColors.brandAccent,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(option.label, style: const TextStyle(fontSize: 12)),
                secondary: Text(
                  '+${formatRupiah(option.priceRupiah)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
          ],
        ),
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
      DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: _contentGap,
            children: [
              const CircleAvatar(
                radius: _reviewAvatar,
                child: Icon(Icons.person_outline),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _savingsGap,
                  children: [
                    const Text(
                      'Pelanggan Demo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      spacing: 2,
                      children: [
                        ...List.filled(
                          _reviewStarCount,
                          const ReferenceIcon(
                            'star',
                            size: 11,
                            color: PanganKitaColors.brandAccent,
                          ),
                        ),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 11,
                            color: PanganKitaColors.brandAccent,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Ulasan contoh',
                      style: TextStyle(fontSize: 9, color: Colors.black54),
                    ),
                    const SizedBox(height: _reviewGap),
                    const Text(
                      'Ini contoh tampilan ulasan pelanggan. '
                      'Belum ada ulasan nyata untuk produk demo ini.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            style: _quantityStyle,
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
            style: _quantityStyle,
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    ],
  );
}

class _CartAction extends StatelessWidget {
  const new({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: _contentGap,
    children: [
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: PanganKitaColors.brandAccent,
          foregroundColor: PanganKitaColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          textStyle: const TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          shape: const StadiumBorder(),
        ),
        onPressed: onAdd,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Tambah ke Keranjang (Demo)'),
      ),
      const Text(
        'Demo offline · Favorit hanya berlaku selama halaman terbuka. '
        'Produk, lokasi, tambahan, dan ulasan adalah contoh. '
        'Jumlah 1-10 item tidak mengubah stok atau membuat pesanan.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ],
  );
}

final ButtonStyle _quantityStyle = IconButton.styleFrom(
  minimumSize: const Size.square(44),
  backgroundColor: const Color(0xFFE8E4DF),
  foregroundColor: Colors.black54,
  disabledForegroundColor: Colors.grey,
);
