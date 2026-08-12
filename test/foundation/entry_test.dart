import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Entering, revealing, hinting, and streaming: the four widgets the last of
/// the hooks needed.
void main() {
  group('AstryxEntryAnimation', () {
    testWidgets('starts hidden and finishes visible', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxEntryAnimation(child: AstryxText('Arrived')),
        surfaceSize: const Size(300, 120),
      );

      // First frame: built, but not yet opaque.
      final first = tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(first.opacity.value, lessThan(1));

      await tester.pumpAndSettle();

      // Settled, the transition widgets are gone entirely rather than left
      // behind as an opacity layer.
      expect(find.byType(FadeTransition), findsNothing);
      expect(find.text('Arrived'), findsOneWidget);
    });

    testWidgets('under reduced motion it is simply there', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxEntryAnimation(
          transition: AstryxEntryTransition.fadeUp,
          child: AstryxText('Arrived'),
        ),
        surfaceSize: const Size(300, 120),
        disableAnimations: true,
      );

      // No frame of it is animated: not a fast animation, none at all.
      expect(find.byType(FadeTransition), findsNothing);
      expect(find.text('Arrived'), findsOneWidget);
    });

    testWidgets('enabled: false skips the animation', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxEntryAnimation(
          enabled: false,
          child: AstryxText('Arrived'),
        ),
        surfaceSize: const Size(300, 120),
      );

      expect(find.byType(FadeTransition), findsNothing);
    });

    testWidgets('a delay holds it back', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxEntryAnimation(
          delay: Duration(milliseconds: 200),
          child: AstryxText('Arrived'),
        ),
        surfaceSize: const Size(300, 120),
      );

      final held = tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(held.opacity.value, 0);

      await tester.pump(const Duration(milliseconds: 220));
      await tester.pumpAndSettle();
      expect(find.text('Arrived'), findsOneWidget);
    });
  });

  group('AstryxContainerReveal', () {
    testWidgets('reveals at once with no scrollable above it', (tester) async {
      var revealed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxContainerReveal(
          onRevealed: () => revealed++,
          child: const AstryxText('Chart'),
        ),
        surfaceSize: const Size(300, 200),
      );
      await tester.pumpAndSettle();

      // Nothing to wait for. Content that never appears because it was looking
      // for a viewport that does not exist is the worse failure.
      expect(revealed, 1);
      expect(find.text('Chart'), findsOneWidget);
    });

    testWidgets('waits for the scroll that brings it into view', (
      tester,
    ) async {
      var revealed = 0;

      await pumpAstryxWidget(
        tester,
        SizedBox(
          height: 200,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 400, child: AstryxText('Above')),
              AstryxContainerReveal(
                onRevealed: () => revealed++,
                child: const SizedBox(height: 80, child: AstryxText('Chart')),
              ),
            ],
          ),
        ),
        surfaceSize: const Size(300, 240),
      );
      await tester.pumpAndSettle();

      expect(revealed, 0, reason: 'still below the fold');

      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pumpAndSettle();

      expect(revealed, 1);
    });

    testWidgets('reveals once, not on every scroll', (tester) async {
      var revealed = 0;

      await pumpAstryxWidget(
        tester,
        SizedBox(
          height: 200,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 400),
              AstryxContainerReveal(
                onRevealed: () => revealed++,
                child: const SizedBox(height: 80, child: AstryxText('Chart')),
              ),
              const SizedBox(height: 400),
            ],
          ),
        ),
        surfaceSize: const Size(300, 240),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pumpAndSettle();

      expect(revealed, 1);
    });

    testWidgets('the child is laid out before it is revealed', (tester) async {
      await pumpAstryxWidget(
        tester,
        const SizedBox(
          height: 200,
          // A non-lazy scroller, so the widget below the fold is really built —
          // a `ListView` would not have built it yet, which is a different
          // (and fine) reason for it not to be painted.
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 400),
                AstryxContainerReveal(
                  child: SizedBox(height: 80, child: AstryxText('Chart')),
                ),
              ],
            ),
          ),
        ),
        surfaceSize: const Size(300, 240),
      );
      await tester.pumpAndSettle();

      // In the tree and taking its space while invisible: a reveal that changed
      // the page height as it fired would move whatever the reader was reading.
      expect(tester.getSize(find.byType(AstryxContainerReveal)).height, 80);
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        0,
        reason: 'laid out, not painted',
      );
    });
  });

  group('AstryxKeyboardHint', () {
    Widget build() => const AstryxKeyboardHint(child: AstryxText('⌘K'));

    testWidgets('shows while the last input was a key', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(200, 100),
      );

      // The scope starts in keyboard mode, so the first focus of a session is
      // visible — the hint follows the same signal as the focus ring. Shown, it
      // is the child itself rather than a hidden `Visibility`.
      expect(find.text('⌘K'), findsOneWidget);
      expect(find.byType(Visibility), findsNothing);
    });

    testWidgets('steps back once a pointer is used', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(200, 100),
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      final hidden = tester.widget<Visibility>(find.byType(Visibility));
      expect(hidden.visible, isFalse);
      // Hidden, but still occupying its space: a hint that appears on the first
      // keystroke must not shove the row sideways.
      expect(hidden.maintainSize, isTrue);
    });

    testWidgets('otherwise takes the slot on a pointer', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxKeyboardHint(
          otherwise: AstryxText('2 minutes ago'),
          child: AstryxText('⌘K'),
        ),
        surfaceSize: const Size(240, 100),
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('2 minutes ago'), findsOneWidget);
      expect(find.text('⌘K'), findsNothing);
    });
  });

  group('AstryxStreamingText', () {
    testWidgets('reveals at the rate it is given', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxStreamingText(
          'Twelve chars',
          charactersPerSecond: 10,
        ),
        surfaceSize: const Size(300, 120),
      );

      await tester.pump(const Duration(milliseconds: 500));
      final half = tester.widget<AstryxText>(find.byType(AstryxText)).data;
      expect(half.length, greaterThan(0));
      expect(half.length, lessThan('Twelve chars'.length));

      await tester.pump(const Duration(milliseconds: 900));
      expect(
        tester.widget<AstryxText>(find.byType(AstryxText)).data,
        'Twelve chars',
      );
    });

    testWidgets('the whole text is the accessible name from the start', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxStreamingText('The whole answer', charactersPerSecond: 5),
        surfaceSize: const Size(300, 120),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // A live region firing per token would restart the sentence eighty times
      // a second, so the node carries the complete string instead.
      expect(find.bySemanticsLabel('The whole answer'), findsOneWidget);

      handle.dispose();
    });

    testWidgets('more text extends what is shown', (tester) async {
      var text = 'First part';

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxVStack(
            children: <Widget>[
              AstryxStreamingText(text, charactersPerSecond: 1000),
              AstryxButton(
                label: 'More',
                onPressed: () => setState(() => text = 'First part, then more'),
              ),
            ],
          ),
        ),
        surfaceSize: const Size(400, 200),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('First part'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('More'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('First part, then more'), findsOneWidget);
    });

    testWidgets('a rewrite is swapped in whole rather than retyped', (
      tester,
    ) async {
      var text = 'A wrong answer';

      await pumpAstryxWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => AstryxVStack(
            children: <Widget>[
              AstryxStreamingText(text, charactersPerSecond: 1000),
              AstryxButton(
                label: 'Replace',
                onPressed: () => setState(() => text = 'Something else'),
              ),
            ],
          ),
        ),
        surfaceSize: const Size(400, 200),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.bySemanticsLabel('Replace'));
      await tester.pump();

      // Immediately, with no typing: a caret walking backwards over a sentence
      // is unreadable.
      expect(find.text('Something else'), findsOneWidget);
    });

    testWidgets('under reduced motion everything arrived is shown at once', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxStreamingText('All of it now', charactersPerSecond: 1),
        surfaceSize: const Size(300, 120),
        disableAnimations: true,
      );

      expect(find.text('All of it now'), findsOneWidget);
    });
  });
}
