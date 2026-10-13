/// Visual configuration for menu surfaces.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for menu surfaces: `AstryxDropdownMenu`, `AstryxContextMenu` and selector popups.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxMenuTheme {
  /// Creates a menu theme.
  const AstryxMenuTheme();

  /// Returns a copy with the given fields replaced.
  AstryxMenuTheme copyWith() => const AstryxMenuTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxMenuTheme merge(AstryxMenuTheme? other) {
    if (other == null) return this;
    return const AstryxMenuTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxMenuTheme? lerp(AstryxMenuTheme? a, AstryxMenuTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxMenuTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxMenuTheme;

  @override
  int get hashCode => (AstryxMenuTheme).hashCode;
}
