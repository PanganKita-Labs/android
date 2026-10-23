import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

/// Minimal application entry point for the PanganKita Flutter rebuild.
class PanganKitaApp extends StatelessWidget {
  /// Creates the app without any legacy screens or mock business flows.
  const new({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PanganKita',
    debugShowCheckedModeBanner: false,
    theme: PanganKitaTheme.light,
    home: const Scaffold(
      body: SafeArea(child: Center(child: Text('UI belum diimplementasikan'))),
    ),
  );
}
