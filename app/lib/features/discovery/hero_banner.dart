import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/food_detail_sheet.dart';

const _pastryWidth = 220.0;
const _pastryHeight = 114.0;
const _dotWidth = 13.0;
const _dotHeight = 4.0;

/// Croissant campaign artwork and local example call to action.
class HeroBanner extends StatelessWidget {
  /// Creates the reference campaign.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 147),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          PanganKitaColors.brandPrimary,
          PanganKitaColors.brandPrimaryStrong,
        ],
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          width: _pastryWidth,
          height: _pastryHeight,
          child: Image.asset(
            'assets/prototype/hero.png',
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            excludeFromSemantics: true,
          ),
        ),
        const _HeroCopy(),
        const Positioned(right: 14, bottom: 10, child: _HeroDots()),
      ],
    ),
  );
}

class _HeroCopy extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0x25FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'FLASH SALE',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Croissant Favoritmu,\nDiskon Hingga 60%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            height: 1.17,
            fontWeight: FontWeight.w700,
            letterSpacing: -.45,
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 36),
            backgroundColor: PanganKitaColors.brandAccent,
            textStyle: const TextStyle(
              fontFamily: PanganKitaTheme.referenceFontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () => FoodDetailSheet.show(
            context,
            DemoFood.examples.firstWhere((food) => food.id == 'roti'),
          ),
          child: const Text('Pesan Sekarang!'),
        ),
      ],
    ),
  );
}

class _HeroDots extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          _HeroDot(color: PanganKitaColors.brandPrimary),
          _HeroDot(color: PanganKitaColors.borderNeutral),
          _HeroDot(color: PanganKitaColors.borderNeutral),
        ],
      ),
    ),
  );
}

class _HeroDot extends StatelessWidget {
  const new({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _dotWidth,
    height: _dotHeight,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
    ),
  );
}
