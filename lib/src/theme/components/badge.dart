/// Visual configuration for AstryxBadge.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBadge`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxBadgeTheme {
  /// Creates a badge theme.
  const AstryxBadgeTheme();

  /// Returns a copy with the given fields replaced.
  AstryxBadgeTheme copyWith() => const AstryxBadgeTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxBadgeTheme merge(AstryxBadgeTheme? other) {
    if (other == null) return this;
    return const AstryxBadgeTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxBadgeTheme? lerp(AstryxBadgeTheme? a, AstryxBadgeTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxBadgeTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxBadgeTheme;

  @override
  int get hashCode => (AstryxBadgeTheme).hashCode;
}
