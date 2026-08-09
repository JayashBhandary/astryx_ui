import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';
import '../support/theme_input.dart';

/// Phase 3 — the theme runtime and the seven prebuilt themes.
///
/// The exit criterion is the parity group at the end: every prebuilt theme
/// resolving to the values upstream produces, in both modes, *through* the
/// Layer 2 conversion.
void main() {
  final themes = <String, AstryxDefinedTheme>{
    'neutral': neutralTheme,
    'matcha': matchaTheme,
    'stone': stoneTheme,
    'gothic': gothicTheme,
    'chocolate': chocolateTheme,
    'y2k': y2kTheme,
    'butter': butterTheme,
  };

  group('AstryxColorMode', () {
    test('light and dark ignore the platform brightness', () {
      for (final brightness in Brightness.values) {
        expect(
          AstryxColorMode.light.resolve(brightness),
          AstryxThemeMode.light,
        );
        expect(AstryxColorMode.dark.resolve(brightness), AstryxThemeMode.dark);
      }
    });

    test('system follows the platform brightness', () {
      expect(
        AstryxColorMode.system.resolve(Brightness.light),
        AstryxThemeMode.light,
      );
      expect(
        AstryxColorMode.system.resolve(Brightness.dark),
        AstryxThemeMode.dark,
      );
    });
  });

  group('AstryxDensity', () {
    test('touch platforms resolve to touch, pointer platforms to pointer', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.iOS,
        TargetPlatform.android,
      ]) {
        expect(AstryxDensity.resolve(platform), AstryxDensity.touch);
      }
      for (final platform in <TargetPlatform>[
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        expect(AstryxDensity.resolve(platform), AstryxDensity.pointer);
      }
    });

    test('a known pointer kind overrides the platform', () {
      // The web case: the platform is the host OS, not the input device.
      expect(
        AstryxDensity.resolve(TargetPlatform.android, coarsePointer: false),
        AstryxDensity.pointer,
      );
      expect(
        AstryxDensity.resolve(TargetPlatform.windows, coarsePointer: true),
        AstryxDensity.touch,
      );
    });

    test('carries the hover and tap-target rules', () {
      expect(AstryxDensity.pointer.supportsHover, isTrue);
      expect(AstryxDensity.touch.supportsHover, isFalse);
      expect(AstryxDensity.touch.minimumTapTarget, 48);
      expect(AstryxDensity.pointer.minimumTapTarget, 0);
    });
  });

  group('AstryxTheme', () {
    testWidgets('of returns the enclosing data', (tester) async {
      late AstryxThemeData seen;
      final data = AstryxThemeData.resolve(mode: AstryxThemeMode.dark);

      await tester.pumpWidget(
        AstryxTheme(
          data: data,
          child: Builder(
            builder: (context) {
              seen = AstryxTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(seen, data);
    });

    testWidgets('of throws a helpful error with no theme', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => AstryxTheme.of(context),
              throwsA(
                isA<FlutterError>().having(
                  (e) => e.message,
                  'message',
                  contains('AstryxThemeProvider'),
                ),
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('maybeOf returns null with no theme', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(AstryxTheme.maybeOf(context), isNull);
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('a nested scope re-themes its subtree', (tester) async {
      late Color outer;
      late Color inner;
      final light = AstryxThemeData.resolve(mode: AstryxThemeMode.light);
      final dark = AstryxThemeData.resolve(mode: AstryxThemeMode.dark);

      await tester.pumpWidget(
        AstryxTheme(
          data: light,
          child: Builder(
            builder: (context) {
              outer = AstryxTheme.of(context).color(AstryxColorToken.accent);
              return AstryxTheme(
                data: dark,
                child: Builder(
                  builder: (context) {
                    inner = AstryxTheme.of(
                      context,
                    ).color(AstryxColorToken.accent);
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ),
      );
      expect(outer, isNot(inner));
    });

    test('updateShouldNotify tracks data, density and icons', () {
      final light = AstryxThemeData.resolve(mode: AstryxThemeMode.light);
      final dark = AstryxThemeData.resolve(mode: AstryxThemeMode.dark);
      const child = SizedBox.shrink();

      final base = AstryxTheme(data: light, child: child);
      expect(
        AstryxTheme(data: light, child: child).updateShouldNotify(base),
        isFalse,
      );
      expect(
        AstryxTheme(data: dark, child: child).updateShouldNotify(base),
        isTrue,
      );
      expect(
        AstryxTheme(
          data: light,
          density: AstryxDensity.touch,
          child: child,
        ).updateShouldNotify(base),
        isTrue,
      );
    });
  });

  group('AstryxThemeProvider', () {
    testWidgets('installs theme, density, icons and localisations', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxThemeProvider(
          theme: neutralTheme,
          mode: AstryxColorMode.light,
          platform: TargetPlatform.macOS,
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(AstryxTheme.of(ctx).mode, AstryxThemeMode.light);
      expect(AstryxTheme.densityOf(ctx), AstryxDensity.pointer);
      expect(AstryxTheme.iconsOf(ctx), AstryxIconRegistry.defaults);
      expect(AstryxLocalizations.of(ctx).dialogClose, 'Close');
    });

    testWidgets('system mode follows the platform brightness', (tester) async {
      Future<AstryxThemeMode> modeFor(Brightness brightness) async {
        late AstryxThemeMode mode;
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: AstryxThemeProvider(
              child: Builder(
                builder: (context) {
                  mode = AstryxTheme.of(context).mode;
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
        return mode;
      }

      expect(await modeFor(Brightness.light), AstryxThemeMode.light);
      expect(await modeFor(Brightness.dark), AstryxThemeMode.dark);
    });

    testWidgets('density can be overridden', (tester) async {
      late AstryxDensity density;
      await tester.pumpWidget(
        AstryxThemeProvider(
          density: AstryxDensity.touch,
          platform: TargetPlatform.macOS,
          child: Builder(
            builder: (context) {
              density = AstryxTheme.densityOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(density, AstryxDensity.touch);
    });

    testWidgets('works inside an existing app, for incremental adoption', (
      tester,
    ) async {
      late Color accent;
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF000000),
          builder: (context, _) => AstryxThemeProvider(
            theme: matchaTheme,
            mode: AstryxColorMode.light,
            child: Builder(
              builder: (context) {
                accent = AstryxTheme.of(context).color(AstryxColorToken.accent);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(accent, isNotNull);
    });
  });

  group('AstryxApp', () {
    testWidgets('provides a theme and a default text style', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxApp(
          theme: neutralTheme,
          mode: AstryxColorMode.light,
          platform: TargetPlatform.macOS,
          home: Builder(
            builder: (context) {
              ctx = context;
              return const Text('hello');
            },
          ),
        ),
      );

      final data = AstryxTheme.of(ctx);
      expect(data.mode, AstryxThemeMode.light);
      expect(
        DefaultTextStyle.of(ctx).style.color,
        data.color(AstryxColorToken.textPrimary),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('runs with no theme at all', (tester) async {
      await tester.pumpWidget(const AstryxApp(home: Text('bare')));
      expect(find.text('bare'), findsOneWidget);
    });
  });

  group('AstryxIconRegistry', () {
    test('the default registry covers every semantic name', () {
      expect(AstryxIconRegistry.defaults.isComplete, isTrue);
      expect(
        AstryxIconRegistry.defaults.icons,
        hasLength(AstryxIconName.values.length),
      );
    });

    test('copyWith replaces one entry and keeps the rest', () {
      const replacement = IconData(0x1234, fontFamily: 'test');
      final registry = AstryxIconRegistry.defaults.copyWith(
        const <AstryxIconName, IconData>{AstryxIconName.close: replacement},
      );
      expect(registry.icon(AstryxIconName.close), replacement);
      expect(
        registry.icon(AstryxIconName.check),
        AstryxIconRegistry.defaults.icon(AstryxIconName.check),
      );
    });

    test('a missing icon throws, naming the gap', () {
      const sparse = AstryxIconRegistry(icons: <AstryxIconName, IconData>{});
      expect(sparse.isComplete, isFalse);
      expect(sparse.maybeIcon(AstryxIconName.close), isNull);
      expect(
        () => sparse.icon(AstryxIconName.close),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('close'),
          ),
        ),
      );
    });

    test('merge is a no-op for a null other', () {
      expect(
        AstryxIconRegistry.defaults.merge(null),
        AstryxIconRegistry.defaults,
      );
    });
  });

  group('AstryxLocalizations', () {
    testWidgets('falls back to English with no scope', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final l10n = AstryxLocalizations.of(context);
            expect(l10n.dialogClose, 'Close');
            expect(l10n.fieldRequired, 'Required');
            return const SizedBox.shrink();
          },
        ),
      );
    });

    test('keeps the distinctions upstream draws', () {
      const l10n = AstryxLocalizations();
      // A persistent banner and a transient toast translate differently.
      expect(l10n.bannerDismiss, 'Dismiss');
      expect(l10n.toastDismiss, 'Dismiss notification');
    });

    test('pluralises the character counters', () {
      const l10n = AstryxLocalizations();
      expect(l10n.charactersRemaining(1), '1 character remaining');
      expect(l10n.charactersRemaining(12), '12 characters remaining');
      expect(l10n.charactersOverLimit(1), '1 character over the limit');
    });

    test('interpolates the parameterised strings', () {
      const l10n = AstryxLocalizations();
      expect(l10n.clearField('Email'), 'Clear Email');
      expect(l10n.tableSortBy('Name'), 'Sort by Name');
      expect(l10n.tableSelectRowNamed('Alice'), 'Select Alice');
    });

    testWidgets('a scope overrides the defaults', (tester) async {
      await tester.pumpWidget(
        AstryxLocalizationsScope(
          localizations: const _FrLocalizations(),
          child: Builder(
            builder: (context) {
              expect(AstryxLocalizations.of(context).dialogClose, 'Fermer');
              // Unoverridden strings still resolve.
              expect(AstryxLocalizations.of(context).fieldRequired, 'Required');
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });

  group('component theme helpers', () {
    test('lerpDiscrete snaps at the midpoint', () {
      expect(lerpDiscrete<int>(1, 2, 0.49), 1);
      expect(lerpDiscrete<int>(1, 2, 0.5), 2);
    });

    test('a null side is treated as absent, not as zero', () {
      // Growing an unset padding from 0 would animate the wrong shape.
      expect(lerpNullableDouble(null, 8, 0.25), isNull);
      expect(lerpNullableDouble(null, 8, 0.75), 8);
      expect(lerpNullableDouble(4, 8, 0.5), 6);
    });

    test('lerpColor treats a null side as absent, not transparent', () {
      expect(lerpColor(null, const Color(0xFF000000), 0.25), isNull);
      expect(
        lerpColor(const Color(0xFF000000), const Color(0xFFFFFFFF), 0),
        const Color(0xFF000000),
      );
    });

    test('lerpDuration interpolates', () {
      expect(
        lerpDuration(
          const Duration(milliseconds: 100),
          const Duration(milliseconds: 200),
          0.5,
        ),
        const Duration(milliseconds: 150),
      );
    });

    test('mergeMaps returns null only when both sides are null', () {
      expect(mergeMaps<String, int>(null, null), isNull);
      expect(mergeMaps<String, int>(<String, int>{'a': 1}, null), <String, int>{
        'a': 1,
      });
      expect(
        mergeMaps<String, int>(<String, int>{'a': 1}, <String, int>{'a': 2}),
        <String, int>{'a': 2},
      );
    });

    test('deepEquals compares collections by value', () {
      expect(deepEquals(<int>[1, 2], <int>[1, 2]), isTrue);
      expect(deepHash(<int>[1, 2]), deepHash(<int>[1, 2]));
    });
  });

  group('the seven prebuilt themes', () {
    test('all seven are defined and registered', () {
      expect(themes, hasLength(7));
      for (final entry in themes.entries) {
        expect(entry.value.name, entry.key);
        expect(getRegisteredTheme(entry.key), isNotNull, reason: entry.key);
      }
    });

    test('each converts to usable Flutter values in both modes', () {
      for (final entry in themes.entries) {
        for (final mode in AstryxThemeMode.values) {
          final data = AstryxThemeData.resolve(
            theme: entry.value,
            mode: mode,
            platform: TargetPlatform.macOS,
          );
          final where = '${entry.key} / ${mode.name}';

          for (final token in AstryxColorToken.values) {
            expect(() => data.color(token), returnsNormally, reason: where);
          }
          for (final token in AstryxRadiusToken.values) {
            expect(() => data.radius(token), returnsNormally, reason: where);
          }
          for (final token in AstryxDurationToken.values) {
            expect(() => data.duration(token), returnsNormally, reason: where);
          }
          for (final role in AstryxTypeRole.values) {
            expect(data.textStyle(role).fontSize, isNotNull, reason: where);
          }
          expect(data.ease, returnsNormally, reason: where);
        }
      }
    });

    test('the themes are visibly distinct from one another', () {
      final accents = themes.values
          .map(
            (t) => AstryxThemeData.resolve(
              theme: t,
              mode: AstryxThemeMode.light,
              platform: TargetPlatform.macOS,
            ).color(AstryxColorToken.accent),
          )
          .toSet();
      // Not all seven need differ, but a generator bug that collapsed them all
      // onto the defaults would show up here.
      expect(accents.length, greaterThan(3));
    });

    test('y2k has square corners throughout', () {
      final data = AstryxThemeData.resolve(
        theme: y2kTheme,
        mode: AstryxThemeMode.light,
        platform: TargetPlatform.macOS,
      );
      // Its radius scale zeroes the scalable steps, and it then overrides
      // `--radius-full` explicitly — the fixed pill anchor the scale cannot
      // reach. Square really does mean square.
      expect(data.radius(AstryxRadiusToken.element), 0);
      expect(data.radius(AstryxRadiusToken.full), 0);
    });

    test('a theme font family reaches the text styles', () {
      final data = AstryxThemeData.resolve(
        theme: neutralTheme,
        mode: AstryxThemeMode.light,
        platform: TargetPlatform.macOS,
      );
      expect(data.textStyle(AstryxTypeRole.body).fontFamily, 'Figtree');
    });
  });

  group('P3-11 — upstream parity, the Phase 3 exit criterion', () {
    test('every theme resolves to upstream values in both modes', () {
      final fixture = asObjects(loadEngineFixture('themes')['themes']);
      expect(fixture, hasLength(7));

      for (final record in fixture) {
        final name = record['name']! as String;
        final theme = themes[name];
        expect(theme, isNotNull, reason: name);

        // The hand-off the generated theme has to survive: the Dart theme was
        // emitted from the recorded input, so this proves the emission, the
        // engine and the conversion all agree with upstream at once.
        expectCoreTokensMatch(
          resolveThemeTokens(theme, AstryxThemeMode.light),
          record['resolvedLight']! as Map<String, dynamic>,
          reason: '$name / light',
        );
        expectCoreTokensMatch(
          resolveThemeTokens(theme, AstryxThemeMode.dark),
          record['resolvedDark']! as Map<String, dynamic>,
          reason: '$name / dark',
        );

        // …and that the generated input is the recorded input, not merely one
        // that happens to resolve the same way.
        final expected = defineTheme(
          decodeThemeInput(record['input']! as Map<String, dynamic>),
        );
        expect(theme!.tokens, expected.tokens, reason: '$name tokens');
        expect(
          theme.components,
          expected.components,
          reason: '$name components',
        );
      }
    });
  });
}

class _FrLocalizations extends AstryxLocalizations {
  const _FrLocalizations();

  @override
  String get dialogClose => 'Fermer';
}
