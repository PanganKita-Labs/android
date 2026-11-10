import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
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
  const new({this.initialArea = 'Mandala by Pass, Medan', super.key});

  /// Example area currently selected in this app session.
  final String initialArea;

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final _search = TextEditingController();
  String _selected = _sampleAreas.first.name;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialArea;
  }

  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _sampleAreas
        .where((area) => area.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _LocationSelectionList(
                controller: _search,
                query: _query,
                selected: _selected,
                matches: matches,
                onQueryChanged: (value) =>
                    setState(() => _query = value.trim()),
                onQueryCleared: () {
                  _search.clear();
                  setState(() => _query = '');
                },
                onSelected: (area) => setState(() => _selected = area),
              ),
            ),
            _AreaConfirmation(
              onPressed: () => Navigator.pop(context, _selected),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSelectionList extends StatelessWidget {
  const new({
    required this.controller,
    required this.query,
    required this.selected,
    required this.matches,
    required this.onQueryChanged,
    required this.onQueryCleared,
    required this.onSelected,
  });

  final TextEditingController controller;
  final String query;
  final String selected;
  final List<({String name, String subtitle})> matches;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryCleared;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
    children: [
      _LocationListIntro(
        controller: controller,
        query: query,
        onQueryChanged: onQueryChanged,
        onQueryCleared: onQueryCleared,
      ),
      const SizedBox(height: 18),
      const _LocationSectionHeading('Lokasi pilihan'),
      if (query.isEmpty || matches.any((area) => area.name == selected))
        _AreaTile(
          name: selected,
          subtitle: 'Medan, Sumatera Utara · contoh',
          selected: true,
          onTap: null,
        ),
      const SizedBox(height: 20),
      const _LocationSectionHeading('Pencarian terakhir'),
      if (matches.isEmpty)
        const Padding(
          padding: EdgeInsets.all(16),
          child: I18nText('Area contoh tidak ditemukan.'),
        )
      else
        for (final area in matches.where((area) => area.name != selected))
          _AreaTile(
            name: area.name,
            subtitle: '${area.subtitle} · contoh',
            selected: selected == area.name,
            onTap: () => onSelected(area.name),
          ),
      const SizedBox(height: 12),
      const _AreaExampleDisclaimer(),
    ],
  );
}

class _LocationSectionHeading extends StatelessWidget {
  const new(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      I18nText(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
    ],
  );
}

class _LocationListIntro extends StatelessWidget {
  const new({
    required this.controller,
    required this.query,
    required this.onQueryChanged,
    required this.onQueryCleared,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryCleared;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const _LocationHeading(),
      const SizedBox(height: 22),
      _AreaSearchField(
        controller: controller,
        query: query,
        onChanged: onQueryChanged,
        onClear: onQueryCleared,
      ),
      const SizedBox(height: 16),
      const _CurrentLocationPreview(),
      const SizedBox(height: 14),
      const _IllustrativeMap(),
    ],
  );
}

class _LocationHeading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: translateDisplayText(context, 'Kembali'),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, size: 28),
      ),
      const SizedBox(width: 10),
      I18nText(
        'Pilih Lokasi',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ],
  );
}

class _AreaSearchField extends StatelessWidget {
  const new({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: translateDisplayText(context, 'Cari area contoh'),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: query.isEmpty
          ? null
          : IconButton(
              tooltip: translateDisplayText(context, 'Hapus pencarian'),
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
    ),
  );
}

class _CurrentLocationPreview extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: const CircleAvatar(
        backgroundColor: PanganKitaColors.savingsSurface,
        child: Icon(
          Icons.my_location,
          color: PanganKitaColors.brandPrimaryStrong,
        ),
      ),
      title: const I18nText('Gunakan lokasi saat ini'),
      subtitle: const I18nText('Akses lokasi belum tersedia'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => DemoNotice.unavailable(context),
    ),
  );
}

class _AreaExampleDisclaimer extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: const BoxDecoration(
      color: PanganKitaColors.urgencySurface,
      borderRadius: BorderRadius.all(Radius.circular(_noticeRadius)),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline, color: PanganKitaColors.brandAccent),
        SizedBox(width: 12),
        Expanded(
          child: I18nText(
            'Area ini hanya contoh tampilan; belum menentukan '
            'hasil berdasarkan jarak.',
          ),
        ),
      ],
    ),
  );
}

class _AreaConfirmation extends StatelessWidget {
  const new({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: PanganKitaColors.brandPrimaryStrong,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
        ),
        onPressed: onPressed,
        child: const I18nText('Gunakan Lokasi Ini'),
      ),
    ),
  );
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
      title: I18nText(name),
      subtitle: I18nText(subtitle),
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x3345A6A3),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 90,
                child: Icon(
                  Icons.location_on,
                  size: 44,
                  color: PanganKitaColors.brandPrimaryStrong,
                ),
              ),
            ),
          ),
          const _MapStreetLabels(),
          const Positioned(right: 12, bottom: 12, child: _MapPreviewCaption()),
        ],
      ),
    ),
  );
}

class _MapStreetLabels extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Stack(
    children: [
      Positioned(top: 16, left: 55, child: _MapStreetLabel('Jl. Setia Budi')),
      Positioned(
        top: 24,
        right: 12,
        child: _MapStreetLabel('Jl. Gatot Subroto'),
      ),
      Positioned(
        bottom: 38,
        left: 88,
        child: _MapStreetLabel('Mandala by Pass'),
      ),
      Positioned(top: 82, right: 12, child: _MapStreetLabel('Taman Cadika')),
    ],
  );
}

class _MapPreviewCaption extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(color: Colors.white),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 155,
        child: I18nText(
          'Peta ilustrasi - bukan lokasi langsung',
          textAlign: TextAlign.right,
        ),
      ),
    ),
  );
}

class _MapStreetLabel extends StatelessWidget {
  const new(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => I18nText(
    label,
    style: const TextStyle(color: Color(0xFF14313A), fontSize: 10),
  );
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEDEBE4), BlendMode.src);
    final park = Paint()..color = const Color(0xFFCFE7BE);
    _paintParks(canvas, size, park);
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

  void _paintParks(Canvas canvas, Size size, Paint park) {
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
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}
