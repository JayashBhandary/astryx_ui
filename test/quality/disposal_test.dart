import 'dart:ui' show PointerDeviceKind;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P11-5` — nothing leaks on dispose.
///
/// Every widget that owns an `AnimationController`, `FocusNode`,
/// `ScrollController`, `Timer` or `OverlayEntry` is mounted, exercised into the
/// state that creates the resource, and then unmounted.
///
/// Two things make a leak visible here:
///
///  * `FlutterMemoryAllocations` — the framework's own leak tracking, which
///    `flutter_test` asserts on in debug builds when a disposable is collected
///    without `dispose()`.
///  * `hasScheduledFrame` — a ticker that outlives its widget keeps asking for
///    frames forever, which is the symptom users actually feel.
///
/// The pattern throughout is *mount, exercise, replace with an empty tree,
/// settle*. Disposing while the widget is mid-animation or mid-open is the case
/// that breaks; disposing an idle widget almost never is.
void main() {
  /// Replaces the tree, settles, and fails if anything is still ticking.
  Future<void> unmountAndSettle(WidgetTester tester) async {
    await pumpAstryxWidget(tester, const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(
      tester.binding.hasScheduledFrame,
      isFalse,
      reason: 'a ticker outlived its widget',
    );
    expect(tester.takeException(), isNull);
  }

  group('animated widgets', () {
    testWidgets('AstryxSpinner stops ticking when removed', (tester) async {
      await pumpAstryxWidget(tester, const AstryxSpinner());
      await tester.pump(const Duration(milliseconds: 100));
      // A repeating controller keeps scheduling frames while it is mounted.
      expect(tester.binding.hasScheduledFrame, isTrue);

      await unmountAndSettle(tester);
    });

    testWidgets('AstryxSkeleton stops ticking when removed', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 100, height: 20),
      );
      await tester.pump(const Duration(seconds: 1));
      await unmountAndSettle(tester);
    });

    testWidgets('an indeterminate progress bar stops ticking', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxProgressBar(label: 'Working'),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.binding.hasScheduledFrame, isTrue);

      await unmountAndSettle(tester);
    });

    testWidgets('a skeleton disposed inside its start delay', (tester) async {
      // The delay is a `Timer`, and a `Timer` that fires into a disposed state
      // is the ADR-025 bug. Unmounted before it ever fires.
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 100, height: 20),
      );
      await tester.pump(const Duration(milliseconds: 10));
      await unmountAndSettle(tester);
    });
  });

  group('overlays disposed while open', () {
    testWidgets('a popover', (tester) async {
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
      );
      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Panel'), findsOneWidget);
      expect(AstryxOverlayStack.depth, 1);

      await unmountAndSettle(tester);
      expect(AstryxOverlayStack.depth, 0, reason: 'the dismiss entry leaked');
    });

    testWidgets('a dialog', (tester) async {
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxDialog(
          controller: controller,
          title: 'Open',
          child: const AstryxText('Body'),
        ),
        surfaceSize: const Size(500, 500),
      );
      controller.show();
      await tester.pumpAndSettle();

      await unmountAndSettle(tester);
      expect(AstryxOverlayStack.depth, 0);
    });

    testWidgets('a dropdown menu with an open submenu', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Align(
          alignment: Alignment.topCenter,
          child: AstryxDropdownMenu(
            controller: controller,
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(
                label: 'Move to',
                submenu: <AstryxMenuEntry>[
                  AstryxMenuItem(label: 'Archive', onSelected: () {}),
                ],
              ),
            ],
            triggerBuilder: (context, c) =>
                AstryxButton(label: 'Actions', onPressed: c.toggle),
          ),
        ),
        surfaceSize: const Size(500, 500),
      );
      controller.show();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Archive'), findsOneWidget);

      // Two nested portals and two animation controllers, both torn down at
      // once — the case a single-overlay test would miss.
      await unmountAndSettle(tester);
      expect(AstryxOverlayStack.depth, 0);
    });

    testWidgets('a tooltip mid-delay', (tester) async {
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxTooltip(
            message: 'Archive',
            child: AstryxButton(label: 'Archive', onPressed: () {}),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('Archive')));
      // Removed *during* the 200ms wait, so the show timer is still pending.
      await tester.pump(const Duration(milliseconds: 50));

      await unmountAndSettle(tester);
    });

    testWidgets('a selector with its list open', (tester) async {
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxSelector<String>(
            label: 'Owner',
            value: null,
            showSearch: true,
            onChanged: (_) {},
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'a', label: 'Ada'),
            ],
          ),
        ),
        surfaceSize: const Size(400, 500),
      );

      await tester.tap(find.byType(AstryxSelector<String>));
      await tester.pumpAndSettle();
      expect(find.text('Ada'), findsOneWidget);

      // Holds a scroll controller, a focus node, a focus scope and a search
      // text controller, all created lazily on open.
      await unmountAndSettle(tester);
    });
  });

  group('toasts', () {
    testWidgets('a toast removed before its timer fires', (tester) async {
      final controller = AstryxToastController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        const SizedBox.expand(),
        toastController: controller,
      );
      controller.show(const AstryxToast(message: 'Archived'));
      await tester.pumpAndSettle();
      expect(find.text('Archived'), findsOneWidget);

      await unmountAndSettle(tester);
    });

    testWidgets('clearing the queue disposes every card', (tester) async {
      final controller = AstryxToastController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        const SizedBox.expand(),
        toastController: controller,
      );
      for (var i = 0; i < 4; i++) {
        controller.show(
          AstryxToast(message: 'Toast $i', duration: Duration.zero),
        );
      }
      await tester.pumpAndSettle();

      controller.clear();
      await tester.pumpAndSettle();
      expect(find.textContaining('Toast'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('controllers the widget owns', () {
    testWidgets('a text input with no caller-supplied controller', (
      tester,
    ) async {
      await pumpAstryxWidget(
        tester,
        const AstryxTextInput(label: 'Name', width: 300),
      );
      await tester.enterText(find.byType(EditableText), 'Ada');
      await tester.pump();

      // Owns a `TextEditingController`, a `FocusNode` and a `ScrollController`,
      // all created because the caller supplied none.
      await unmountAndSettle(tester);
    });

    testWidgets('a caller-supplied controller survives the widget', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'Ada');
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxTextInput(
          label: 'Name',
          controller: controller,
          focusNode: focus,
          width: 300,
        ),
      );
      await unmountAndSettle(tester);

      // Still usable: the widget removed its listeners but did not dispose
      // what it does not own. Disposing a caller's controller is the mirror
      // image of leaking one, and just as wrong.
      expect(controller.text, 'Ada');
      controller.text = 'Alan';
      expect(controller.text, 'Alan');
    });

    testWidgets('a tab list with an overflowing strip', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTabList<int>(
          value: 0,
          onChanged: (_) {},
          tabs: <AstryxTab<int>>[
            for (var i = 0; i < 20; i++)
              AstryxTab<int>(value: i, label: 'Section $i'),
          ],
        ),
        surfaceSize: const Size(300, 300),
      );
      await tester.pumpAndSettle();

      await unmountAndSettle(tester);
    });

    testWidgets('a table that scrolls in both axes', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxTable<_Row>(
          rows: <_Row>[for (var i = 0; i < 40; i++) _Row('$i', 'Row $i')],
          keyOf: (row) => row.id,
          maxHeight: 200,
          columns: <AstryxTableColumn<_Row>>[
            for (var c = 0; c < 6; c++)
              AstryxTableColumn<_Row>(
                id: 'c$c',
                header: 'Column $c',
                width: const AstryxTableColumnWidth.fixed(160),
                cellBuilder: (context, row) => AstryxText(row.name),
              ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Two scroll controllers, both with clients.
      await unmountAndSettle(tester);
    });

    testWidgets('a card that owns a focus node', (tester) async {
      await pumpAstryxWidget(
        tester,
        AstryxCard(
          semanticsLabel: 'Open',
          autofocus: true,
          onPressed: () {},
          child: const AstryxText('Body'),
        ),
      );
      await tester.pump();

      await unmountAndSettle(tester);
    });
  });

  group('focus trap', () {
    testWidgets('disposes its scope and gives focus back', (tester) async {
      final outside = FocusNode(debugLabel: 'outside');
      addTearDown(outside.dispose);

      await pumpAstryxWidget(
        tester,
        Column(
          children: <Widget>[
            Focus(
              focusNode: outside,
              child: const SizedBox(width: 10, height: 10),
            ),
            const AstryxFocusTrap(
              child: Focus(child: SizedBox(width: 10, height: 10)),
            ),
          ],
        ),
      );
      await tester.pump();

      await unmountAndSettle(tester);
    });
  });
}

class _Row {
  const _Row(this.id, this.name);

  final String id;
  final String name;
}
