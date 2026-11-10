import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _green = PanganKitaColors.brandPrimaryStrong;
const Color _ink = PanganKitaColors.inkDeep;
const _noticeRadius = 16.0;
const _photoRadius = 12.0;
const _photoSize = 72.0;
const _merchantRadius = 26.0;

/// Read-only completed-pickup example from the local orders preview.
class PickupPage extends StatelessWidget {
  /// Shows the selected example without confirming a real pickup.
  const new({required this.food, required this.quantity, super.key});

  /// Example listing displayed in the completed order.
  final DemoFood food;

  /// Example quantity displayed in the completed order.
  final int quantity;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(
      leading: const BackButton(),
      title: const I18nText('Pengambilan'),
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundColor: PanganKitaColors.positiveSurface,
            child: Icon(Icons.shopping_bag_outlined, size: 56, color: _green),
          ),
          const SizedBox(height: 12),
          I18nText(
            'Pesanan sudah diambil!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(color: _green),
          ),
          const SizedBox(height: 6),
          const I18nText(
            'Contoh tampilan pengambilan selesai.\n'
            'Belum ada pengambilan nyata yang dikonfirmasi.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _PickupSummary(food: food, quantity: quantity),
          const SizedBox(height: 12),
          const _PickupThankYou(),
          const SizedBox(height: 12),
          _PickupActions(food: food, quantity: quantity),
        ],
      ),
    ),
  );
}

class _PickupActions extends StatelessWidget {
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: PanganKitaColors.brandAccent,
          minimumSize: const Size.fromHeight(54),
        ),
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.review,
          arguments: (food: food, quantity: quantity),
        ).ignore(),
        icon: const Icon(Icons.star),
        label: const I18nText('Beri Ulasan'),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        ).ignore(),
        icon: const Icon(Icons.home_outlined),
        label: const I18nText('Kembali ke Beranda'),
      ),
    ],
  );
}

class _PickupThankYou extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: PanganKitaColors.positiveSurface,
      borderRadius: BorderRadius.all(Radius.circular(_noticeRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, size: 32, color: _green),
          const SizedBox(width: 16),
          Expanded(
            child: I18nText(
              'Terima kasih telah memilih makanan surplus.',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: _green),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PickupMerchant extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: _merchantRadius,
        backgroundImage: AssetImage(food.image),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              food.merchant,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            I18nText(food.pickupAddress),
          ],
        ),
      ),
    ],
  );
}

class _PickupProduct extends StatelessWidget {
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(_photoRadius)),
        child: SizedBox.square(
          dimension: _photoSize,
          child: Image.asset(food.image, fit: BoxFit.cover),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            I18nText(
              food.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            I18nText('$quantity × ${food.price}'),
          ],
        ),
      ),
    ],
  );
}

class _PickupSummary extends StatelessWidget {
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PickupMerchant(food: food),
          const SizedBox(height: 12),
          _PickupProduct(food: food, quantity: quantity),
          const Divider(height: 20),
          const _SummaryRow(label: 'Kode pengambilan', value: 'Belum tersedia'),
          const SizedBox(height: 12),
          const _SummaryRow(
            label: 'Waktu pengambilan',
            value: 'Belum tersedia',
          ),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Total contoh',
            value: formatRupiah(quantity * food.priceRupiah),
            emphasized: true,
          ),
        ],
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: I18nText(label)),
      const SizedBox(width: 8),
      I18nText(
        value,
        style: emphasized
            ? Theme.of(context).textTheme.titleLarge?.copyWith(color: _green)
            : Theme.of(context).textTheme.bodyMedium?.copyWith(color: _ink),
      ),
    ],
  );
}
