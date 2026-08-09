/// Token overrides for content rendered on an inverted surface.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/onMediaTokens.ts`.
///
/// "On dark" is content sitting on a dark background — light text,
/// white-tinted interactions. "On light" is the inverse.
///
/// Upstream's primary mechanism is CSS `color-scheme`: setting it on the media
/// element makes every `light-dark()` token resolve to its other half, so only
/// a small set of tokens need explicit overrides. `astryx_ui` has no CSS
/// cascade, so Layer 2 selects the opposing half directly — but the *set* of
/// explicit overrides, and the way theme-supplied ones merge over the defaults,
/// port unchanged.
library;

import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Which surface luminance an override set applies to.
enum AstryxSurface {
  /// Content on a dark background.
  dark,

  /// Content on a light background.
  light;

  /// The value of the `color-scheme` pseudo-token for this surface.
  String get colorScheme => name;
}

/// The key upstream uses for the CSS `color-scheme` declaration.
///
/// It is not a design token — it has no `--` prefix — but it travels in the
/// same map, so it is named here rather than left as a bare string.
const String astryxColorSchemeKey = 'color-scheme';

/// Theme-supplied overrides for one surface context.
///
/// The same shape as the main theme, scoped to a surface.
@immutable
class AstryxOnMediaOverrides {
  /// Creates a set of on-media overrides.
  const AstryxOnMediaOverrides({this.tokens, this.components});

  /// Token overrides for this surface context.
  final Map<String, AstryxTokenValue>? tokens;

  /// Component style overrides for this surface context.
  final AstryxComponentStyleMap? components;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxOnMediaOverrides &&
          const DeepCollectionEquality().equals(other.tokens, tokens) &&
          const DeepCollectionEquality().equals(other.components, components);

  @override
  int get hashCode => Object.hash(
    const DeepCollectionEquality().hash(tokens),
    const DeepCollectionEquality().hash(components),
  );

  @override
  String toString() =>
      'AstryxOnMediaOverrides(tokens: $tokens, components: $components)';
}

/// Resolved on-media overrides, as stored on a defined theme.
@immutable
class AstryxResolvedOnMedia {
  /// Creates a resolved on-media override set.
  const AstryxResolvedOnMedia({required this.tokens, this.components});

  /// Resolved token values, as CSS strings.
  final Map<String, String> tokens;

  /// Component style overrides, passed through from the input unchanged.
  final AstryxComponentStyleMap? components;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxResolvedOnMedia &&
          const DeepCollectionEquality().equals(other.tokens, tokens) &&
          const DeepCollectionEquality().equals(other.components, components);

  @override
  int get hashCode => Object.hash(
    const DeepCollectionEquality().hash(tokens),
    const DeepCollectionEquality().hash(components),
  );

  @override
  String toString() =>
      'AstryxResolvedOnMedia(tokens: $tokens, components: $components)';
}

/// Default token overrides for content on a dark surface.
///
/// Most tokens flip automatically with the colour scheme. These are the ones
/// that need a different value on an *inverted* surface than on a dark page
/// background: primary text and icons become the pure on-colour rather than
/// the dark-mode grey, and the accent collapses to the same on-colour.
const Map<String, String> astryxDefaultOnDarkTokens = <String, String>{
  astryxColorSchemeKey: 'dark',
  '--color-text-primary': 'var(--color-on-dark)',
  '--color-icon-primary': 'var(--color-on-dark)',
  '--color-accent': 'var(--color-on-dark)',
};

/// Default token overrides for content on a light surface.
const Map<String, String> astryxDefaultOnLightTokens = <String, String>{
  astryxColorSchemeKey: 'light',
  '--color-text-primary': 'var(--color-on-light)',
  '--color-icon-primary': 'var(--color-on-light)',
  '--color-accent': 'var(--color-on-light)',
};

/// Resolves the on-media overrides for [surface]: the defaults for that
/// surface, with any [input] tokens applied over them.
///
/// Component overrides pass through untouched.
AstryxResolvedOnMedia resolveOnMedia(
  AstryxSurface surface, [
  AstryxOnMediaOverrides? input,
]) {
  final defaults = surface == AstryxSurface.dark
      ? astryxDefaultOnDarkTokens
      : astryxDefaultOnLightTokens;

  final tokens = <String, String>{...defaults};

  final inputTokens = input?.tokens;
  if (inputTokens != null) {
    for (final entry in inputTokens.entries) {
      tokens[entry.key] = entry.value.css;
    }
  }

  return AstryxResolvedOnMedia(tokens: tokens, components: input?.components);
}
