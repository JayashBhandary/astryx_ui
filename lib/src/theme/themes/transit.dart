// Hand-authored. Not a transcription of an upstream `defineTheme` call — the
// seven themes beside this one are generated from `astryx-0.3.0`, this one is
// not, and `mirror-upstream` has nothing to say about it.
//
// Every colour pair in here was solved for a contrast ratio rather than picked
// by eye. The floors, and why they are the floors:
//
//   text on any surface it can land on          >= 4.5   WCAG 2.1 AA, 1.4.3
//   the foreground of a filled control          >= 4.5   same, and the reason
//                                                        `--color-on-success`
//                                                        is not the fill
//   a control's boundary, a focus ring          >= 3.0   WCAG 2.1 AA, 1.4.11
//
// "Any surface it can land on" includes `--color-background-muted`, which is
// the darkest light surface and the lightest dark one, so it is the surface
// every text and border token here was solved against.

// Font fallback stacks are one string each; reflowing them would change the
// token value.
// ignore_for_file: lines_longer_than_80_chars

/// The Astryx `transit` theme — for departure boards, tickets and itineraries.
library;

import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';

/// The definition of the `transit` theme, before the engine runs over it.
///
/// A transport theme: a signal blue accent, a cool slate neutral, and the
/// squarer corners of printed signage. Exposed so a consumer can extend it —
/// `AstryxDefineThemeInput(extendsTheme: transitTheme, …)` — or read what it
/// configures.
///
/// Three things it does deliberately differently from the themes beside it:
///
/// * `--color-on-success`, `--color-on-error` and `--color-on-warning` are a
///   near-white and a near-black, never the fill they sit on. A badge or a
///   stepper indicator painted from those pairs is legible in both modes.
/// * `--color-text-secondary` clears 4.5:1 on every surface including
///   `--color-background-muted`, because supporting copy is body text and the
///   rule does not care that it is supporting.
/// * `--color-border-emphasized` clears 3:1 on every surface, because it draws
///   the boundary of the secondary button and a boundary is a control.
const AstryxDefineThemeInput transitThemeInput = AstryxDefineThemeInput(
  name: 'transit',
  typography: AstryxTypographyConfig(
    scale: AstryxTypeScaleSpec(base: 14, ratio: 1.22),
    body: AstryxTypographyRole(
      family: 'Inter',
      fallbacks:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
    ),
    // Signage is set condensed because a platform name has to fit a fixed
    // board. Headings borrow that; body copy does not, because an itinerary is
    // read at arm's length rather than across a concourse.
    heading: AstryxTypographyRole(
      family: 'Archivo',
      fallbacks:
          '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
      weights: <int, AstryxFontWeight>{
        3: AstryxFontWeight('bold'),
        4: AstryxFontWeight('bold'),
      },
    ),
    code: AstryxTypographyRole(
      family: 'IBM Plex Mono',
      fallbacks: '"SF Mono", Monaco, Consolas, monospace',
    ),
  ),
  // Squarer than the default. A ticket, a boarding pass and a platform sign
  // are all rectangles with a small radius; a pill-shaped departure row reads
  // as a chat bubble.
  radius: AstryxRadiusScaleConfig(base: 4, multiplier: 0.75),
  motion: AstryxMotionScaleConfig(
    fast: 120,
    medium: 260,
    slow: 620,
    ratio: 0.75,
  ),
  syntax: AstryxSyntaxTheme(
    name: 'xds-transit',
    tokens: <String, String>{
      'keyword': 'light-dark(#6e2eb8, #b590df)',
      'string': 'light-dark(#207e4f, #69d39e)',
      'comment': 'light-dark(#636d83, #969fb0)',
      'number': 'light-dark(#a55a18, #d39b69)',
      'function': 'light-dark(#2268c3, #79a2d8)',
      'type': 'light-dark(#6e2eb8, #b590df)',
      'variable': 'light-dark(#5c6b8a, #94a0b8)',
      'operator': 'light-dark(#636d83, #969fb0)',
      'constant': 'light-dark(#a55a18, #d39b69)',
      'tag': 'light-dark(#bd3228, #db8a84)',
      'attribute': 'light-dark(#866918, #d3b769)',
      'property': 'light-dark(#247b6f, #69d3c5)',
      'punctuation': 'light-dark(#656e81, #98a0ae)',
      'background': 'light-dark(#f2f5fa, #0b1220)',
    },
  ),
  tokens: <String, AstryxTokenValue>{
    // ---------------------------------------------------------------------
    // Accent and surfaces
    // ---------------------------------------------------------------------
    '--color-accent': AstryxTokenValue.lightDark('#0b57c7', '#7fb2ff'),
    '--color-accent-muted': AstryxTokenValue.lightDark(
      '#0b57c714',
      '#7fb2ff24',
    ),
    '--color-neutral': AstryxTokenValue.lightDark('#0f172914', '#eef2fb1a'),
    '--color-background-body': AstryxTokenValue.lightDark('#f2f5fa', '#080d18'),
    '--color-background-surface': AstryxTokenValue.lightDark(
      '#ffffff',
      '#101827',
    ),
    '--color-background-card': AstryxTokenValue.lightDark('#ffffff', '#141d30'),
    '--color-background-popover': AstryxTokenValue.lightDark(
      '#ffffff',
      '#141d30',
    ),
    '--color-background-muted': AstryxTokenValue.lightDark(
      '#e4e9f2',
      '#26314a',
    ),
    '--color-background-inverted': AstryxTokenValue.lightDark(
      '#0f1729',
      '#eef2fb',
    ),
    '--color-overlay': AstryxTokenValue.lightDark('#0f172999', '#04080fcc'),
    '--color-overlay-hover': AstryxTokenValue.lightDark(
      '#0f17290d',
      '#eef2fb0d',
    ),
    '--color-overlay-pressed': AstryxTokenValue.lightDark(
      '#0f17291a',
      '#eef2fb1a',
    ),

    // ---------------------------------------------------------------------
    // Text and icons
    //
    // `secondary` is solved against `--color-background-muted`, the worst
    // surface in each mode: 4.67:1 light, 4.69:1 dark, and higher everywhere
    // else. `disabled` is exempt from 1.4.3 and is tuned for "visibly off"
    // rather than for a ratio.
    // ---------------------------------------------------------------------
    '--color-text-primary': AstryxTokenValue.lightDark('#0f1729', '#eef2fb'),
    '--color-text-secondary': AstryxTokenValue.lightDark('#5a6781', '#8f9cb7'),
    '--color-text-disabled': AstryxTokenValue.lightDark('#b5bac5', '#464c59'),
    '--color-text-accent': AstryxTokenValue.lightDark('#0b57c7', '#7fb2ff'),
    '--color-icon-primary': AstryxTokenValue.lightDark('#0f1729', '#eef2fb'),
    '--color-icon-secondary': AstryxTokenValue.lightDark('#5a6781', '#8f9cb7'),
    '--color-icon-disabled': AstryxTokenValue.lightDark('#b5bac5', '#464c59'),
    '--color-icon-accent': AstryxTokenValue.lightDark('#0b57c7', '#7fb2ff'),

    // ---------------------------------------------------------------------
    // Foregrounds on a fill
    //
    // Each of these is measured against the fill it names, not against the
    // page: `--color-on-success` sits on `--color-success` and nowhere else.
    // ---------------------------------------------------------------------
    '--color-on-dark': AstryxTokenValue('#FFFFFF'),
    '--color-on-light': AstryxTokenValue('#0f1729'),
    '--color-on-accent': AstryxTokenValue.lightDark('#ffffff', '#05122a'),
    '--color-on-success': AstryxTokenValue.lightDark('#ffffff', '#05122a'),
    '--color-on-error': AstryxTokenValue.lightDark('#ffffff', '#05122a'),
    '--color-on-warning': AstryxTokenValue.lightDark('#ffffff', '#05122a'),

    // ---------------------------------------------------------------------
    // Status
    //
    // The solid fills carry `--color-on-*` at 4.9:1 or better, and read as
    // text on the page at 4.5:1 or better. The muted fills are the green, red
    // and yellow families below, so a banner and a badge of the same severity
    // agree.
    // ---------------------------------------------------------------------
    '--color-success': AstryxTokenValue.lightDark('#0e8147', '#4dcb8c'),
    '--color-success-muted': AstryxTokenValue.lightDark('#dbf5e8', '#2b503d'),
    '--color-error': AstryxTokenValue.lightDark('#c12115', '#eb7d75'),
    '--color-error-muted': AstryxTokenValue.lightDark('#f6dcda', '#552926'),
    '--color-warning': AstryxTokenValue.lightDark('#9b6508', '#e2b05a'),
    '--color-warning-muted': AstryxTokenValue.lightDark('#f6efda', '#574923'),

    // ---------------------------------------------------------------------
    // Lines and fills that are not text
    // ---------------------------------------------------------------------
    '--color-border': AstryxTokenValue.lightDark('#d5dce8', '#eef2fb1f'),
    '--color-border-emphasized': AstryxTokenValue.lightDark(
      '#74819a',
      '#74819a',
    ),
    '--color-skeleton': AstryxTokenValue.lightDark('#dde3ee', '#26314a'),
    '--color-shadow': AstryxTokenValue.lightDark('#0f17291f', '#0000005c'),
    '--color-tint-hover': AstryxTokenValue.lightDark('black', 'white'),
    '--text-supporting-size': AstryxTokenValue('12px'),

    // ---------------------------------------------------------------------
    // The ten categorical families
    //
    // Line colours, not severities: "the Blue line", "the Orange line". Each
    // family's text clears 4.5:1 on its own background in both modes — the
    // range is 4.6 to 6.8 — so a route badge is readable wherever it lands.
    // ---------------------------------------------------------------------
    '--color-background-blue': AstryxTokenValue.lightDark('#dae6f6', '#253a55'),
    '--color-border-blue': AstryxTokenValue.lightDark('#b8ceea', '#1a293d'),
    '--color-icon-blue': AstryxTokenValue.lightDark('#125bba', '#8db2e2'),
    '--color-text-blue': AstryxTokenValue.lightDark('#125bba', '#8db2e2'),
    '--color-background-cyan': AstryxTokenValue.lightDark('#daf2f6', '#264d55'),
    '--color-border-cyan': AstryxTokenValue.lightDark('#b8e2ea', '#1b363c'),
    '--color-icon-cyan': AstryxTokenValue.lightDark('#0f7185', '#8dd4e2'),
    '--color-text-cyan': AstryxTokenValue.lightDark('#0f7185', '#8dd4e2'),
    '--color-background-gray': AstryxTokenValue.lightDark('#e6e7ea', '#3a3c41'),
    '--color-border-gray': AstryxTokenValue.lightDark('#cdd0d6', '#292b2e'),
    '--color-icon-gray': AstryxTokenValue.lightDark('#525f7a', '#b0b5bf'),
    '--color-text-gray': AstryxTokenValue.lightDark('#525f7a', '#b0b5bf'),
    '--color-background-green': AstryxTokenValue.lightDark(
      '#dbf5e8',
      '#2b503d',
    ),
    '--color-border-green': AstryxTokenValue.lightDark('#b8ead1', '#1e382b'),
    '--color-icon-green': AstryxTokenValue.lightDark('#1a7a4a', '#90dfb8'),
    '--color-text-green': AstryxTokenValue.lightDark('#1a7a4a', '#90dfb8'),
    '--color-background-orange': AstryxTokenValue.lightDark(
      '#f6e7da',
      '#573b23',
    ),
    '--color-border-orange': AstryxTokenValue.lightDark('#eacfb8', '#3e2a19'),
    '--color-icon-orange': AstryxTokenValue.lightDark('#a44f04', '#e2b58d'),
    '--color-text-orange': AstryxTokenValue.lightDark('#a44f04', '#e2b58d'),
    '--color-background-pink': AstryxTokenValue.lightDark('#f6dae8', '#51293d'),
    '--color-border-pink': AstryxTokenValue.lightDark('#eab8d1', '#3a1d2b'),
    '--color-icon-pink': AstryxTokenValue.lightDark('#ad1f66', '#e28db8'),
    '--color-text-pink': AstryxTokenValue.lightDark('#ad1f66', '#e28db8'),
    '--color-background-purple': AstryxTokenValue.lightDark(
      '#e7dbf5',
      '#3c2b50',
    ),
    '--color-border-purple': AstryxTokenValue.lightDark('#cfb8ea', '#2a1e38'),
    '--color-icon-purple': AstryxTokenValue.lightDark('#6224a8', '#b590df'),
    '--color-text-purple': AstryxTokenValue.lightDark('#6224a8', '#b590df'),
    '--color-background-red': AstryxTokenValue.lightDark('#f6dcda', '#552926'),
    '--color-border-red': AstryxTokenValue.lightDark('#eabbb8', '#3c1d1b'),
    '--color-icon-red': AstryxTokenValue.lightDark('#b81f14', '#e2928d'),
    '--color-text-red': AstryxTokenValue.lightDark('#b81f14', '#e2928d'),
    '--color-background-teal': AstryxTokenValue.lightDark('#dbf5f1', '#2b504b'),
    '--color-border-teal': AstryxTokenValue.lightDark('#b8eae4', '#1e3835'),
    '--color-icon-teal': AstryxTokenValue.lightDark('#197669', '#90dfd4'),
    '--color-text-teal': AstryxTokenValue.lightDark('#197669', '#90dfd4'),
    '--color-background-yellow': AstryxTokenValue.lightDark(
      '#f6efda',
      '#574923',
    ),
    '--color-border-yellow': AstryxTokenValue.lightDark('#eaddb8', '#3e3419'),
    '--color-icon-yellow': AstryxTokenValue.lightDark('#886507', '#e2cc8d'),
    '--color-text-yellow': AstryxTokenValue.lightDark('#886507', '#e2cc8d'),

    // ---------------------------------------------------------------------
    // Shape and elevation
    // ---------------------------------------------------------------------
    '--radius-full': AstryxTokenValue('9999px'),
    '--shadow-low': AstryxTokenValue(
      '0 1px 2px #0f172914, 0 2px 6px #0f17291a',
    ),
    '--shadow-med': AstryxTokenValue(
      '0 2px 4px #0f172914, 0 6px 14px #0f17291f',
    ),
    '--shadow-high': AstryxTokenValue(
      '0 4px 8px #0f17291f, 0 16px 32px #0f172929',
    ),
    '--shadow-inset-hover': AstryxTokenValue('inset 0px 0px 0px 2px #0b57c733'),
    '--shadow-inset-selected': AstryxTokenValue(
      'inset 0px 0px 0px 2px #0b57c766',
    ),
    '--shadow-inset-success': AstryxTokenValue(
      'inset 0px 0px 0px 2px #0e814740',
    ),
    '--shadow-inset-warning': AstryxTokenValue(
      'inset 0px 0px 0px 2px #9b650840',
    ),
    '--shadow-inset-error': AstryxTokenValue('inset 0px 0px 0px 2px #c1211540'),
  },
  components: <String, Map<String, AstryxStyleOverrides>>{
    // The secondary button is an outline, and its outline is the emphasised
    // border rather than the hairline one: a control boundary owes 3:1, and
    // `--color-border` is a separator that does not.
    'button': <String, AstryxStyleOverrides>{
      'variant:secondary': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'transparent',
          'borderWidth': '1px',
          'borderStyle': 'solid',
          'borderColor': 'var(--color-border-emphasized)',
        },
        pseudo: <String, Map<String, String>>{
          ':hover': <String, String>{
            'backgroundColor': 'var(--color-neutral)',
          },
        },
      ),
    },
    // Badges are the route and status chips on every screen in this theme, so
    // they take the family pairs, which are solved against each other, rather
    // than the solid fills.
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
    'progressbar-track': <String, AstryxStyleOverrides>{
      'base': AstryxStyleOverrides(
        properties: <String, String>{
          'backgroundColor': 'var(--color-skeleton)',
        },
      ),
    },
  },
);

/// The `transit` theme, resolved.
///
/// A transport palette — a signal blue accent, cool slate neutrals, squarer
/// corners — solved for WCAG 2.1 AA rather than picked by eye.
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(theme: transitTheme, home: const DeparturesPage());
/// ```
/// {@end-tool}
final AstryxDefinedTheme transitTheme = defineTheme(transitThemeInput);
