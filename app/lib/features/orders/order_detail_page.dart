import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/orders/order_help_sheet.dart';
import 'package:pangankita/shared/format_rupiah.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkDeep;
const Color _green = PanganKitaColors.brandPrimaryStrong;
const _paleGreen = Color(0xFFE9F6EF);
const _merchantRadius = 24.0;
const _productSize = 76.0;
const _productRadius = 10.0;
const _noticeRadius = 16.0;

/// Read-only detail for one local order example, not a real reservation.
class OrderDetailPage extends StatelessWidget {
  /// Displays the selected example food without creating an order.
  const new({required this.food, super.key});

  /// Food shown by the order preview card that opened this page.
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(
      leading: const BackButton(),
      title: const Text('Detail Pesanan'),
      actions: [
        IconButton(
          tooltip: 'Buka Bantuan Pesanan',
          onPressed: () => OrderHelpSheet.show(context, food: food),
          icon: const Icon(Icons.help_outline),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          const _StatusNotice(),
          const SizedBox(height: 16),
          const _ProgressPreview(),
          const SizedBox(height: 16),
          _DetailCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Kode pengambilan',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Belum tersedia',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: _ink),
                ),
                const SizedBox(height: 6),
                const Text('Belum ada pesanan atau kode yang dibuat.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _OrderFoodCard(food: food),
          const SizedBox(height: 12),
          _PickupInfoCard(food: food),
          const SizedBox(height: 12),
          _PaymentInfoCard(food: food),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => OrderHelpSheet.show(context, food: food),
            icon: const Icon(Icons.support_agent_outlined),
            label: const Text('Bantuan Pesanan'),
          ),
        ],
      ),
    ),
  );
}

class _OrderFoodCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: _merchantRadius,
              backgroundImage: AssetImage(food.image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.merchant,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(food.pickupAddress),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(_productRadius),
              ),
              child: SizedBox.square(
                dimension: _productSize,
                child: Image.asset(food.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('1 × ${food.price}'),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _PickupInfoCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Informasi pengambilan',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Lokasi toko', value: food.pickupAddress),
        const SizedBox(height: 8),
        _InfoRow(label: 'Batas pickup contoh', value: food.pickupTime),
        const SizedBox(height: 8),
        const _InfoRow(label: 'Waktu pengambilan', value: 'Belum tersedia'),
      ],
    ),
  );
}

class _PaymentInfoCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Rincian pembayaran',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Subtotal contoh',
          value: formatRupiah(food.priceRupiah),
        ),
        const SizedBox(height: 8),
        const _InfoRow(label: 'Metode pembayaran', value: 'Belum tersedia'),
        const Divider(height: 24),
        _InfoRow(
          label: 'Total contoh',
          value: formatRupiah(food.priceRupiah),
          emphasized: true,
        ),
      ],
    ),
  );
}

class _StatusNotice extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: _paleGreen,
      borderRadius: const BorderRadius.all(Radius.circular(_noticeRadius)),
      border: Border.all(color: const Color(0xFFC9E8D8)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFD4EFDF),
            child: Icon(Icons.shopping_bag_outlined, color: _green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contoh detail pesanan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text('Status pesanan belum tersedia.'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProgressPreview extends StatelessWidget {
  const new();

  static const _stepSize = 30.0;
  static const _stepCount = 3;
  static const double _lineHeight = _stepSize / 2;
  static const _lineColor = Color(0xFFD2DAD5);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      children: [
        Positioned(
          left: constraints.maxWidth / (_stepCount * 2),
          width: constraints.maxWidth * (_stepCount - 1) / _stepCount,
          top: _lineHeight,
          child: const Divider(height: 1, thickness: 2, color: _lineColor),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (index, label) in [
              'Dibayar',
              'Disiapkan',
              'Siap diambil',
            ].indexed)
              Expanded(
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: _stepSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: PanganKitaColors.surfaceWarm,
                          shape: BoxShape.circle,
                          border: Border.all(color: _lineColor, width: 2),
                        ),
                        child: Center(child: Text('${index + 1}')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: _ink),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class _DetailCard extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}

class _InfoRow extends StatelessWidget {
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Text(label)),
      const SizedBox(width: 12),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: emphasized
              ? Theme.of(context).textTheme.titleLarge?.copyWith(color: _green)
              : null,
        ),
      ),
    ],
  );
}
