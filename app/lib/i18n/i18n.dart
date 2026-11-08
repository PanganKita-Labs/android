/// Stable, app-facing import for PanganKita internationalization.
///
/// Do not import Flutter-generated `app_localizations*.dart` files directly
/// from application screens.
library;

import 'package:flutter/widgets.dart';
import 'package:pangankita/i18n/generated/app_localizations.dart';

export 'package:pangankita/i18n/generated/app_localizations.dart';
export 'package:pangankita/i18n/i18n_text.dart';

/// Reads localization strings through a BuildContext.
extension I18n on BuildContext {
  /// Returns the active localizations, or null in isolated tests without
  /// localization delegates.
  AppLocalizations? get i18n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations);
}
