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

/// Corner radii, in logical pixels.
///
/// 7 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxRadiusToken implements AstryxToken {
  /// The `--radius-none` token.
  ///
  /// Default: `0px`
  none('--radius-none'),

  /// The `--radius-inner` token.
  ///
  /// Default: `4px`
  inner('--radius-inner'),

  /// The `--radius-element` token.
  ///
  /// Default: `8px`
  element('--radius-element'),

  /// The `--radius-container` token.
  ///
  /// Default: `12px`
  container('--radius-container'),

  /// The `--radius-page` token.
  ///
  /// Default: `28px`
  page('--radius-page'),

  /// The `--radius-chat` token.
  ///
  /// Default: `28px`
  chat('--radius-chat'),

  /// The `--radius-full` token.
  ///
  /// Default: `9999px`
  full('--radius-full');

  const AstryxRadiusToken(this.cssName);

  @override
  final String cssName;
}
