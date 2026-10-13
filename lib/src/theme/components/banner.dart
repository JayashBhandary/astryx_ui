/// Visual configuration for AstryxBanner.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBanner`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// There is deliberately no header fill here. The muted fill is what tells an
/// error banner from a success banner, and one theme-wide colour would erase
/// that. Shape, spacing, type and the detail panel are themeable.
///
/// {@tool snippet}
/// ```dart
/// // Tighter banners with a bolder title.
/// const AstryxBannerTheme(
///   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
///   titleStyle: TextStyle(fontWeight: FontWeight.w700),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxBannerTheme {
  /// Creates a banner theme.
  const AstryxBannerTheme({
    this.borderRadius,
    this.padding,
    this.contentPadding,
    this.gap,
    this.iconSize,
    this.titleStyle,
    this.descriptionStyle,
    this.contentBackgroundColor,
    this.contentBorder,
  });

  /// The corner radius. Defaults to `--radius-container`.
  ///
  /// With a content panel, the top corners go to the header and the bottom
  /// corners to the panel.
  final BorderRadiusGeometry? borderRadius;

  /// The padding of the coloured header.
  ///
  /// Defaults to `--spacing-3` vertically and `--spacing-4` horizontally.
  final EdgeInsetsGeometry? padding;

  /// The padding of the content panel below the header.
  ///
  /// Defaults to `--spacing-3` vertically and `--spacing-4` horizontally.
  final EdgeInsetsGeometry? contentPadding;

  /// The gap between the icon, the text, the actions and the dismiss button,
  /// and between the actions themselves. Defaults to `--spacing-2`.
  final double? gap;

  /// The status icon size. Defaults to the `sm` icon step.
  final double? iconSize;

  /// Applied over the title's resolved style.
  ///
  /// Merged, not replaced: the label type role stays unless this sets it.
  final TextStyle? titleStyle;

  /// Applied over the description's resolved style.
  ///
  /// Merged, not replaced: the supporting type role and secondary colour stay
  /// unless this sets them.
  final TextStyle? descriptionStyle;

  /// The fill of the content panel. Defaults to `--color-background-card`.
  final Color? contentBackgroundColor;

  /// The border on the content panel's sides and bottom.
  ///
  /// Defaults to `--color-border` at `--border-width`.
  final BorderSide? contentBorder;

  /// Returns a copy with the given fields replaced.
  AstryxBannerTheme copyWith({
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
    double? gap,
    double? iconSize,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Color? contentBackgroundColor,
    BorderSide? contentBorder,
  }) => AstryxBannerTheme(
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    contentPadding: contentPadding ?? this.contentPadding,
    gap: gap ?? this.gap,
    iconSize: iconSize ?? this.iconSize,
    titleStyle: titleStyle ?? this.titleStyle,
    descriptionStyle: descriptionStyle ?? this.descriptionStyle,
    contentBackgroundColor:
        contentBackgroundColor ?? this.contentBackgroundColor,
    contentBorder: contentBorder ?? this.contentBorder,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// The text styles merge rather than replace.
  AstryxBannerTheme merge(AstryxBannerTheme? other) {
    if (other == null) return this;
    return AstryxBannerTheme(
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      contentPadding: other.contentPadding ?? contentPadding,
      gap: other.gap ?? gap,
      iconSize: other.iconSize ?? iconSize,
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      descriptionStyle:
          descriptionStyle?.merge(other.descriptionStyle) ??
          other.descriptionStyle,
      contentBackgroundColor:
          other.contentBackgroundColor ?? contentBackgroundColor,
      contentBorder: other.contentBorder ?? contentBorder,
    );
  }

  /// Linearly interpolates between two banner themes.
  static AstryxBannerTheme? lerp(
    AstryxBannerTheme? a,
    AstryxBannerTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxBannerTheme(
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      padding: lerpInsets(a?.padding, b?.padding, t),
      contentPadding: lerpInsets(a?.contentPadding, b?.contentPadding, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      iconSize: lerpNullableDouble(a?.iconSize, b?.iconSize, t),
      titleStyle: lerpTextStyle(a?.titleStyle, b?.titleStyle, t),
      descriptionStyle: lerpTextStyle(
        a?.descriptionStyle,
        b?.descriptionStyle,
        t,
      ),
      contentBackgroundColor: lerpColor(
        a?.contentBackgroundColor,
        b?.contentBackgroundColor,
        t,
      ),
      contentBorder: lerpBorderSide(a?.contentBorder, b?.contentBorder, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxBannerTheme &&
          other.borderRadius == borderRadius &&
          other.padding == padding &&
          other.contentPadding == contentPadding &&
          other.gap == gap &&
          other.iconSize == iconSize &&
          other.titleStyle == titleStyle &&
          other.descriptionStyle == descriptionStyle &&
          other.contentBackgroundColor == contentBackgroundColor &&
          other.contentBorder == contentBorder;

  @override
  int get hashCode => Object.hash(
    borderRadius,
    padding,
    contentPadding,
    gap,
    iconSize,
    titleStyle,
    descriptionStyle,
    contentBackgroundColor,
    contentBorder,
  );
}
