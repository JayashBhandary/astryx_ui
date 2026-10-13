import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Routes, route-based dialogs and sheets, and the system back button.
///
/// The Material equivalents are `MaterialPageRoute`, `showDialog`,
/// `showModalBottomSheet`, and the back button closing whatever is on top.
void main() {
  setUp(AstryxOverlayStack.reset);

  /// An app whose home page exposes its context through [onContext].
  Widget app({
    required ValueChanged<BuildContext> onContext,
    TargetPlatform platform = TargetPlatform.android,
    AstryxPageTransition? pageTransition,
    Map<String, WidgetBuilder> routes = const <String, WidgetBuilder>{},
    Widget? child,
  }) => AstryxApp(
    platform: platform,
    pageTransition: pageTransition,
    routes: routes,
    home: Builder(
      builder: (context) {
        onContext(context);
        return child ?? const AstryxText('Home');
      },
    ),
  );

  /// Simulates the Android back button.
  Future<void> pressBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  group('AstryxPageRoute', () {
    testWidgets('AstryxApp builds named routes as AstryxPageRoutes', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(
        app(
          onContext: (c) => home = c,
          routes: <String, WidgetBuilder>{
            '/next': (_) => const AstryxText('Next'),
          },
        ),
      );
      expect(ModalRoute.of(home), isA<AstryxPageRoute<dynamic>>());

      Navigator.of(home).pushNamed('/next');
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsOneWidget);
      expect(
        ModalRoute.of(tester.element(find.text('Next'))),
        isA<AstryxPageRoute<dynamic>>(),
      );
    });

    testWidgets('push animates rather than appearing in one frame', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      Navigator.of(home).push(
        AstryxPageRoute<void>(builder: (_) => const AstryxText('Next')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final opacity = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.text('Next'),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(opacity.opacity.value, inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsNothing);
    });

    testWidgets('pop returns the result', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      final result = Navigator.of(home).push<int>(
        AstryxPageRoute<int>(
          builder: (context) => AstryxButton(
            label: 'Done',
            onPressed: () => Navigator.pop(context, 7),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(await result, 7);
    });

    testWidgets('the transition follows the platform and the app', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(
        app(onContext: (c) => home = c, platform: TargetPlatform.iOS),
      );
      expect(AstryxPageTransitionScope.of(home), AstryxPageTransition.slide);

      await tester.pumpWidget(
        app(onContext: (c) => home = c, platform: TargetPlatform.android),
      );
      // The platform is part of the theme, so it changes when the theme
      // animation passes its midpoint.
      await tester.pumpAndSettle();
      expect(AstryxPageTransitionScope.of(home), AstryxPageTransition.fade);

      await tester.pumpWidget(
        app(
          onContext: (c) => home = c,
          platform: TargetPlatform.iOS,
          pageTransition: AstryxPageTransition.none,
        ),
      );
      expect(AstryxPageTransitionScope.of(home), AstryxPageTransition.none);
    });

    testWidgets('the page is painted on the body colour', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      final box = tester.widget<ColoredBox>(
        find
            .ancestor(of: find.text('Home'), matching: find.byType(ColoredBox))
            .first,
      );
      expect(
        box.color,
        AstryxTheme.of(home).color(AstryxColorToken.backgroundBody),
      );
    });

    testWidgets('a swipe from the leading edge goes back on iOS', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(
        app(onContext: (c) => home = c, platform: TargetPlatform.iOS),
      );
      Navigator.of(home).push(
        AstryxPageRoute<void>(builder: (_) => const AstryxText('Next')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsNothing);

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.moveBy(const Offset(400, 0));
      await tester.pump();
      // Mid-swipe, both pages are on screen.
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('a short swipe settles back', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(
        app(onContext: (c) => home = c, platform: TargetPlatform.iOS),
      );
      Navigator.of(home).push(
        AstryxPageRoute<void>(builder: (_) => const AstryxText('Next')),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });

    testWidgets('no swipe on the fade transition', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      Navigator.of(home).push(
        AstryxPageRoute<void>(builder: (_) => const AstryxText('Next')),
      );
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(400, 0));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('AstryxPage builds a page route for Navigator.pages', (
      tester,
    ) async {
      await tester.pumpWidget(
        AstryxThemeProvider(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Navigator(
              pages: const <Page<void>>[
                AstryxPage<void>(
                  key: ValueKey<String>('a'),
                  child: AstryxText('Page A'),
                ),
              ],
              onDidRemovePage: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Page A'), findsOneWidget);
      expect(
        ModalRoute.of(tester.element(find.text('Page A'))),
        isA<AstryxPageRoute<void>>(),
      );
    });
  });

  group('showAstryxDialog', () {
    testWidgets('returns the value it is popped with', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      final result = showAstryxDialog<String>(
        context: home,
        title: 'Rename',
        builder: (_) => const AstryxText('Body'),
        footerBuilder: (context) => AstryxButton(
          label: 'Save',
          onPressed: () => Navigator.pop(context, 'saved'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(await result, 'saved');
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('the close button, Escape, the barrier and back return null', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));

      Future<String?> open() {
        final result = showAstryxDialog<String>(
          context: home,
          title: 'Dialog',
          builder: (_) => const AstryxText('Body'),
        );
        return result;
      }

      var result = open();
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Close'));
      await tester.pumpAndSettle();
      expect(await result, isNull);

      result = open();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(find.text('Body'), findsNothing);

      result = open();
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(find.text('Body'), findsNothing);

      result = open();
      await tester.pumpAndSettle();
      await pressBack(tester);
      expect(await result, isNull);
      expect(find.text('Body'), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('escapeDismissible: false keeps it open on Escape', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      showAstryxDialog<void>(
        context: home,
        escapeDismissible: false,
        barrierDismissible: false,
        builder: (_) => const AstryxText('Body'),
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('keeps a subtree component theme', (tester) async {
      late BuildContext inner;
      await tester.pumpWidget(
        app(
          onContext: (_) {},
          child: AstryxComponentTheme(
            data: const AstryxComponentThemes(
              divider: AstryxDividerTheme(thickness: 5),
            ),
            child: Builder(
              builder: (context) {
                inner = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      double? seen;
      showAstryxDialog<void>(
        context: inner,
        builder: (context) {
          seen = AstryxTheme.of(context).divider.thickness;
          return const SizedBox.shrink();
        },
      );
      await tester.pumpAndSettle();
      expect(seen, 5);
    });
  });

  group('route focus', () {
    testWidgets('an autofocus inside the dialog still takes focus', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      final node = FocusNode();
      addTearDown(node.dispose);
      showAstryxDialog<void>(
        context: home,
        builder: (_) => Focus(
          focusNode: node,
          autofocus: true,
          child: const SizedBox(width: 10, height: 10),
        ),
      );
      await tester.pumpAndSettle();
      expect(node.hasPrimaryFocus, isTrue);

      // Escape from inside still closes it.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate((w) => w is Focus && w.focusNode == node),
        findsNothing,
      );
    });

    testWidgets('the alert focuses cancel', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      final result = showAstryxAlertDialog(
        context: home,
        title: 'Delete project',
        description: 'Gone for good.',
        confirmLabel: 'Delete',
      );
      await tester.pumpAndSettle();
      // Enter out of habit presses the focused button: cancel, not delete.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });
  });

  group('showAstryxAlertDialog', () {
    testWidgets('confirm is true; cancel and back are false', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));

      Future<bool> open() => showAstryxAlertDialog(
        context: home,
        title: 'Delete project',
        description: 'This cannot be undone.',
        confirmLabel: 'Delete',
        destructive: true,
      );

      var result = open();
      await tester.pumpAndSettle();
      expect(find.text('This cannot be undone.'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);

      result = open();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await result, isFalse);

      result = open();
      await tester.pumpAndSettle();
      // The barrier does not dismiss an alert.
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.text('Delete project'), findsOneWidget);
      await pressBack(tester);
      expect(await result, isFalse);
    });
  });

  group('showAstryxBottomSheet', () {
    testWidgets('returns the value and closes on back', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));

      var result = showAstryxBottomSheet<String>(
        context: home,
        label: 'Share',
        height: AstryxBottomSheetHeight.hug,
        builder: (context) => AstryxButton(
          label: 'Copy link',
          onPressed: () => Navigator.pop(context, 'copy'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy link'));
      await tester.pumpAndSettle();
      expect(await result, 'copy');

      result = showAstryxBottomSheet<String>(
        context: home,
        label: 'Share',
        builder: (_) => const AstryxText('Sheet'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sheet'), findsOneWidget);
      await pressBack(tester);
      expect(await result, isNull);
      expect(find.text('Sheet'), findsNothing);
    });
  });

  group('back button with declarative overlays', () {
    testWidgets('back closes an open AstryxDialog, not the page', (
      tester,
    ) async {
      final dialog = AstryxDialogController();
      addTearDown(dialog.dispose);
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      Navigator.of(home).push(
        AstryxPageRoute<void>(
          builder: (_) => Column(
            children: <Widget>[
              const AstryxText('Page'),
              AstryxDialog(
                controller: dialog,
                title: 'Dialog',
                child: const AstryxText('Body'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      dialog.show();
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);

      await pressBack(tester);
      expect(dialog.isOpen, isFalse);
      expect(find.text('Body'), findsNothing);
      expect(find.text('Page'), findsOneWidget);

      // With nothing open, back leaves the page as usual.
      await pressBack(tester);
      expect(find.text('Page'), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('back closes only the top-most of two layers', (tester) async {
      final outer = AstryxDialogController();
      final inner = AstryxDialogController();
      addTearDown(outer.dispose);
      addTearDown(inner.dispose);
      await tester.pumpWidget(
        app(
          onContext: (_) {},
          child: Column(
            children: <Widget>[
              AstryxDialog(
                controller: outer,
                title: 'Outer',
                child: const AstryxText('Outer body'),
              ),
              AstryxDialog(
                controller: inner,
                title: 'Inner',
                child: const AstryxText('Inner body'),
              ),
            ],
          ),
        ),
      );
      outer.show();
      await tester.pumpAndSettle();
      inner.show();
      await tester.pumpAndSettle();

      await pressBack(tester);
      expect(inner.isOpen, isFalse);
      expect(outer.isOpen, isTrue);

      await pressBack(tester);
      expect(outer.isOpen, isFalse);
    });

    testWidgets('a tooltip does not hold up back', (tester) async {
      late BuildContext home;
      await tester.pumpWidget(app(onContext: (c) => home = c));
      Navigator.of(home).push(
        AstryxPageRoute<void>(
          builder: (_) => const Center(
            child: AstryxTooltip(
              message: 'Tip',
              child: AstryxText('Page'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final route = ModalRoute.of(tester.element(find.text('Page')))!;
      expect(route.popDisposition, RoutePopDisposition.pop);
    });
  });
}
