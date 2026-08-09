import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/expand_color_scale.dart';
import 'package:astryx_ui/src/theme/engine/syntax_theme.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/resolved_token_set.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/theme_input.dart';

/// Tests for the Layer 1 → Layer 2 hand-off.
void main() {
  tearDown(resetThemes);

  final brand = defineTheme(
    const AstryxDefineThemeInput(
      name: 'brand',
      color: AstryxColorScaleConfig(accent: '#0064E0'),
    ),
  );

  group('resolve', () {
    test('carries every core token in both modes', () {
      final tokens = AstryxResolvedTokenSet.resolve(brand);
      expect(tokens.light.keys, containsAll(astryxTokenDefaults.keys));
      expect(tokens.dark.keys, containsAll(astryxTokenDefaults.keys));
      expect(tokens.isComplete, isTrue);
      expect(tokens.length, greaterThanOrEqualTo(184));
    });

    test('resolves the two modes to different values', () {
      final tokens = AstryxResolvedTokenSet.resolve(brand);
      expect(
        tokens.value(AstryxColorToken.backgroundSurface, AstryxThemeMode.light),
        isNot(
          tokens.value(
            AstryxColorToken.backgroundSurface,
            AstryxThemeMode.dark,
          ),
        ),
      );
    });

    test('leaves no reference or colour function unresolved', () {
      final tokens = AstryxResolvedTokenSet.resolve(brand);
      for (final mode in AstryxThemeMode.values) {
        for (final name in astryxTokenDefaults.keys) {
          final value = tokens.valueOf(name, mode);
          expect(value, isNot(contains('var(')), reason: '$name / $mode');
          expect(value, isNot(contains('color-mix(')), reason: '$name / $mode');
        }
      }
    });

    test('agrees with the engine it wraps', () {
      final tokens = AstryxResolvedTokenSet.resolve(brand);
      expect(tokens.light, resolveThemeTokens(brand, AstryxThemeMode.light));
      expect(tokens.dark, resolveThemeTokens(brand, AstryxThemeMode.dark));
    });

    test('a null theme resolves the Astryx defaults', () {
      final tokens = AstryxResolvedTokenSet.resolve(null);
      expect(
        tokens.value(AstryxColorToken.textPrimary, AstryxThemeMode.light),
        '#0A1317',
      );
      expect(
        tokens.value(AstryxSpacingToken.spacing1, AstryxThemeMode.light),
        '4px',
      );
    });

    test('keeps tokens outside the core set, such as a syntax palette', () {
      final withSyntax = defineTheme(
        const AstryxDefineThemeInput(
          name: 'syntax',
          syntax: AstryxSyntaxTheme(
            name: 'p',
            tokens: <String, String>{'keyword': '#700084'},
          ),
        ),
      );
      final tokens = AstryxResolvedTokenSet.resolve(withSyntax);
      expect(tokens.contains('--color-syntax-keyword'), isTrue);
      expect(
        tokens.valueOf('--color-syntax-keyword', AstryxThemeMode.light),
        '#700084',
      );
    });
  });

  group('defaults', () {
    test('is complete and matches an explicit null resolve', () {
      expect(AstryxResolvedTokenSet.defaults.isComplete, isTrue);
      expect(
        AstryxResolvedTokenSet.defaults,
        AstryxResolvedTokenSet.resolve(null),
      );
    });

    test('is resolved once and reused', () {
      expect(
        AstryxResolvedTokenSet.defaults,
        same(AstryxResolvedTokenSet.defaults),
      );
    });
  });

  group('lookup', () {
    final tokens = AstryxResolvedTokenSet.resolve(brand);

    test('forMode selects the right map', () {
      expect(tokens.forMode(AstryxThemeMode.light), same(tokens.light));
      expect(tokens.forMode(AstryxThemeMode.dark), same(tokens.dark));
    });

    test('value and valueOf agree', () {
      expect(
        tokens.value(AstryxColorToken.accent, AstryxThemeMode.light),
        tokens.valueOf('--color-accent', AstryxThemeMode.light),
      );
    });

    test('accepts any token enum through the shared interface', () {
      const tokenList = <AstryxToken>[
        AstryxColorToken.accent,
        AstryxSpacingToken.spacing4,
        AstryxRadiusToken.element,
        AstryxDurationToken.fast,
        AstryxShadowToken.med,
        AstryxTypeToken.bodySize,
        AstryxBorderToken.width,
        AstryxSizeToken.elementMd,
        AstryxEaseToken.standard,
        AstryxFontWeightToken.bold,
        AstryxTextSizeToken.base,
        AstryxTypographyToken.body,
      ];
      for (final token in tokenList) {
        expect(
          tokens.maybeValue(token, AstryxThemeMode.light),
          isNotNull,
          reason: token.cssName,
        );
      }
    });

    test('pair returns both halves', () {
      final (light, dark) = tokens.pair(AstryxColorToken.accent);
      expect(
        light,
        tokens.value(AstryxColorToken.accent, AstryxThemeMode.light),
      );
      expect(dark, tokens.value(AstryxColorToken.accent, AstryxThemeMode.dark));
    });

    test(
      'an unknown name throws from valueOf and is null from maybeValueOf',
      () {
        expect(
          () => tokens.valueOf('--nope', AstryxThemeMode.light),
          throwsArgumentError,
        );
        expect(tokens.maybeValueOf('--nope', AstryxThemeMode.light), isNull);
        expect(tokens.contains('--nope'), isFalse);
      },
    );
  });

  group('immutability', () {
    test('the exposed maps reject mutation', () {
      final tokens = AstryxResolvedTokenSet.resolve(brand);
      expect(
        () => tokens.light['--color-accent'] = 'red',
        throwsUnsupportedError,
      );
      expect(
        () => tokens.dark['--color-accent'] = 'red',
        throwsUnsupportedError,
      );
    });

    test('mutating the source maps afterwards does not leak in', () {
      final light = <String, String>{'--color-accent': '#111111'};
      final dark = <String, String>{'--color-accent': '#222222'};
      final tokens = AstryxResolvedTokenSet(light: light, dark: dark);

      light['--color-accent'] = '#999999';
      expect(
        tokens.valueOf('--color-accent', AstryxThemeMode.light),
        '#111111',
      );
    });
  });

  group('equality', () {
    test('two resolves of the same theme are equal', () {
      final a = AstryxResolvedTokenSet.resolve(brand);
      final b = AstryxResolvedTokenSet.resolve(brand);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(identical(a, b), isFalse);
    });

    test('different themes are not equal', () {
      final other = defineTheme(
        const AstryxDefineThemeInput(
          name: 'other',
          color: AstryxColorScaleConfig(accent: '#DC2626'),
        ),
      );
      expect(
        AstryxResolvedTokenSet.resolve(brand),
        isNot(AstryxResolvedTokenSet.resolve(other)),
      );
    });

    test('a difference in only one mode is detected', () {
      final base = AstryxResolvedTokenSet.resolve(brand);
      expect(
        base.copyWith(dark: <String, String>{'--color-accent': '#000000'}),
        isNot(base),
      );
    });
  });

  group('copyWith', () {
    final tokens = AstryxResolvedTokenSet.resolve(brand);

    test('returns the same instance when nothing is given', () {
      expect(tokens.copyWith(), same(tokens));
    });

    test('patches one mode and leaves the other alone', () {
      final patched = tokens.copyWith(
        light: <String, String>{'--color-accent': '#ABCDEF'},
      );
      expect(
        patched.value(AstryxColorToken.accent, AstryxThemeMode.light),
        '#ABCDEF',
      );
      expect(
        patched.value(AstryxColorToken.accent, AstryxThemeMode.dark),
        tokens.value(AstryxColorToken.accent, AstryxThemeMode.dark),
      );
      expect(patched.length, tokens.length);
    });

    test('can add a token outside the core set', () {
      final patched = tokens.copyWith(
        light: <String, String>{'--app-brand': '#123456'},
        dark: <String, String>{'--app-brand': '#654321'},
      );
      expect(patched.pairOf('--app-brand'), ('#123456', '#654321'));
    });
  });

  test('asserts that both modes carry the same token names', () {
    expect(
      () => AstryxResolvedTokenSet(
        light: const <String, String>{'--a': '1', '--b': '2'},
        dark: const <String, String>{'--a': '1'},
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  group('upstream parity', () {
    test('every prebuilt theme resolves to the recorded values', () {
      // The Phase 2 exit criterion, re-run through the Layer 2 hand-off, so a
      // mistake in this class cannot quietly undo it.
      for (final record in asObjects(loadEngineFixture('themes')['themes'])) {
        final theme = defineTheme(
          decodeThemeInput(record['input']! as Map<String, dynamic>),
        );
        final tokens = AstryxResolvedTokenSet.resolve(theme);

        expectCoreTokensMatch(
          tokens.light,
          record['resolvedLight']! as Map<String, dynamic>,
          reason: '${record['name']} / light',
        );
        expectCoreTokensMatch(
          tokens.dark,
          record['resolvedDark']! as Map<String, dynamic>,
          reason: '${record['name']} / dark',
        );
        resetThemes();
      }
    });
  });
}
