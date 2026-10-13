/// Visual configuration for AstryxCheckbox.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxCheckbox` and the rows of
/// `AstryxCheckboxList`.
///
/// The Material equivalent is `CheckboxThemeData`. Hover tints are derived
/// from the colours here — upstream's percentages of `--color-tint-hover`
/// mixed over them — so overriding [fillColor] retints the hover state too.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Square, green checkboxes app-wide.
/// const AstryxCheckboxTheme(
///   fillColor: Color(0xFF2E7D32),
///   borderRadius: BorderRadius.zero,
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxCheckboxTheme {
  /// Creates a checkbox theme.
  const AstryxCheckboxTheme({
    this.fillColor,
    this.backgroundColor,
    this.borderColor,
    this.checkColor,
    this.size,
    this.borderRadius,
    this.borderWidth,
    this.disabledOpacity,
  });

  /// The box fill when checked or indeterminate. Defaults to `--color-accent`.
  final Color? fillColor;

  /// The box fill when unchecked.
  ///
  /// Defaults to `--color-background-surface`.
  final Color? backgroundColor;

  /// The outline when unchecked and enabled.
  ///
  /// Defaults to `--color-border-emphasized`. A filled box takes its border
  /// from the fill, and a disabled one keeps `--color-border`.
  final Color? borderColor;

  /// The tick, the indeterminate bar and the spinner on a filled box.
  ///
  /// Defaults to `--color-on-accent`.
  final Color? checkColor;

  /// The edge length of the box, at every `AstryxToggleSize`.
  ///
  /// Defaults to 20 at `sm` and 24 at `md`.
  final double? size;

  /// The corner radius of the box and its focus ring.
  ///
  /// Defaults to `--radius-inner`.
  final BorderRadiusGeometry? borderRadius;

  /// The outline width. Defaults to `--border-width`.
  final double? borderWidth;

  /// The opacity of a disabled box. Defaults to 0.5.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  AstryxCheckboxTheme copyWith({
    Color? fillColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? checkColor,
    double? size,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    double? disabledOpacity,
  }) => AstryxCheckboxTheme(
    fillColor: fillColor ?? this.fillColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    checkColor: checkColor ?? this.checkColor,
    size: size ?? this.size,
    borderRadius: borderRadius ?? this.borderRadius,
    borderWidth: borderWidth ?? this.borderWidth,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxCheckboxTheme merge(AstryxCheckboxTheme? other) {
    if (other == null) return this;
    return AstryxCheckboxTheme(
      fillColor: other.fillColor ?? fillColor,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      checkColor: other.checkColor ?? checkColor,
      size: other.size ?? size,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
    );
  }

  /// Linearly interpolates between two checkbox themes.
  static AstryxCheckboxTheme? lerp(
    AstryxCheckboxTheme? a,
    AstryxCheckboxTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxCheckboxTheme(
      fillColor: lerpColor(a?.fillColor, b?.fillColor, t),
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      borderColor: lerpColor(a?.borderColor, b?.borderColor, t),
      checkColor: lerpColor(a?.checkColor, b?.checkColor, t),
      size: lerpNullableDouble(a?.size, b?.size, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      borderWidth: lerpNullableDouble(a?.borderWidth, b?.borderWidth, t),
      disabledOpacity: lerpNullableDouble(
        a?.disabledOpacity,
        b?.disabledOpacity,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxCheckboxTheme &&
          other.fillColor == fillColor &&
          other.backgroundColor == backgroundColor &&
          other.borderColor == borderColor &&
          other.checkColor == checkColor &&
          other.size == size &&
          other.borderRadius == borderRadius &&
          other.borderWidth == borderWidth &&
          other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    fillColor,
    backgroundColor,
    borderColor,
    checkColor,
    size,
    borderRadius,
    borderWidth,
    disabledOpacity,
  );
}
