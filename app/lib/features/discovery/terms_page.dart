import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

const _ink = Color(0xFF10283C);

/// Information about the current demo while official terms await approval.
class TermsPage extends StatelessWidget {
  /// Creates the terms preview opened from Settings.
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(title: const Text('Syarat & Ketentuan')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(
            'Syarat & Ketentuan',
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(color: _ink),
          ),
          const SizedBox(height: 8),
          const Text('Informasi penggunaan versi contoh PanganKita'),
          const SizedBox(height: 24),
          const Card(
            color: Color(0xFFE7F0EB),
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Dokumen Syarat & Ketentuan resmi belum tersedia. '
                'Halaman ini menjelaskan kemampuan aplikasi contoh saat ini '
                'dan belum menjadi perjanjian penggunaan.',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _TermsSection(
            title: 'Akun',
            description:
                'Masuk, pendaftaran, dan pemulihan password saat ini '
                'merupakan simulasi lokal. Tidak ada akun atau password '
                'yang dibuat melalui halaman contoh.',
          ),
          const _TermsSection(
            title: 'Produk dan pesanan',
            description:
                'Daftar makanan, harga, stok, dan pesanan yang ditampilkan '
                'adalah contoh. Menekan tombol pada alur belanja belum '
                'membuat reservasi atau pesanan nyata.',
          ),
          const _TermsSection(
            title: 'Pembayaran dan pengambilan',
            description:
                'Tampilan pembayaran dan pengambilan hanya pratinjau. '
                'Tidak ada pembayaran yang diproses atau pengambilan '
                'yang dicatat oleh contoh aplikasi ini.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Ketentuan resmi perlu diterbitkan dan ditinjau oleh tim '
            'sebelum layanan nyata digunakan.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

class _TermsSection extends StatelessWidget {
  const new({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
        ),
        const SizedBox(height: 6),
        Text(description),
      ],
    ),
  );
}
