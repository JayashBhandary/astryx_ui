import 'dart:ui' show PointerDeviceKind;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Phase 9 — overlays.
///
/// The emphasis is dismissal, focus and leaks. `P9-7` names the last one
/// specifically — an overlay disposed while open is a real bug class, and the
/// symptom is not a crash but a layer that keeps eating Escape long after the
/// widget that owned it is gone.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('P9-2 — AstryxPopover', () {
    Widget build({
      AstryxOverlayController? controller,
      bool trapFocus = true,
      bool barrierDismissible = true,
      bool escapeDismissible = true,
      FocusNode? triggerFocus,
    }) => Center(
      child: AstryxPopover(
        controller: controller,
        label: 'Settings',
        trapFocus: trapFocus,
        barrierDismissible: barrierDismissible,
        escapeDismissible: escapeDismissible,
        content: AstryxButton(label: 'Inside', onPressed: () {}),
        triggerBuilder: (context, controller) => AstryxButton(
          label: 'Open',
          focusNode: triggerFocus,
          onPressed: controller.toggle,
        ),
      ),
    );

    testWidgets('opens on a press and closes on a press outside', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      expect(find.text('Inside'), findsNothing);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsNothing);
    });

    testWidgets('Escape closes it', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsNothing);
    });

    testWidgets('honours barrierDismissible and escapeDismissible', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(barrierDismissible: false, escapeDismissible: false),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsOneWidget);
    });

    testWidgets('returns focus to the trigger on close', (tester) async {
      final trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);

      await pumpAstryxWidget(
        tester,
        build(triggerFocus: trigger),
        surfaceSize: const Size(500, 500),
      );

      trigger.requestFocus();
      await tester.pump();
      expect(trigger.hasFocus, isTrue);

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(trigger.hasFocus, isFalse, reason: 'focus moved into the panel');

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      // The behaviour that is easy to skip and impossible to work around.
      expect(trigger.hasFocus, isTrue);
    });

    testWidgets('a controller drives it from outside', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller: controller),
        surfaceSize: const Size(500, 500),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsOneWidget);

      controller.hide();
      await tester.pumpAndSettle();
      expect(find.text('Inside'), findsNothing);
    });

    testWidgets('names the panel for a screen reader', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Settings'), findsOneWidget);
      handle.dispose();
    });
  });

  group('P9-3 — AstryxTooltip', () {
    Widget build({
      Duration wait = const Duration(milliseconds: 200),
      bool enabled = true,
    }) => Center(
      child: AstryxTooltip(
        message: 'Archive this conversation',
        waitDuration: wait,
        enabled: enabled,
        child: AstryxButton(label: 'Archive', onPressed: () {}),
      ),
    );

    testWidgets('appears after the wait and hides on exit', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Archive')));
      await tester.pump();
      expect(
        find.text('Archive this conversation'),
        findsNothing,
        reason: 'the delay filters a pointer merely passing through',
      );

      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsOneWidget);

      await gesture.moveTo(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsNothing);
    });

    testWidgets('a long-press reveals it on touch', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        density: AstryxDensity.touch,
        surfaceSize: const Size(500, 500),
      );

      // The ADR-006 commitment: a hover-only tooltip is invisible here.
      await tester.longPress(find.text('Archive'));
      await tester.pumpAndSettle();
      expect(find.text('Archive this conversation'), findsOneWidget);
    });

    testWidgets('the message reaches semantics without any gesture', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      final node = tester.getSemantics(find.byType(AstryxButton));
      expect(node.tooltip, 'Archive this conversation');
      // `getSemanticsData()`, not `.label`: on a merged node the latter
      // returns only the node's own string, and the whole point here is that
      // the trigger's name and the tooltip arrive as one announcement.
      expect(
        node.getSemanticsData().label,
        'Archive',
        reason: 'merged into the trigger, not a second node beside it',
      );
      handle.dispose();
    });

    testWidgets('does not swallow the trigger press', (tester) async {
      var pressed = 0;
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxTooltip(
            message: 'Archive',
            child: AstryxButton(
              label: 'Archive',
              onPressed: () => pressed++,
            ),
          ),
        ),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Archive'));
      await tester.pump();
      expect(pressed, 1);
    });

    testWidgets('enabled: false never shows', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(enabled: false, wait: Duration.zero),
        surfaceSize: const Size(500, 500),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('Archive')));
      await tester.pumpAndSettle();

      expect(find.text('Archive this conversation'), findsNothing);
    });
  });

  group('P9-4 — AstryxDropdownMenu', () {
    late List<String> chosen;

    Widget build({TextDirection? direction}) {
      final menu = AstryxDropdownMenu(
        label: 'Actions',
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Edit', onSelected: () => chosen.add('edit')),
          AstryxMenuItem(
            label: 'Duplicate',
            enabled: false,
            onSelected: () => chosen.add('duplicate'),
          ),
          const AstryxMenuDivider(),
          AstryxMenuItem(
            label: 'Move to',
            submenu: <AstryxMenuEntry>[
              AstryxMenuItem(
                label: 'Archive',
                onSelected: () => chosen.add('archive'),
              ),
            ],
          ),
          AstryxMenuItem(
            label: 'Delete',
            destructive: true,
            onSelected: () => chosen.add('delete'),
          ),
        ],
        triggerBuilder: (context, controller) =>
            AstryxButton(label: 'Actions', onPressed: controller.toggle),
      );
      return Center(child: menu);
    }

    setUp(() => chosen = <String>[]);

    testWidgets('opens, and the arrows move without activating', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(chosen, isEmpty, reason: 'browsing is not choosing');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(chosen, <String>['edit']);
      expect(find.text('Edit'), findsNothing, reason: 'it closed first');
    });

    testWidgets('the arrows skip a disabled item', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(
        chosen,
        <String>[],
        reason: 'the third item is a submenu, which opens rather than fires',
      );
      expect(find.text('Archive'), findsOneWidget);
    });

    testWidgets('End jumps to the last item', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosen, <String>['delete']);
    });

    testWidgets('type-ahead jumps to the first match', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyD);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(
        chosen,
        <String>['delete'],
        reason: '"Duplicate" is disabled, so "Delete" is the first match',
      );
    });

    testWidgets('Right opens a submenu and Left closes it', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Archive'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Archive'), findsNothing);
    });

    testWidgets('the submenu arrows mirror under RTL', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        textDirection: TextDirection.rtl,
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      // Left is forward under RTL.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Archive'), findsOneWidget);
    });

    testWidgets('Escape closes it', (tester) async {
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsNothing);
    });

    testWidgets('each item is a button in the semantics tree', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        build(),
        surfaceSize: const Size(500, 500),
      );

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.text('Edit'));
      expect(node.flagsCollection.isButton, isTrue);
      handle.dispose();
    });
  });

  group('P9-5 — AstryxDialog', () {
    Widget build(
      AstryxDialogController controller, {
      bool barrierDismissible = true,
      bool escapeDismissible = true,
      FocusNode? triggerFocus,
    }) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AstryxButton(
            label: 'Open',
            focusNode: triggerFocus,
            onPressed: controller.show,
          ),
          AstryxDialog(
            controller: controller,
            title: 'Delete project',
            barrierDismissible: barrierDismissible,
            escapeDismissible: escapeDismissible,
            footer: AstryxButton(label: 'Cancel', onPressed: controller.hide),
            child: AstryxButton(label: 'Confirm', onPressed: () {}),
          ),
        ],
      ),
    );

    testWidgets('opens, and Escape closes it', (tester) async {
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller),
        surfaceSize: const Size(600, 600),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Delete project'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Delete project'), findsNothing);
    });

    testWidgets('a press on the barrier closes it, unless told not to', (
      tester,
    ) async {
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller),
        surfaceSize: const Size(600, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Delete project'), findsNothing);

      final locked = AstryxDialogController();
      addTearDown(locked.dispose);
      await pumpAstryxWidget(
        tester,
        build(locked, barrierDismissible: false),
        surfaceSize: const Size(600, 600),
      );
      locked.show();
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Delete project'), findsOneWidget);
    });

    testWidgets('traps focus and restores it to the trigger', (tester) async {
      final controller = AstryxDialogController();
      final trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(controller.dispose);
      addTearDown(trigger.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller, triggerFocus: trigger),
        surfaceSize: const Size(600, 600),
      );

      trigger.requestFocus();
      await tester.pump();

      controller.show();
      await tester.pumpAndSettle();
      expect(trigger.hasFocus, isFalse);

      // Tab all the way round: focus must still be inside the dialog.
      for (var i = 0; i < 6; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }
      expect(
        trigger.hasFocus,
        isFalse,
        reason: 'tabbing must not escape the dialog',
      );

      controller.hide();
      await tester.pumpAndSettle();
      expect(trigger.hasFocus, isTrue);
    });

    testWidgets('scopes and names the route for a screen reader', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        build(controller),
        surfaceSize: const Size(600, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.bySemanticsLabel('Delete project'));
      expect(node.flagsCollection.scopesRoute, isTrue);
      expect(node.flagsCollection.namesRoute, isTrue);
      handle.dispose();
    });

    testWidgets('content taller than the viewport scrolls', (tester) async {
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxDialog(
            controller: controller,
            title: 'Terms',
            child: Column(
              children: <Widget>[
                for (var i = 0; i < 40; i++) AstryxText('Clause $i'),
              ],
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();

      // No overflow exception, and the body really is scrollable.
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(AstryxDialog),
          matching: find.byType(Scrollable),
        ),
        findsWidgets,
      );
    });
  });

  group('P9-6 — AstryxToast', () {
    testWidgets('the provider installs a host, so no setup is needed', (
      tester,
    ) async {
      late BuildContext inner;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            inner = context;
            return const SizedBox.shrink();
          },
        ),
      );

      AstryxToastScope.of(inner).show(
        const AstryxToast(message: 'Project archived'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Project archived'), findsOneWidget);
    });

    testWidgets('auto-dismisses after its duration', (tester) async {
      late BuildContext inner;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            inner = context;
            return const SizedBox.shrink();
          },
        ),
      );

      AstryxToastScope.of(inner).show(
        const AstryxToast(
          message: 'Saved',
          duration: Duration(milliseconds: 500),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsNothing);
    });

    testWidgets('Duration.zero keeps it until dismissed', (tester) async {
      late BuildContext inner;
      await pumpAstryxWidget(
        tester,
        Builder(
          builder: (context) {
            inner = context;
            return const SizedBox.shrink();
          },
        ),
      );

      AstryxToastScope.of(inner).show(
        const AstryxToast(message: 'Pinned', duration: Duration.zero),
      );
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      expect(find.text('Pinned'), findsOneWidget);

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pumpAndSettle();
      expect(find.text('Pinned'), findsNothing);
    });

    testWidgets('never shows more than maxVisible at once', (tester) async {
      final controller = AstryxToastController(maxVisible: 2);
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        const SizedBox.shrink(),
        toastController: controller,
      );

      for (var i = 0; i < 5; i++) {
        controller.show(
          AstryxToast(message: 'Toast $i', duration: Duration.zero),
        );
      }
      await tester.pumpAndSettle();

      expect(find.text('Toast 0'), findsOneWidget);
      expect(find.text('Toast 1'), findsOneWidget);
      expect(find.text('Toast 2'), findsNothing);
    });

    testWidgets('is announced as a live region', (tester) async {
      final handle = tester.ensureSemantics();
      final controller = AstryxToastController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        const SizedBox.shrink(),
        toastController: controller,
      );
      controller.show(
        const AstryxToast(message: 'Archived', duration: Duration.zero),
      );
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.bySemanticsLabel('Notifications'));
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });

    testWidgets('the default position follows density', (tester) async {
      expect(
        AstryxToastPosition.defaultFor(AstryxDensity.pointer),
        AstryxToastPosition.bottomEnd,
      );
      expect(
        AstryxToastPosition.defaultFor(AstryxDensity.touch),
        AstryxToastPosition.bottomStart,
      );
    });
  });

  group('P9-7 — dismissal, focus and leaks', () {
    testWidgets('Escape closes one layer, not all of them', (tester) async {
      final dialog = AstryxDialogController();
      final popover = AstryxOverlayController();
      addTearDown(dialog.dispose);
      addTearDown(popover.dispose);

      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxDialog(
            controller: dialog,
            title: 'Outer',
            child: AstryxPopover(
              controller: popover,
              label: 'Inner',
              content: const AstryxText('Panel'),
              triggerBuilder: (context, inner) =>
                  AstryxButton(label: 'Open inner', onPressed: inner.toggle),
            ),
          ),
        ),
        surfaceSize: const Size(600, 600),
      );

      dialog.show();
      await tester.pumpAndSettle();
      popover.show();
      await tester.pumpAndSettle();
      expect(find.text('Panel'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // The popover goes; the dialog stays. Without the shared stack both
      // would close and the user would lose work they were in the middle of.
      expect(find.text('Panel'), findsNothing);
      expect(find.text('Outer'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Outer'), findsNothing);
    });

    testWidgets('disposing while open leaves nothing behind', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxPopover(
            controller: controller,
            content: const AstryxText('Panel'),
            triggerBuilder: (context, c) =>
                AstryxButton(label: 'Open', onPressed: c.toggle),
          ),
        ),
        surfaceSize: const Size(500, 500),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Panel'), findsOneWidget);
      expect(AstryxOverlayStack.depth, 1);

      // The parent goes away with the overlay still showing — the real bug
      // class, whose symptom is a dead layer that keeps eating Escape.
      await pumpAstryxWidget(tester, const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(find.text('Panel'), findsNothing);
      expect(AstryxOverlayStack.depth, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a closed overlay is off the stack', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxPopover(
            controller: controller,
            content: const AstryxText('Panel'),
            triggerBuilder: (context, c) =>
                AstryxButton(label: 'Open', onPressed: c.toggle),
          ),
        ),
        surfaceSize: const Size(500, 500),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(AstryxOverlayStack.depth, 1);

      controller.hide();
      await tester.pumpAndSettle();
      expect(AstryxOverlayStack.depth, 0);
    });

    testWidgets('the positioner keeps an overlay inside the viewport', (
      tester,
    ) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Align(
          alignment: Alignment.bottomCenter,
          child: AstryxPopover(
            controller: controller,
            width: 200,
            content: const SizedBox(height: 200, child: AstryxText('Tall')),
            triggerBuilder: (context, c) =>
                AstryxButton(label: 'Open', onPressed: c.toggle),
          ),
        ),
      );

      controller.show();
      await tester.pumpAndSettle();

      // Below the trigger there is no room, so it flips above rather than
      // being clipped away — the same rule the geometry table proves in
      // isolation, here through a real widget.
      final rect = tester.getRect(find.text('Tall'));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(300));
    });
  });

  group('AstryxFocusTrap', () {
    testWidgets('restores focus on dispose', (tester) async {
      final outside = FocusNode(debugLabel: 'outside');
      addTearDown(outside.dispose);

      Widget build({required bool trapped}) => Column(
        children: <Widget>[
          Focus(
            focusNode: outside,
            child: const SizedBox(width: 10, height: 10),
          ),
          if (trapped)
            const AstryxFocusTrap(
              child: Focus(child: SizedBox(width: 10, height: 10)),
            ),
        ],
      );

      await pumpAstryxWidget(tester, build(trapped: false));
      outside.requestFocus();
      await tester.pump();
      expect(outside.hasFocus, isTrue);

      await pumpAstryxWidget(tester, build(trapped: true));
      await tester.pump();
      expect(outside.hasFocus, isFalse);

      await pumpAstryxWidget(tester, build(trapped: false));
      await tester.pump();
      expect(outside.hasFocus, isTrue);
    });

    testWidgets('restoreFocus: false does not claw focus back', (tester) async {
      final first = FocusNode(debugLabel: 'first');
      final second = FocusNode(debugLabel: 'second');
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      Widget build({required bool trapped, required bool restore}) => Column(
        children: <Widget>[
          Focus(
            focusNode: first,
            child: const SizedBox(width: 10, height: 10),
          ),
          Focus(
            focusNode: second,
            child: const SizedBox(width: 10, height: 10),
          ),
          if (trapped)
            AstryxFocusTrap(
              restoreFocus: restore,
              child: const Focus(child: SizedBox(width: 10, height: 10)),
            ),
        ],
      );

      // Focus moves elsewhere *while the trap is open*. Restoring then means
      // overruling that move; not restoring means respecting it. Both are
      // defensible, which is exactly why the flag exists.
      for (final restore in <bool>[true, false]) {
        await pumpAstryxWidget(
          tester,
          build(trapped: false, restore: restore),
        );
        first.requestFocus();
        await tester.pump();

        await pumpAstryxWidget(tester, build(trapped: true, restore: restore));
        await tester.pump();

        second.requestFocus();
        await tester.pump();

        await pumpAstryxWidget(
          tester,
          build(trapped: false, restore: restore),
        );
        await tester.pump();

        expect(first.hasFocus, restore, reason: 'restoreFocus: $restore');
      }
    });
  });
}
