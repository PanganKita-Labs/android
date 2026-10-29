import 'package:pangankita/shared/format_rupiah.dart';

/// Illustrative listing copied from the supplied local prototype.
/// Prices, stock, ratings, and merchants are display examples, not live offers.
class DemoFood {
  /// Creates reference display data.
  const new({
    required this.id,
    required this.category,
    required this.merchant,
    required this.title,
    required this.rating,
    required this.saving,
    required this.priceRupiah,
    required this.original,
    required this.pickupTime,
    required this.distance,
    required this.stock,
    this.flash = false,
    this.searchTerms = '',
    this.pickupAddress = 'Lokasi toko contoh',
  });

  /// Asset identifier.
  final String id;

  /// Category label.
  final String category;

  /// Reference merchant name.
  final String merchant;

  /// Illustrative pickup address; not a real location integration.
  final String pickupAddress;

  /// Reference food name.
  final String title;

  /// Reference rating, unverified.
  final String rating;

  /// Reference discount label, not calculated.
  final String saving;

  /// Reference formatted price.
  String get price => formatRupiah(priceRupiah);

  /// Whole-rupiah fixture amount for local cart arithmetic.
  final int priceRupiah;

  /// Reference formatted original price.
  final String original;

  /// Illustrative pickup clock label; not an authoritative deadline.
  final String pickupTime;

  /// Reference distance or countdown, not a live timer.
  final String distance;

  /// Illustrative stock label.
  final String stock;

  /// Whether this reference item belongs to Flash Sale.
  final bool flash;

  /// Additional local keywords for illustrative search.
  final String searchTerms;

  /// Asset used by both the card and detail sheet.
  String get image => id == 'garlic-bread'
      ? 'assets/prototype/garlic-bread.webp'
      : 'assets/prototype/$id.webp';

  /// Reference line breaks for compact cards; search uses the original title.
  String get cardTitle => switch (id) {
    'buns' => title.replaceFirst(' Buns', '\nBuns'),
    'chicken' => title.replaceFirst(' Tanpa', '\nTanpa'),
    'rendang' => title.replaceFirst(' Rendang', '\nRendang'),
    _ => title,
  };

  /// Case-insensitive reference search; no remote requests.
  bool matches(String query, String selectedCategory) =>
      (selectedCategory == 'Semua' || category == selectedCategory) &&
      '$title $merchant $category $searchTerms'.toLowerCase().contains(
        query.trim().toLowerCase(),
      );

  /// Display-only count shown in the HTML.
  /// The local fixture subset contains five examples.
  static const referenceCategoryCount = '18';

  /// Additional display-only product on the Mawar store and search previews.
  static const garlicBread = DemoFood(
    id: 'garlic-bread',
    category: 'Roti & Pastry',
    merchant: 'Mawar Bakery & Cake',
    pickupAddress: 'Mandala by Pass, Medan',
    title: 'Best Cheesy Garlic Bread',
    rating: '4.8 (contoh)',
    saving: 'Hemat (contoh)',
    priceRupiah: 32000,
    original: 'Rp32.000',
    pickupTime: '20.30',
    distance: 'Belum tersedia',
    stock: 'Stok contoh',
  );

  /// Categories from the reference.
  static const categories = [
    'Semua',
    'Aneka Nasi',
    'Roti & Pastry',
    'Kue & Dessert',
  ];

  /// Deterministic visual examples from the HTML; no inventory mutations.
  static const examples = [
    DemoFood(
      id: 'buns',
      category: 'Kue & Dessert',
      merchant: 'Mawar Bakery & Cake',
      pickupAddress: 'Mandala by Pass, Medan',
      title: 'Mawar Coconut Buns (Isi 5 pcs)',
      searchTerms: 'roti',
      rating: '4.8 (106+ ratings)',
      saving: 'Hemat 60%',
      priceRupiah: 32000,
      original: 'Rp65.000',
      pickupTime: '20.30',
      distance: '30 menit lagi',
      stock: 'Sisa 2 kotak',
      flash: true,
    ),
    DemoFood(
      id: 'soto',
      category: 'Aneka Nasi',
      merchant: 'Soto Kesawan',
      title: 'Paket Nasi Soto Jeroan Kesawan',
      rating: '4.9 (120+ ratings)',
      saving: 'Hemat 51%',
      priceRupiah: 28500,
      original: 'Rp58.000',
      pickupTime: '21.30',
      distance: '50 menit lagi',
      stock: 'Tersisa 1 porsi',
      flash: true,
    ),
    DemoFood(
      id: 'roti',
      category: 'Roti & Pastry',
      merchant: 'Raihan Bakery & Cake',
      title: 'Roti Abon Ayam',
      rating: '4.7 (84+ ratings)',
      saving: 'Hemat 41%',
      priceRupiah: 18500,
      original: 'Rp38.000',
      pickupTime: '19.20',
      distance: '800 m',
      stock: 'Tersisa 3 kotak',
    ),
    DemoFood(
      id: 'chicken',
      category: 'Aneka Nasi',
      merchant: 'Hisana Fried Chicken',
      title: 'Ayam Paha Atas Tanpa Tulang',
      rating: '5.0 (300+ ratings)',
      saving: 'Hemat 70%',
      priceRupiah: 8500,
      original: 'Rp38.000',
      pickupTime: '21.00',
      distance: '400 m',
      stock: 'Tersisa 4 potong',
    ),
    DemoFood(
      id: 'rendang',
      category: 'Aneka Nasi',
      merchant: 'RM Putra Buana',
      title: 'Paket Ayam Pop + Rendang Sapi',
      rating: '4.2 (34+ ratings)',
      saving: 'Hemat 16%',
      priceRupiah: 26700,
      original: 'Rp38.000',
      pickupTime: '20.50',
      distance: '100 m',
      stock: 'Tersisa 3 porsi',
    ),
  ];
}
