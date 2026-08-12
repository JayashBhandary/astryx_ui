import 'package:astryx_ui/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// The syntax palette: the one part of the token set that is **optional**, and
/// the only accessor on `AstryxThemeData` that may return null.
void main() {
  group('AstryxSyntaxToken', () {
    test('mirrors the fourteen string keys, in order', () {
      expect(
        AstryxSyntaxToken.values.map((token) => token.key),
        astryxSyntaxTokenKeys,
      );
    });

    test('names itself with the upstream prefix', () {
      expect(
        AstryxSyntaxToken.keyword.cssName,
        '${astryxSyntaxTokenPrefix}keyword',
      );
      expect(AstryxSyntaxToken.background.cssName, '--color-syntax-background');
    });
  });

  group('AstryxThemeData.syntaxColor', () {
    test('reads a palette the theme carries, per mode', () {
      final light = AstryxThemeData.resolve(
        theme: neutralTheme,
        mode: AstryxThemeMode.light,
      );
      final dark = AstryxThemeData.resolve(
        theme: neutralTheme,
        mode: AstryxThemeMode.dark,
      );

      expect(light.hasSyntaxPalette, isTrue);
      expect(light.syntaxColor(AstryxSyntaxToken.keyword), isNotNull);
      // `light-dark()` is resolved per mode like every other colour token, so
      // the two halves of a palette are not the same value.
      expect(
        light.syntaxColor(AstryxSyntaxToken.keyword),
        isNot(dark.syntaxColor(AstryxSyntaxToken.keyword)),
      );
    });

    test('every prebuilt theme carries a complete palette', () {
      for (final theme in <AstryxDefinedTheme>[
        neutralTheme,
        stoneTheme,
        butterTheme,
        chocolateTheme,
        gothicTheme,
        matchaTheme,
        y2kTheme,
      ]) {
        final data = AstryxThemeData.resolve(
          theme: theme,
          mode: AstryxThemeMode.light,
        );
        expect(
          data.syntaxPalette.length,
          AstryxSyntaxToken.values.length,
          reason: 'a theme with a partial palette would highlight unevenly',
        );
      }
    });

    test('is null on the bare defaults rather than throwing', () {
      final data = AstryxThemeData.resolve(mode: AstryxThemeMode.light);

      // A palette sits outside the 184 core tokens, so an unthemed app has
      // none — and throwing would punish a caller for the theme's silence.
      expect(data.hasSyntaxPalette, isFalse);
      expect(data.syntaxColor(AstryxSyntaxToken.string), isNull);
      expect(data.syntaxPalette, isEmpty);
    });

    test('the returned palette cannot be mutated', () {
      final data = AstryxThemeData.resolve(
        theme: neutralTheme,
        mode: AstryxThemeMode.light,
      );

      expect(
        () => data.syntaxPalette.remove(AstryxSyntaxToken.keyword),
        throwsUnsupportedError,
      );
    });
  });
}
