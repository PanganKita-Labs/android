import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF10283C);
const Color _orange = PanganKitaColors.brandAccent;
const Color _green = PanganKitaColors.brandPrimaryStrong;
const _compactWidth = 360.0;
const _largeTextScale = 1.5;

/// Account-settings preview with local, non-persistent switches.
class SettingsPage extends StatelessWidget {
  /// Creates the settings reference page without account integration.
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
              IconButton.filledTonal(
                tooltip: 'Kembali ke Profil Saya',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _ink),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pengaturan',
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(color: _ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const _SectionTitle('Notifikasi'),
          const SizedBox(height: 6),
          Text(
            'Pengaturan notifikasi hanya contoh dan tidak disimpan.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          const _NotificationCard(),
          const SizedBox(height: 30),
          const _SectionTitle('Akun'),
          const SizedBox(height: 10),
          const _SettingsCard(
            rows: [
              _SettingsRow(Icons.lock_outline, 'Ubah Password'),
              _SettingsRow(Icons.language, 'Bahasa', detail: 'Indonesia'),
            ],
          ),
          const SizedBox(height: 30),
          const _SectionTitle('Tentang PanganKita'),
          const SizedBox(height: 10),
          const _SettingsCard(
            rows: [
              _SettingsRow(Icons.description_outlined, 'Syarat & Ketentuan'),
              _SettingsRow(Icons.verified_user_outlined, 'Kebijakan Privasi'),
              _SettingsRow(Icons.help_outline, 'Pusat Bantuan'),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'PanganKita • Pengaturan contoh',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const new(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
  );
}

class _NotificationCard extends StatefulWidget {
  const new();

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _orders = true;
  bool _messages = true;
  bool _promos = false;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          secondary: const Icon(Icons.notifications_outlined, color: _orange),
          title: const Text('Update pesanan'),
          subtitle: const Text('Dapatkan notifikasi status pesanan kamu.'),
          value: _orders,
          activeTrackColor: _green,
          onChanged: (value) => setState(() => _orders = value),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          secondary: const Icon(Icons.chat_bubble_outline, color: _green),
          title: const Text('Pesan dari toko'),
          subtitle: const Text(
            'Dapatkan notifikasi pesan dari toko pilihanmu.',
          ),
          value: _messages,
          activeTrackColor: _green,
          onChanged: (value) => setState(() => _messages = value),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          secondary: const Icon(Icons.local_offer_outlined, color: _orange),
          title: const Text('Promo & penawaran'),
          subtitle: const Text(
            'Dapatkan info promo, diskon dan penawaran menarik.',
          ),
          value: _promos,
          activeTrackColor: _green,
          onChanged: (value) => setState(() => _promos = value),
        ),
      ],
    ),
  );
}

class _SettingsRow {
  const new(this.icon, this.label, {this.detail});

  final IconData icon;
  final String label;
  final String? detail;
}

class _SettingsCard extends StatelessWidget {
  const new({required this.rows});

  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).width <= _compactWidth &&
        MediaQuery.textScalerOf(context).scale(1) >= _largeTextScale;
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            if (index > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Icon(rows[index].icon, color: _green),
              title: Text(rows[index].label),
              subtitle: compact
                  ? switch (rows[index].detail) {
                      final String detail => Text(detail),
                      null => null,
                    }
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!compact)
                    if (rows[index].detail case final detail?) Text(detail),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => DemoNotice.unavailable(context),
            ),
          ],
        ],
      ),
    );
  }
}
