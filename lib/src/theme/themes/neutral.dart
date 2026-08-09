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

/// The Astryx `neutral` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `neutral` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: neutralTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput neutralThemeInput = AstryxDefineThemeInput(
  name: 'neutral',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
    body: AstryxTypographyRole(
      family: 'Figtree',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Figtree',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
      weights: <int, AstryxFontWeight>{
        3: AstryxFontWeight('bold'),
        4: AstryxFontWeight('bold'),
      },
    ),
    code: AstryxTypographyRole(
      family: 'ui-monospace',
      fallbacks:
          '"SF Mono", Monaco, Consolas, "Liberation Mono", "Courier New", monospace',
    ),
  ),
  motion: AstryxMotionScaleConfig(
    fast: 125,
    medium: 300,
    slow: 700,
    ratio: 0.75,
  ),
  syntax: AstryxSyntaxTheme(
    name: 'xds-neutral',
    tokens: <String, String>{
      'keyword': 'light-dark(#700084, #efa8ff)',
      'string': 'light-dark(#005600, #a6d2a2)',
      'comment': 'light-dark(#737373, #a3a3a3)',
      'number': 'light-dark(#6e3500, #ffb37f)',
      'function': 'light-dark(#00458c, #a0caff)',
      'type': 'light-dark(#700084, #efa8ff)',
      'variable': 'light-dark(#171717, #e5e5e5)',
      'operator': 'light-dark(#737373, #a3a3a3)',
      'constant': 'light-dark(#6e3500, #ffb37f)',
      'tag': 'light-dark(#89001a, #ffaeaa)',
      'attribute': 'light-dark(#584400, #eec12f)',
      'property': 'light-dark(#005348, #83dac9)',
      'punctuation': 'light-dark(#a3a3a3, #525252)',
      'background': 'light-dark(#fafafa, #0a0a0a)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#ffffff',
      '#262626',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#f1f1f1', '#1b1b1b'),
    '--color-background-card': AstryxTokenValue.lightDark('#ffffff', '#1b1b1b'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#ffffff',
      '#1b1b1b',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#f1f1f1',
      '#1b1b1b',
    ),
    '--color-accent': AstryxTokenValue.lightDark('#262626', '#ebebeb'),
    '--color-accent-muted': AstryxTokenValue.lightDark('#f1f1f1', '#262626'),
    '--color-neutral': AstryxTokenValue.lightDark('#0000000F', '#FFFFFF1A'),
    '--color-overlay': AstryxTokenValue.lightDark('#00000080', '#000000CC'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#0000000D',
      '#FFFFFF0D',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#0000001A',
      '#FFFFFF1A',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#171717', '#fafafa'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#525252', '#a3a3a3'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#a3a3a3', '#525252'),
    '--color-text-accent': AstryxTokenValue.lightDark('#262626', '#ebebeb'),
    '--color-on-dark': AstryxTokenValue('#ffffff'),
    '--color-on-light': AstryxTokenValue('#171717'),
    '--color-on-accent': AstryxTokenValue.lightDark('#ffffff', '#171717'),
    '--color-on-success': AstryxTokenValue.lightDark('#ffffff', '#171717'),
    '--color-on-error': AstryxTokenValue.lightDark('#ffffff', '#171717'),
    '--color-on-warning': AstryxTokenValue('#171717'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#262626', '#ebebeb'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#171717', '#fafafa'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#737373', '#a3a3a3'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#a3a3a3', '#525252'),
    '--color-success': AstryxTokenValue.lightDark('#007004', '#9fe59b'),
    '--color-error': AstryxTokenValue.lightDark('#a50c25', '#ffc6c1'),
    '--color-warning': AstryxTokenValue.lightDark('#745b00', '#fdcf4f'),
    '--color-success-muted': AstryxTokenValue.lightDark('#c5e5c0', '#84c9803D'),
    '--color-error-muted': AstryxTokenValue.lightDark('#facecb', '#ff9e973D'),
    '--color-warning-muted': AstryxTokenValue.lightDark('#f8da9d', '#deb4333D'),
    '--color-border': AstryxTokenValue.lightDark('#00000014', '#FFFFFF1A'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#d4d4d4',
      '#525252',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#ebebeb', '#525252'),
    '--color-shadow': AstryxTokenValue.lightDark('#0000001A', '#0000004D'),
    '--color-tint-hover': AstryxTokenValue.lightDark('black', 'white'),
    '--color-background-red': AstryxTokenValue.lightDark(
      '#facecb',
      '#ff9e973D',
    ),
    '--color-border-red': AstryxTokenValue.lightDark('#e6bab8', '#ff6f6c'),
    '--color-icon-red': AstryxTokenValue.lightDark('#89001a', '#ff9e97'),
    '--color-text-red': AstryxTokenValue.lightDark('#89001a', '#ffc6c1'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#fad0b5',
      '#ffa2583D',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#e6bda2', '#e2883e'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#6e3500', '#ffa258'),
    '--color-text-orange': AstryxTokenValue.lightDark('#6e3500', '#ffc9a2'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#f8da9d',
      '#deb4333D',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#e4c279', '#c0990e'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#584400', '#deb433'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#584400', '#fdcf4f'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#c5e5c0',
      '#84c9803D',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#b2d1ac', '#69ad67'),
    '--color-icon-green': AstryxTokenValue.lightDark('#0c5700', '#84c980'),
    '--color-text-green': AstryxTokenValue.lightDark('#0c5700', '#9fe59b'),
    '--color-background-teal': AstryxTokenValue.lightDark(
      '#a5e3d6',
      '#7ec6b83D',
    ),
    '--color-border-teal': AstryxTokenValue.lightDark('#94d6c8', '#63ab9d'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#005348', '#7ec6b8'),
    '--color-text-teal': AstryxTokenValue.lightDark('#005348', '#99e2d3'),
    '--color-background-cyan': AstryxTokenValue.lightDark(
      '#a3e0ef',
      '#83c2d43D',
    ),
    '--color-border-cyan': AstryxTokenValue.lightDark('#91d3e3', '#67a7b8'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#00505f', '#83c2d4'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#00505f', '#9edef0'),
    '--color-background-blue': AstryxTokenValue.lightDark(
      '#c4ddfb',
      '#9eb7ff3D',
    ),
    '--color-border-blue': AstryxTokenValue.lightDark('#b1c9e7', '#6d9cfe'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#00458c', '#9eb7ff'),
    '--color-text-blue': AstryxTokenValue.lightDark('#00458c', '#c7d3ff'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#eccef3',
      '#f297ff3D',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#d8bbdf', '#dd74f0'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#700084', '#f297ff'),
    '--color-text-purple': AstryxTokenValue.lightDark('#700084', '#fac1ff'),
    '--color-background-pink': AstryxTokenValue.lightDark(
      '#fccadc',
      '#ff99c33D',
    ),
    '--color-border-pink': AstryxTokenValue.lightDark('#e7b7c8', '#f273aa'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#83004b', '#ff99c3'),
    '--color-text-pink': AstryxTokenValue.lightDark('#83004b', '#ffc3da'),
    '--color-background-gray': AstryxTokenValue.lightDark(
      '#e5e5e5',
      'var(--color-neutral)',
    ),
    '--color-border-gray': AstryxTokenValue.lightDark('#d4d4d4', '#262626'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#525252', '#a3a3a3'),
    '--color-text-gray': AstryxTokenValue.lightDark('#262626', '#e5e5e5'),
    '--radius-none': AstryxTokenValue('0.25rem'),
    '--radius-inner': AstryxTokenValue('0.375rem'),
    '--radius-element': AstryxTokenValue('0.625rem'),
    '--radius-container': AstryxTokenValue('0.75rem'),
    '--radius-page': AstryxTokenValue('1.75rem'),
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px light-dark(oklch(0 0 0 / 5%), oklch(0 0 0 / 25%)), 0 4px 8px light-dark(oklch(0 0 0 / 10%), oklch(0 0 0 / 40%)), inset 0 0 0 1px light-dark(transparent, oklch(1 0 0 / 8%))',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px light-dark(oklch(0 0 0 / 5%), oklch(0 0 0 / 35%)), 0 4px 12px light-dark(oklch(0 0 0 / 10%), oklch(0 0 0 / 50%)), inset 0 0 0 1px light-dark(transparent, oklch(1 0 0 / 12%))',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px light-dark(oklch(0 0 0 / 10%), oklch(0 0 0 / 50%)), 0 12px 24px light-dark(oklch(0 0 0 / 15%), oklch(0 0 0 / 70%)), inset 0 0 0 1px light-dark(transparent, oklch(1 0 0 / 15%))',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #0074e24D'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #0074e280',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #1981004D',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #ffce2f4D',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #e33f4a4D'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    'button': <String, AstryxStyleOverrides>{
      'variant:destructive': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-error-muted)',
          'color': 'var(--color-error)',
        },
      ),
    },
    'badge': <String, AstryxStyleOverrides>{
      'variant:info': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#0074e2, #6d9cfe)',
          'color': 'light-dark(#ffffff, #171717)',
        },
      ),
      'variant:neutral': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-gray)',
          'color': 'var(--color-text-gray)',
        },
      ),
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#198100, #64af4c)',
          'color': 'light-dark(#ffffff, #171717)',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffce2f',
          'color': '#171717',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#e33f4a, #ff705d)',
          'color': 'light-dark(#ffffff, #171717)',
        },
      ),
      'variant:red': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
          'color': 'var(--color-text-red)',
        },
      ),
      'variant:orange': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-orange)',
          'color': 'var(--color-text-orange)',
        },
      ),
      'variant:yellow': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-yellow)',
          'color': 'var(--color-text-yellow)',
        },
      ),
      'variant:green': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-green)',
          'color': 'var(--color-text-green)',
        },
      ),
      'variant:teal': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-teal)',
          'color': 'var(--color-text-teal)',
        },
      ),
      'variant:cyan': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-cyan)',
          'color': 'var(--color-text-cyan)',
        },
      ),
      'variant:blue': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-blue)',
          'color': 'var(--color-text-blue)',
        },
      ),
      'variant:purple': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-purple)',
          'color': 'var(--color-text-purple)',
        },
      ),
      'variant:pink': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-pink)',
          'color': 'var(--color-text-pink)',
        },
      ),
      'variant:gray': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-gray)',
          'color': 'var(--color-text-gray)',
        },
      ),
    },
    'statusdot': <String, AstryxStyleOverrides>{
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#198100, #64af4c)',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffce2f',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#e33f4a, #ff705d)',
        },
      ),
      'variant:accent': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#0074e2, #6d9cfe)',
        },
      ),
    },
    'banner': <String, AstryxStyleOverrides>{
      'status:info': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-blue)',
          '--color-accent-muted': 'transparent',
          '--color-text-primary': 'var(--color-text-blue)',
          '--color-text-secondary': 'var(--color-text-blue)',
          '--color-accent': 'var(--color-text-blue)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-green)',
          '--color-text-secondary': 'var(--color-text-green)',
          '--color-success': 'var(--color-text-green)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-yellow)',
          '--color-text-secondary': 'var(--color-text-yellow)',
          '--color-warning': 'var(--color-text-yellow)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-red)',
          '--color-text-secondary': 'var(--color-text-red)',
          '--color-error': 'var(--color-text-red)',
        },
      ),
    },
    'switch': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-background-gray': 'var(--color-border-emphasized)',
        },
      ),
    },
    'progressbar': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-background-muted': 'var(--color-border-emphasized)',
        },
      ),
      'variant:accent': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-accent': '#0074e2',
        },
      ),
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#198100',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffce2f',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#e33f4a',
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

/// The `neutral` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: neutralTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme neutralTheme = defineTheme(neutralThemeInput);
