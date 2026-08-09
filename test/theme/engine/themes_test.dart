import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/engine/theme_registry.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';
import '../../support/theme_input.dart';

/// The Phase 2 exit criterion.
///
/// Every one of the seven prebuilt Astryx themes is run through the Dart
/// engine — `defineTheme` and all four scale expanders — and every resolved
/// token is diffed against the same theme resolved by the upstream TypeScript,
/// in both modes.
///
/// The fixture records each theme's *input* to `defineTheme`, not only its
/// output, so this really does exercise the engine rather than replaying a
/// snapshot. These are the hardest inputs available: real themes with seeded
/// colour scales, custom type scales, radius and motion configuration, syntax
/// palettes and hand-written component overrides.
void main() {
  const expectedThemes = <String>[
    'neutral',
    'matcha',
    'stone',
    'gothic',
    'chocolate',
    'y2k',
    'butter',
  ];

  late Map<String, dynamic> fixture;
  late List<Map<String, dynamic>> themes;

  setUpAll(() {
    fixture = loadEngineFixture('themes');
    themes = asObjects(fixture['themes']);
  });

  tearDown(resetThemes);

  test('the fixture covers all seven prebuilt themes', () {
    expect(themes.map((t) => t['name']), expectedThemes);
  });

  for (final name in expectedThemes) {
    group(name, () {
      late Map<String, dynamic> record;
      late AstryxDefinedTheme theme;

      setUp(() {
        record = themes.firstWhere((t) => t['name'] == name);
        theme = defineTheme(
          decodeThemeInput(record['input']! as Map<String, dynamic>),
        );
      });

      test('produces the same token overrides as upstream', () {
        expect(theme.name, name);
        expect(theme.tokens, record['tokens']);
      });

      test('produces the same component overrides as upstream', () {
        expect(
          theme.components,
          decodeComponents(record['components'] as Map<String, dynamic>?),
        );
      });

      test('produces the same on-media overrides as upstream', () {
        expect(
          theme.onDark!.tokens,
          (record['onDark']! as Map<String, dynamic>)['tokens'],
        );
        expect(
          theme.onLight!.tokens,
          (record['onLight']! as Map<String, dynamic>)['tokens'],
        );
      });

      test('resolves every core token identically in light mode', () {
        expectCoreTokensMatch(
          resolveThemeTokens(theme, AstryxThemeMode.light),
          record['resolvedLight']! as Map<String, dynamic>,
          reason: '$name / light',
        );
      });

      test('resolves every core token identically in dark mode', () {
        expectCoreTokensMatch(
          resolveThemeTokens(theme, AstryxThemeMode.dark),
          record['resolvedDark']! as Map<String, dynamic>,
          reason: '$name / dark',
        );
      });

      test('leaves no unresolved reference or colour function behind', () {
        // A token that still reads `var(...)` after resolution would silently
        // paint as nothing in Layer 2. The only legitimate survivors are the
        // colour spaces the resolver deliberately refuses.
        for (final mode in AstryxThemeMode.values) {
          final resolved = resolveThemeTokens(theme, mode);
          for (final key in astryxTokenDefaults.keys) {
            final value = resolved[key]!;
            if (value.contains('color-mix(in oklab') ||
                value.contains('color-mix(in oklch')) {
              continue;
            }
            expect(value, isNot(contains('var(')), reason: '$key / $mode');
            expect(
              value,
              isNot(contains('color-mix(')),
              reason: '$key / $mode',
            );
          }
        }
      });
    });
  }

  test('every theme resolves the full 184-token core set', () {
    for (final record in themes) {
      final theme = defineTheme(
        decodeThemeInput(record['input']! as Map<String, dynamic>),
      );
      for (final mode in AstryxThemeMode.values) {
        expect(
          resolveThemeTokens(theme, mode).keys,
          containsAll(astryxTokenDefaults.keys),
          reason: '${record['name']} / $mode',
        );
      }
      resetThemes();
    }
  });
}
