import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _providerGap = 9.0;
const _providerIconSize = 26.0;
const _facebookIconHeight = 30.0;
const _socialBorder = Color(0xFFDADBD9);
const _dividerColor = Color(0xFFE4E8EB);

/// Provider buttons using the actual artwork from the supplied reference.
class SocialSignIn extends StatelessWidget {
  /// Creates the social sign-in group.
  const new({required this.register, super.key});

  /// Whether this group appears below registration.
  final bool register;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _SocialDivider(register: register),
      const SizedBox(height: 16),
      Row(
        spacing: _providerGap,
        children: [
          for (final provider in ['Facebook', 'Google', 'Apple'])
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: _socialBorder, width: 1.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                ),
                onPressed: () => DemoNotice.show(
                  context,
                  'Login $provider belum terhubung. Tidak ada akun yang '
                  'digunakan.',
                ),
                child: Semantics(
                  label: 'Lanjutkan dengan $provider',
                  child: Image.asset(
                    'assets/prototype/social-${provider.toLowerCase()}.png',
                    width: _providerIconSize,
                    height: provider == 'Facebook'
                        ? _facebookIconHeight
                        : _providerIconSize,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );
}

class _SocialDivider extends StatelessWidget {
  const new({required this.register});
  final bool register;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(
          child: Center(child: Divider(color: _dividerColor, height: 1)),
        ),
        ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              register ? 'Atau daftar dengan' : 'Lanjutkan dengan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: PanganKitaTheme.bodyFontFamily,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6F7886),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
