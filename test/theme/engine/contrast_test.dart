import 'package:astryx_ui/src/theme/color/css_color.dart';
import 'package:astryx_ui/src/theme/color/rgba.dart';
import 'package:astryx_ui/src/theme/engine/contrast.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

AstryxRgba _rgba(Map<String, dynamic> json) => AstryxRgba(
  r: asDouble(json['r']),
  g: asDouble(json['g']),
  b: asDouble(json['b']),
  a: asDouble(json['a']),
);

/// Parity tests for the contrast port.
///
/// The first half transcribes `contrast.test.ts`; the second diffs against
/// `dev/fixtures/engine/contrast.json`, recorded from the upstream module.
void main() {
  group('relativeLuminance', () {
    test('is 0 for black and 1 for white', () {
      expect(relativeLuminance(AstryxRgba.black), 0);
      expect(relativeLuminance(AstryxRgba.white), closeTo(1, 1e-10));
    });

    test('weights channels per WCAG — green brightest, blue darkest', () {
      const red = AstryxRgba(r: 255, g: 0, b: 0);
      const green = AstryxRgba(r: 0, g: 255, b: 0);
      const blue = AstryxRgba(r: 0, g: 0, b: 255);
      expect(relativeLuminance(red), closeTo(0.2126, 1e-4));
      expect(relativeLuminance(green), closeTo(0.7152, 1e-4));
      expect(relativeLuminance(blue), closeTo(0.0722, 1e-4));
    });
  });

  group('contrastRatio', () {
    test('is 21 for black on white and 1 for identical colours', () {
      expect(contrastRatio('#000000', '#FFFFFF'), closeTo(21, 1e-5));
      expect(contrastRatio('#3B82F6', '#3B82F6'), 1);
    });

    test('is symmetric in foreground and background for opaque colours', () {
      expect(
        contrastRatio('#0064E0', '#FCFDFE'),
        closeTo(contrastRatio('#FCFDFE', '#0064E0'), 1e-10),
      );
    });

    test('matches the canonical 4.5:1 boundary grey — #767676 on white', () {
      final ratio = contrastRatio('#767676', '#FFFFFF');
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, lessThan(4.6));
    });

    test('composites a translucent foreground over the background', () {
      // 50% black over white paints as mid-grey, not black.
      final composited = contrastRatio('rgba(0, 0, 0, 0.5)', '#FFFFFF');
      expect(composited, lessThan(contrastRatio('#000000', '#FFFFFF')));
      expect(
        composited,
        closeTo(contrastRatio('rgb(127.5, 127.5, 127.5)', '#FFFFFF'), 1e-10),
      );
    });

    test('rejects a translucent background', () {
      expect(
        () => contrastRatio('#000000', '#FFFFFF80'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('background must be opaque'),
          ),
        ),
      );
    });

    test('rejects unparseable colours', () {
      expect(
        () => contrastRatio('var(--color-accent)', '#FFFFFF'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('could not parse foreground'),
          ),
        ),
      );
      expect(
        () => contrastRatio('#000000', 'oklch(0.5 0.1 200)'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('could not parse background'),
          ),
        ),
      );
    });

    test('accepts already-parsed colours as well as strings', () {
      final fg = parseColor('#000000')!;
      expect(contrastRatio(fg, AstryxRgba.white), closeTo(21, 1e-5));
    });
  });

  group('compositeOver', () {
    test('returns the foreground when opaque, the backdrop at alpha 0', () {
      final fg = parseColor('#123456')!;
      final bg = parseColor('#FFFFFF')!;
      expect(compositeOver(fg, bg), fg.copyWith(a: 1));
      expect(compositeOver(fg.copyWith(a: 0), bg), bg.copyWith(a: 1));
    });

    test('blends in gamma-encoded sRGB space, like CSS', () {
      final fg = parseColor('rgba(0, 0, 0, 0.5)')!;
      final bg = parseColor('#FFFFFF')!;
      final out = compositeOver(fg, bg);
      expect(out.r, closeTo(127.5, 1e-5));
      expect(out.g, closeTo(127.5, 1e-5));
      expect(out.b, closeTo(127.5, 1e-5));
      expect(out.a, 1);
    });
  });

  group('upstream parity', () {
    late Map<String, dynamic> fixture;

    setUpAll(() => fixture = loadEngineFixture('contrast'));

    test('relativeLuminance matches upstream', () {
      for (final c in asObjects(fixture['relativeLuminance'])) {
        final color = _rgba(c['color']! as Map<String, dynamic>);
        expect(
          relativeLuminance(color),
          asDouble(c['luminance']),
          reason: '$color',
        );
      }
    });

    test('contrastRatio matches upstream for every recorded pair', () {
      final cases = asObjects(fixture['contrastRatio']);
      expect(cases, isNotEmpty);

      for (final c in cases) {
        final fg = c['fg']! as String;
        final bg = c['bg']! as String;
        expect(contrastRatio(fg, bg), asDouble(c['ratio']), reason: '$fg/$bg');
      }
    });

    test('compositeOver matches upstream', () {
      for (final c in asObjects(fixture['compositeOver'])) {
        final fg = _rgba(c['fg']! as Map<String, dynamic>);
        final bg = _rgba(c['bg']! as Map<String, dynamic>);
        expect(
          compositeOver(fg, bg),
          _rgba(c['result']! as Map<String, dynamic>),
        );
      }
    });
  });
}
