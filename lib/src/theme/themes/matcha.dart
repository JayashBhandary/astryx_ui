// GENERATED FILE — DO NOT EDIT BY HAND.
//
// Source:    astryx-0.3.0/packages/themes/<name>/src/<name>Theme.ts
//            captured as a defineTheme input in dev/fixtures/engine/themes.json
// Generator: dev/tools/generate-dart-themes.mjs
//
// Regenerate with:
//   node dev/tools/mirror-upstream.mjs
//   node dev/tools/dump-engine-fixtures.mjs themes
//   node dev/tools/generate-dart-themes.mjs
//   dart format astryx_ui/lib/src/theme/themes

// Font fallback stacks are reproduced verbatim from upstream. Reflowing them
// would change the token values the parity tests compare against.
// ignore_for_file: lines_longer_than_80_chars

/// The Astryx `matcha` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `matcha` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: matchaTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput matchaThemeInput = AstryxDefineThemeInput(
  name: 'matcha',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 16, ratio: 1.25),
    body: AstryxTypographyRole(
      family: 'DM Sans',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Playwrite US Trad',
      fallbacks: 'Georgia, "Times New Roman", Times, serif',
    ),
    code: AstryxTypographyRole(
      family: 'JetBrains Mono',
      fallbacks: '"SF Mono", Monaco, Consolas, monospace',
    ),
  ),
  motion: AstryxMotionScaleConfig(
    fast: 125,
    medium: 300,
    slow: 700,
    ratio: 0.75,
  ),
  syntax: AstryxSyntaxTheme(
    name: 'xds-matcha',
    tokens: <String, String>{
      'keyword': 'light-dark(#5a6b2a, #a8bf6a)',
      'string': 'light-dark(#2e6b4a, #7bc49e)',
      'comment': 'light-dark(#707E46, #707E46)',
      'number': 'light-dark(#8c6b30, #d4b870)',
      'function': 'light-dark(#3a5e8c, #7ba8d4)',
      'type': 'light-dark(#6b4a8c, #b08ed4)',
      'variable': 'light-dark(#3E481D, #C0CBA9)',
      'operator': 'light-dark(#707E46, #94a468)',
      'constant': 'light-dark(#8c6b30, #d4b870)',
      'tag': 'light-dark(#8c3a3a, #d47a7a)',
      'attribute': 'light-dark(#7c5e3a, #c4a882)',
      'property': 'light-dark(#3a7c6b, #70c4b0)',
      'punctuation': 'light-dark(#707E46, #5a6440)',
      'background': 'light-dark(#F0F0E0, #1a1c14)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#3E481D14',
      '#C0CBA920',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#3E481D0F', '#C0CBA91A'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#1a1c14',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#F0F0E0', '#12140e'),
    '--color-overlay': AstryxTokenValue.lightDark('#3E481D80', '#3E481DCC'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#3E481D0D',
      '#C0CBA90D',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#3E481D1A',
      '#C0CBA91A',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#F0F0E0',
      '#3E481D',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#707E46', '#94a468'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#C0CBA9', '#5a6440'),
    '--color-text-accent': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-on-dark': AstryxTokenValue('#FFFFFF'),
    '--color-on-light': AstryxTokenValue('#3E481D'),
    '--color-on-accent': AstryxTokenValue.lightDark('#FFFFFF', '#3E481D'),
    '--color-on-success': AstryxTokenValue.lightDark('#FFFFFF', '#3E481D'),
    '--color-on-error': AstryxTokenValue.lightDark('#FFFFFF', '#3E481D'),
    '--color-on-warning': AstryxTokenValue.lightDark('#3E481D', '#3E481D'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#707E46', '#94a468'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#C0CBA9', '#5a6440'),
    '--color-background-card': AstryxTokenValue.lightDark('#FFFFFF', '#1e2016'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#3E481D',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#3E481D',
      '#C0CBA9',
    ),
    '--color-success': AstryxTokenValue.lightDark('#4D9900', '#6dbf2a'),
    '--color-success-muted': AstryxTokenValue.lightDark(
      '#4D990020',
      '#6dbf2a20',
    ),
    '--color-error': AstryxTokenValue.lightDark('#FD0000', '#ff5c5c'),
    '--color-error-muted': AstryxTokenValue.lightDark('#FD000020', '#ff5c5c20'),
    '--color-warning': AstryxTokenValue.lightDark('#FFB600', '#ffc940'),
    '--color-warning-muted': AstryxTokenValue.lightDark(
      '#FFB60020',
      '#ffc94020',
    ),
    '--color-border': AstryxTokenValue.lightDark('#DCE3CE', '#C0CBA91A'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#B7C29E',
      '#5a6440',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#C0CBA9', '#5a6440'),
    '--color-shadow': AstryxTokenValue.lightDark('#3E481D1A', '#0000004D'),
    '--color-tint-hover': AstryxTokenValue.lightDark('black', 'white'),
    '--color-background-blue': AstryxTokenValue.lightDark(
      '#3a5e8c33',
      '#3a5e8c33',
    ),
    '--color-border-blue': AstryxTokenValue.lightDark('#3a5e8c', '#7ba8d4'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#3a5e8c', '#7ba8d4'),
    '--color-text-blue': AstryxTokenValue.lightDark('#2e4a6e', '#8dbce0'),
    '--color-background-cyan': AstryxTokenValue.lightDark(
      '#3a7c7c33',
      '#3a7c7c33',
    ),
    '--color-border-cyan': AstryxTokenValue.lightDark('#3a7c7c', '#70c4c4'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#3a7c7c', '#70c4c4'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#2e6060', '#82d4d4'),
    '--color-background-gray': AstryxTokenValue.lightDark(
      '#707E4633',
      '#5a644033',
    ),
    '--color-border-gray': AstryxTokenValue.lightDark('#707E46', '#707E46'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#707E46', '#94a468'),
    '--color-text-gray': AstryxTokenValue.lightDark('#3E481D', '#C0CBA9'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#4D990033',
      '#6dbf2a33',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#4D9900', '#6dbf2a'),
    '--color-icon-green': AstryxTokenValue.lightDark('#4D9900', '#6dbf2a'),
    '--color-text-green': AstryxTokenValue.lightDark('#3d7a00', '#80d43a'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#c4762033',
      '#d4903a33',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#c47620', '#d4903a'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#c47620', '#d4903a'),
    '--color-text-orange': AstryxTokenValue.lightDark('#a06018', '#e0a04a'),
    '--color-background-pink': AstryxTokenValue.lightDark(
      '#c44a7033',
      '#e07a9a33',
    ),
    '--color-border-pink': AstryxTokenValue.lightDark('#c44a70', '#e07a9a'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#c44a70', '#e07a9a'),
    '--color-text-pink': AstryxTokenValue.lightDark('#a03a5a', '#f08aaa'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#6b4a8c33',
      '#b08ed433',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#6b4a8c', '#b08ed4'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#6b4a8c', '#b08ed4'),
    '--color-text-purple': AstryxTokenValue.lightDark('#553a70', '#c0a0e0'),
    '--color-background-red': AstryxTokenValue.lightDark(
      '#FD000033',
      '#ff5c5c33',
    ),
    '--color-border-red': AstryxTokenValue.lightDark('#FD0000', '#ff5c5c'),
    '--color-icon-red': AstryxTokenValue.lightDark('#FD0000', '#ff5c5c'),
    '--color-text-red': AstryxTokenValue.lightDark('#cc0000', '#ff7a7a'),
    '--color-background-teal': AstryxTokenValue.lightDark(
      '#2e6b5a33',
      '#5ab89833',
    ),
    '--color-border-teal': AstryxTokenValue.lightDark('#2e6b5a', '#5ab898'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#2e6b5a', '#5ab898'),
    '--color-text-teal': AstryxTokenValue.lightDark('#245546', '#6ccaaa'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#FFB60033',
      '#ffc94033',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#FFB600', '#ffc940'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#FFB600', '#ffc940'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#cc9200', '#ffd960'),
    '--spacing-0-5': AstryxTokenValue('3px'),
    '--spacing-1': AstryxTokenValue('6px'),
    '--spacing-1-5': AstryxTokenValue('9px'),
    '--spacing-2': AstryxTokenValue('12px'),
    '--spacing-3': AstryxTokenValue('18px'),
    '--spacing-4': AstryxTokenValue('24px'),
    '--spacing-5': AstryxTokenValue('30px'),
    '--spacing-6': AstryxTokenValue('36px'),
    '--spacing-7': AstryxTokenValue('42px'),
    '--spacing-8': AstryxTokenValue('48px'),
    '--spacing-9': AstryxTokenValue('54px'),
    '--spacing-10': AstryxTokenValue('60px'),
    '--spacing-11': AstryxTokenValue('66px'),
    '--spacing-12': AstryxTokenValue('72px'),
    '--radius-inner': AstryxTokenValue('6px'),
    '--radius-element': AstryxTokenValue('12px'),
    '--radius-container': AstryxTokenValue('18px'),
    '--radius-page': AstryxTokenValue('42px'),
    '--size-element-sm': AstryxTokenValue('36px'),
    '--size-element-md': AstryxTokenValue('40px'),
    '--size-element-lg': AstryxTokenValue('44px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #3E481D0D, 0 4px 8px #3E481D1A',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #3E481D0D, 0 4px 12px #3E481D1A',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #3E481D1A, 0 12px 24px #3E481D26',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #3E481D30'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #3E481D50',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #4D990050',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #FFB60050',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #FD000050'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    'button': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-full)',
        },
      ),
    },
    'card': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-page)',
          'padding': 'var(--spacing-3)',
        },
      ),
    },
    'section': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'padding': 'var(--spacing-3)',
        },
      ),
    },
  },
);

/// The `matcha` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: matchaTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme matchaTheme = defineTheme(matchaThemeInput);
