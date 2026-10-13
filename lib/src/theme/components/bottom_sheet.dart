/// Visual configuration for AstryxBottomSheet.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBottomSheet`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxBottomSheetTheme {
  /// Creates a bottom sheet theme.
  const AstryxBottomSheetTheme();

  /// Returns a copy with the given fields replaced.
  AstryxBottomSheetTheme copyWith() => const AstryxBottomSheetTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxBottomSheetTheme merge(AstryxBottomSheetTheme? other) {
    if (other == null) return this;
    return const AstryxBottomSheetTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxBottomSheetTheme? lerp(AstryxBottomSheetTheme? a, AstryxBottomSheetTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxBottomSheetTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxBottomSheetTheme;

  @override
  int get hashCode => (AstryxBottomSheetTheme).hashCode;
}
