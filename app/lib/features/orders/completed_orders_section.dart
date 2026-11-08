import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkCool;
const _gap = 12.0;
const _photoSize = 76.0;
const _photoRadius = 12.0;
const _merchantRadius = 18.0;
const Color _badgeColor = PanganKitaColors.positiveSurfaceMuted;

/// Display-only examples for the completed orders tab.
class CompletedOrdersSection extends StatelessWidget {
  /// Creates the sample section without a real order history.
  const new({super.key, this.query = ''});

  /// Filters the two local examples by product or merchant name.
  final String query;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const I18nText(
        'Contoh tampilan · belum ada pesanan selesai.',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 18),
      if (DemoFood.examples[1].matches(query, 'Semua'))
        _DatedCompletedExample(
          date: '26 Oktober 2026 · contoh',
          food: DemoFood.examples[1],
          quantity: 2,
        ),
      const SizedBox(height: 28),
      if (DemoFood.examples[0].matches(query, 'Semua'))
        _DatedCompletedExample(
          date: '25 Oktober 2026 · contoh',
          food: DemoFood.examples[0],
          quantity: 1,
        ),
      if (!DemoFood.examples[0].matches(query, 'Semua') &&
          !DemoFood.examples[1].matches(query, 'Semua'))
        const I18nText('Tidak ada pesanan contoh yang cocok.'),
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
      I18nText(
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
                  const Expanded(child: I18nText('Total pembayaran contoh')),
                  I18nText(
                    formatRupiah(quantity * food.priceRupiah),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: PanganKitaColors.brandPrimary),
                  ),
                ],
              ),
              _CompletedActions(food: food, quantity: quantity),
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
        child: I18nText(
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
          child: I18nText(
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
            I18nText(food.title, style: Theme.of(context).textTheme.titleSmall),
            I18nText('$quantity × ${food.price}'),
            const I18nText(
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
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.pickup,
            arguments: (food: food, quantity: quantity),
          ).ignore(),
          child: const I18nText('Lihat Detail'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.review,
            arguments: (food: food, quantity: quantity),
          ).ignore(),
          child: const I18nText('Beri Ulasan'),
        ),
      ),
    ],
  );
}
