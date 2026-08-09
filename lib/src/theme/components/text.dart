/// Visual configuration for text.
library;

import 'package:astryx_ui/src/theme/components/component_theme.dart';
import 'package:flutter/widgets.dart';

/// Visual configuration for `AstryxText` and `AstryxHeading`.
///
/// Every field is nullable; null means "fall through to the token default".
/// See `02-CONVENTIONS.md` §6.
///
/// {@tool snippet}
/// ```dart
/// // Tighten every heading in one place.
/// const AstryxTextTheme(style: TextStyle(letterSpacing: -0.2));
/// ```
/// {@end-tool}
@immutable
class AstryxTextTheme {
  /// Creates a text theme.
  const AstryxTextTheme({this.style, this.justify});

  /// Applied over the style the type role resolves to.
  ///
  /// Merged, not replaced — a theme that sets only `letterSpacing` keeps the
  /// size, weight and line height the scale computed.
  final TextStyle? style;

  /// The default alignment, when an instance does not set one.
  ///
  /// Typed as [TextAlign] rather than the widget's own enum so the theme layer
  /// does not depend on the component layer.
  final TextAlign? justify;

  /// Returns a copy with the given fields replaced.
  AstryxTextTheme copyWith({TextStyle? style, TextAlign? justify}) =>
      AstryxTextTheme(
        style: style ?? this.style,
        justify: justify ?? this.justify,
      );

  /// Returns a copy with every non-null field of [other] applied over this.
  AstryxTextTheme merge(AstryxTextTheme? other) {
    if (other == null) return this;
    return AstryxTextTheme(
      // Merged rather than replaced, so a per-instance theme setting one
      // property does not discard the app-level theme's others.
      style: style?.merge(other.style) ?? other.style,
      justify: other.justify ?? justify,
    );
  }

  /// Linearly interpolates between two text themes.
  static AstryxTextTheme? lerp(
    AstryxTextTheme? a,
    AstryxTextTheme? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return AstryxTextTheme(
      style: lerpTextStyle(a?.style, b?.style, t),
      justify: lerpDiscrete(a?.justify, b?.justify, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxTextTheme &&
          other.style == style &&
          other.justify == justify;

  @override
  int get hashCode => Object.hash(style, justify);
}
