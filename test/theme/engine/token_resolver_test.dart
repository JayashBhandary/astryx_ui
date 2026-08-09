import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/engine/token_value.dart';
import 'package:flutter_test/flutter_test.dart';

/// Transcription of upstream's `tokens.test.ts`.
///
/// The wide numeric parity for the resolver lives in `define_theme_test.dart`
/// and `themes_test.dart`, which diff whole resolved token maps. These are the
/// named behaviours: reference chains, cycles, fallbacks, and which colour
/// functions are evaluated versus deliberately preserved.
void main() {
  tearDown(resetThemes);

  AstryxDefinedTheme theme(
    String name,
    Map<String, AstryxTokenValue> tokens,
  ) => defineTheme(AstryxDefineThemeInput(name: name, tokens: tokens));

  final testTheme = theme('test', const <String, AstryxTokenValue>{
    '--color-accent': AstryxTokenValue.lightDark('#AA0000', '#FF5555'),
    '--color-neutral': AstryxTokenValue.lightDark(
      'rgba(5, 54, 89, 0.1)',
      'rgba(223, 226, 229, 0.2)',
    ),
    '--spacing-4': AstryxTokenValue('20px'),
  });

  group('resolveThemeTokens', () {
    test('resolves the defaults when no theme is given', () {
      final tokens = resolveThemeTokens(null, AstryxThemeMode.light);
      expect(tokens['--color-text-primary'], '#0A1317');
      expect(tokens['--spacing-1'], '4px');
    });

    test('resolves pair overrides from the original input tokens', () {
      expect(
        resolveThemeTokens(testTheme, AstryxThemeMode.light)['--color-accent'],
        '#AA0000',
      );
      expect(
        resolveThemeTokens(testTheme, AstryxThemeMode.dark)['--color-accent'],
        '#FF5555',
      );
    });

    test('resolves pair overrides whose halves contain commas', () {
      expect(
        resolveThemeTokens(testTheme, AstryxThemeMode.light)['--color-neutral'],
        'rgba(5, 54, 89, 0.1)',
      );
      expect(
        resolveThemeTokens(testTheme, AstryxThemeMode.dark)['--color-neutral'],
        'rgba(223, 226, 229, 0.2)',
      );
    });

    test('resolves a light-dark() string with no input tokens to fall back '
        'on', () {
      // What a pre-built theme looks like: the pair has already been flattened
      // and there is no record of the original halves.
      const built = AstryxDefinedTheme(
        name: 'built',
        tokens: <String, String>{
          '--color-neutral':
              'light-dark(rgba(5, 54, 89, 0.1), rgba(223, 226, 229, 0.2))',
        },
      );
      expect(
        resolveThemeTokens(built, AstryxThemeMode.light)['--color-neutral'],
        'rgba(5, 54, 89, 0.1)',
      );
      expect(
        resolveThemeTokens(built, AstryxThemeMode.dark)['--color-neutral'],
        'rgba(223, 226, 229, 0.2)',
      );
    });

    test('passes a single-value override through unchanged', () {
      expect(
        resolveThemeTokens(testTheme, AstryxThemeMode.light)['--spacing-4'],
        '20px',
      );
    });
  });

  group('resolveThemeToken', () {
    test('resolves one token', () {
      expect(
        resolveThemeToken(testTheme, '--color-accent', AstryxThemeMode.dark),
        '#FF5555',
      );
    });

    test('returns the fallback for an unknown token', () {
      expect(
        resolveThemeToken(
          testTheme,
          '--missing-token',
          AstryxThemeMode.dark,
          fallback: 'fallback',
        ),
        'fallback',
      );
    });

    test('returns an empty string for an unknown token with no fallback', () {
      expect(
        resolveThemeToken(testTheme, '--missing-token', AstryxThemeMode.dark),
        '',
      );
    });
  });

  group('reference resolution', () {
    test('resolves a token that references another to a raw value', () {
      final ref = theme('ref', const <String, AstryxTokenValue>{
        '--color-accent': AstryxTokenValue.lightDark('#0058D2', '#BBC2FF'),
        '--color-text-accent': AstryxTokenValue('var(--color-accent)'),
      });
      expect(
        resolveThemeTokens(ref, AstryxThemeMode.light)['--color-text-accent'],
        '#0058D2',
      );
      expect(
        resolveThemeTokens(ref, AstryxThemeMode.dark)['--color-text-accent'],
        '#BBC2FF',
      );
    });

    test('follows a reference chain', () {
      final chain = theme('chain', const <String, AstryxTokenValue>{
        '--color-accent': AstryxTokenValue.lightDark('#112233', '#445566'),
        '--color-icon-accent': AstryxTokenValue('var(--color-accent)'),
        '--color-text-accent': AstryxTokenValue('var(--color-icon-accent)'),
      });
      final light = resolveThemeTokens(chain, AstryxThemeMode.light);
      expect(light['--color-icon-accent'], '#112233');
      expect(light['--color-text-accent'], '#112233');
    });

    test('uses the var() fallback when the referenced token is unknown', () {
      final fallback = theme('fallback', const <String, AstryxTokenValue>{
        '--color-text-accent': AstryxTokenValue('var(--not-a-token, #ABCDEF)'),
      });
      expect(
        resolveThemeTokens(
          fallback,
          AstryxThemeMode.light,
        )['--color-text-accent'],
        '#ABCDEF',
      );
    });

    test('leaves an unresolvable reference as a literal var()', () {
      final unresolvable = theme(
        'unresolvable',
        const <String, AstryxTokenValue>{
          '--color-text-accent': AstryxTokenValue('var(--not-a-token)'),
        },
      );
      expect(
        resolveThemeTokens(
          unresolvable,
          AstryxThemeMode.light,
        )['--color-text-accent'],
        'var(--not-a-token)',
      );
    });

    test('does not loop forever on a reference cycle', () {
      final cycle = theme('cycle', const <String, AstryxTokenValue>{
        '--color-text-accent': AstryxTokenValue('var(--color-icon-accent)'),
        '--color-icon-accent': AstryxTokenValue('var(--color-text-accent)'),
      });
      final tokens = resolveThemeTokens(cycle, AstryxThemeMode.light);
      // The cycle collapses to a literal reference rather than hanging.
      expect(tokens['--color-text-accent'], contains('var('));
      expect(tokens['--color-icon-accent'], contains('var('));
    });
  });

  group('CSS colour functions', () {
    test('evaluates a mix with transparent to an rgba() value', () {
      final mix = theme('mix', const <String, AstryxTokenValue>{
        '--color-accent': AstryxTokenValue.lightDark('#0058D2', '#BBC2FF'),
        '--color-accent-muted': AstryxTokenValue(
          'color-mix(in srgb, var(--color-accent) 20%, transparent)',
        ),
      });
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.light)['--color-accent-muted'],
        'rgba(0, 88, 210, 0.2)',
      );
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.dark)['--color-accent-muted'],
        'rgba(187, 194, 255, 0.2)',
      );
    });

    test('resolves a mix inside a light/dark pair per mode', () {
      final mix = theme('ld-mix', const <String, AstryxTokenValue>{
        '--color-accent': AstryxTokenValue.lightDark('#FF0000', '#00FF00'),
        '--color-accent-muted': AstryxTokenValue.lightDark(
          'color-mix(in srgb, var(--color-accent) 20%, transparent)',
          'color-mix(in srgb, var(--color-accent) 25%, transparent)',
        ),
      });
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.light)['--color-accent-muted'],
        'rgba(255, 0, 0, 0.2)',
      );
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.dark)['--color-accent-muted'],
        'rgba(0, 255, 0, 0.25)',
      );
    });

    test('mixes two opaque colours by equal weight', () {
      final mix = theme('two-color', const <String, AstryxTokenValue>{
        '--color-neutral': AstryxTokenValue(
          'color-mix(in srgb, #000000, #FFFFFF)',
        ),
      });
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.light)['--color-neutral'],
        '#808080',
      );
    });

    test('mixes two opaque colours with an explicit percentage', () {
      final mix = theme('weighted', const <String, AstryxTokenValue>{
        '--color-neutral': AstryxTokenValue(
          'color-mix(in srgb, #000000 25%, #FFFFFF)',
        ),
      });
      expect(
        resolveThemeTokens(mix, AstryxThemeMode.light)['--color-neutral'],
        '#BFBFBF',
      );
    });

    test('preserves an unsupported colour space rather than guessing', () {
      final mix = theme('oklab', const <String, AstryxTokenValue>{
        '--color-accent': AstryxTokenValue.lightDark('#0058D2', '#BBC2FF'),
        '--color-neutral': AstryxTokenValue(
          'color-mix(in oklab, var(--color-accent), black 15%)',
        ),
      });
      final resolved = resolveThemeTokens(
        mix,
        AstryxThemeMode.light,
      )['--color-neutral'];
      // The var() still resolves; the mix itself survives as an expression.
      expect(resolved, contains('color-mix(in oklab'));
      expect(resolved, contains('#0058D2'));
    });
  });

  group('generated themes end to end', () {
    test('derived accent tokens resolve to raw values', () {
      final brand = defineTheme(
        const AstryxDefineThemeInput(
          name: 'brand',
          color: AstryxColorScaleConfig(accent: '#0064E0'),
        ),
      );
      final light = resolveThemeTokens(brand, AstryxThemeMode.light);
      final dark = resolveThemeTokens(brand, AstryxThemeMode.dark);

      for (final key in const <String>[
        '--color-accent',
        '--color-text-accent',
        '--color-icon-accent',
        '--color-accent-muted',
      ]) {
        expect(light[key], matches('^(#|rgb)'), reason: key);
        expect(dark[key], matches('^(#|rgb)'), reason: key);
        expect(light[key], isNot(contains('var(')), reason: key);
        expect(light[key], isNot(contains('color-mix')), reason: key);
      }

      // The derived accent tokens resolve to the base accent.
      expect(light['--color-text-accent'], light['--color-accent']);
      expect(light['--color-icon-accent'], light['--color-accent']);
    });
  });
}
