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

/// Elevation shadows. Values are compound CSS box-shadow strings.
///
/// 8 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxShadowToken implements AstryxToken {
  /// The `--shadow-low` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  low('--shadow-low'),

  /// The `--shadow-med` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  med('--shadow-med'),

  /// The `--shadow-high` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  high('--shadow-high'),

  /// The `--shadow-inset-hover` token.
  ///
  /// Its default is a compound value; see `astryxTokenDefaults`.
  insetHover('--shadow-inset-hover'),

  /// The `--shadow-inset-selected` token.
  ///
  /// Default: `inset 0px 0px 0px 2px rgba(1, 113, 227, 0.5)`
  insetSelected('--shadow-inset-selected'),

  /// The `--shadow-inset-success` token.
  ///
  /// Default: `inset 0px 0px 0px 2px rgba(38, 167, 86, 0.3)`
  insetSuccess('--shadow-inset-success'),

  /// The `--shadow-inset-warning` token.
  ///
  /// Default: `inset 0px 0px 0px 2px rgba(226, 164, 0, 0.3)`
  insetWarning('--shadow-inset-warning'),

  /// The `--shadow-inset-error` token.
  ///
  /// Default: `inset 0px 0px 0px 2px rgba(227, 25, 59, 0.3)`
  insetError('--shadow-inset-error');

  const AstryxShadowToken(this.cssName);

  @override
  final String cssName;
}
