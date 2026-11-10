import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/onboarding/auth_validation.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/demo_notice.dart';

const Color _ink = PanganKitaColors.inkDeep;

/// Email step for the local password recovery preview.
class RecoveryPage extends StatefulWidget {
  /// Creates the demo recovery form.
  const new({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

/// Owns the recovery email input and local validation status.
class _RecoveryPageState extends State<RecoveryPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

/// Validates the local email input before opening recovery verification.
  void _continue() {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    DemoNotice.show(
      context,
      'Mode demo. Tidak ada email atau kode yang dikirim.',
    );
    Navigator.pushNamed<void>(context, AppRoutes.recoverOtp).ignore();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          const _RecoveryHeader(),
          const SizedBox(height: 52),
          _RecoveryForm(form: _form, email: _email, onContinue: _continue),
          const SizedBox(height: 42),
          const Center(child: I18nText('Sudah ingat password?')),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const I18nText('Kembali ke Login'),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Collects the recovery email for a demonstration route only.
class _RecoveryForm extends StatelessWidget {
  const new({
    required this.form,
    required this.email,
    required this.onContinue,
  });

  final GlobalKey<FormState> form;
  final TextEditingController email;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => Form(
    key: form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        I18nText(
          'Email',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: _ink),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: email,
          validator: AuthValidation.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          onFieldSubmitted: (_) => onContinue(),
          decoration: const InputDecoration(
            hintText: 'nama@contoh.com',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 10),
        I18nText(
          'Mode demo: tidak ada email atau kode yang dikirim.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 54),
        FilledButton(
          onPressed: onContinue,
          style: FilledButton.styleFrom(shape: const StadiumBorder()),
          child: const I18nText('Kirim Kode OTP'),
        ),
      ],
    ),
  );
}

/// Explains the account-recovery preview and navigation.
class _RecoveryHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton.filledTonal(
          tooltip: translateDisplayText(context, 'Kembali'),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _ink,
            minimumSize: const Size.square(52),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      const SizedBox(height: 46),
      const Center(
        child: CircleAvatar(
          radius: 58,
          backgroundColor: PanganKitaColors.savingsSurface,
          child: Icon(
            Icons.lock_outline,
            size: 56,
            color: PanganKitaColors.brandPrimaryStrong,
          ),
        ),
      ),
      const SizedBox(height: 28),
      I18nText(
        'Lupa Password?',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: _ink),
      ),
      const SizedBox(height: 6),
      I18nText(
        'Tenang, kami bantu pulihkan akunmu.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}
