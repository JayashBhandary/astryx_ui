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

/// The Astryx `y2k` theme.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `y2k` theme, before the engine runs over it.
///
/// Transcribed from upstream's `defineTheme` call. Exposed so a consumer can
/// extend it — `AstryxDefineThemeInput(extendsTheme: y2kTheme, …)` — or read
/// what it configures.
const AstryxDefineThemeInput y2kThemeInput = AstryxDefineThemeInput(
  name: 'y2k',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 16, ratio: 1.25),
    body: AstryxTypographyRole(
      family: 'Poppins',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    heading: AstryxTypographyRole(
      family: 'Poppins',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    code: AstryxTypographyRole(
      family: 'JetBrains Mono',
      fallbacks: '"SF Mono", Monaco, Consolas, monospace',
    ),
  ),
  motion: AstryxMotionScaleConfig(
    fast: 100,
    medium: 250,
    slow: 600,
    ratio: 0.8,
  ),
  radius: AstryxRadiusScaleConfig(base: 4, multiplier: 0),
  syntax: AstryxSyntaxTheme(
    name: 'xds-y2k',
    tokens: <String, String>{
      'keyword': 'light-dark(#615a7a, #aea6ca)',
      'string': 'light-dark(#586242, #a5af8b)',
      'comment': 'light-dark(#5e5e5e, #ababab)',
      'number': 'light-dark(#775843, #c8a48c)',
      'function': 'light-dark(#39637d, #87b0cd)',
      'type': 'light-dark(#615a7a, #aea6ca)',
      'variable': 'light-dark(#5e5e5e, #ababab)',
      'operator': 'light-dark(#5e5e5e, #ababab)',
      'constant': 'light-dark(#775843, #c8a48c)',
      'tag': 'light-dark(#7f5351, #d19f9d)',
      'attribute': 'light-dark(#6c5c3e, #bca987)',
      'property': 'light-dark(#3c6755, #87b5a1)',
      'punctuation': 'light-dark(#5e5e5e, #ababab)',
      'background': 'light-dark(#FFF6ED, #190f00)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
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
    '--size-element-sm': AstryxTokenValue('32px'),
    '--size-element-md': AstryxTokenValue('40px'),
    '--size-element-lg': AstryxTokenValue('48px'),
    '--color-accent': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#2d241b14',
      '#EDEFFC20',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#2d241b10', '#EDEFFC1A'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#16182b',
    ),
    '--color-background-body': AstryxTokenValue.lightDark('#CCCFFA', '#0e0f1a'),
    '--color-overlay': AstryxTokenValue.lightDark('#2d241b80', '#0a0b14CC'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#2d241b0D',
      '#EDEFFC0D',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#2d241b1A',
      '#EDEFFC1A',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#ede0d4',
      '#1f2238',
    ),
    '--color-text-primary': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#675d52', '#a6acd6'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#d1c5b8', '#4a4f6b'),
    '--color-text-accent': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--color-on-dark': AstryxTokenValue('#FFFFFF'),
    '--color-on-light': AstryxTokenValue('#2d241b'),
    '--color-on-accent': AstryxTokenValue.lightDark('#FFFFFF', '#16182b'),
    '--color-on-success': AstryxTokenValue.lightDark('#3a5500', '#1e3200'),
    '--color-on-error': AstryxTokenValue.lightDark('#8b1d24', '#5c0008'),
    '--color-on-warning': AstryxTokenValue.lightDark('#614400', '#3f2600'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#675d52', '#a6acd6'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#d1c5b8', '#4a4f6b'),
    '--color-background-card': AstryxTokenValue.lightDark('#FFFFFF', '#16182b'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#FFFFFF',
      '#1f2238',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#2d241b',
      '#EDEFFC',
    ),
    '--color-success': AstryxTokenValue.lightDark('#C5E17A', '#C5E17A'),
    '--color-success-muted': AstryxTokenValue.lightDark('#C5E17A', '#C5E17A'),
    '--color-error': AstryxTokenValue.lightDark('#FFC5C3', '#FFC5C3'),
    '--color-error-muted': AstryxTokenValue.lightDark('#FFC5C3', '#FFC5C3'),
    '--color-warning': AstryxTokenValue.lightDark('#FFE08A', '#FFE08A'),
    '--color-warning-muted': AstryxTokenValue.lightDark('#FFE08A', '#FFE08A'),
    '--color-border': AstryxTokenValue.lightDark('#2F292E', '#EDEFFC1A'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#2F292E',
      '#3a3f5e',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#d1c5b8', '#2a2e47'),
    '--color-shadow': AstryxTokenValue.lightDark('#2d241b1A', '#0000004D'),
    '--color-tint-hover': AstryxTokenValue.lightDark('#2d241b', '#EDEFFC'),
    '--text-supporting-size': AstryxTokenValue('12px'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#C5E17A',
      '#C5E17A',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#B5D16A', '#B5D16A'),
    '--color-icon-green': AstryxTokenValue.lightDark('#3a5500', '#1e3200'),
    '--color-text-green': AstryxTokenValue.lightDark('#3a5500', '#1e3200'),
    '--color-background-red': AstryxTokenValue.lightDark('#FFC5C3', '#FFC5C3'),
    '--color-border-red': AstryxTokenValue.lightDark('#FF9E9A', '#FF9E9A'),
    '--color-icon-red': AstryxTokenValue.lightDark('#8b1d24', '#5c0008'),
    '--color-text-red': AstryxTokenValue.lightDark('#8b1d24', '#5c0008'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#FFE08A',
      '#FFE08A',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#FFCC55', '#FFCC55'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#614400', '#3f2600'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#614400', '#3f2600'),
    '--color-background-blue': AstryxTokenValue.lightDark('#B8E0FF', '#B8E0FF'),
    '--color-border-blue': AstryxTokenValue.lightDark('#8ECFFF', '#8ECFFF'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#004e74', '#002c4d'),
    '--color-text-blue': AstryxTokenValue.lightDark('#004e74', '#002c4d'),
    '--color-background-pink': AstryxTokenValue.lightDark('#FFC8E0', '#FFC8E0'),
    '--color-border-pink': AstryxTokenValue.lightDark('#FFA0C8', '#FFA0C8'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#822050', '#580030'),
    '--color-text-pink': AstryxTokenValue.lightDark('#822050', '#580030'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#DDD0FF',
      '#DDD0FF',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#C0AAFF', '#C0AAFF'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#453080', '#201058'),
    '--color-text-purple': AstryxTokenValue.lightDark('#453080', '#201058'),
    '--color-background-cyan': AstryxTokenValue.lightDark('#A8F0E2', '#A8F0E2'),
    '--color-border-cyan': AstryxTokenValue.lightDark('#70E8D0', '#70E8D0'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#005548', '#003028'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#005548', '#003028'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#FFCCA0',
      '#FFCCA0',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#FFAA66', '#FFAA66'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#703500', '#4a1800'),
    '--color-text-orange': AstryxTokenValue.lightDark('#703500', '#4a1800'),
    '--color-background-teal': AstryxTokenValue.lightDark('#A8EED0', '#A8EED0'),
    '--color-border-teal': AstryxTokenValue.lightDark('#78E0B0', '#78E0B0'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#005530', '#003018'),
    '--color-text-teal': AstryxTokenValue.lightDark('#005530', '#003018'),
    '--color-background-gray': AstryxTokenValue.lightDark('#ede0d4', '#ede0d4'),
    '--color-border-gray': AstryxTokenValue.lightDark('#dfd2c6', '#dfd2c6'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#4f453b', '#2d241b'),
    '--color-text-gray': AstryxTokenValue.lightDark('#4f453b', '#2d241b'),
    '--radius-none': AstryxTokenValue('0px'),
    '--radius-inner': AstryxTokenValue('0px'),
    '--radius-element': AstryxTokenValue('0px'),
    '--radius-container': AstryxTokenValue('0px'),
    '--radius-page': AstryxTokenValue('0px'),
    '--radius-full': AstryxTokenValue('0px'),
    '--shadow-low': AstryxTokenValue(
      '0 2px 4px #2d241b0D, 0 4px 8px #2d241b1A',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #2d241b0D, 0 4px 12px #2d241b1A',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 6px #2d241b1A, 0 12px 24px #2d241b26',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #2d241b30'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #2d241b50',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #3a550050',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #61440050',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #8b1d2450'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    'text': <String, AstryxStyleOverrides>{
      'type:display-1': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Crimson Text", Georgia, "Times New Roman", Times, serif',
        },
      ),
      'type:display-2': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Crimson Text", Georgia, "Times New Roman", Times, serif',
        },
      ),
      'type:display-3': AstryxStyleOverrides(
        properties: <String, String>{
          'fontFamily':
              '"Crimson Text", Georgia, "Times New Roman", Times, serif',
        },
      ),
    },
    'top-nav-item': <String, AstryxStyleOverrides>{
      'selected': AstryxStyleOverrides(
        properties: <String, String>{
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
          'borderRadius': '0px',
          'borderWidth': '1px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-border)',
        },
      ),
      'variant:primary': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-text-primary)',
          'color': 'var(--color-background-body)',
          'borderColor': 'transparent',
        },
      ),
      'variant:secondary': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-green)',
          'borderWidth': '1px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-text-green)',
          'color': 'var(--color-text-green)',
        },
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'var(--color-border-green)',
          },
        },
      ),
      'variant:ghost': AstryxStyleOverrides(
        properties: <String, String>{
          'borderColor': 'transparent',
        },
      ),
      'variant:destructive': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-background-red)',
          'color': 'var(--color-text-red)',
          'borderWidth': '1px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-text-red)',
        },
      ),
    },
    'badge': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': '9999px',
          'borderWidth': '1.5px',
          'borderStyle': 'solid',
          'borderColor': 'color-mix(in srgb, currentColor 30%, transparent)',
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
          'borderRadius': '0px',
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
    'field': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': '0px',
        },
      ),
    },
    'card': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'borderRadius': '0px',
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

/// The `y2k` theme, resolved.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: y2kTheme, home: const HomePage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme y2kTheme = defineTheme(y2kThemeInput);
