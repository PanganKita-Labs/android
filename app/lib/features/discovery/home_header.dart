import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/reference_icon.dart';

/// Reference greeting and selected example area; no geolocation is collected.
class HomeHeader extends StatelessWidget {
  /// Creates the demo header.
  const new({required this.location, required this.onLocationTap, super.key});

  /// Area selected in the local preview.
  final String location;

  /// Opens the local area selector.
  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) => Row(
    spacing: PanganKitaSpacing.sm,
    children: [
      const _HomeAvatarLink(),
      Expanded(
        child: _HomeLocationSummary(
          location: location,
          onLocationTap: onLocationTap,
        ),
      ),
      IconButton.filledTonal(
        tooltip: translateDisplayText(context, 'Keranjang'),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
        onPressed: () => Navigator.pushNamed<void>(context, AppRoutes.cart),
        icon: const ReferenceIcon('cart', size: 23),
      ),
      IconButton.filledTonal(
        tooltip: translateDisplayText(context, 'Notifikasi'),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
        onPressed: () =>
            Navigator.pushNamed<void>(context, AppRoutes.notifications),
        icon: const Badge(
          smallSize: 8,
          backgroundColor: Color(0xFFAF0014),
          child: ReferenceIcon('bell', size: 23),
        ),
      ),
    ],
  );
}

/// Opens the local profile preview from the home screen.
class _HomeAvatarLink extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.pushNamed(context, AppRoutes.profile).ignore(),
    customBorder: const CircleBorder(),
    child: Tooltip(
      message: translateDisplayText(context, 'Buka profil contoh'),
      child: const CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage('assets/prototype/avatar.webp'),
      ),
    ),
  );
}

/// Displays the current example area and forwards location taps.
class _HomeLocationSummary extends StatelessWidget {
  const new({required this.location, required this.onLocationTap});

  final String location;
  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text.rich(
        TextSpan(
          text: translateDisplayText(context, 'Selamat Pagi, '),
          children: const [
            TextSpan(
              text: 'Vincent',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        style: const TextStyle(
          fontFamily: PanganKitaTheme.emphasisFontFamily,
          fontSize: 13,
          height: 1.26,
          letterSpacing: -.2,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 3),
      Tooltip(
        message: 'Pilih lokasi',
        child: InkWell(
          onTap: onLocationTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              spacing: PanganKitaSpacing.xs,
              children: [
                const ReferenceIcon('pin', size: 13),
                Expanded(
                  child: I18nText(
                    location,
                    style: const TextStyle(fontSize: 11, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
