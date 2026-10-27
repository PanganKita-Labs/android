import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _orderTitleSize = 15.0;
const _orderPriceGap = 8.0;
const _orderPhotoSize = 72.0;
const _orderGap = 10.0;
const _lineGap = 4.0;

/// Read-only checkout lines from the current session cart.
class CheckoutOrderDetails extends StatelessWidget {
  /// Displays every configured item and its integer-rupiah line total.
  const new({required this.cart, super.key});

  /// App-owned preview state; no inventory or payment authority.
  final DemoCart cart;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _orderGap,
        children: [
          Text(
            'Rincian pesanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final line in cart.lines) _CheckoutLine(line: line),
        ],
      ),
    ),
  );
}

class _CheckoutLine extends StatelessWidget {
  const new({required this.line});
  final DemoCartLine line;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: _orderGap,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: SizedBox.square(
          dimension: _orderPhotoSize,
          child: Image.asset(
            line.food.image,
            fit: BoxFit.cover,
            semanticLabel: line.food.title,
          ),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: _lineGap,
          children: [
            Text(
              line.food.id == 'buns'
                  ? line.food.title.replaceFirst(' (Isi 5 pcs)', '')
                  : line.food.title,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontSize: _orderTitleSize),
            ),
            if (line.food.id == 'buns')
              const Text(
                '(Isi 5 pcs)',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            if (line.addons.isNotEmpty)
              Text(
                line.addons.map((addon) => addon.label).join(', '),
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: _orderPriceGap,
              runSpacing: _lineGap,
              children: [
                Text(
                  '${line.quantity} x ${formatRupiah(line.unitPrice)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  formatRupiah(line.total),
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: PanganKitaColors.brandPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
