import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/navigation/app_bottom_navigation.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/food_card.dart';
import 'package:pangankita/features/discovery/hero_banner.dart';
import 'package:pangankita/features/discovery/home_header.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/models/demo_food.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _categoryGap = 5.0;
const _categoryLabelGap = 6.0;
const _categoryFontSize = 9.0;
const _nearbySectionGap = 12.0;
const _referenceCategoryCount = '18';

void _ignoreAreaChange(String area) {
  if (area.isEmpty) throw ArgumentError.value(area, 'area');
}

/// Searchable local reference feed with category filtering.
class HomePage extends StatefulWidget {
  /// Creates the demo feed.
  const new({
    this.initialLocation = 'Mandala by Pass, Medan',
    this.onLocationChanged = _ignoreAreaChange,
    super.key,
  });

  /// The example area selected for this app session.
  final String initialLocation;

  /// Reports an area change to the app-session owner.
  final ValueChanged<String> onLocationChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Owns the home screen's local query, category, and selected area.
///
/// The selected area is reported to the root app through the provided callback.
class _HomePageState extends State<HomePage> {
  String _query = '';
  String _category = 'Semua';
  String _location = 'Mandala by Pass, Medan';

  @override
  void initState() {
    super.initState();
    _location = widget.initialLocation;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLocation != widget.initialLocation) {
      _location = widget.initialLocation;
    }
  }

  /// Opens the example-area selector and reports a selected area only while
  /// mounted.
  Future<void> _chooseLocation() async {
    final selected = await Navigator.pushNamed(
      context,
      AppRoutes.location,
      arguments: _location,
    );
    if (mounted && selected is String) {
      setState(() => _location = selected);
      widget.onLocationChanged(selected);
    }
  }

  void _selectCategory(String category) => setState(() => _category = category);

  void _searchChanged(String value) => setState(() => _query = value);

  void _submitSearch(String value) => Navigator.pushNamed(
    context,
    AppRoutes.search,
    arguments: value.trim(),
  ).ignore();

  void _openFilter() => unawaited(_filter());

  /// Displays the category picker for the local food fixtures.
  Future<void> _filter() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final category in DemoFood.categories)
              ListTile(
                title: I18nText(
                  category,
                  style: const TextStyle(
                    fontFamily: PanganKitaTheme.bodyFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: category == _category,
                onTap: () {
                  _selectCategory(category);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = DemoFood.examples
        .where((food) => food.matches(_query, _category))
        .toList();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(23, 12, 23, 37),
          children: [
            HomeHeader(
              location: _location,
              onLocationTap: () => unawaited(_chooseLocation()),
            ),
            const SizedBox(height: 14),
            _HomeSearch(
              onChanged: _searchChanged,
              onSubmitted: _submitSearch,
              onFilter: _openFilter,
            ),
            const SizedBox(height: 10),
            const HeroBanner(),
            const SizedBox(height: 20),
            const _HomeCategoryHeading(),
            const SizedBox(height: 2),
            _HomeCategories(selected: _category, onSelected: _selectCategory),
            _FeedSection(
              title: 'Flash Sale',
              flash: true,
              foods: filtered.where((food) => food.flash).toList(),
            ),
            _FeedSection(
              title: 'Dekat dari Lokasimu',
              flash: false,
              foods: filtered.where((food) => !food.flash).toList(),
            ),
            const SizedBox(height: 8),
            const _MerchantBanner(),
            const SizedBox(height: 12),
            const _HomeDemoDisclaimer(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 0),
    );
  }
}

/// Displays the category section's branded title.
class _HomeCategoryHeading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const I18nText(
    'Kategori',
    style: TextStyle(
      fontFamily: PanganKitaTheme.emphasisFontFamily,
      fontSize: 23,
      height: 1.16,
      letterSpacing: -.45,
      fontWeight: FontWeight.w700,
      color: PanganKitaColors.inkCool,
    ),
  );
}

/// Identifies offers, locations, ratings, and stock as examples.
class _HomeDemoDisclaimer extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const I18nText(
    'Demo offline · Semua penawaran, lokasi, rating, dan stok '
    'adalah contoh.',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: _categoryFontSize, color: Colors.blueGrey),
  );
}

/// Displays a feed title and its display-only See All action.
class _FeedHeading extends StatelessWidget {
  const new({required this.title, required this.flash});

  final String title;
  final bool flash;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              title,
              style: const TextStyle(
                fontFamily: PanganKitaTheme.emphasisFontFamily,
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w700,
                letterSpacing: -.45,
                color: PanganKitaColors.inkCool,
              ),
            ),
            if (!flash)
              const I18nText(
                'Diurutkan dari jarak pickup terdekat',
                style: TextStyle(fontSize: 9, color: Colors.blueGrey),
              ),
          ],
        ),
      ),
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: PanganKitaColors.textSecondaryCool,
        ),
        onPressed: () => DemoNotice.show(
          context,
          'Semua contoh untuk bagian ini sudah ditampilkan.',
        ),
        child: const I18nText(
          'Lihat Semua',
          style: TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

/// Displays the store illustration in the merchant banner.
class _MerchantBannerIcon extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0x22FFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(9)),
    ),
    child: Padding(
      padding: EdgeInsets.all(10),
      child: ReferenceIcon('store', size: 21),
    ),
  );
}

/// Renders one category feed using the provided local food examples.
class _FeedSection extends StatelessWidget {
  const new({required this.title, required this.foods, required this.flash});
  final String title;
  final List<DemoFood> foods;
  final bool flash;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: flash ? 0 : _nearbySectionGap),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FeedHeading(title: title, flash: flash),
        const SizedBox(height: 2),
        if (foods.isEmpty)
          const I18nText('Tidak ada makanan yang cocok dengan pencarianmu.'),
        for (final food in foods) ...[
          FoodCard(food: food),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );
}

/// Promotes the nearby-stores preview without querying live merchants.
class _MerchantBanner extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: PanganKitaColors.brandPrimaryStrong,
      padding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),
    onPressed: () =>
        Navigator.pushNamed(context, AppRoutes.nearbyStores).ignore(),
    child: const Row(
      spacing: 15,
      children: [
        _MerchantBannerIcon(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              I18nText(
                'Mau lihat berdasarkan toko?',
                style: TextStyle(
                  fontFamily: PanganKitaTheme.emphasisFontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              I18nText(
                'Jelajahi semua merchant di dekatmu',
                style: TextStyle(
                  fontFamily: PanganKitaTheme.bodyFontFamily,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: Color(0xCCFFFFFF),
                ),
              ),
            ],
          ),
        ),
        ReferenceIcon('chevron', size: 17),
      ],
    ),
  );
}

/// Connects the home search input and filter button to caller callbacks.
class _HomeSearch extends StatelessWidget {
  const new({
    required this.onChanged,
    required this.onSubmitted,
    required this.onFilter,
  });
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: TextInputAction.search,
    style: const TextStyle(fontSize: 11),
    decoration: InputDecoration(
      hintText: translateDisplayText(
        context,
        'Temukan makanan lezat di sekitarmu...',
      ),
      semanticCounterText: 'Cari makanan atau toko',
      hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: PanganKitaColors.brandPrimary),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
      ),
      prefixIcon: const ReferenceIcon('search', size: 18),
      suffixIcon: IconButton(
        tooltip: translateDisplayText(context, 'Filter makanan'),
        onPressed: onFilter,
        icon: const ReferenceIcon('filter', size: 19),
      ),
    ),
  );
}

/// Shows the available fixture categories and selected category.
class _HomeCategories extends StatelessWidget {
  const new({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      spacing: _categoryGap,
      children: [
        for (final category in DemoFood.categories)
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: _categoryLabelGap,
              children: [
                I18nText(category),
                if (category == 'Semua') const _ReferenceCategoryCount(),
              ],
            ),
            selected: selected == category,
            onSelected: (value) => onSelected(category),
            showCheckmark: false,
            shape: const StadiumBorder(),
            side: BorderSide.none,
            backgroundColor: Colors.white,
            selectedColor: PanganKitaColors.brandPrimaryStrong,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            labelPadding: const EdgeInsets.symmetric(horizontal: 6),
            labelStyle: TextStyle(
              fontFamily: PanganKitaTheme.bodyFontFamily,
              fontSize: _categoryFontSize,
              fontWeight: FontWeight.w500,
              color: selected == category
                  ? Colors.white
                  : PanganKitaColors.textPrimary,
            ),
          ),
      ],
    ),
  );
}

/// Displays the illustrative count or caption for a category.
class _ReferenceCategoryCount extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(color: Color(0x27FFFFFF), shape: BoxShape.circle),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: I18nText(
        _referenceCategoryCount,
        style: TextStyle(
          fontFamily: PanganKitaTheme.emphasisFontFamily,
          fontSize: 9,
          height: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
