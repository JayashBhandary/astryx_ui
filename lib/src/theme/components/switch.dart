/// Visual configuration for AstryxSwitch.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxSwitch`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxSwitchTheme {
  /// Creates a switch theme.
  const AstryxSwitchTheme();

  /// Returns a copy with the given fields replaced.
  AstryxSwitchTheme copyWith() => const AstryxSwitchTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxSwitchTheme merge(AstryxSwitchTheme? other) {
    if (other == null) return this;
    return const AstryxSwitchTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxSwitchTheme? lerp(AstryxSwitchTheme? a, AstryxSwitchTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxSwitchTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxSwitchTheme;

  @override
  int get hashCode => (AstryxSwitchTheme).hashCode;
}
