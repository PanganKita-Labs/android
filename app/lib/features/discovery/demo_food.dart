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
    required this.price,
    required this.original,
    required this.shipping,
    required this.distance,
    required this.stock,
    this.flash = false,
  });

  /// Asset identifier.
  final String id;

  /// Category label.
  final String category;

  /// Reference merchant name.
  final String merchant;

  /// Reference food name.
  final String title;

  /// Reference rating, unverified.
  final String rating;

  /// Reference discount label, not calculated.
  final String saving;

  /// Reference formatted price.
  final String price;

  /// Reference formatted original price.
  final String original;

  /// Illustrative delivery fee retained from HTML; no delivery is offered.
  final String shipping;

  /// Reference distance or countdown, not a live timer.
  final String distance;

  /// Illustrative stock label.
  final String stock;

  /// Whether this reference item belongs to Flash Sale.
  final bool flash;

  /// Asset used by both the card and detail sheet.
  String get image => 'assets/prototype/$id.webp';

  /// Case-insensitive reference search; no remote requests.
  bool matches(String query, String selectedCategory) =>
      (selectedCategory == 'Semua' || category == selectedCategory) &&
      '$title $merchant $category'.toLowerCase().contains(
        query.trim().toLowerCase(),
      );

  /// Display-only count shown in the HTML.
  /// The local fixture subset contains five examples.
  static const referenceCategoryCount = '18';

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
      title: 'Mawar Coconut Buns (Isi 5 pcs)',
      rating: '4.8 (106+ ratings)',
      saving: 'Hemat 60%',
      price: 'Rp32.000',
      original: 'Rp65.000',
      shipping: 'Rp5.000',
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
      price: 'Rp28.500',
      original: 'Rp58.000',
      shipping: 'Rp7.000',
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
      price: 'Rp18.500',
      original: 'Rp38.000',
      shipping: 'Rp3.000',
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
      price: 'Rp8.500',
      original: 'Rp38.000',
      shipping: 'Rp6.000',
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
      price: 'Rp26.700',
      original: 'Rp38.000',
      shipping: 'Rp2.000',
      distance: '100 m',
      stock: 'Tersisa 3 porsi',
    ),
  ];
}
