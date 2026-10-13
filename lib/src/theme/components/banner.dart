/// Visual configuration for AstryxBanner.
library;

import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxBanner`.
///
/// Every field is nullable; null means "fall through to the token default".
/// Resolution is: the widget's own `theme:`, then this theme from the
/// enclosing `AstryxThemeData`, then the tokens.
@immutable
class AstryxBannerTheme {
  /// Creates a banner theme.
  const AstryxBannerTheme();

  /// Returns a copy with the given fields replaced.
  AstryxBannerTheme copyWith() => const AstryxBannerTheme();

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxBannerTheme merge(AstryxBannerTheme? other) {
    if (other == null) return this;
    return const AstryxBannerTheme();
  }

  /// Linearly interpolates between two themes.
  static AstryxBannerTheme? lerp(AstryxBannerTheme? a, AstryxBannerTheme? b, double t) {
    if (a == null && b == null) return null;
    return const AstryxBannerTheme();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AstryxBannerTheme;

  @override
  int get hashCode => (AstryxBannerTheme).hashCode;
}
