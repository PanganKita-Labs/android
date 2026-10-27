import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _ink = Color(0xFF14313A);
const _red = Color(0xFFD94B42);
const _redPale = Color(0xFFFCEAE6);
const _greenPale = Color(0xFFE6F0EB);
const _gap = 12.0;
const _photoSize = 76.0;
const _photoRadius = 12.0;
const _merchantRadius = 18.0;

/// Display-only example for the canceled-orders tab.
class CanceledOrdersSection extends StatelessWidget {
  /// Creates the preview without a real canceled order.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Contoh tampilan · belum ada pesanan dibatalkan.',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 18),
      Text(
        '26 Oktober 2026 · contoh',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
      ),
      const SizedBox(height: 14),
      const _CanceledExampleCard(),
      const SizedBox(height: 24),
      const DecoratedBox(
        decoration: BoxDecoration(
          color: _greenPale,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: PanganKitaColors.brandPrimary,
                size: 30,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text('Pesanan yang dibatalkan akan muncul di sini.'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _CanceledExampleCard extends StatelessWidget {
  const new();

  static final DemoFood food = DemoFood.examples[1];

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _gap,
        children: [
          _CanceledMerchantHeader(food: food),
          _CanceledProduct(food: food),
          const Divider(height: 1),
          _CanceledTotal(priceRupiah: food.priceRupiah),
          const Text(
            'Belum ada pembayaran',
            style: TextStyle(
              color: Colors.black54,
              decoration: TextDecoration.underline,
            ),
          ),
          const _CanceledActions(),
        ],
      ),
    ),
  );
}

class _CanceledMerchantHeader extends StatelessWidget {
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
          color: _redPale,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text('Contoh', style: TextStyle(color: _red)),
        ),
      ),
    ],
  );
}

class _CanceledTotal extends StatelessWidget {
  const new({required this.priceRupiah});

  final int priceRupiah;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Text('Total pembayaran contoh')),
      Text(
        formatRupiah(priceRupiah),
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: PanganKitaColors.brandPrimary),
      ),
    ],
  );
}

class _CanceledProduct extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

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
            Text('1 × ${food.price}'),
            const SizedBox(height: 6),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: _redPale,
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'Alasan pembatalan: Belum tersedia',
                  style: TextStyle(color: _red),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _CanceledActions extends StatelessWidget {
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
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home).ignore(),
          child: const Text('Cari Menu Lain', textAlign: TextAlign.center),
        ),
      ),
    ],
  );
}
