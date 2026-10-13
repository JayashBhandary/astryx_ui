/// Visual configuration for AstryxDialog and AstryxAlertDialog.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxDialog` and `AstryxAlertDialog`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxDialogTheme {
  /// Creates a dialog theme.
  const AstryxDialogTheme();

  /// Returns a copy with the given fields replaced.
  AstryxDialogTheme copyWith() => const AstryxDialogTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxDialogTheme merge(AstryxDialogTheme? other) {
    if (other == null) return this;
    return const AstryxDialogTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxDialogTheme? lerp(AstryxDialogTheme? a, AstryxDialogTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxDialogTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxDialogTheme;

  @override
  int get hashCode => (AstryxDialogTheme).hashCode;
}
