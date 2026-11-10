import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _profileGreen = PanganKitaColors.brandPrimaryStrong;
const Color _profileInk = PanganKitaColors.inkDeep;

void _ignoreAreaChange(String area) {
  if (area.isEmpty) throw ArgumentError.value(area, 'area');
}

String _defaultLocation() => 'Mandala by Pass, Medan';

/// Display-only profile based on the first panel of the account reference.
class ProfilePage extends StatelessWidget {
  /// Creates the local example without loading account information.
  const new({
    this.readLocation = _defaultLocation,
    this.onLocationChanged = _ignoreAreaChange,
    super.key,
  });

  /// Reads the latest example area from the app session when needed.
  final String Function() readLocation;

  /// Reports a confirmed area to the app-session owner.
  final ValueChanged<String> onLocationChanged;

/// Opens the example-area selector and reports its selected value.
  Future<void> _chooseLocation(BuildContext context) async {
    final selected = await Navigator.pushNamed(
      context,
      AppRoutes.location,
      arguments: readLocation(),
    );
    if (context.mounted && selected is String) {
      onLocationChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const _ProfileHeader(),
          const SizedBox(height: 20),
          const _ProfileIdentity(),
          const SizedBox(height: 18),
          const _ProfileImpactNotice(),
          const SizedBox(height: 16),
          _ProfileNavigation(
            onChooseLocation: () => _chooseLocation(context).ignore(),
          ),
          const SizedBox(height: 14),
          _ProfileMenu(
            items: [
              _ProfileItem(
                Icons.logout,
                'Keluar',
                () => DemoNotice.unavailable(context),
                color: PanganKitaColors.danger,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Shows profile navigation, title, and settings shortcut.
class _ProfileHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: translateDisplayText(context, 'Kembali ke Beranda'),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: _profileInk),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: I18nText(
          'Profil Saya',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: _profileInk),
        ),
      ),
      IconButton(
        tooltip: translateDisplayText(context, 'Buka Pengaturan'),
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.settings).ignore(),
        icon: const Icon(Icons.settings_outlined, color: _profileInk),
      ),
    ],
  );
}

/// Displays static demonstration identity and edit navigation.
class _ProfileIdentity extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Center(
        child: CircleAvatar(
          radius: 72,
          backgroundImage: AssetImage('assets/prototype/avatar.webp'),
        ),
      ),
      const SizedBox(height: 12),
      I18nText(
        'Vincent',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium
            ?.copyWith(color: _profileInk),
      ),
      I18nText(
        'vincent@example.com • contoh',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 14),
      Center(
        child: OutlinedButton.icon(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.editProfile).ignore(),
          icon: const Icon(Icons.edit_outlined),
          label: const I18nText('Edit Profil'),
        ),
      ),
    ],
  );
}

/// Shows illustrative food-rescue appreciation, not impact metrics.
class _ProfileImpactNotice extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: const BoxDecoration(
      color: PanganKitaColors.savingsSurface,
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFD8F2E0),
          child: Icon(Icons.eco_outlined, color: _profileGreen),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: I18nText(
            'Terima kasih sudah ikut menyelamatkan makanan.',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: _profileInk),
          ),
        ),
      ],
    ),
  );
}

/// Connects profile menu actions to existing demo routes.
class _ProfileNavigation extends StatelessWidget {
  const new({required this.onChooseLocation});

  final VoidCallback onChooseLocation;

  @override
  Widget build(BuildContext context) => _ProfileMenu(
    items: [
      _ProfileItem(
        Icons.receipt_long_outlined,
        'Riwayat Pesanan',
        () => Navigator.pushNamed(context, AppRoutes.orders).ignore(),
      ),
      _ProfileItem(
        Icons.favorite_border,
        'Favorit Saya',
        () => Navigator.pushNamed(context, AppRoutes.favorites).ignore(),
      ),
      _ProfileItem(Icons.location_on_outlined, 'Lokasi Saya', onChooseLocation),
      _ProfileItem(
        Icons.settings_outlined,
        'Pengaturan',
        () => Navigator.pushNamed(context, AppRoutes.settings).ignore(),
      ),
      _ProfileItem(
        Icons.help_outline,
        'Pusat Bantuan',
        () => Navigator.pushNamed(context, AppRoutes.support).ignore(),
      ),
    ],
  );
}

/// Describes one profile menu icon, label, and action.
class _ProfileItem {
  const new(this.icon, this.label, this.onTap, {this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
}

/// Renders the ordered menu entries for the local profile.
class _ProfileMenu extends StatelessWidget {
  const new({required this.items});

  final List<_ProfileItem> items;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const Divider(height: 1, indent: 60, endIndent: 16),
          ListTile(
            leading: Icon(
              items[index].icon,
              color: items[index].color ?? _profileGreen,
            ),
            title: I18nText(
              items[index].label,
              style: TextStyle(color: items[index].color ?? _profileInk),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: items[index].onTap,
          ),
        ],
      ],
    ),
  );
}
