/// Visual configuration for AstryxTable.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxTable`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxTableTheme {
  /// Creates a table theme.
  const AstryxTableTheme();

  /// Returns a copy with the given fields replaced.
  AstryxTableTheme copyWith() => const AstryxTableTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxTableTheme merge(AstryxTableTheme? other) {
    if (other == null) return this;
    return const AstryxTableTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxTableTheme? lerp(AstryxTableTheme? a, AstryxTableTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxTableTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxTableTheme;

  @override
  int get hashCode => (AstryxTableTheme).hashCode;
}
