/// Visual configuration for AstryxBottomSheet.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBottomSheet` and the sheets of an
/// `AstryxBottomSheetSwitcher`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Rounder sheets with a quieter handle.
/// AstryxBottomSheetTheme(
///   borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
///   handleColor: const Color(0x33000000),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxBottomSheetTheme {
  /// Creates a bottom sheet theme.
  const AstryxBottomSheetTheme({
    this.backgroundColor,
    this.scrimColor,
    this.borderRadius,
    this.border,
    this.shadows,
    this.padding,
    this.maxWidth,
    this.handleColor,
    this.handleWidth,
    this.handleHeight,
  });

  /// The sheet fill. Defaults to `--color-background-surface`.
  final Color? backgroundColor;

  /// The scrim colour behind the sheet. Defaults to `--color-overlay`.
  final Color? scrimColor;

  /// The sheet's corner radius.
  ///
  /// Defaults to `--radius-container` on the two top corners only; the bottom
  /// corners sit against the viewport edge.
  final BorderRadiusGeometry? borderRadius;

  /// The hairline on the three edges facing the scrim.
  ///
  /// Defaults to `--color-border` at `--border-width`. [BorderSide.none]
  /// drops it.
  final BorderSide? border;

  /// The sheet's elevation. Defaults to `--shadow-high`.
  ///
  /// Inset layers are not drawn.
  final List<AstryxShadow>? shadows;

  /// The inset around the body when the widget sets none.
  ///
  /// Defaults to `--spacing-4` on every side.
  final EdgeInsetsGeometry? padding;

  /// The widest the sheet grows before it centres instead. Defaults to 640.
  final double? maxWidth;

  /// The grab handle's colour. Defaults to `--color-border`.
  final Color? handleColor;

  /// The grab handle's width. Defaults to `--size-element-lg`.
  final double? handleWidth;

  /// The grab handle's thickness. Defaults to `--spacing-1`.
  ///
  /// Only the pill: the drag target around it stays a full touch target.
  final double? handleHeight;

  /// Returns a copy with the given fields replaced.
  AstryxBottomSheetTheme copyWith({
    Color? backgroundColor,
    Color? scrimColor,
    BorderRadiusGeometry? borderRadius,
    BorderSide? border,
    List<AstryxShadow>? shadows,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
    Color? handleColor,
    double? handleWidth,
    double? handleHeight,
  }) => AstryxBottomSheetTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    scrimColor: scrimColor ?? this.scrimColor,
    borderRadius: borderRadius ?? this.borderRadius,
    border: border ?? this.border,
    shadows: shadows ?? this.shadows,
    padding: padding ?? this.padding,
    maxWidth: maxWidth ?? this.maxWidth,
    handleColor: handleColor ?? this.handleColor,
    handleWidth: handleWidth ?? this.handleWidth,
    handleHeight: handleHeight ?? this.handleHeight,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxBottomSheetTheme merge(AstryxBottomSheetTheme? other) {
    if (other == null) return this;
    return AstryxBottomSheetTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      scrimColor: other.scrimColor ?? scrimColor,
      borderRadius: other.borderRadius ?? borderRadius,
      border: other.border ?? border,
      shadows: other.shadows ?? shadows,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
      handleColor: other.handleColor ?? handleColor,
      handleWidth: other.handleWidth ?? handleWidth,
      handleHeight: other.handleHeight ?? handleHeight,
    );
  }

  /// Linearly interpolates between two bottom sheet themes.
  static AstryxBottomSheetTheme? lerp(
    AstryxBottomSheetTheme? a,
    AstryxBottomSheetTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxBottomSheetTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      scrimColor: lerpColor(a?.scrimColor, b?.scrimColor, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      border: lerpBorderSide(a?.border, b?.border, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      maxWidth: lerpNullableDouble(a?.maxWidth, b?.maxWidth, t),
      handleColor: lerpColor(a?.handleColor, b?.handleColor, t),
      handleWidth: lerpNullableDouble(a?.handleWidth, b?.handleWidth, t),
      handleHeight: lerpNullableDouble(a?.handleHeight, b?.handleHeight, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxBottomSheetTheme &&
          other.backgroundColor == backgroundColor &&
          other.scrimColor == scrimColor &&
          other.borderRadius == borderRadius &&
          other.border == border &&
          deepEquals(other.shadows, shadows) &&
          other.padding == padding &&
          other.maxWidth == maxWidth &&
          other.handleColor == handleColor &&
          other.handleWidth == handleWidth &&
          other.handleHeight == handleHeight;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    scrimColor,
    borderRadius,
    border,
    deepHash(shadows),
    padding,
    maxWidth,
    handleColor,
    handleWidth,
    handleHeight,
  );
}
