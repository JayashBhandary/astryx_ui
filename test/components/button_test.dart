import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 6 — actions.
///
/// `AstryxButton` is the reference implementation for every interactive widget
/// that follows, so what is pinned here is as much about the *pattern* as the
/// widget: how state, focus, keyboard activation and tap targets compose.
void main() {
  /// The decoration the button paints.
  BoxDecoration decorationOf(WidgetTester tester) =>
      tester
              .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
              .first
              .decoration!
          as BoxDecoration;

  group('P6-2 — AstryxButton', () {
    testWidgets('renders its label and calls back when pressed', (
      tester,
    ) async {
      var presses = 0;
      await pumpAstryxWidget(
        tester,
        AstryxButton(label: 'Save', onPressed: () => presses++),
      );

      expect(find.text('Save'), findsOneWidget);
      await tester.tap(find.byType(AstryxButton));
      await tester.pump();
      expect(presses, 1);
    });

    testWidgets('every variant renders with its own background', (
      tester,
    ) async {
      final backgrounds = <AstryxButtonVariant, Color>{};
      for (final variant in AstryxButtonVariant.values) {
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'x', variant: variant, onPressed: () {}),
        );
        backgrounds[variant] = decorationOf(tester).color!;
      }

      // Ghost is transparent so it does not paint over its surface.
      expect(backgrounds[AstryxButtonVariant.ghost]!.a, 0);
      // The other three are distinct.
      final filled = <Color>{
        backgrounds[AstryxButtonVariant.primary]!,
        backgrounds[AstryxButtonVariant.secondary]!,
        backgrounds[AstryxButtonVariant.destructive]!,
      };
      expect(filled, hasLength(3));
    });

    testWidgets('sizes come from the element size tokens', (tester) async {
      const expected = <AstryxButtonSize, double>{
        AstryxButtonSize.sm: 28,
        AstryxButtonSize.md: 32,
        AstryxButtonSize.lg: 36,
      };
      for (final entry in expected.entries) {
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'x', size: entry.key, onPressed: () {}),
        );
        expect(
          tester.getSize(find.byType(AnimatedContainer).first).height,
          entry.value,
          reason: entry.key.name,
        );
      }
    });

    testWidgets('disabled blocks the callback', (tester) async {
      var presses = 0;
      await pumpAstryxWidget(
        tester,
        AstryxButton(
          label: 'x',
          enabled: false,
          onPressed: () => presses++,
        ),
      );
      await tester.tap(find.byType(AstryxButton), warnIfMissed: false);
      await tester.pump();
      expect(presses, 0);
    });

    testWidgets('a null callback makes the button inert', (tester) async {
      await pumpAstryxWidget(tester, const AstryxButton(label: 'x'));
      final handle = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.byType(AstryxButton))
            .flagsCollection
            .isEnabled,
        Tristate.isFalse,
      );
      handle.dispose();
    });

    group('loading', () {
      testWidgets('blocks the callback and shows a spinner', (tester) async {
        var presses = 0;
        await pumpAstryxWidget(
          tester,
          AstryxButton(
            label: 'Save',
            loading: true,
            onPressed: () => presses++,
          ),
        );

        await tester.tap(find.byType(AstryxButton), warnIfMissed: false);
        await tester.pump();
        expect(presses, 0);
        expect(find.byType(AstryxSpinner), findsOneWidget);
      });

      testWidgets('does not shift the layout', (tester) async {
        // The exit criterion. The spinner takes the leading slot at exactly
        // the icon size, so the button's width is identical either way.
        Future<Size> sizeWhen({required bool loading}) async {
          await pumpAstryxWidget(
            tester,
            AstryxButton(
              label: 'Save changes',
              loading: loading,
              leading: const AstryxIcon(AstryxIconName.check),
              onPressed: () {},
            ),
          );
          return tester.getSize(find.byType(AnimatedContainer).first);
        }

        expect(await sizeWhen(loading: false), await sizeWhen(loading: true));
      });

      testWidgets('reports as disabled and announces the state', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'Save', loading: true, onPressed: () {}),
        );

        final node = tester.getSemantics(find.byType(AstryxButton));
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
        // A silent spinner tells a screen-reader user nothing.
        expect(node.label, contains('Loading'));
        handle.dispose();
      });
    });

    group('keyboard', () {
      Future<int> pressesAfter(
        WidgetTester tester,
        LogicalKeyboardKey key,
      ) async {
        var presses = 0;
        await pumpAstryxWidget(
          tester,
          AstryxButton(
            label: 'x',
            autofocus: true,
            onPressed: () => presses++,
          ),
        );
        await tester.pump();
        await tester.sendKeyEvent(key);
        await tester.pump();
        return presses;
      }

      testWidgets('enter activates', (tester) async {
        expect(await pressesAfter(tester, LogicalKeyboardKey.enter), 1);
      });

      testWidgets('space activates', (tester) async {
        expect(await pressesAfter(tester, LogicalKeyboardKey.space), 1);
      });
    });

    group('focus ring', () {
      testWidgets('appears on keyboard focus, not on a mouse press', (
        tester,
      ) async {
        // Closes the Phase 4 criterion that had no focusable widget to prove
        // it against.
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'x', autofocus: true, onPressed: () {}),
        );
        await tester.pump();
        expect(find.byKey(AstryxFocusRing.ringKey), findsOneWidget);

        await tester.tap(find.byType(AstryxButton));
        await tester.pump();
        expect(
          find.byKey(AstryxFocusRing.ringKey),
          findsNothing,
          reason: 'a mouse press must not leave a keyboard focus ring',
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(find.byKey(AstryxFocusRing.ringKey), findsOneWidget);
      });
    });

    group('semantics', () {
      testWidgets('is a button with the label as its name', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'Save changes', onPressed: () {}),
        );

        expect(
          tester.getSemantics(find.byType(AstryxButton)),
          matchesSemantics(
            label: 'Save changes',
            isButton: true,
            isEnabled: true,
            isFocusable: true,
            hasEnabledState: true,
            hasTapAction: true,
          ),
        );
        handle.dispose();
      });

      testWidgets('the label is announced once, not twice', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(
          tester,
          AstryxButton(label: 'Save', onPressed: () {}),
        );
        // The child Text would otherwise contribute a second node.
        expect(tester.getSemantics(find.byType(AstryxButton)).label, 'Save');
        handle.dispose();
      });
    });

    testWidgets('meets the tap-target guidelines in touch density', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      // The smallest button is 28px tall — below every guideline until the
      // density model floors it.
      await pumpAstryxWidget(
        tester,
        AstryxButton(
          label: 'x',
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        density: AstryxDensity.touch,
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('inherits its size from an enclosing scope', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxSizeScope(
          size: AstryxElementSize.lg,
          child: AstryxButton(label: 'x', onPressed: () {}),
        ),
      );
      expect(tester.getSize(find.byType(AnimatedContainer).first).height, 36);
    });

    testWidgets('an explicit size beats the inherited one', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxSizeScope(
          size: AstryxElementSize.lg,
          child: AstryxButton(
            label: 'x',
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ),
      );
      expect(tester.getSize(find.byType(AnimatedContainer).first).height, 28);
    });

    testWidgets('href goes through the link delegate', (tester) async {
      Uri? followed;
      await pumpAstryxWidget(
        tester,
        AstryxLinkScope(
          delegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
            followed = uri;
          }),
          child: AstryxButton(
            label: 'Docs',
            href: Uri.parse('https://example.com/docs'),
          ),
        ),
      );

      await tester.tap(find.byType(AstryxButton));
      await tester.pump();
      expect(followed, Uri.parse('https://example.com/docs'));
    });

    testWidgets('a per-instance theme merges over the app theme', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxButton(
          label: 'x',
          theme: const AstryxButtonTheme(
            backgroundColor: Color(0xFF123456),
          ),
          onPressed: () {},
        ),
      );
      expect(decorationOf(tester).color, const Color(0xFF123456));
    });
  });

  group('P6-3 — AstryxIconButton', () {
    testWidgets('is square and renders the registry glyph', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: 'Close',
          onPressed: () {},
        ),
      );

      final size = tester.getSize(find.byType(AnimatedContainer).first);
      expect(size.width, size.height);
      expect(
        tester.widget<Icon>(find.byType(Icon)).icon,
        AstryxIconRegistry.defaults.icon(AstryxIconName.close),
      );
    });

    testWidgets('the label becomes the accessible name', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: 'Close',
          onPressed: () {},
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxIconButton));
      expect(node.label, 'Close');
      expect(node.flagsCollection.isButton, isTrue);
      handle.dispose();
    });

    testWidgets('meets the labelled-tap-target guideline', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: 'Close',
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        density: AstryxDensity.touch,
      );

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('the custom constructor takes any widget', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxIconButton.custom(
          label: 'Avatar',
          onPressed: () {},
          child: const SizedBox(width: 12, height: 12),
        ),
      );
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(AstryxIconButton), findsOneWidget);
    });
  });

  group('P6-4 — AstryxButtonGroup', () {
    List<BorderRadius> radiiOf(WidgetTester tester, TextDirection direction) =>
        tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .map(
              (c) => ((c.decoration! as BoxDecoration).borderRadius!).resolve(
                direction,
              ),
            )
            .toList();

    testWidgets('squares the inner corners and keeps the outer ones', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          children: <Widget>[
            AstryxButton(label: 'A', onPressed: () {}),
            AstryxButton(label: 'B', onPressed: () {}),
            AstryxButton(label: 'C', onPressed: () {}),
          ],
        ),
      );

      final radii = radiiOf(tester, TextDirection.ltr);
      expect(radii, hasLength(3));
      // First: rounded on the left, square on the right.
      expect(radii[0].topLeft, isNot(Radius.zero));
      expect(radii[0].topRight, Radius.zero);
      // Middle: square both ends.
      expect(radii[1].topLeft, Radius.zero);
      expect(radii[1].topRight, Radius.zero);
      // Last: the mirror of the first.
      expect(radii[2].topLeft, Radius.zero);
      expect(radii[2].topRight, isNot(Radius.zero));
    });

    testWidgets('flips under RTL', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          children: <Widget>[
            AstryxButton(label: 'A', onPressed: () {}),
            AstryxButton(label: 'B', onPressed: () {}),
          ],
        ),
        textDirection: TextDirection.rtl,
      );

      final radii = radiiOf(tester, TextDirection.rtl);
      // The reading-start corner is now the right one.
      expect(radii[0].topRight, isNot(Radius.zero));
      expect(radii[0].topLeft, Radius.zero);
    });

    testWidgets('a single child keeps every corner', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          children: <Widget>[AstryxButton(label: 'Only', onPressed: () {})],
        ),
      );
      final radius = radiiOf(tester, TextDirection.ltr).single;
      expect(radius.topLeft, isNot(Radius.zero));
      expect(radius.topRight, isNot(Radius.zero));
    });

    testWidgets('cascades variant and size to its children', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.lg,
          children: <Widget>[AstryxButton(label: 'A', onPressed: () {})],
        ),
      );

      expect(tester.getSize(find.byType(AnimatedContainer).first).height, 36);
      final primaryBackground = decorationOf(tester).color;

      await pumpAstryxWidget(
        tester,
        AstryxButton(
          label: 'A',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
      );
      expect(decorationOf(tester).color, primaryBackground);
    });

    testWidgets("a child's own variant wins", (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          variant: AstryxButtonVariant.primary,
          children: <Widget>[
            AstryxButton(
              label: 'A',
              variant: AstryxButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
        ),
      );
      expect(decorationOf(tester).color!.a, 0);
    });

    testWidgets('detached keeps each button its own shape', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButtonGroup(
          attached: false,
          children: <Widget>[
            AstryxButton(label: 'A', onPressed: () {}),
            AstryxButton(label: 'B', onPressed: () {}),
          ],
        ),
      );
      for (final radius in radiiOf(tester, TextDirection.ltr)) {
        expect(radius.topLeft, isNot(Radius.zero));
        expect(radius.topRight, isNot(Radius.zero));
      }
    });

    testWidgets('an empty group renders nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxButtonGroup(children: <Widget>[]),
      );
      expect(find.byType(AnimatedContainer), findsNothing);
    });
  });

  group('P6-6 — contrast', () {
    final shippedThemes = <String, AstryxDefinedTheme>{
      'neutral': neutralTheme,
      'matcha': matchaTheme,
      'stone': stoneTheme,
      'gothic': gothicTheme,
      'chocolate': chocolateTheme,
      'y2k': y2kTheme,
      'butter': butterTheme,
    };

    /// Theme + mode combinations whose `destructive` variant is below 4.5:1
    /// **in upstream's own token values**.
    ///
    /// Reproduced faithfully rather than quietly corrected — see ADR-023 and
    /// the test below, which pins the measured ratios so a change either way
    /// is visible.
    const knownUpstreamShortfalls = <String>{
      'stone/light',
      'stone/dark',
      'matcha/light',
      'matcha/dark',
      'chocolate/light',
      'chocolate/dark',
    };

    testWidgets('every variant passes in every shipped theme, both modes', (
      tester,
    ) async {
      for (final theme in shippedThemes.entries) {
        for (final brightness in Brightness.values) {
          for (final variant in AstryxButtonVariant.values) {
            final key = '${theme.key}/${brightness.name}';
            if (variant == AstryxButtonVariant.destructive &&
                knownUpstreamShortfalls.contains(key)) {
              continue;
            }

            final handle = tester.ensureSemantics();
            await pumpAstryxWidget(
              tester,
              AstryxButton(label: 'Label', variant: variant, onPressed: () {}),
              brightness: brightness,
              theme: theme.value,
            );
            // The background genuinely animates across a theme change, which
            // is wanted in an app and a trap in a loop like this one: without
            // settling, the frame still shows the previous theme's colour.
            await tester.pumpAndSettle();
            await expectLater(
              tester,
              meetsGuideline(textContrastGuideline),
              reason: '$key / ${variant.name}',
            );
            handle.dispose();
          }
        }
      }
    });

    test('the accent pair clears 4.5:1 in every shipped theme', () {
      // `expandColorScale` guarantees this for generated scales, and every
      // shipped theme holds to it. The `primary` button is safe everywhere.
      for (final theme in shippedThemes.entries) {
        for (final mode in AstryxThemeMode.values) {
          final tokens = resolveThemeTokens(theme.value, mode);
          expect(
            contrastRatio(
              tokens['--color-on-accent']!,
              tokens['--color-accent']!,
            ),
            greaterThanOrEqualTo(4.5),
            reason: '${theme.key} / ${mode.name}',
          );
        }
      }
    });

    test('the error pair falls short upstream, and by how much', () {
      // **Upstream gaps, reproduced faithfully — not port bugs.**
      //
      // `expandColorScale` guarantees 4.5:1 only for `--color-on-accent`
      // against `--color-accent`. The status colours are convention-bound and
      // hand-written per theme, so nothing holds them to that bar — and three
      // themes plus the bare defaults miss it.
      //
      // `stone` light is the severe one: upstream sets `--color-on-error` to
      // `#58413e`, the *same value* as `--color-error`, so a destructive
      // button's label is invisible. It reads as a typo in `stoneTheme.ts`.
      //
      // Correcting a token here would be a silent deviation, so the ratios are
      // pinned instead: attributed, visible, and impossible to regress
      // unnoticed. A consumer fixes any of them with a one-token override.
      // See ADR-023.
      const expected = <String, ({double light, double dark})>{
        'stone': (light: 1.00, dark: 1.32),
        'matcha': (light: 4.06, dark: 3.23),
        'chocolate': (light: 4.06, dark: 3.81),
      };

      for (final entry in expected.entries) {
        final theme = shippedThemes[entry.key]!;
        for (final mode in AstryxThemeMode.values) {
          final tokens = resolveThemeTokens(theme, mode);
          expect(
            contrastRatio(
              tokens['--color-on-error']!,
              tokens['--color-error']!,
            ),
            closeTo(
              mode == AstryxThemeMode.light
                  ? entry.value.light
                  : entry.value.dark,
              0.01,
            ),
            reason: '${entry.key} / ${mode.name}',
          );
        }
      }

      // The bare defaults fall short in dark mode too.
      final dark = resolveThemeTokens(null, AstryxThemeMode.dark);
      expect(
        contrastRatio(dark['--color-on-accent']!, dark['--color-accent']!),
        closeTo(3.11, 0.01),
      );
      expect(
        contrastRatio(dark['--color-on-error']!, dark['--color-error']!),
        closeTo(3.76, 0.01),
      );
      // Light mode is fine.
      final light = resolveThemeTokens(null, AstryxThemeMode.light);
      expect(
        contrastRatio(light['--color-on-accent']!, light['--color-accent']!),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('AstryxButtonTheme', () {
    test('merge keeps the base where the override is silent', () {
      const base = AstryxButtonTheme(
        backgroundColor: Color(0xFF000000),
        gap: 4,
      );
      const over = AstryxButtonTheme(gap: 12);
      final merged = base.merge(over);
      expect(merged.backgroundColor, const Color(0xFF000000));
      expect(merged.gap, 12);
      expect(base.merge(null), base);
    });

    test('lerp interpolates and is null-safe', () {
      const a = AstryxButtonTheme(gap: 0);
      const b = AstryxButtonTheme(gap: 10);
      expect(AstryxButtonTheme.lerp(a, b, 0.5)!.gap, 5);
      expect(AstryxButtonTheme.lerp(null, null, 0.5), isNull);
    });

    test('is a value type, including its shadow list', () {
      const a = AstryxButtonTheme(
        shadows: <AstryxShadow>[AstryxShadow(color: Color(0xFF000000))],
      );
      const b = AstryxButtonTheme(
        shadows: <AstryxShadow>[AstryxShadow(color: Color(0xFF000000))],
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
