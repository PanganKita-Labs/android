import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkCool;
const _red = Color(0xFFD94B42);
const _redPale = Color(0xFFFCEAE6);
const Color _greenPale = PanganKitaColors.positiveSurfaceMuted;
const _gap = 12.0;
const _photoSize = 76.0;
const _photoRadius = 12.0;
const _merchantRadius = 18.0;

/// Display-only example for the canceled-orders tab.
class CanceledOrdersSection extends StatelessWidget {
  /// Creates the preview without a real canceled order.
  const new({super.key, this.query = ''});

  /// Filters the local canceled example by product or merchant name.
  final String query;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const I18nText(
        'Contoh tampilan · belum ada pesanan dibatalkan.',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 18),
      I18nText(
        '26 Oktober 2026 · contoh',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
      ),
      const SizedBox(height: 14),
      if (DemoFood.examples[1].matches(query, 'Semua'))
        const _CanceledExampleCard()
      else
        const I18nText('Tidak ada pesanan contoh yang cocok.'),
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
                child: I18nText('Pesanan yang dibatalkan akan muncul di sini.'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Displays one canceled-order fixture with its preview metadata.
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
          const I18nText(
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

/// Shows the example merchant for a canceled order.
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
        child: I18nText(
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
          child: I18nText('Contoh', style: TextStyle(color: _red)),
        ),
      ),
    ],
  );
}

/// Displays the illustrative total for the canceled order.
class _CanceledTotal extends StatelessWidget {
  const new({required this.priceRupiah});

  final int priceRupiah;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: I18nText('Total pembayaran contoh')),
      I18nText(
        formatRupiah(priceRupiah),
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: PanganKitaColors.brandPrimary),
      ),
    ],
  );
}

/// Shows the product fixture associated with the canceled order.
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
            I18nText(food.title, style: Theme.of(context).textTheme.titleSmall),
            I18nText('1 × ${food.price}'),
            const SizedBox(height: 6),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: _redPale,
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: I18nText(
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

/// Shows demonstration actions for a canceled order.
///
/// No cancellation or refund operation is sent to a backend.
class _CanceledActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const I18nText('Lihat Detail'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home).ignore(),
          child: const I18nText('Cari Menu Lain', textAlign: TextAlign.center),
        ),
      ),
    ],
  );
}
