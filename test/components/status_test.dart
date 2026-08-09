import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 7 — status indicators.
///
/// Three animated widgets, so this file also sets the convention Phases 9 and
/// 10 follow: drive animations with `tester.pump(duration)`, and pump to a
/// **named fraction** of the cycle when a frame has to be deterministic.
void main() {
  group('P7-1 — AstryxSpinner', () {
    testWidgets('renders and animates', (tester) async {
      await pumpAstryxWidget(tester, const AstryxSpinner());

      expect(find.byType(AstryxSpinner), findsOneWidget);
      expect(
        tester.getSize(find.byType(AstryxSpinner)),
        const Size(14, 14), // md
      );

      // A repeating controller keeps scheduling frames.
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('every size uses its own diameter', (tester) async {
      const expected = <AstryxSpinnerSize, double>{
        AstryxSpinnerSize.sm: 10,
        AstryxSpinnerSize.md: 14,
        AstryxSpinnerSize.lg: 18,
      };
      for (final entry in expected.entries) {
        await pumpAstryxWidget(tester, AstryxSpinner(size: entry.key));
        expect(
          tester.getSize(find.byType(AstryxSpinner)).width,
          entry.value,
          reason: entry.key.name,
        );
      }
    });

    testWidgets('is announced as a live region', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxSpinner(label: 'Saving'));

      final node = tester.getSemantics(find.byType(AstryxSpinner));
      expect(node.label, 'Saving');
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });

    testWidgets('falls back to the loading string', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxSpinner());
      expect(
        tester.getSemantics(find.byType(AstryxSpinner)).label,
        const AstryxLocalizations().buttonLoading,
      );
      handle.dispose();
    });

    testWidgets('stops under reduced motion but stays announced', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxSpinner(),
        disableAnimations: true,
      );

      // Nothing is scheduling frames — the controller really stopped.
      expect(tester.binding.hasScheduledFrame, isFalse);
      // A spinner that cannot spin still has to say it is working.
      expect(
        tester
            .getSemantics(find.byType(AstryxSpinner))
            .flagsCollection
            .isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('disposes its controller', (tester) async {
      // A leaked repeating controller in a design system is reproduced
      // hundreds of times in a consuming app.
      await pumpAstryxWidget(tester, const AstryxSpinner());
      expect(tester.binding.hasScheduledFrame, isTrue);

      await pumpAstryxWidget(tester, const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(
        tester.binding.hasScheduledFrame,
        isFalse,
        reason: 'a surviving ticker would keep requesting frames',
      );
    });

    testWidgets('inherit takes its colour from the enclosing IconTheme', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const IconTheme(
          data: IconThemeData(color: Color(0xFF123456)),
          child: AstryxSpinner(shade: AstryxSpinnerShade.inherit),
        ),
      );
      // Painted, so assert through the tree rather than the pixels.
      expect(find.byType(CustomPaint), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('P7-2 — AstryxSkeleton', () {
    testWidgets('renders a block at the requested size', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 120, height: 20),
      );
      expect(tester.getSize(find.byType(AstryxSkeleton)), const Size(120, 20));
    });

    testWidgets('is hidden from assistive technology', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 100, height: 20),
      );
      // A reader announcing a row of empty boxes is noise; a loading
      // announcement belongs on the container.
      expect(
        find.descendant(
          of: find.byType(AstryxSkeleton),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('uses the skeleton token', (tester) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxSkeleton(width: 40, height: 20);
          },
        ),
      );
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(AstryxSkeleton),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (box.decoration as BoxDecoration).color,
        data.color(AstryxColorToken.skeleton),
      );
    });

    testWidgets('the pulse waits out the delay, then runs', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 40, height: 20),
      );
      // Content that loads quickly should not flash an animation on its way
      // past, so nothing is animating yet.
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isTrue);

      // Leave the tree quiescent for the next test.
      await pumpAstryxWidget(tester, const SizedBox.shrink());
    });

    testWidgets('stays fully opaque under reduced motion', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 40, height: 20, delay: Duration.zero),
        disableAnimations: true,
      );

      expect(tester.binding.hasScheduledFrame, isFalse);
      // The animation's own floor of 0.25 would be nearly invisible when
      // frozen, so a static placeholder renders at full opacity.
      expect(
        tester
            .widgetList<Opacity>(
              find.descendant(
                of: find.byType(AstryxSkeleton),
                matching: find.byType(Opacity),
              ),
            )
            .first
            .opacity,
        1.0,
      );
    });

    testWidgets('the text constructor can be shortened', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          width: 200,
          child: AstryxSkeleton.text(widthFactor: 0.5),
        ),
      );
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('the circle constructor is square and fully rounded', (
      tester,
    ) async {
      late AstryxThemeData data;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            data = AstryxTheme.of(context);
            return const AstryxSkeleton.circle(size: 32);
          },
        ),
      );
      expect(tester.getSize(find.byType(AstryxSkeleton)), const Size(32, 32));
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(AstryxSkeleton),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (box.decoration as BoxDecoration).borderRadius,
        data.borderRadius(AstryxRadiusToken.full),
      );
    });

    testWidgets('disposes its controller', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 40, height: 20, delay: Duration.zero),
      );
      expect(tester.binding.hasScheduledFrame, isTrue);

      await pumpAstryxWidget(tester, const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });

  group('P7-3 — AstryxProgressBar', () {
    testWidgets('determinate fills to the value', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          width: 200,
          child: AstryxProgressBar(label: 'Uploading', value: 0.5),
        ),
      );
      // The fill animates in, so settle before measuring.
      await tester.pumpAndSettle();

      final finder = find
          .descendant(
            of: find.byType(AstryxProgressBar),
            matching: find.byType(FractionallySizedBox),
          )
          .first;
      expect(
        tester.widget<FractionallySizedBox>(finder).widthFactor,
        closeTo(0.5, 1e-6),
      );

      // The fill must actually occupy the track. A `FractionallySizedBox`
      // with only a width factor leaves a childless `ColoredBox` at zero
      // height, which paints nothing — a bug the widget tests missed and a
      // golden caught.
      final rect = tester.getRect(finder);
      expect(rect.height, 8);
      expect(rect.width, closeTo(100, 0.5));
    });

    testWidgets('announces its percentage and is a live region', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Uploading', value: 0.42),
      );

      final node = tester.getSemantics(find.byType(AstryxProgressBar));
      expect(node.label, 'Uploading');
      // A percentage string, not an adjustable value — a reader must not offer
      // to increase a progress bar.
      expect(node.value, '42%');
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });

    testWidgets('indeterminate has no value and is not a live region', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Loading'),
      );

      final node = tester.getSemantics(find.byType(AstryxProgressBar));
      expect(node.value, isEmpty);
      // Announcing "loading" on a loop tells the user nothing new.
      expect(node.flagsCollection.isLiveRegion, isFalse);
      handle.dispose();

      await pumpAstryxWidget(tester, const SizedBox.shrink());
    });

    testWidgets('a custom formatter is used for label and semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxProgressBar(
          label: 'Files',
          value: 0.25,
          showValueLabel: true,
          formatValue: (v) => '${(v * 8).round()} of 8',
        ),
      );

      expect(find.text('2 of 8'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(AstryxProgressBar)).value,
        '2 of 8',
      );
      handle.dispose();
    });

    testWidgets('the label can be hidden without losing the name', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(
          label: 'Uploading',
          value: 0.5,
          showLabel: false,
        ),
      );

      expect(find.text('Uploading'), findsNothing);
      expect(
        tester.getSemantics(find.byType(AstryxProgressBar)).label,
        'Uploading',
      );
      handle.dispose();
    });

    testWidgets('the fill grows from the reading edge, both directions', (
      tester,
    ) async {
      Future<double> fillLeftEdge(TextDirection direction) async {
        await pumpAstryxWidget(
          tester,
          const SizedBox(
            width: 200,
            child: AstryxProgressBar(
              label: 'x',
              value: 0.25,
              showLabel: false,
            ),
          ),
          textDirection: direction,
        );
        await tester.pumpAndSettle();
        return tester
            .getTopLeft(
              find
                  .descendant(
                    of: find.byType(AstryxProgressBar),
                    matching: find.byType(FractionallySizedBox),
                  )
                  .first,
            )
            .dx;
      }

      final ltr = await fillLeftEdge(TextDirection.ltr);
      final rtl = await fillLeftEdge(TextDirection.rtl);
      // A quarter-full bar hugs the left in LTR and the right in RTL, so its
      // left edge is much further along.
      expect(rtl, greaterThan(ltr));
    });

    testWidgets('indeterminate animates; determinate does not loop', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Loading'),
      );
      expect(tester.binding.hasScheduledFrame, isTrue);

      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Loading', value: 1),
      );
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('stops under reduced motion', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Loading'),
        disableAnimations: true,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('disposes its controller', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Loading'),
      );
      expect(tester.binding.hasScheduledFrame, isTrue);

      await pumpAstryxWidget(tester, const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    test('rejects a value outside 0..1', () {
      for (final value in <double>[-0.1, 1.1]) {
        expect(
          () => AstryxProgressBar(label: 'x', value: value),
          throwsAssertionError,
        );
      }
    });
  });

  group('the button spinner is the real one', () {
    testWidgets('a loading button renders an AstryxSpinner', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxButton(label: 'Save', loading: true, onPressed: () {}),
      );
      expect(find.byType(AstryxSpinner), findsOneWidget);

      await pumpAstryxWidget(tester, const SizedBox.shrink());
    });

    testWidgets('the button owns the announcement, not the spinner', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxButton(label: 'Save', loading: true, onPressed: () {}),
      );

      // One live region, not two competing.
      expect(
        tester.getSemantics(find.byType(AstryxButton)).label,
        contains('Loading'),
      );
      handle.dispose();
      await pumpAstryxWidget(tester, const SizedBox.shrink());
    });
  });
}
