import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _ink = PanganKitaColors.inkDeep;
const Color _orange = PanganKitaColors.brandAccent;
const Color _green = PanganKitaColors.brandPrimaryStrong;
const _compactWidth = 360.0;
const _largeTextScale = 1.5;

/// Account-settings preview with local, non-persistent switches.
class SettingsPage extends StatelessWidget {
  /// Creates the settings reference page without account integration.
  const new({this.onLocaleChanged = _ignoreLocaleChange, super.key});

  /// Called when the user selects a supported UI language.
  final ValueChanged<Locale> onLocaleChanged;

  // A standalone SettingsPage cannot persist a language choice.
  static void _ignoreLocaleChange(Locale _) {
    return;
  }

  Future<void> _chooseLanguage(BuildContext context) async {
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final strings = sheetContext.i18n;
        final current = Localizations.localeOf(sheetContext).languageCode;
        final languages = <({Locale locale, String label})>[
          (
            locale: const Locale('id'),
            label: strings?.languageIndonesian ?? 'Bahasa Indonesia',
          ),
          (
            locale: const Locale('en'),
            label: strings?.languageEnglish ?? 'English',
          ),
          (
            locale: const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans',
            ),
            label: strings?.languageChinese ?? '简体中文',
          ),
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final language in languages)
                ListTile(
                  title: I18nText(language.label),
                  selected: language.locale.languageCode == current,
                  onTap: () => Navigator.pop(sheetContext, language.locale),
                ),
            ],
          ),
        );
      },
    );
    if (selected case final locale?) onLocaleChanged(locale);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const _SettingsHeader(),
            const SizedBox(height: 32),
            _SectionTitle(i18n?.notificationsTitle ?? 'Notifikasi'),
            const SizedBox(height: 6),
            I18nText(
              i18n?.notificationsDemo ??
                  'Pengaturan notifikasi hanya contoh dan tidak disimpan.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            const _NotificationCard(),
            const SizedBox(height: 30),
            _SettingsAccountSection(
              onChooseLanguage: () => _chooseLanguage(context).ignore(),
            ),
            const SizedBox(height: 30),
            const _SettingsAboutSection(),
            const SizedBox(height: 22),
            I18nText(
              i18n?.settingsFooter ?? 'PanganKita • Pengaturan contoh',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

}

class _SettingsHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: i18n?.backToProfile ?? 'Kembali ke Profil Saya',
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
          child: I18nText(
            i18n?.settingsTitle ?? 'Pengaturan',
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(color: _ink),
          ),
        ),
      ],
    );
  }
}

class _SettingsAccountSection extends StatelessWidget {
  const new({required this.onChooseLanguage});

  final VoidCallback onChooseLanguage;

  @override
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    final language = Localizations.localeOf(context).languageCode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(i18n?.accountTitle ?? 'Akun'),
        const SizedBox(height: 10),
        _SettingsCard(
          rows: [
            _SettingsRow(
              Icons.lock_outline,
              i18n?.changePassword ?? 'Ubah Password',
              route: AppRoutes.recover,
            ),
            _SettingsRow(
              Icons.language,
              i18n?.languageLabel ?? 'Bahasa',
              detail: switch (language) {
                'en' => 'English',
                'zh' => '简体中文',
                _ => 'Indonesia',
              },
              onTap: onChooseLanguage,
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsAboutSection extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(i18n?.aboutPanganKita ?? 'Tentang PanganKita'),
        const SizedBox(height: 10),
        _SettingsCard(
          rows: [
            _SettingsRow(
              Icons.description_outlined,
              i18n?.terms ?? 'Syarat & Ketentuan',
              route: AppRoutes.terms,
            ),
            _SettingsRow(
              Icons.verified_user_outlined,
              i18n?.privacy ?? 'Kebijakan Privasi',
              route: AppRoutes.privacy,
            ),
            _SettingsRow(
              Icons.help_outline,
              i18n?.helpCenter ?? 'Pusat Bantuan',
              route: AppRoutes.support,
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => I18nText(
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
  Widget build(BuildContext context) {
    final i18n = context.i18n;
    return Card(
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
            title: I18nText(i18n?.ordersUpdate ?? 'Update pesanan'),
            subtitle: I18nText(
              i18n?.ordersUpdateDescription ??
                  'Dapatkan notifikasi status pesanan kamu.',
            ),
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
            title: I18nText(i18n?.merchantMessages ?? 'Pesan dari toko'),
            subtitle: I18nText(
              i18n?.merchantMessagesDescription ??
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
            title: I18nText(i18n?.promotions ?? 'Promo & penawaran'),
            subtitle: I18nText(
              i18n?.promotionsDescription ??
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
}

class _SettingsRow {
  const new(this.icon, this.label, {this.detail, this.route, this.onTap});

  final IconData icon;
  final String label;
  final String? detail;
  final String? route;
  final VoidCallback? onTap;
}

class _SettingsCard extends StatelessWidget {
  const new({required this.rows});

  final List<_SettingsRow> rows;

  void _openRow(BuildContext context, _SettingsRow row) {
    if (row.onTap case final tap?) {
      tap();
    } else if (row.route case final route?) {
      Navigator.pushNamed(context, route).ignore();
    } else {
      DemoNotice.unavailable(context);
    }
  }

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
              title: I18nText(rows[index].label),
              subtitle: compact
                  ? switch (rows[index].detail) {
                      final String detail => I18nText(detail),
                      null => null,
                    }
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!compact)
                    if (rows[index].detail case final detail?) I18nText(detail),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _openRow(context, rows[index]),
            ),
          ],
        ],
      ),
    );
  }
}
