/// Visual configuration for toasts.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for toasts.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxToastTheme {
  /// Creates a toast theme.
  const AstryxToastTheme();

  /// Returns a copy with the given fields replaced.
  AstryxToastTheme copyWith() => const AstryxToastTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxToastTheme merge(AstryxToastTheme? other) {
    if (other == null) return this;
    return const AstryxToastTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxToastTheme? lerp(AstryxToastTheme? a, AstryxToastTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxToastTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxToastTheme;

  @override
  int get hashCode => (AstryxToastTheme).hashCode;
}
