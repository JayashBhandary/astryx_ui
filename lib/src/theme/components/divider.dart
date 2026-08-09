/// Visual configuration for the divider.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxDivider`.
@immutable
class AstryxDividerTheme {
  /// Creates a divider theme.
  const AstryxDividerTheme({
    this.color,
    this.emphasizedColor,
    this.thickness,
    this.labelGap,
  });

  /// The line colour for the subtle variant. Defaults to `--color-border`.
  final Color? color;

  /// The line colour for the strong variant.
  ///
  /// Defaults to `--color-border-emphasized`, the token the colour scale
  /// tone-bumps to clear WCAG 1.4.11.
  final Color? emphasizedColor;

  /// The line thickness. Defaults to `--border-width`.
  final double? thickness;

  /// The gap between a label and the lines either side of it.
  final double? labelGap;

  /// Returns a copy with the given fields replaced.
  AstryxDividerTheme copyWith({
    Color? color,
    Color? emphasizedColor,
    double? thickness,
    double? labelGap,
  }) => AstryxDividerTheme(
    color: color ?? this.color,
    emphasizedColor: emphasizedColor ?? this.emphasizedColor,
    thickness: thickness ?? this.thickness,
    labelGap: labelGap ?? this.labelGap,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxDividerTheme merge(AstryxDividerTheme? other) {
    if (other == null) return this;
    return AstryxDividerTheme(
      color: other.color ?? color,
      emphasizedColor: other.emphasizedColor ?? emphasizedColor,
      thickness: other.thickness ?? thickness,
      labelGap: other.labelGap ?? labelGap,
    );
  }

  /// Linearly interpolates between two divider themes.
  static AstryxDividerTheme? lerp(
    AstryxDividerTheme? a,
    AstryxDividerTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxDividerTheme(
      color: lerpColor(a?.color, b?.color, t),
      emphasizedColor: lerpColor(a?.emphasizedColor, b?.emphasizedColor, t),
      thickness: lerpNullableDouble(a?.thickness, b?.thickness, t),
      labelGap: lerpNullableDouble(a?.labelGap, b?.labelGap, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxDividerTheme &&
          other.color == color &&
          other.emphasizedColor == emphasizedColor &&
          other.thickness == thickness &&
          other.labelGap == labelGap;

  @override
  int get hashCode => Object.hash(color, emphasizedColor, thickness, labelGap);
}
