import 'package:astryx_ui/src/theme/font_stack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the CSS font stack → Flutter font family resolution.
///
/// Open item 5 settled on resolving the system stack per platform and bundling
/// nothing, so these pin what "resolving" means for each shape of stack Astryx
/// and its themes actually ship.
void main() {
  // The two stacks in the Astryx defaults.
  const systemStack =
      '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, '
      'Arial, sans-serif';
  const codeStack = '"SF Mono", Monaco, Consolas, monospace';

  group('a system stack', () {
    test('resolves to the platform default', () {
      final stack = resolveFontStack(
        systemStack,
        platform: TargetPlatform.macOS,
      );
      // Null is the answer, not a failure: Flutter's default *is* the platform
      // UI font, which is what `-apple-system` asks for.
      expect(stack.family, isNull);
      // The families after the alias are dropped, not promoted. A browser
      // never reaches them once the alias resolves, and Flutter's platform
      // default already *is* the Segoe UI or Roboto they name.
      expect(stack.fallbacks, isEmpty);
    });

    test('resolves the same way on every platform', () {
      for (final platform in TargetPlatform.values) {
        expect(
          resolveFontStack(systemStack, platform: platform).family,
          isNull,
          reason: '$platform',
        );
      }
    });

    test('recognises system-ui and the ui-* aliases', () {
      for (final alias in <String>[
        'system-ui',
        'ui-sans-serif',
        'ui-serif',
        'ui-rounded',
      ]) {
        expect(
          resolveFontStack(
            '$alias, Helvetica',
            platform: TargetPlatform.iOS,
          ).family,
          isNull,
          reason: alias,
        );
      }
    });
  });

  group('a named stack', () {
    test('takes the first family as the primary', () {
      final stack = resolveFontStack(
        codeStack,
        platform: TargetPlatform.macOS,
      );
      expect(stack.family, 'SF Mono');
      expect(stack.fallbacks.take(2), <String>['Monaco', 'Consolas']);
    });

    test('honours a theme that asks for a real family', () {
      // Position decides. This is every prebuilt theme's shape — neutral's is
      // `Figtree, -apple-system, …` — so an alias appearing *later* must not
      // make the theme's own font unreachable.
      final stack = resolveFontStack(
        'Figtree, -apple-system, sans-serif',
        platform: TargetPlatform.android,
      );
      expect(stack.family, 'Figtree');
    });

    test('keeps a leading named family when no alias is present', () {
      final stack = resolveFontStack(
        'Figtree, Helvetica, sans-serif',
        platform: TargetPlatform.android,
      );
      expect(stack.family, 'Figtree');
      expect(stack.fallbacks, contains('Helvetica'));
    });

    test('strips quotes from a family name', () {
      expect(
        resolveFontStack(
          '"Geist Mono", monospace',
          platform: TargetPlatform.linux,
        ).family,
        'Geist Mono',
      );
      expect(
        resolveFontStack(
          "'Single Quoted', monospace",
          platform: TargetPlatform.linux,
        ).family,
        'Single Quoted',
      );
    });
  });

  group('generic families', () {
    test('monospace expands to concrete families per platform', () {
      expect(
        resolveFontStack('monospace', platform: TargetPlatform.macOS).fallbacks,
        contains('Menlo'),
      );
      expect(
        resolveFontStack(
          'monospace',
          platform: TargetPlatform.windows,
        ).fallbacks,
        contains('Consolas'),
      );
      expect(
        resolveFontStack(
          'monospace',
          platform: TargetPlatform.android,
        ).fallbacks,
        contains('Roboto Mono'),
      );
    });

    test('serif expands per platform', () {
      expect(
        resolveFontStack('serif', platform: TargetPlatform.iOS).fallbacks,
        contains('Times New Roman'),
      );
    });

    test('sans-serif adds nothing, since the default already is one', () {
      expect(
        resolveFontStack('sans-serif', platform: TargetPlatform.macOS),
        const AstryxFontStack(),
      );
    });

    test('a generic sorts after every named family', () {
      final stack = resolveFontStack(
        codeStack,
        platform: TargetPlatform.macOS,
      );
      expect(
        stack.fallbacks.indexOf('Consolas'),
        lessThan(stack.fallbacks.indexOf('Menlo')),
      );
    });
  });

  group('edge cases', () {
    test('an empty stack resolves to the platform default', () {
      expect(
        resolveFontStack('', platform: TargetPlatform.macOS),
        const AstryxFontStack(),
      );
    });

    test('a lone family becomes the primary with no fallbacks', () {
      expect(
        resolveFontStack('Figtree', platform: TargetPlatform.macOS),
        const AstryxFontStack(family: 'Figtree'),
      );
    });

    test('duplicates are dropped', () {
      final stack = resolveFontStack(
        'Figtree, Helvetica, Helvetica',
        platform: TargetPlatform.macOS,
      );
      expect(stack.fallbacks, <String>['Helvetica']);
    });

    test('aliases are matched case-insensitively', () {
      expect(
        resolveFontStack(
          'BlinkMacSystemFont, Helvetica',
          platform: TargetPlatform.macOS,
        ).family,
        isNull,
      );
    });

    test('a trailing comma is tolerated', () {
      expect(
        resolveFontStack('Figtree, ', platform: TargetPlatform.macOS).family,
        'Figtree',
      );
    });
  });

  group('AstryxFontStack', () {
    test('is a value type', () {
      const a = AstryxFontStack(family: 'A', fallbacks: <String>['B']);
      const b = AstryxFontStack(family: 'A', fallbacks: <String>['B']);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const AstryxFontStack(family: 'A')));
    });
  });
}
