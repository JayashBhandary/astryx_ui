import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P11-1` — usable at 200% text scale.
///
/// The phase plan predicts this will break: *"Astryx's base font size is 14 px
/// and its control heights are 28–36 px; at 200% scale those layouts will break
/// somewhere. Find where, and fix it, before users do."*
///
/// Every case here renders a widget at `textScaleFactor: 2` and fails on a
/// render overflow. An overflow is not cosmetic — Flutter clips the content, so
/// the text a user enlarged the type to read is the text that disappears.
void main() {
  /// Renders [child] at 200% and fails if anything overflowed.
  Future<void> expectNoOverflow(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(400, 800),
    AstryxDensity density = AstryxDensity.pointer,
  }) async {
    await pumpAstryxWidget(
      tester,
      child,
      textScaleFactor: 2,
      surfaceSize: size,
      density: density,
    );
    await tester.pumpAndSettle();

    final error = tester.takeException();
    expect(
      error,
      isNull,
      reason: 'overflowed at 200% text scale: $error',
    );
  }

  group('layout and typography', () {
    testWidgets('text wraps rather than overflowing', (tester) async {
      await expectNoOverflow(
        tester,
        const SizedBox(
          width: 200,
          child: AstryxText(
            'A sentence long enough to need more than one line at 200%.',
          ),
        ),
      );
    });

    testWidgets('a heading in a narrow column', (tester) async {
      await expectNoOverflow(
        tester,
        const SizedBox(
          width: 180,
          child: AstryxHeading('Quarterly usage report'),
        ),
      );
    });
  });

  group('actions', () {
    testWidgets('every button size and variant', (tester) async {
      for (final size in AstryxButtonSize.values) {
        await expectNoOverflow(
          tester,
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              for (final variant in AstryxButtonVariant.values)
                AstryxButton(
                  label: variant.name,
                  variant: variant,
                  size: size,
                  onPressed: () {},
                ),
            ],
          ),
        );
      }
    });

    testWidgets('a button whose label is longer than its box', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 140,
          child: AstryxButton(
            label: 'Export everything as CSV',
            onPressed: () {},
          ),
        ),
      );
    });

    testWidgets('an icon button, which has no text to grow', (tester) async {
      await expectNoOverflow(
        tester,
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: 'Close',
          onPressed: () {},
        ),
      );
    });
  });

  group('forms', () {
    testWidgets('a text input with a label, description and error', (
      tester,
    ) async {
      await expectNoOverflow(
        tester,
        const AstryxTextInput(
          label: 'Email address',
          description: 'We only use this to sign you in.',
          status: AstryxFieldStatus.error('That address is not valid'),
          placeholder: 'you@example.com',
          width: 320,
        ),
      );
    });

    testWidgets('every input size', (tester) async {
      for (final size in AstryxInputSize.values) {
        await expectNoOverflow(
          tester,
          AstryxTextInput(label: size.name, size: size, width: 300),
        );
      }
    });

    testWidgets('a checkbox with a description', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 260,
          child: AstryxCheckbox(
            label: 'Accept the terms of service',
            description: 'You can withdraw consent at any time.',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );
    });

    testWidgets('a switch in a spread row', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 300,
          child: AstryxSwitch(
            label: 'Email notifications about absolutely everything',
            value: true,
            labelPosition: AstryxToggleLabelPosition.start,
            labelSpacing: AstryxToggleLabelSpacing.spread,
            onChanged: (_) {},
          ),
        ),
      );
    });

    testWidgets('a radio group with descriptions', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 300,
          child: AstryxRadioList<String>(
            label: 'Plan',
            value: 'pro',
            onChanged: (_) {},
            options: const <AstryxRadioOption<String>>[
              AstryxRadioOption(
                value: 'free',
                label: 'Free',
                description: 'One project, community support only.',
              ),
              AstryxRadioOption(value: 'pro', label: 'Pro'),
            ],
          ),
        ),
      );
    });

    testWidgets('a selector with a long value', (tester) async {
      await expectNoOverflow(
        tester,
        AstryxSelector<String>(
          label: 'Owner',
          value: 'k',
          width: 260,
          showClear: true,
          onChanged: (_) {},
          options: const <AstryxSelectorEntry<String>>[
            AstryxSelectorOption(
              value: 'k',
              label: 'Katherine Johnson, Engineering',
            ),
          ],
        ),
      );
    });
  });

  group('status', () {
    testWidgets('a progress bar with a label', (tester) async {
      await expectNoOverflow(
        tester,
        const SizedBox(
          width: 280,
          child: AstryxProgressBar(value: 0.4, label: 'Uploading files'),
        ),
      );
    });
  });

  group('surfaces', () {
    testWidgets('a card with all three slots', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 280,
          child: AstryxCard(
            header: const AstryxHeading(
              'Usage',
              type: AstryxHeadingType.display3,
            ),
            footer: AstryxButton(label: 'See details', onPressed: () {}),
            child: const AstryxText('4,201 requests this month.'),
          ),
        ),
      );
    });

    testWidgets('a badge grows vertically instead of clipping', (tester) async {
      // `--spacing-5` is 20px and the label scales to 28px. A fixed height
      // would clip the text; a minimum height grows with it (ADR-042).
      await expectNoOverflow(
        tester,
        const AstryxBadge('Active', variant: AstryxBadgeVariant.success),
      );

      final height = tester.getSize(find.byType(AstryxBadge)).height;
      expect(
        height,
        greaterThan(20),
        reason: 'the pill grew to fit its enlarged label',
      );
    });

    testWidgets('a badge in a too-narrow box ellipsises', (tester) async {
      await expectNoOverflow(
        tester,
        const SizedBox(width: 100, child: AstryxBadge('Engineering')),
      );
    });

    testWidgets('a wrapping row of badges', (tester) async {
      // A plain `AstryxHStack` of badges *should* overflow when they do not
      // fit — that is what a `Row` does, and `wrap: true` is the opt-in.
      await expectNoOverflow(
        tester,
        const AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          children: <Widget>[
            AstryxBadge('Active', variant: AstryxBadgeVariant.success),
            AstryxBadge('Engineering'),
          ],
        ),
      );
    });

    testWidgets('a banner with actions and a dismiss button', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 380,
          child: AstryxBanner(
            status: AstryxBannerStatus.error,
            title: 'Could not save your changes',
            description: 'The server rejected three of the fields.',
            actions: <Widget>[
              AstryxButton(
                label: 'Retry',
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
            onDismiss: () {},
          ),
        ),
      );
    });
  });

  group('data', () {
    testWidgets('tabs at every size', (tester) async {
      for (final size in AstryxTabSize.values) {
        await expectNoOverflow(
          tester,
          AstryxTabList<String>(
            size: size,
            value: 'a',
            onChanged: (_) {},
            tabs: const <AstryxTab<String>>[
              AstryxTab(value: 'a', label: 'Overview'),
              AstryxTab(value: 'b', label: 'Activity'),
            ],
          ),
        );
      }
    });

    testWidgets('a table at every density', (tester) async {
      for (final density in AstryxTableDensity.values) {
        await expectNoOverflow(
          tester,
          AstryxTable<_Row>(
            density: density,
            rows: const <_Row>[_Row('a', 'Alpha'), _Row('b', 'Bravo')],
            keyOf: (row) => row.id,
            selectionMode: AstryxTableSelectionMode.multiple,
            onSelectionChanged: (_) {},
            columns: <AstryxTableColumn<_Row>>[
              AstryxTableColumn<_Row>(
                id: 'name',
                header: 'Name',
                cellBuilder: (context, row) => AstryxText(row.name),
              ),
            ],
          ),
          size: const Size(500, 800),
        );
      }
    });
  });

  group('overlays', () {
    testWidgets('a tooltip wraps its message', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxTooltip(
            message: 'Archive this conversation and everything in it',
            waitDuration: Duration.zero,
            child: AstryxButton(label: 'Archive', onPressed: () {}),
          ),
        ),
        textScaleFactor: 2,
        surfaceSize: const Size(400, 500),
      );

      await tester.longPress(find.byType(AstryxButton));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a dialog with a long title and a footer', (tester) async {
      final controller = AstryxDialogController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        AstryxDialog(
          controller: controller,
          title: 'Delete this project permanently',
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
          child: const AstryxText('Everything will be removed.'),
        ),
        textScaleFactor: 2,
        surfaceSize: const Size(500, 700),
      );
      controller.show();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a dropdown menu item with a description', (tester) async {
      final controller = AstryxOverlayController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        Align(
          alignment: Alignment.topCenter,
          child: AstryxDropdownMenu(
            controller: controller,
            width: 240,
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(
                label: 'Duplicate this project',
                description: 'Requires the Editor role',
                onSelected: () {},
              ),
            ],
            triggerBuilder: (context, c) =>
                AstryxButton(label: 'Actions', onPressed: c.toggle),
          ),
        ),
        textScaleFactor: 2,
        surfaceSize: const Size(400, 600),
      );
      controller.show();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a toast with an action', (tester) async {
      final controller = AstryxToastController();
      addTearDown(controller.dispose);

      await pumpAstryxWidget(
        tester,
        const SizedBox.expand(),
        textScaleFactor: 2,
        surfaceSize: const Size(420, 600),
        toastController: controller,
      );
      controller.show(
        const AstryxToast(
          message: 'Your project was archived successfully',
          duration: Duration.zero,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('touch density at 200%', () {
    testWidgets('the toggles still fit', (tester) async {
      await expectNoOverflow(
        tester,
        SizedBox(
          width: 320,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxCheckbox(
                label: 'Accept the terms',
                value: false,
                onChanged: (_) {},
              ),
              AstryxSwitch(
                label: 'Notifications',
                value: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        density: AstryxDensity.touch,
      );
    });
  });
}

class _Row {
  const _Row(this.id, this.name);

  final String id;
  final String name;
}
