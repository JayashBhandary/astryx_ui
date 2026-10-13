/// Visual configuration for AstryxTabList.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTabList`.
///
/// The Material equivalent is `TabBarTheme`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// {@tool snippet}
/// ```dart
/// // A thicker, brand-coloured indicator on every tab strip.
/// const AstryxTabsTheme(
///   indicatorColor: Color(0xFF7C3AED),
///   indicatorThickness: 3,
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxTabsTheme {
  /// Creates a tabs theme.
  const AstryxTabsTheme({
    this.labelStyle,
    this.selectedLabelStyle,
    this.labelColor,
    this.selectedLabelColor,
    this.disabledLabelColor,
    this.indicatorColor,
    this.indicatorThickness,
    this.tabPadding,
    this.gap,
    this.height,
    this.hoverBackgroundColor,
    this.borderRadius,
    this.dividerColor,
    this.dividerThickness,
  });

  /// The label's text style, merged over the `label` type role.
  ///
  /// Its colour is ignored — the label colours below set that, per state. Its
  /// weight applies to unselected tabs and defaults to
  /// `--font-weight-normal`.
  final TextStyle? labelStyle;

  /// Merged over [labelStyle] for the selected tab.
  ///
  /// Its colour is ignored, as for [labelStyle]. Its weight defaults to
  /// `--font-weight-semibold`.
  final TextStyle? selectedLabelStyle;

  /// The label and icon colour of an unselected, enabled tab.
  ///
  /// Defaults to `--color-text-secondary`.
  final Color? labelColor;

  /// The label and icon colour of the selected tab.
  ///
  /// Defaults to `--color-text-primary`.
  final Color? selectedLabelColor;

  /// The label and icon colour of a disabled tab.
  ///
  /// Defaults to `--color-text-disabled`.
  final Color? disabledLabelColor;

  /// The selected tab's indicator colour. Defaults to `--color-accent`.
  final Color? indicatorColor;

  /// The selected tab's indicator thickness. Defaults to 2.
  final double? indicatorThickness;

  /// The padding around a tab's label, icon and badge.
  ///
  /// Defaults to `--spacing-3` either side, or `--spacing-1` at the end of a
  /// closable tab, which spends its trailing gutter on the close button.
  final EdgeInsetsGeometry? tabPadding;

  /// The gap between adjacent tabs. Defaults to `--spacing-0-5`.
  final double? gap;

  /// The strip's height, overriding the size's own.
  final double? height;

  /// The background of a tab under the pointer.
  ///
  /// Defaults to `--color-overlay-hover`. Never applied in touch density —
  /// see `AstryxDensity.supportsHover`.
  final Color? hoverBackgroundColor;

  /// The corner radius of a tab's hover background and focus ring.
  ///
  /// Defaults to `--radius-element`.
  final BorderRadiusGeometry? borderRadius;

  /// The colour of the rule under the strip. Defaults to `--color-border`.
  final Color? dividerColor;

  /// The thickness of the rule under the strip.
  ///
  /// Defaults to `--border-width`.
  final double? dividerThickness;

  /// Returns a copy with the given fields replaced.
  AstryxTabsTheme copyWith({
    TextStyle? labelStyle,
    TextStyle? selectedLabelStyle,
    Color? labelColor,
    Color? selectedLabelColor,
    Color? disabledLabelColor,
    Color? indicatorColor,
    double? indicatorThickness,
    EdgeInsetsGeometry? tabPadding,
    double? gap,
    double? height,
    Color? hoverBackgroundColor,
    BorderRadiusGeometry? borderRadius,
    Color? dividerColor,
    double? dividerThickness,
  }) => AstryxTabsTheme(
    labelStyle: labelStyle ?? this.labelStyle,
    selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
    labelColor: labelColor ?? this.labelColor,
    selectedLabelColor: selectedLabelColor ?? this.selectedLabelColor,
    disabledLabelColor: disabledLabelColor ?? this.disabledLabelColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorThickness: indicatorThickness ?? this.indicatorThickness,
    tabPadding: tabPadding ?? this.tabPadding,
    gap: gap ?? this.gap,
    height: height ?? this.height,
    hoverBackgroundColor: hoverBackgroundColor ?? this.hoverBackgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    dividerColor: dividerColor ?? this.dividerColor,
    dividerThickness: dividerThickness ?? this.dividerThickness,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// The text styles merge rather than replace, so an outer theme's font
  /// family survives an inner theme that only changes the size.
  AstryxTabsTheme merge(AstryxTabsTheme? other) {
    if (other == null) return this;
    return AstryxTabsTheme(
      labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      selectedLabelStyle:
          selectedLabelStyle?.merge(other.selectedLabelStyle) ??
          other.selectedLabelStyle,
      labelColor: other.labelColor ?? labelColor,
      selectedLabelColor: other.selectedLabelColor ?? selectedLabelColor,
      disabledLabelColor: other.disabledLabelColor ?? disabledLabelColor,
      indicatorColor: other.indicatorColor ?? indicatorColor,
      indicatorThickness: other.indicatorThickness ?? indicatorThickness,
      tabPadding: other.tabPadding ?? tabPadding,
      gap: other.gap ?? gap,
      height: other.height ?? height,
      hoverBackgroundColor: other.hoverBackgroundColor ?? hoverBackgroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      dividerColor: other.dividerColor ?? dividerColor,
      dividerThickness: other.dividerThickness ?? dividerThickness,
    );
  }

  /// Linearly interpolates between two tabs themes.
  static AstryxTabsTheme? lerp(
    AstryxTabsTheme? a,
    AstryxTabsTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxTabsTheme(
      labelStyle: lerpTextStyle(a?.labelStyle, b?.labelStyle, t),
      selectedLabelStyle: lerpTextStyle(
        a?.selectedLabelStyle,
        b?.selectedLabelStyle,
        t,
      ),
      labelColor: lerpColor(a?.labelColor, b?.labelColor, t),
      selectedLabelColor: lerpColor(
        a?.selectedLabelColor,
        b?.selectedLabelColor,
        t,
      ),
      disabledLabelColor: lerpColor(
        a?.disabledLabelColor,
        b?.disabledLabelColor,
        t,
      ),
      indicatorColor: lerpColor(a?.indicatorColor, b?.indicatorColor, t),
      indicatorThickness: lerpNullableDouble(
        a?.indicatorThickness,
        b?.indicatorThickness,
        t,
      ),
      tabPadding: lerpInsets(a?.tabPadding, b?.tabPadding, t),
      gap: lerpNullableDouble(a?.gap, b?.gap, t),
      height: lerpNullableDouble(a?.height, b?.height, t),
      hoverBackgroundColor: lerpColor(
        a?.hoverBackgroundColor,
        b?.hoverBackgroundColor,
        t,
      ),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      dividerColor: lerpColor(a?.dividerColor, b?.dividerColor, t),
      dividerThickness: lerpNullableDouble(
        a?.dividerThickness,
        b?.dividerThickness,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTabsTheme &&
          other.labelStyle == labelStyle &&
          other.selectedLabelStyle == selectedLabelStyle &&
          other.labelColor == labelColor &&
          other.selectedLabelColor == selectedLabelColor &&
          other.disabledLabelColor == disabledLabelColor &&
          other.indicatorColor == indicatorColor &&
          other.indicatorThickness == indicatorThickness &&
          other.tabPadding == tabPadding &&
          other.gap == gap &&
          other.height == height &&
          other.hoverBackgroundColor == hoverBackgroundColor &&
          other.borderRadius == borderRadius &&
          other.dividerColor == dividerColor &&
          other.dividerThickness == dividerThickness;

  @override
  int get hashCode => Object.hash(
    labelStyle,
    selectedLabelStyle,
    labelColor,
    selectedLabelColor,
    disabledLabelColor,
    indicatorColor,
    indicatorThickness,
    tabPadding,
    gap,
    height,
    hoverBackgroundColor,
    borderRadius,
    dividerColor,
    dividerThickness,
  );
}
