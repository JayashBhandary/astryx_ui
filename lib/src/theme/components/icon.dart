/// Visual configuration for icons.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxIcon`.
@immutable
class AstryxIconTheme {
  /// Creates an icon theme.
  const AstryxIconTheme({this.color, this.size, this.opticalSizeAdjustment});

  /// The default colour, when an instance names no semantic colour.
  final Color? color;

  /// Overrides the resolved size, in logical pixels.
  final double? size;

  /// Added to the resolved size.
  ///
  /// For an icon set whose glyphs read optically smaller or larger than their
  /// box — Lucide's 24px grid with a 2px stroke sits slightly light next to
  /// 14px text, and a theme swapping in a heavier set may want to compensate.
  final double? opticalSizeAdjustment;

  /// Returns a copy with the given fields replaced.
  AstryxIconTheme copyWith({
    Color? color,
    double? size,
    double? opticalSizeAdjustment,
  }) => AstryxIconTheme(
    color: color ?? this.color,
    size: size ?? this.size,
    opticalSizeAdjustment: opticalSizeAdjustment ?? this.opticalSizeAdjustment,
  );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxIconTheme merge(AstryxIconTheme? other) {
    if (other == null) return this;
    return AstryxIconTheme(
      color: other.color ?? color,
      size: other.size ?? size,
      opticalSizeAdjustment:
          other.opticalSizeAdjustment ?? opticalSizeAdjustment,
    );
  }

  /// Linearly interpolates between two icon themes.
  static AstryxIconTheme? lerp(
    AstryxIconTheme? a,
    AstryxIconTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxIconTheme(
      color: lerpColor(a?.color, b?.color, t),
      size: lerpNullableDouble(a?.size, b?.size, t),
      opticalSizeAdjustment: lerpNullableDouble(
        a?.opticalSizeAdjustment,
        b?.opticalSizeAdjustment,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxIconTheme &&
          other.color == color &&
          other.size == size &&
          other.opticalSizeAdjustment == opticalSizeAdjustment;

  @override
  int get hashCode => Object.hash(color, size, opticalSizeAdjustment);
}
