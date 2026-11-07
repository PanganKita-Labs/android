import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/discovery_navigation.dart';
import 'package:pangankita/features/orders/canceled_orders_section.dart';
import 'package:pangankita/features/orders/completed_orders_section.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

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
  const new({super.key, this.initialTab = 0});

  /// Tab to display when opening from an illustrative notification.
  final int initialTab;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late int _selectedTab = widget.initialTab;
  bool _searching = false;
  String _query = '';

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
                onPressed: () => setState(() {
                  _searching = !_searching;
                  if (!_searching) _query = '';
                }),
                icon: const Image(
                  image: AssetImage('assets/prototype/icon-search.png'),
                  width: 26,
                  height: 26,
                ),
              ),
            ],
          ),
          const Text('Makanan favoritmu, siap dinikmati.'),
          if (_searching) ...[
            const SizedBox(height: 12),
            _OrderSearchField(
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ],
          const SizedBox(height: 18),
          _OrderTabs(
            selected: _selectedTab,
            onSelected: (index) => setState(() => _selectedTab = index),
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
            for (final food in _sampleFoods.where(
              (food) => food.matches(_query, 'Semua'),
            )) ...[_OrderExampleCard(food: food), const SizedBox(height: 16)],
            if (!_sampleFoods.any((food) => food.matches(_query, 'Semua')))
              const Text('Tidak ada pesanan contoh yang cocok.'),
          ] else if (_selectedTab == 1)
            CompletedOrdersSection(query: _query)
          else
            CanceledOrdersSection(query: _query),
        ],
      ),
    ),
    bottomNavigationBar: const DiscoveryNavigation(selectedIndex: 1),
  );
}

class _OrderSearchField extends StatelessWidget {
  const new({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    autofocus: true,
    decoration: const InputDecoration(
      hintText: 'Cari nama produk atau toko contoh',
      prefixIcon: Padding(
        padding: EdgeInsets.all(14),
        child: Image(
          image: AssetImage('assets/prototype/icon-search.png'),
          width: 20,
          height: 20,
        ),
      ),
    ),
    onChanged: onChanged,
  );
}

class _OrderTabs extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _chipGap,
    runSpacing: _chipRunGap,
    children: [
      for (final (index, label) in ['Aktif', 'Selesai', 'Dibatalkan'].indexed)
        ChoiceChip(
          label: Text(label),
          selected: selected == index,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            color: selected == index ? Colors.white : _ink,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide.none,
          onSelected: (_) => onSelected(index),
        ),
    ],
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
                backgroundColor: PanganKitaColors.savingsSurface,
                backgroundImage: food.merchant == 'Mawar Bakery & Cake'
                    ? const AssetImage('assets/prototype/mawar-mark.webp')
                    : null,
                child: food.merchant == 'Mawar Bakery & Cake'
                    ? null
                    : Text(food.merchant.substring(0, 1)),
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
          _OrderCardActions(food: food),
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
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => Navigator.pushNamed<void>(
            context,
            AppRoutes.merchantChat,
            arguments: (food: food, message: null),
          ),
          child: const Text('Chat Toko'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: FilledButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.orderDetail,
            arguments: food,
          ).ignore(),
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
