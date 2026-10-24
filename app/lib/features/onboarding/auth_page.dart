import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/features/onboarding/auth_field.dart';
import 'package:pangankita/features/onboarding/auth_validation.dart';
import 'package:pangankita/features/onboarding/social_sign_in.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _minFormGutter = 20.0;
const _maxFormGutter = 29.0;
const _formGutterFraction = .07;
const _formBottom = 28.0;
const _loginTop = 70.0;
const _formTop = 16.0;
const _fieldGap = 12.0;
const _submitGap = 24.0;
const _compactSubmitGap = 8.0;

enum _AuthMode {
  login,
  register,
  password;

  String get title => switch (this) {
    login => 'Selamat datang kembali!',
    register => 'Buat Akun Baru',
    password => 'Buat Password Baru',
  };
  String get subtitle => switch (this) {
    login => 'Temukan makanan favorit dengan\nharga lebih hemat.',
    register => 'Daftar dan nikmati makanan lezat\ndengan harga lebih hemat.',
    password => 'Pastikan password mudah diingat\nnamun sulit ditebak.',
  };
  String get passwordLabel => switch (this) {
    login => 'Password',
    register => 'Buat password',
    password => 'Password baru',
  };
  String get submitLabel => switch (this) {
    login => 'Masuk',
    register => 'Daftar',
    password => 'Simpan Password',
  };
  String get nextRoute => switch (this) {
    login => AppRoutes.home,
    register => AppRoutes.verify,
    password => AppRoutes.success,
  };
}

/// Reference sign-in, registration, and replacement-password screens.
class AuthPage extends StatelessWidget {
  /// Creates the sign-in screen.
  const new login({super.key}) : _mode = _AuthMode.login;

  /// Creates the registration screen.
  const new register({super.key}) : _mode = _AuthMode.register;

  /// Creates the local replacement-password screen.
  const new password({super.key}) : _mode = _AuthMode.password;

  final _AuthMode _mode;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(
                    horizontal:
                        (MediaQuery.sizeOf(context).width * _formGutterFraction)
                            .clamp(_minFormGutter, _maxFormGutter),
                  ).copyWith(
                    top: _mode == _AuthMode.login ? _loginTop : _formTop,
                    bottom: _formBottom,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_mode != _AuthMode.login)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                  const SizedBox(height: 20),
                  _AuthHeading(mode: _mode),
                  const SizedBox(height: 25),
                  _AuthForm(mode: _mode),
                  if (_mode != _AuthMode.password) ...[
                    const SizedBox(height: 19),
                    SocialSignIn(register: _mode == _AuthMode.register),
                    const Spacer(),
                    const SizedBox(height: 24),
                    _AuthFooter(register: _mode == _AuthMode.register),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AuthHeading extends StatelessWidget {
  const new({required this.mode});
  final _AuthMode mode;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: mode == _AuthMode.password
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start,
    children: [
      Text(
        mode.title,
        textAlign: mode == _AuthMode.password
            ? TextAlign.center
            : TextAlign.start,
        style: const TextStyle(
          fontSize: 27,
          height: 1.18,
          fontWeight: FontWeight.w700,
          letterSpacing: -.55,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        mode.subtitle,
        textAlign: mode == _AuthMode.password
            ? TextAlign.center
            : TextAlign.start,
        style: const TextStyle(fontSize: 16, height: 1.38),
      ),
    ],
  );
}

class _AuthFooter extends StatelessWidget {
  const new({required this.register});
  final bool register;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(register ? 'Sudah punya akun?' : 'Belum punya akun?'),
      TextButton(
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          register ? AppRoutes.login : AppRoutes.register,
        ),
        child: Text(register ? 'Masuk' : 'Daftar'),
      ),
    ],
  );
}

class _AuthForm extends StatefulWidget {
  const new({required this.mode});
  final _AuthMode mode;

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool get _login => widget.mode == _AuthMode.login;
  bool get _register => widget.mode == _AuthMode.register;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _confirmation(String? value) =>
      value != _password.text || value == null || value.isEmpty
      ? 'Konfirmasi password tidak cocok.'
      : null;

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    _password.clear();
    _confirm.clear();
    DemoNotice.show(
      context,
      'Mode demo. Tidak ada autentikasi atau akun server.',
    );
    await Navigator.pushNamed<void>(context, widget.mode.nextRoute);
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: _fieldGap,
      children: [
        if (_register)
          AuthField(
            label: 'Nama lengkap',
            controller: _name,
            validator: AuthValidation.requiredValue,
          ),
        if (widget.mode != _AuthMode.password)
          AuthField(
            label: 'Email',
            controller: _email,
            validator: AuthValidation.email,
          ),
        AuthField(
          label: widget.mode.passwordLabel,
          controller: _password,
          password: true,
          validator: _login
              ? AuthValidation.requiredValue
              : AuthValidation.password,
        ),
        if (!_login)
          AuthField(
            label: widget.mode == _AuthMode.password
                ? 'Konfirmasi password baru'
                : 'Konfirmasi password',
            controller: _confirm,
            password: true,
            validator: _confirmation,
          ),
        if (_login)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.recover),
              child: const Text(
                'Lupa Password?',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
            ),
          ),
        SizedBox(height: _login ? _submitGap : _compactSubmitGap),
        FilledButton(
          onPressed: () {
            unawaited(_submit());
          },
          child: Text(widget.mode.submitLabel),
        ),
      ],
    ),
  );
}
