import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const List<({String name, String subtitle})> _sampleAreas = [
  (name: 'Mandala by Pass, Medan', subtitle: 'Medan, Sumatera Utara'),
  (name: 'Medan Tembung', subtitle: 'Medan, Sumatera Utara'),
  (name: 'Medan Kota', subtitle: 'Medan, Sumatera Utara'),
];
const _noticeRadius = 15.0;
const _mapRadius = 16.0;
const _mapAspectRatio = 1.55;
const _parkRight = .75;
const _parkTop = .15;
const _parkWidth = .22;
const _parkHeight = .55;
const _smallParkTop = .05;
const _smallParkSize = .25;
const _streetWidth = 9.0;
const _streetStartX = 12.0;
const _streetStartY = 20.0;
const _streetStepX = 38.0;
const _streetStepY = 39.0;
const _streetSlopeX = 26.0;
const _streetSlopeY = 10.0;
const _mainRoadWidth = 13.0;
const _mainRoadStart = .5;
const _mainRoadEnd = .57;

/// Local preview of the location selection design; no GPS or map service runs.
class LocationSelectionPage extends StatefulWidget {
  /// Creates the area selector.
  const new({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final _search = TextEditingController();
  String _selected = _sampleAreas.first.name;
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recent = _sampleAreas
        .skip(1)
        .where(
          (area) => area.name.toLowerCase().contains(_query.toLowerCase()),
        );
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Kembali',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pilih Lokasi',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value.trim()),
                    decoration: InputDecoration(
                      hintText: 'Cari area atau nama jalan',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              onPressed: () {
                                _search.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: PanganKitaColors.savingsSurface,
                        child: Icon(
                          Icons.my_location,
                          color: PanganKitaColors.brandPrimaryStrong,
                        ),
                      ),
                      title: const Text('Gunakan lokasi saat ini'),
                      subtitle: const Text('Akses lokasi belum tersedia'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => DemoNotice.unavailable(context),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _IllustrativeMap(),
                  const SizedBox(height: 18),
                  Text(
                    'Lokasi pilihan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _AreaTile(
                    name: _selected,
                    subtitle: 'Medan, Sumatera Utara · contoh',
                    selected: true,
                    onTap: null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pencarian terakhir',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (recent.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Area contoh tidak ditemukan.'),
                    )
                  else
                    for (final area in recent)
                      _AreaTile(
                        name: area.name,
                        subtitle: '${area.subtitle} · contoh',
                        selected: _selected == area.name,
                        onTap: () => setState(() => _selected = area.name),
                      ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: PanganKitaColors.urgencySurface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(_noticeRadius),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: PanganKitaColors.brandAccent,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Area ini hanya contoh tampilan; belum menentukan '
                            'hasil berdasarkan jarak.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: PanganKitaColors.brandPrimaryStrong,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text('Gunakan Lokasi Ini'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaTile extends StatelessWidget {
  const new({
    required this.name,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: selected ? PanganKitaColors.savingsSurface : Colors.white,
    child: ListTile(
      leading: Icon(
        selected ? Icons.location_on : Icons.history,
        color: PanganKitaColors.brandPrimaryStrong,
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? PanganKitaColors.brandPrimaryStrong : Colors.blueGrey,
      ),
      onTap: onTap,
    ),
  );
}

class _IllustrativeMap extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: _mapAspectRatio,
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(_mapRadius)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapPainter()),
          const Center(
            child: Icon(
              Icons.location_on,
              size: 44,
              color: PanganKitaColors.brandPrimaryStrong,
            ),
          ),
          const Positioned(
            right: 12,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Ilustrasi peta · bukan lokasi langsung'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEDEBE4), BlendMode.src);
    final park = Paint()..color = const Color(0xFFCFE7BE);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * _parkRight,
            size.height * _parkTop,
            size.width * _parkWidth,
            size.height * _parkHeight,
          ),
          const Radius.circular(_mapRadius),
        ),
        park,
      )
      ..drawRect(
        Rect.fromLTWH(
          0,
          size.height * _smallParkTop,
          size.width * _smallParkSize,
          size.height * _smallParkSize,
        ),
        park,
      );
    final street = Paint()
      ..color = Colors.white
      ..strokeWidth = _streetWidth;
    for (var x = _streetStartX; x < size.width; x += _streetStepX) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + _streetSlopeX, size.height),
        street,
      );
    }
    for (var y = _streetStartY; y < size.height; y += _streetStepY) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y - _streetSlopeY),
        street,
      );
    }
    street
      ..color = const Color(0xFFFFDE91)
      ..strokeWidth = _mainRoadWidth;
    canvas.drawLine(
      Offset(size.width * _mainRoadStart, 0),
      Offset(size.width * _mainRoadEnd, size.height),
      street,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}
