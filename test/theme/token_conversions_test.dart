import 'package:astryx_ui/src/theme/astryx_shadow.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/token_conversions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the string → Flutter value converters.
void main() {
  group('parseCssLength', () {
    test('parses px', () {
      expect(parseCssLength('16px'), 16.0);
      expect(parseCssLength('0px'), 0.0);
      expect(parseCssLength('9999px'), 9999.0);
      expect(parseCssLength(' 28px '), 28.0);
    });

    test('parses rem against the 16px root', () {
      expect(parseCssLength('1rem'), 16.0);
      expect(parseCssLength('0.875rem'), 14.0);
      expect(parseCssLength('2.625rem'), 42.0);
    });

    test('honours a custom root font size', () {
      expect(parseCssLength('1rem', rootFontSize: 10), 10.0);
    });

    test('parses a bare number', () {
      expect(parseCssLength('0'), 0.0);
      expect(parseCssLength('1.5'), 1.5);
    });

    test('returns null for what it cannot parse', () {
      expect(parseCssLength(''), isNull);
      expect(parseCssLength('50%'), isNull);
      expect(parseCssLength('calc(100% - 4px)'), isNull);
      expect(parseCssLength('auto'), isNull);
    });
  });

  group('parseCssColor', () {
    test('parses hex, rgba and the named colours', () {
      expect(
        parseCssColor('#0064E0', AstryxThemeMode.light),
        const Color(0xFF0064E0),
      );
      expect(
        parseCssColor('rgba(5, 54, 89, 0.1)', AstryxThemeMode.light),
        const Color(0x1A053659),
      );
      expect(
        parseCssColor('black', AstryxThemeMode.light),
        const Color(0xFF000000),
      );
      expect(
        parseCssColor('white', AstryxThemeMode.light),
        const Color(0xFFFFFFFF),
      );
    });

    test('parses eight-digit hex alpha', () {
      expect(
        parseCssColor('#01122866', AstryxThemeMode.light),
        const Color(0x66011228),
      );
    });

    test('selects the half matching the mode', () {
      const value = 'light-dark(#0064E0, #2694FE)';
      expect(
        parseCssColor(value, AstryxThemeMode.light),
        const Color(0xFF0064E0),
      );
      expect(
        parseCssColor(value, AstryxThemeMode.dark),
        const Color(0xFF2694FE),
      );
    });

    test('parses oklch, which appears inside shadow values', () {
      expect(
        parseCssColor('oklch(0 0 0 / 25%)', AstryxThemeMode.light),
        const Color(0x40000000),
      );
    });

    test('returns null for what it cannot evaluate', () {
      expect(parseCssColor('var(--nope)', AstryxThemeMode.light), isNull);
      expect(parseCssColor('rebeccapurple', AstryxThemeMode.light), isNull);
    });
  });

  group('parseCssDuration', () {
    test('parses milliseconds and seconds', () {
      expect(parseCssDuration('175ms'), const Duration(milliseconds: 175));
      expect(parseCssDuration('1300ms'), const Duration(milliseconds: 1300));
      expect(parseCssDuration('0.3s'), const Duration(milliseconds: 300));
      expect(parseCssDuration('2s'), const Duration(seconds: 2));
    });

    test('keeps sub-millisecond precision', () {
      expect(parseCssDuration('0.5ms'), const Duration(microseconds: 500));
    });

    test('returns null for a non-time', () {
      expect(parseCssDuration('175'), isNull);
      expect(parseCssDuration('fast'), isNull);
    });
  });

  group('parseCssCurve', () {
    // `Cubic` has no `==`, so two separately built curves are never equal.
    // Comparing control points is the only meaningful check.
    void expectCubic(Curve? actual, Cubic expected) {
      expect(actual, isA<Cubic>());
      final cubic = actual! as Cubic;
      expect(
        <double>[cubic.a, cubic.b, cubic.c, cubic.d],
        <double>[expected.a, expected.b, expected.c, expected.d],
      );
    }

    test('parses cubic-bezier', () {
      expectCubic(
        parseCssCurve('cubic-bezier(0.24, 1, 0.4, 1)'),
        const Cubic(0.24, 1, 0.4, 1),
      );
    });

    test('parses the keywords', () {
      expect(parseCssCurve('linear'), Curves.linear);
      expectCubic(parseCssCurve('ease'), const Cubic(0.25, 0.1, 0.25, 1));
      expectCubic(parseCssCurve('ease-in'), const Cubic(0.42, 0, 1, 1));
      expectCubic(parseCssCurve('ease-out'), const Cubic(0, 0, 0.58, 1));
      expectCubic(parseCssCurve('ease-in-out'), const Cubic(0.42, 0, 0.58, 1));
    });

    test('returns null for the unsupported forms', () {
      expect(parseCssCurve('steps(4, end)'), isNull);
      expect(parseCssCurve('cubic-bezier(0.24, 1, 0.4)'), isNull);
      expect(parseCssCurve('wobble'), isNull);
    });
  });

  group('parseCssFontWeight', () {
    test('parses the numeric steps', () {
      expect(parseCssFontWeight('400'), FontWeight.w400);
      expect(parseCssFontWeight('500'), FontWeight.w500);
      expect(parseCssFontWeight('600'), FontWeight.w600);
      expect(parseCssFontWeight('700'), FontWeight.w700);
      expect(parseCssFontWeight('900'), FontWeight.w900);
    });

    test('parses the keywords', () {
      expect(parseCssFontWeight('normal'), FontWeight.w400);
      expect(parseCssFontWeight('bold'), FontWeight.w700);
    });

    test('snaps to the nearest hundred and clamps', () {
      expect(parseCssFontWeight('450'), FontWeight.w500);
      expect(parseCssFontWeight('1'), FontWeight.w100);
      expect(parseCssFontWeight('5000'), FontWeight.w900);
    });

    test('returns null for a non-weight', () {
      expect(parseCssFontWeight('heavy'), isNull);
    });
  });

  group('astryxCssBlurToFlutterRadius', () {
    test('is zero for a zero or negative CSS blur', () {
      expect(astryxCssBlurToFlutterRadius(0), 0);
      expect(astryxCssBlurToFlutterRadius(-4), 0);
    });

    test('produces the radius whose sigma equals the CSS sigma', () {
      // CSS blurs with sigma = B / 2; Flutter with
      // sigma = radius * 0.57735 + 0.5.
      for (final cssBlur in <double>[1, 2, 4, 8, 12, 24]) {
        final radius = astryxCssBlurToFlutterRadius(cssBlur);
        final flutterSigma = radius * 0.57735 + 0.5;
        expect(flutterSigma, closeTo(cssBlur / 2, 1e-9), reason: '$cssBlur');
      }
    });

    test('clamps rather than going negative for a tiny blur', () {
      expect(astryxCssBlurToFlutterRadius(0.5), 0);
    });
  });

  group('parseCssShadows', () {
    test('parses a two-layer shadow', () {
      const value =
          '0px 1px 1px rgba(0, 0, 0, 0.1), 0px 2px 8px rgba(0, 0, 0, 0.2)';
      final shadows = parseCssShadows(value, AstryxThemeMode.light);

      expect(shadows, hasLength(2));
      expect(shadows[0].offset, const Offset(0, 1));
      expect(shadows[0].color, const Color(0x1A000000));
      expect(shadows[0].inset, isFalse);
      expect(shadows[1].offset, const Offset(0, 2));
      expect(
        shadows[1].blurRadius,
        closeTo(astryxCssBlurToFlutterRadius(8), 1e-9),
      );
    });

    test('selects the mode inside a nested light-dark()', () {
      // Shadow tokens are not themselves light-dark() expressions, so the
      // resolver leaves the inner ones intact and this is where they resolve.
      const value =
          '0px 1px 1px light-dark(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.2))';
      expect(
        parseCssShadows(value, AstryxThemeMode.light).single.color,
        const Color(0x1A000000),
      );
      expect(
        parseCssShadows(value, AstryxThemeMode.dark).single.color,
        const Color(0x33000000),
      );
    });

    test('parses an inset shadow with a spread', () {
      const value = 'inset 0px 0px 0px 2px rgba(1, 113, 227, 0.5)';
      final shadow = parseCssShadows(value, AstryxThemeMode.light).single;

      expect(shadow.inset, isTrue);
      expect(shadow.offset, Offset.zero);
      expect(shadow.blurRadius, 0);
      expect(shadow.spreadRadius, 2);
      expect(shadow.color, const Color(0x800171E3));
    });

    test('returns nothing for none or an empty value', () {
      expect(parseCssShadows('none', AstryxThemeMode.light), isEmpty);
      expect(parseCssShadows('   ', AstryxThemeMode.light), isEmpty);
    });

    test('skips a malformed layer and keeps the rest', () {
      const value = 'nonsense, 0px 2px 4px #000000';
      expect(parseCssShadows(value, AstryxThemeMode.light), hasLength(1));
    });
  });

  group('AstryxShadow', () {
    const shadow = AstryxShadow(
      color: Color(0xFF112233),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 1,
    );

    test('converts to a BoxShadow', () {
      expect(
        shadow.toBoxShadow(),
        const BoxShadow(
          color: Color(0xFF112233),
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      );
    });

    test('refuses to convert an inset shadow through toBoxShadowOrNull', () {
      const inset = AstryxShadow(color: Color(0xFF000000), inset: true);
      expect(inset.toBoxShadowOrNull(), isNull);
      expect(shadow.toBoxShadowOrNull(), isNotNull);
    });

    test('lerps between two shadows', () {
      const other = AstryxShadow(
        color: Color(0xFF112233),
        offset: Offset(0, 6),
        blurRadius: 8,
        spreadRadius: 3,
      );
      final mid = AstryxShadow.lerp(shadow, other, 0.5)!;
      expect(mid.offset, const Offset(0, 4));
      expect(mid.blurRadius, 6);
      expect(mid.spreadRadius, 2);
    });

    test('lerps lists of different lengths', () {
      final list = AstryxShadow.lerpList(
        const <AstryxShadow>[shadow],
        const <AstryxShadow>[shadow, shadow],
        0.5,
      )!;
      expect(list, hasLength(2));
    });

    test('is a value type', () {
      expect(
        shadow,
        const AstryxShadow(
          color: Color(0xFF112233),
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      );
    });
  });

  group('selectMode', () {
    test('passes a plain value through', () {
      expect(selectMode('16px', AstryxThemeMode.dark), '16px');
    });

    test('splits a light-dark() with nested commas correctly', () {
      const value =
          'light-dark(rgba(5, 54, 89, 0.1), rgba(223, 226, 229, 0.2))';
      expect(
        selectMode(value, AstryxThemeMode.light),
        'rgba(5, 54, 89, 0.1)',
      );
      expect(
        selectMode(value, AstryxThemeMode.dark),
        'rgba(223, 226, 229, 0.2)',
      );
    });
  });
}
