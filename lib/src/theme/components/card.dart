/// Visual configuration for AstryxCard and AstryxSelectableCard.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxCard` and `AstryxSelectableCard`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// The fill fields deliberately do not flatten the card's variants:
/// [backgroundColor] replaces only the standard fill, so a muted, transparent
/// or categorical card keeps its own colour.
///
/// {@tool snippet}
/// ```dart
/// // Softer, rounder cards everywhere.
/// const AstryxCardTheme(
///   borderRadius: BorderRadius.all(Radius.circular(16)),
///   borderColor: Color(0x14000000),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxCardTheme {
  /// Creates a card theme.
  const AstryxCardTheme({
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.gap,
    this.shadows,
  });

  /// The fill of the standard variant.
  ///
  /// Defaults to `--color-background-card`. The muted, transparent and
  /// categorical variants keep their own fills.
  final Color? backgroundColor;

  /// The fill of a selected `AstryxSelectableCard`.
  ///
  /// Defaults to `--color-accent-muted`.
  final Color? selectedBackgroundColor;

  /// The hairline border colour. Defaults to `--color-border`.
  final Color? borderColor;

  /// The border colour of a selected `AstryxSelectableCard`.
  ///
  /// Defaults to `--color-accent`.
  final Color? selectedBorderColor;

  /// The border width. Defaults to `--border-width`.
  final double? borderWidth;

  /// The corner radius. Defaults to `--radius-container`.
  ///
  /// Also shapes the card's focus ring.
  final BorderRadiusGeometry? borderRadius;

  /// The inner padding, used when the widget sets no `padding` of its own.
  ///
  /// Defaults to `--spacing-4` on every side.
  final EdgeInsetsGeometry? padding;

  /// The gap between a card's slots — header, body and footer, or a
  /// selectable card's control and content — used when the widget sets no
  /// `padding` of its own.
  ///
  /// Defaults to `--spacing-4`.
  final double? gap;

  /// The resting shadow, used when the widget sets no `elevation` of its own.
  ///
  /// Defaults to none. Inset layers are dropped.
  final List<AstryxShadow>? shadows;

  /// Returns a copy with the given fields replaced.
  AstryxCardTheme copyWith({
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? borderColor,
    Color? selectedBorderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    double? gap,
    List<AstryxShadow>? shadows,
  }) => AstryxCardTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    selectedBackgroundColor:
        selectedBackgroundColor ?? this.selectedBackgroundColor,
    borderColor: borderColor ?? this.borderColor,
    selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
    borderWidth: borderWidth ?? this.borderWidth,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    shadows: shadows ?? this.shadows,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxCardTheme merge(AstryxCardTheme? other) {
    if (other == null) return this;
    return AstryxCardTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      selectedBackgroundColor:
          other.selectedBackgroundColor ?? selectedBackgroundColor,
      borderColor: other.borderColor ?? borderColor,
      selectedBorderColor: other.selectedBorderColor ?? selectedBorderColor,
      borderWidth: other.borderWidth ?? borderWidth,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      gap: other.gap ?? gap,
      shadows: other.shadows ?? shadows,
    );
  }

  /// Linearly interpolates between two card themes.
  static AstryxCardTheme? lerp(
    AstryxCardTheme? a,
    AstryxCardTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxCardTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      selectedBackgroundColor: lerpColor(
        a?.selectedBackgroundColor,
        b?.selectedBackgroundColor,
        t,
      ),
      borderColor: lerpColor(a?.borderColor, b?.borderColor, t),
      selectedBorderColor: lerpColor(
        a?.selectedBorderColor,
        b?.selectedBorderColor,
        t,
      ),
      borderWidth: lerpNullableDouble(a?.borderWidth, b?.borderWidth, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxCardTheme &&
          other.backgroundColor == backgroundColor &&
          other.selectedBackgroundColor == selectedBackgroundColor &&
          other.borderColor == borderColor &&
          other.selectedBorderColor == selectedBorderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.padding == padding &&
          other.gap == gap &&
          deepEquals(other.shadows, shadows);

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    selectedBackgroundColor,
    borderColor,
    selectedBorderColor,
    borderWidth,
    borderRadius,
    padding,
    gap,
    deepHash(shadows),
  );
}
