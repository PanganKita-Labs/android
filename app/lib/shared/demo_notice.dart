import 'package:flutter/material.dart';
import 'package:pangankita/i18n/i18n.dart';

/// Feedback for actions that have no server integration.
abstract final class DemoNotice {
  /// Shows [message] as local feedback using [context].
  ///
  /// Hides the current snackbar before presenting the new message.
  /// No notification is sent to a device or external service.
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: I18nText(message)));
  }

  /// Explains an unavailable integration.
  static void unavailable(BuildContext context) =>
      show(context, 'Fitur ini belum tersedia dalam demo offline.');
}
