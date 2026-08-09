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

/// The Astryx `butter` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `butter` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: butterTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput butterThemeInput = AstryxDefineThemeInput(
  name: 'butter',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 14, ratio: 1.25),
    body: AstryxTypographyRole(
      family: 'Outfit',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Outfit',
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
    fast: 125,
    medium: 300,
    slow: 700,
    ratio: 0.75,
  ),
  syntax: AstryxSyntaxTheme(
    name: 'xds-butter',
    tokens: <String, String>{
      'keyword': 'light-dark(#52237b, #ddb9f6)',
      'string': 'light-dark(#004800, #a5d29d)',
      'comment': 'light-dark(#605f52, #adac9e)',
      'number': 'light-dark(#622e00, #f2bd81)',
      'function': 'light-dark(#203a6c, #bdc5eb)',
      'type': 'light-dark(#52237b, #ddb9f6)',
      'variable': 'light-dark(#605f52, #adac9e)',
      'operator': 'light-dark(#605f52, #adac9e)',
      'constant': 'light-dark(#622e00, #f2bd81)',
      'tag': 'light-dark(#6d211c, #f4b8ae)',
      'attribute': 'light-dark(#413e00, #d6c957)',
      'property': 'light-dark(#00482d, #94d3bb)',
      'punctuation': 'light-dark(#605f52, #adac9e)',
      'background': 'light-dark(#FDFBE4, #131107)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue.lightDark('#225BFF', '#FDEE8C'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#225BFF33',
      '#FDEE8C40',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#1d1c110F', '#f3f2e21A'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#2E2117',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#FDFBE4', '#261A13'),
    '--color-overlay': AstryxTokenValue.lightDark('#1d1c1180', '#261A13cc'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#1d1c110D',
      '#f3f2e20D',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#1d1c111A',
      '#f3f2e21A',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#f3f2e2',
      '#3A2A1F',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#1d1c11', '#f3f2e2'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#605f52', '#adac9e'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#adac9e', '#605f52'),
    '--color-text-accent': AstryxTokenValue.lightDark('#225BFF', '#FDEE8C'),
    '--color-on-dark': AstryxTokenValue('#ffffff'),
    '--color-on-light': AstryxTokenValue('#1d1c11'),
    '--color-on-accent': AstryxTokenValue.lightDark('#ffffff', '#1d1c11'),
    '--color-on-success': AstryxTokenValue.lightDark('#ccff88', '#0b2e00'),
    '--color-on-error': AstryxTokenValue.lightDark('#ffe3de', '#600000'),
    '--color-on-warning': AstryxTokenValue.lightDark('#ffeec3', '#3b2200'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#225BFF', '#FDEE8C'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#1d1c11', '#f3f2e2'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#605f52', '#adac9e'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#adac9e', '#605f52'),
    '--color-background-card': AstryxTokenValue.lightDark('#FFFFFF', '#3A2A1F'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#3A2A1F',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#1d1c11',
      '#FDFBE4',
    ),
    '--color-error': AstryxTokenValue.lightDark('#771210', '#ffb4a6'),
    '--color-error-muted': AstryxTokenValue.lightDark('#77121033', '#ffb4a640'),
    '--color-warning': AstryxTokenValue.lightDark('#543700', '#f7be00'),
    '--color-warning-muted': AstryxTokenValue.lightDark(
      '#54370033',
      '#f7be0040',
    ),
    '--color-success': AstryxTokenValue.lightDark('#004700', '#99d94b'),
    '--color-success-muted': AstryxTokenValue.lightDark(
      '#00470033',
      '#99d94b40',
    ),
    '--color-border': AstryxTokenValue.lightDark('#e5e3d4', '#f3f2e21A'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#C7C4B2',
      '#939184',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#e5e3d4', '#49473b'),
    '--color-shadow': AstryxTokenValue.lightDark('#1d1c111A', '#0000004D'),
    '--color-tint-hover': AstryxTokenValue.lightDark('black', 'white'),
    '--text-supporting-size': AstryxTokenValue('12px'),
    '--size-element-sm': AstryxTokenValue('32px'),
    '--size-element-md': AstryxTokenValue('40px'),
    '--size-element-lg': AstryxTokenValue('48px'),
    '--color-background-blue': AstryxTokenValue.lightDark('#dbe1ff', '#dbe1ff'),
    '--color-border-blue': AstryxTokenValue.lightDark('#bdc5eb', '#bdc5eb'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#203a6c', '#203a6c'),
    '--color-text-blue': AstryxTokenValue.lightDark('#203a6c', '#203a6c'),
    '--color-background-cyan': AstryxTokenValue.lightDark('#a9eff0', '#a9eff0'),
    '--color-border-cyan': AstryxTokenValue.lightDark('#8dd2d3', '#8dd2d3'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#004649', '#004649'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#004649', '#004649'),
    '--color-background-gray': AstryxTokenValue.lightDark('#f0edd4', '#f0edd4'),
    '--color-border-gray': AstryxTokenValue.lightDark('#d6d3b8', '#d6d3b8'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#4a4732', '#4a4732'),
    '--color-text-gray': AstryxTokenValue.lightDark('#4a4732', '#4a4732'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#c1efb8',
      '#c1efb8',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#a5d29d', '#a5d29d'),
    '--color-icon-green': AstryxTokenValue.lightDark('#004800', '#004800'),
    '--color-text-green': AstryxTokenValue.lightDark('#004800', '#004800'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#ffdcb6',
      '#ffdcb6',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#f2bd81', '#f2bd81'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#622e00', '#622e00'),
    '--color-text-orange': AstryxTokenValue.lightDark('#622e00', '#622e00'),
    '--color-background-pink': AstryxTokenValue.lightDark('#ffd5fb', '#ffd5fb'),
    '--color-border-pink': AstryxTokenValue.lightDark('#f0b3e8', '#f0b3e8'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#6c0a68', '#6c0a68'),
    '--color-text-pink': AstryxTokenValue.lightDark('#6c0a68', '#6c0a68'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#f2daff',
      '#f2daff',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#ddb9f6', '#ddb9f6'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#52237b', '#52237b'),
    '--color-text-purple': AstryxTokenValue.lightDark('#52237b', '#52237b'),
    '--color-background-red': AstryxTokenValue.lightDark('#ffdad3', '#ffdad3'),
    '--color-border-red': AstryxTokenValue.lightDark('#f4b8ae', '#f4b8ae'),
    '--color-icon-red': AstryxTokenValue.lightDark('#6d211c', '#6d211c'),
    '--color-text-red': AstryxTokenValue.lightDark('#6d211c', '#6d211c'),
    '--color-background-teal': AstryxTokenValue.lightDark('#b0f0d7', '#b0f0d7'),
    '--color-border-teal': AstryxTokenValue.lightDark('#94d3bb', '#94d3bb'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#00482d', '#00482d'),
    '--color-text-teal': AstryxTokenValue.lightDark('#00482d', '#00482d'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#feee7b',
      '#feee7b',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#d6c957', '#d6c957'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#413e00', '#413e00'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#413e00', '#413e00'),
    '--radius-none': AstryxTokenValue('0.125rem'),
    '--radius-inner': AstryxTokenValue('0.375rem'),
    '--radius-element': AstryxTokenValue('0.5rem'),
    '--radius-container': AstryxTokenValue('0.75rem'),
    '--radius-page': AstryxTokenValue('1.5rem'),
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #1d1c110D, 0 4px 8px #1d1c111A',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #1d1c110D, 0 4px 12px #1d1c111A',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #1d1c111A, 0 12px 24px #1d1c1126',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #79786a30'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #79786a50',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #00470030',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #54370030',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #77121030'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    'top-nav-heading': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'color': 'light-dark(#225BFF, #FDEE8C)',
          '--color-text-primary': 'light-dark(#225BFF, #FDEE8C)',
        },
      ),
    },
    'top-nav-item': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'color': 'light-dark(#6E92FF, #FDEE8CCC)',
        },
      ),
      'selected': AstryxStyleOverrides(
        properties: <String, String>{
          'color': 'light-dark(#225BFF, #FDEE8C)',
          'backgroundColor': 'transparent',
        },
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'var(--color-overlay-hover)',
          },
          ':active': <String, String>{
            'backgroundColor': 'var(--color-overlay-pressed)',
          },
        },
      ),
    },
    'button': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-3)',
          'paddingInline': 'var(--spacing-4)',
        },
      ),
      'variant:secondary': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'transparent',
          'borderWidth': '1.5px',
          'borderStyle': 'solid',
          'borderColor': 'light-dark(#225BFF, #FDEE8C)',
          'color': 'light-dark(#225BFF, #FDEE8C)',
        },
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'light-dark(#225BFF14, #FDEE8C14)',
          },
        },
      ),
      'variant:ghost': AstryxStyleOverrides(
        properties: <String, String>{
          'color': 'light-dark(#225BFF, #FDEE8C)',
        },
      ),
      'variant:destructive': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#ffdad3, #f4b8ae)',
          'color': 'light-dark(#550000, #6d211c)',
        },
      ),
    },
    'badge': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'height': '30px',
          'paddingBlock': '0',
          'paddingInline': 'var(--spacing-3)',
        },
      ),
      'variant:info': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#4883fd',
          'color': '#ffffff',
        },
      ),
      'variant:neutral': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffee7b',
          'color': '#225BFF',
        },
      ),
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#91D143',
          'color': '#1d1c11',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffc502',
          'color': '#1d1c11',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#fc473b',
          'color': '#ffffff',
        },
      ),
    },
    'banner': <String, AstryxStyleOverrides>{
      'status:info': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-accent-muted': '#4883fd',
          '--color-text-primary': '#ffffff',
          '--color-text-secondary': '#ffffff',
          '--color-accent': '#ffffff',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success-muted': '#91D143',
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#1d1c11',
          '--color-success': '#1d1c11',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning-muted': '#ffc502',
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#1d1c11',
          '--color-warning': '#1d1c11',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error-muted': '#fc473b',
          '--color-text-primary': '#ffffff',
          '--color-text-secondary': '#ffffff',
          '--color-error': '#ffffff',
        },
      ),
    },
    'card': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': 'var(--radius-container)',
          'padding': 'var(--spacing-4)',
        },
      ),
      'variant:info': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:blue': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:cyan': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:gray': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:green': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:orange': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:pink': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:purple': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:red': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:teal': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:yellow': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
      'variant:muted': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-text-primary': '#1d1c11',
          '--color-text-secondary': '#605f52',
        },
      ),
    },
    'section': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'padding': 'var(--spacing-4)',
        },
      ),
    },
    'progressbar-track': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'light-dark(#e5e3d4, #725538)',
        },
      ),
    },
    'progressbar-fill': <String, AstryxStyleOverrides>{
      'variant:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#91D143',
        },
      ),
      'variant:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffc502',
        },
      ),
      'variant:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#fc473b',
        },
      ),
    },
    'field-status': <String, AstryxStyleOverrides>{
      'type:success': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#91D143',
          'color': '#1d1c11',
        },
      ),
      'type:warning': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#ffc502',
          'color': '#1d1c11',
        },
      ),
      'type:error': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': '#fc473b',
          'color': '#ffffff',
        },
      ),
    },
    'text-input': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'textarea': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'number-input': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'date-input': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'time-input': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'selector': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'multi-selector': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'typeahead': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'tokenizer': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'paddingBlock': 'var(--spacing-2)',
          'paddingInline': 'var(--spacing-3)',
          'borderColor': 'var(--color-border)',
        },
      ),
      'status:success': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-success': '#91D143',
        },
      ),
      'status:warning': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-warning': '#ffc502',
        },
      ),
      'status:error': AstryxStyleOverrides(
        properties: <String, String>{
          '--color-error': '#fc473b',
        },
      ),
    },
    'text': <String, AstryxStyleOverrides>{
      'type:display-1': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily': 'Sarina, "Brush Script MT", "Snell Roundhand", cursive',
        },
      ),
      'type:display-2': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily': 'Sarina, "Brush Script MT", "Snell Roundhand", cursive',
        },
      ),
      'type:display-3': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily': 'Sarina, "Brush Script MT", "Snell Roundhand", cursive',
        },
      ),
    },
  },
);

/// The `butter` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: butterTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme butterTheme = defineTheme(butterThemeInput);
