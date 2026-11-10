import 'package:flutter/foundation.dart';
import 'package:pangankita/shared/models/demo_addon.dart';
import 'package:pangankita/shared/models/demo_food.dart';

/// App-session cart for UI demonstrations; no persistence or stock mutations.
class DemoCart extends ChangeNotifier {
  /// Maximum quantity per configured cart line, not the cart-wide total.
  /// This is a demo UI bound, not a merchant inventory limit.
  static const quantityLimit = 10;
  final _lines = <String, DemoCartLine>{};

  /// Unmodifiable snapshot of cart lines, not a writable cart view.
  List<DemoCartLine> get lines => List.unmodifiable(_lines.values);

  /// Number of configured items, including quantities.
  int get itemCount =>
      _lines.values.fold(0, (sum, line) => sum + line.quantity);

  /// Whole-rupiah preview total; the demo service fee is zero.
  int get subtotal => _lines.values.fold(0, (sum, line) => sum + line.total);

  /// Adds [food] or combines it with an identically configured cart line.
  ///
  /// [quantity] defaults to one and must be between 1 and [quantityLimit].
  /// [addons] defaults to an empty set and is stored in [DemoAddon] enum order.
  /// Returns `true` and notifies listeners when a line changes. Returns
  /// `false` without mutation or notification at the combined-line limit.
  /// Throws [RangeError] if [quantity] is outside the supported interval.
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

  /// Replaces the quantity of the existing line identified by [id].
  ///
  /// An unknown [id] or unchanged quantity causes no listener notification,
  /// but [quantity] is validated first. A change notifies listeners once.
  /// Throws [RangeError] for quantities outside 1 to [quantityLimit].
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

  /// Removes the cart line identified by [id], if present.
  ///
  /// Notifies listeners only when an existing line is removed.
  void remove(String id) {
    if (_lines.remove(id) != null) notifyListeners();
  }

  /// Clears local cart lines without changing any fixture inventory.
  ///
  /// Notifies listeners only when the cart was nonempty.
  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }

  /// Throws [RangeError] if [quantity] is outside 1 to [quantityLimit].
  void _checkQuantity(int quantity) {
    if (quantity < 1 || quantity > quantityLimit) {
      throw RangeError.range(quantity, 1, quantityLimit, 'quantity');
    }
  }
}

/// Display snapshot for one configured local-cart line.
///
/// Fields are final, but [addons] may be mutable if constructed directly.
/// [DemoCart.add] supplies an unmodifiable add-on list instead.
class DemoCartLine {
  /// Creates a display line for [food], [quantity], and [addons].
  ///
  /// The constructor retains [addons] without copying or validation.
  /// [DemoCart.add] validates quantity and normalizes the add-on list.
  /// Direct construction neither notifies listeners nor reserves stock.
  const new({required this.food, required this.quantity, required this.addons});

  /// Selected home fixture.
  final DemoFood food;

  /// Preview quantity.
  final int quantity;

  /// Selected add-ons, retained by reference without copying.
  ///
  /// [DemoCart.add] supplies an unmodifiable list in canonical enum order;
  /// a directly constructed line does not guarantee those properties.
  final List<DemoAddon> addons;

  /// Combines the food ID and selected add-ons into a line identity.
  /// [DemoCart.add] normalizes add-on order for canonical IDs.
  String get id => '${food.id}/${addons.map((addon) => addon.name).join(',')}';

  /// Whole-rupiah amount for one configured item.
  int get unitPrice =>
      food.priceRupiah +
      addons.fold(0, (sum, addon) => sum + addon.priceRupiah);

  /// Illustrative line total.
  int get total => unitPrice * quantity;
}
