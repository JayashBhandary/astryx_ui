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

/// The Astryx `stone` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `stone` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: stoneTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput stoneThemeInput = AstryxDefineThemeInput(
  name: 'stone',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 14, ratio: 1.25),
    body: AstryxTypographyRole(
      family: 'Figtree',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Montserrat',
      fallbacks:
          '"Figtree", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
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
    name: 'xds-stone',
    tokens: <String, String>{
      'keyword': 'light-dark(#645a72, #b2a7c1)',
      'string': 'light-dark(#4e6357, #9bb19a)',
      'comment': 'light-dark(#5e5e5e, #ababb0)',
      'number': 'light-dark(#755752, #bea792)',
      'function': 'light-dark(#506072, #99adc6)',
      'type': 'light-dark(#645a72, #b2a7c1)',
      'variable': 'light-dark(#5e5e5e, #ababb0)',
      'operator': 'light-dark(#5e5e5e, #ababb0)',
      'constant': 'light-dark(#755752, #bea792)',
      'tag': 'light-dark(#775751, #c7a39d)',
      'attribute': 'light-dark(#79693f, #b6aa90)',
      'property': 'light-dark(#4e6357, #94b2a0)',
      'punctuation': 'light-dark(#5e5e5e, #ababb0)',
      'background': 'light-dark(#f3f3f5, #171719)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue.lightDark('#25252a', '#f3f3f5'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#25252a14',
      '#f3f3f520',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#25252a0f', '#f3f3f51a'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#ffffff',
      '#1b1b1f',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#f3f3f5', '#111015'),
    '--color-overlay': AstryxTokenValue.lightDark('#25252a80', '#28282acc'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#25252a0d',
      '#f3f3f50d',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#25252a1a',
      '#f3f3f51a',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#e2e2e8',
      '#3b3b3f',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#25252a', '#f3f3f5'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#83838a', '#9d9da3'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#d7d7da', '#5e5e61'),
    '--color-text-accent': AstryxTokenValue.lightDark('#25252a', '#f3f3f5'),
    '--color-on-dark': AstryxTokenValue('#FFFFFF'),
    '--color-on-light': AstryxTokenValue.lightDark('#25252a', '#28282a'),
    '--color-on-accent': AstryxTokenValue.lightDark('#ffffff', '#25252a'),
    '--color-on-success': AstryxTokenValue.lightDark('#374c36', '#d0e9ce'),
    '--color-on-error': AstryxTokenValue.lightDark('#58413e', '#f9dcd7'),
    '--color-on-warning': AstryxTokenValue.lightDark('#524622', '#f4e1b7'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#25252a', '#f3f3f5'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#25252a', '#f3f3f5'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#83838a', '#9d9da3'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#d7d7da', '#5e5e61'),
    '--color-background-card': AstryxTokenValue.lightDark('#FFFFFF', '#242325'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#ffffff',
      '#25252a',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#25252a',
      '#f3f3f5',
    ),
    '--color-success': AstryxTokenValue.lightDark('#374c36', '#b4cdb2'),
    '--color-success-muted': AstryxTokenValue.lightDark('#d0e9ce', '#b4cdb2'),
    '--color-error': AstryxTokenValue.lightDark('#58413e', '#dcc0bc'),
    '--color-error-muted': AstryxTokenValue.lightDark('#f9dcd7', '#dcc0bc'),
    '--color-warning': AstryxTokenValue.lightDark('#524622', '#d7c59c'),
    '--color-warning-muted': AstryxTokenValue.lightDark('#f4e1b7', '#d7c59c'),
    '--color-border': AstryxTokenValue.lightDark('#e2e2e8', '#f3f3f51a'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#83838a',
      '#5e5e61',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#d4d4da', '#5e5e64'),
    '--color-shadow': AstryxTokenValue.lightDark('#25252a1a', '#0000004d'),
    '--color-tint-hover': AstryxTokenValue.lightDark('black', 'white'),
    '--text-supporting-size': AstryxTokenValue('12px'),
    '--color-background-blue': AstryxTokenValue.lightDark('#d7e4f5', '#485362'),
    '--color-border-blue': AstryxTokenValue.lightDark('#c9d6e7', '#313c4a'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#3c4856', '#d7e4f5'),
    '--color-text-blue': AstryxTokenValue.lightDark('#3c4856', '#d7e4f5'),
    '--color-background-cyan': AstryxTokenValue.lightDark('#cce8e5', '#3e5755'),
    '--color-border-cyan': AstryxTokenValue.lightDark('#bedad7', '#28403e'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#334b49', '#cce8e5'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#334b49', '#cce8e5'),
    '--color-background-gray': AstryxTokenValue.lightDark('#e2e2e8', '#525257'),
    '--color-border-gray': AstryxTokenValue.lightDark('#d4d4da', '#3b3b3f'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#46464b', '#e2e2e8'),
    '--color-text-gray': AstryxTokenValue.lightDark('#46464b', '#e2e2e8'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#d0e9ce',
      '#425841',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#c2dbc0', '#2b402b'),
    '--color-icon-green': AstryxTokenValue.lightDark('#374c36', '#d0e9ce'),
    '--color-text-green': AstryxTokenValue.lightDark('#374c36', '#d0e9ce'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#ffdcbb',
      '#684d32',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#f1ceae', '#4f361c'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#5b4227', '#ffdcbb'),
    '--color-text-orange': AstryxTokenValue.lightDark('#5b4227', '#ffdcbb'),
    '--color-background-pink': AstryxTokenValue.lightDark('#f0dde8', '#5e4e57'),
    '--color-border-pink': AstryxTokenValue.lightDark('#e2cfda', '#463740'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#52424c', '#f0dde8'),
    '--color-text-pink': AstryxTokenValue.lightDark('#52424c', '#f0dde8'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#e8dff3',
      '#564f60',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#d9d1e5', '#3f3949'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#4b4454', '#e8dff3'),
    '--color-text-purple': AstryxTokenValue.lightDark('#4b4454', '#e8dff3'),
    '--color-background-red': AstryxTokenValue.lightDark('#f9dcd7', '#644d49'),
    '--color-border-red': AstryxTokenValue.lightDark('#ebcec9', '#4c3633'),
    '--color-icon-red': AstryxTokenValue.lightDark('#58413e', '#f9dcd7'),
    '--color-text-red': AstryxTokenValue.lightDark('#58413e', '#f9dcd7'),
    '--color-background-teal': AstryxTokenValue.lightDark('#d4e7dc', '#46564d'),
    '--color-border-teal': AstryxTokenValue.lightDark('#c6d9ce', '#303f36'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#3b4a41', '#d4e7dc'),
    '--color-text-teal': AstryxTokenValue.lightDark('#3b4a41', '#d4e7dc'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#f4e1b7',
      '#5e512d',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#e5d3a9', '#463a18'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#524622', '#f4e1b7'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#524622', '#f4e1b7'),
    '--radius-none': AstryxTokenValue('0.125rem'),
    '--radius-inner': AstryxTokenValue('0.25rem'),
    '--radius-element': AstryxTokenValue('0.5rem'),
    '--radius-container': AstryxTokenValue('0.75rem'),
    '--radius-page': AstryxTokenValue('1.5rem'),
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #28282A0D, 0 4px 8px #28282A1A',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #28282A0D, 0 4px 12px #28282A1A',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #28282A1A, 0 12px 24px #28282A26',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #28282A30'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #28282A50',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #83838a30',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #83838a30',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #83838a30'),
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
          'backgroundColor': 'transparent',
          'borderWidth': '1.5px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-border-emphasized)',
        },
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'var(--color-neutral)',
          },
        },
      ),
      'variant:destructive': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
          'color': 'var(--color-text-red)',
        },
      ),
    },
    'badge': <String, AstryxStyleOverrides>{
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
      'status:info': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-accent-muted': 'var(--color-background-blue)',
          '--color-text-primary': 'var(--color-text-blue)',
          '--color-text-secondary': 'var(--color-text-blue)',
          '--color-accent': 'var(--color-text-blue)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success-muted': 'var(--color-background-green)',
          '--color-text-primary': 'var(--color-text-green)',
          '--color-text-secondary': 'var(--color-text-green)',
          '--color-success': 'var(--color-text-green)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning-muted': 'var(--color-background-yellow)',
          '--color-text-primary': 'var(--color-text-yellow)',
          '--color-text-secondary': 'var(--color-text-yellow)',
          '--color-warning': 'var(--color-text-yellow)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error-muted': 'var(--color-background-red)',
          '--color-text-primary': 'var(--color-text-red)',
          '--color-text-secondary': 'var(--color-text-red)',
          '--color-error': 'var(--color-text-red)',
        },
      ),
    },
    'progressbar-fill': <String, AstryxStyleOverrides>{
      'variant:accent': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#d7e4f5, #a0acbc)',
        },
      ),
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#d0e9ce, #9ab298)',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#f4e1b7, #bbaa82)',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#f9dcd7, #c0a5a0)',
        },
      ),
    },
    'progressbar-track': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-skeleton)',
        },
      ),
    },
    'switch': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-background-gray': 'var(--color-skeleton)',
        },
      ),
    },
    'field-status': <String, AstryxStyleOverrides>{
      'type:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-green)',
        },
      ),
      'type:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-yellow)',
        },
      ),
      'type:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
        },
      ),
    },
    'text-input': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'textarea': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'number-input': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'date-input': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'time-input': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'selector': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'multi-selector': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'typeahead': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
        },
      ),
    },
    'tokenizer': <String, AstryxStyleOverrides>{
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': 'light-dark(#7f977e, #99b298)',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': 'light-dark(#9f8f68, #bbaa81)',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': 'light-dark(#a58b86, #c0a5a1)',
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

/// The `stone` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: stoneTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme stoneTheme = defineTheme(stoneThemeInput);
