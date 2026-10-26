import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _compactWidth = 360.0;
const _compactPhoto = 87.0;
const _regularPhoto = 104.0;
const _photoGap = 10.0;
const _priceGap = 6.0;
const _badgeGap = 5.0;
const _badgeIconGap = 3.0;
const _badgeIconSize = 14.0;
const _footerIconSize = 14.0;
const _badgeBorderWidth = .7;

/// Read-only listing card matching the pickup-oriented home reference.
class FoodCard extends StatelessWidget {
  /// Creates a card for an illustrative local offer.
  const new({required this.food, super.key});

  /// Display data, not live stock or a verified merchant.
  final DemoFood food;

  @override
  Widget build(BuildContext context) {
    final photoSize = MediaQuery.sizeOf(context).width < _compactWidth
        ? _compactPhoto
        : _regularPhoto;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () =>
            Navigator.pushNamed<void>(context, AppRoutes.product(food.id)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: _photoGap,
                children: [
                  SizedBox.square(
                    dimension: photoSize,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.asset(
                        food.image,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _FoodSummary(food: food, minHeight: photoSize),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: .5,
                color: Color(0xFFDFDFDE),
              ),
              _FoodFooter(food: food),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodSummary extends StatelessWidget {
  const new({required this.food, required this.minHeight});
  final DemoFood food;
  final double minHeight;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minHeight: minHeight),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MerchantLine(food: food),
            const SizedBox(height: 4),
            Text(
              food.cardTitle,
              style: const TextStyle(
                fontFamily: PanganKitaTheme.emphasisFontFamily,
                fontSize: 14,
                height: 1.15,
                fontWeight: FontWeight.w700,
                letterSpacing: -.15,
              ),
            ),
            const SizedBox(height: 5),
            _FoodBadges(food: food),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: _FoodPrice(food: food),
        ),
      ],
    ),
  );
}

class _MerchantLine extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: PanganKitaSpacing.xs,
    runSpacing: _badgeGap,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Flexible(
            child: Text(
              food.merchant,
              style: const TextStyle(fontSize: 8.5, color: Colors.black54),
            ),
          ),
          Semantics(
            label: 'Badge contoh; merchant belum diverifikasi',
            child: const Icon(
              Icons.check_circle,
              size: 9,
              color: PanganKitaColors.brandPrimary,
            ),
          ),
        ],
      ),
      _FoodRating(rating: food.rating),
    ],
  );
}

class _FoodBadges extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _badgeGap,
    runSpacing: PanganKitaSpacing.xs,
    children: [
      if (!food.flash) const _FoodBadge(label: 'Promo QRIS', icon: 'tag'),
      _FoodBadge(label: food.saving, icon: 'badge'),
      if (food.flash) const _FoodBadge(label: 'Flash Sale', icon: 'bolt'),
    ],
  );
}

class _FoodPrice extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _priceGap,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        food.price,
        style: const TextStyle(
          fontFamily: PanganKitaTheme.emphasisFontFamily,
          fontSize: 20,
          height: 1.15,
          color: PanganKitaColors.brandPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -.35,
        ),
      ),
      Text(
        food.original,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    ],
  );
}

class _FoodBadge extends StatelessWidget {
  const new({required this.label, required this.icon});
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(
        color: PanganKitaColors.borderNeutral,
        width: _badgeBorderWidth,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: _badgeIconGap,
        children: [
          ReferenceIcon(
            icon,
            size: _badgeIconSize,
            color: icon == 'badge'
                ? PanganKitaColors.brandPrimary
                : PanganKitaColors.brandAccent,
          ),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: icon == 'badge' && label.startsWith('Hemat ')
                    ? [
                        const TextSpan(text: 'Hemat '),
                        TextSpan(
                          text: label.substring('Hemat '.length),
                          style: const TextStyle(
                            fontFamily: PanganKitaTheme.emphasisFontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]
                    : [TextSpan(text: label)],
              ),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FoodFooter extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: _priceGap,
    runSpacing: _badgeGap,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text.rich(
        TextSpan(
          children: [
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.schedule_outlined,
                size: _footerIconSize,
                color: PanganKitaColors.brandAccent,
              ),
            ),
            TextSpan(
              text: '  ${food.pickupTime}',
              style: const TextStyle(color: PanganKitaColors.brandAccent),
            ),
            TextSpan(text: '  |  ${food.distance}'),
          ],
        ),
        style: const TextStyle(fontSize: 9.5, height: 1.3, color: Colors.grey),
        semanticsLabel: 'Pickup contoh ${food.pickupTime}, ${food.distance}',
      ),
      Text(
        food.stock,
        style: const TextStyle(
          fontSize: 9.5,
          height: 1.3,
          color: PanganKitaColors.danger,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _FoodRating extends StatelessWidget {
  const new({required this.rating});
  final String rating;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 2,
    children: [
      const ReferenceIcon('star', size: 9, color: PanganKitaColors.brandAccent),
      Flexible(
        child: Text(
          rating,
          style: const TextStyle(fontSize: 5.5, color: Color(0xFF686868)),
        ),
      ),
    ],
  );
}
