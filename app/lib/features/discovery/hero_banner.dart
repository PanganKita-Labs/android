import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _pastryWidth = 145.0;
const _pastryHeight = 112.0;
const _campaignFontSize = 18.0;
const _artworkMaxTextSize = 24.0;
const _indicatorWidth = 76.0;
const _indicatorHeight = 22.0;
const _indicatorGap = 5.0;
const _dotWidth = 11.0;
const _dotHeight = 4.0;

/// Croissant campaign artwork and local example call to action.
class HeroBanner extends StatelessWidget {
  /// Creates the reference campaign.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 141),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF075B32), PanganKitaColors.brandPrimaryStrong],
      ),
      borderRadius: BorderRadius.all(Radius.circular(17)),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        if (MediaQuery.textScalerOf(context).scale(_campaignFontSize) <=
            _artworkMaxTextSize)
          Positioned(
            right: 0,
            bottom: 0,
            width: _pastryWidth,
            height: _pastryHeight,
            child: ClipRRect(
              // The supplied crop includes a text fragment in its top-left.
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(70),
              ),
              child: Image.asset(
                'assets/prototype/hero.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                excludeFromSemantics: true,
              ),
            ),
          ),
        const _HeroCopy(),
        // Cover the partially transparent indicator in the supplied crop.
        const Positioned(right: 6, bottom: 9, child: _HeroDots()),
      ],
    ),
  );
}

class _HeroDots extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Container(
    width: _indicatorWidth,
    height: _indicatorHeight,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: _indicatorGap,
      children: [
        for (final color in const [
          Color(0xFF52A963),
          PanganKitaColors.borderNeutral,
          PanganKitaColors.borderNeutral,
        ])
          Container(
            width: _dotWidth,
            height: _dotHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
      ],
    ),
  );
}

class _HeroCopy extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                fontFamily: PanganKitaTheme.bodyFontFamily,
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Croissant Favoritmu,\nDiskon Hingga 60%',
          style: TextStyle(
            color: Colors.white,
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontSize: _campaignFontSize,
            height: 1.17,
            fontWeight: FontWeight.w700,
            letterSpacing: -.45,
          ),
        ),
        const SizedBox(height: 4),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: PanganKitaColors.brandAccent,
            textStyle: const TextStyle(
              fontFamily: PanganKitaTheme.emphasisFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () => DemoNotice.show(
            context,
            'Promo croissant belum tersedia dalam demo offline. '
            'Tidak ada pesanan yang dibuat.',
          ),
          child: const Text('Pesan Sekarang!'),
        ),
      ],
    ),
  );
}
