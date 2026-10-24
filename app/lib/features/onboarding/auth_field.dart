import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/reference_icon.dart';

const _visibilityIconSize = 20.0;

/// Accessible form field with local password visibility state.
class AuthField extends StatefulWidget {
  /// Creates a field; [password] enables the visibility control.
  const new({
    required this.label,
    required this.controller,
    required this.validator,
    this.password = false,
    super.key,
  });

  /// Visible hint and screen-reader label.
  final String label;

  /// Controller owned by the form.
  final TextEditingController controller;

  /// Local input validation.
  final FormFieldValidator<String> validator;

  /// Whether the field contains a password.
  final bool password;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final tooltip = _visible ? 'Sembunyikan password' : 'Tampilkan password';
    final visibilityIcon = _visible ? 'eye-off' : 'eye';
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(
        fontSize: 15,
        height: 1.2,
        color: Color(0xFF20242A),
      ),
      validator: widget.validator,
      obscureText: widget.password && !_visible,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: widget.label == 'Email'
          ? TextInputType.emailAddress
          : TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontSize: 15,
          height: 1.2,
          color: Color(0xFF8695A5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: PanganKitaColors.borderNeutral),
        ),
        suffixIcon: widget.password
            ? IconButton(
                tooltip: tooltip,
                onPressed: () => setState(() => _visible = !_visible),
                icon: ReferenceIcon(
                  visibilityIcon,
                  size: _visibilityIconSize,
                  color: const Color(0xFF657181),
                ),
              )
            : null,
      ),
    );
  }
}
