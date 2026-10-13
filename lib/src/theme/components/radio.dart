/// Visual configuration for the radios in AstryxRadioList.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for the radios in `AstryxRadioList`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxRadioTheme {
  /// Creates a radio theme.
  const AstryxRadioTheme();

  /// Returns a copy with the given fields replaced.
  AstryxRadioTheme copyWith() => const AstryxRadioTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxRadioTheme merge(AstryxRadioTheme? other) {
    if (other == null) return this;
    return const AstryxRadioTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxRadioTheme? lerp(AstryxRadioTheme? a, AstryxRadioTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxRadioTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxRadioTheme;

  @override
  int get hashCode => (AstryxRadioTheme).hashCode;
}
