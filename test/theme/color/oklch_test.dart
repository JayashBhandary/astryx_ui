import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/oklch.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';
import 'package:flutter_test/flutter_test.dart';

/// OKLCH is not exercised by upstream's colour tests — `parseColor` refuses it
/// outright. These are our own, covering the achromatic values that actually
/// appear in Astryx shadow tokens plus enough of the general conversion to
/// trust it when a theme reaches for a chromatic value.
void main() {
  group('parseOklch — the forms Astryx shadow tokens actually use', () {
    test('parses black with a percentage alpha', () {
      final color = parseOklch('oklch(0 0 0 / 25%)');
      expect(color, isNotNull);
      expect(
        color!.isCloseTo(const AstryxRgba(r: 0, g: 0, b: 0, a: 0.25)),
        isTrue,
      );
    });

    test('parses white with a percentage alpha', () {
      final color = parseOklch('oklch(1 0 0 / 8%)');
      expect(color, isNotNull);
      expect(
        color!.isCloseTo(
          const AstryxRgba(r: 255, g: 255, b: 255, a: 0.08),
          epsilon: 1e-4,
        ),
        isTrue,
      );
    });

    test('defaults alpha to opaque', () {
      final color = parseOklch('oklch(0 0 0)');
      expect(color?.a, 1);
    });
  });

  group('parseOklch — general', () {
    test('accepts a percentage lightness', () {
      final asNumber = parseOklch('oklch(0.5 0 0)');
      final asPercent = parseOklch('oklch(50% 0 0)');
      expect(asNumber, isNotNull);
      expect(asPercent!.isCloseTo(asNumber!), isTrue);
    });

    test('accepts a numeric alpha', () {
      expect(parseOklch('oklch(0 0 0 / 0.5)')?.a, 0.5);
    });

    test('clamps alpha to 0-1', () {
      expect(parseOklch('oklch(0 0 0 / 2)')?.a, 1);
      expect(parseOklch('oklch(0 0 0 / -1)')?.a, 0);
    });

    test('matches the reference grey for L=0.5 with no chroma', () {
      final color = parseOklch('oklch(0.5 0 0)');
      expect(color, isNotNull);

      // Achromatic, so all three channels agree.
      expect(color!.r, closeTo(color.g, 1e-9));
      expect(color.g, closeTo(color.b, 1e-9));

      // oklch(0.5 0 0) is #636363 — sRGB 99, not 128. OKLab lightness is
      // perceptual, so a naive 0.5 * 255 would be badly wrong. This value is
      // the check that the transfer function and matrices are both right.
      expect(formatHex(color.r, color.g, color.b), '#636363');
    });

    test('clips out-of-gamut chroma into range', () {
      final color = parseOklch('oklch(0.7 0.4 30)');
      expect(color, isNotNull);
      for (final channel in [color!.r, color.g, color.b]) {
        expect(channel, greaterThanOrEqualTo(0));
        expect(channel, lessThanOrEqualTo(255));
      }
    });

    test('hue rotates the result', () {
      final red = parseOklch('oklch(0.6 0.15 30)')!;
      final blue = parseOklch('oklch(0.6 0.15 250)')!;
      expect(red.r, greaterThan(red.b));
      expect(blue.b, greaterThan(blue.r));
    });

    test('returns null for values that are not oklch()', () {
      expect(parseOklch('#FFFFFF'), isNull);
      expect(parseOklch('rgb(0, 0, 0)'), isNull);
      expect(parseOklch('oklch(0 0)'), isNull);
      expect(parseOklch('oklch(a b c)'), isNull);
    });
  });

  group('oklchToRgba', () {
    test('L=0 is black and L=1 is white', () {
      expect(
        oklchToRgba(l: 0, c: 0, h: 0).isCloseTo(AstryxRgba.black),
        isTrue,
      );
      expect(
        oklchToRgba(
          l: 1,
          c: 0,
          h: 0,
        ).isCloseTo(AstryxRgba.white, epsilon: 1e-3),
        isTrue,
      );
    });
  });
}
