import 'package:flutter/foundation.dart';
import 'package:pangankita/features/discovery/demo_addon.dart';
import 'package:pangankita/features/discovery/demo_food.dart';

/// App-session cart for UI demonstrations; no persistence or stock mutations.
class DemoCart extends ChangeNotifier {
  /// Explicit preview limit, not an assertion about merchant inventory.
  static const quantityLimit = 10;
  final _lines = <String, DemoCartLine>{};

  /// Read-only current cart snapshot.
  List<DemoCartLine> get lines => List.unmodifiable(_lines.values);

  /// Number of configured items, including quantities.
  int get itemCount =>
      _lines.values.fold(0, (sum, line) => sum + line.quantity);

  /// Whole-rupiah preview total; the demo service fee is zero.
  int get subtotal => _lines.values.fold(0, (sum, line) => sum + line.total);

  /// Adds or combines a configuration; returns false at the preview limit.
  bool add(
    DemoFood food, {
    int quantity = 1,
    Set<DemoAddon> addons = const {},
  }) {
    _checkQuantity(quantity);
    final options = List<DemoAddon>.unmodifiable(
      DemoAddon.values.where(addons.contains),
    );
    final candidate = DemoCartLine(
      food: food,
      quantity: quantity,
      addons: options,
    );
    final combined = quantity + (_lines[candidate.id]?.quantity ?? 0);
    if (combined > quantityLimit) return false;
    _lines[candidate.id] = DemoCartLine(
      food: food,
      quantity: combined,
      addons: options,
    );
    notifyListeners();
    return true;
  }

  /// Changes only a known line within the documented preview bounds.
  void setQuantity(String id, int quantity) {
    _checkQuantity(quantity);
    final line = _lines[id];
    if (line == null || line.quantity == quantity) return;
    _lines[id] = DemoCartLine(
      food: line.food,
      quantity: quantity,
      addons: line.addons,
    );
    notifyListeners();
  }

  /// Removes an individual configuration.
  void remove(String id) {
    if (_lines.remove(id) != null) notifyListeners();
  }

  /// Clears the local cart without affecting any listing or inventory.
  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }

  void _checkQuantity(int quantity) {
    if (quantity < 1 || quantity > quantityLimit) {
      throw RangeError.range(quantity, 1, quantityLimit, 'quantity');
    }
  }
}

/// Immutable configuration of one local cart line.
class DemoCartLine {
  /// Creates a display snapshot, not an inventory reservation.
  const new({required this.food, required this.quantity, required this.addons});

  /// Selected home fixture.
  final DemoFood food;

  /// Preview quantity.
  final int quantity;

  /// Canonically ordered options.
  /// The cart stores these as an unmodifiable list.
  final List<DemoAddon> addons;

  /// Identity includes options to keep different configurations separate.
  String get id => '${food.id}/${addons.map((addon) => addon.name).join(',')}';

  /// Whole-rupiah amount for one configured item.
  int get unitPrice =>
      food.priceRupiah +
      addons.fold(0, (sum, addon) => sum + addon.priceRupiah);

  /// Illustrative line total.
  int get total => unitPrice * quantity;
}
