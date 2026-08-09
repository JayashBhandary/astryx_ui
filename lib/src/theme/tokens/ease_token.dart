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

/// Animation easing curves, as CSS cubic-bezier expressions.
///
/// 1 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxEaseToken implements AstryxToken {
  /// The `--ease-standard` token.
  ///
  /// Default: `cubic-bezier(0.24, 1, 0.4, 1)`
  standard('--ease-standard');

  const AstryxEaseToken(this.cssName);

  @override
  final String cssName;
}
