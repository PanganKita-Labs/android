import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';

const _pageInset = 18.0;
const _cardPhotoWidth = 108.0;
const _cardPhotoHeight = 142.0;
const _resultGap = 11.0;
const _chipGap = 8.0;
const _sheetTopInset = 8.0;
const _topInset = 12.0;
const _bottomInset = 24.0;
const _badgeInset = 5.0;
const _badgeTopInset = 6.0;
const _favoriteIconSize = 20.0;
const _merchantAvatarRadius = 10.0;
const _priceGap = 4.0;

/// Search and filter preview over local listing examples.
class SearchPage extends StatefulWidget {
  /// Starts with the query submitted from Home.
  const new({this.initialQuery = '', super.key});

  /// Initial local query; no remote search is performed.
  final String initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final _favorites = <String>{};
  String _query = '';
  String _category = 'Semua';
  int? _minimum;
  int? _maximum;
  bool _lowestPriceFirst = false;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery.trim();
    _controller.text = _query;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<DemoFood> get _results {
    final minimum = _minimum;
    final maximum = _maximum;
    final foods = [DemoFood.garlicBread, ...DemoFood.examples]
        .where(
          (food) =>
              food.matches(_query, _category) &&
              (minimum == null || food.priceRupiah >= minimum) &&
              (maximum == null || food.priceRupiah <= maximum),
        )
        .toList();
    if (_lowestPriceFirst) {
      foods.sort((a, b) => a.priceRupiah.compareTo(b.priceRupiah));
    }
    return foods;
  }

  void _openFilters() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: PanganKitaColors.surfaceWarm,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => _SearchFilters(
          category: _category,
          minimum: _minimum,
          maximum: _maximum,
          lowestPriceFirst: _lowestPriceFirst,
          onApply: _applyFilters,
        ),
      ),
    );
  }

  void _applyFilters(
    ({String category, int? minimum, int? maximum, bool lowestPriceFirst})
    filters,
  ) {
    setState(() {
      _category = filters.category;
      _minimum = filters.minimum;
      _maximum = filters.maximum;
      _lowestPriceFirst = filters.lowestPriceFirst;
    });
    Navigator.pop(context);
  }

  void _toggleFavorite(String id) => setState(
    () => _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id),
  );

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: _pageInset)
              .copyWith(top: _topInset, bottom: _bottomInset),
          children: [
            _SearchBar(
              controller: _controller,
              onChanged: (value) => setState(() => _query = value.trim()),
              onFilter: _openFilters,
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.location_on, color: PanganKitaColors.brandPrimary),
                SizedBox(width: 8),
                Expanded(child: Text('Mandala by Pass, Medan · contoh lokasi')),
              ],
            ),
            const SizedBox(height: 24),
            _QuickFilters(
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
              onDiscount: _openFilters,
            ),
            const SizedBox(height: 24),
            if (results.isEmpty)
              _EmptySearch(
                onSuggestion: (query) {
                  _controller.text = query;
                  setState(() => _query = query);
                },
              )
            else ...[
              Text(
                _query.isEmpty ? 'Makanan contoh' : 'Hasil untuk “$_query”',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text('${results.length} makanan contoh ditemukan'),
              const SizedBox(height: 14),
              for (final food in results) ...[
                _SearchResultCard(
                  food: food,
                  favorite: _favorites.contains(food.id),
                  onFavorite: () => _toggleFavorite(food.id),
                ),
                const SizedBox(height: _resultGap),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const new({
    required this.controller,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

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
      const SizedBox(width: 8),
      Expanded(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Cari makanan...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              tooltip: 'Hapus pencarian',
              onPressed: () {
                controller.clear();
                onChanged('');
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton.filledTonal(
        tooltip: 'Filter pencarian',
        onPressed: onFilter,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: PanganKitaColors.textPrimary,
        ),
        icon: const Icon(Icons.tune),
      ),
    ],
  );
}

class _QuickFilters extends StatelessWidget {
  const new({
    required this.selected,
    required this.onSelected,
    required this.onDiscount,
  });

  final String selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onDiscount;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _chipGap,
    children: [
      for (final category in ['Semua', 'Roti & Pastry'])
        ChoiceChip(
          label: Text(category),
          selected: selected == category,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          backgroundColor: Colors.white,
          side: const BorderSide(color: PanganKitaColors.borderNeutral),
          labelStyle: TextStyle(
            color: selected == category
                ? Colors.white
                : PanganKitaColors.textPrimary,
          ),
          onSelected: (_) => onSelected(category),
        ),
      ActionChip(
        label: const Text('Filter'),
        backgroundColor: Colors.white,
        side: const BorderSide(color: PanganKitaColors.borderNeutral),
        onPressed: onDiscount,
      ),
    ],
  );
}

class _SearchResultCard extends StatelessWidget {
  const new({
    required this.food,
    required this.favorite,
    required this.onFavorite,
  });

  final DemoFood food;
  final bool favorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: InkWell(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.product(food.id)).ignore(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _SearchResultPhoto(food: food),
            const SizedBox(width: 10),
            Expanded(
              child: _SearchResultInfo(
                food: food,
                favorite: favorite,
                onFavorite: onFavorite,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SearchResultPhoto extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Image.asset(
          food.image,
          width: _cardPhotoWidth,
          height: _cardPhotoHeight,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        left: _badgeInset,
        top: _badgeTopInset,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: PanganKitaColors.brandAccent,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              food.saving,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
  );
}

class _SearchResultInfo extends StatelessWidget {
  const new({
    required this.food,
    required this.favorite,
    required this.onFavorite,
  });

  final DemoFood food;
  final bool favorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              food.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            tooltip: favorite
                ? 'Hapus favorit sementara'
                : 'Favoritkan sementara',
            onPressed: onFavorite,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              size: _favoriteIconSize,
              color: PanganKitaColors.textPrimary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          CircleAvatar(
            radius: _merchantAvatarRadius,
            backgroundImage: AssetImage(food.image),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              food.merchant,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: _priceGap,
        children: [
          Text(
            food.price,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
          ),
          Text(
            food.original,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        'Pickup contoh: ${food.pickupTime}',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: PanganKitaColors.brandAccent),
      ),
    ],
  );
}

class _EmptySearch extends StatelessWidget {
  const new({required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 55),
      const CircleAvatar(
        radius: 65,
        backgroundColor: PanganKitaColors.savingsSurface,
        child: Icon(
          Icons.search,
          size: 70,
          color: PanganKitaColors.brandPrimaryStrong,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Belum ketemu makananmu',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const Text('Coba kata kunci lain dari contoh makanan yang tersedia.'),
      const SizedBox(height: 26),
      const Text('Coba cari'),
      Wrap(
        spacing: _chipGap,
        children: [
          for (final query in ['Roti', 'Nasi', 'Ayam'])
            ActionChip(
              label: Text(query),
              onPressed: () => onSuggestion(query),
            ),
        ],
      ),
    ],
  );
}

class _SearchFilters extends StatefulWidget {
  const new({
    required this.category,
    required this.minimum,
    required this.maximum,
    required this.lowestPriceFirst,
    required this.onApply,
  });

  final String category;
  final int? minimum;
  final int? maximum;
  final bool lowestPriceFirst;
  final ValueChanged<
    ({String category, int? minimum, int? maximum, bool lowestPriceFirst})
  >
  onApply;

  @override
  State<_SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<_SearchFilters> {
  String _category = 'Semua';
  bool _lowestPriceFirst = false;
  final TextEditingController _minimum = TextEditingController();
  final TextEditingController _maximum = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _lowestPriceFirst = widget.lowestPriceFirst;
    _minimum.text = widget.minimum?.toString() ?? '';
    _maximum.text = widget.maximum?.toString() ?? '';
  }

  @override
  void dispose() {
    _minimum.dispose();
    _maximum.dispose();
    super.dispose();
  }

  void _apply() {
    final min = int.tryParse(_minimum.text.trim());
    final max = int.tryParse(_maximum.text.trim());
    if ((_minimum.text.isNotEmpty && min == null) ||
        (_maximum.text.isNotEmpty && max == null) ||
        (min != null && max != null && min > max)) {
      setState(() => _error = 'Masukkan rentang harga yang valid.');
      return;
    }
    widget.onApply((
      category: _category,
      minimum: min,
      maximum: max,
      lowestPriceFirst: _lowestPriceFirst,
    ));
  }

  void _reset() {
    setState(() {
      _category = 'Semua';
      _lowestPriceFirst = false;
      _minimum.clear();
      _maximum.clear();
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: _pageInset).copyWith(
        top: _sheetTopInset,
        bottom: MediaQuery.viewInsetsOf(context).bottom + _pageInset,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filter Pencarian',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(onPressed: _reset, child: const Text('Reset')),
            ],
          ),
          const Divider(),
          Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
          _SearchCategoryChoices(
            selected: _category,
            onSelected: (category) => setState(() => _category = category),
          ),
          const Divider(),
          Text(
            'Rentang harga (Rp)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _SearchPriceFields(minimum: _minimum, maximum: _maximum),
          const Divider(),
          Text('Jarak', style: Theme.of(context).textTheme.titleMedium),
          const Text('Filter jarak belum tersedia pada data contoh.'),
          const Divider(),
          Text('Urutkan', style: Theme.of(context).textTheme.titleMedium),
          _SearchSortChoices(
            lowestPriceFirst: _lowestPriceFirst,
            onSelected: (value) => setState(() => _lowestPriceFirst = value),
          ),
          const Divider(),
          Text(
            'Hanya toko buka',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text('Status buka belum tersedia pada data contoh.'),
          if (_error != null)
            Text(
              _error ?? '',
              style: const TextStyle(color: PanganKitaColors.danger),
            ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: PanganKitaColors.brandPrimaryStrong,
              foregroundColor: Colors.white,
            ),
            onPressed: _apply,
            child: const Text('Tampilkan Hasil'),
          ),
        ],
      ),
    ),
  );
}

class _SearchCategoryChoices extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _chipGap,
    children: [
      for (final category in DemoFood.categories)
        ChoiceChip(
          label: Text(category),
          selected: selected == category,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          backgroundColor: Colors.white,
          side: const BorderSide(color: PanganKitaColors.borderNeutral),
          labelStyle: TextStyle(
            color: selected == category
                ? Colors.white
                : PanganKitaColors.textPrimary,
          ),
          onSelected: (_) => onSelected(category),
        ),
    ],
  );
}

class _SearchPriceFields extends StatelessWidget {
  const new({required this.minimum, required this.maximum});

  final TextEditingController minimum;
  final TextEditingController maximum;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: minimum,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Minimum'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: TextField(
          controller: maximum,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Maksimum'),
        ),
      ),
    ],
  );
}

class _SearchSortChoices extends StatelessWidget {
  const new({required this.lowestPriceFirst, required this.onSelected});

  final bool lowestPriceFirst;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          lowestPriceFirst
              ? Icons.radio_button_unchecked
              : Icons.radio_button_checked,
          color: PanganKitaColors.brandPrimaryStrong,
        ),
        title: const Text('Urutan contoh'),
        onTap: () => onSelected(false),
      ),
      ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          lowestPriceFirst
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: PanganKitaColors.brandPrimaryStrong,
        ),
        title: const Text('Harga terendah'),
        onTap: () => onSelected(true),
      ),
    ],
  );
}
