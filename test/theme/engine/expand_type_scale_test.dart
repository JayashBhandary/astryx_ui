import 'dart:math' as math;

import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/engine/expand_type_scale.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/utils/js_number.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Parity tests for the type scale expander.
void main() {
  const defaultScale = AstryxTypeScaleConfig(base: 14, ratio: 1.2);
  final tokens = expandTypeScale(defaultScale);

  group('Layer 1 — raw size tokens', () {
    test('emits 12 raw size tokens, all in rem', () {
      for (final name in astryxStepToSizeToken.values) {
        expect(tokens[name], isNotNull, reason: name);
        expect(tokens[name], endsWith('rem'), reason: name);
      }
      expect(astryxStepToSizeToken.values, hasLength(12));
    });

    test('anchors --font-size-base to the base size', () {
      expect(tokens['--font-size-base'], '0.875rem'); // 14/16
    });

    test('computes the geometric progression for the sub-scale', () {
      expect(tokens['--font-size-4xs'], '0.375rem'); // 6/16
      expect(tokens['--font-size-3xs'], '0.4375rem'); // 7/16
      expect(tokens['--font-size-2xs'], '0.5rem'); // 8/16
    });

    test('computes the geometric progression', () {
      expect(tokens['--font-size-xs'], '0.625rem'); // 10/16
      expect(tokens['--font-size-sm'], '0.75rem'); // 12/16
      expect(tokens['--font-size-lg'], '1.0625rem'); // 17/16
      expect(tokens['--font-size-xl'], '1.25rem'); // 20/16
      expect(tokens['--font-size-2xl'], '1.5rem'); // 24/16
      expect(tokens['--font-size-3xl'], '1.8125rem'); // 29/16
      expect(tokens['--font-size-4xl'], '2.1875rem'); // 35/16
    });
  });

  group('Layer 2 — semantic tokens', () {
    test('heading sizes are var() references to the raw tokens', () {
      expect(tokens['--text-heading-1-size'], 'var(--font-size-2xl)');
      expect(tokens['--text-heading-2-size'], 'var(--font-size-xl)');
      expect(tokens['--text-heading-3-size'], 'var(--font-size-lg)');
      expect(tokens['--text-heading-4-size'], 'var(--font-size-base)');
      expect(tokens['--text-heading-5-size'], 'var(--font-size-sm)');
      expect(tokens['--text-heading-6-size'], 'var(--font-size-xs)');
    });

    test('heading leadings are baked-in computed values', () {
      expect(tokens['--text-heading-1-leading'], '1.3333'); // 24px → 32px
      expect(tokens['--text-heading-2-leading'], '1.4'); // 20px → 28px
      expect(tokens['--text-heading-3-leading'], '1.4118'); // 17px → 24px
      expect(tokens['--text-heading-4-leading'], '1.4286'); // 14px → 20px
      expect(tokens['--text-heading-5-leading'], '1.6667'); // 12px → 20px
      expect(tokens['--text-heading-6-leading'], '1.6'); // 10px → 16px
    });

    test('text type sizes are var() references', () {
      expect(tokens['--text-body-size'], 'var(--font-size-base)');
      expect(tokens['--text-large-size'], 'var(--font-size-lg)');
      expect(tokens['--text-label-size'], 'var(--font-size-base)');
      expect(tokens['--text-code-size'], 'var(--font-size-base)');
      expect(tokens['--text-supporting-size'], 'var(--font-size-sm)');
    });

    test('text type leadings are baked-in computed values', () {
      expect(tokens['--text-body-leading'], '1.4286'); // 14px → 20px
      expect(tokens['--text-large-leading'], '1.4118'); // 17px → 24px
      expect(tokens['--text-label-leading'], '1.4286');
      expect(tokens['--text-code-leading'], '1.4286');
      expect(tokens['--text-supporting-leading'], '1.6667'); // 12px → 20px
    });

    test('weight tokens are var() references', () {
      expect(tokens['--text-heading-1-weight'], 'var(--font-weight-semibold)');
      expect(tokens['--text-body-weight'], 'var(--font-weight-normal)');
      expect(tokens['--text-large-weight'], 'var(--font-weight-semibold)');
      expect(tokens['--text-label-weight'], 'var(--font-weight-medium)');
      expect(tokens['--text-code-weight'], 'var(--font-weight-normal)');
      expect(tokens['--text-supporting-weight'], 'var(--font-weight-normal)');
    });

    test('display sizes continue the progression above h1', () {
      // display-1 = 14 × 1.2⁶ ≈ 41.80 → 42px → 2.625rem, the largest.
      expect(tokens['--text-display-1-size'], 'var(--font-size-5xl)');
      // display-2 = 14 × 1.2⁵ ≈ 34.84 → 35px → 2.1875rem.
      expect(tokens['--text-display-2-size'], 'var(--font-size-4xl)');
      // display-3 = 14 × 1.2⁴ ≈ 29.03 → 29px → 1.8125rem, closest to h1.
      expect(tokens['--text-display-3-size'], 'var(--font-size-3xl)');
    });

    test('display types default to normal weight', () {
      expect(tokens['--text-display-1-weight'], 'var(--font-weight-normal)');
      expect(tokens['--text-display-2-weight'], 'var(--font-weight-normal)');
      expect(tokens['--text-display-3-weight'], 'var(--font-weight-normal)');
    });

    test('every line height snaps to the 4px grid', () {
      const pairs = <String, double>{
        '--text-heading-1-leading': 24,
        '--text-heading-2-leading': 20,
        '--text-heading-3-leading': 17,
        '--text-heading-4-leading': 14,
        '--text-heading-5-leading': 12,
        '--text-heading-6-leading': 10,
        '--text-body-leading': 14,
        '--text-large-leading': 17,
        '--text-supporting-leading': 12,
      };
      for (final entry in pairs.entries) {
        final ratio = parseFloatLoose(tokens[entry.key]!);
        final lhPx = jsRound(entry.value * ratio);
        expect(lhPx % 4, 0, reason: entry.key);
        expect(lhPx, greaterThanOrEqualTo(entry.value + 4), reason: entry.key);
      }
    });

    test('uses a tiered target ratio based on font size', () {
      double lh(double fontSize, String token) =>
          jsRound(fontSize * parseFloatLoose(tokens[token]!));

      // Below 20px the target is 1.5: 14px → a 20px line.
      expect(lh(14, '--text-heading-4-leading'), 20);
      // From 20 to 31px the target is 1.4: 20px → 28px, 24px → 32px.
      expect(lh(20, '--text-heading-2-leading'), 28);
      expect(lh(24, '--text-heading-1-leading'), 32);
    });
  });

  group('scope', () {
    test('does not touch the named --leading-* tokens', () {
      expect(tokens.keys.where((k) => k.startsWith('--leading-')), isEmpty);
    });

    test('generates 54 tokens — 12 size plus 42 semantic', () {
      expect(tokens, hasLength(54));
    });

    test('every generated key is a known token', () {
      for (final key in tokens.keys) {
        expect(astryxTokenDefaults, contains(key), reason: key);
      }
    });
  });

  group('weight overrides', () {
    test('applies heading weight overrides', () {
      final overridden = expandTypeScale(
        defaultScale.copyWith(
          weights: const AstryxTypeScaleWeights(
            heading: <int, String>{1: 'var(--font-weight-bold)'},
          ),
        ),
      );
      expect(overridden['--text-heading-1-weight'], 'var(--font-weight-bold)');
      expect(
        overridden['--text-heading-2-weight'],
        'var(--font-weight-semibold)',
      );
    });

    test('applies text weight overrides', () {
      final overridden = expandTypeScale(
        defaultScale.copyWith(
          weights: const AstryxTypeScaleWeights(
            text: <String, String>{'large': 'var(--font-weight-normal)'},
          ),
        ),
      );
      expect(overridden['--text-large-weight'], 'var(--font-weight-normal)');
      expect(overridden['--text-body-weight'], 'var(--font-weight-normal)');
    });

    test('ignores an override for a text type with no step', () {
      final overridden = expandTypeScale(
        defaultScale.copyWith(
          weights: const AstryxTypeScaleWeights(
            text: <String, String>{'display-4': '900'},
          ),
        ),
      );
      expect(overridden, isNot(contains('--text-display-4-weight')));
      expect(overridden, hasLength(54));
    });
  });

  group('alternate scales', () {
    test('dense — base 12, ratio 1.125', () {
      final dense = expandTypeScale(
        const AstryxTypeScaleConfig(base: 12, ratio: 1.125),
      );
      expect(dense['--font-size-base'], '0.75rem'); // 12/16
      expect(dense['--text-heading-4-size'], 'var(--font-size-base)');
    });

    test('airy — base 16, ratio 1.25', () {
      final airy = expandTypeScale(
        const AstryxTypeScaleConfig(base: 16, ratio: 1.25),
      );
      expect(airy['--font-size-base'], '1rem'); // 16/16
      expect(airy['--font-size-lg'], '1.25rem'); // 20/16
      expect(airy['--text-heading-1-size'], 'var(--font-size-2xl)');
    });

    test('every scale produces 4px-grid-aligned line heights', () {
      const scales = <AstryxTypeScaleConfig>[
        AstryxTypeScaleConfig(base: 12, ratio: 1.125),
        AstryxTypeScaleConfig(base: 14, ratio: 1.2),
        AstryxTypeScaleConfig(base: 16, ratio: 1.25),
        AstryxTypeScaleConfig(base: 18, ratio: 1.333),
      ];
      for (final config in scales) {
        final scaled = expandTypeScale(config);
        for (var level = 1; level <= 6; level++) {
          final step = astryxHeadingSteps[level]!;
          final fontSize = jsRound(
            config.base * math.pow(config.ratio, step).toDouble(),
          );
          final ratio = parseFloatLoose(
            scaled['--text-heading-$level-leading']!,
          );
          final lhPx = jsRound(fontSize * ratio);
          expect(lhPx % 4, 0, reason: '$config h$level');
          expect(lhPx, greaterThanOrEqualTo(fontSize + 4));
        }
      }
    });
  });

  group('generateTypeScaleComponents', () {
    final components = generateTypeScaleComponents(defaultScale);

    test('generates the heading and text component keys', () {
      expect(components, contains('heading'));
      expect(components, contains('text'));
    });

    test('generates rules for all 6 heading levels', () {
      for (var level = 1; level <= 6; level++) {
        expect(components['heading'], contains('level:$level'));
      }
    });

    test('generates rules for all 8 text types, display included', () {
      for (final type in astryxTextSteps.keys) {
        expect(components['text'], contains('type:$type'));
      }
      expect(components['text'], hasLength(8));
    });

    test('heading rules carry family, size, weight and line height', () {
      final h1 = components['heading']!['level:1']!;
      expect(h1['fontFamily'], 'var(--font-family-heading)');
      expect(h1['fontSize'], 'var(--text-heading-1-size)');
      expect(h1['fontWeight'], 'var(--text-heading-1-weight)');
      expect(h1['lineHeight'], 'var(--text-heading-1-leading)');
    });

    test('text rules reference the semantic tokens', () {
      final body = components['text']!['type:body']!;
      expect(body['fontSize'], 'var(--text-body-size)');
      expect(body['lineHeight'], 'var(--text-body-leading)');
      expect(body['fontFamily'], 'var(--font-family-body)');
      expect(
        components['text']!['type:code']!['fontFamily'],
        'var(--font-family-code)',
      );
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('expand_type_scale'));

    test('matches upstream for every recorded configuration', () {
      final cases = asObjects(fixture['cases']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final json = c['config']! as Map<String, dynamic>;
        final weights = json['weights'] as Map<String, dynamic>?;
        final heading = weights?['heading'] as Map<String, dynamic>?;
        final text = weights?['text'] as Map<String, dynamic>?;

        final config = AstryxTypeScaleConfig(
          base: asDouble(json['base']),
          ratio: asDouble(json['ratio']),
          weights: weights == null
              ? null
              : AstryxTypeScaleWeights(
                  heading: heading?.map(
                    (key, value) => MapEntry(int.parse(key), value! as String),
                  ),
                  text: text?.cast<String, String>(),
                ),
        );
        expect(expandTypeScale(config), c['tokens'], reason: '$json');
      }
    });

    test('generateTypeScaleComponents matches upstream', () {
      expect(
        generateTypeScaleComponents(defaultScale),
        fixture['components'],
      );
    });
  });
}
