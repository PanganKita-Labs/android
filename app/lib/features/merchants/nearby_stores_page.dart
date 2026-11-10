import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkCool;
const Color _orange = PanganKitaColors.referenceOrange;
const _cardRadius = 20.0;
const _imageHeight = 126.0;
const _avatarRadius = 20.0;
const _chipGap = 7.0;
const _statDividerHeight = 32.0;
const _statIconSize = 14.0;

const _storeIds = ['buns', 'soto', 'roti', 'chicken'];

/// Searchable visual preview of the supplied nearby-stores design.
class NearbyStoresPage extends StatefulWidget {
  /// Creates the page without live merchant or location data.
  const new({super.key});

  @override
  State<NearbyStoresPage> createState() => _NearbyStoresPageState();
}

/// Owns the local store query and category selection.
///
/// The list is filtered from examples, not discovered via device location.
class _NearbyStoresPageState extends State<NearbyStoresPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final stores = DemoFood.examples.where(
      (food) =>
          _storeIds.contains(food.id) &&
          '${food.merchant} ${food.category}'.toLowerCase().contains(
            _query.trim().toLowerCase(),
          ),
    );
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(23, 18, 23, 36),
          children: [
            const _StoresHeader(),
            const SizedBox(height: 20),
            _StoresSearch(onChanged: (value) => setState(() => _query = value)),
            const SizedBox(height: 14),
            const _StoresFilters(),
            const SizedBox(height: 22),
            const _StoresSectionHeader(),
            const SizedBox(height: 6),
            const I18nText(
              'Contoh tampilan · belum memakai lokasi atau data toko nyata.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            for (final food in stores) ...[
              _StoreCard(food: food),
              const SizedBox(height: 16),
            ],
            if (stores.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(
                  child: I18nText('Tidak ada toko contoh yang cocok.'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows the nearby-store heading and map navigation.
class _StoresHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton.filledTonal(
        tooltip: translateDisplayText(context, 'Kembali'),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: PanganKitaColors.textPrimary,
        ),
        icon: const Icon(Icons.arrow_back),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              'Toko di Sekitarmu',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: _ink),
            ),
            const I18nText('Mandala by Pass, Medan · contoh lokasi'),
          ],
        ),
      ),
    ],
  );
}

/// Collects a store query for in-memory fixture matching.
class _StoresSearch extends StatelessWidget {
  const new({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: translateDisplayText(
        context,
        'Cari nama toko atau kategori...',
      ),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        tooltip: translateDisplayText(context, 'Filter toko belum tersedia'),
        onPressed: () => DemoNotice.unavailable(context),
        icon: const Icon(Icons.tune),
      ),
    ),
  );
}

/// Displays local store-category filter controls.
class _StoresFilters extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final label in [
          'Terdekat',
          'Buka Sekarang',
          'Diskon Terbesar',
          'Rating',
        ]) ...[
          ChoiceChip(
            label: I18nText(label),
            selected: label == 'Terdekat',
            showCheckmark: false,
            selectedColor: PanganKitaColors.brandPrimaryStrong,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              fontFamily: PanganKitaTheme.bodyFontFamily,
              color: label == 'Terdekat' ? Colors.white : _ink,
            ),
            side: BorderSide.none,
            onSelected: (_) => DemoNotice.unavailable(context),
          ),
          const SizedBox(width: _chipGap),
        ],
      ],
    ),
  );
}

/// Labels the list of available example stores.
class _StoresSectionHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              'Pilihan toko',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: _ink),
            ),
            const I18nText('4 toko contoh untuk pratinjau'),
          ],
        ),
      ),
      TextButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.nearbyMap).ignore(),
        child: const I18nText('Lihat Peta'),
      ),
    ],
  );
}

/// Displays an illustrative merchant preview and opens its detail.
class _StoreCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

/// Opens the local detail route for the selected fixture merchant.
  void _openStore(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.store(food.id)).ignore();

  String get _reviewCount => food.rating.split('(').last.split(' ').first;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: InkWell(
      onTap: () => _openStore(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StoreBanner(food: food),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _StoreIdentity(food: food),
                const SizedBox(height: 12),
                _StoreStats(food: food, reviewCount: _reviewCount),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Shows the example store cover image and category.
class _StoreBanner extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.bottomRight,
    children: [
      Image.asset(
        food.id == 'buns'
            ? 'assets/prototype/store-croissants.webp'
            : food.image,
        height: _imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _orange,
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: I18nText(
              '${food.saving} · contoh',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
  );
}

/// Displays store name, branding, and sample address.
class _StoreIdentity extends StatelessWidget {
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
            : I18nText(
                food.merchant.substring(0, 1),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
              ),
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
            I18nText(food.id == 'buns' ? 'Roti & Pastry' : food.category),
          ],
        ),
      ),
      const Icon(Icons.chevron_right),
    ],
  );
}

/// Groups static review, distance, and product-count captions.
class _StoreStats extends StatelessWidget {
  const new({required this.food, required this.reviewCount});

  final DemoFood food;
  final String reviewCount;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: PanganKitaColors.surfaceWarm,
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StoreStat(
              value: food.rating.split(' ').first,
              label: '$reviewCount ulasan contoh',
              isRating: true,
            ),
          ),
          const SizedBox(height: _statDividerHeight, child: VerticalDivider()),
          const Expanded(
            child: _StoreStat(value: '—', label: 'jarak belum ada'),
          ),
          const SizedBox(height: _statDividerHeight, child: VerticalDivider()),
          Expanded(
            child: _StoreStat(
              value: food.id == 'buns' ? '2' : '1',
              label: 'produk contoh',
            ),
          ),
        ],
      ),
    ),
  );
}

/// Formats one preview statistic and its explanatory caption.
class _StoreStat extends StatelessWidget {
  const new({required this.value, required this.label, this.isRating = false});

  final String value;
  final String label;
  final bool isRating;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isRating)
            const Icon(
              Icons.star,
              size: _statIconSize,
              color: PanganKitaColors.brandAccent,
            ),
          Flexible(
            child: I18nText(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
      I18nText(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
