const _minimumPasswordLength = 8;

/// Validation shared by the local sign-in, registration and recovery forms.
abstract final class AuthValidation {
  /// Returns an error for null or whitespace-only input; otherwise null.
  static String? requiredValue(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom wajib diisi.' : null;

  /// Validates a local email shape without checking account ownership.
  /// Returns null for accepted input; no email or verification is sent.
  static String? email(String? value) {
    final required = requiredValue(value);
    if (required != null) return required;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$')
            .hasMatch((value ?? '').trim())
        ? null
        : 'Masukkan format email yang valid.';
  }

  /// Requires eight or more characters including a letter and a digit.
  /// Returns null when valid; does not authenticate or store a password.
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
