import 'package:flutter/widgets.dart';
import 'package:pangankita/i18n/generated/app_localizations.dart';
import 'package:pangankita/i18n/generated/i18n_presentation_lookup.g.dart';

/// Translates recognized presentation strings using the generated lookup.
///
/// Returns [value] unchanged if no localization delegate is available
/// or if the value has no matching generated translation.
/// [context] supplies the active translation delegate; [value] should be a
/// known presentation phrase, never an identifier or user-provided value.
String translateDisplayText(BuildContext context, String value) =>
    translateI18nPresentation(
      Localizations.of<AppLocalizations>(context, AppLocalizations),
      value,
    );

/// A const-capable localized equivalent of a plain Flutter [Text] widget.
///
/// Missing delegates and unrecognized display text retain [data].
/// Do not translate identifiers, URLs, route names, or user input.
class I18nText extends StatelessWidget {
  /// Creates a localized rendering of [data] with the given text options.
  ///
  /// Only phrases recognized by the generated lookup are translated.
  /// [locale] controls text shaping, not the active translation language;
  /// the surrounding localization context selects the language.
  /// Styling, layout, and accessibility options pass through to [Text].
  const new(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  /// Original display text, generally sourced from the Indonesian demo.
  final String data;

  /// Font and text styling applied to the translated value.
  final TextStyle? style;

  /// Strut style inherited by the translated text.
  final StrutStyle? strutStyle;

  /// Text horizontal alignment.
  final TextAlign? textAlign;

  /// Override for text direction.
  final TextDirection? textDirection;

  /// Override for typographic locale.
  final Locale? locale;

  /// Whether text may wrap.
  final bool? softWrap;

  /// Overflow behavior of rendered text.
  final TextOverflow? overflow;

  /// Text scaling override.
  final TextScaler? textScaler;

  /// Maximum line count.
  final int? maxLines;

  /// Optional semantics override.
  final String? semanticsLabel;

  /// Text layout width basis.
  final TextWidthBasis? textWidthBasis;

  /// Text height behavior.
  final TextHeightBehavior? textHeightBehavior;

  /// Selection color.
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) => Text(
    translateDisplayText(context, data),
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}
