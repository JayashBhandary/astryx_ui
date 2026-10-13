/// Visual configuration for toasts.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for toasts: the cards `AstryxToastHost` stacks.
///
/// The Material equivalent is `SnackBarThemeData`. Toasts are raised through
/// a controller rather than built in place, so the app-wide slot is the usual
/// way in; `AstryxToast.theme` overrides it for one toast.
///
/// The fill is per type — a neutral toast and an error toast must stay
/// distinguishable — so there is one colour field for each rather than one
/// for all.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the toast's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Shorter-lived, squarer toasts.
/// const AstryxToastTheme(
///   duration: Duration(seconds: 3),
///   borderRadius: BorderRadius.all(Radius.circular(4)),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxToastTheme {
  /// Creates a toast theme.
  const AstryxToastTheme({
    this.backgroundColor,
    this.errorBackgroundColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.shadows,
    this.maxWidth,
    this.margin,
    this.spacing,
    this.duration,
  });

  /// The fill of a neutral toast.
  ///
  /// Defaults to `--color-background-inverted`. The content is resolved for
  /// the opposite colour mode, so pick a fill that suits it.
  final Color? backgroundColor;

  /// The fill of an error toast.
  ///
  /// Defaults to `--color-background-error-inverted`.
  final Color? errorBackgroundColor;

  /// The message style, merged over the default text style.
  final TextStyle? textStyle;

  /// The space between the card's edge and its content.
  ///
  /// Defaults to `--spacing-4` on every side.
  final EdgeInsetsGeometry? padding;

  /// The card's corner radius. Defaults to `--radius-container`.
  final BorderRadiusGeometry? borderRadius;

  /// The card's shadow. Defaults to `--shadow-med`.
  final List<AstryxShadow>? shadows;

  /// The widest a card may be. Defaults to 400.
  final double? maxWidth;

  /// The space between the stack and the screen edge, inside the safe area.
  ///
  /// Read from the app-wide theme only, since it places the whole stack.
  /// Defaults to `--spacing-4` on every side.
  final EdgeInsetsGeometry? margin;

  /// The gap between stacked toasts.
  ///
  /// Read from the app-wide theme only, since it spaces the whole stack.
  /// Defaults to `--spacing-3`.
  final double? spacing;

  /// How long a toast stays when it does not say.
  ///
  /// Defaults to five seconds. [Duration.zero] keeps toasts until dismissed.
  final Duration? duration;

  /// Returns a copy with the given fields replaced.
  AstryxToastTheme copyWith({
    Color? backgroundColor,
    Color? errorBackgroundColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    List<AstryxShadow>? shadows,
    double? maxWidth,
    EdgeInsetsGeometry? margin,
    double? spacing,
    Duration? duration,
  }) => AstryxToastTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
    textStyle: textStyle ?? this.textStyle,
    padding: padding ?? this.padding,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    maxWidth: maxWidth ?? this.maxWidth,
    margin: margin ?? this.margin,
    spacing: spacing ?? this.spacing,
    duration: duration ?? this.duration,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxToastTheme merge(AstryxToastTheme? other) {
    if (other == null) return this;
    return AstryxToastTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      errorBackgroundColor: other.errorBackgroundColor ?? errorBackgroundColor,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      padding: other.padding ?? padding,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      maxWidth: other.maxWidth ?? maxWidth,
      margin: other.margin ?? margin,
      spacing: other.spacing ?? spacing,
      duration: other.duration ?? duration,
    );
  }

  /// Linearly interpolates between two toast themes.
  static AstryxToastTheme? lerp(
    AstryxToastTheme? a,
    AstryxToastTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxToastTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      errorBackgroundColor: lerpColor(
        a?.errorBackgroundColor,
        b?.errorBackgroundColor,
        t,
      ),
      textStyle: lerpTextStyle(a?.textStyle, b?.textStyle, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      maxWidth: lerpNullableDouble(a?.maxWidth, b?.maxWidth, t),
      margin: lerpInsets(a?.margin, b?.margin, t),
      spacing: lerpNullableDouble(a?.spacing, b?.spacing, t),
      duration: lerpDuration(a?.duration, b?.duration, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxToastTheme &&
          other.backgroundColor == backgroundColor &&
          other.errorBackgroundColor == errorBackgroundColor &&
          other.textStyle == textStyle &&
          other.padding == padding &&
          other.borderRadius == borderRadius &&
          deepEquals(other.shadows, shadows) &&
          other.maxWidth == maxWidth &&
          other.margin == margin &&
          other.spacing == spacing &&
          other.duration == duration;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    errorBackgroundColor,
    textStyle,
    padding,
    borderRadius,
    deepHash(shadows),
    maxWidth,
    margin,
    spacing,
    duration,
  );
}
