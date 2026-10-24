import 'package:flutter/material.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _sheetHeightFraction = .8;
const _detailPhotoHeight = 220.0;
const _detailColumnGap = 24.0;
const _detailRowGap = 12.0;

/// Read-only details for a reference listing.
class FoodDetailSheet extends StatelessWidget {
  /// Creates details for a local example.
  const new({required this.food, super.key});

  /// Illustrative food data.
  final DemoFood food;

  /// Opens an accessible, scrollable native sheet.
  static Future<void> show(BuildContext context, DemoFood food) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => FoodDetailSheet(food: food),
      );

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    heightFactor: _sheetHeightFraction,
    child: ListView(
      padding: const EdgeInsets.only(left: 22, right: 22, bottom: 30),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            tooltip: 'Tutup detail',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          child: Image.asset(
            food.image,
            height: _detailPhotoHeight,
            fit: BoxFit.cover,
            semanticLabel: food.title,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${food.merchant} · ${food.rating}',
          style: const TextStyle(color: Colors.blueGrey),
        ),
        Text(food.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text(
          'Informasi penawaran ini hanya konten prototipe. '
          'Harga, rating, ongkir, stok, dan waktu bukan penawaran langsung.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: _detailColumnGap,
          runSpacing: _detailRowGap,
          children: [
            Text('Harga surplus\n${food.price}'),
            Text('Harga awal\n${food.original}'),
            Text('Ongkir (contoh)\n${food.shipping}'),
            Text('Stok pada referensi\n${food.stock}'),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => DemoNotice.show(
            context,
            'Pemesanan dan pembayaran belum diimplementasikan dalam demo '
            'offline.',
          ),
          child: const Text('Simulasi Saja — Tidak Bisa Dipesan'),
        ),
      ],
    ),
  );
}
