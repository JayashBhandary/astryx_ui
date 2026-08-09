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

/// Font family stacks.
///
/// 3 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxTypographyToken implements AstryxToken {
  /// The `--font-family-body` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  body('--font-family-body'),

  /// The `--font-family-code` token.
  ///
  /// Default: `"SF Mono", Monaco, Consolas, monospace`
  code('--font-family-code'),

  /// The `--font-family-heading` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  heading('--font-family-heading');

  const AstryxTypographyToken(this.cssName);

  @override
  final String cssName;
}
