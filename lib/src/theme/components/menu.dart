/// Visual configuration for menu surfaces.
library;

import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for menu surfaces: `AstryxDropdownMenu`,
/// `AstryxContextMenu` and their submenus.
///
/// The Material equivalent is `MenuThemeData` and `PopupMenuThemeData`
/// together: one class for the panel and the rows painted on it, because a
/// menu whose rows disagree with its panel is not a look anyone asks for.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // Squarer menus with roomier rows, everywhere.
/// const AstryxMenuTheme(
///   borderRadius: BorderRadius.all(Radius.circular(4)),
///   itemPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxMenuTheme {
  /// Creates a menu theme.
  const AstryxMenuTheme({
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.shadows,
    this.padding,
    this.itemPadding,
    this.itemBorderRadius,
    this.itemHighlightColor,
    this.itemTextStyle,
    this.iconColor,
    this.iconSize,
    this.dividerColor,
  });

  /// The panel fill. Defaults to `--color-background-popover`.
  final Color? backgroundColor;

  /// The panel's hairline border.
  ///
  /// Defaults to `--color-border` at `--border-width`. Use [BorderSide.none]
  /// to drop it.
  final BorderSide? border;

  /// The panel's corner radius. Defaults to `--radius-container`.
  final BorderRadiusGeometry? borderRadius;

  /// The panel's shadow. Defaults to `--shadow-low`.
  final List<AstryxShadow>? shadows;

  /// The space between the panel's edge and its rows.
  ///
  /// Defaults to `--spacing-1` on every side.
  final EdgeInsetsGeometry? padding;

  /// The padding inside each row.
  ///
  /// Defaults to `--spacing-2` inline and `--spacing-1-5` block.
  final EdgeInsetsGeometry? itemPadding;

  /// The corner radius of a highlighted row. Defaults to `--radius-inner`.
  final BorderRadiusGeometry? itemBorderRadius;

  /// The fill behind the highlighted row.
  ///
  /// Defaults to `--color-overlay-hover`.
  final Color? itemHighlightColor;

  /// The row label's text style, merged over the label type role.
  ///
  /// A colour here applies to enabled rows only: a disabled row keeps the
  /// disabled colour and a destructive row keeps the error colour, so the
  /// theme cannot make either look like an ordinary action.
  final TextStyle? itemTextStyle;

  /// The leading icon colour on an enabled, non-destructive row.
  ///
  /// Defaults to `--color-icon-secondary`.
  final Color? iconColor;

  /// The leading icon size. Defaults to the small icon size.
  final double? iconSize;

  /// The colour of an `AstryxMenuDivider`. Defaults to `--color-border`.
  final Color? dividerColor;

  /// Returns a copy with the given fields replaced.
  AstryxMenuTheme copyWith({
    Color? backgroundColor,
    BorderSide? border,
    BorderRadiusGeometry? borderRadius,
    List<AstryxShadow>? shadows,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? itemPadding,
    BorderRadiusGeometry? itemBorderRadius,
    Color? itemHighlightColor,
    TextStyle? itemTextStyle,
    Color? iconColor,
    double? iconSize,
    Color? dividerColor,
  }) => AstryxMenuTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    padding: padding ?? this.padding,
    itemPadding: itemPadding ?? this.itemPadding,
    itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
    itemHighlightColor: itemHighlightColor ?? this.itemHighlightColor,
    itemTextStyle: itemTextStyle ?? this.itemTextStyle,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    dividerColor: dividerColor ?? this.dividerColor,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxMenuTheme merge(AstryxMenuTheme? other) {
    if (other == null) return this;
    return AstryxMenuTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      padding: other.padding ?? padding,
      itemPadding: other.itemPadding ?? itemPadding,
      itemBorderRadius: other.itemBorderRadius ?? itemBorderRadius,
      itemHighlightColor: other.itemHighlightColor ?? itemHighlightColor,
      itemTextStyle:
          itemTextStyle?.merge(other.itemTextStyle) ?? other.itemTextStyle,
      iconColor: other.iconColor ?? iconColor,
      iconSize: other.iconSize ?? iconSize,
      dividerColor: other.dividerColor ?? dividerColor,
    );
  }

  /// Linearly interpolates between two menu themes.
  static AstryxMenuTheme? lerp(
    AstryxMenuTheme? a,
    AstryxMenuTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxMenuTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      border: lerpBorderSide(a?.border, b?.border, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      shadows: lerpShadows(a?.shadows, b?.shadows, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      itemPadding: lerpInsets(a?.itemPadding, b?.itemPadding, t),
      itemBorderRadius: lerpRadius(
        a?.itemBorderRadius,
        b?.itemBorderRadius,
        t,
      ),
      itemHighlightColor: lerpColor(
        a?.itemHighlightColor,
        b?.itemHighlightColor,
        t,
      ),
      itemTextStyle: lerpTextStyle(a?.itemTextStyle, b?.itemTextStyle, t),
      iconColor: lerpColor(a?.iconColor, b?.iconColor, t),
      iconSize: lerpNullableDouble(a?.iconSize, b?.iconSize, t),
      dividerColor: lerpColor(a?.dividerColor, b?.dividerColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxMenuTheme &&
          other.backgroundColor == backgroundColor &&
          other.border == border &&
          other.borderRadius == borderRadius &&
          deepEquals(other.shadows, shadows) &&
          other.padding == padding &&
          other.itemPadding == itemPadding &&
          other.itemBorderRadius == itemBorderRadius &&
          other.itemHighlightColor == itemHighlightColor &&
          other.itemTextStyle == itemTextStyle &&
          other.iconColor == iconColor &&
          other.iconSize == iconSize &&
          other.dividerColor == dividerColor;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    border,
    borderRadius,
    deepHash(shadows),
    padding,
    itemPadding,
    itemBorderRadius,
    itemHighlightColor,
    itemTextStyle,
    iconColor,
    iconSize,
    dividerColor,
  );
}
