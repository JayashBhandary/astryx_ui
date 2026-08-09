@Tags(<String>['golden'])
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// Appearance tests for the overlays.
///
/// Every case renders into a **fixed-size surface with the trigger at a known
/// position**, as `P9-8` requires: an overlay's whole appearance is where it
/// ended up, and a golden taken against a floating layout proves nothing.
void main() {
  /// Opens [controller] and lets the entry animation finish.
  Future<void> open(WidgetTester tester, VoidCallback show) async {
    show();
    await tester.pumpAndSettle();
  }

  testWidgets('a popover on each side', (tester) async {
    for (final side in AstryxOverlaySide.values) {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await expectAstryxGolden(
        tester,
        Center(
          child: AstryxPopover(
            controller: controller,
            side: side,
            width: 160,
            showArrow: true,
            content: const AstryxText('Anchored content'),
            triggerBuilder: (context, c) =>
                AstryxButton(label: side.name, onPressed: c.toggle),
          ),
        ),
        name: 'popover.${side.name}',
        surfaceSize: const Size(400, 400),
        beforeCapture: (WidgetTester tester) => open(tester, controller.show),
        // Captured after the animation settles, so the frame is deterministic.
        settle: true,
      );
    }
  });

  testWidgets('a popover that has to flip', (tester) async {
    final controller = AstryxOverlayController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      Align(
        alignment: Alignment.bottomCenter,
        child: AstryxPopover(
          controller: controller,
          width: 200,
          showArrow: true,
          content: const SizedBox(
            height: 120,
            child: AstryxText('No room below'),
          ),
          triggerBuilder: (context, c) =>
              AstryxButton(label: 'Open', onPressed: c.toggle),
        ),
      ),
      name: 'popover.flipped',
      beforeCapture: (WidgetTester tester) => open(tester, controller.show),
      settle: true,
    );
  });

  testWidgets('a popover that has to shift', (tester) async {
    final controller = AstryxOverlayController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        child: AstryxPopover(
          controller: controller,
          width: 240,
          showArrow: true,
          content: const AstryxText('Slid back into view'),
          triggerBuilder: (context, c) =>
              AstryxButton(label: 'Open', onPressed: c.toggle),
        ),
      ),
      name: 'popover.shifted',
      // The shift is toward the leading edge, so RTL mirrors it — a genuinely
      // different image, which is the bar a golden axis has to clear.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      beforeCapture: (WidgetTester tester) => open(tester, controller.show),
      settle: true,
    );
  });

  testWidgets('a tooltip', (tester) async {
    final controller = AstryxOverlayController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      Center(
        child: AstryxTooltip(
          message: 'Archive this conversation',
          showArrow: true,
          waitDuration: Duration.zero,
          child: AstryxButton(label: 'Archive', onPressed: () {}),
        ),
      ),
      name: 'tooltip',
      beforeCapture: (WidgetTester tester) async {
        await tester.longPress(find.text('Archive'));
        await tester.pumpAndSettle();
      },
      settle: true,
    );
  });

  testWidgets('a dropdown menu', (tester) async {
    final controller = AstryxOverlayController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      Align(
        alignment: Alignment.topCenter,
        child: AstryxDropdownMenu(
          controller: controller,
          width: 220,
          entries: <AstryxMenuEntry>[
            const AstryxMenuSection('Manage'),
            AstryxMenuItem(
              label: 'Edit',
              icon: const AstryxIcon(AstryxIconName.wrench),
              onSelected: () {},
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              icon: const AstryxIcon(AstryxIconName.copy),
              enabled: false,
              onSelected: () {},
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Move to',
              submenu: <AstryxMenuEntry>[
                AstryxMenuItem(label: 'Archive', onSelected: () {}),
              ],
            ),
            AstryxMenuItem(
              label: 'Delete',
              icon: const AstryxIcon(AstryxIconName.close),
              destructive: true,
              onSelected: () {},
            ),
          ],
          triggerBuilder: (context, c) =>
              AstryxButton(label: 'Actions', onPressed: c.toggle),
        ),
      ),
      name: 'dropdown_menu',
      surfaceSize: const Size(400, 400),
      // The icon leads and the submenu chevron trails, so both flip.
      directions: const <TextDirection>{
        TextDirection.ltr,
        TextDirection.rtl,
      },
      beforeCapture: (WidgetTester tester) => open(tester, controller.show),
      settle: true,
    );
  });

  testWidgets('a dialog', (tester) async {
    final controller = AstryxDialogController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      AstryxDialog(
        controller: controller,
        title: 'Delete project',
        description: 'This cannot be undone.',
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(label: 'Cancel', onPressed: () {}),
            AstryxButton(
              label: 'Delete',
              variant: AstryxButtonVariant.destructive,
              onPressed: () {},
            ),
          ],
        ),
        child: const AstryxText(
          'Everything in this project will be permanently removed.',
        ),
      ),
      name: 'dialog',
      surfaceSize: const Size(600, 400),
      beforeCapture: (WidgetTester tester) => open(tester, controller.show),
      settle: true,
    );
  });

  testWidgets('the toast stack', (tester) async {
    final controller = AstryxToastController();
    addTearDown(controller.dispose);

    await expectAstryxGolden(
      tester,
      const SizedBox.expand(),
      name: 'toast',
      surfaceSize: const Size(500, 400),
      toastController: controller,
      // Bottom trailing on pointer, bottom leading on touch — the density
      // default this axis exists to prove.
      densities: const <AstryxDensity>{
        AstryxDensity.pointer,
        AstryxDensity.touch,
      },
      beforeCapture: (WidgetTester tester) async {
        controller
          ..clear()
          ..show(
            const AstryxToast(
              message: 'Project archived',
              duration: Duration.zero,
            ),
          )
          ..show(
            const AstryxToast(
              message: 'Could not reach the server',
              type: AstryxToastType.error,
              duration: Duration.zero,
            ),
          );
        await tester.pumpAndSettle();
      },
      settle: true,
    );
  });
}
