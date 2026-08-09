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

/// The Astryx `gothic` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `gothic` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: gothicTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput gothicThemeInput = AstryxDefineThemeInput(
  name: 'gothic',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 16, ratio: 1.25),
    body: AstryxTypographyRole(
      family: 'Fustat',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Fustat',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
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
    fast: 150,
    medium: 350,
    slow: 800,
    ratio: 0.75,
  ),
  syntax: AstryxSyntaxTheme(
    name: 'xds-gothic',
    tokens: <String, String>{
      'keyword': '#c39adb',
      'string': '#a3c987',
      'comment': '#6b7079',
      'number': '#dec074',
      'function': '#8aa1d8',
      'type': '#c39adb',
      'variable': '#E8F1F6',
      'operator': '#96A0AB',
      'constant': '#e6b85e',
      'tag': '#d97580',
      'attribute': '#dec074',
      'property': '#7cc5b3',
      'punctuation': '#7a8290',
      'background': '#101314',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue('#E8F1F6'),
    '--color-accent-muted': AstryxTokenValue('#E8F1F620'),
    '--color-neutral': AstryxTokenValue('#E8F1F61A'),
    '--color-background-surface': AstryxTokenValue('#101314'),
    '--color-background-body': AstryxTokenValue('#101314'),
    '--color-overlay': AstryxTokenValue('#101314CC'),
    '--color-overlay-hover': AstryxTokenValue('#E8F1F60D'),
    '--color-overlay-pressed': AstryxTokenValue('#E8F1F61A'),
    '--color-background-muted': AstryxTokenValue('#24292D'),
    '--color-text-primary': AstryxTokenValue('#E8F1F6'),
    '--color-text-secondary': AstryxTokenValue('#96A0AB'),
    '--color-text-disabled': AstryxTokenValue('#495056'),
    '--color-text-accent': AstryxTokenValue('#E8F1F6'),
    '--color-on-dark': AstryxTokenValue('#E8F1F6'),
    '--color-on-light': AstryxTokenValue('#101314'),
    '--color-on-accent': AstryxTokenValue('#101314'),
    '--color-on-success': AstryxTokenValue('#101314'),
    '--color-on-error': AstryxTokenValue('#101314'),
    '--color-on-warning': AstryxTokenValue('#101314'),
    '--color-icon-accent': AstryxTokenValue('#E8F1F6'),
    '--color-icon-primary': AstryxTokenValue('#E8F1F6'),
    '--color-icon-secondary': AstryxTokenValue('#96A0AB'),
    '--color-icon-disabled': AstryxTokenValue('#495056'),
    '--color-background-card': AstryxTokenValue('#1a1d20'),
    '--color-background-popover': AstryxTokenValue('#24292D'),
    '--color-background-inverted': AstryxTokenValue('#E8F1F6'),
    '--color-success': AstryxTokenValue('#b3c79a'),
    '--color-success-muted': AstryxTokenValue('#b3c79a'),
    '--color-error': AstryxTokenValue('#c6a6a2'),
    '--color-error-muted': AstryxTokenValue('#c6a6a2'),
    '--color-warning': AstryxTokenValue('#d3c490'),
    '--color-warning-muted': AstryxTokenValue('#d3c490'),
    '--color-border': AstryxTokenValue('#E8F1F61A'),
    '--color-border-emphasized': AstryxTokenValue('#495056'),
    '--color-skeleton': AstryxTokenValue('#495056'),
    '--color-shadow': AstryxTokenValue('#0000004D'),
    '--color-tint-hover': AstryxTokenValue('white'),
    '--color-background-blue': AstryxTokenValue('#a3b5d6'),
    '--color-border-blue': AstryxTokenValue('#8696b8'),
    '--color-icon-blue': AstryxTokenValue('#2a3b6e'),
    '--color-text-blue': AstryxTokenValue('#1f2c54'),
    '--color-background-cyan': AstryxTokenValue('#a3c2cf'),
    '--color-border-cyan': AstryxTokenValue('#86a4b1'),
    '--color-icon-cyan': AstryxTokenValue('#2a5e75'),
    '--color-text-cyan': AstryxTokenValue('#204858'),
    '--color-background-gray': AstryxTokenValue('#3d4248'),
    '--color-border-gray': AstryxTokenValue('#5d646b'),
    '--color-icon-gray': AstryxTokenValue('#E8F1F6'),
    '--color-text-gray': AstryxTokenValue('#E8F1F6'),
    '--color-background-green': AstryxTokenValue('#b3c79a'),
    '--color-border-green': AstryxTokenValue('#96a880'),
    '--color-icon-green': AstryxTokenValue('#3a5e2c'),
    '--color-text-green': AstryxTokenValue('#244023'),
    '--color-background-orange': AstryxTokenValue('#d3b89a'),
    '--color-border-orange': AstryxTokenValue('#b6987d'),
    '--color-icon-orange': AstryxTokenValue('#8a4818'),
    '--color-text-orange': AstryxTokenValue('#6e3812'),
    '--color-background-pink': AstryxTokenValue('#c89aab'),
    '--color-border-pink': AstryxTokenValue('#aa7d8e'),
    '--color-icon-pink': AstryxTokenValue('#8d2d4c'),
    '--color-text-pink': AstryxTokenValue('#71223c'),
    '--color-background-purple': AstryxTokenValue('#b29bc4'),
    '--color-border-purple': AstryxTokenValue('#947da6'),
    '--color-icon-purple': AstryxTokenValue('#5a2370'),
    '--color-text-purple': AstryxTokenValue('#481b58'),
    '--color-background-red': AstryxTokenValue('#c6a6a2'),
    '--color-border-red': AstryxTokenValue('#a48581'),
    '--color-icon-red': AstryxTokenValue('#5e3a35'),
    '--color-text-red': AstryxTokenValue('#4a2520'),
    '--color-background-teal': AstryxTokenValue('#a3c2b6'),
    '--color-border-teal': AstryxTokenValue('#86a499'),
    '--color-icon-teal': AstryxTokenValue('#1f5e52'),
    '--color-text-teal': AstryxTokenValue('#174a40'),
    '--color-background-yellow': AstryxTokenValue('#d3c490'),
    '--color-border-yellow': AstryxTokenValue('#b6a775'),
    '--color-icon-yellow': AstryxTokenValue('#876515'),
    '--color-text-yellow': AstryxTokenValue('#6c5010'),
    '--radius-none': AstryxTokenValue('0.125rem'),
    '--radius-inner': AstryxTokenValue('0.25rem'),
    '--radius-element': AstryxTokenValue('0.5rem'),
    '--radius-container': AstryxTokenValue('0.75rem'),
    '--radius-page': AstryxTokenValue('1.5rem'),
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #00000033, 0 4px 8px #00000040',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #00000033, 0 4px 12px #00000040',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #00000040, 0 12px 24px #0000004D',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 1px #96A0AB30'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #96A0AB50',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 1px #87b06a50',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 1px #d6b56a50',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 1px #d4485150'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    'button': <String, AstryxStyleOverrides>{
      'variant:secondary': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-gray)',
          'color': 'var(--color-text-gray)',
          'borderColor': 'transparent',
          'borderWidth': '0',
        },
      ),
      'variant:ghost': AstryxStyleOverrides(
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'var(--color-overlay-hover)',
          },
        },
      ),
      'variant:destructive': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-error)',
          'color': 'var(--color-text-red)',
        },
      ),
    },
    'badge': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-element)',
          'fontWeight': 'var(--font-weight-medium)',
        },
      ),
      'variant:info': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-blue)',
          'color': 'var(--color-text-blue)',
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
          'backgroundColor': 'var(--color-background-green)',
          'color': 'var(--color-text-green)',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-yellow)',
          'color': 'var(--color-text-yellow)',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
          'color': 'var(--color-text-red)',
        },
      ),
    },
    'banner': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-element)',
        },
      ),
      'status:info': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-blue)',
          '--color-text-primary': 'var(--color-text-blue)',
          '--color-text-secondary': 'var(--color-text-blue)',
          '--color-accent': 'var(--color-text-blue)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-green)',
          '--color-text-primary': 'var(--color-text-green)',
          '--color-text-secondary': 'var(--color-text-green)',
          '--color-success': 'var(--color-text-green)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-yellow)',
          '--color-text-primary': 'var(--color-text-yellow)',
          '--color-text-secondary': 'var(--color-text-yellow)',
          '--color-warning': 'var(--color-text-yellow)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
          '--color-text-primary': 'var(--color-text-red)',
          '--color-text-secondary': 'var(--color-text-red)',
          '--color-error': 'var(--color-text-red)',
        },
      ),
    },
    'card': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'padding': 'var(--spacing-3)',
          'borderRadius': 'var(--radius-container)',
        },
      ),
      'variant:blue': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-blue)',
          '--color-text-secondary': 'var(--color-text-blue)',
        },
      ),
      'variant:cyan': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-cyan)',
          '--color-text-secondary': 'var(--color-text-cyan)',
        },
      ),
      'variant:gray': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-gray)',
          '--color-text-secondary': 'var(--color-text-gray)',
        },
      ),
      'variant:green': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-green)',
          '--color-text-secondary': 'var(--color-text-green)',
        },
      ),
      'variant:orange': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-orange)',
          '--color-text-secondary': 'var(--color-text-orange)',
        },
      ),
      'variant:pink': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-pink)',
          '--color-text-secondary': 'var(--color-text-pink)',
        },
      ),
      'variant:purple': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-purple)',
          '--color-text-secondary': 'var(--color-text-purple)',
        },
      ),
      'variant:red': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-red)',
          '--color-text-secondary': 'var(--color-text-red)',
        },
      ),
      'variant:teal': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-teal)',
          '--color-text-secondary': 'var(--color-text-teal)',
        },
      ),
      'variant:yellow': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': 'var(--color-text-yellow)',
          '--color-text-secondary': 'var(--color-text-yellow)',
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
    'field': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-element)',
        },
      ),
    },
    'text': <String, AstryxStyleOverrides>{
      'type:display-1': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Manufacturing Consent", "UnifrakturMaguntia", "Old English Text MT", serif',
        },
      ),
      'type:display-2': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Manufacturing Consent", "UnifrakturMaguntia", "Old English Text MT", serif',
        },
      ),
      'type:display-3': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Manufacturing Consent", "UnifrakturMaguntia", "Old English Text MT", serif',
        },
      ),
    },
  },
);

/// The `gothic` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: gothicTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme gothicTheme = defineTheme(gothicThemeInput);
