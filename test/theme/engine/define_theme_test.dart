import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:astryx_ui/src/theme/engine/on_media_tokens.dart';
import 'package:astryx_ui/src/theme/engine/style_overrides.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:astryx_ui/src/theme/engine/typography_config.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';
import '../../support/theme_input.dart';

/// Behaviour and parity tests for `defineTheme` and the theme registry.
void main() {
  tearDown(resetThemes);

  group('precedence', () {
    test('an explicit token beats a colour-scale-generated one', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'explicit-wins',
          color: AstryxColorScaleConfig(accent: '#0064E0'),
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('red'),
          },
        ),
      );
      expect(theme.tokens['--color-accent'], 'red');
    });

    test('an explicit token beats every generator', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'explicit-wins-everywhere',
          color: AstryxColorScaleConfig(accent: '#DC2626'),
          typography: AstryxTypographyConfig(
            scale: AstryxTypeScaleSpec(base: 16, ratio: 1.25),
          ),
          radius: AstryxRadiusScaleConfig(base: 6, multiplier: 1.5),
          motion: AstryxMotionScaleConfig(fast: 100, medium: 250, ratio: 0.8),
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('#123456'),
            '--font-size-base': AstryxTokenValue('2rem'),
            '--radius-element': AstryxTokenValue('1px'),
            '--duration-fast': AstryxTokenValue('1ms'),
          },
        ),
      );
      expect(theme.tokens['--color-accent'], '#123456');
      expect(theme.tokens['--font-size-base'], '2rem');
      expect(theme.tokens['--radius-element'], '1px');
      expect(theme.tokens['--duration-fast'], '1ms');
    });

    test('a base theme sits below everything', () {
      final base = defineTheme(
        const AstryxDefineThemeInput(
          name: 'base',
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('#111111'),
            '--color-success': AstryxTokenValue('#222222'),
          },
        ),
      );
      final derived = defineTheme(
        AstryxDefineThemeInput(
          name: 'derived',
          extendsTheme: base,
          tokens: const <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue('#333333'),
          },
        ),
      );
      expect(derived.tokens['--color-accent'], '#333333');
      // Untouched base tokens carry through.
      expect(derived.tokens['--color-success'], '#222222');
    });

    test('a light/dark pair becomes a light-dark() string', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'tuple',
          tokens: <String, AstryxTokenValue>{
            '--color-accent': AstryxTokenValue.lightDark('#AA0000', '#FF5555'),
          },
        ),
      );
      expect(theme.tokens['--color-accent'], 'light-dark(#AA0000, #FF5555)');
      // …and the original pair survives on the theme.
      expect(
        theme.inputTokens!['--color-accent'],
        const AstryxTokenValue.lightDark('#AA0000', '#FF5555'),
      );
    });
  });

  group('typography', () {
    test('quotes a font family containing a space', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'fonts',
          typography: AstryxTypographyConfig(
            body: AstryxTypographyRole(
              family: 'Geist Mono',
              fallbacks: 'monospace',
            ),
          ),
        ),
      );
      expect(theme.tokens['--font-family-body'], '"Geist Mono", monospace');
    });

    test('leaves a single-word family unquoted', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'fonts-unquoted',
          typography: AstryxTypographyConfig(
            code: AstryxTypographyRole(family: 'ui-monospace'),
          ),
        ),
      );
      expect(theme.tokens['--font-family-code'], 'ui-monospace');
    });

    test('the heading family falls back to the body family', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'heading-inherits',
          typography: AstryxTypographyConfig(
            body: AstryxTypographyRole(
              family: 'Inter',
              fallbacks: 'sans-serif',
            ),
            heading: AstryxTypographyRole(weight: AstryxFontWeight.bold),
          ),
        ),
      );
      expect(theme.tokens['--font-family-heading'], 'Inter, sans-serif');
    });

    test('generates no typography tokens without a scale', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'no-scale',
          typography: AstryxTypographyConfig(
            body: AstryxTypographyRole(family: 'Figtree'),
          ),
        ),
      );
      expect(theme.tokens, isNot(contains('--font-size-base')));
      expect(theme.tokens['--font-family-body'], 'Figtree');
    });

    test('a role weight fills the levels the per-level map leaves alone', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'weights',
          typography: AstryxTypographyConfig(
            scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
            heading: AstryxTypographyRole(
              weight: AstryxFontWeight.bold,
              weights: <int, AstryxFontWeight>{3: AstryxFontWeight.normal},
            ),
          ),
        ),
      );
      expect(
        theme.tokens['--text-heading-3-weight'],
        'var(--font-weight-normal)',
      );
      expect(
        theme.tokens['--text-heading-1-weight'],
        'var(--font-weight-bold)',
      );
    });

    test('a raw CSS weight passes through unmapped', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'raw-weight',
          typography: AstryxTypographyConfig(
            scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
            code: AstryxTypographyRole(weight: AstryxFontWeight('800')),
          ),
        ),
      );
      expect(theme.tokens['--text-code-weight'], '800');
    });
  });

  group('components', () {
    test('explicit component styles merge over the generated ones', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'components',
          typography: AstryxTypographyConfig(
            scale: AstryxTypeScaleSpec(base: 14, ratio: 1.2),
          ),
          components: <String, Map<String, AstryxStyleOverrides>>{
            'heading': <String, AstryxStyleOverrides>{
              'level:1': AstryxStyleOverrides(
                properties: <String, String>{'fontWeight': '800'},
              ),
            },
          },
        ),
      );
      final h1 = theme.components!['heading']!['level:1']!;
      // The override wins…
      expect(h1.properties['fontWeight'], '800');
      // …and the generated siblings survive.
      expect(h1.properties['fontSize'], 'var(--text-heading-1-size)');
      expect(h1.properties['lineHeight'], 'var(--text-heading-1-leading)');
    });

    test('components pass through untouched without a type scale', () {
      const components = <String, Map<String, AstryxStyleOverrides>>{
        'button': <String, AstryxStyleOverrides>{
          'base': AstryxStyleOverrides(
            properties: <String, String>{'fontWeight': '600'},
            pseudo: <String, Map<String, String>>{
              ':hover': <String, String>{'opacity': '0.9'},
            },
          ),
        },
      };
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'passthrough',
          components: components,
        ),
      );
      expect(theme.components, components);
    });
  });

  group('syntax', () {
    test('writes syntax tokens under the --color-syntax- prefix', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(
          name: 'syntax',
          syntax: AstryxSyntaxTheme(
            name: 'stub',
            tokens: <String, String>{'keyword': '#700084'},
          ),
        ),
      );
      expect(theme.tokens['--color-syntax-keyword'], '#700084');
    });
  });

  group('registry', () {
    test('defineTheme registers the theme under its name', () {
      final theme = defineTheme(
        const AstryxDefineThemeInput(name: 'registered'),
      );
      expect(getRegisteredTheme('registered'), same(theme));
      expect(getRegisteredThemes().keys, contains('registered'));
    });

    test('registration replaces an earlier theme of the same name', () {
      defineTheme(const AstryxDefineThemeInput(name: 'dup'));
      final second = defineTheme(const AstryxDefineThemeInput(name: 'dup'));
      expect(getRegisteredTheme('dup'), same(second));
      expect(getRegisteredThemes(), hasLength(1));
    });

    test('an unknown, null or empty name returns null', () {
      expect(getRegisteredTheme('missing'), isNull);
      expect(getRegisteredTheme(null), isNull);
      expect(getRegisteredTheme(''), isNull);
    });

    test('the returned map is a snapshot', () {
      defineTheme(const AstryxDefineThemeInput(name: 'snapshot'));
      getRegisteredThemes().clear();
      expect(getRegisteredTheme('snapshot'), isNotNull);
    });
  });

  group('on-media', () {
    test('resolves both surfaces even when neither is configured', () {
      final theme = defineTheme(const AstryxDefineThemeInput(name: 'media'));
      expect(theme.onDark!.tokens, astryxDefaultOnDarkTokens);
      expect(theme.onLight!.tokens, astryxDefaultOnLightTokens);
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('define_theme'));

    test('matches upstream for every recorded input', () {
      final cases = asObjects(fixture['cases']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final input = decodeThemeInput(c['input']! as Map<String, dynamic>);
        final expected = c['theme']! as Map<String, dynamic>;
        final theme = defineTheme(input);
        final reason = input.name;

        expect(theme.name, expected['name'], reason: reason);
        expect(theme.tokens, expected['tokens'], reason: reason);
        expect(
          theme.components,
          decodeComponents(expected['components'] as Map<String, dynamic>?),
          reason: reason,
        );
        expect(
          theme.onDark!.tokens,
          (expected['onDark']! as Map<String, dynamic>)['tokens'],
          reason: reason,
        );
        expect(
          theme.onLight!.tokens,
          (expected['onLight']! as Map<String, dynamic>)['tokens'],
          reason: reason,
        );
      }
    });

    test('resolved tokens match upstream in both modes', () {
      for (final c in asObjects(fixture['cases'])) {
        final input = decodeThemeInput(c['input']! as Map<String, dynamic>);
        final theme = defineTheme(input);

        for (final mode in AstryxThemeMode.values) {
          final expected =
              (mode == AstryxThemeMode.light
                      ? c['resolvedLight']!
                      : c['resolvedDark']!)
                  as Map<String, dynamic>;
          expectCoreTokensMatch(
            resolveThemeTokens(theme, mode),
            expected,
            reason: '${input.name} / ${mode.name}',
          );
        }
      }
    });

    test('the defaults alone resolve to upstream values in both modes', () {
      expectCoreTokensMatch(
        resolveThemeTokens(null, AstryxThemeMode.light),
        fixture['defaultsLight']! as Map<String, dynamic>,
        reason: 'defaults / light',
      );
      expectCoreTokensMatch(
        resolveThemeTokens(null, AstryxThemeMode.dark),
        fixture['defaultsDark']! as Map<String, dynamic>,
        reason: 'defaults / dark',
      );
    });
  });
}
