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

/// Interactive element heights, in logical pixels.
///
/// 3 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxSizeToken implements AstryxToken {
  /// The `--size-element-sm` token.
  ///
  /// Default: `28px`
  elementSm('--size-element-sm'),

  /// The `--size-element-md` token.
  ///
  /// Default: `32px`
  elementMd('--size-element-md'),

  /// The `--size-element-lg` token.
  ///
  /// Default: `36px`
  elementLg('--size-element-lg');

  const AstryxSizeToken(this.cssName);

  @override
  final String cssName;
}
