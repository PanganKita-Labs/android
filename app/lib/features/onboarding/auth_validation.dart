const _minimumPasswordLength = 8;

/// Validation shared by the local sign-in, registration and recovery forms.
abstract final class AuthValidation {
  /// Returns an error for null or whitespace-only input; otherwise null.
  static String? requiredValue(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom wajib diisi.' : null;

  /// Validates the shape of [value] without verifying an email account.
  ///
  /// Returns the required-field error for null or blank text, a format
  /// error for rejected input, or `null` for an accepted email shape.
  /// No email is sent and no identity is authenticated.
  static String? email(String? value) {
    final required = requiredValue(value);
    if (required != null) return required;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$')
            .hasMatch((value ?? '').trim())
        ? null
        : 'Masukkan format email yang valid.';
  }

  /// Validates [value] as a local password-form input.
  ///
  /// Returns an error for null, fewer than eight characters, or missing
  /// ASCII letters or digits; otherwise returns `null`. This does not
  /// authenticate or persist the password.
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
