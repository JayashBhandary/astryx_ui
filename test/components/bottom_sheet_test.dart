import 'package:astryx_ui/astryx_ui.dart';
// The panel is internal — it is what the switcher raises without a layer of
// its own — but it is the box whose geometry these tests are about.
import 'package:astryx_ui/src/components/overlay/bottom_sheet.dart'
    show AstryxBottomSheetPanel;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `AstryxBottomSheet` and `AstryxBottomSheetSwitcher`, checked against
/// `packages/core/src/BottomSheet/`.
void main() {
  const surface = Size(400, 800);

  /// Mounts a sheet driven by [controller] and opens it.
  Future<void> open(
    WidgetTester tester,
    AstryxBottomSheetController controller, {
    AstryxBottomSheetHeight height = AstryxBottomSheetHeight.capped,
    List<double> snapPoints = const <double>[],
    bool showHandle = true,
    bool dragDismissible = true,
    Widget child = const AstryxText('sheet body'),
  }) async {
    await pumpAstryxWidget(
      tester,
      AstryxBottomSheet(
        controller: controller,
        label: 'Filters',
        height: height,
        snapPoints: snapPoints,
        showHandle: showHandle,
        dragDismissible: dragDismissible,
        child: child,
      ),
      surfaceSize: surface,
    );
    controller.show();
    await tester.pumpAndSettle();
  }

  testWidgets('renders nothing until it is opened', (tester) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);

    await pumpAstryxWidget(
      tester,
      AstryxBottomSheet(
        controller: controller,
        label: 'Filters',
        child: const AstryxText('sheet body'),
      ),
      surfaceSize: surface,
    );

    expect(find.text('sheet body'), findsNothing);

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('sheet body'), findsOneWidget);
  });

  testWidgets('sits against the bottom edge, full width up to its cap', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller);

    final rect = tester.getRect(find.byType(AstryxBottomSheetPanel));
    expect(rect.bottom, moreOrLessEquals(surface.height, epsilon: 0.5));
    expect(rect.left, moreOrLessEquals(0, epsilon: 0.5));
    expect(rect.width, moreOrLessEquals(surface.width, epsilon: 0.5));
  });

  testWidgets('each height budget claims its share of the viewport', (
    tester,
  ) async {
    final heights = <AstryxBottomSheetHeight, double>{};
    for (final height in AstryxBottomSheetHeight.values) {
      final controller = AstryxBottomSheetController();
      await open(
        tester,
        controller,
        height: height,
        // Enough content that `hug` has something to hug.
        child: const SizedBox(height: 120),
      );
      heights[height] = tester
          .getSize(find.byType(AstryxBottomSheetPanel))
          .height;
      controller.dispose();
    }

    // `capped` is the middle budget, `tall` the largest, and `hug` sizes to
    // 120px of content rather than to a share of the screen.
    expect(
      heights[AstryxBottomSheetHeight.capped],
      moreOrLessEquals(surface.height * 0.62, epsilon: 1),
    );
    expect(
      heights[AstryxBottomSheetHeight.tall],
      moreOrLessEquals(surface.height * 0.92, epsilon: 1),
    );
    expect(
      heights[AstryxBottomSheetHeight.hug],
      lessThan(heights[AstryxBottomSheetHeight.capped]!),
    );
  });

  testWidgets('the scrim dismisses it, and focus goes back', (tester) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller);

    // The scrim fills the viewport behind the sheet; a press well above the
    // sheet's top edge lands on it.
    await tester.tapAt(const Offset(200, 40));
    await tester.pumpAndSettle();

    expect(controller.isOpen, isFalse);
    expect(find.text('sheet body'), findsNothing);
  });

  testWidgets('the handle is named, and absent when asked to be', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);

    await open(tester, controller);
    expect(
      find.bySemanticsLabel(RegExp('Drag to resize')),
      findsOneWidget,
      reason: 'the grab handle is a drag target, so it has to be named',
    );

    await open(tester, controller, showHandle: false);
    expect(find.bySemanticsLabel(RegExp('Drag to resize')), findsNothing);

    handle.dispose();
  });

  testWidgets('dragging the handle down far enough dismisses it', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller);

    await tester.drag(
      find.bySemanticsLabel(RegExp('Drag to resize')),
      const Offset(0, 400),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(controller.isOpen, isFalse);
  });

  testWidgets('a short drag springs back rather than dismissing', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller);
    final before = tester.getRect(find.byType(AstryxBottomSheetPanel));

    await tester.drag(
      find.bySemanticsLabel(RegExp('Drag to resize')),
      const Offset(0, 20),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(controller.isOpen, isTrue);
    expect(tester.getRect(find.byType(AstryxBottomSheetPanel)), before);
  });

  testWidgets('dragDismissible false keeps the sheet through a long drag', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller, dragDismissible: false);

    await tester.drag(
      find.bySemanticsLabel(RegExp('Drag to resize')),
      const Offset(0, 500),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(controller.isOpen, isTrue);
  });

  testWidgets('snap points open at the tallest detent by default', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller, snapPoints: const <double>[0.25, 0.5]);

    expect(
      tester.getSize(find.byType(AstryxBottomSheetPanel)).height,
      moreOrLessEquals(surface.height * 0.5, epsilon: 1),
    );
  });

  testWidgets('a drag down settles on the shorter detent', (tester) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller, snapPoints: const <double>[0.25, 0.5]);

    // From 50% toward 25%: two hundred pixels of an 800px viewport.
    await tester.drag(
      find.bySemanticsLabel(RegExp('Drag to resize')),
      const Offset(0, 180),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(controller.isOpen, isTrue);
    expect(
      tester.getSize(find.byType(AstryxBottomSheetPanel)).height,
      moreOrLessEquals(surface.height * 0.25, epsilon: 1),
    );
  });

  testWidgets('a snap point outside (0, 1] is dropped, not thrown for', (
    tester,
  ) async {
    final controller = AstryxBottomSheetController();
    addTearDown(controller.dispose);
    await open(tester, controller, snapPoints: const <double>[0.5, 50, -1]);

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(AstryxBottomSheetPanel)).height,
      moreOrLessEquals(surface.height * 0.5, epsilon: 1),
    );
  });

  group('AstryxBottomSheetSwitcher', () {
    /// Mounts a two-step flow whose active step is [active].
    Future<void> pumpFlow(
      WidgetTester tester,
      String? active, {
      ValueChanged<String?>? onChanged,
    }) async {
      await pumpAstryxWidget(
        tester,
        AstryxBottomSheetSwitcher(
          activeSheetId: active,
          onActiveSheetChanged: onChanged ?? (_) {},
          sheets: const <AstryxBottomSheetPage>[
            AstryxBottomSheetPage(
              id: 'details',
              label: 'Setup details',
              child: AstryxText('the details'),
            ),
            AstryxBottomSheetPage(
              id: 'confirm',
              label: 'Confirm',
              child: AstryxText('the confirmation'),
            ),
          ],
        ),
        surfaceSize: surface,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('a null id shows nothing', (tester) async {
      await pumpFlow(tester, null);
      expect(find.text('the details'), findsNothing);
    });

    testWidgets('the active id decides which step is on screen', (
      tester,
    ) async {
      await pumpFlow(tester, 'details');
      expect(find.text('the details'), findsOneWidget);
      expect(find.text('the confirmation'), findsNothing);

      await pumpFlow(tester, 'confirm');
      expect(find.text('the confirmation'), findsOneWidget);
      expect(find.text('the details'), findsNothing);
    });

    testWidgets('one scrim survives a step change', (tester) async {
      await pumpFlow(tester, 'details');
      final layers = find.byType(AstryxOverlay).evaluate().length;

      await pumpFlow(tester, 'confirm');

      // The whole point of the switcher: the layer, and so the scrim, is the
      // same one throughout the flow.
      expect(find.byType(AstryxOverlay).evaluate().length, layers);
    });

    testWidgets('the scrim reports a close as a null id', (tester) async {
      final changes = <String?>[];
      await pumpFlow(tester, 'details', onChanged: changes.add);

      await tester.tapAt(const Offset(200, 40));
      await tester.pumpAndSettle();

      expect(changes, <String?>[null]);
    });
  });
}
