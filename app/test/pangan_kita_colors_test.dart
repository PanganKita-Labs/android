import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';

void main() {
  test('reference color tokens preserve approved pixel values', () {
    // These are visual-regression anchors, not alternative runtime tokens.
    expect(PanganKitaColors.inkCool, const Color(0xFF14313A));
    expect(PanganKitaColors.inkDeep, const Color(0xFF10283C));
    expect(PanganKitaColors.referenceOrange, const Color(0xFFE98412));
    expect(PanganKitaColors.highlightGreen, const Color(0xFF52A963));
    expect(PanganKitaColors.navigationInactive, const Color(0xFF8D8F90));
    expect(PanganKitaColors.positiveSurfaceMuted, const Color(0xFFE6F0EB));
    expect(PanganKitaColors.positiveSurface, const Color(0xFFE7F5ED));
    expect(PanganKitaColors.informationSurface, const Color(0xFFE7F0EB));
    expect(PanganKitaColors.attentionText, const Color(0xFFAD5200));
    expect(PanganKitaColors.textSecondaryCool, const Color(0xFF52636B));
  });
}
