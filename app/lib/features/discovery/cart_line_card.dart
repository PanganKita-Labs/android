import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _lineGap = 12.0;
const _quantityGap = 8.0;
const _cartPhotoSize = 82.0;
const _cartTextGap = 6.0;

/// One configured product with local quantity and removal controls.
class CartLineCard extends StatelessWidget {
  /// Uses the app-owned cart; does not reserve or persist stock.
  const new({required this.line, required this.cart, super.key});

  /// Current immutable line snapshot.
  final DemoCartLine line;

  /// Local cart state owner.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _lineGap,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: SizedBox.square(
            dimension: _cartPhotoSize,
            child: Image.asset(
              line.food.image,
              fit: BoxFit.cover,
              semanticLabel: line.food.title,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: _cartTextGap,
            children: [
              Text(
                line.food.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (line.addons.isNotEmpty)
                Text(
                  line.addons.map((addon) => addon.label).join(', '),
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              Text(
                formatRupiah(line.unitPrice),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: PanganKitaColors.brandPrimary),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: _quantityGap,
                children: [
                  IconButton.filledTonal(
                    style: _cartQuantityStyle,
                    tooltip: 'Kurangi ${line.food.title}',
                    onPressed: line.quantity > 1
                        ? () => cart.setQuantity(line.id, line.quantity - 1)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '${line.quantity}',
                    semanticsLabel:
                        'Jumlah ${line.food.title}: ${line.quantity}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton.filledTonal(
                    style: _cartQuantityStyle,
                    tooltip: 'Tambah ${line.food.title}',
                    onPressed: line.quantity < DemoCart.quantityLimit
                        ? () => cart.setQuantity(line.id, line.quantity + 1)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Hapus ${line.food.title}',
          onPressed: () => cart.remove(line.id),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    ),
  );
}

final ButtonStyle _cartQuantityStyle = IconButton.styleFrom(
  backgroundColor: PanganKitaColors.borderNeutral,
  foregroundColor: PanganKitaColors.textPrimary,
  disabledForegroundColor: Colors.grey,
);
