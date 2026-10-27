import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/discovery_navigation.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/format_rupiah.dart';

const _ink = Color(0xFF14313A);
const _orange = Color(0xFFE98412);
const _chipGap = 8.0;
const _chipRunGap = 10.0;
const _cardGap = 8.0;
const _merchantRadius = 18.0;
const _photoSize = 72.0;
const _photoRadius = 10.0;
const _codeRadius = 12.0;
final List<DemoFood> _sampleFoods = [
  DemoFood.examples.first,
  DemoFood.examples[1],
];

/// Orders tab based on the supplied active-orders design, using demo examples.
class OrdersPage extends StatefulWidget {
  /// Creates an order-preview page without a persisted order.
  const new({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pesanan',
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(color: _ink),
                ),
              ),
              IconButton(
                tooltip: 'Cari pesanan',
                onPressed: () => DemoNotice.unavailable(context),
                icon: const Icon(Icons.search, size: 30, color: _ink),
              ),
            ],
          ),
          const Text('Makanan favoritmu, siap dinikmati.'),
          const SizedBox(height: 18),
          Wrap(
            spacing: _chipGap,
            runSpacing: _chipRunGap,
            children: [
              for (final (index, label) in [
                'Aktif',
                'Selesai',
                'Dibatalkan',
              ].indexed)
                ChoiceChip(
                  label: Text(label),
                  selected: _selectedTab == index,
                  showCheckmark: false,
                  selectedColor: PanganKitaColors.brandPrimaryStrong,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    fontFamily: PanganKitaTheme.emphasisFontFamily,
                    color: _selectedTab == index ? Colors.white : _ink,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                  onSelected: (_) => setState(() => _selectedTab = index),
                ),
            ],
          ),
          const SizedBox(height: 22),
          if (_selectedTab == 0) ...[
            Text(
              'Contoh pesanan aktif',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: _ink),
            ),
            const SizedBox(height: 6),
            const Text(
              'Contoh tampilan · belum ada pesanan nyata.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            for (final food in _sampleFoods) ...[
              _OrderExampleCard(food: food),
              const SizedBox(height: 16),
            ],
          ] else
            _EmptyOrderTab(title: _selectedTab == 1 ? 'selesai' : 'dibatalkan'),
        ],
      ),
    ),
    bottomNavigationBar: const DiscoveryNavigation(selectedIndex: 1),
  );
}

class _OrderExampleCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _cardGap,
        children: [
          Row(
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
              const _ExampleBadge(),
            ],
          ),
          _OrderItemSummary(food: food),
          const Divider(height: 1),
          Row(
            children: [
              const Icon(Icons.schedule_outlined, color: _orange, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text('Waktu pickup contoh: ${food.pickupTime}')),
            ],
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFE6F0EB),
              borderRadius: BorderRadius.all(Radius.circular(_codeRadius)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kode pengambilan'),
                  Text(
                    'Belum tersedia',
                    style: TextStyle(
                      fontFamily: PanganKitaTheme.emphasisFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(child: Text('Total pembayaran contoh')),
              Text(
                formatRupiah(food.priceRupiah),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: PanganKitaColors.brandPrimary),
              ),
            ],
          ),
          const _OrderCardActions(),
        ],
      ),
    ),
  );
}

class _OrderItemSummary extends StatelessWidget {
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
          ],
        ),
      ),
    ],
  );
}

class _OrderCardActions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const Text('Chat Toko'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const Text(
            'Detail Pesanan',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.15),
          ),
        ),
      ),
    ],
  );
}

class _ExampleBadge extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0xFFE6F0EB),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        'Contoh',
        style: TextStyle(color: PanganKitaColors.brandPrimary),
      ),
    ),
  );
}

class _EmptyOrderTab extends StatelessWidget {
  const new({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Column(
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 54,
          color: Colors.black38,
        ),
        const SizedBox(height: 12),
        Text(
          'Belum ada pesanan $title',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Text('Riwayat pesanan belum tersedia dalam demo offline.'),
      ],
    ),
  );
}
