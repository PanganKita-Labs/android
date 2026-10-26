import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/features/discovery/demo_addon.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/format_rupiah.dart';

void main() {
  test(
    'whole-rupiah totals include options and combine identical selections',
    () {
      final cart = DemoCart();
      addTearDown(cart.dispose);
      final food = DemoFood.examples.first;
      expect(
        cart.add(
          food,
          quantity: 2,
          addons: {DemoAddon.cheese, DemoAddon.chili},
        ),
        isTrue,
      );
      expect(cart.subtotal, 98000);
      expect(
        cart.add(food, addons: {DemoAddon.chili, DemoAddon.cheese}),
        isTrue,
      );
      expect(cart.lines, hasLength(1));
      expect(cart.itemCount, 3);
      expect(cart.subtotal, 147000);
      expect(cart.add(food), isTrue);
      expect(cart.lines, hasLength(2));
      expect(cart.subtotal, 179000);
      cart.setQuantity(cart.lines.first.id, 1);
      expect(cart.subtotal, 81000);
      cart.remove(cart.lines.first.id);
      expect(cart.subtotal, 32000);
      cart.clear();
      expect(cart.lines, isEmpty);
      expect(cart.subtotal, 0);
    },
  );

  test('preview limits reject invalid amounts without mutating the cart', () {
    final cart = DemoCart();
    addTearDown(cart.dispose);
    final food = DemoFood.examples.first;
    expect(() => cart.add(food, quantity: 0), throwsRangeError);
    expect(() => cart.add(food, quantity: 11), throwsRangeError);
    expect(cart.add(food, quantity: 10), isTrue);
    expect(cart.add(food), isFalse);
    expect(cart.itemCount, 10);
    expect(() => cart.setQuantity(cart.lines.first.id, -1), throwsRangeError);
    expect(cart.itemCount, 10);
    expect(() => cart.lines.clear(), throwsUnsupportedError);
    expect(
      () => cart.lines.first.addons.add(DemoAddon.garlic),
      throwsUnsupportedError,
    );
  });

  test('rupiah formatting keeps integer precision and thousands grouping', () {
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(8500), 'Rp8.500');
    expect(formatRupiah(1000000), 'Rp1.000.000');
  });
}
