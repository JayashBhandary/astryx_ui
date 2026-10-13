/// Visual configuration for AstryxBadge.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBadge`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// There is deliberately no fill or foreground colour here. A badge's colour
/// *is* its variant — sentiment or category — and one theme-wide colour would
/// make every variant look the same. Shape, spacing and type are what a theme
/// can change without erasing that meaning.
///
/// {@tool snippet}
/// ```dart
/// // Square-cornered badges with a little more room.
/// const AstryxBadgeTheme(
///   borderRadius: BorderRadius.all(Radius.circular(4)),
///   padding: EdgeInsets.symmetric(horizontal: 10),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxBadgeTheme {
  /// Creates a badge theme.
  const AstryxBadgeTheme({
    this.borderRadius,
    this.border,
    this.padding,
    this.minHeight,
    this.gap,
    this.textStyle,
    this.iconSize,
  });

  /// The corner radius. Defaults to `--radius-full`, a pill.
  final BorderRadiusGeometry? borderRadius;

  /// An outline. Defaults to none.
  final BorderSide? border;

  /// The inner padding. Defaults to `--spacing-2` either side.
  final EdgeInsetsGeometry? padding;

  /// The minimum height. Defaults to `--spacing-5`.
  final double? minHeight;

  /// The gap between the icon and the label. Defaults to `--spacing-1`.
  final double? gap;

  /// Applied over the label's resolved style.
  ///
  /// Merged, not replaced: the supporting type role and the variant's
  /// foreground colour stay unless this sets them. Setting a colour here
  /// overrides every variant's foreground.
  final TextStyle? textStyle;

  /// The icon size. Defaults to the `xsm` icon step.
  final double? iconSize;

  /// Returns a copy with the given fields replaced.
  AstryxBadgeTheme copyWith({
    BorderRadiusGeometry? borderRadius,
    BorderSide? border,
    EdgeInsetsGeometry? padding,
    double? minHeight,
    double? gap,
    TextStyle? textStyle,
    double? iconSize,
  }) => AstryxBadgeTheme(
    borderRadius: borderRadius ?? this.borderRadius,
    border: border ?? this.border,
    padding: padding ?? this.padding,
    minHeight: minHeight ?? this.minHeight,
    gap: gap ?? this.gap,
    textStyle: textStyle ?? this.textStyle,
    iconSize: iconSize ?? this.iconSize,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// [textStyle] merges rather than replaces.
  AstryxBadgeTheme merge(AstryxBadgeTheme? other) {
    if (other == null) return this;
    return AstryxBadgeTheme(
      borderRadius: other.borderRadius ?? borderRadius,
      border: other.border ?? border,
      padding: other.padding ?? padding,
      minHeight: other.minHeight ?? minHeight,
      gap: other.gap ?? gap,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      iconSize: other.iconSize ?? iconSize,
    );
  }

  /// Linearly interpolates between two badge themes.
  static AstryxBadgeTheme? lerp(
    AstryxBadgeTheme? a,
    AstryxBadgeTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxBadgeTheme(
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      border: lerpBorderSide(a?.border, b?.border, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      minHeight: lerpNullableDouble(a?.minHeight, b?.minHeight, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      textStyle: lerpTextStyle(a?.textStyle, b?.textStyle, t),
      iconSize: lerpNullableDouble(a?.iconSize, b?.iconSize, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxBadgeTheme &&
          other.borderRadius == borderRadius &&
          other.border == border &&
          other.padding == padding &&
          other.minHeight == minHeight &&
          other.gap == gap &&
          other.textStyle == textStyle &&
          other.iconSize == iconSize;

  @override
  int get hashCode => Object.hash(
    borderRadius,
    border,
    padding,
    minHeight,
    gap,
    textStyle,
    iconSize,
  );
}
