import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The overlays added after Phase 9: the alert dialog, the hover card, the
/// overlay layer, the two collapsibles and the context menu.
///
/// Each is tested on the thing that makes it *different* from the widget it
/// resembles — an alert dialog's barrier that does not dismiss, a hover card
/// that survives the pointer crossing onto it, a collapsible that builds
/// nothing while closed — rather than on the machinery they all share, which
/// `overlay_test.dart` already covers.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxAlertDialog', () {
    late List<String> answers;

    Widget build({
      bool barrierDismissible = false,
      bool showCancel = true,
    }) {
      final controller = AstryxDialogController()..show();
      addTearDown(controller.dispose);

      return AstryxAlertDialog(
        controller: controller,
        title: 'Delete project',
        description: 'Atlas will be removed. This cannot be undone.',
        confirmLabel: 'Delete project',
        destructive: true,
        showCancel: showCancel,
        barrierDismissible: barrierDismissible,
        onConfirm: () => answers.add('confirmed'),
        onCancel: () => answers.add('cancelled'),
      );
    }

    setUp(() => answers = <String>[]);

    testWidgets('a press on the barrier does not answer the question', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(
        find.text('Delete project'),
        findsWidgets,
        reason:
            'the point of the component is that a stray click cannot '
            'dismiss it',
      );
      expect(answers, isEmpty);
    });

    testWidgets('Escape cancels', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(answers, <String>['cancelled']);
      expect(
        find.text('Atlas will be removed. This cannot be undone.'),
        findsNothing,
      );
    });

    testWidgets('confirming closes first, then calls back', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(AstryxButton, 'Delete project'));
      await tester.pumpAndSettle();

      expect(answers, <String>['confirmed']);
      expect(
        find.text('Atlas will be removed. This cannot be undone.'),
        findsNothing,
      );
    });

    testWidgets('cancel holds focus when it opens', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      // Enter on the focused control must not be the destructive one.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(
        answers,
        <String>['cancelled'],
        reason: 'focus starts on the safe answer, not on the destructive one',
      );
    });

    testWidgets('an acknowledgement has one way out', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(showCancel: false),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsNothing);

      await tester.tap(find.widgetWithText(AstryxButton, 'Delete project'));
      await tester.pumpAndSettle();
      expect(answers, <String>['confirmed']);
    });
  });

  group('AstryxOverlay', () {
    testWidgets('renders nothing until the controller opens it', (
      tester,
    ) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxOverlay(
          controller: controller,
          label: 'Preview',
          child: const AstryxText('On the layer'),
        ),
        surfaceSize: const Size(500, 400),
      );

      expect(find.text('On the layer'), findsNothing);

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('On the layer'), findsOneWidget);
    });

    testWidgets('the scrim dismisses, unless told not to', (tester) async {
      final controller = AstryxOverlayController()..show();
      addTearDown(controller.dispose);
      var dismissed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxOverlay(
          controller: controller,
          onDismiss: () => dismissed++,
          child: const AstryxText('On the layer'),
        ),
        surfaceSize: const Size(500, 400),
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(dismissed, 1);
      expect(controller.isOpen, isFalse);
      expect(find.text('On the layer'), findsNothing);
    });

    testWidgets('Escape closes one layer, not the stack', (tester) async {
      final outer = AstryxOverlayController()..show();
      final inner = AstryxOverlayController();
      addTearDown(outer.dispose);
      addTearDown(inner.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxOverlay(
          controller: outer,
          child: AstryxOverlay(
            controller: inner,
            child: const AstryxText('Inner layer'),
          ),
        ),
        surfaceSize: const Size(500, 400),
      );
      await tester.pumpAndSettle();

      inner.show();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(inner.isOpen, isFalse);
      expect(
        outer.isOpen,
        isTrue,
        reason: 'closing the top layer must not take the one beneath it',
      );
    });

    testWidgets('focus returns to the trigger on close', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);
      final trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxVStack(
          children: <Widget>[
            AstryxButton(
              label: 'Open',
              focusNode: trigger,
              onPressed: controller.show,
            ),
            AstryxOverlay(
              controller: controller,
              child: AstryxButton(label: 'Inside', onPressed: () {}),
            ),
          ],
        ),
        surfaceSize: const Size(500, 400),
      );

      trigger.requestFocus();
      await tester.pump();
      controller.show();
      await tester.pumpAndSettle();

      expect(trigger.hasPrimaryFocus, isFalse);

      controller.hide();
      await tester.pumpAndSettle();
      expect(trigger.hasPrimaryFocus, isTrue);
    });
  });

  group('AstryxHoverCard', () {
    Widget build({Duration wait = const Duration(milliseconds: 300)}) => Center(
      child: AstryxHoverCard(
        label: 'Ada Lovelace',
        waitDuration: wait,
        content: AstryxButton(label: 'Follow', onPressed: () {}),
        child: const AstryxText('@ada'),
      ),
    );

    testWidgets('opens on hover, after the wait', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 400),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('@ada')));
      await tester.pump();
      expect(
        find.text('Follow'),
        findsNothing,
        reason: 'a panel under every passing mouse makes a page unusable',
      );

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('survives the pointer crossing onto the card', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(wait: Duration.zero),
        surfaceSize: const Size(500, 400),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('@ada')));
      await tester.pumpAndSettle();
      expect(find.text('Follow'), findsOneWidget);

      // Off the trigger and onto the card, which is the journey a tooltip
      // cannot survive and this one must.
      await gesture.moveTo(tester.getCenter(find.text('Follow')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('closes once the pointer leaves both', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(wait: Duration.zero),
        surfaceSize: const Size(500, 400),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('@ada')));
      await tester.pumpAndSettle();
      expect(find.text('Follow'), findsOneWidget);

      await gesture.moveTo(const Offset(2, 2));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Follow'), findsNothing);
    });

    testWidgets('a long-press reaches it on touch', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        density: AstryxDensity.touch,
        surfaceSize: const Size(500, 400),
      );

      await tester.longPress(find.text('@ada'));
      await tester.pumpAndSettle();

      expect(find.text('Follow'), findsOneWidget);

      // Touch has no pointer-exit, so a press elsewhere is the way out.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Follow'), findsNothing);
    });
  });

  group('AstryxCollapsible', () {
    testWidgets('builds nothing while collapsed', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCollapsible(
          title: 'Advanced settings',
          child: AstryxText('Retries and timeouts'),
        ),
      );

      expect(find.text('Retries and timeouts'), findsNothing);

      await tester.tap(find.text('Advanced settings'));
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsOneWidget);

      await tester.tap(find.text('Advanced settings'));
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsNothing);
    });

    testWidgets('Enter and Space work the header', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCollapsible(
          title: 'Advanced settings',
          child: AstryxText('Retries and timeouts'),
        ),
      );

      final focus = Focus.of(
        tester.element(find.text('Advanced settings')),
      );
      focus.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsNothing);
    });

    testWidgets('reports the state, rather than only painting it', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(
        tester,
        const AstryxCollapsible(
          title: 'Advanced settings',
          child: AstryxText('Retries and timeouts'),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Advanced settings')),
        matchesSemantics(
          label: 'Advanced settings',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
          hasExpandedState: true,
          hasTapAction: true,
          isFocusable: true,
        ),
      );

      await tester.tap(find.text('Advanced settings'));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel('Advanced settings')),
        matchesSemantics(
          label: 'Advanced settings',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
          hasExpandedState: true,
          isExpanded: true,
          hasTapAction: true,
          isFocusable: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('a controller owns the state when one is given', (
      tester,
    ) async {
      final controller = AstryxCollapsibleController(expanded: true);
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxCollapsible(
          title: 'Advanced settings',
          controller: controller,
          child: const AstryxText('Retries and timeouts'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Retries and timeouts'), findsOneWidget);

      controller.collapse();
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsNothing);
    });

    testWidgets('a disabled header does nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCollapsible(
          title: 'Advanced settings',
          enabled: false,
          child: AstryxText('Retries and timeouts'),
        ),
      );

      await tester.tap(find.text('Advanced settings'));
      await tester.pumpAndSettle();
      expect(find.text('Retries and timeouts'), findsNothing);
    });
  });

  group('AstryxCollapsibleGroup', () {
    testWidgets('exclusive closes the one that was open', (tester) async {
      final opened = <int?>[];

      await pumpAstryxWidget(
        tester,
        AstryxCollapsibleGroup(
          exclusive: true,
          initialIndex: 0,
          onChanged: opened.add,
          children: const <AstryxCollapsible>[
            AstryxCollapsible(title: 'Billing', child: AstryxText('Invoices')),
            AstryxCollapsible(title: 'Members', child: AstryxText('Seats')),
          ],
        ),
        surfaceSize: const Size(400, 400),
      );
      await tester.pumpAndSettle();

      expect(find.text('Invoices'), findsOneWidget);
      expect(find.text('Seats'), findsNothing);

      await tester.tap(find.text('Members'));
      await tester.pumpAndSettle();

      expect(find.text('Invoices'), findsNothing);
      expect(find.text('Seats'), findsOneWidget);
      expect(opened, <int?>[1]);

      await tester.tap(find.text('Members'));
      await tester.pumpAndSettle();
      expect(find.text('Seats'), findsNothing);
      expect(opened, <int?>[1, null]);
    });

    testWidgets('a plain group leaves each section its own state', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCollapsibleGroup(
          children: <AstryxCollapsible>[
            AstryxCollapsible(title: 'Billing', child: AstryxText('Invoices')),
            AstryxCollapsible(title: 'Members', child: AstryxText('Seats')),
          ],
        ),
        surfaceSize: const Size(400, 400),
      );

      await tester.tap(find.text('Billing'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Members'));
      await tester.pumpAndSettle();

      expect(find.text('Invoices'), findsOneWidget);
      expect(
        find.text('Seats'),
        findsOneWidget,
        reason: 'comparing two sections is what a non-exclusive group is for',
      );
    });
  });

  group('AstryxContextMenu', () {
    late List<String> chosen;

    Widget build({bool enabled = true}) => Center(
      child: AstryxContextMenu(
        label: 'Row actions',
        enabled: enabled,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(
            label: 'Rename',
            onSelected: () => chosen.add('rename'),
          ),
          const AstryxMenuDivider(),
          AstryxMenuItem(
            label: 'Delete',
            destructive: true,
            onSelected: () => chosen.add('delete'),
          ),
        ],
        child: const SizedBox(width: 200, height: 80, child: AstryxText('Row')),
      ),
    );

    setUp(() => chosen = <String>[]);

    Future<void> secondaryTapAt(WidgetTester tester, Offset at) async {
      final gesture = await tester.startGesture(
        at,
        buttons: kSecondaryMouseButton,
        kind: PointerDeviceKind.mouse,
      );
      await gesture.up();
      await tester.pumpAndSettle();
    }

    testWidgets('a secondary click opens it at the pointer', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );

      expect(find.text('Rename'), findsNothing);

      final at = tester.getCenter(find.text('Row'));
      await secondaryTapAt(tester, at);

      expect(find.text('Rename'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Rename')).dx,
        greaterThanOrEqualTo(at.dx),
        reason: 'the menu belongs where the pointer was, not where the row is',
      );
    });

    testWidgets('choosing closes the menu and then acts', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );

      await secondaryTapAt(tester, tester.getCenter(find.text('Row')));
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      expect(chosen, <String>['rename']);
      expect(find.text('Rename'), findsNothing);
    });

    testWidgets('Escape closes it', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );

      await secondaryTapAt(tester, tester.getCenter(find.text('Row')));
      expect(find.text('Rename'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsNothing);
    });

    testWidgets('a long-press reaches it on touch', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        density: AstryxDensity.touch,
        surfaceSize: const Size(600, 500),
      );

      await tester.longPress(find.text('Row'));
      await tester.pumpAndSettle();

      expect(find.text('Rename'), findsOneWidget);
    });

    testWidgets('a long-press does nothing on a pointer', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(600, 500),
      );

      await tester.longPress(find.text('Row'));
      await tester.pumpAndSettle();

      expect(
        find.text('Rename'),
        findsNothing,
        reason: 'holding a mouse button down is not a request for a menu',
      );
    });

    testWidgets('disabled opens nothing', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(enabled: false),
        surfaceSize: const Size(600, 500),
      );

      await secondaryTapAt(tester, tester.getCenter(find.text('Row')));
      expect(find.text('Rename'), findsNothing);
    });
  });

  group('disposed while open', () {
    testWidgets('an alert dialog', (tester) async {
      final controller = AstryxDialogController()..show();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxAlertDialog(
          controller: controller,
          title: 'Delete project',
          description: 'This cannot be undone.',
          confirmLabel: 'Delete',
        ),
        surfaceSize: const Size(600, 500),
      );
      await tester.pumpAndSettle();

      await pumpAstryxWidget(tester, const AstryxText('gone'));
      await tester.pumpAndSettle();

      expect(
        AstryxOverlayStack.depth,
        0,
        reason: 'a disposed layer that stays registered eats the next Escape',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('an overlay layer', (tester) async {
      final controller = AstryxOverlayController()..show();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxOverlay(
          controller: controller,
          child: const AstryxText('On the layer'),
        ),
        surfaceSize: const Size(500, 400),
      );
      await tester.pumpAndSettle();

      await pumpAstryxWidget(tester, const AstryxText('gone'));
      await tester.pumpAndSettle();

      expect(AstryxOverlayStack.depth, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a hover card mid-delay', (tester) async {
      await pumpAstryxWidget(
        tester,
        const Center(
          child: AstryxHoverCard(
            content: AstryxText('Card'),
            child: AstryxText('@ada'),
          ),
        ),
        surfaceSize: const Size(500, 400),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('@ada')));
      await tester.pump(const Duration(milliseconds: 100));

      await pumpAstryxWidget(tester, const AstryxText('gone'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a context menu', (tester) async {
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxContextMenu(
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Rename', onSelected: () {}),
            ],
            child: const SizedBox(
              width: 200,
              height: 80,
              child: AstryxText('Row'),
            ),
          ),
        ),
        surfaceSize: const Size(600, 500),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Row')),
        buttons: kSecondaryMouseButton,
        kind: PointerDeviceKind.mouse,
      );
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget);

      await pumpAstryxWidget(tester, const AstryxText('gone'));
      await tester.pumpAndSettle();

      expect(AstryxOverlayStack.depth, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a collapsible mid-animation', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxCollapsible(
          title: 'Advanced settings',
          child: AstryxText('Retries'),
        ),
      );

      await tester.tap(find.text('Advanced settings'));
      await tester.pump(const Duration(milliseconds: 40));

      await pumpAstryxWidget(tester, const AstryxText('gone'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
