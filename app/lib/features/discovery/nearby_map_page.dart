import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _markerPositions = [
  Alignment(.2, .18),
  Alignment(-.48, -.5),
  Alignment(.55, -.4),
  Alignment(-.55, .6),
];
const _mapInk = Color(0xFF14313A);
const _streetStep = 44.0;
const _blockInset = 5.0;
const _mainRoadWidth = 18.0;
const _mainRoadStart = .42;
const _mainRoadEnd = .58;
const _parkLeft = .76;
const _parkTop = .38;
const _parkWidth = .24;
const _parkHeight = .27;
const _mapInset = 14.0;
const _mapBottomInset = 12.0;
const _mapLabelInset = 12.0;
const _pinSelectedSize = 62.0;
const _pinSize = 34.0;
const _pinLabelSize = 11.0;
const _sheetHeightFraction = .48;
const _chipIconSize = 20.0;
const _pinBorderWidth = 3.0;
const _locationDiameter = 80.0;
const _locationDotDiameter = 27.0;
const _locationDotBorder = 4.0;
const _sheetImageSize = 116.0;
const _parcelInset = 12.0;
const _parcelWidth = 13.0;
const _parcelHeight = 18.0;
const _crossRoadWidth = 12.0;
const _roadBorderWidth = 6.0;
const _listButtonWidth = 145.0;
const _sheetHandleWidth = 34.0;
const _sheetHandleHeight = 4.0;

/// Display-only map of four local merchant examples.
class NearbyMapPage extends StatefulWidget {
  /// Creates the map without device location or live map tiles.
  const new({super.key});

  @override
  State<NearbyMapPage> createState() => _NearbyMapPageState();
}

class _NearbyMapPageState extends State<NearbyMapPage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final stores = DemoFood.examples.take(_markerPositions.length).toList();
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: Column(
          children: [
            const _MapHeader(),
            Expanded(
              child: _MerchantMap(
                stores: stores,
                selected: _selected,
                onSelected: (index) => setState(() => _selected = index),
              ),
            ),
            _MapStoreSheet(food: stores[_selected]),
          ],
        ),
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Kembali ke daftar toko',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toko di Sekitarmu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: PanganKitaColors.brandPrimaryStrong,
                  ),
                  Expanded(
                    child: Text(
                      'Mandala by Pass, Medan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Filter peta belum tersedia',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: PanganKitaColors.brandPrimaryStrong,
          ),
          onPressed: () => DemoNotice.unavailable(context),
          icon: const Icon(Icons.tune),
        ),
      ],
    ),
  );
}

class _MerchantMap extends StatelessWidget {
  const new({
    required this.stores,
    required this.selected,
    required this.onSelected,
  });

  final List<DemoFood> stores;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ClipRect(child: CustomPaint(painter: _StreetPainter())),
      const Align(alignment: Alignment(-.42, .08), child: _CurrentLocation()),
      const Positioned(
        left: 28,
        top: 170,
        child: _RoadLabel('Jl. Setia Budi', angle: -.35),
      ),
      const Positioned(
        right: 70,
        bottom: 115,
        child: _RoadLabel('Mandala\nby Pass'),
      ),
      for (var index = 0; index < stores.length; index++)
        Align(
          alignment: _markerPositions[index],
          child: _MerchantPin(
            food: stores[index],
            selected: selected == index,
            onTap: () => onSelected(index),
          ),
        ),
      const _MapFilterChips(),
      Positioned(
        right: _mapInset,
        bottom: _mapBottomInset,
        child: IconButton.filledTonal(
          tooltip: 'Lokasi perangkat belum tersedia',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: PanganKitaColors.brandPrimaryStrong,
          ),
          onPressed: () => DemoNotice.unavailable(context),
          icon: const Icon(Icons.my_location),
        ),
      ),
      Positioned(
        left: _mapLabelInset,
        bottom: _mapBottomInset,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'Peta ilustrasi • posisi toko contoh',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    ],
  );
}

class _MapFilterChips extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Positioned(
    top: _mapInset + 2,
    left: _mapInset,
    right: _mapInset + 1,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final label in ['Buka sekarang', 'Diskon']) ...[
            Material(
              color: Colors.white,
              shape: const StadiumBorder(
                side: BorderSide(color: PanganKitaColors.borderNeutral),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                onTap: () => DemoNotice.unavailable(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        label == 'Diskon'
                            ? Icons.local_offer_outlined
                            : Icons.schedule,
                        color: _mapInk,
                        size: _chipIconSize,
                      ),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    ),
  );
}

class _MerchantPin extends StatelessWidget {
  const new({required this.food, required this.selected, required this.onTap});

  final DemoFood food;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: const BorderRadius.all(Radius.circular(32)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints.tight(
            Size.square(selected ? _pinSelectedSize : _pinSize),
          ),
          decoration: BoxDecoration(
            color: PanganKitaColors.brandPrimaryStrong,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: _pinBorderWidth),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 8),
            ],
          ),
          child: selected
              ? ClipOval(child: Image.asset(food.image, fit: BoxFit.cover))
              : const Icon(Icons.restaurant, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 3),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 110),
          child: Text(
            food.merchant,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _mapInk,
              fontSize: _pinLabelSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CurrentLocation extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints.tight(const Size.square(_locationDiameter)),
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: Color(0x3346A9A9),
      shape: BoxShape.circle,
    ),
    child: Container(
      constraints: BoxConstraints.tight(
        const Size.square(_locationDotDiameter),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: _locationDotBorder),
      ),
    ),
  );
}

class _RoadLabel extends StatelessWidget {
  const new(this.label, {this.angle = 0});

  final String label;
  final double angle;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: angle,
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _mapInk),
    ),
  );
}

class _MapStoreSheet extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * _sheetHeightFraction,
    ),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: _sheetHandleWidth,
              height: _sheetHandleHeight,
              decoration: const BoxDecoration(
                color: PanganKitaColors.borderNeutral,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              SizedBox(
                width: _listButtonWidth,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.list, size: 18),
                  label: const Text('Lihat daftar'),
                ),
              ),
            ],
          ),
          _MapStoreSummary(food: food),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: PanganKitaColors.brandPrimaryStrong,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.store(food.id)).ignore(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_right),
                SizedBox(width: 8),
                Text('Lihat Toko'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MapStoreSummary extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: SizedBox.square(
          dimension: _sheetImageSize,
          child: Image.asset(
            food.id == 'buns'
                ? 'assets/prototype/store-croissants.webp'
                : food.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.merchant,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, size: 17, color: Color(0xFFF5921B)),
                Expanded(
                  child: Text(
                    '${food.rating.split(' ').first} · contoh rating',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Row(
              children: [
                Icon(Icons.location_on_outlined, size: 17),
                SizedBox(width: 3),
                Expanded(child: Text('Jarak belum tersedia')),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              food.id == 'buns' ? '2 produk contoh' : '1 produk contoh',
              style: const TextStyle(
                color: PanganKitaColors.brandPrimaryStrong,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _StreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFF8F5EF), BlendMode.src);
    final block = Paint()..color = const Color(0xFFECE8E1);
    final parcel = Paint()..color = const Color(0xFFF4F0E9);
    for (var x = -_streetStep; x < size.width; x += _streetStep) {
      for (var y = -_streetStep; y < size.height; y += _streetStep) {
        canvas
          ..drawRect(
            Rect.fromLTWH(
              x + _blockInset,
              y + _blockInset,
              _streetStep - _blockInset,
              _streetStep - _blockInset * 2,
            ),
            block,
          )
          ..drawRect(
            Rect.fromLTWH(
              x + _parcelInset,
              y + _parcelInset,
              _parcelWidth,
              _parcelHeight,
            ),
            parcel,
          );
      }
    }
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * _parkLeft,
        size.height * _parkTop,
        size.width * _parkWidth,
        size.height * _parkHeight,
      ),
      Paint()..color = const Color(0xFFCFE7BB),
    );
    final road = Path()
      ..moveTo(0, size.height * .27)
      ..lineTo(size.width, size.height * .2)
      ..moveTo(0, size.height * .72)
      ..lineTo(size.width, size.height * .63);
    canvas.drawPath(
      road,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = _crossRoadWidth,
    );
    final highway = Path()
      ..moveTo(size.width * _mainRoadStart, 0)
      ..lineTo(size.width * _mainRoadEnd, size.height);
    canvas
      ..drawPath(
        highway,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = _mainRoadWidth + _roadBorderWidth,
      )
      ..drawPath(
        highway,
        Paint()
          ..color = const Color(0xFFFFDF91)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _mainRoadWidth,
      );
  }

  @override
  bool shouldRepaint(covariant _StreetPainter oldDelegate) => false;
}
