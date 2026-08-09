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

/// Font weights.
///
/// 4 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxFontWeightToken implements AstryxToken {
  /// The `--font-weight-normal` token.
  ///
  /// Default: `400`
  normal('--font-weight-normal'),

  /// The `--font-weight-medium` token.
  ///
  /// Default: `500`
  medium('--font-weight-medium'),

  /// The `--font-weight-semibold` token.
  ///
  /// Default: `600`
  semibold('--font-weight-semibold'),

  /// The `--font-weight-bold` token.
  ///
  /// Default: `700`
  bold('--font-weight-bold');

  const AstryxFontWeightToken(this.cssName);

  @override
  final String cssName;
}
