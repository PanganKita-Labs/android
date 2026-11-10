import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _ink = PanganKitaColors.inkDeep;
const _labelStyle = TextStyle(
  fontFamily: PanganKitaTheme.bodyFontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF53617B),
);
const _fieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(9)),
  borderSide: BorderSide(color: Color(0xFFD5DDE5)),
);
const _focusedFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(9)),
  borderSide: BorderSide(color: PanganKitaColors.brandPrimaryStrong),
);
final _emailShape = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Local edit-form preview; no account data is loaded or saved.
class EditProfilePage extends StatefulWidget {
  /// Creates the illustrative form.
  const new({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      DemoNotice.show(
        context,
        'Perubahan contoh belum dapat disimpan ke akun.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const _EditProfileHeader(),
          const SizedBox(height: 36),
          const _EditPhotoControls(),
          const SizedBox(height: 28),
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
                enabledBorder: _fieldBorder,
                focusedBorder: _focusedFieldBorder,
              ),
            ),
            child: Form(key: _formKey, child: const _ProfileFields()),
          ),
          const SizedBox(height: 26),
          I18nText('Keamanan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          const _EditSecurityLink(),
          const SizedBox(height: 42),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: PanganKitaColors.brandPrimaryStrong,
              minimumSize: const Size.fromHeight(56),
              shape: const StadiumBorder(),
            ),
            onPressed: _save,
            child: const I18nText('Simpan Perubahan'),
          ),
        ],
      ),
    ),
  );
}

class _EditProfileHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton.filledTonal(
        tooltip: translateDisplayText(context, 'Kembali ke Profil Saya'),
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
      I18nText(
        'Edit Profil',
        style: Theme.of(context).textTheme.headlineLarge
            ?.copyWith(color: _ink),
      ),
    ],
  );
}

class _EditPhotoControls extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Center(
        child: Stack(
          children: [
            const CircleAvatar(
              radius: 92,
              backgroundImage: AssetImage('assets/prototype/avatar.webp'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton.filled(
                tooltip: translateDisplayText(
                  context,
                  'Ubah foto belum tersedia',
                ),
                onPressed: () => DemoNotice.unavailable(context),
                icon: const Icon(Icons.camera_alt_outlined),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: TextButton(
          onPressed: () => DemoNotice.unavailable(context),
          child: const I18nText(
            'Ubah Foto',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
      ),
    ],
  );
}

class _EditSecurityLink extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      leading: const Icon(Icons.lock_outline, color: _ink),
      title: I18nText(
        'Ubah Password',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => DemoNotice.unavailable(context),
    ),
  );
}

class _ProfileFields extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const I18nText('Nama lengkap', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: 'Vincent',
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: translateDisplayText(context, 'Nama lengkap'),
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Masukkan nama lengkap.'
            : null,
      ),
      const SizedBox(height: 24),
      const I18nText('Email', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: 'vincent@example.com',
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: translateDisplayText(context, 'Email contoh'),
        ),
        validator: (value) => value == null || !_emailShape.hasMatch(value)
            ? 'Masukkan email yang valid.'
            : null,
      ),
      const SizedBox(height: 24),
      const I18nText('Nomor telepon', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: translateDisplayText(context, 'Tambahkan nomor telepon'),
        ),
      ),
      const SizedBox(height: 6),
      I18nText(
        'Nomor telepon membantu toko menghubungimu.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
