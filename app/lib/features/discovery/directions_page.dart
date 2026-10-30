import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _green = PanganKitaColors.brandPrimaryStrong;
const List<({IconData icon, String label})> _modes = [
  (icon: Icons.directions_walk, label: 'Jalan kaki'),
  (icon: Icons.two_wheeler_outlined, label: 'Motor'),
  (icon: Icons.directions_car_outlined, label: 'Mobil'),
];
const _streetStartX = 25.0;
const _streetStartY = 30.0;
const _streetStep = 52.0;
const _streetSlopeX = 20.0;
const _streetSlopeY = 12.0;
const _routeStroke = 6.0;
const _sheetHeightFraction = .42;

/// Directions preview. It does not use GPS, routing, or live travel times.
class DirectionsPage extends StatefulWidget {
  /// Creates directions for an illustrative merchant.
  const new({required this.food, super.key});

  /// Local example shown as the destination.
  final DemoFood food;

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  int _mode = 0;

  void _backToMap() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.nearbyMap).ignore();
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) _backToMap();
    },
    child: Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Kembali ke peta toko',
                    onPressed: _backToMap,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Petunjuk Arah',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            _Destination(food: widget.food),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  for (var i = 0; i < _modes.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: _mode == i
                              ? PanganKitaColors.savingsSurface
                              : Colors.white,
                          foregroundColor: _green,
                        ),
                        onPressed: () => setState(() => _mode = i),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_modes[i].icon),
                            Text(
                              _modes[i].label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Expanded(child: _RouteMap()),
            _DirectionsSheet(food: widget.food, mode: _modes[_mode].label),
          ],
        ),
      ),
    ),
  );
}

class _Destination extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.my_location, color: _green),
                SizedBox(width: 12),
                Expanded(child: Text('Lokasi saya (contoh)')),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.location_on, color: _green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    food.merchant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _RouteMap extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(child: CustomPaint(painter: _RoutePainter())),
        const Align(
          alignment: Alignment(-.52, .62),
          child: Icon(Icons.my_location, size: 32, color: Colors.blue),
        ),
        const Align(
          alignment: Alignment(.42, -.45),
          child: Icon(Icons.location_on, size: 42, color: _green),
        ),
        Align(
          alignment: const Alignment(0, .12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Rute ilustrasi',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF5F1E9),
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 13;
    for (var x = _streetStartX; x < size.width; x += _streetStep) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + _streetSlopeX, size.height),
        road,
      );
    }
    for (var y = _streetStartY; y < size.height; y += _streetStep) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y - _streetSlopeY),
        road,
      );
    }
    final route = Path()
      ..moveTo(size.width * .24, size.height * .81)
      ..lineTo(size.width * .45, size.height * .65)
      ..lineTo(size.width * .52, size.height * .3)
      ..lineTo(size.width * .71, size.height * .27);
    canvas.drawPath(
      route,
      Paint()
        ..color = _green
        ..style = PaintingStyle.stroke
        ..strokeWidth = _routeStroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => false;
}

class _DirectionsSheet extends StatelessWidget {
  const new({required this.food, required this.mode});

  final DemoFood food;
  final String mode;

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * _sheetHeightFraction,
    ),
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(food.merchant, style: Theme.of(context).textTheme.titleLarge),
          Text(food.pickupAddress),
          const SizedBox(height: 10),
          Text('$mode • jarak dan waktu belum tersedia'),
          const SizedBox(height: 8),
          Text('Batas pickup contoh: ${food.pickupTime}'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => DemoNotice.unavailable(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Buka di Aplikasi Peta'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.store(food.id)).ignore(),
            icon: const Icon(Icons.storefront_outlined),
            label: const Text('Lihat Toko'),
          ),
        ],
      ),
    ),
  );
}
