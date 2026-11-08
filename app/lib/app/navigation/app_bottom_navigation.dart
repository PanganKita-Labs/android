import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _navigationHeight = 54.0;
const _navigationFontSize = 12.0;
const _navigationLineHeight = 1.2;
const _notificationsIndex = 3;

/// App-wide bottom destinations shared by consumer tabs.
class AppBottomNavigation extends StatelessWidget {
  /// Selects Home (0), Orders (1), Chat (2), or Notifications (3).
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
      case _notificationsIndex:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.notifications,
        ).ignore();
      default:
        DemoNotice.unavailable(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    return NavigationBar(
      height: MediaQuery.textScalerOf(context).scale(_navigationHeight),
      selectedIndex: selectedIndex,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: PanganKitaTheme.emphasisFontFamily,
          fontSize: _navigationFontSize,
          height: _navigationLineHeight,
          color: states.contains(WidgetState.selected)
              ? PanganKitaColors.highlightGreen
              : PanganKitaColors.navigationInactive,
          fontWeight: FontWeight.w600,
        ),
      ),
      onDestinationSelected: (index) => _selectDestination(context, index),
      destinations: [
        NavigationDestination(
          icon: const ReferenceIcon('home'),
          selectedIcon: const ReferenceIcon(
            'home-filled',
            color: PanganKitaColors.highlightGreen,
          ),
          label: i18n?.navHome ?? 'Beranda',
        ),
        NavigationDestination(
          icon: const ReferenceIcon('bag'),
          label: i18n?.navOrders ?? 'Pesanan',
        ),
        NavigationDestination(
          icon: const ReferenceIcon('chat'),
          label: i18n?.navChat ?? 'Chat',
        ),
        NavigationDestination(
          icon: const ReferenceIcon('bell'),
          label: i18n?.navNotifications ?? 'Notifikasi',
        ),
      ],
    );
  }
}
