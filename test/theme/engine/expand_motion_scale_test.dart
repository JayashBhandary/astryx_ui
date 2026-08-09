import 'package:astryx_ui/src/theme/engine/expand_motion_scale.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Parity tests for the motion scale expander.
void main() {
  const defaultScale = AstryxMotionScaleConfig(
    fast: 175,
    medium: 410,
    ratio: 0.75,
  );
  const withSlow = AstryxMotionScaleConfig(
    fast: 175,
    medium: 410,
    slow: 975,
    ratio: 0.75,
  );

  group('expandMotionScale', () {
    test('computes the default Astryx motion scale', () {
      final tokens = expandMotionScale(defaultScale);
      expect(tokens['--duration-fast-min'], '130ms'); // 175 × 0.75 = 131.25
      expect(tokens['--duration-fast'], '175ms');
      expect(tokens['--duration-fast-max'], '235ms'); // 175 / 0.75 = 233.3
      expect(tokens['--duration-medium-min'], '310ms'); // 410 × 0.75 = 307.5
      expect(tokens['--duration-medium'], '410ms');
      expect(tokens['--duration-medium-max'], '545ms'); // 410 / 0.75 = 546.6
    });

    test('computes a snappy motion scale', () {
      final tokens = expandMotionScale(
        const AstryxMotionScaleConfig(fast: 100, medium: 250, ratio: 0.75),
      );
      expect(tokens['--duration-fast-min'], '75ms');
      expect(tokens['--duration-fast'], '100ms');
      expect(tokens['--duration-fast-max'], '135ms');
      expect(tokens['--duration-medium-min'], '190ms');
      expect(tokens['--duration-medium'], '250ms');
      expect(tokens['--duration-medium-max'], '335ms');
    });

    test('computes a cinematic motion scale', () {
      final tokens = expandMotionScale(
        const AstryxMotionScaleConfig(fast: 200, medium: 500, ratio: 0.7),
      );
      expect(tokens['--duration-fast-min'], '140ms');
      expect(tokens['--duration-fast'], '200ms');
      expect(tokens['--duration-fast-max'], '285ms');
      expect(tokens['--duration-medium-min'], '350ms');
      expect(tokens['--duration-medium'], '500ms');
      expect(tokens['--duration-medium-max'], '715ms');
    });

    test('omits the easing token when no easing is given', () {
      expect(expandMotionScale(defaultScale)['--ease-standard'], isNull);
    });

    test('includes the easing override when one is given', () {
      final tokens = expandMotionScale(
        defaultScale.copyWith(easing: 'cubic-bezier(0.0, 0.0, 0.2, 1)'),
      );
      expect(tokens['--ease-standard'], 'cubic-bezier(0.0, 0.0, 0.2, 1)');
    });

    test('treats an empty easing string as absent, as upstream does', () {
      final tokens = expandMotionScale(
        const AstryxMotionScaleConfig(
          fast: 175,
          medium: 410,
          ratio: 0.75,
          easing: '',
        ),
      );
      expect(tokens['--ease-standard'], isNull);
    });

    test('produces exactly 6 duration tokens without a slow band', () {
      final tokens = expandMotionScale(defaultScale);
      expect(
        tokens.keys.where((k) => k.startsWith('--duration-')),
        hasLength(6),
      );
    });

    test('produces 9 duration tokens with a slow band', () {
      final tokens = expandMotionScale(withSlow);
      expect(
        tokens.keys.where((k) => k.startsWith('--duration-')),
        hasLength(9),
      );
    });

    test('computes the default slow band', () {
      final tokens = expandMotionScale(withSlow);
      expect(tokens['--duration-slow-min'], '730ms'); // 975 × 0.75 = 731.25
      expect(tokens['--duration-slow'], '975ms');
      expect(tokens['--duration-slow-max'], '1300ms'); // 975 / 0.75 = 1300
    });

    test('emits no slow tokens when slow is omitted', () {
      final tokens = expandMotionScale(defaultScale);
      expect(tokens['--duration-slow-min'], isNull);
      expect(tokens['--duration-slow'], isNull);
      expect(tokens['--duration-slow-max'], isNull);
    });

    test('maintains the ordering min < base < max across bands', () {
      final tokens = expandMotionScale(withSlow);
      int ms(String key) =>
          int.parse(tokens[key]!.substring(0, tokens[key]!.length - 2));

      expect(ms('--duration-fast-min'), lessThan(ms('--duration-fast')));
      expect(ms('--duration-fast'), lessThan(ms('--duration-fast-max')));
      expect(ms('--duration-medium-min'), lessThan(ms('--duration-medium')));
      expect(ms('--duration-medium'), lessThan(ms('--duration-medium-max')));
      expect(ms('--duration-fast-max'), lessThan(ms('--duration-medium-min')));
      expect(ms('--duration-medium-max'), lessThan(ms('--duration-slow-min')));
      expect(ms('--duration-slow-min'), lessThan(ms('--duration-slow')));
      expect(ms('--duration-slow'), lessThan(ms('--duration-slow-max')));
    });
  });

  group('AstryxMotionScaleConfig', () {
    test('is a value type', () {
      expect(
        defaultScale,
        const AstryxMotionScaleConfig(fast: 175, medium: 410, ratio: 0.75),
      );
      expect(
        defaultScale.hashCode,
        const AstryxMotionScaleConfig(
          fast: 175,
          medium: 410,
          ratio: 0.75,
        ).hashCode,
      );
      expect(defaultScale.copyWith(slow: 975), withSlow);
    });
  });

  group('upstream parity', () {
    test('matches upstream for every recorded configuration', () {
      final cases = asObjects(
        loadEngineFixture('expand_motion_scale')['cases'],
      );
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final config = c['config']! as Map<String, dynamic>;
        final slow = config['slow'];
        final actual = expandMotionScale(
          AstryxMotionScaleConfig(
            fast: asDouble(config['fast']),
            medium: asDouble(config['medium']),
            ratio: asDouble(config['ratio']),
            slow: slow == null ? null : asDouble(slow),
            easing: config['easing'] as String?,
          ),
        );
        expect(actual, c['tokens'], reason: '$config');
      }
    });
  });
}
