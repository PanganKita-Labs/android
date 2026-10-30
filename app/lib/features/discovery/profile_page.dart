import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _profileGreen = PanganKitaColors.brandPrimaryStrong;
const _profileInk = Color(0xFF10283C);

/// Display-only profile based on the first panel of the account reference.
class ProfilePage extends StatelessWidget {
  /// Creates the local example without loading account information.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Kembali ke Beranda',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _profileInk),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Profil Saya',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: _profileInk),
                ),
              ),
              IconButton(
                tooltip: 'Pengaturan belum tersedia',
                onPressed: () => DemoNotice.unavailable(context),
                icon: const Icon(Icons.settings_outlined, color: _profileInk),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: CircleAvatar(
              radius: 72,
              backgroundImage: AssetImage('assets/prototype/avatar.webp'),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vincent',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: _profileInk),
          ),
          Text(
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
              label: const Text('Edit Profil'),
            ),
          ),
          const SizedBox(height: 18),
          Container(
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
                  child: Text(
                    'Terima kasih sudah ikut menyelamatkan makanan.',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: _profileInk),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ProfileMenu(
            items: [
              _ProfileItem(
                Icons.receipt_long_outlined,
                'Riwayat Pesanan',
                () => Navigator.pushNamed(context, AppRoutes.orders).ignore(),
              ),
              _ProfileItem(
                Icons.favorite_border,
                'Favorit Saya',
                () => DemoNotice.unavailable(context),
              ),
              _ProfileItem(
                Icons.location_on_outlined,
                'Lokasi Saya',
                () => Navigator.pushNamed(context, AppRoutes.location).ignore(),
              ),
              _ProfileItem(
                Icons.settings_outlined,
                'Pengaturan',
                () => DemoNotice.unavailable(context),
              ),
              _ProfileItem(
                Icons.help_outline,
                'Pusat Bantuan',
                () => DemoNotice.unavailable(context),
              ),
            ],
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

class _ProfileItem {
  const new(this.icon, this.label, this.onTap, {this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
}

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
            title: Text(
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
