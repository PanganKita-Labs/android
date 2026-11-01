import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF10283C);
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
              Text(
                'Edit Profil',
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: _ink),
              ),
            ],
          ),
          const SizedBox(height: 36),
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
                    tooltip: 'Ubah foto belum tersedia',
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
              child: const Text(
                'Ubah Foto',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
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
          Text('Keamanan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: const Icon(Icons.lock_outline, color: _ink),
              title: Text(
                'Ubah Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => DemoNotice.unavailable(context),
            ),
          ),
          const SizedBox(height: 42),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: PanganKitaColors.brandPrimaryStrong,
              minimumSize: const Size.fromHeight(56),
              shape: const StadiumBorder(),
            ),
            onPressed: _save,
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    ),
  );
}

class _ProfileFields extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Nama lengkap', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: 'Vincent',
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: 'Nama lengkap'),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Masukkan nama lengkap.'
            : null,
      ),
      const SizedBox(height: 24),
      const Text('Email', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: 'vincent@example.com',
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Email contoh'),
        validator: (value) => value == null || !_emailShape.hasMatch(value)
            ? 'Masukkan email yang valid.'
            : null,
      ),
      const SizedBox(height: 24),
      const Text('Nomor telepon', style: _labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(hintText: 'Tambahkan nomor telepon'),
      ),
      const SizedBox(height: 6),
      Text(
        'Nomor telepon membantu toko menghubungimu.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
