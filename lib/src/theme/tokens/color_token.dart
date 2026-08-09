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

/// Semantic colour tokens.
///
/// 79 tokens. [cssName] is the upstream CSS custom property and
/// is the join key against `dev/fixtures/tokens.json`.
enum AstryxColorToken implements AstryxToken {
  /// The `--color-accent` token.
  ///
  /// Default: `light-dark(#0064E0, #2694FE)`
  accent('--color-accent'),

  /// The `--color-accent-muted` token.
  ///
  /// Default: `light-dark(#0082FB33, #0082FB3F)`
  accentMuted('--color-accent-muted'),

  /// The `--color-on-accent` token.
  ///
  /// Default: `light-dark(#FFFFFF, #FFFFFF)`
  onAccent('--color-on-accent'),

  /// The `--color-neutral` token.
  ///
  /// Default: `light-dark(rgba(5, 54, 89, 0.1), rgba(223, 226, 229, 0.2))`
  neutral('--color-neutral'),

  /// The `--color-background-surface` token.
  ///
  /// Default: `light-dark(#FFFFFF, #1F1F22)`
  backgroundSurface('--color-background-surface'),

  /// The `--color-background-body` token.
  ///
  /// Default: `light-dark(#F1F4F7, #111112)`
  backgroundBody('--color-background-body'),

  /// The `--color-overlay` token.
  ///
  /// Default: `light-dark(#01122866, #11111299)`
  overlay('--color-overlay'),

  /// The `--color-overlay-hover` token.
  ///
  /// Default: `light-dark(#0536590C, #FFFFFF0C)`
  overlayHover('--color-overlay-hover'),

  /// The `--color-overlay-pressed` token.
  ///
  /// Default: `light-dark(#05365919, #FFFFFF19)`
  overlayPressed('--color-overlay-pressed'),

  /// The `--color-background-muted` token.
  ///
  /// Default: `light-dark(#0536590C, #1111127F)`
  backgroundMuted('--color-background-muted'),

  /// The `--color-text-primary` token.
  ///
  /// Default: `light-dark(#0A1317, #DFE2E5)`
  textPrimary('--color-text-primary'),

  /// The `--color-text-secondary` token.
  ///
  /// Default: `light-dark(#4E606F, #AAAFB5)`
  textSecondary('--color-text-secondary'),

  /// The `--color-text-disabled` token.
  ///
  /// Default: `light-dark(#A4B0BC, #6F747C)`
  textDisabled('--color-text-disabled'),

  /// The `--color-text-accent` token.
  ///
  /// Default: `light-dark(#0064E0, #3E9EFB)`
  textAccent('--color-text-accent'),

  /// The `--color-on-dark` token.
  ///
  /// Default: `light-dark(#FFFFFF, #FFFFFF)`
  onDark('--color-on-dark'),

  /// The `--color-on-light` token.
  ///
  /// Default: `light-dark(#000000, #000000)`
  onLight('--color-on-light'),

  /// The `--color-icon-accent` token.
  ///
  /// Default: `light-dark(#0064E0, #2694FE)`
  iconAccent('--color-icon-accent'),

  /// The `--color-icon-primary` token.
  ///
  /// Default: `light-dark(#0A1317, #DFE2E5)`
  iconPrimary('--color-icon-primary'),

  /// The `--color-icon-secondary` token.
  ///
  /// Default: `light-dark(#4E606F, #AAAFB5)`
  iconSecondary('--color-icon-secondary'),

  /// The `--color-icon-disabled` token.
  ///
  /// Default: `light-dark(#A4B0BC, #6F747C)`
  iconDisabled('--color-icon-disabled'),

  /// The `--color-background-card` token.
  ///
  /// Default: `light-dark(#FFFFFF, #1F1F22)`
  backgroundCard('--color-background-card'),

  /// The `--color-background-popover` token.
  ///
  /// Default: `light-dark(#FFFFFF, #28292C)`
  backgroundPopover('--color-background-popover'),

  /// The `--color-background-inverted` token.
  ///
  /// Default: `light-dark(#0A1317, #FFFFFF)`
  backgroundInverted('--color-background-inverted'),

  /// The `--color-background-error-inverted` token.
  ///
  /// Default: `light-dark(#AA071E, #E3193B)`
  backgroundErrorInverted('--color-background-error-inverted'),

  /// The `--color-success` token.
  ///
  /// Default: `light-dark(#0D8626, #0D8626)`
  success('--color-success'),

  /// The `--color-success-muted` token.
  ///
  /// Default: `light-dark(#0B991F33, #0B991F3F)`
  successMuted('--color-success-muted'),

  /// The `--color-on-success` token.
  ///
  /// Default: `light-dark(#FFFFFF, #FFFFFF)`
  onSuccess('--color-on-success'),

  /// The `--color-error` token.
  ///
  /// Default: `light-dark(#E3193B, #F5394F)`
  error('--color-error'),

  /// The `--color-error-muted` token.
  ///
  /// Default: `light-dark(#E3193B33, #F5394F3F)`
  errorMuted('--color-error-muted'),

  /// The `--color-on-error` token.
  ///
  /// Default: `light-dark(#FFFFFF, #FFFFFF)`
  onError('--color-on-error'),

  /// The `--color-warning` token.
  ///
  /// Default: `light-dark(#E9AF08, #F2C00B)`
  warning('--color-warning'),

  /// The `--color-warning-muted` token.
  ///
  /// Default: `light-dark(#E2A40033, #E2A4003F)`
  warningMuted('--color-warning-muted'),

  /// The `--color-on-warning` token.
  ///
  /// Default: `light-dark(#0A1317, #0A1317)`
  onWarning('--color-on-warning'),

  /// The `--color-border` token.
  ///
  /// Default: `light-dark(#05365919, #F2F4F619)`
  border('--color-border'),

  /// The `--color-border-emphasized` token.
  ///
  /// Default: `light-dark(#CCD3DB, #494D53)`
  borderEmphasized('--color-border-emphasized'),

  /// The `--color-skeleton` token.
  ///
  /// Default: `light-dark(#CCD3DB, #5A5E66)`
  skeleton('--color-skeleton'),

  /// The `--color-track` token.
  ///
  /// Default: `light-dark(#CCD3DB, #5A5E66)`
  track('--color-track'),

  /// The `--color-shadow` token.
  ///
  /// Default: `light-dark(rgba(5, 54, 89, 0.1), rgba(0, 0, 0, 0.3))`
  shadow('--color-shadow'),

  /// The `--color-tint-hover` token.
  ///
  /// Default: `light-dark(black, white)`
  tintHover('--color-tint-hover'),

  /// The `--color-background-blue` token.
  ///
  /// Default: `light-dark(#0171E333, #0171E333)`
  backgroundBlue('--color-background-blue'),

  /// The `--color-border-blue` token.
  ///
  /// Default: `light-dark(#0064E0, #2694FE)`
  borderBlue('--color-border-blue'),

  /// The `--color-icon-blue` token.
  ///
  /// Default: `light-dark(#0064E0, #2694FE)`
  iconBlue('--color-icon-blue'),

  /// The `--color-text-blue` token.
  ///
  /// Default: `light-dark(#042F97, #AFD7FF)`
  textBlue('--color-text-blue'),

  /// The `--color-background-cyan` token.
  ///
  /// Default: `light-dark(#03A7D733, #03A7D733)`
  backgroundCyan('--color-background-cyan'),

  /// The `--color-border-cyan` token.
  ///
  /// Default: `light-dark(#089DD0, #0171A4)`
  borderCyan('--color-border-cyan'),

  /// The `--color-icon-cyan` token.
  ///
  /// Default: `light-dark(#00ACC1, #26C6DA)`
  iconCyan('--color-icon-cyan'),

  /// The `--color-text-cyan` token.
  ///
  /// Default: `light-dark(#014975, #A1EEF9)`
  textCyan('--color-text-cyan'),

  /// The `--color-background-gray` token.
  ///
  /// Default: `light-dark(#0A131733, #666A724C)`
  backgroundGray('--color-background-gray'),

  /// The `--color-border-gray` token.
  ///
  /// Default: `light-dark(#647685, #748695)`
  borderGray('--color-border-gray'),

  /// The `--color-icon-gray` token.
  ///
  /// Default: `light-dark(#4E606F, #AAAFB5)`
  iconGray('--color-icon-gray'),

  /// The `--color-text-gray` token.
  ///
  /// Default: `light-dark(#0A1317, #E7EAED)`
  textGray('--color-text-gray'),

  /// The `--color-background-green` token.
  ///
  /// Default: `light-dark(#24BB5E33, #24BB5E33)`
  backgroundGreen('--color-background-green'),

  /// The `--color-border-green` token.
  ///
  /// Default: `light-dark(#0D8626, #0B991F)`
  borderGreen('--color-border-green'),

  /// The `--color-icon-green` token.
  ///
  /// Default: `light-dark(#0D8626, #26A756)`
  iconGreen('--color-icon-green'),

  /// The `--color-text-green` token.
  ///
  /// Default: `light-dark(#09441F, #A5F690)`
  textGreen('--color-text-green'),

  /// The `--color-background-orange` token.
  ///
  /// Default: `light-dark(#F2790233, #F2790233)`
  backgroundOrange('--color-background-orange'),

  /// The `--color-border-orange` token.
  ///
  /// Default: `light-dark(#EB6E00, #B34A01)`
  borderOrange('--color-border-orange'),

  /// The `--color-icon-orange` token.
  ///
  /// Default: `light-dark(#E9690B, #FB8C00)`
  iconOrange('--color-icon-orange'),

  /// The `--color-text-orange` token.
  ///
  /// Default: `light-dark(#6B2203, #FDB876)`
  textOrange('--color-text-orange'),

  /// The `--color-background-pink` token.
  ///
  /// Default: `light-dark(#E638B333, #E638B333)`
  backgroundPink('--color-background-pink'),

  /// The `--color-border-pink` token.
  ///
  /// Default: `light-dark(#F351C0, #C02294)`
  borderPink('--color-border-pink'),

  /// The `--color-icon-pink` token.
  ///
  /// Default: `light-dark(#C2185B, #EC407A)`
  iconPink('--color-icon-pink'),

  /// The `--color-text-pink` token.
  ///
  /// Default: `light-dark(#650053, #FEADE3)`
  textPink('--color-text-pink'),

  /// The `--color-background-purple` token.
  ///
  /// Default: `light-dark(#7952FF33, #7952FF33)`
  backgroundPurple('--color-background-purple'),

  /// The `--color-border-purple` token.
  ///
  /// Default: `light-dark(#9081FF, #7340FE)`
  borderPurple('--color-border-purple'),

  /// The `--color-icon-purple` token.
  ///
  /// Default: `light-dark(#5B08D8, #7952FF)`
  iconPurple('--color-icon-purple'),

  /// The `--color-text-purple` token.
  ///
  /// Default: `light-dark(#3E0697, #B3B0FE)`
  textPurple('--color-text-purple'),

  /// The `--color-background-red` token.
  ///
  /// Default: `light-dark(#E3193B33, #E3193B33)`
  backgroundRed('--color-background-red'),

  /// The `--color-border-red` token.
  ///
  /// Default: `light-dark(#E3193B, #F5394F)`
  borderRed('--color-border-red'),

  /// The `--color-icon-red` token.
  ///
  /// Default: `light-dark(#D31130, #E3193B)`
  iconRed('--color-icon-red'),

  /// The `--color-text-red` token.
  ///
  /// Default: `light-dark(#7B0210, #FFB2B8)`
  textRed('--color-text-red'),

  /// The `--color-background-teal` token.
  ///
  /// Default: `light-dark(#0DB7AF33, #0DB7AF33)`
  backgroundTeal('--color-background-teal'),

  /// The `--color-border-teal` token.
  ///
  /// Default: `light-dark(#08A3A3, #08767D)`
  borderTeal('--color-border-teal'),

  /// The `--color-icon-teal` token.
  ///
  /// Default: `light-dark(#009688, #26A69A)`
  iconTeal('--color-icon-teal'),

  /// The `--color-text-teal` token.
  ///
  /// Default: `light-dark(#083943, #40DCCD)`
  textTeal('--color-text-teal'),

  /// The `--color-background-yellow` token.
  ///
  /// Default: `light-dark(#E2A40033, #E2A40033)`
  backgroundYellow('--color-background-yellow'),

  /// The `--color-border-yellow` token.
  ///
  /// Default: `light-dark(#C58600, #B47700)`
  borderYellow('--color-border-yellow'),

  /// The `--color-icon-yellow` token.
  ///
  /// Default: `light-dark(#FBC02D, #FFEE58)`
  iconYellow('--color-icon-yellow'),

  /// The `--color-text-yellow` token.
  ///
  /// Default: `light-dark(#753F07, #FBCE03)`
  textYellow('--color-text-yellow');

  const AstryxColorToken(this.cssName);

  @override
  final String cssName;
}
