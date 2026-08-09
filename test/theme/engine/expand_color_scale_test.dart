import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/engine/contrast.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/hct.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// The three tokens that exist only when a seed accent is supplied.
const _accentTokens = <String>[
  '--color-accent',
  '--color-accent-muted',
  '--color-on-accent',
];

const _defaultAccent = '#0064E0';
const _defaultAccentDark = '#2694FE';

final _lightDark = RegExp(r'^light-dark\((.+?),\s*(.+)\)$');

/// Splits a `light-dark(a, b)` token into its light and dark halves. A
/// single-value token applies to both modes.
(String light, String dark) _splitLightDark(String value) {
  final match = _lightDark.firstMatch(value);
  if (match == null) return (value, value);
  return (match.group(1)!, match.group(2)!);
}

String _resolve(Map<String, String> tokens, String name, {required bool dark}) {
  final (light, darkHalf) = _splitLightDark(tokens[name]!);
  return dark ? darkHalf : light;
}

/// Resolves one mode of an alpha token, composited over its backdrop.
String _resolveComposited(
  Map<String, String> tokens,
  String name,
  String backdrop, {
  required bool dark,
}) {
  final fg = parseColor(_resolve(tokens, name, dark: dark))!;
  final bg = parseColor(backdrop)!;
  return formatColor(compositeOver(fg, bg));
}

/// Parity and guarantee tests for the colour scale expander.
void main() {
  group('expandColorScale', () {
    test('produces every expected token key', () {
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      const expectedKeys = <String>[
        '--color-accent',
        '--color-accent-muted',
        '--color-on-accent',
        '--color-neutral',
        '--color-background-surface',
        '--color-background-body',
        '--color-overlay',
        '--color-overlay-hover',
        '--color-overlay-pressed',
        '--color-background-muted',
        '--color-text-primary',
        '--color-text-secondary',
        '--color-text-disabled',
        '--color-text-accent',
        '--color-icon-accent',
        '--color-icon-primary',
        '--color-icon-secondary',
        '--color-icon-disabled',
        '--color-background-card',
        '--color-background-popover',
        '--color-background-inverted',
        '--color-border',
        '--color-border-emphasized',
        '--color-skeleton',
        '--color-track',
        '--color-shadow',
        '--color-tint-hover',
      ];
      for (final key in expectedKeys) {
        expect(tokens, contains(key));
      }
      expect(tokens, hasLength(expectedKeys.length));
    });

    test('every generated key is a known token', () {
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      for (final key in tokens.keys) {
        expect(astryxTokenDefaults, contains(key), reason: key);
      }
    });

    test('the neutral styles produce different --color-neutral values', () {
      String neutral(AstryxNeutralStyle style) => expandColorScale(
        AstryxColorScaleConfig(accent: _defaultAccent, neutralStyle: style),
      )['--color-neutral']!;

      expect(
        neutral(AstryxNeutralStyle.warm),
        isNot(neutral(AstryxNeutralStyle.cool)),
      );
      expect(
        neutral(AstryxNeutralStyle.cool),
        isNot(neutral(AstryxNeutralStyle.neutral)),
      );
      expect(
        neutral(AstryxNeutralStyle.warm),
        isNot(neutral(AstryxNeutralStyle.neutral)),
      );
    });

    test('emits the derived accent tokens as --color-accent references', () {
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      // Reference tokens follow a scoped --color-accent override at runtime.
      expect(tokens['--color-text-accent'], 'var(--color-accent)');
      expect(tokens['--color-icon-accent'], 'var(--color-accent)');
      expect(
        tokens['--color-accent-muted'],
        'light-dark(color-mix(in srgb, var(--color-accent) 20%, transparent), '
        'color-mix(in srgb, var(--color-accent) 25%, transparent))',
      );
      // The base token and the contrast-computed on-accent stay resolved.
      expect(tokens['--color-accent'], startsWith('light-dark(#'));
      expect(tokens['--color-on-accent'], startsWith('light-dark(#'));
    });

    test('high contrast changes --color-text-primary', () {
      final standard = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      final high = expandColorScale(
        const AstryxColorScaleConfig(
          accent: _defaultAccent,
          contrast: AstryxContrastLevel.high,
        ),
      );
      expect(
        high['--color-text-primary'],
        isNot(standard['--color-text-primary']),
      );
    });
  });

  group('expandColorScale — neutral-only themes', () {
    test('an accent-less config still expands', () {
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm),
      );
      expect(
        tokens['--color-background-surface'],
        startsWith('light-dark(#'),
      );
    });

    test('an empty config expands and omits --color-accent', () {
      final tokens = expandColorScale(const AstryxColorScaleConfig());
      expect(
        tokens['--color-background-surface'],
        startsWith('light-dark(#'),
      );
      expect(tokens, isNot(contains('--color-accent')));
    });

    test('omits the accent tokens so they fall through to the defaults', () {
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm),
      );
      for (final key in _accentTokens) {
        expect(tokens, isNot(contains(key)));
      }
      // The reference tokens still point at whatever --color-accent
      // resolves to.
      expect(tokens['--color-text-accent'], 'var(--color-accent)');
      expect(tokens['--color-icon-accent'], 'var(--color-accent)');
    });

    test('seeds the neutrals from the light half of the default accent', () {
      // Drift guard. Re-colouring the default accent without re-seeding would
      // silently change every neutral-only theme.
      expect(
        astryxTokenDefaults['--color-accent'],
        'light-dark($_defaultAccent, $_defaultAccentDark)',
      );

      final neutralOnly = expandColorScale(
        const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm),
      );
      final seeded = expandColorScale(
        const AstryxColorScaleConfig(
          accent: _defaultAccent,
          neutralStyle: AstryxNeutralStyle.warm,
        ),
      );
      for (final entry in seeded.entries) {
        if (_accentTokens.contains(entry.key)) continue;
        expect(neutralOnly[entry.key], entry.value, reason: entry.key);
      }
    });

    test('honours neutralStyle and contrast without an accent', () {
      expect(
        expandColorScale(
          const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.warm),
        )['--color-neutral'],
        isNot(
          expandColorScale(
            // Naming the default is the point: this asserts warm ≠ cool.
            // ignore: avoid_redundant_argument_values
            const AstryxColorScaleConfig(neutralStyle: AstryxNeutralStyle.cool),
          )['--color-neutral'],
        ),
      );
      expect(
        expandColorScale(
          const AstryxColorScaleConfig(contrast: AstryxContrastLevel.high),
        )['--color-text-primary'],
        isNot(
          expandColorScale(
            const AstryxColorScaleConfig(),
          )['--color-text-primary'],
        ),
      );
    });

    test('does not re-colour themes that do pass an accent', () {
      // Seeding from the default hex derives a *different* accent than the
      // default token holds, so "just default the seed" would not be
      // behaviour-preserving. Omitting the tokens is the only way a
      // neutral-only theme keeps the default accent.
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      expect(tokens['--color-accent'], startsWith('light-dark(#'));
      expect(
        tokens['--color-accent'],
        isNot(astryxTokenDefaults['--color-accent']),
      );
    });

    test('treats an empty accent as supplied, not absent', () {
      // '' is falsy but not null. Only an absent accent is neutral-only; a
      // supplied-but-malformed one keeps the old behaviour, where the hex
      // parser falls back to black.
      final tokens = expandColorScale(const AstryxColorScaleConfig(accent: ''));
      for (final key in _accentTokens) {
        expect(tokens, contains(key));
      }
    });
  });

  group('WCAG contrast guarantees', () {
    // Representative configurations: the docs' default accent, both contrast
    // levels, every neutral style, saturated brand accents across the hue
    // wheel, a low-chroma seed, and degenerate black and white seeds.
    const configs = <AstryxColorScaleConfig>[
      AstryxColorScaleConfig(accent: _defaultAccent),
      AstryxColorScaleConfig(
        accent: _defaultAccent,
        contrast: AstryxContrastLevel.high,
      ),
      AstryxColorScaleConfig(
        accent: '#DC2626',
        neutralStyle: AstryxNeutralStyle.warm,
      ),
      AstryxColorScaleConfig(
        accent: '#B7410E',
        neutralStyle: AstryxNeutralStyle.warm,
        contrast: AstryxContrastLevel.high,
      ),
      AstryxColorScaleConfig(
        accent: '#12B76A',
        neutralStyle: AstryxNeutralStyle.neutral,
      ),
      AstryxColorScaleConfig(
        accent: '#D9006E',
        neutralStyle: AstryxNeutralStyle.warm,
      ),
      AstryxColorScaleConfig(accent: '#657100'),
      AstryxColorScaleConfig(accent: '#6B7280'),
      AstryxColorScaleConfig(accent: '#000000'),
      AstryxColorScaleConfig(
        accent: '#FFFFFF',
        neutralStyle: AstryxNeutralStyle.neutral,
        contrast: AstryxContrastLevel.high,
      ),
    ];

    for (final config in configs) {
      for (final dark in <bool>[false, true]) {
        final mode = dark ? 'dark' : 'light';

        test('$config: text meets 4.5:1 on its surfaces ($mode)', () {
          final tokens = expandColorScale(config);
          final surface = _resolve(
            tokens,
            '--color-background-surface',
            dark: dark,
          );
          final body = _resolve(tokens, '--color-background-body', dark: dark);
          final card = _resolve(tokens, '--color-background-card', dark: dark);
          final popover = _resolve(
            tokens,
            '--color-background-popover',
            dark: dark,
          );
          // Alpha tokens paint over the surface — composite before measuring.
          final muted = _resolveComposited(
            tokens,
            '--color-background-muted',
            surface,
            dark: dark,
          );
          final neutral = _resolveComposited(
            tokens,
            '--color-neutral',
            surface,
            dark: dark,
          );

          final textPrimary = _resolve(
            tokens,
            '--color-text-primary',
            dark: dark,
          );
          final textSecondary = _resolve(
            tokens,
            '--color-text-secondary',
            dark: dark,
          );
          final accent = _resolve(tokens, '--color-accent', dark: dark);
          final onAccent = _resolve(tokens, '--color-on-accent', dark: dark);

          // Primary text on every generated background it renders on.
          for (final bg in <String>[
            surface,
            body,
            card,
            popover,
            muted,
            neutral,
          ]) {
            expect(
              contrastRatio(textPrimary, bg),
              greaterThanOrEqualTo(4.5),
              reason: '$textPrimary on $bg',
            );
          }
          // Secondary text on the main content surfaces.
          for (final bg in <String>[surface, body, card, popover]) {
            expect(
              contrastRatio(textSecondary, bg),
              greaterThanOrEqualTo(4.5),
              reason: '$textSecondary on $bg',
            );
          }
          // Accent-coloured text — --color-text-accent references the accent.
          expect(contrastRatio(accent, surface), greaterThanOrEqualTo(4.5));
          // Label text on accent-filled controls, such as primary buttons.
          expect(contrastRatio(onAccent, accent), greaterThanOrEqualTo(4.5));
        });

        test('$config: non-text UI meets 3:1 on the surface ($mode)', () {
          final tokens = expandColorScale(config);
          final surface = _resolve(
            tokens,
            '--color-background-surface',
            dark: dark,
          );

          for (final token in <String>[
            // Accent-filled controls and focus indicators.
            '--color-accent',
            // Meaningful icons alongside text.
            '--color-icon-primary',
            '--color-icon-secondary',
            // Form-control boundaries.
            '--color-border-emphasized',
          ]) {
            expect(
              contrastRatio(_resolve(tokens, token, dark: dark), surface),
              greaterThanOrEqualTo(3),
              reason: token,
            );
          }
        });
      }
    }

    test('the decorative tokens excluded from 3:1 stay decorative', () {
      // --color-border is a hairline separator, roughly 1.1:1 by design;
      // --color-skeleton conveys no information; --color-track sits behind a
      // 3:1 indicator; disabled text is explicitly exempt from WCAG 1.4.3.
      // Locking in the alpha form of --color-border means a future change
      // that starts relying on it for contrast shows up here.
      final tokens = expandColorScale(
        const AstryxColorScaleConfig(accent: _defaultAccent),
      );
      final (light, dark) = _splitLightDark(tokens['--color-border']!);
      for (final half in <String>[light, dark]) {
        final parsed = parseColor(half);
        expect(parsed, isNotNull, reason: half);
        expect(parsed!.a, lessThanOrEqualTo(0.2));
      }
    });
  });

  group('--color-border-emphasized WCAG 1.4.11 correction', () {
    // The one generated token whose emitted value is corrected. Its preferred
    // tones — neutral-variant 70 light, 30 dark — land below the 3:1 floor
    // against the generated surface, so the generator bumps them until they
    // clear it. Reconstructing the uncorrected output locks in the delta.
    const config = AstryxColorScaleConfig(accent: _defaultAccent);
    final hue = hexToHct(_defaultAccent).hue;
    final variants = tonalPalette(hue, AstryxNeutralStyle.cool.variantChroma);
    final tokens = expandColorScale(config);

    test('light: the uncorrected tone 70 is about 2.24:1 and is raised', () {
      final surface = _resolve(
        tokens,
        '--color-background-surface',
        dark: false,
      );
      final oldValue = variants[70]!;
      final newValue = _resolve(
        tokens,
        '--color-border-emphasized',
        dark: false,
      );
      expect(contrastRatio(oldValue, surface), closeTo(2.24, 0.05));
      expect(contrastRatio(oldValue, surface), lessThan(3));
      expect(newValue, isNot(oldValue));
      expect(contrastRatio(newValue, surface), greaterThanOrEqualTo(3));
    });

    test('dark: the uncorrected tone 30 is about 1.84:1 and is raised', () {
      final surface = _resolve(
        tokens,
        '--color-background-surface',
        dark: true,
      );
      final oldValue = variants[30]!;
      final newValue = _resolve(
        tokens,
        '--color-border-emphasized',
        dark: true,
      );
      expect(contrastRatio(oldValue, surface), closeTo(1.84, 0.05));
      expect(contrastRatio(oldValue, surface), lessThan(3));
      expect(newValue, isNot(oldValue));
      expect(contrastRatio(newValue, surface), greaterThanOrEqualTo(3));
    });
  });

  group('ensureContrastTone', () {
    test('returns the starting tone when it already meets the ratio', () {
      // Tone 10 on a near-white background is far past 4.5:1 already.
      expect(
        ensureContrastTone(282, 8, 10, -1, '#FCFDFE', 4.5),
        ensureContrastTone(282, 8, 10, 1, '#FCFDFE', 1),
      );
    });

    test('bumps the tone until the ratio passes', () {
      // Tone 70 sits around 2.2:1 on a near-white surface — below 3:1.
      final before = ensureContrastTone(282, 8, 70, -1, '#FCFDFE', 1);
      expect(contrastRatio(before, '#FCFDFE'), lessThan(3));
      final after = ensureContrastTone(282, 8, 70, -1, '#FCFDFE', 3);
      expect(contrastRatio(after, '#FCFDFE'), greaterThanOrEqualTo(3));
    });

    test('terminates at the tone floor and ceiling for impossible ratios', () {
      // 22:1 is unreachable; the loop must stop at pure black or white.
      expect(ensureContrastTone(282, 8, 70, -1, '#FFFFFF', 22), '#000000');
      expect(ensureContrastTone(282, 8, 30, 1, '#000000', 22), '#FFFFFF');
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('expand_color_scale'));

    test('matches upstream for every recorded configuration', () {
      final cases = asObjects(fixture['cases']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final json = c['config']! as Map<String, dynamic>;
        final config = AstryxColorScaleConfig(
          accent: json['accent'] as String?,
          neutralStyle: switch (json['neutralStyle'] as String?) {
            'warm' => AstryxNeutralStyle.warm,
            'neutral' => AstryxNeutralStyle.neutral,
            _ => AstryxNeutralStyle.cool,
          },
          contrast: json['contrast'] == 'high'
              ? AstryxContrastLevel.high
              : AstryxContrastLevel.standard,
        );
        expect(expandColorScale(config), c['tokens'], reason: '$json');
      }
    });

    test('ensureContrastTone matches upstream for every recorded walk', () {
      for (final c in asObjects(fixture['ensureContrastTone'])) {
        expect(
          ensureContrastTone(
            asDouble(c['hue']),
            asDouble(c['chroma']),
            asDouble(c['startTone']),
            (c['step']! as num).toInt(),
            c['background']! as String,
            asDouble(c['minRatio']),
          ),
          c['hex'],
          reason: '$c',
        );
      }
    });
  });
}
