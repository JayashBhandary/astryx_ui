/// Visual configuration for AstryxTable.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTable`.
///
/// The Material equivalent is `DataTableThemeData`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
///
/// Row states are discrete named fields, as for `AstryxButtonTheme`: a
/// consumer recolouring the selection should not have to restate the hover.
///
/// {@tool snippet}
/// ```dart
/// // A tinted header and roomier cells on every table.
/// const AstryxTableTheme(
///   headerBackgroundColor: Color(0xFFF4F4F5),
///   cellPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxTableTheme {
  /// Creates a table theme.
  const AstryxTableTheme({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.cellTextStyle,
    this.cellPadding,
    this.headerMinHeight,
    this.rowMinHeight,
    this.stripeColor,
    this.hoverRowColor,
    this.selectedRowColor,
    this.dividerColor,
    this.dividerThickness,
  });

  /// The table's background. Defaults to `--color-background-card`.
  final Color? backgroundColor;

  /// The colour of the outline around the table.
  ///
  /// Defaults to `--color-border`.
  final Color? borderColor;

  /// The width of the outline around the table.
  ///
  /// Defaults to `--border-width`.
  final double? borderWidth;

  /// The table's corner radius, which also clips its content.
  ///
  /// Defaults to `--radius-container`.
  final BorderRadiusGeometry? borderRadius;

  /// The pinned header's background.
  ///
  /// Defaults to `--color-background-card`.
  final Color? headerBackgroundColor;

  /// Merged over the header's default style: the `label` type role in
  /// `--color-text-secondary` at `--font-weight-semibold`.
  final TextStyle? headerTextStyle;

  /// Merged over the body cells' default text style, the `body` type role.
  ///
  /// Applies through `DefaultTextStyle`, so a cell that sets its own style
  /// keeps it.
  final TextStyle? cellTextStyle;

  /// The padding inside every header and body cell.
  ///
  /// Defaults to the table's `AstryxTableDensity` spacing, so setting this
  /// fixes the padding regardless of density.
  final EdgeInsetsGeometry? cellPadding;

  /// A floor under the header's height. Defaults to its content's height.
  final double? headerMinHeight;

  /// A floor under every body row's height. Defaults to its content's height.
  final double? rowMinHeight;

  /// The background of alternate rows when the table is striped.
  ///
  /// Defaults to `--color-background-muted`.
  final Color? stripeColor;

  /// The background of a row under the pointer.
  ///
  /// Defaults to `--color-overlay-hover`. Never applied in touch density —
  /// see `AstryxDensity.supportsHover`.
  final Color? hoverRowColor;

  /// The background of a selected row. Defaults to `--color-accent-muted`.
  final Color? selectedRowColor;

  /// The colour of the rules under the header and between rows.
  ///
  /// Defaults to `--color-border`.
  final Color? dividerColor;

  /// The thickness of the rules under the header and between rows.
  ///
  /// Defaults to `--border-width`.
  final double? dividerThickness;

  /// Returns a copy with the given fields replaced.
  AstryxTableTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    Color? headerBackgroundColor,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
    EdgeInsetsGeometry? cellPadding,
    double? headerMinHeight,
    double? rowMinHeight,
    Color? stripeColor,
    Color? hoverRowColor,
    Color? selectedRowColor,
    Color? dividerColor,
    double? dividerThickness,
  }) => AstryxTableTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderWidth: borderWidth ?? this.borderWidth,
    borderRadius: borderRadius ?? this.borderRadius,
    headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    cellTextStyle: cellTextStyle ?? this.cellTextStyle,
    cellPadding: cellPadding ?? this.cellPadding,
    headerMinHeight: headerMinHeight ?? this.headerMinHeight,
    rowMinHeight: rowMinHeight ?? this.rowMinHeight,
    stripeColor: stripeColor ?? this.stripeColor,
    hoverRowColor: hoverRowColor ?? this.hoverRowColor,
    selectedRowColor: selectedRowColor ?? this.selectedRowColor,
    dividerColor: dividerColor ?? this.dividerColor,
    dividerThickness: dividerThickness ?? this.dividerThickness,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  ///
  /// The text styles merge rather than replace, so an outer theme's font
  /// family survives an inner theme that only changes the size.
  AstryxTableTheme merge(AstryxTableTheme? other) {
    if (other == null) return this;
    return AstryxTableTheme(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderWidth: other.borderWidth ?? borderWidth,
      borderRadius: other.borderRadius ?? borderRadius,
      headerBackgroundColor:
          other.headerBackgroundColor ?? headerBackgroundColor,
      headerTextStyle:
          headerTextStyle?.merge(other.headerTextStyle) ??
          other.headerTextStyle,
      cellTextStyle:
          cellTextStyle?.merge(other.cellTextStyle) ?? other.cellTextStyle,
      cellPadding: other.cellPadding ?? cellPadding,
      headerMinHeight: other.headerMinHeight ?? headerMinHeight,
      rowMinHeight: other.rowMinHeight ?? rowMinHeight,
      stripeColor: other.stripeColor ?? stripeColor,
      hoverRowColor: other.hoverRowColor ?? hoverRowColor,
      selectedRowColor: other.selectedRowColor ?? selectedRowColor,
      dividerColor: other.dividerColor ?? dividerColor,
      dividerThickness: other.dividerThickness ?? dividerThickness,
    );
  }

  /// Linearly interpolates between two table themes.
  static AstryxTableTheme? lerp(
    AstryxTableTheme? a,
    AstryxTableTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxTableTheme(
      backgroundColor: lerpColor(a?.backgroundColor, b?.backgroundColor, t),
      borderColor: lerpColor(a?.borderColor, b?.borderColor, t),
      borderWidth: lerpNullableDouble(a?.borderWidth, b?.borderWidth, t),
      borderRadius: lerpRadius(a?.borderRadius, b?.borderRadius, t),
      headerBackgroundColor: lerpColor(
        a?.headerBackgroundColor,
        b?.headerBackgroundColor,
        t,
      ),
      headerTextStyle: lerpTextStyle(
        a?.headerTextStyle,
        b?.headerTextStyle,
        t,
      ),
      cellTextStyle: lerpTextStyle(a?.cellTextStyle, b?.cellTextStyle, t),
      cellPadding: lerpInsets(a?.cellPadding, b?.cellPadding, t),
      headerMinHeight: lerpNullableDouble(
        a?.headerMinHeight,
        b?.headerMinHeight,
        t,
      ),
      rowMinHeight: lerpNullableDouble(a?.rowMinHeight, b?.rowMinHeight, t),
      stripeColor: lerpColor(a?.stripeColor, b?.stripeColor, t),
      hoverRowColor: lerpColor(a?.hoverRowColor, b?.hoverRowColor, t),
      selectedRowColor: lerpColor(a?.selectedRowColor, b?.selectedRowColor, t),
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
      other is AstryxTableTheme &&
          other.backgroundColor == backgroundColor &&
          other.borderColor == borderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.headerBackgroundColor == headerBackgroundColor &&
          other.headerTextStyle == headerTextStyle &&
          other.cellTextStyle == cellTextStyle &&
          other.cellPadding == cellPadding &&
          other.headerMinHeight == headerMinHeight &&
          other.rowMinHeight == rowMinHeight &&
          other.stripeColor == stripeColor &&
          other.hoverRowColor == hoverRowColor &&
          other.selectedRowColor == selectedRowColor &&
          other.dividerColor == dividerColor &&
          other.dividerThickness == dividerThickness;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderColor,
    borderWidth,
    borderRadius,
    headerBackgroundColor,
    headerTextStyle,
    cellTextStyle,
    cellPadding,
    headerMinHeight,
    rowMinHeight,
    stripeColor,
    hoverRowColor,
    selectedRowColor,
    dividerColor,
    dividerThickness,
  );
}
