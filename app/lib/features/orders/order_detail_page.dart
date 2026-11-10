import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/orders/order_help_sheet.dart';
import 'package:pangankita/i18n/i18n.dart';
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
  /// Displays a read-only order preview for the fixture [food].
  ///
  /// No order is created, paid for, reserved, or confirmed; help is local.
  const new({required this.food, super.key});

  /// Food shown by the order preview card that opened this page.
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(
      leading: const BackButton(),
      title: const I18nText('Detail Pesanan'),
      actions: [
        IconButton(
          tooltip: translateDisplayText(context, 'Buka Bantuan Pesanan'),
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
          const _PickupCodeCard(),
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
            label: const I18nText('Bantuan Pesanan'),
          ),
        ],
      ),
    ),
  );
}

/// Shows an unavailable pickup-code example, not a valid code.
class _PickupCodeCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        I18nText(
          'Kode pengambilan',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        I18nText(
          'Belum tersedia',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: _ink),
        ),
        const SizedBox(height: 6),
        const I18nText('Belum ada pesanan atau kode yang dibuat.'),
      ],
    ),
  );
}

/// Displays merchant identity for the selected example order.
class _OrderMerchantLine extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
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

/// Displays fixture product details for the order preview.
class _OrderFoodCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OrderMerchantLine(food: food),
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
                  I18nText(
                    food.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  I18nText('1 × ${food.price}'),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Shows illustrative pickup instructions and status.
class _PickupInfoCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        I18nText(
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

/// Shows a sample payment summary without transaction verification.
class _PaymentInfoCard extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => _DetailCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        I18nText(
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

/// Explains the current example order status and limitations.
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
                I18nText(
                  'Contoh detail pesanan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const I18nText('Status pesanan belum tersedia.'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Displays illustrative order lifecycle steps, not server state.
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
                        child: Center(child: I18nText('${index + 1}')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    I18nText(
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

/// Provides shared presentation styling for order detail sections.
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

/// Formats a label-value pair in the order preview.
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
      Expanded(child: I18nText(label)),
      const SizedBox(width: 12),
      Flexible(
        child: I18nText(
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
