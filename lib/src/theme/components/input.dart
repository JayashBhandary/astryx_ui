/// Visual configuration for text-entry controls.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for text-entry controls: `AstryxTextInput`, `AstryxNumberInput`, the `AstryxSelector` trigger and the other fields built on `AstryxInputContainer`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxInputTheme {
  /// Creates a input theme.
  const AstryxInputTheme();

  /// Returns a copy with the given fields replaced.
  AstryxInputTheme copyWith() => const AstryxInputTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxInputTheme merge(AstryxInputTheme? other) {
    if (other == null) return this;
    return const AstryxInputTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxInputTheme? lerp(AstryxInputTheme? a, AstryxInputTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxInputTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxInputTheme;

  @override
  int get hashCode => (AstryxInputTheme).hashCode;
}
