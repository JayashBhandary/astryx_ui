import 'package:astryx_ui/src/theme/color/color_value.dart';
import 'package:astryx_ui/src/theme/color/light_dark.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splitTopLevelComma', () {
    test('splits on the first top-level comma', () {
      final split = splitTopLevelComma('#FFF, #000');
      expect(split?.before, '#FFF');
      expect(split?.after, ' #000');
    });

    test('ignores commas nested inside functions', () {
      // The whole reason this is not a regex: rgba() has two inner commas
      // before the top-level one.
      final split = splitTopLevelComma('rgba(5, 54, 89, 0.1), #FFF');
      expect(split?.before, 'rgba(5, 54, 89, 0.1)');
      expect(split?.after, ' #FFF');
    });

    test('ignores commas nested several levels deep', () {
      final split = splitTopLevelComma(
        'color-mix(in srgb, var(--a), rgba(1, 2, 3, 1) 20%), #000',
      );
      expect(
        split?.before,
        'color-mix(in srgb, var(--a), rgba(1, 2, 3, 1) 20%)',
      );
      expect(split?.after, ' #000');
    });

    test('ignores commas inside quoted strings', () {
      final split = splitTopLevelComma('"Segoe UI, Bold", Roboto');
      expect(split?.before, '"Segoe UI, Bold"');
      expect(split?.after, ' Roboto');
    });

    test('returns null when there is no top-level comma', () {
      expect(splitTopLevelComma('#FFFFFF'), isNull);
      expect(splitTopLevelComma('rgba(1, 2, 3, 1)'), isNull);
    });
  });

  group('parseLightDark', () {
    test('splits a simple pair', () {
      expect(
        parseLightDark('light-dark(#FFFFFF, #1F1F22)'),
        const AstryxColorValue(light: '#FFFFFF', dark: '#1F1F22'),
      );
    });

    test('splits a pair whose sides contain commas', () {
      expect(
        parseLightDark(
          'light-dark(rgba(5, 54, 89, 0.1), rgba(223, 226, 229, 0.2))',
        ),
        const AstryxColorValue(
          light: 'rgba(5, 54, 89, 0.1)',
          dark: 'rgba(223, 226, 229, 0.2)',
        ),
      );
    });

    test('trims whitespace around each side', () {
      expect(
        parseLightDark('light-dark(  #FFF ,  #000  )'),
        const AstryxColorValue(light: '#FFF', dark: '#000'),
      );
    });

    test('returns null for values that are not light-dark()', () {
      expect(parseLightDark('#FFFFFF'), isNull);
      expect(parseLightDark('color-mix(in srgb, #000, #FFF)'), isNull);
      expect(parseLightDark('light-dark(#FFF)'), isNull);
    });
  });

  group('isLightDark', () {
    test('recognises the expression without parsing it', () {
      expect(isLightDark('light-dark(#FFF, #000)'), isTrue);
      expect(isLightDark('  light-dark(#FFF, #000)  '), isTrue);
      expect(isLightDark('#FFF'), isFalse);
    });
  });

  group('AstryxColorValue', () {
    test('resolves the requested side', () {
      const value = AstryxColorValue(light: 'L', dark: 'D');
      expect(value.resolve(brightnessIsDark: false), 'L');
      expect(value.resolve(brightnessIsDark: true), 'D');
    });

    test('reports uniform pairs', () {
      expect(const AstryxColorValue.same('#FFF').isUniform, isTrue);
      expect(
        const AstryxColorValue(light: '#FFF', dark: '#000').isUniform,
        isFalse,
      );
    });

    test('compares by value', () {
      expect(
        const AstryxColorValue(light: 'a', dark: 'b'),
        const AstryxColorValue(light: 'a', dark: 'b'),
      );
      expect(
        const AstryxColorValue(light: 'a', dark: 'b'),
        isNot(const AstryxColorValue(light: 'a', dark: 'c')),
      );
    });
  });
}
