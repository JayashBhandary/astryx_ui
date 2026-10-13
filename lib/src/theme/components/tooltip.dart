/// Visual configuration for AstryxTooltip.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTooltip`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxTooltipTheme {
  /// Creates a tooltip theme.
  const AstryxTooltipTheme();

  /// Returns a copy with the given fields replaced.
  AstryxTooltipTheme copyWith() => const AstryxTooltipTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxTooltipTheme merge(AstryxTooltipTheme? other) {
    if (other == null) return this;
    return const AstryxTooltipTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxTooltipTheme? lerp(AstryxTooltipTheme? a, AstryxTooltipTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxTooltipTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxTooltipTheme;

  @override
  int get hashCode => (AstryxTooltipTheme).hashCode;
}
