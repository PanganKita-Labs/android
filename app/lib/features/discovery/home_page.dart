import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/discovery_navigation.dart';
import 'package:pangankita/features/discovery/food_card.dart';
import 'package:pangankita/features/discovery/hero_banner.dart';
import 'package:pangankita/features/discovery/home_header.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _categoryGap = 5.0;
const _categoryLabelGap = 6.0;
const _categoryFontSize = 9.0;
const _nearbySectionGap = 12.0;

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

class _HomePageState extends State<HomePage> {
  String _query = '';
  String _category = 'Semua';
  String _location = 'Mandala by Pass, Medan';

  @override
  void initState() {
    super.initState();
    _location = widget.initialLocation;
  }

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
                title: Text(
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
              onChanged: (value) => setState(() => _query = value),
              onSubmitted: (value) => Navigator.pushNamed(
                context,
                AppRoutes.search,
                arguments: value.trim(),
              ).ignore(),
              onFilter: () {
                unawaited(_filter());
              },
            ),
            const SizedBox(height: 10),
            const HeroBanner(),
            const SizedBox(height: 20),
            const Text(
              'Kategori',
              style: TextStyle(
                fontFamily: PanganKitaTheme.emphasisFontFamily,
                fontSize: 23,
                height: 1.16,
                letterSpacing: -.45,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14313A),
              ),
            ),
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
            const Text(
              'Demo offline · Semua penawaran, lokasi, rating, dan stok '
              'adalah contoh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _categoryFontSize,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DiscoveryNavigation(selectedIndex: 0),
    );
  }
}

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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: PanganKitaTheme.emphasisFontFamily,
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.45,
                      color: Color(0xFF14313A),
                    ),
                  ),
                  if (!flash)
                    const Text(
                      'Diurutkan dari jarak pickup terdekat',
                      style: TextStyle(fontSize: 9, color: Colors.blueGrey),
                    ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: const Color(0xFF52636B),
              ),
              onPressed: () => DemoNotice.show(
                context,
                'Semua contoh untuk bagian ini sudah ditampilkan.',
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: PanganKitaTheme.emphasisFontFamily,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        if (foods.isEmpty)
          const Text('Tidak ada makanan yang cocok dengan pencarianmu.'),
        for (final food in foods) ...[
          FoodCard(food: food),
          const SizedBox(height: 8),
        ],
      ],
    ),
  );
}

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
        DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0x22FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ReferenceIcon('store', size: 21),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mau lihat berdasarkan toko?',
                style: TextStyle(
                  fontFamily: PanganKitaTheme.emphasisFontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
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
      hintText: 'Temukan makanan lezat di sekitarmu...',
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
        tooltip: 'Filter makanan',
        onPressed: onFilter,
        icon: const ReferenceIcon('filter', size: 19),
      ),
    ),
  );
}

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
                Text(category),
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

class _ReferenceCategoryCount extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(color: Color(0x27FFFFFF), shape: BoxShape.circle),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Text(
        DemoFood.referenceCategoryCount,
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
