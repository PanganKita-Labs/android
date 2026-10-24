import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/food_card.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';

import 'font_test_utils.dart';

TextStyle _styleOf(WidgetTester tester, Finder finder) {
  final text = tester.widget<Text>(finder);
  return DefaultTextStyle.of(tester.element(finder)).style.merge(text.style);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  test('theme assigns Geist to emphasis and Satoshi to supporting text', () {
    final theme = PanganKitaTheme.light;
    for (final style in [
      theme.textTheme.displayLarge,
      theme.textTheme.displayMedium,
      theme.textTheme.displaySmall,
      theme.textTheme.headlineLarge,
      theme.textTheme.headlineMedium,
      theme.textTheme.headlineSmall,
      theme.textTheme.titleLarge,
      theme.textTheme.titleMedium,
      theme.textTheme.titleSmall,
    ]) {
      expect(style?.fontFamily, 'Geist');
    }
    for (final style in [
      theme.textTheme.bodyLarge,
      theme.textTheme.bodyMedium,
      theme.textTheme.bodySmall,
      theme.textTheme.labelLarge,
      theme.textTheme.labelMedium,
      theme.textTheme.labelSmall,
    ]) {
      expect(style?.fontFamily, 'Satoshi');
    }
    for (final style in [
      theme.filledButtonTheme.style,
      theme.elevatedButtonTheme.style,
      theme.outlinedButtonTheme.style,
      theme.textButtonTheme.style,
    ]) {
      expect(style?.textStyle?.resolve({})?.fontFamily, 'Geist');
    }
  });

  testWidgets(
    'homepage applies the approved text roles including mixed badges',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 1800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(theme: PanganKitaTheme.light, home: const HomePage()),
      );
      await tester.pumpAndSettle();

      for (final label in [
        'Selamat Pagi, Vincent',
        'Croissant Favoritmu,\nDiskon Hingga 60%',
        'Pesan Sekarang!',
        'Kategori',
        'Flash Sale',
        'Dekat dari Lokasimu',
        'Lihat Semua',
        'Mawar Coconut\nBuns (Isi 5 pcs)',
        'Rp32.000',
        'Beranda',
        'Pesanan',
        'Chat',
        'Notifikasi',
      ]) {
        expect(
          _styleOf(tester, find.text(label).first).fontFamily,
          'Geist',
          reason: label,
        );
      }
      for (final label in [
        'Mandala by Pass, Medan',
        'Semua',
        'Mawar Bakery & Cake',
        '4.8 (106+ ratings)',
        'Rp65.000',
        'Sisa 2 kotak',
        'Diurutkan dari jarak pickup terdekat',
      ]) {
        expect(
          _styleOf(tester, find.text(label).first).fontFamily,
          'Satoshi',
          reason: label,
        );
      }
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.fontFamily,
        'Satoshi',
      );
      final card = find.byType(FoodCard).first;
      final saving = find.descendant(
        of: card,
        matching: find.text('Hemat 60%'),
      );
      expect(_styleOf(tester, saving).fontFamily, 'Satoshi');
      final savingSpan = tester.widget<Text>(saving).textSpan! as TextSpan;
      expect(savingSpan.children!.last.style?.fontFamily, 'Geist');
      final flashBadge = find.descendant(
        of: card,
        matching: find.text('Flash Sale'),
      );
      expect(_styleOf(tester, flashBadge).fontFamily, 'Satoshi');
      expect(_styleOf(tester, flashBadge).fontWeight, FontWeight.w500);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('login uses Geist headings and actions with Satoshi inputs', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const AuthPage.login()),
    );
    await tester.pumpAndSettle();
    expect(
      _styleOf(tester, find.text('Selamat datang kembali!')).fontFamily,
      'Geist',
    );
    expect(_styleOf(tester, find.text('Masuk')).fontFamily, 'Geist');
    expect(_styleOf(tester, find.text('Lupa Password?')).fontFamily, 'Geist');
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.style.fontFamily, 'Satoshi');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('OTP heading uses Geist while form digits remain Satoshi', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: PanganKitaTheme.light, home: const OtpPage()),
    );
    await tester.pumpAndSettle();
    expect(
      _styleOf(tester, find.text('Verifikasi Kode OTP')).fontFamily,
      'Geist',
    );
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.style.fontFamily, 'Satoshi');
      expect(field.style.fontWeight, FontWeight.w500);
    }
    expect(tester.takeException(), isNull);
  });
}
