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

/// Semantic type-scale tokens. Each role has a `-size`, `-weight` and
/// `-leading` token; Phase 3 composes them into a `TextStyle`.
///
/// 42 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxTypeToken implements AstryxToken {
  /// The `--text-heading-1-size` token.
  ///
  /// Default: `var(--font-size-2xl)`
  heading1Size('--text-heading-1-size'),

  /// The `--text-heading-1-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading1Weight('--text-heading-1-weight'),

  /// The `--text-heading-1-leading` token.
  ///
  /// Default: `1.3333`
  heading1Leading('--text-heading-1-leading'),

  /// The `--text-heading-2-size` token.
  ///
  /// Default: `var(--font-size-xl)`
  heading2Size('--text-heading-2-size'),

  /// The `--text-heading-2-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading2Weight('--text-heading-2-weight'),

  /// The `--text-heading-2-leading` token.
  ///
  /// Default: `1.4`
  heading2Leading('--text-heading-2-leading'),

  /// The `--text-heading-3-size` token.
  ///
  /// Default: `var(--font-size-lg)`
  heading3Size('--text-heading-3-size'),

  /// The `--text-heading-3-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading3Weight('--text-heading-3-weight'),

  /// The `--text-heading-3-leading` token.
  ///
  /// Default: `1.4118`
  heading3Leading('--text-heading-3-leading'),

  /// The `--text-heading-4-size` token.
  ///
  /// Default: `var(--font-size-base)`
  heading4Size('--text-heading-4-size'),

  /// The `--text-heading-4-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading4Weight('--text-heading-4-weight'),

  /// The `--text-heading-4-leading` token.
  ///
  /// Default: `1.4286`
  heading4Leading('--text-heading-4-leading'),

  /// The `--text-heading-5-size` token.
  ///
  /// Default: `var(--font-size-sm)`
  heading5Size('--text-heading-5-size'),

  /// The `--text-heading-5-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading5Weight('--text-heading-5-weight'),

  /// The `--text-heading-5-leading` token.
  ///
  /// Default: `1.6667`
  heading5Leading('--text-heading-5-leading'),

  /// The `--text-heading-6-size` token.
  ///
  /// Default: `var(--font-size-xs)`
  heading6Size('--text-heading-6-size'),

  /// The `--text-heading-6-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  heading6Weight('--text-heading-6-weight'),

  /// The `--text-heading-6-leading` token.
  ///
  /// Default: `1.6`
  heading6Leading('--text-heading-6-leading'),

  /// The `--text-body-size` token.
  ///
  /// Default: `var(--font-size-base)`
  bodySize('--text-body-size'),

  /// The `--text-body-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  bodyWeight('--text-body-weight'),

  /// The `--text-body-leading` token.
  ///
  /// Default: `1.4286`
  bodyLeading('--text-body-leading'),

  /// The `--text-large-size` token.
  ///
  /// Default: `var(--font-size-lg)`
  largeSize('--text-large-size'),

  /// The `--text-large-weight` token.
  ///
  /// Default: `var(--font-weight-semibold)`
  largeWeight('--text-large-weight'),

  /// The `--text-large-leading` token.
  ///
  /// Default: `1.4118`
  largeLeading('--text-large-leading'),

  /// The `--text-label-size` token.
  ///
  /// Default: `var(--font-size-base)`
  labelSize('--text-label-size'),

  /// The `--text-label-weight` token.
  ///
  /// Default: `var(--font-weight-medium)`
  labelWeight('--text-label-weight'),

  /// The `--text-label-leading` token.
  ///
  /// Default: `1.4286`
  labelLeading('--text-label-leading'),

  /// The `--text-code-size` token.
  ///
  /// Default: `var(--font-size-base)`
  codeSize('--text-code-size'),

  /// The `--text-code-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  codeWeight('--text-code-weight'),

  /// The `--text-code-leading` token.
  ///
  /// Default: `1.4286`
  codeLeading('--text-code-leading'),

  /// The `--text-supporting-size` token.
  ///
  /// Default: `var(--font-size-sm)`
  supportingSize('--text-supporting-size'),

  /// The `--text-supporting-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  supportingWeight('--text-supporting-weight'),

  /// The `--text-supporting-leading` token.
  ///
  /// Default: `1.6667`
  supportingLeading('--text-supporting-leading'),

  /// The `--text-display-1-size` token.
  ///
  /// Default: `var(--font-size-5xl)`
  display1Size('--text-display-1-size'),

  /// The `--text-display-1-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  display1Weight('--text-display-1-weight'),

  /// The `--text-display-1-leading` token.
  ///
  /// Default: `1.2381`
  display1Leading('--text-display-1-leading'),

  /// The `--text-display-2-size` token.
  ///
  /// Default: `var(--font-size-4xl)`
  display2Size('--text-display-2-size'),

  /// The `--text-display-2-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  display2Weight('--text-display-2-weight'),

  /// The `--text-display-2-leading` token.
  ///
  /// Default: `1.2571`
  display2Leading('--text-display-2-leading'),

  /// The `--text-display-3-size` token.
  ///
  /// Default: `var(--font-size-3xl)`
  display3Size('--text-display-3-size'),

  /// The `--text-display-3-weight` token.
  ///
  /// Default: `var(--font-weight-normal)`
  display3Weight('--text-display-3-weight'),

  /// The `--text-display-3-leading` token.
  ///
  /// Default: `1.2414`
  display3Leading('--text-display-3-leading');

  const AstryxTypeToken(this.cssName);

  @override
  final String cssName;
}
