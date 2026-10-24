import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/food_detail_sheet.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _photoGap = 11.0;
const _compactWidth = 380.0;
const _compactPhoto = 87.0;
const _regularPhoto = 108.0;
const _priceGap = 7.0;
const _badgeGap = 5.0;
const _badgeIconGap = 3.0;
const _badgeIconSize = 13.0;
const _footerIconSize = 15.0;

double _photoHeight(BuildContext context) =>
    MediaQuery.sizeOf(context).width < _compactWidth
    ? _compactPhoto
    : _regularPhoto;

/// Content-sized listing card from the HTML reference.
class FoodCard extends StatelessWidget {
  /// Creates a reference card.
  const new({required this.food, super.key});

  /// Read-only local example.
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: () => FoodDetailSheet.show(context, food),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _photoGap,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                  child: Image.asset(
                    food.image,
                    width: MediaQuery.sizeOf(context).width < _compactWidth
                        ? _compactPhoto
                        : _regularPhoto,
                    height: _photoHeight(context),
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
                Expanded(child: _FoodSummary(food: food)),
              ],
            ),
            const Divider(height: 19, thickness: 1, color: Color(0xFFDFDFDE)),
            _FoodFooter(food: food),
          ],
        ),
      ),
    ),
  );
}

class _FoodSummary extends StatelessWidget {
  const new({required this.food});
  final DemoFood food;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: PanganKitaSpacing.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            food.merchant,
            style: const TextStyle(fontSize: 9.2, color: Colors.black54),
          ),
          _FoodRating(rating: food.rating),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        food.title,
        style: const TextStyle(
          fontSize: 14.6,
          letterSpacing: -.15,
          height: 1.16,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 5),
      Wrap(
        spacing: _badgeGap,
        runSpacing: PanganKitaSpacing.xs,
        children: [
          _FoodBadge(label: food.saving, icon: 'badge'),
          _FoodBadge(
            label: food.flash ? 'Flash Sale' : 'Promo QRIS',
            icon: food.flash ? 'bolt' : 'tag',
          ),
        ],
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: _priceGap,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            food.price,
            style: const TextStyle(
              fontSize: 20.5,
              letterSpacing: -.35,
              height: 1.15,
              color: PanganKitaColors.brandPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            food.original,
            style: const TextStyle(
              fontSize: 9.5,
              height: 1.2,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
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
      border: Border.all(color: PanganKitaColors.borderNeutral),
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
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
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: _badgeGap,
        children: [
          const ReferenceIcon(
            'truck',
            size: _footerIconSize,
            color: PanganKitaColors.brandAccent,
          ),
          Text(
            'Ongkir ${food.shipping}',
            style: const TextStyle(
              fontSize: 9.7,
              height: 1.2,
              color: PanganKitaColors.brandAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      Text(
        food.distance,
        style: const TextStyle(
          fontSize: 9.7,
          height: 1.2,
          color: Color(0xFF999D9F),
        ),
      ),
      Text(
        food.stock,
        style: const TextStyle(
          fontSize: 9.5,
          height: 1.2,
          color: PanganKitaColors.danger,
          fontWeight: FontWeight.w700,
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
      const ReferenceIcon(
        'star',
        size: 12,
        color: PanganKitaColors.brandAccent,
      ),
      Flexible(
        child: Text(
          rating,
          style: const TextStyle(fontSize: 7.4, color: Color(0xFF686868)),
        ),
      ),
    ],
  );
}
