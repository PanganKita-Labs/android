import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/food_card.dart';
import 'package:pangankita/features/discovery/hero_banner.dart';
import 'package:pangankita/features/discovery/home_header.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _categoryGap = 5.0;
const _categoryLabelGap = 6.0;
const _categoryFontSize = 11.0;
const _navigationHeight = 70.0;
const _navigationFontSize = 12.5;
const _navigationLineHeight = 1.2;

/// Searchable local reference feed with category filtering.
class HomePage extends StatefulWidget {
  /// Creates the demo feed.
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
  String _category = 'Semua';

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
                title: Text(category),
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
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 37),
          children: [
            const HomeHeader(),
            const SizedBox(height: 18),
            _HomeSearch(
              onChanged: (value) => setState(() => _query = value),
              onFilter: () {
                unawaited(_filter());
              },
            ),
            const SizedBox(height: 15),
            const HeroBanner(),
            const SizedBox(height: 28),
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 23,
                height: 1.16,
                letterSpacing: -.45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 26),
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
      bottomNavigationBar: const _HomeNavigation(),
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
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (flash) const _PickupSignal(),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.45,
                    ),
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
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        if (!flash)
          const Text(
            'Diurutkan dari jarak pickup terdekat',
            style: TextStyle(fontSize: 10.8, color: Colors.blueGrey),
          ),
        const SizedBox(height: 11),
        if (foods.isEmpty)
          const Text('Tidak ada makanan yang cocok dengan pencarianmu.'),
        for (final food in foods) ...[
          FoodCard(food: food),
          const SizedBox(height: 9),
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
      padding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),
    onPressed: () => DemoNotice.unavailable(context),
    child: const Row(
      spacing: 15,
      children: [
        ReferenceIcon('store', size: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mau lihat berdasarkan toko?',
                style: TextStyle(fontSize: 13.2, fontWeight: FontWeight.w700),
              ),
              Text(
                'Jelajahi semua merchant di dekatmu',
                style: TextStyle(fontSize: 10.8),
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
  const new({required this.onChanged, required this.onFilter});
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      hintText: 'Temukan makanan lezat di sekitarmu...',
      semanticCounterText: 'Cari makanan atau toko',
      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: PanganKitaColors.brandPrimary),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
      ),
      prefixIcon: const ReferenceIcon('search'),
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
            selectedColor: PanganKitaColors.brandPrimary,
            labelStyle: TextStyle(
              fontSize: _categoryFontSize,
              fontWeight: FontWeight.w600,
              color: selected == category
                  ? Colors.white
                  : PanganKitaColors.textPrimary,
            ),
          ),
      ],
    ),
  );
}

class _HomeNavigation extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => NavigationBar(
    height: _navigationHeight,
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        fontFamily: PanganKitaTheme.referenceFontFamily,
        fontSize: _navigationFontSize,
        height: _navigationLineHeight,
        color: states.contains(WidgetState.selected)
            ? PanganKitaColors.brandPrimary
            : const Color(0xFF8D8F90),
        fontWeight: states.contains(WidgetState.selected)
            ? FontWeight.w700
            : FontWeight.w400,
      ),
    ),
    onDestinationSelected: (index) {
      if (index != 0) DemoNotice.unavailable(context);
    },
    destinations: const [
      NavigationDestination(
        icon: ReferenceIcon('home'),
        selectedIcon: ReferenceIcon('home-filled'),
        label: 'Beranda',
      ),
      NavigationDestination(icon: ReferenceIcon('bag'), label: 'Pesanan'),
      NavigationDestination(icon: ReferenceIcon('chat'), label: 'Chat'),
      NavigationDestination(icon: ReferenceIcon('bell'), label: 'Notifikasi'),
    ],
  );
}

class _PickupSignal extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Row(
    spacing: 9,
    children: [
      SizedBox(
        width: 8,
        height: 8,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: PanganKitaColors.brandAccent,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x30E9AE50), spreadRadius: 4)],
          ),
        ),
      ),
      Flexible(
        child: Text(
          'PICKUP SEGERA',
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: .22,
            height: 1.2,
            color: PanganKitaColors.brandAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
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
        style: TextStyle(fontSize: 9, height: 1),
      ),
    ),
  );
}
