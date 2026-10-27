import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _navigationHeight = 54.0;
const _navigationFontSize = 12.0;
const _navigationLineHeight = 1.2;

/// Bottom destinations shared by the discovery previews.
class DiscoveryNavigation extends StatelessWidget {
  /// Selects Home (0), Orders (1), or Chat (2).
  const new({required this.selectedIndex, super.key});

  /// Active destination index.
  final int selectedIndex;

  void _selectDestination(BuildContext context, int index) {
    if (index == selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home).ignore();
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.orders).ignore();
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.chat).ignore();
      default:
        DemoNotice.unavailable(context);
    }
  }

  @override
  Widget build(BuildContext context) => NavigationBar(
    height: MediaQuery.textScalerOf(context).scale(_navigationHeight),
    selectedIndex: selectedIndex,
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        fontFamily: PanganKitaTheme.emphasisFontFamily,
        fontSize: _navigationFontSize,
        height: _navigationLineHeight,
        color: states.contains(WidgetState.selected)
            ? const Color(0xFF52A963)
            : const Color(0xFF8D8F90),
        fontWeight: FontWeight.w600,
      ),
    ),
    onDestinationSelected: (index) => _selectDestination(context, index),
    destinations: const [
      NavigationDestination(
        icon: ReferenceIcon('home'),
        selectedIcon: ReferenceIcon('home-filled', color: Color(0xFF52A963)),
        label: 'Beranda',
      ),
      NavigationDestination(icon: ReferenceIcon('bag'), label: 'Pesanan'),
      NavigationDestination(icon: ReferenceIcon('chat'), label: 'Chat'),
      NavigationDestination(icon: ReferenceIcon('bell'), label: 'Notifikasi'),
    ],
  );
}
