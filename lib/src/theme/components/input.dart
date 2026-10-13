/// Visual configuration for text-entry controls.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for text-entry controls: `AstryxTextInput`,
/// `AstryxTextArea`, `AstryxNumberInput`, the `AstryxSelector` trigger and the
/// other fields built on `AstryxInputContainer`.
///
/// The astryx counterpart of Material's `InputDecorationTheme`. The chrome —
/// background, border, corner radius, padding — is read by the shared input
/// container, so a theme set here reaches every text-like control at once,
/// including the date and time inputs, the multi and complex selectors, and
/// the search fields. The text styles and caret colours are read by the
/// controls that paint text.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxInputTheme {
  /// Creates an input theme.
  const AstryxInputTheme({
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.contentPadding,
    this.gap,
    this.textStyle,
    this.placeholderStyle,
    this.cursorColor,
    this.selectionColor,
  });

  /// The fill of an enabled, editable control.
  ///
  /// Defaults to `--color-background-surface`.
  final Color? backgroundColor;

  /// The fill of a disabled or read-only control.
  ///
  /// Defaults to `--color-background-muted`.
  final Color? disabledBackgroundColor;

  /// The border colour at rest. Defaults to `--color-border-emphasized`.
  final Color? borderColor;

  /// The border colour while the control holds focus, or while a selector's
  /// list is open. Defaults to `--color-accent`.
  final Color? focusBorderColor;

  /// The border colour in the error state.
  ///
  /// Defaults to the error status colour. The warning and success states
  /// keep their status colours.
  final Color? errorBorderColor;

  /// The border width at rest. Defaults to `--border-width`.
  ///
  /// Doubled while focused or in a status state, so the ring still reads as
  /// a ring.
  final double? borderWidth;

  /// The corner radius. Defaults to `--radius-element`.
  ///
  /// Inside an `AstryxInputGroup` the corners that meet a neighbour stay
  /// square regardless.
  final Radius? borderRadius;

  /// The padding between the border and the content.
  ///
  /// Defaults to `--spacing-2` horizontally, plus `--spacing-2` vertically for
  /// a multi-line control. Single-line controls keep their fixed height, so
  /// vertical padding there eats into the text rather than growing the box.
  final EdgeInsetsGeometry? contentPadding;

  /// The space between the leading content, the control and the trailing
  /// content. Defaults to `--spacing-2`.
  final double? gap;

  /// The style of the entered text — or a selector's chosen value — merged
  /// over the body type role.
  ///
  /// A disabled control keeps `--color-text-disabled` whatever colour is
  /// given here, so the disabled state stays legible as disabled.
  final TextStyle? textStyle;

  /// The style of the placeholder, merged over the resolved text style.
  ///
  /// Its colour defaults to `--color-text-secondary`.
  final TextStyle? placeholderStyle;

  /// The caret colour, and the colour of the selection handles.
  ///
  /// Defaults to `--color-accent`.
  final Color? cursorColor;

  /// The fill behind selected text. Defaults to `--color-accent-muted`.
  final Color? selectionColor;

  /// Returns a copy with the given fields replaced.
  AstryxInputTheme copyWith({
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    Color? errorBorderColor,
    double? borderWidth,
    Radius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    double? gap,
    TextStyle? textStyle,
    TextStyle? placeholderStyle,
    Color? cursorColor,
    Color? selectionColor,
  }) => AstryxInputTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    disabledBackgroundColor:
        disabledBackgroundColor ?? this.disabledBackgroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    errorBorderColor: errorBorderColor ?? this.errorBorderColor,
    borderWidth: borderWidth ?? this.borderWidth,
    borderRadius: borderRadius ?? this.borderRadius,
    contentPadding: contentPadding ?? this.contentPadding,
    gap: gap ?? this.gap,
    textStyle: textStyle ?? this.textStyle,
    placeholderStyle: placeholderStyle ?? this.placeholderStyle,
    cursorColor: cursorColor ?? this.cursorColor,
    selectionColor: selectionColor ?? this.selectionColor,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// The text styles merge rather than replace, so a theme that sets only a
  /// font size keeps a colour set further out.
  AstryxInputTheme merge(AstryxInputTheme? other) {
    if (other == null) return this;
    return AstryxInputTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      disabledBackgroundColor:
          other.disabledBackgroundColor ?? disabledBackgroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      errorBorderColor: other.errorBorderColor ?? errorBorderColor,
      borderWidth: other.borderWidth ?? borderWidth,
      borderRadius: other.borderRadius ?? borderRadius,
      contentPadding: other.contentPadding ?? contentPadding,
      gap: other.gap ?? gap,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      placeholderStyle:
          placeholderStyle?.merge(other.placeholderStyle) ??
          other.placeholderStyle,
      cursorColor: other.cursorColor ?? cursorColor,
      selectionColor: other.selectionColor ?? selectionColor,
    );
  }

  /// Linearly interpolates between two input themes.
  static AstryxInputTheme? lerp(
    AstryxInputTheme? a,
    AstryxInputTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxInputTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      disabledBackgroundColor: lerpColor(
        a?.disabledBackgroundColor,
        b?.disabledBackgroundColor,
        t,
      ),
      borderColor: lerpColor(a?.borderColor, b?.borderColor, t),
      focusBorderColor: lerpColor(a?.focusBorderColor, b?.focusBorderColor, t),
      errorBorderColor: lerpColor(a?.errorBorderColor, b?.errorBorderColor, t),
      borderWidth: lerpNullableDouble(a?.borderWidth, b?.borderWidth, t),
      borderRadius: _lerpCorner(a?.borderRadius, b?.borderRadius, t),
      contentPadding: lerpInsets(a?.contentPadding, b?.contentPadding, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      textStyle: lerpTextStyle(a?.textStyle, b?.textStyle, t),
      placeholderStyle: lerpTextStyle(
        a?.placeholderStyle,
        b?.placeholderStyle,
        t,
      ),
      cursorColor: lerpColor(a?.cursorColor, b?.cursorColor, t),
      selectionColor: lerpColor(a?.selectionColor, b?.selectionColor, t),
    );
  }

  /// A null side is absent, not zero — the same rule as the shared helpers.
  static Radius? _lerpCorner(Radius? a, Radius? b, double t) {
    if (a == null || b == null) return lerpDiscrete(a, b, t);
    return Radius.lerp(a, b, t);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxInputTheme &&
          other.backgroundColor == backgroundColor &&
          other.disabledBackgroundColor == disabledBackgroundColor &&
          other.borderColor == borderColor &&
          other.focusBorderColor == focusBorderColor &&
          other.errorBorderColor == errorBorderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.contentPadding == contentPadding &&
          other.gap == gap &&
          other.textStyle == textStyle &&
          other.placeholderStyle == placeholderStyle &&
          other.cursorColor == cursorColor &&
          other.selectionColor == selectionColor;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    disabledBackgroundColor,
    borderColor,
    focusBorderColor,
    errorBorderColor,
    borderWidth,
    borderRadius,
    contentPadding,
    gap,
    textStyle,
    placeholderStyle,
    cursorColor,
    selectionColor,
  );
}
