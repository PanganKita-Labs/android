import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/models/demo_food.dart';

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
const _recommendationCount = 2;
const _recommendationImageSize = 48.0;

/// Search and filter preview over local listing examples.
class SearchPage extends StatefulWidget {
  /// Initializes a fixture search with [initialQuery].
  ///
  /// Leading and trailing whitespace is removed at screen initialization.
  const new({this.initialQuery = '', super.key});

  /// Initial local query; no remote search is performed.
  final String initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

/// Owns local search text, filters, and temporary favorites.
///
/// Creates and disposes its text controller and search focus node.
/// Results are derived from [DemoFood] fixtures, without remote search;
/// favorites and filters are discarded when this state is removed.
class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final _favorites = <String>{};
  final _searchFocus = FocusNode();
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
    _searchFocus.dispose();
    super.dispose();
  }

  /// Returns fixture results matching the active query and price filters.
  ///
  /// The optional sort only reorders the in-memory list.
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

  /// Opens a modal with a temporary copy of the current search filters.
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

  /// Applies the validated [filters] record to page-local search state.
  ///
  /// Nullable price bounds are inclusive; the sorting flag affects only
  /// local ordering. The filter sheet is then dismissed without persistence.
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

  /// Restores the default category, price bounds, and sort order.
  void _resetFilters() => setState(() {
    _category = 'Semua';
    _minimum = null;
    _maximum = null;
    _lowestPriceFirst = false;
  });

  /// Copies a suggested query into the text field and updates local results.
  void _acceptSuggestion(String query) {
    _controller.text = query;
    setState(() => _query = query);
  }

  void _editSearch() => _searchFocus.requestFocus();

  /// Toggles the fixture favorite [id] only in this search screen.
  ///
  /// No favorites list, profile data, or storage is updated elsewhere.
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
              focusNode: _searchFocus,
              onChanged: (value) => setState(() => _query = value.trim()),
              onFilter: _openFilters,
            ),
            const SizedBox(height: 12),
            const _SearchLocation(),
            const SizedBox(height: 24),
            _QuickFilters(
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
              onDiscount: _openFilters,
            ),
            const SizedBox(height: 24),
            if (results.isEmpty)
              _EmptySearch(
                onEditSearch: _editSearch,
                onResetFilters: _resetFilters,
                onSuggestion: _acceptSuggestion,
              )
            else ...[
              _ResultHeading(query: _query, count: results.length),
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

/// Shows the fixed illustrative area used by the search preview.
class _SearchLocation extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Icon(Icons.location_on, color: PanganKitaColors.brandPrimary),
      SizedBox(width: 8),
      Expanded(child: I18nText('Mandala by Pass, Medan · contoh lokasi')),
    ],
  );
}

/// Displays the active search query and matching fixture count.
class _ResultHeading extends StatelessWidget {
  const new({required this.query, required this.count});

  final String query;
  final int count;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      I18nText(
        query.isEmpty ? 'Makanan contoh' : 'Hasil untuk “$query”',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      I18nText('$count makanan contoh ditemukan'),
    ],
  );
}

/// Shows the result title and toggles a session-only favorite.
class _SearchTitle extends StatelessWidget {
  const new({
    required this.food,
    required this.favorite,
    required this.onFavorite,
  });

  final DemoFood food;
  final bool favorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: I18nText(
          food.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      IconButton(
        tooltip: favorite ? 'Hapus favorit sementara' : 'Favoritkan sementara',
        onPressed: onFavorite,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          size: _favoriteIconSize,
          color: PanganKitaColors.textPrimary,
        ),
      ),
    ],
  );
}

/// Shows merchant information from the local search result.
class _SearchMerchant extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _merchantAvatarRadius,
        backgroundImage: AssetImage(food.image),
      ),
      const SizedBox(width: 5),
      const Icon(
        Icons.storefront_outlined,
        size: 14,
        color: PanganKitaColors.brandPrimaryStrong,
      ),
      const SizedBox(width: 3),
      Expanded(
        child: I18nText(
          food.merchant,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ],
  );
}

/// Provides the illustration for a query with no fixture matches.
class _EmptySearchIcon extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Center(
    child: CircleAvatar(
      radius: 55,
      backgroundColor: PanganKitaColors.savingsSurface,
      child: Icon(
        Icons.search,
        size: 60,
        color: PanganKitaColors.brandPrimaryStrong,
      ),
    ),
  );
}

/// Lets the user edit the query or clear local search filters.
class _EmptySearchButtons extends StatelessWidget {
  const new({required this.onEdit, required this.onReset});

  final VoidCallback onEdit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: onEdit,
          child: const I18nText('Ubah Pencarian'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextButton(
          onPressed: onReset,
          child: const I18nText('Reset Filter'),
        ),
      ),
    ],
  );
}

/// Displays the filter sheet heading and its reset control.
class _FilterHeading extends StatelessWidget {
  const new({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: I18nText(
          'Filter Pencarian',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      TextButton(onPressed: onReset, child: const I18nText('Reset')),
    ],
  );
}

/// Displays local search-price validation feedback.
class _FilterError extends StatelessWidget {
  const new({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) =>
      I18nText(error, style: const TextStyle(color: PanganKitaColors.danger));
}

/// Invokes the filter sheet's validated apply callback.
class _FilterApply extends StatelessWidget {
  const new({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: PanganKitaColors.brandPrimaryStrong,
      foregroundColor: Colors.white,
    ),
    onPressed: onApply,
    child: const I18nText('Tampilkan Hasil'),
  );
}

/// Collects search input and exposes the filter sheet action.
class _SearchBar extends StatelessWidget {
  const new({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

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
      const SizedBox(width: 8),
      Expanded(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: translateDisplayText(context, 'Cari makanan...'),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              tooltip: translateDisplayText(context, 'Hapus pencarian'),
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
        tooltip: translateDisplayText(context, 'Filter pencarian'),
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

/// Shows predefined filters for the local result set.
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
          label: I18nText(category),
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
        label: const I18nText('Filter'),
        backgroundColor: Colors.white,
        side: const BorderSide(color: PanganKitaColors.borderNeutral),
        onPressed: onDiscount,
      ),
    ],
  );
}

/// Displays one fixture search result and its navigation action.
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

/// Renders the product image for a fixture search result.
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
            child: I18nText(
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

/// Groups a local result's title, merchant, and price metadata.
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
      _SearchTitle(food: food, favorite: favorite, onFavorite: onFavorite),
      const SizedBox(height: 8),
      _SearchMerchant(food: food),
      const SizedBox(height: 8),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: _priceGap,
        children: [
          I18nText(
            food.price,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: PanganKitaColors.brandPrimaryStrong),
          ),
          I18nText(
            food.original,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _SearchPickupMeta(pickupTime: food.pickupTime),
    ],
  );
}

/// Shows static pickup and stock captions for a fixture.
class _SearchPickupMeta extends StatelessWidget {
  const new({required this.pickupTime});

  final String pickupTime;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Row(
        children: [
          Icon(Icons.location_on_outlined, size: 14),
          Expanded(child: I18nText('Jarak belum tersedia')),
        ],
      ),
      Row(
        children: [
          const Icon(
            Icons.schedule,
            size: 14,
            color: PanganKitaColors.brandAccent,
          ),
          Expanded(child: I18nText('Ambil $pickupTime (contoh)')),
        ],
      ),
    ],
  );
}

/// Shows an empty result state with filter reset actions.
class _EmptySearch extends StatelessWidget {
  const new({
    required this.onSuggestion,
    required this.onEditSearch,
    required this.onResetFilters,
  });

  final ValueChanged<String> onSuggestion;
  final VoidCallback onEditSearch;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 35),
      const _EmptySearchIcon(),
      const SizedBox(height: 16),
      I18nText(
        'Belum ketemu makananmu',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const I18nText(
        'Coba kata kunci lain dari contoh makanan yang tersedia.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      _EmptySearchButtons(onEdit: onEditSearch, onReset: onResetFilters),
      const SizedBox(height: 18),
      I18nText(
        'Mungkin Kamu Suka',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      for (final food in DemoFood.examples.take(_recommendationCount))
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox.square(
            dimension: _recommendationImageSize,
            child: Image.asset(food.image, fit: BoxFit.cover),
          ),
          title: I18nText(
            food.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: I18nText(food.price),
          onTap: () => onSuggestion(food.title),
        ),
    ],
  );
}

/// Collects temporary search filters before notifying its parent.
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

// Empty bounds are unbounded. Whitespace-only and malformed bounds are
// invalid, matching the original search-filter behavior.
/// Parses optional whole-rupiah bounds from the filter text fields.
///
/// Returns `null` for malformed, negative, or reversed ranges; absent bounds
/// remain unbounded. Whitespace-only nonempty input is invalid.
({int? minimum, int? maximum})? _parseSearchPriceRange(
  String minimumInput,
  String maximumInput,
) {
  final minimum = int.tryParse(minimumInput.trim());
  final maximum = int.tryParse(maximumInput.trim());
  if (!_isValidPriceBound(minimumInput, minimum) ||
      !_isValidPriceBound(maximumInput, maximum)) {
    return null;
  }
  if (minimum != null && maximum != null && minimum > maximum) {
    return null;
  }
  return (minimum: minimum, maximum: maximum);
}

/// Whether a raw bound is empty or parses as a nonnegative integer.
bool _isValidPriceBound(String raw, int? parsed) {
  if (raw.isNotEmpty && parsed == null) return false;
  return parsed == null || parsed >= 0;
}

/// Manages filter-sheet inputs and local validation errors.
///
/// Invalid price ranges are not submitted to the owning search page.
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

  /// Validates the current price range before notifying the search page.
  void _apply() {
    final range = _parseSearchPriceRange(_minimum.text, _maximum.text);
    if (range == null) {
      setState(() => _error = 'Masukkan rentang harga yang valid.');
      return;
    }
    widget.onApply((
      category: _category,
      minimum: range.minimum,
      maximum: range.maximum,
      lowestPriceFirst: _lowestPriceFirst,
    ));
  }

  /// Clears all temporary filter values and their validation message.
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
          _FilterHeading(onReset: _reset),
          const Divider(),
          I18nText('Kategori', style: Theme.of(context).textTheme.titleMedium),
          _SearchCategoryChoices(
            selected: _category,
            onSelected: (category) => setState(() => _category = category),
          ),
          const Divider(),
          I18nText(
            'Rentang harga (Rp)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _SearchPriceFields(minimum: _minimum, maximum: _maximum),
          const Divider(),
          I18nText('Jarak', style: Theme.of(context).textTheme.titleMedium),
          const I18nText('Filter jarak belum tersedia pada data contoh.'),
          const Divider(),
          I18nText('Urutkan', style: Theme.of(context).textTheme.titleMedium),
          _SearchSortChoices(
            lowestPriceFirst: _lowestPriceFirst,
            onSelected: (value) => setState(() => _lowestPriceFirst = value),
          ),
          const Divider(),
          I18nText(
            'Hanya toko buka',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const I18nText('Status buka belum tersedia pada data contoh.'),
          if (_error case final String error) _FilterError(error: error),
          const SizedBox(height: 16),
          _FilterApply(onApply: _apply),
        ],
      ),
    ),
  );
}

/// Displays local fixture categories in the filter sheet.
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
          label: I18nText(category),
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

/// Collects optional whole-rupiah minimum and maximum bounds.
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
          decoration: InputDecoration(
            labelText: translateDisplayText(context, 'Minimum'),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: TextField(
          controller: maximum,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: translateDisplayText(context, 'Maksimum'),
          ),
        ),
      ),
    ],
  );
}

/// Selects whether local results are ordered by lowest price.
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
        title: const I18nText('Urutan contoh'),
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
        title: const I18nText('Harga terendah'),
        onTap: () => onSelected(true),
      ),
    ],
  );
}
