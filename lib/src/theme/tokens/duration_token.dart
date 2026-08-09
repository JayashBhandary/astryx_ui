// GENERATED FILE — DO NOT EDIT BY HAND.
//
// Source:    astryx-0.3.0/packages/core/src/theme/tokens.stylex.ts
// Generator: dev/tools/generate-dart-tokens.mjs
//
// Regenerate with:
//   node dev/tools/extract-tokens.mjs
//   node dev/tools/generate-dart-tokens.mjs
//   dart format astryx_ui/lib/src/theme/tokens

import 'package:astryx_ui/src/theme/tokens/token.dart';

/// Animation durations.
///
/// 9 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxDurationToken implements AstryxToken {
  /// The `--duration-fast-min` token.
  ///
  /// Default: `130ms`
  fastMin('--duration-fast-min'),

  /// The `--duration-fast` token.
  ///
  /// Default: `175ms`
  fast('--duration-fast'),

  /// The `--duration-fast-max` token.
  ///
  /// Default: `230ms`
  fastMax('--duration-fast-max'),

  /// The `--duration-medium-min` token.
  ///
  /// Default: `310ms`
  mediumMin('--duration-medium-min'),

  /// The `--duration-medium` token.
  ///
  /// Default: `410ms`
  medium('--duration-medium'),

  /// The `--duration-medium-max` token.
  ///
  /// Default: `550ms`
  mediumMax('--duration-medium-max'),

  /// The `--duration-slow-min` token.
  ///
  /// Default: `730ms`
  slowMin('--duration-slow-min'),

  /// The `--duration-slow` token.
  ///
  /// Default: `975ms`
  slow('--duration-slow'),

  /// The `--duration-slow-max` token.
  ///
  /// Default: `1300ms`
  slowMax('--duration-slow-max');

  const AstryxDurationToken(this.cssName);

  @override
  final String cssName;
}
