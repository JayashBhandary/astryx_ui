/// Visual configuration for the radios in AstryxRadioList.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for the radios in `AstryxRadioList`.
///
/// The Material equivalent is `RadioThemeData`. Hover tints are derived from
/// the colours here, so overriding [selectedColor] retints the hover state
/// too.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Larger radios with a contrasting dot.
/// const AstryxRadioTheme(size: 24, dotColor: Color(0xFFFFD54F));
/// ```
/// {@end-tool}
@immutable
class AstryxRadioTheme {
  /// Creates a radio theme.
  const AstryxRadioTheme({
    this.selectedColor,
    this.backgroundColor,
    this.borderColor,
    this.dotColor,
    this.size,
    this.dotSize,
    this.borderWidth,
    this.disabledOpacity,
  });

  /// The circle fill when selected. Defaults to `--color-accent`.
  final Color? selectedColor;

  /// The circle fill when unselected.
  ///
  /// Defaults to `--color-background-surface`.
  final Color? backgroundColor;

  /// The outline when unselected and enabled.
  ///
  /// Defaults to `--color-border-emphasized`. A selected circle takes its
  /// border from the fill, and a disabled one keeps `--color-border`.
  final Color? borderColor;

  /// The dot that grows in when selected. Defaults to `--color-on-accent`.
  final Color? dotColor;

  /// The diameter of the circle, at every `AstryxToggleSize`.
  ///
  /// Defaults to 20 at `sm` and 24 at `md`.
  final double? size;

  /// The diameter of the dot. Defaults to 8 at `sm` and 10 at `md`.
  final double? dotSize;

  /// The outline width. Defaults to `--border-width`.
  final double? borderWidth;

  /// The opacity of a disabled radio. Defaults to 0.5.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  AstryxRadioTheme copyWith({
    Color? selectedColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? dotColor,
    double? size,
    double? dotSize,
    double? borderWidth,
    double? disabledOpacity,
  }) => AstryxRadioTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    dotColor: dotColor ?? this.dotColor,
    size: size ?? this.size,
    dotSize: dotSize ?? this.dotSize,
    borderWidth: borderWidth ?? this.borderWidth,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxRadioTheme merge(AstryxRadioTheme? other) {
    if (other == null) return this;
    return AstryxRadioTheme(
      selectedColor: other.selectedColor ?? selectedColor,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      dotColor: other.dotColor ?? dotColor,
      size: other.size ?? size,
      dotSize: other.dotSize ?? dotSize,
      borderWidth: other.borderWidth ?? borderWidth,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
    );
  }

  /// Linearly interpolates between two radio themes.
  static AstryxRadioTheme? lerp(
    AstryxRadioTheme? a,
    AstryxRadioTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxRadioTheme(
      selectedColor: lerpColor(a?.selectedColor, b?.selectedColor, t),
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      borderColor: lerpColor(a?.borderColor, b?.borderColor, t),
      dotColor: lerpColor(a?.dotColor, b?.dotColor, t),
      size: lerpNullableDouble(a?.size, b?.size, t),
      dotSize: lerpNullableDouble(a?.dotSize, b?.dotSize, t),
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
      other is AstryxRadioTheme &&
          other.selectedColor == selectedColor &&
          other.backgroundColor == backgroundColor &&
          other.borderColor == borderColor &&
          other.dotColor == dotColor &&
          other.size == size &&
          other.dotSize == dotSize &&
          other.borderWidth == borderWidth &&
          other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    selectedColor,
    backgroundColor,
    borderColor,
    dotColor,
    size,
    dotSize,
    borderWidth,
    disabledOpacity,
  );
}
