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

/// Raw font sizes, in logical pixels.
///
/// 12 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxTextSizeToken implements AstryxToken {
  /// The `--font-size-4xs` token.
  ///
  /// Default: `0.375rem`
  fourXs('--font-size-4xs'),

  /// The `--font-size-3xs` token.
  ///
  /// Default: `0.4375rem`
  threeXs('--font-size-3xs'),

  /// The `--font-size-2xs` token.
  ///
  /// Default: `0.5rem`
  twoXs('--font-size-2xs'),

  /// The `--font-size-xs` token.
  ///
  /// Default: `0.625rem`
  xs('--font-size-xs'),

  /// The `--font-size-sm` token.
  ///
  /// Default: `0.75rem`
  sm('--font-size-sm'),

  /// The `--font-size-base` token.
  ///
  /// Default: `0.875rem`
  base('--font-size-base'),

  /// The `--font-size-lg` token.
  ///
  /// Default: `1.0625rem`
  lg('--font-size-lg'),

  /// The `--font-size-xl` token.
  ///
  /// Default: `1.25rem`
  xl('--font-size-xl'),

  /// The `--font-size-2xl` token.
  ///
  /// Default: `1.5rem`
  twoXl('--font-size-2xl'),

  /// The `--font-size-3xl` token.
  ///
  /// Default: `1.8125rem`
  threeXl('--font-size-3xl'),

  /// The `--font-size-4xl` token.
  ///
  /// Default: `2.1875rem`
  fourXl('--font-size-4xl'),

  /// The `--font-size-5xl` token.
  ///
  /// Default: `2.625rem`
  fiveXl('--font-size-5xl');

  const AstryxTextSizeToken(this.cssName);

  @override
  final String cssName;
}
