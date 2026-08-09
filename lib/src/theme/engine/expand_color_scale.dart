/// Colour token generation from a single seed accent, via HCT.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/expandColorScale.ts`.
///
/// Only tokens that meaningfully *derive* from the accent are generated. Status
/// colours, categorical hues and the fixed `--color-on-dark` and
/// `--color-on-light` pair are convention-bound, so they are left out and fall
/// through to the token defaults.
///
/// ## Contrast guarantees
///
/// Text tones clear WCAG 1.4.3 (4.5:1) by tone spacing alone: HCT tone is CIE
/// L*, which fixes relative luminance regardless of hue or chroma, so the fixed
/// tone assignments hold for any accent and any neutral style.
///
/// `--color-border-emphasized` outlines form controls, making it a non-text
/// boundary under WCAG 1.4.11, and its preferred tones land near 2.2:1. It is
/// tone-bumped by [ensureContrastTone] until it reaches 3:1.
///
/// `--color-border`, `--color-skeleton` and `--color-track` are deliberately
/// decorative or redundant cues and are *not* held to 3:1.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/engine/contrast.dart';
import 'package:astryx_ui/src/theme/engine/hct.dart';
import 'package:meta/meta.dart';

/// How much of the seed hue bleeds into neutral and background colours.
enum AstryxNeutralStyle {
  /// The most hue bleed — chroma 7 for neutrals, 10 for the variant ramp.
  warm(7, 10),

  /// Upstream's default — chroma 5 for neutrals, 8 for the variant ramp.
  cool(5, 8),

  /// The least hue bleed — chroma 3 for neutrals, 6 for the variant ramp.
  neutral(3, 6);

  const AstryxNeutralStyle(this.chroma, this.variantChroma);

  /// The chroma of the neutral ramp.
  final double chroma;

  /// The chroma of the neutral-variant ramp, used for secondary text, disabled
  /// text, skeletons and tracks.
  final double variantChroma;
}

/// The contrast level applied to text and UI tone assignments.
enum AstryxContrastLevel {
  /// Upstream's default. Primary text at tone 10 (light) and 90 (dark).
  standard,

  /// Pushes text tones to the extremes — 0 and 99 for primary text.
  high,
}

/// Configuration for the colour scale.
///
/// {@tool snippet}
/// ```dart
/// // Minimal — just a seed colour.
/// const AstryxColorScaleConfig(accent: '#0064E0');
///
/// // Neutral-only: keeps the default accent, themes the neutrals.
/// const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm);
/// ```
/// {@end-tool}
@immutable
class AstryxColorScaleConfig {
  /// Creates a colour scale configuration.
  const AstryxColorScaleConfig({
    this.accent,
    this.neutralStyle = AstryxNeutralStyle.cool,
    this.contrast = AstryxContrastLevel.standard,
  });

  /// The seed accent colour as `#RRGGBB`. Everything derives from this.
  ///
  /// When null, the neutral palettes are seeded from the default accent's hue
  /// and the three accent tokens are *not* generated — they keep their token
  /// default values rather than this seed's derivation. Defaulting the seed
  /// instead of omitting the tokens would recolour every neutral-only theme.
  final String? accent;

  /// Neutral tone warmth.
  final AstryxNeutralStyle neutralStyle;

  /// Contrast level for text and UI tone assignments.
  final AstryxContrastLevel contrast;

  /// Returns a copy with the given fields replaced.
  AstryxColorScaleConfig copyWith({
    String? accent,
    AstryxNeutralStyle? neutralStyle,
    AstryxContrastLevel? contrast,
  }) => AstryxColorScaleConfig(
    accent: accent ?? this.accent,
    neutralStyle: neutralStyle ?? this.neutralStyle,
    contrast: contrast ?? this.contrast,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxColorScaleConfig &&
          other.accent == accent &&
          other.neutralStyle == neutralStyle &&
          other.contrast == contrast;

  @override
  int get hashCode => Object.hash(accent, neutralStyle, contrast);

  @override
  String toString() =>
      'AstryxColorScaleConfig(accent: $accent, neutralStyle: $neutralStyle, '
      'contrast: $contrast)';
}

/// The hue source for accent-less configurations — the light half of the
/// default `--color-accent`.
///
/// Only its hue reaches the output. A test guards the two against drift.
const String astryxDefaultAccentSeed = '#0064E0';

/// The WCAG 1.4.11 minimum contrast for non-text UI boundaries.
const double astryxNonTextMinContrast = 3;

String _ld(String light, String dark) => 'light-dark($light, $dark)';

String _accentWithAlpha(double alpha) =>
    'color-mix(in srgb, var(--color-accent) '
    '${formatNumber(alpha * 100)}%, transparent)';

/// Walks tone in [step] increments from [startTone] until the colour reaches
/// [minRatio] against [background], and returns the resulting hex.
///
/// Used for tokens whose preferred tone is not guaranteed by tone spacing
/// alone, such as `--color-border-emphasized`. Because HCT tone is CIE L*,
/// each step moves luminance monotonically, so the loop always terminates — at
/// worst at pure black or white, which is 21:1 against anything mid-range.
///
/// [step] is `1` or `-1`.
String ensureContrastTone(
  double hue,
  double chroma,
  double startTone,
  int step,
  String background,
  double minRatio,
) {
  var tone = startTone;
  var hex = hctToHex(AstryxHct(hue: hue, chroma: chroma, tone: tone));
  while (contrastRatio(hex, background) < minRatio &&
      tone + step >= 0 &&
      tone + step <= 100) {
    tone += step;
    hex = hctToHex(AstryxHct(hue: hue, chroma: chroma, tone: tone));
  }
  return hex;
}

/// Expands [config] into colour token overrides, keyed by CSS custom property
/// name.
///
/// {@tool snippet}
/// ```dart
/// final tokens = expandColorScale(
///   const AstryxColorScaleConfig(accent: '#0064E0'),
/// );
/// // tokens['--color-accent'] == 'light-dark(#…, #…)'
///
/// final neutralOnly = expandColorScale(
///   const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm),
/// );
/// // neutralOnly['--color-accent'] == null
/// ```
/// {@end-tool}
Map<String, String> expandColorScale(AstryxColorScaleConfig config) {
  final accent = config.accent;

  final seed = hexToHct(accent ?? astryxDefaultAccentSeed);
  final seedHue = seed.hue;

  final primaryChroma = math.max<double>(seed.chroma, 48);
  final neutralChroma = config.neutralStyle.chroma;
  final neutralVariantChroma = config.neutralStyle.variantChroma;

  final palette = tonalPalette(seedHue, primaryChroma);
  final neutrals = tonalPalette(seedHue, neutralChroma);
  final variants = tonalPalette(seedHue, neutralVariantChroma);

  String p(int tone) => palette[tone]!;
  String n(int tone) => neutrals[tone]!;
  String nv(int tone) => variants[tone]!;

  final isHigh = config.contrast == AstryxContrastLevel.high;

  final textPrimaryLightTone = isHigh ? 0 : 10;
  final textPrimaryDarkTone = isHigh ? 99 : 90;
  final textSecondaryLightTone = isHigh ? 20 : 30;
  final textSecondaryDarkTone = isHigh ? 80 : 70;

  // Emphasized borders outline form controls, so they are non-text UI
  // boundaries under WCAG 1.4.11 and must reach 3:1 against the surface they
  // sit on. The preferred tones — 70 light, 30 dark — land around 2.2:1 and
  // 1.8:1, so bump the tone toward the opposing extreme until the ratio
  // passes. Text tones need no such loop; their spacing already guarantees
  // 4.5:1 for any hue and chroma.
  final borderEmphasized = _ld(
    ensureContrastTone(
      seedHue,
      neutralVariantChroma,
      70,
      -1,
      n(99),
      astryxNonTextMinContrast,
    ),
    ensureContrastTone(
      seedHue,
      neutralVariantChroma,
      30,
      1,
      n(10),
      astryxNonTextMinContrast,
    ),
  );

  return <String, String>{
    // Core semantic — generated only with a seed accent.
    if (accent != null) ...<String, String>{
      '--color-accent': _ld(p(40), p(80)),
      // The derived accent tokens reference `--color-accent` rather than
      // baking its resolved hex, so a scoped override of the base token
      // re-accents the whole subtree at runtime. `--color-on-accent` stays
      // baked: it is a contrast computation against the accent, which CSS
      // cannot express.
      '--color-accent-muted': _ld(
        _accentWithAlpha(0.2),
        _accentWithAlpha(0.25),
      ),
      '--color-on-accent': _ld(p(100), p(20)),
    },
    '--color-neutral': _ld(
      hexWithAlpha(n(10), 0.1),
      hexWithAlpha(n(90), 0.2),
    ),
    '--color-background-surface': _ld(n(99), n(10)),
    '--color-background-body': _ld(n(95), n(5)),
    '--color-overlay': _ld(hexWithAlpha(n(10), 0.4), hexWithAlpha(n(10), 0.6)),
    '--color-overlay-hover': _ld(
      hexWithAlpha(n(10), 0.05),
      hexWithAlpha(n(100), 0.05),
    ),
    '--color-overlay-pressed': _ld(
      hexWithAlpha(n(10), 0.1),
      hexWithAlpha(n(100), 0.1),
    ),
    '--color-background-muted': _ld(
      hexWithAlpha(n(10), 0.05),
      hexWithAlpha(n(10), 0.5),
    ),

    // Text
    '--color-text-primary': _ld(
      n(textPrimaryLightTone),
      n(textPrimaryDarkTone),
    ),
    '--color-text-secondary': _ld(
      nv(textSecondaryLightTone),
      nv(textSecondaryDarkTone),
    ),
    '--color-text-disabled': _ld(nv(60), nv(40)),
    '--color-text-accent': 'var(--color-accent)',

    // Icon
    '--color-icon-accent': 'var(--color-accent)',
    '--color-icon-primary': _ld(
      n(textPrimaryLightTone),
      n(textPrimaryDarkTone),
    ),
    '--color-icon-secondary': _ld(
      nv(textSecondaryLightTone),
      nv(textSecondaryDarkTone),
    ),
    '--color-icon-disabled': _ld(nv(60), nv(40)),

    // Surface variants
    '--color-background-card': _ld(n(99), n(10)),
    '--color-background-popover': _ld(n(99), n(20)),
    '--color-background-inverted': _ld(n(10), n(99)),

    // Border. The hairline is decorative — roughly 1.1:1 by design — and is
    // not a WCAG 1.4.11 boundary.
    '--color-border': _ld(hexWithAlpha(n(10), 0.1), hexWithAlpha(n(95), 0.1)),
    '--color-border-emphasized': borderEmphasized,

    // Effects
    '--color-skeleton': _ld(nv(70), nv(30)),
    // Channel-on-body surface — progress and slider tracks, switch off-state.
    // Defaults to the same ramp stop as `--color-skeleton`.
    '--color-track': _ld(nv(70), nv(30)),
    '--color-shadow': _ld(hexWithAlpha(n(0), 0.1), hexWithAlpha(n(0), 0.3)),
    '--color-tint-hover': _ld('black', 'white'),
  };
}
