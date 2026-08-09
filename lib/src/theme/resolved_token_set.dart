/// The output of the theme engine: every token, concrete, in both modes.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Every token name mapped to a concrete light value and a concrete dark value.
///
/// This is where Layer 1 hands off to Layer 2. Every `var()` reference has been
/// followed and every evaluable colour function evaluated, so the values here
/// are terminal strings — `'#0064E0'`, `'8px'`, `'175ms'` — not expressions.
/// Turning those strings into Flutter values is `AstryxThemeData`'s job, not
/// this class's.
///
/// Resolution is eager and happens once, in [AstryxResolvedTokenSet.resolve].
/// There is no cascade in Flutter to defer it to, and a theme is resolved far
/// less often than it is read.
///
/// Instances are immutable, hold two unmodifiable maps, and are cheap to
/// compare: [hashCode] is computed once during construction, so the common
/// `updateShouldNotify` path is an identity check followed at worst by an
/// integer comparison.
///
/// {@tool snippet}
/// ```dart
/// final tokens = AstryxResolvedTokenSet.resolve(myTheme);
///
/// tokens.value(AstryxColorToken.accent, AstryxThemeMode.light); // '#0064E0'
/// tokens.pair(AstryxSpacingToken.s4);                           // ('16px', '16px')
/// ```
/// {@end-tool}
@immutable
class AstryxResolvedTokenSet {
  /// Creates a token set from two already-resolved maps.
  ///
  /// Both maps must carry the same key set;
  /// [AstryxResolvedTokenSet.resolve] guarantees that. Prefer it unless you are
  /// reconstructing a set from a cache or a fixture.
  AstryxResolvedTokenSet({
    required Map<String, String> light,
    required Map<String, String> dark,
  }) : light = Map<String, String>.unmodifiable(light),
       dark = Map<String, String>.unmodifiable(dark),
       _hashCode = Object.hash(
         const MapEquality<String, String>().hash(light),
         const MapEquality<String, String>().hash(dark),
       ) {
    assert(
      const SetEquality<String>().equals(
        this.light.keys.toSet(),
        this.dark.keys.toSet(),
      ),
      'light and dark must resolve the same token names',
    );
  }

  /// Runs the engine over [theme] and captures both modes.
  ///
  /// A null [theme] resolves the Astryx defaults alone, which is what an
  /// unthemed app gets.
  factory AstryxResolvedTokenSet.resolve(AstryxDefinedTheme? theme) =>
      AstryxResolvedTokenSet(
        light: resolveThemeTokens(theme, AstryxThemeMode.light),
        dark: resolveThemeTokens(theme, AstryxThemeMode.dark),
      );

  /// The Astryx defaults, with no theme applied.
  ///
  /// Resolved on first use and reused thereafter — Dart initialises a static
  /// final lazily, the result is immutable, and resolving it is the same work
  /// every time.
  static final AstryxResolvedTokenSet defaults = AstryxResolvedTokenSet.resolve(
    null,
  );

  /// Every token's light-mode value, keyed by CSS custom property name.
  final Map<String, String> light;

  /// Every token's dark-mode value, keyed by CSS custom property name.
  final Map<String, String> dark;

  final int _hashCode;

  /// The token names in this set.
  ///
  /// Always the 184 core tokens, plus anything extra the theme defined — a
  /// syntax palette, say, which sits outside the core set.
  Iterable<String> get names => light.keys;

  /// The number of tokens in this set.
  int get length => light.length;

  /// The map for [mode].
  Map<String, String> forMode(AstryxThemeMode mode) =>
      mode == AstryxThemeMode.dark ? dark : light;

  /// The value of [token] in [mode].
  ///
  /// Throws an [ArgumentError] if the token is not in this set, which for one
  /// of the twelve token enums can only mean the set was built by hand and is
  /// incomplete. Use [maybeValue] where absence is expected.
  String value(AstryxToken token, AstryxThemeMode mode) =>
      valueOf(token.cssName, mode);

  /// The value of [token] in [mode], or null if it is not in this set.
  String? maybeValue(AstryxToken token, AstryxThemeMode mode) =>
      maybeValueOf(token.cssName, mode);

  /// The value of the token named [cssName] in [mode].
  ///
  /// Prefer [value]; this exists for the tokens outside the twelve enums —
  /// a theme's syntax palette, or a consumer's own namespaced tokens.
  String valueOf(String cssName, AstryxThemeMode mode) {
    final value = forMode(mode)[cssName];
    if (value == null) {
      throw ArgumentError.value(cssName, 'cssName', 'Not a resolved token');
    }
    return value;
  }

  /// The value of the token named [cssName] in [mode], or null if absent.
  String? maybeValueOf(String cssName, AstryxThemeMode mode) =>
      forMode(mode)[cssName];

  /// Both halves of [token], as a record.
  ///
  /// Useful where a consumer genuinely needs the pair rather than one mode —
  /// building a chart palette that ships with the document, for instance.
  (String light, String dark) pair(AstryxToken token) => pairOf(token.cssName);

  /// Both halves of the token named [cssName].
  (String light, String dark) pairOf(String cssName) => (
    valueOf(cssName, AstryxThemeMode.light),
    valueOf(cssName, AstryxThemeMode.dark),
  );

  /// Whether [cssName] is present in this set.
  bool contains(String cssName) => light.containsKey(cssName);

  /// Whether this set carries every one of the 184 core Astryx tokens.
  ///
  /// False only for a hand-built set. Anything from
  /// [AstryxResolvedTokenSet.resolve] is complete, because resolution seeds
  /// from the defaults before applying a theme.
  bool get isComplete => astryxTokenDefaults.keys.every(light.containsKey);

  /// Returns a copy with the given entries applied over one or both modes.
  ///
  /// The values are taken as already-resolved: no `var()` reference in them is
  /// followed and no colour function evaluated. This is a targeted patch for a
  /// caller that already holds concrete values — to re-run the engine, build a
  /// new theme and call [AstryxResolvedTokenSet.resolve].
  AstryxResolvedTokenSet copyWith({
    Map<String, String>? light,
    Map<String, String>? dark,
  }) {
    if (light == null && dark == null) return this;
    return AstryxResolvedTokenSet(
      light: <String, String>{...this.light, ...?light},
      dark: <String, String>{...this.dark, ...?dark},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AstryxResolvedTokenSet) return false;
    if (other._hashCode != _hashCode) return false;
    return const MapEquality<String, String>().equals(other.light, light) &&
        const MapEquality<String, String>().equals(other.dark, dark);
  }

  @override
  int get hashCode => _hashCode;

  @override
  String toString() => 'AstryxResolvedTokenSet($length tokens)';
}
