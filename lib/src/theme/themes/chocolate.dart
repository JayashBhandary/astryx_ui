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

/// The Astryx `chocolate` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `chocolate` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: chocolateTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput chocolateThemeInput = AstryxDefineThemeInput(
  name: 'chocolate',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
    body: AstryxTypographyRole(
      family: 'Albert Sans',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Fraunces',
      fallbacks: 'Georgia, "Times New Roman", Times, serif',
      weights: <int, AstryxFontWeight>{
        3: AstryxFontWeight('bold'),
        4: AstryxFontWeight('bold'),
      },
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
    name: 'xds-chocolate',
    tokens: <String, String>{
      'keyword': 'light-dark(#8C5927, #d4a06a)',
      'string': 'light-dark(#2e6b4a, #7bc49e)',
      'comment': 'light-dark(#B88859, #B88859)',
      'number': 'light-dark(#a06018, #d4b870)',
      'function': 'light-dark(#3a5e8c, #7ba8d4)',
      'type': 'light-dark(#6b4a8c, #b08ed4)',
      'variable': 'light-dark(#4a3520, #EDE4D4)',
      'operator': 'light-dark(#B88859, #c4a882)',
      'constant': 'light-dark(#a06018, #d4b870)',
      'tag': 'light-dark(#8c3a3a, #d47a7a)',
      'attribute': 'light-dark(#8C5927, #d4a06a)',
      'property': 'light-dark(#3a7c6b, #70c4b0)',
      'punctuation': 'light-dark(#B88859, #6b5540)',
      'background': 'light-dark(#FFFCF7, #1c1610)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue.lightDark('#8C5927', '#d4a06a'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#8C592714',
      '#d4a06a20',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#8C59270F', '#EDE4D41A'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#FFFCF7',
      '#1c1610',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#FFFCF7', '#141010'),
    '--color-overlay': AstryxTokenValue.lightDark('#4a352080', '#140e0aCC'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#4a35200D',
      '#EDE4D40D',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#4a35201A',
      '#EDE4D41A',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#EDE4D4',
      '#2a2018',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#4a3520', '#EDE4D4'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#B88859', '#c4a882'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#C4AC95', '#6b5540'),
    '--color-text-accent': AstryxTokenValue.lightDark('#8C5927', '#d4a06a'),
    '--color-on-dark': AstryxTokenValue('#FFFCF7'),
    '--color-on-light': AstryxTokenValue('#4a3520'),
    '--color-on-accent': AstryxTokenValue.lightDark('#FFFFFF', '#4a3520'),
    '--color-on-success': AstryxTokenValue.lightDark('#FFFFFF', '#4a3520'),
    '--color-on-error': AstryxTokenValue.lightDark('#FFFFFF', '#4a3520'),
    '--color-on-warning': AstryxTokenValue.lightDark('#4a3520', '#4a3520'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#8C5927', '#d4a06a'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#4a3520', '#EDE4D4'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#B88859', '#c4a882'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#C4AC95', '#6b5540'),
    '--color-background-card': AstryxTokenValue.lightDark('#EDE4D4', '#2a2018'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#FFFCF7',
      '#2a2018',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#4a3520',
      '#EDE4D4',
    ),
    '--color-success': AstryxTokenValue.lightDark('#709900', '#96bf2a'),
    '--color-success-muted': AstryxTokenValue.lightDark(
      '#70990020',
      '#96bf2a20',
    ),
    '--color-error': AstryxTokenValue.lightDark('#FD0000', '#ff5c5c'),
    '--color-error-muted': AstryxTokenValue.lightDark('#FD000020', '#ff5c5c20'),
    '--color-warning': AstryxTokenValue.lightDark('#FFB600', '#ffc940'),
    '--color-warning-muted': AstryxTokenValue.lightDark(
      '#FFB60020',
      '#ffc94020',
    ),
    '--color-border': AstryxTokenValue.lightDark('#C4AC95', '#EDE4D41A'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#B88859',
      '#6b5540',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#C4AC95', '#6b5540'),
    '--color-shadow': AstryxTokenValue.lightDark('#4a35201A', '#0000004D'),
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
      '#B8885933',
      '#6b554033',
    ),
    '--color-border-gray': AstryxTokenValue.lightDark('#B88859', '#B88859'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#B88859', '#c4a882'),
    '--color-text-gray': AstryxTokenValue.lightDark('#4a3520', '#EDE4D4'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#70990033',
      '#96bf2a33',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#709900', '#96bf2a'),
    '--color-icon-green': AstryxTokenValue.lightDark('#709900', '#96bf2a'),
    '--color-text-green': AstryxTokenValue.lightDark('#5a7a00', '#a8d43a'),
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
    '--radius-none': AstryxTokenValue('0.125rem'),
    '--radius-inner': AstryxTokenValue('0.375rem'),
    '--radius-element': AstryxTokenValue('0.625rem'),
    '--radius-container': AstryxTokenValue('0.75rem'),
    '--radius-page': AstryxTokenValue('1.5rem'),
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #4a35200D, 0 4px 8px #4a35201A',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #4a35200D, 0 4px 12px #4a35201A',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #4a35201A, 0 12px 24px #4a352026',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #8C592730'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #8C592750',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #70990050',
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
      'variant:secondary': AstryxStyleOverrides(
        properties: <String, String>{
          'borderWidth': '1px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-border-emphasized)',
        },
      ),
    },
    'card': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
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

/// The `chocolate` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: chocolateTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme chocolateTheme = defineTheme(chocolateThemeInput);
