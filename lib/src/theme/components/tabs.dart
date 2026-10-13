/// Visual configuration for AstryxTabList.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTabList`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxTabsTheme {
  /// Creates a tabs theme.
  const AstryxTabsTheme();

  /// Returns a copy with the given fields replaced.
  AstryxTabsTheme copyWith() => const AstryxTabsTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxTabsTheme merge(AstryxTabsTheme? other) {
    if (other == null) return this;
    return const AstryxTabsTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxTabsTheme? lerp(AstryxTabsTheme? a, AstryxTabsTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxTabsTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxTabsTheme;

  @override
  int get hashCode => (AstryxTabsTheme).hashCode;
}
