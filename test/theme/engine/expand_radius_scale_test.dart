import 'package:astryx_ui/src/theme/engine/expand_radius_scale.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Parity tests for the radius scale expander.
void main() {
  group('expandRadiusScale', () {
    test('generates the default scale', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 4, multiplier: 1),
      );
      expect(tokens['--radius-none'], '0px');
      expect(tokens['--radius-inner'], '4px');
      expect(tokens['--radius-element'], '8px');
      expect(tokens['--radius-container'], '12px');
      expect(tokens['--radius-page'], '28px');
      expect(tokens['--radius-chat'], '28px');
      expect(tokens['--radius-full'], '9999px');
    });

    test('applies the multiplier', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 4, multiplier: 1.5),
      );
      expect(tokens['--radius-inner'], '6px');
      expect(tokens['--radius-element'], '12px');
      expect(tokens['--radius-container'], '18px');
      expect(tokens['--radius-page'], '42px');
      expect(tokens['--radius-chat'], '42px');
    });

    test('a multiplier of 0 produces all zeros', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 4, multiplier: 0),
      );
      expect(tokens['--radius-none'], '0px');
      expect(tokens['--radius-inner'], '0px');
      expect(tokens['--radius-element'], '0px');
      expect(tokens['--radius-container'], '0px');
      expect(tokens['--radius-page'], '0px');
      expect(tokens['--radius-chat'], '0px');
      expect(tokens['--radius-full'], '9999px');
    });

    test('the fixed tokens are unaffected by the multiplier', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 4, multiplier: 2),
      );
      expect(tokens['--radius-none'], '0px');
      expect(tokens['--radius-full'], '9999px');
    });

    test('rounds fractional results to the nearest whole pixel', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 3, multiplier: 1.3),
      );
      expect(tokens['--radius-inner'], '4px'); // 3 × 1 × 1.3 = 3.9
      expect(tokens['--radius-element'], '8px'); // 3 × 2 × 1.3 = 7.8
    });

    test('works with a non-standard base', () {
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 6, multiplier: 1),
      );
      expect(tokens['--radius-inner'], '6px');
      expect(tokens['--radius-element'], '12px');
      expect(tokens['--radius-container'], '18px');
      expect(tokens['--radius-page'], '42px');
    });

    test('rounds negative halves toward zero, as JavaScript does', () {
      // Dart's own `.round()` would give -1px here. See `jsRound`.
      final tokens = expandRadiusScale(
        const AstryxRadiusScaleConfig(base: 1, multiplier: -0.5),
      );
      expect(tokens['--radius-inner'], '0px');
      expect(tokens['--radius-element'], '-1px');
    });
  });

  group('AstryxRadiusScaleConfig', () {
    test('is a value type', () {
      const a = AstryxRadiusScaleConfig(base: 4, multiplier: 1);
      const b = AstryxRadiusScaleConfig(base: 4, multiplier: 1);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.copyWith(multiplier: 2).multiplier, 2);
      expect(a.copyWith(multiplier: 2).base, 4);
    });
  });

  group('upstream parity', () {
    test('matches upstream for every recorded configuration', () {
      final cases = asObjects(
        loadEngineFixture('expand_radius_scale')['cases'],
      );
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final config = c['config']! as Map<String, dynamic>;
        final actual = expandRadiusScale(
          AstryxRadiusScaleConfig(
            base: asDouble(config['base']),
            multiplier: asDouble(config['multiplier']),
          ),
        );
        expect(actual, c['tokens'], reason: '$config');
      }
    });
  });
}
