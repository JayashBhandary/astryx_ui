import 'dart:convert';
import 'dart:io';

import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parity check for the generated token layer.
///
/// `dev/fixtures/tokens.json` is extracted directly from
/// `astryx-0.3.0/packages/core/src/theme/tokens.stylex.ts`. If the Dart token
/// layer and that fixture ever disagree, the port has drifted from upstream —
/// which is exactly the class of bug that is otherwise invisible until a theme
/// renders wrong.
void main() {
  late Map<String, dynamic> fixture;
  late Map<String, String> flat;
  late Map<String, Map<String, String>> groups;

  setUpAll(() {
    // `flutter test` runs with the package root as the working directory.
    final file = File('../dev/fixtures/tokens.json');
    expect(
      file.existsSync(),
      isTrue,
      reason:
          'Fixture missing. Regenerate with: node dev/tools/extract-tokens.mjs',
    );

    fixture = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
    flat = (fixture['flat'] as Map<String, dynamic>).cast<String, String>();
    groups = (fixture['groups'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, dynamic>).cast<String, String>(),
      ),
    );
  });

  group('astryxTokenDefaults', () {
    test('is pinned to upstream 0.3.0', () {
      expect(fixture['upstreamVersion'], '0.3.0');
    });

    test('holds every token the fixture does, and no others', () {
      expect(astryxTokenDefaults.keys.toSet(), flat.keys.toSet());
    });

    test('holds 184 tokens', () {
      expect(astryxTokenDefaults, hasLength(184));
      expect(astryxTokenDefaults, hasLength(fixture['total']));
    });

    test('reproduces every default value verbatim', () {
      final mismatches = <String>[];
      for (final entry in flat.entries) {
        final actual = astryxTokenDefaults[entry.key];
        if (actual != entry.value) {
          mismatches.add('${entry.key}: "$actual" != "${entry.value}"');
        }
      }
      expect(mismatches, isEmpty, reason: mismatches.join('\n'));
    });
  });

  group('token name enums', () {
    // Each enum must cover exactly its fixture group — no missing token, no
    // invented one, no typo in a cssName.
    void expectGroupMatches(
      String groupKey,
      Iterable<String> cssNames,
      int expectedCount,
    ) {
      final expected = groups[groupKey]!.keys.toSet();
      expect(cssNames.toSet(), expected);
      expect(cssNames.length, expectedCount);
      expect(cssNames.toSet(), hasLength(cssNames.length));
    }

    test('AstryxColorToken covers the colour group', () {
      expectGroupMatches(
        'color',
        AstryxColorToken.values.map((t) => t.cssName),
        79,
      );
    });

    test('AstryxSpacingToken covers the spacing group', () {
      expectGroupMatches(
        'spacing',
        AstryxSpacingToken.values.map((t) => t.cssName),
        15,
      );
    });

    test('AstryxSizeToken covers the size group', () {
      expectGroupMatches(
        'size',
        AstryxSizeToken.values.map((t) => t.cssName),
        3,
      );
    });

    test('AstryxBorderToken covers the border group', () {
      expectGroupMatches(
        'border',
        AstryxBorderToken.values.map((t) => t.cssName),
        1,
      );
    });

    test('AstryxRadiusToken covers the radius group', () {
      expectGroupMatches(
        'radius',
        AstryxRadiusToken.values.map((t) => t.cssName),
        7,
      );
    });

    test('AstryxShadowToken covers the shadow group', () {
      expectGroupMatches(
        'shadow',
        AstryxShadowToken.values.map((t) => t.cssName),
        8,
      );
    });

    test('AstryxDurationToken covers the duration group', () {
      expectGroupMatches(
        'duration',
        AstryxDurationToken.values.map((t) => t.cssName),
        9,
      );
    });

    test('AstryxEaseToken covers the ease group', () {
      expectGroupMatches(
        'ease',
        AstryxEaseToken.values.map((t) => t.cssName),
        1,
      );
    });

    test('AstryxTypographyToken covers the typography group', () {
      expectGroupMatches(
        'typography',
        AstryxTypographyToken.values.map((t) => t.cssName),
        3,
      );
    });

    test('AstryxTextSizeToken covers the text size group', () {
      expectGroupMatches(
        'textSize',
        AstryxTextSizeToken.values.map((t) => t.cssName),
        12,
      );
    });

    test('AstryxFontWeightToken covers the font weight group', () {
      expectGroupMatches(
        'fontWeight',
        AstryxFontWeightToken.values.map((t) => t.cssName),
        4,
      );
    });

    test('AstryxTypeToken covers the type scale group', () {
      expectGroupMatches(
        'typeScale',
        AstryxTypeToken.values.map((t) => t.cssName),
        42,
      );
    });

    test('every enum cssName resolves in astryxTokenDefaults', () {
      final allNames = <String>[
        ...AstryxColorToken.values.map((t) => t.cssName),
        ...AstryxSpacingToken.values.map((t) => t.cssName),
        ...AstryxSizeToken.values.map((t) => t.cssName),
        ...AstryxBorderToken.values.map((t) => t.cssName),
        ...AstryxRadiusToken.values.map((t) => t.cssName),
        ...AstryxShadowToken.values.map((t) => t.cssName),
        ...AstryxDurationToken.values.map((t) => t.cssName),
        ...AstryxEaseToken.values.map((t) => t.cssName),
        ...AstryxTypographyToken.values.map((t) => t.cssName),
        ...AstryxTextSizeToken.values.map((t) => t.cssName),
        ...AstryxFontWeightToken.values.map((t) => t.cssName),
        ...AstryxTypeToken.values.map((t) => t.cssName),
      ];

      expect(allNames, hasLength(184));
      expect(allNames.toSet(), hasLength(184), reason: 'names must be unique');
      for (final name in allNames) {
        expect(astryxTokenDefaults, contains(name));
      }
    });
  });

  group('structural expectations the theme engine relies on', () {
    test('every token name is a CSS custom property', () {
      for (final name in astryxTokenDefaults.keys) {
        expect(name, startsWith('--'));
      }
    });

    test('type scale sizes are var() references, not literals', () {
      // Phase 2's resolver has to follow these. If upstream ever inlines them,
      // the resolver's reference-following path stops being exercised.
      expect(
        astryxTokenDefaults[AstryxTypeToken.heading1Size.cssName],
        startsWith('var('),
      );
    });

    test('type scale leadings are unitless ratios', () {
      // They map directly onto TextStyle.height, which is also unitless.
      final leading =
          astryxTokenDefaults[AstryxTypeToken.heading1Leading.cssName]!;
      expect(double.tryParse(leading), isNotNull);
      expect(leading, isNot(contains('px')));
    });

    test('element sizes are all below the 44px touch minimum', () {
      // The premise behind AstryxDensity (ADR-006). If upstream ever raises
      // these, revisit that decision rather than silently keeping the floor.
      for (final token in AstryxSizeToken.values) {
        final px = double.parse(
          astryxTokenDefaults[token.cssName]!.replaceAll('px', ''),
        );
        expect(px, lessThan(44));
      }
    });
  });
}
