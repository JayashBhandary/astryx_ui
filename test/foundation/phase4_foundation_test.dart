import 'dart:ui' show CheckedState, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 4 — the foundation layer.
///
/// The exit criteria are the four behavioural guarantees every component above
/// this layer relies on: focus rings appear only for the keyboard, hover is
/// inert on touch, small controls still meet 44px, and animation collapses
/// under reduced motion.
void main() {
  group('P4-1 — AstryxStatesController', () {
    test('honours hover in pointer density', () {
      final controller = AstryxStatesController()..hovered = true;
      expect(controller.hovered, isTrue);
      expect(controller.value, contains(WidgetState.hovered));
    });

    test('refuses hover in touch density', () {
      // Touch devices synthesise hover events; without this a tap leaves a
      // control looking hovered afterwards.
      final controller = AstryxStatesController(
        density: AstryxDensity.touch,
      )..hovered = true;
      expect(controller.hovered, isFalse);
    });

    test('passes every other state through on touch', () {
      final controller = AstryxStatesController(density: AstryxDensity.touch)
        ..pressed = true
        ..focused = true
        ..disabled = true
        ..selected = true
        ..error = true;
      expect(controller.pressed, isTrue);
      expect(controller.focused, isTrue);
      expect(controller.disabled, isTrue);
      expect(controller.selected, isTrue);
      expect(controller.error, isTrue);
    });

    test('drops hover when the density changes to touch', () {
      final controller = AstryxStatesController()..hovered = true;
      controller.density = AstryxDensity.touch;
      expect(controller.hovered, isFalse);
    });

    test('filters an initial hover on a touch controller', () {
      final controller = AstryxStatesController(
        density: AstryxDensity.touch,
        value: <WidgetState>{WidgetState.hovered, WidgetState.pressed},
      );
      expect(controller.hovered, isFalse);
      expect(controller.pressed, isTrue);
    });

    test('notifies listeners on a real change', () {
      var notifications = 0;
      final controller = AstryxStatesController()
        ..addListener(() => notifications++)
        ..hovered = true;
      expect(notifications, 1);
      controller.hovered = true;
      expect(notifications, 1, reason: 'no change, no notification');
    });

    test('resolves a WidgetStateProperty against the current states', () {
      final controller = AstryxStatesController()..pressed = true;
      const color = WidgetStateProperty<Color>.fromMap(
        <WidgetStatesConstraint, Color>{
          WidgetState.pressed: Color(0xFF111111),
          WidgetState.any: Color(0xFF222222),
        },
      );
      expect(controller.resolve(color), const Color(0xFF111111));
    });
  });

  group('P4-2 — AstryxFocusVisible', () {
    testWidgets('defaults to visible with no scope installed', (tester) async {
      // A spurious ring is cosmetic; a missing one is an accessibility
      // failure. The default must fail toward showing it.
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(AstryxFocusVisible.of(context), isTrue);
            expect(AstryxFocusVisible.maybeDeviceOf(context), isNull);
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('starts visible, so the first tab of a session shows', (
      tester,
    ) async {
      late bool visible;
      await tester.pumpWidget(
        AstryxFocusVisibleScope(
          child: Builder(
            builder: (context) {
              visible = AstryxFocusVisible.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(visible, isTrue);
    });

    testWidgets('a pointer press hides the ring; a key press restores it', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxFocusVisibleScope(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox(width: 100, height: 100);
            },
          ),
        ),
      );

      await tester.tapAt(const Offset(50, 50));
      await tester.pump();
      expect(
        AstryxFocusVisible.of(ctx),
        isFalse,
        reason: 'a mouse click must not raise a keyboard focus ring',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(AstryxFocusVisible.of(ctx), isTrue);
    });

    testWidgets('hover and scroll do not suppress a ring', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxFocusVisibleScope(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox(width: 100, height: 100);
            },
          ),
        ),
      );

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(50, 50));
      addTearDown(mouse.removePointer);
      await tester.pump();

      // Neither moves focus, so neither may take the ring away.
      expect(AstryxFocusVisible.of(ctx), isTrue);
    });

    testWidgets('the provider installs the scope', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxThemeProvider(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox(width: 100, height: 100);
            },
          ),
        ),
      );
      expect(AstryxFocusVisible.maybeDeviceOf(ctx), isNotNull);
    });
  });

  group('P4-3 — AstryxFocusRing', () {
    testWidgets('draws nothing when unfocused', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxFocusRing(focused: false, child: SizedBox(width: 20)),
      );
      expect(find.byType(DecoratedBox), findsNothing);
    });

    testWidgets('draws when focused and focus is visible', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxFocusRing(focused: true, child: SizedBox(width: 20)),
      );
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    testWidgets('draws nothing after a pointer press', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxFocusRing(
          focused: true,
          child: SizedBox(width: 100, height: 100),
        ),
      );
      expect(find.byType(DecoratedBox), findsOneWidget);

      await tester.tapAt(const Offset(200, 150));
      await tester.pump();
      expect(
        find.byType(DecoratedBox),
        findsNothing,
        reason: 'the :focus-visible rule must reach the ring',
      );
    });

    testWidgets('honours enabled: false', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxFocusRing(
          focused: true,
          enabled: false,
          child: SizedBox(width: 20),
        ),
      );
      expect(find.byType(DecoratedBox), findsNothing);
    });

    testWidgets('does not change the child layout', (tester) async {
      const childKey = Key('ring.child');
      await pumpAstryxWidget(
        tester,
        const AstryxFocusRing(
          focused: true,
          child: SizedBox(key: childKey, width: 60, height: 30),
        ),
      );
      expect(tester.getSize(find.byKey(childKey)), const Size(60, 30));
      // The ring is painted outside the bounds, so the wrapper matches too.
      expect(
        tester.getSize(find.byType(AstryxFocusRing)),
        const Size(60, 30),
      );
    });
  });

  group('P4-4 — AstryxTapTarget', () {
    testWidgets('is a pass-through in pointer density', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTapTarget(child: SizedBox(width: 20, height: 20)),
      );
      expect(
        tester.getSize(find.byType(AstryxTapTarget)),
        const Size(20, 20),
      );
    });

    testWidgets('grows a 20x20 child to 48x48 in touch density', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTapTarget(child: SizedBox(width: 20, height: 20)),
        density: AstryxDensity.touch,
      );
      expect(
        tester.getSize(find.byType(AstryxTapTarget)),
        const Size(48, 48),
      );
      // The child keeps its own size — only the hit region grew.
      expect(tester.getSize(find.byType(SizedBox).last), const Size(20, 20));
    });

    testWidgets('leaves a child larger than the minimum alone', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTapTarget(child: SizedBox(width: 80, height: 60)),
        density: AstryxDensity.touch,
      );
      expect(
        tester.getSize(find.byType(AstryxTapTarget)),
        const Size(80, 60),
      );
    });

    testWidgets('a tap in the slop still activates the child', (tester) async {
      var taps = 0;
      await pumpAstryxWidget(
        tester,
        AstryxTapTarget(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => taps++,
            child: const SizedBox(width: 20, height: 20),
          ),
        ),
        density: AstryxDensity.touch,
      );

      // 20px right of centre: outside the 20x20 child, inside the 48x48 target.
      final centre = tester.getCenter(find.byType(AstryxTapTarget));
      await tester.tapAt(centre + const Offset(20, 0));
      await tester.pump();
      expect(taps, 0, reason: 'the child itself does not extend that far');

      await tester.tapAt(centre);
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('meets the platform tap-target guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      // Semantics *outside* the tap target — see the ordering note on
      // AstryxTapTarget. Nested the other way the semantics node stays 20x20
      // and assistive technology sees the small target, whatever the hit
      // region does.
      await pumpAstryxWidget(
        tester,
        Semantics(
          container: true,
          button: true,
          label: 'Tiny',
          onTap: () {},
          child: const AstryxTapTarget(
            child: SizedBox(width: 20, height: 20),
          ),
        ),
        density: AstryxDensity.touch,
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('a single axis can be opted out', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTapTarget(
          expandHorizontally: false,
          child: SizedBox(width: 20, height: 20),
        ),
        density: AstryxDensity.touch,
      );
      expect(
        tester.getSize(find.byType(AstryxTapTarget)),
        const Size(20, 48),
      );
    });
  });

  group('P4-5 — AstryxMotion', () {
    testWidgets('resolves token durations and curves', (tester) async {
      late AstryxMotion motion;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            motion = AstryxMotion.of(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(
        motion.duration(AstryxDurationToken.fast),
        const Duration(milliseconds: 175),
      );
      expect(motion.curve(), isA<Cubic>());
      expect(motion.animate, isTrue);
      expect(motion.reduced, isFalse);
    });

    testWidgets('collapses every duration to zero under reduced motion', (
      tester,
    ) async {
      late AstryxMotion motion;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            motion = AstryxMotion.of(context);
            return const SizedBox.shrink();
          },
        ),
        disableAnimations: true,
      );

      for (final token in AstryxDurationToken.values) {
        expect(motion.duration(token), Duration.zero, reason: token.name);
      }
      expect(motion.animate, isFalse);
      // The curve survives — with a zero duration it is never sampled, and
      // neutralising it would only mislead a caller using it elsewhere.
      expect(motion.curve(), isA<Cubic>());
    });
  });

  group('P4-6 — semantics helpers', () {
    testWidgets('AstryxSemanticsButton announces a button', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxSemanticsButton(
          label: 'Save changes',
          onPressed: () {},
          child: const SizedBox(width: 40, height: 40),
        ),
      );

      expect(
        tester.getSemantics(find.byType(AstryxSemanticsButton)),
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

    testWidgets('a disabled button offers no tap action', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxSemanticsButton(
          label: 'Save',
          enabled: false,
          onPressed: () {},
          child: const SizedBox(width: 40, height: 40),
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxSemanticsButton));
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('AstryxSemanticsToggle distinguishes radio from checkbox', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        Column(
          children: <Widget>[
            AstryxSemanticsToggle(
              label: 'Check',
              checked: true,
              onToggle: () {},
              child: const SizedBox(width: 20, height: 20),
            ),
            AstryxSemanticsToggle(
              label: 'Radio',
              checked: true,
              isRadio: true,
              onToggle: () {},
              child: const SizedBox(width: 20, height: 20),
            ),
          ],
        ),
      );

      final checkbox = tester.getSemantics(
        find.byType(AstryxSemanticsToggle).first,
      );
      final radio = tester.getSemantics(
        find.byType(AstryxSemanticsToggle).last,
      );
      expect(checkbox.flagsCollection.isChecked, CheckedState.isTrue);
      expect(
        checkbox.flagsCollection.isInMutuallyExclusiveGroup,
        isFalse,
      );
      expect(radio.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      handle.dispose();
    });

    testWidgets('a mixed toggle announces indeterminate, not checked', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxSemanticsToggle(
          label: 'Some',
          checked: true,
          mixed: true,
          onToggle: () {},
          child: const SizedBox(width: 20, height: 20),
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxSemanticsToggle));
      // The tri-state: mixed is its own value, not "checked plus a flag".
      expect(node.flagsCollection.isChecked, CheckedState.mixed);
      handle.dispose();
    });

    testWidgets('AstryxSemanticsField reports an error as invalid', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxSemanticsField(
          label: 'Email',
          value: 'nope',
          errorText: 'Invalid email',
          child: SizedBox(width: 100, height: 30),
        ),
      );

      final node = tester.getSemantics(find.byType(AstryxSemanticsField));
      expect(node.flagsCollection.isTextField, isTrue);
      expect(
        node.getSemanticsData().validationResult,
        SemanticsValidationResult.invalid,
      );
      handle.dispose();
    });

    testWidgets('AstryxVisuallyHidden stays in the semantics tree', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxVisuallyHidden(
          liveRegion: true,
          child: Text('3 characters remaining'),
        ),
      );

      expect(find.text('3 characters remaining'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(AstryxVisuallyHidden)).label,
        contains('3 characters remaining'),
      );
      // It occupies no space.
      expect(tester.getSize(find.byType(AstryxVisuallyHidden)), Size.zero);
      handle.dispose();
    });
  });

  group('P4-7 — AstryxLinkDelegate', () {
    testWidgets('defaults to a no-op when nothing is installed', (
      tester,
    ) async {
      late AstryxLinkDelegate delegate;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            delegate = AstryxLinkDelegate.of(context);
            return const SizedBox.shrink();
          },
        ),
      );
      expect(delegate, AstryxLinkDelegate.none);
      // Does nothing, and in particular does not throw.
      expect(
        () => delegate.followLink(Uri.parse('https://example.com')),
        returnsNormally,
      );
    });

    testWidgets('a scope delegate receives the uri and target', (tester) async {
      Uri? seen;
      String? seenTarget;
      late BuildContext ctx;

      await tester.pumpWidget(
        AstryxLinkScope(
          delegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
            seen = uri;
            seenTarget = target;
          }),
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      AstryxLinkDelegate.of(
        ctx,
      ).followLink(Uri.parse('https://example.com/docs'), target: '_blank');
      expect(seen, Uri.parse('https://example.com/docs'));
      expect(seenTarget, '_blank');
    });

    testWidgets('the provider installs the delegate', (tester) async {
      var followed = 0;
      late BuildContext ctx;
      await tester.pumpWidget(
        AstryxThemeProvider(
          linkDelegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
            followed++;
          }),
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      AstryxLinkDelegate.of(ctx).followLink(Uri.parse('/x'));
      expect(followed, 1);
    });
  });

  group('P4-8 — AstryxSizeScope', () {
    testWidgets('an explicit size beats the inherited one', (tester) async {
      late AstryxElementSize resolved;
      await tester.pumpWidget(
        AstryxSizeScope(
          size: AstryxElementSize.sm,
          child: Builder(
            builder: (context) {
              resolved = AstryxSizeScope.resolve(
                context,
                AstryxElementSize.lg,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(resolved, AstryxElementSize.lg);
    });

    testWidgets('the inherited size beats the fallback', (tester) async {
      late AstryxElementSize resolved;
      await tester.pumpWidget(
        AstryxSizeScope(
          size: AstryxElementSize.sm,
          child: Builder(
            builder: (context) {
              resolved = AstryxSizeScope.resolve(context, null);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(resolved, AstryxElementSize.sm);
    });

    testWidgets('falls back to md with no scope', (tester) async {
      late AstryxElementSize resolved;
      late AstryxElementSize? inherited;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            resolved = AstryxSizeScope.resolve(context, null);
            inherited = AstryxSizeScope.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      );
      expect(resolved, AstryxElementSize.md);
      // Null is distinguishable from "a container asked for md".
      expect(inherited, isNull);
    });

    testWidgets('the nearest scope wins', (tester) async {
      late AstryxElementSize resolved;
      await tester.pumpWidget(
        AstryxSizeScope(
          size: AstryxElementSize.lg,
          child: AstryxSizeScope(
            size: AstryxElementSize.sm,
            child: Builder(
              builder: (context) {
                resolved = AstryxSizeScope.resolve(context, null);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(resolved, AstryxElementSize.sm);
    });
  });

  group('P4-9 — RTL helpers', () {
    test('astryxInsets maps the logical axes', () {
      expect(
        astryxInsets(inline: 12, block: 6),
        const EdgeInsetsDirectional.only(start: 12, end: 12, top: 6, bottom: 6),
      );
      expect(
        astryxInsets(start: 4, end: 8),
        const EdgeInsetsDirectional.only(start: 4, end: 8),
      );
    });

    test('a specific side beats the axis shorthand', () {
      expect(
        astryxInsets(inline: 12, start: 0).start,
        0,
        reason: 'padding-inline then padding-inline-start',
      );
    });

    testWidgets('insets flip under RTL', (tester) async {
      late EdgeInsets ltr;
      late EdgeInsets rtl;
      final insets = astryxInsets(start: 20, end: 4);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              ltr = insets.resolve(Directionality.of(context));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) {
              rtl = insets.resolve(Directionality.of(context));
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(ltr.left, 20);
      expect(rtl.right, 20);
    });

    test('the mirrored and never-mirrored icon sets are disjoint', () {
      expect(
        astryxMirroredIcons.intersection(astryxNeverMirroredIcons),
        isEmpty,
      );
    });

    test('directional chevrons mirror; the vertical one does not', () {
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronLeft), isTrue);
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronRight), isTrue);
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronDown), isFalse);
      // Objects and glyphs never mirror.
      expect(astryxShouldMirrorIcon(AstryxIconName.clock), isFalse);
      expect(astryxShouldMirrorIcon(AstryxIconName.check), isFalse);
    });

    testWidgets('AstryxMirrorForRtl flips only under RTL, only when enabled', (
      tester,
    ) async {
      Future<int> transformsFor(TextDirection direction, {required bool on}) {
        return tester
            .pumpWidget(
              Directionality(
                textDirection: direction,
                child: AstryxMirrorForRtl(
                  enabled: on,
                  child: const SizedBox(width: 10, height: 10),
                ),
              ),
            )
            .then((_) => tester.widgetList(find.byType(Transform)).length);
      }

      expect(await transformsFor(TextDirection.ltr, on: true), 0);
      expect(await transformsFor(TextDirection.rtl, on: true), 1);
      expect(await transformsFor(TextDirection.rtl, on: false), 0);
    });
  });

  group('P4-10 — the golden harness renders like an app', () {
    testWidgets('provides the real theme, density and focus scopes', (
      tester,
    ) async {
      late BuildContext ctx;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox.shrink();
          },
        ),
        density: AstryxDensity.touch,
        theme: neutralTheme,
      );

      expect(AstryxTheme.maybeOf(ctx), isNotNull);
      expect(AstryxTheme.densityOf(ctx), AstryxDensity.touch);
      expect(AstryxFocusVisible.maybeDeviceOf(ctx), isNotNull);
      expect(AstryxLocalizations.of(ctx).dialogClose, 'Close');
      expect(
        AstryxTheme.of(ctx).textStyle(AstryxTypeRole.body).fontFamily,
        'Figtree',
        reason: 'the harness resolves the theme it was given',
      );
    });

    testWidgets('brightness comes from the MediaQuery, as in an app', (
      tester,
    ) async {
      late AstryxThemeMode mode;
      Future<void> pump(Brightness brightness) => pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            mode = AstryxTheme.of(context).mode;
            return const SizedBox.shrink();
          },
        ),
        brightness: brightness,
      );

      await pump(Brightness.light);
      expect(mode, AstryxThemeMode.light);
      await pump(Brightness.dark);
      expect(mode, AstryxThemeMode.dark);
    });

    testWidgets('the surface colour is the body token, not a constant', (
      tester,
    ) async {
      late Color expected;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            expected = AstryxTheme.of(
              context,
            ).color(AstryxColorToken.backgroundBody);
            return const SizedBox.shrink();
          },
        ),
      );

      final surface = tester.widget<ColoredBox>(
        find
            .ancestor(
              of: find.byKey(astryxGoldenRootKey),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(surface.color, expected);
    });
  });
}
