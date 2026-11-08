import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkDeep;
const _paleGreen = Color(0xFFEAF7F0);
const _sheetHeightFactor = 0.68;
const _merchantRadius = 22.0;

/// Local help panel for the illustrative order-detail screen.
class OrderHelpSheet extends StatelessWidget {
  /// Creates the example FAQ for the selected merchant.
  const new({required this.food, super.key});

  /// Example item displayed in the order detail.
  final DemoFood food;

  /// Opens the order help as a modal sheet without contacting a service.
  static Future<void> show(BuildContext context, {required DemoFood food}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * _sheetHeightFactor,
        ),
        builder: (context) => OrderHelpSheet(food: food),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Bantuan Pesanan',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: _ink),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup Bantuan Pesanan',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: _ink),
                  ),
                ],
              ),
              Text(
                'Ada yang bisa kami bantu?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              _ExampleOrder(food: food),
              const SizedBox(height: 20),
              const _HelpQuestions(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () => DemoNotice.unavailable(context),
            icon: const Icon(Icons.support_agent_outlined),
            label: const Text('Hubungi Customer Service'),
          ),
        ),
      ],
    ),
  );
}

class _ExampleOrder extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: _paleGreen,
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
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
                Text(
                  food.merchant,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Text('ID pesanan belum tersedia'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _HelpQuestions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _HelpQuestion(
        title: 'Bagaimana cara mengambil pesanan?',
        answer:
            'Pengambilan belum tersedia dalam demo ini. Belum ada kode '
            'atau pesanan nyata untuk ditunjukkan ke toko.',
        initiallyExpanded: true,
      ),
      SizedBox(height: 8),
      _HelpQuestion(
        title: 'Pesanan belum siap',
        answer:
            'Status persiapan belum tersedia karena contoh pesanan '
            'tidak terhubung ke toko.',
      ),
      SizedBox(height: 8),
      _HelpQuestion(
        title: 'Toko tutup atau sulit ditemukan',
        answer:
            'Alamat yang tampil adalah contoh. Lokasi dan jam buka toko '
            'belum terhubung ke layanan langsung.',
      ),
      SizedBox(height: 8),
      _HelpQuestion(
        title: 'Pesanan tidak sesuai',
        answer: 'Pelaporan masalah pesanan belum tersedia dalam demo offline.',
      ),
      SizedBox(height: 8),
      _HelpQuestion(
        title: 'Kendala pembayaran',
        answer:
            'Pembayaran belum tersedia; tidak ada tagihan atau transaksi '
            'yang dibuat.',
      ),
    ],
  );
}

class _HelpQuestion extends StatelessWidget {
  const new({
    required this.title,
    required this.answer,
    this.initiallyExpanded = false,
  });

  final String title;
  final String answer;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Card(
    color: initiallyExpanded ? _paleGreen : Colors.white,
    margin: EdgeInsets.zero,
    child: ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: _ink),
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [Align(alignment: Alignment.centerLeft, child: Text(answer))],
    ),
  );
}
