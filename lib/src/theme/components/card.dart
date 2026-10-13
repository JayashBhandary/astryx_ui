/// Visual configuration for AstryxCard and AstryxSelectableCard.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxCard` and `AstryxSelectableCard`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxCardTheme {
  /// Creates a card theme.
  const AstryxCardTheme();

  /// Returns a copy with the given fields replaced.
  AstryxCardTheme copyWith() => const AstryxCardTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxCardTheme merge(AstryxCardTheme? other) {
    if (other == null) return this;
    return const AstryxCardTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxCardTheme? lerp(AstryxCardTheme? a, AstryxCardTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxCardTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxCardTheme;

  @override
  int get hashCode => (AstryxCardTheme).hashCode;
}
