import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF14313A);
const _orange = Color(0xFFE98412);
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
            const Text(
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
                child: Center(child: Text('Tidak ada toko contoh yang cocok.')),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoresHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton.filledTonal(
        tooltip: 'Kembali',
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
            Text(
              'Toko di Sekitarmu',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: _ink),
            ),
            const Text('Mandala by Pass, Medan · contoh lokasi'),
          ],
        ),
      ),
    ],
  );
}

class _StoresSearch extends StatelessWidget {
  const new({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: 'Cari nama toko atau kategori...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        tooltip: 'Filter toko belum tersedia',
        onPressed: () => DemoNotice.unavailable(context),
        icon: const Icon(Icons.tune),
      ),
    ),
  );
}

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
            label: Text(label),
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

class _StoresSectionHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilihan toko',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: _ink),
            ),
            const Text('4 toko contoh untuk pratinjau'),
          ],
        ),
      ),
      TextButton(
        onPressed: () => DemoNotice.unavailable(context),
        child: const Text('Lihat Peta'),
      ),
    ],
  );
}

class _StoreCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  String get _reviewCount => food.rating.split('(').last.split(' ').first;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: InkWell(
      onTap: () => DemoNotice.unavailable(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    child: Text(
                      '${food.saving} · contoh',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: _avatarRadius,
                      backgroundColor: PanganKitaColors.savingsSurface,
                      backgroundImage: food.id == 'buns'
                          ? const AssetImage('assets/prototype/mawar-mark.webp')
                          : null,
                      child: food.id == 'buns'
                          ? null
                          : Text(
                              food.merchant.substring(0, 1),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: PanganKitaColors.brandPrimaryStrong,
                                  ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.merchant,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            food.id == 'buns' ? 'Roti & Pastry' : food.category,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 12),
                DecoratedBox(
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
                            label: '$_reviewCount ulasan contoh',
                            isRating: true,
                          ),
                        ),
                        const SizedBox(
                          height: _statDividerHeight,
                          child: VerticalDivider(),
                        ),
                        const Expanded(
                          child: _StoreStat(
                            value: '—',
                            label: 'jarak belum ada',
                          ),
                        ),
                        const SizedBox(
                          height: _statDividerHeight,
                          child: VerticalDivider(),
                        ),
                        const Expanded(
                          child: _StoreStat(value: '1', label: 'produk contoh'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

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
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
      Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
