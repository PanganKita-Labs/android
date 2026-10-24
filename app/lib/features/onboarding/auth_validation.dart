const _minimumPasswordLength = 8;

/// Validation shared by the local sign-in, registration and recovery forms.
abstract final class AuthValidation {
  /// Requires a nonblank form value.
  static String? requiredValue(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom wajib diisi.' : null;

  /// Checks the format only; no email is sent.
  static String? email(String? value) {
    final required = requiredValue(value);
    if (required != null) return required;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$')
            .hasMatch((value ?? '').trim())
        ? null
        : 'Masukkan format email yang valid.';
  }

  /// Mirrors the reference's registration password requirements.
  static String? password(String? value) {
    if (value == null ||
        value.length < _minimumPasswordLength ||
        !RegExp('[A-Za-z]').hasMatch(value) ||
        !RegExp('[0-9]').hasMatch(value)) {
      return 'Gunakan minimal 8 karakter, termasuk huruf dan angka.';
    }
    return null;
  }
}
