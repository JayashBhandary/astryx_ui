import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';
import 'package:flutter_test/flutter_test.dart';

/// Transcribed from `astryx-0.3.0/packages/core/src/utils/color.test.ts`.
///
/// Every assertion in the upstream suite appears here, in the same order, with
/// two exceptions noted at the bottom of the file.
void main() {
  group('parseHex', () {
    test('parses #rrggbb', () {
      expect(parseHex('#0064E0'), const AstryxRgba(r: 0, g: 100, b: 224));
    });

    test('parses a body without the leading hash', () {
      expect(parseHex('0064E0'), const AstryxRgba(r: 0, g: 100, b: 224));
    });

    test('expands #rgb shorthand', () {
      expect(parseHex('#abc'), const AstryxRgba(r: 0xaa, g: 0xbb, b: 0xcc));
    });

    test('parses #rrggbbaa alpha', () {
      expect(
        parseHex('#00000080'),
        const AstryxRgba(r: 0, g: 0, b: 0, a: 128 / 255),
      );
    });

    test('expands #rgba shorthand', () {
      expect(
        parseHex('#f008'),
        const AstryxRgba(r: 255, g: 0, b: 0, a: 0x88 / 255),
      );
    });

    test('returns null for anything that is not hex', () {
      expect(parseHex('rgb(0,0,0)'), isNull);
      expect(parseHex('#12'), isNull);
      expect(parseHex('#zzzzzz'), isNull);
    });
  });

  group('parseRgb', () {
    test('parses comma-separated channels', () {
      expect(
        parseRgb('rgb(0, 100, 224)'),
        const AstryxRgba(r: 0, g: 100, b: 224),
      );
    });

    test('parses rgba() with alpha', () {
      expect(
        parseRgb('rgba(0, 0, 0, 0.5)'),
        const AstryxRgba(r: 0, g: 0, b: 0, a: 0.5),
      );
    });

    test('parses space-separated channels with slash alpha', () {
      expect(
        parseRgb('rgb(0 100 224 / 0.25)'),
        const AstryxRgba(r: 0, g: 100, b: 224, a: 0.25),
      );
    });

    test('parses percentage channels', () {
      expect(
        parseRgb('rgb(100%, 0%, 0%)'),
        const AstryxRgba(r: 255, g: 0, b: 0),
      );
    });

    test('clamps out-of-range channels and alpha', () {
      expect(
        parseRgb('rgba(300, -20, 10, 2)'),
        const AstryxRgba(r: 255, g: 0, b: 10),
      );
    });

    test('returns null for too few channels or a non-rgb value', () {
      expect(parseRgb('rgb(0, 0)'), isNull);
      expect(parseRgb('#000000'), isNull);
    });
  });

  group('parseColor', () {
    test('delegates to the hex and rgb parsers', () {
      expect(parseColor('#FFFFFF'), AstryxRgba.white);
      expect(parseColor('rgb(1, 2, 3)'), const AstryxRgba(r: 1, g: 2, b: 3));
    });

    test('resolves named colours case-insensitively', () {
      expect(parseColor('transparent'), AstryxRgba.transparent);
      expect(parseColor('BLACK'), AstryxRgba.black);
      expect(parseColor('white'), AstryxRgba.white);
    });

    test('returns null rather than guessing at values it cannot evaluate', () {
      expect(parseColor('var(--color-accent)'), isNull);
      expect(parseColor('oklch(0.5 0.1 200)'), isNull);
      expect(parseColor('rebeccapurple'), isNull);
    });

    test('returns null for the functions the resolver owns', () {
      // Not upstream assertions, but they pin the layer boundary: light-dark()
      // and color-mix() are the resolver's job, not the parser's.
      expect(parseColor('light-dark(#FFFFFF, #000000)'), isNull);
      expect(parseColor('color-mix(in srgb, #000, #FFF)'), isNull);
    });
  });

  group('formatHex', () {
    test('formats channels as uppercase hex', () {
      expect(formatHex(0, 100, 224), '#0064E0');
    });

    test('clamps and rounds out-of-range channels', () {
      expect(formatHex(-5, 300, 127.6), '#00FF80');
    });
  });

  group('formatColor', () {
    test('uses hex when fully opaque', () {
      expect(formatColor(const AstryxRgba(r: 0, g: 100, b: 224)), '#0064E0');
    });

    test('uses rgba() when translucent', () {
      expect(
        formatColor(const AstryxRgba(r: 0, g: 100, b: 224, a: 0.2)),
        'rgba(0, 100, 224, 0.2)',
      );
    });

    test('round-trips through parseColor', () {
      final parsed = parseColor('rgba(10, 20, 30, 0.5)');
      expect(parsed, isNotNull);
      expect(formatColor(parsed!), 'rgba(10, 20, 30, 0.5)');
    });

    test('renders a whole-number alpha without a trailing .0', () {
      // Dart prints 0.0 where JavaScript prints 0. formatColor must match
      // upstream's string output exactly, not just its numeric value.
      expect(
        formatColor(const AstryxRgba(r: 1, g: 2, b: 3, a: 0)),
        'rgba(1, 2, 3, 0)',
      );
    });

    test('rounds alpha to four decimal places', () {
      expect(
        formatColor(const AstryxRgba(r: 0, g: 0, b: 0, a: 128 / 255)),
        'rgba(0, 0, 0, 0.502)',
      );
    });
  });

  group('parseFloatLoose', () {
    test('parses a leading number and ignores the suffix', () {
      // JavaScript's parseFloat behaviour, which parseRgb depends on for
      // percentage channels. double.tryParse would return null here.
      expect(parseFloatLoose('50%'), 50);
      expect(parseFloatLoose('  -12.5deg'), -12.5);
      expect(parseFloatLoose('.5'), 0.5);
      expect(parseFloatLoose('1e2'), 100);
    });

    test('returns NaN when there is no leading number', () {
      expect(parseFloatLoose('abc'), isNaN);
      expect(parseFloatLoose(''), isNaN);
    });
  });
}

// Not transcribed, deliberately:
//
//   * `parseHex(null)` — Dart's type system makes the case unrepresentable.
//   * the whole `toGLFloats` suite — a WebGL helper for the charts package,
//     which is out of scope for 1.0 (see dev/reference/COMPONENT-INVENTORY.md).
