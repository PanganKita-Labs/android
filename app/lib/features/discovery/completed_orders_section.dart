import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _ink = Color(0xFF14313A);
const _gap = 12.0;
const _photoSize = 76.0;
const _photoRadius = 12.0;
const _merchantRadius = 18.0;
const _badgeColor = Color(0xFFE6F0EB);

/// Display-only examples for the completed orders tab.
class CompletedOrdersSection extends StatelessWidget {
  /// Creates the sample section without a real order history.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Contoh tampilan · belum ada pesanan selesai.',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 18),
      _DatedCompletedExample(
        date: '26 Oktober 2026 · contoh',
        food: DemoFood.examples[1],
        quantity: 2,
      ),
      const SizedBox(height: 28),
      _DatedCompletedExample(
        date: '25 Oktober 2026 · contoh',
        food: DemoFood.examples[0],
        quantity: 1,
      ),
    ],
  );
}

class _DatedCompletedExample extends StatelessWidget {
  const new({required this.date, required this.food, required this.quantity});

  final String date;
  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        date,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
      ),
      const SizedBox(height: 14),
      Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: _gap,
            children: [
              _MerchantHeader(food: food),
              _CompletedItem(food: food, quantity: quantity),
              const Divider(height: 1),
              Row(
                children: [
                  const Expanded(child: Text('Total pembayaran contoh')),
                  Text(
                    formatRupiah(quantity * food.priceRupiah),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: PanganKitaColors.brandPrimary),
                  ),
                ],
              ),
              const _CompletedActions(),
            ],
          ),
        ),
      ),
    ],
  );
}

class _MerchantHeader extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _merchantRadius,
        backgroundImage: AssetImage(food.image),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          food.merchant,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      const DecoratedBox(
        decoration: BoxDecoration(
          color: _badgeColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            'Contoh',
            style: TextStyle(color: PanganKitaColors.brandPrimary),
          ),
        ),
      ),
    ],
  );
}

class _CompletedItem extends StatelessWidget {
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_photoRadius)),
        child: SizedBox.square(
          dimension: _photoSize,
          child: Image.asset(food.image, fit: BoxFit.cover),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.title, style: Theme.of(context).textTheme.titleSmall),
            Text('$quantity × ${food.price}'),
            const Text(
              'Waktu diambil: Belum tersedia',
              style: TextStyle(color: PanganKitaColors.brandPrimary),
            ),
          ],
        ),
      ),
    ],
  );
}

class _CompletedActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const Text('Lihat Detail'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const Text('Beri Ulasan'),
        ),
      ),
    ],
  );
}
