import 'package:flutter/material.dart';
import 'package:pangankita/i18n/i18n.dart';

/// Feedback for actions that have no server integration.
abstract final class DemoNotice {
  /// Replaces any previous message with honest local-demo feedback.
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: I18nText(message)));
  }

  /// Explains an unavailable integration.
  static void unavailable(BuildContext context) =>
      show(context, 'Fitur ini belum tersedia dalam demo offline.');
}
