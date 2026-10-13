/// Visual configuration for AstryxCheckbox.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxCheckbox`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxCheckboxTheme {
  /// Creates a checkbox theme.
  const AstryxCheckboxTheme();

  /// Returns a copy with the given fields replaced.
  AstryxCheckboxTheme copyWith() => const AstryxCheckboxTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxCheckboxTheme merge(AstryxCheckboxTheme? other) {
    if (other == null) return this;
    return const AstryxCheckboxTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxCheckboxTheme? lerp(AstryxCheckboxTheme? a, AstryxCheckboxTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxCheckboxTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxCheckboxTheme;

  @override
  int get hashCode => (AstryxCheckboxTheme).hashCode;
}
