import 'package:astryx_ui/src/theme/engine/hct.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Parity tests for the HCT port.
///
/// Two layers. The first transcribes `hct.test.ts`, which checks properties —
/// round-trip stability, component ranges, palette shape. The second diffs
/// against `dev/fixtures/engine/hct.json`, the recorded output of the upstream
/// implementation over a much wider sweep than upstream's own suite covers.
void main() {
  group('hexToHct / hctToHex roundtrip', () {
    const cases = <String>[
      '#FF0000',
      '#00FF00',
      '#0000FF',
      '#000000',
      '#FFFFFF',
      '#808080',
      '#0064E0',
    ];

    (int, int, int) rgbOf(String hex) {
      final h = hex.replaceAll('#', '');
      return (
        int.parse(h.substring(0, 2), radix: 16),
        int.parse(h.substring(2, 4), radix: 16),
        int.parse(h.substring(4, 6), radix: 16),
      );
    }

    for (final hex in cases) {
      test('roundtrips $hex', () {
        final result = hctToHex(hexToHct(hex));
        final (r1, g1, b1) = rgbOf(hex);
        final (r2, g2, b2) = rgbOf(result);
        expect((r1 - r2).abs(), lessThanOrEqualTo(1));
        expect((g1 - g2).abs(), lessThanOrEqualTo(1));
        expect((b1 - b2).abs(), lessThanOrEqualTo(1));
      });
    }
  });

  group('hexToHct ranges', () {
    for (final hex in <String>[
      '#FF0000',
      '#00FF00',
      '#0000FF',
      '#808080',
      '#0064E0',
    ]) {
      test('$hex produces valid HCT ranges', () {
        final hct = hexToHct(hex);
        expect(hct.hue, greaterThanOrEqualTo(0));
        expect(hct.hue, lessThanOrEqualTo(360));
        expect(hct.chroma, greaterThanOrEqualTo(0));
        expect(hct.tone, greaterThanOrEqualTo(0));
        expect(hct.tone, lessThanOrEqualTo(100));
      });
    }

    test('black has tone close to 0', () {
      expect(hexToHct('#000000').tone, closeTo(0, 0.5));
    });

    test('white has tone close to 100', () {
      expect(hexToHct('#FFFFFF').tone, closeTo(100, 0.5));
    });
  });

  group('tonalPalette', () {
    test('produces entries for all standard tones', () {
      final palette = tonalPalette(220, 48);
      for (final tone in astryxPaletteTones) {
        expect(palette[tone], isNotNull);
        expect(palette[tone], matches(r'^#[0-9A-F]{6}$'));
      }
    });
  });

  group('hexWithAlpha', () {
    test('appends the alpha byte for 1.0', () {
      expect(hexWithAlpha('#FF0000', 1), '#FF0000FF');
    });

    test('appends the alpha byte for 0.5', () {
      expect(hexWithAlpha('#FF0000', 0.5), '#FF000080');
    });

    test('appends the alpha byte for 0', () {
      expect(hexWithAlpha('#FF0000', 0), '#FF000000');
    });

    test('appends the alpha byte for 0.2', () {
      expect(hexWithAlpha('#ABCDEF', 0.2), '#ABCDEF33');
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('hct'));

    // JS numbers and Dart doubles are both IEEE 754 binary64. Where the
    // operation order matches, results agree to the last bit; the tolerance
    // covers only `cbrt`, which Dart lacks and this port approximates.
    const epsilon = 1e-9;

    test('hexToHct matches upstream for every recorded input', () {
      final cases = asObjects(fixture['hexToHct']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final hex = c['hex']! as String;
        final actual = hexToHct(hex);
        expect(actual.hue, closeTo(asDouble(c['hue']), epsilon), reason: hex);
        expect(
          actual.chroma,
          closeTo(asDouble(c['chroma']), epsilon),
          reason: hex,
        );
        expect(actual.tone, closeTo(asDouble(c['tone']), epsilon), reason: hex);
      }
    });

    test('hctToHex matches upstream across the hue/chroma/tone grid', () {
      final grid = fixture['hctToHexGrid']! as Map<String, dynamic>;
      final hues = (grid['hues']! as List<dynamic>).map(asDouble).toList();
      final chromas = (grid['chromas']! as List<dynamic>)
          .map(asDouble)
          .toList();
      final tones = (grid['tones']! as List<dynamic>).map(asDouble).toList();
      final results = (grid['results']! as List<dynamic>).cast<String>();

      expect(results, hasLength(hues.length * chromas.length * tones.length));

      var i = 0;
      for (final hue in hues) {
        for (final chroma in chromas) {
          for (final tone in tones) {
            final actual = hctToHex(
              AstryxHct(hue: hue, chroma: chroma, tone: tone),
            );
            expect(
              actual,
              results[i],
              reason: 'hue $hue, chroma $chroma, tone $tone',
            );
            i += 1;
          }
        }
      }
    });

    test('hctToHex matches upstream on the early-return paths', () {
      for (final c in asObjects(fixture['hctToHexEdge'])) {
        final hct = AstryxHct(
          hue: asDouble(c['hue']),
          chroma: asDouble(c['chroma']),
          tone: asDouble(c['tone']),
        );
        expect(hctToHex(hct), c['hex'], reason: '$hct');
      }
    });

    test('tonalPalette matches upstream', () {
      for (final c in asObjects(fixture['tonalPalette'])) {
        final expected = (c['palette']! as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value! as String),
        );
        expect(
          tonalPalette(asDouble(c['hue']), asDouble(c['chroma'])),
          expected,
        );
      }
    });

    test('hexWithAlpha matches upstream', () {
      for (final c in asObjects(fixture['hexWithAlpha'])) {
        expect(
          hexWithAlpha(c['hex']! as String, asDouble(c['alpha'])),
          c['result'],
        );
      }
    });
  });
}
