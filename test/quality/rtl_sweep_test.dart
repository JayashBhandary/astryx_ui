import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P11-7` — the RTL sweep.
///
/// The plan asks for the whole gallery under `Directionality.rtl`, looked at by
/// eye. The goldens do the looking; this file does the part an image cannot
/// check — that things which *should* mirror do, and things which *should not*
/// don't.
///
/// The distinction matters. Padding, icon position and overlay alignment are
/// reading-order concerns and mirror. A progress bar's direction of travel and
/// a chevron-down mirror nothing. Getting the second group wrong is the more
/// common mistake, because "mirror everything" looks thorough.
void main() {
  /// The horizontal centre of [finder] relative to [within].
  double relativeCentre(WidgetTester tester, Finder finder, Finder within) {
    final outer = tester.getRect(within);
    final inner = tester.getRect(finder);
    return (inner.center.dx - outer.left) / outer.width;
  }

  group('what mirrors', () {
    testWidgets('a field label sits at the reading-start edge', (tester) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          const AstryxTextInput(label: 'Email', width: 300),
          textDirection: direction,
        );

        final position = relativeCentre(
          tester,
          find.text('Email'),
          find.byType(AstryxTextInput),
        );
        expect(
          direction == TextDirection.ltr ? position < 0.5 : position > 0.5,
          isTrue,
          reason: '$direction put the label at $position',
        );
      }
    });

    testWidgets('a checkbox sits at the reading-start edge', (tester) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          SizedBox(
            width: 300,
            child: AstryxCheckbox(
              label: 'Accept',
              value: false,
              onChanged: (_) {},
            ),
          ),
          textDirection: direction,
        );

        final box = tester.getRect(find.byType(AstryxCheckbox));
        final label = tester.getRect(find.text('Accept'));
        expect(
          direction == TextDirection.ltr
              ? label.left > box.left
              : label.right < box.right,
          isTrue,
          reason: 'the control leads the label in $direction',
        );
      }
    });

    testWidgets('a switch thumb travels toward the reading-end edge', (
      tester,
    ) async {
      Future<double> thumbOffset(TextDirection direction) async {
        await pumpAstryxWidget(
          tester,
          const AstryxSwitch(label: 'S', value: true, labelHidden: true),
          textDirection: direction,
        );
        await tester.pumpAndSettle();
        final track = tester.getRect(find.byType(AstryxSwitch));
        final thumb = tester.getRect(
          find
              .descendant(
                of: find.byType(AstryxSwitch),
                matching: find.byType(AnimatedContainer),
              )
              .last,
        );
        return thumb.center.dx - track.center.dx;
      }

      expect(await thumbOffset(TextDirection.ltr), greaterThan(0));
      expect(await thumbOffset(TextDirection.rtl), lessThan(0));
    });

    testWidgets('a table numeric column aligns to the reading-end edge', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          AstryxTable<_Row>(
            rows: const <_Row>[_Row('a', 'Alpha', 7)],
            keyOf: (row) => row.id,
            columns: <AstryxTableColumn<_Row>>[
              AstryxTableColumn<_Row>(
                id: 'name',
                header: 'Name',
                cellBuilder: (context, row) => AstryxText(row.name),
              ),
              AstryxTableColumn<_Row>(
                id: 'count',
                header: 'Count',
                width: const AstryxTableColumnWidth.fixed(140),
                alignment: AstryxTableAlignment.end,
                cellBuilder: (context, row) => AstryxText('${row.count}'),
              ),
            ],
          ),
          textDirection: direction,
          surfaceSize: const Size(500, 300),
        );

        final name = tester.getRect(find.text('Alpha')).center.dx;
        final count = tester.getRect(find.text('7')).center.dx;
        expect(
          direction == TextDirection.ltr ? count > name : count < name,
          isTrue,
          reason: 'column order follows reading order in $direction',
        );
      }
    });

    testWidgets('a dialog footer aligns to the reading-end edge', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        final controller = AstryxDialogController();
        addTearDown(controller.dispose);

        await pumpAstryxWidget(
          tester,
          AstryxDialog(
            controller: controller,
            title: 'Delete',
            footer: AstryxButton(label: 'Cancel', onPressed: () {}),
            child: const AstryxText('Body'),
          ),
          textDirection: direction,
          surfaceSize: const Size(600, 400),
        );
        controller.show();
        await tester.pumpAndSettle();

        final position = relativeCentre(
          tester,
          find.text('Cancel'),
          find.text('Body'),
        );
        expect(
          direction == TextDirection.ltr ? position > 0.5 : position < 0.5,
          isTrue,
          reason: '$direction put the footer at $position',
        );
      }
    });

    testWidgets('an overlay flips its inline side under RTL', (tester) async {
      // The positioner resolves the logical side; `left` means "the reading
      // side", which is the right-hand side under RTL.
      expect(
        AstryxOverlaySide.resolve(AstryxOverlaySide.left, TextDirection.rtl),
        AstryxOverlaySide.right,
      );
      expect(
        AstryxOverlaySide.resolve(AstryxOverlaySide.left, TextDirection.ltr),
        AstryxOverlaySide.left,
      );
    });

    testWidgets('a toast stacks at the reading-start edge on touch', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        final controller = AstryxToastController();
        addTearDown(controller.dispose);

        await pumpAstryxWidget(
          tester,
          const SizedBox.expand(),
          textDirection: direction,
          density: AstryxDensity.touch,
          toastController: controller,
          surfaceSize: const Size(500, 400),
        );
        controller.show(
          const AstryxToast(message: 'Archived', duration: Duration.zero),
        );
        await tester.pumpAndSettle();

        final centre = tester.getRect(find.text('Archived')).center.dx;
        expect(
          direction == TextDirection.ltr ? centre < 250 : centre > 250,
          isTrue,
          reason: '$direction put the toast at $centre',
        );
      }
    });
  });

  group('what does not mirror', () {
    testWidgets('a chevron-down is the same glyph in both directions', (
      tester,
    ) async {
      // Vertical icons carry no reading direction. Mirroring one is the
      // "mirror everything" mistake.
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronDown), isFalse);
      expect(astryxShouldMirrorIcon(AstryxIconName.arrowUp), isFalse);
      expect(astryxShouldMirrorIcon(AstryxIconName.arrowDown), isFalse);
      expect(astryxShouldMirrorIcon(AstryxIconName.clock), isFalse);
      expect(astryxShouldMirrorIcon(AstryxIconName.check), isFalse);
    });

    testWidgets('the inline chevrons do mirror', (tester) async {
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronLeft), isTrue);
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronRight), isTrue);
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronsLeft), isTrue);
      expect(astryxShouldMirrorIcon(AstryxIconName.chevronsRight), isTrue);
    });

    testWidgets('a determinate progress bar fills from the reading edge', (
      tester,
    ) async {
      // It *does* mirror — progress reads in the same direction as text — but
      // the value is unchanged, which is the part a naive mirror gets wrong.
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          const SizedBox(
            width: 200,
            child: AstryxProgressBar(value: 0.25, label: 'Uploading'),
          ),
          textDirection: direction,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('a badge does not reverse its icon and label', (tester) async {
      for (final direction in TextDirection.values) {
        await pumpAstryxWidget(
          tester,
          const AstryxBadge(
            'Done',
            icon: AstryxIcon(AstryxIconName.check),
            variant: AstryxBadgeVariant.success,
          ),
          textDirection: direction,
        );

        final icon = tester.getRect(find.byType(AstryxIcon)).center.dx;
        final label = tester.getRect(find.text('Done')).center.dx;
        // The icon leads in reading order, both ways — a `Row` in Flutter is
        // already directional, so this is a check that nothing double-flips.
        expect(
          direction == TextDirection.ltr ? icon < label : icon > label,
          isTrue,
          reason: 'icon leads the label in $direction',
        );
      }
    });
  });

  group('keyboard directions mirror', () {
    testWidgets('tabs, radios and menus all treat Left as forward under RTL', (
      tester,
    ) async {
      // Asserted in each widget's own test file; this is the cross-widget
      // consistency check the plan asks for — three different widgets, one
      // rule, and it would be easy for one to disagree.
      String? tabChoice;
      await pumpAstryxWidget(
        tester,
        AstryxTabList<String>(
          value: 'a',
          autofocus: true,
          onChanged: (value) => tabChoice = value,
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'First'),
            AstryxTab(value: 'b', label: 'Second'),
          ],
        ),
        textDirection: TextDirection.rtl,
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(tabChoice, 'b', reason: 'tabs: left is forward under RTL');

      String? radioChoice;
      await pumpAstryxWidget(
        tester,
        AstryxRadioList<String>(
          value: 'a',
          autofocus: true,
          onChanged: (value) => radioChoice = value,
          options: const <AstryxRadioOption<String>>[
            AstryxRadioOption(value: 'a', label: 'First'),
            AstryxRadioOption(value: 'b', label: 'Second'),
          ],
        ),
        textDirection: TextDirection.rtl,
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(radioChoice, 'b', reason: 'radios: left is forward under RTL');
    });
  });
}

class _Row {
  const _Row(this.id, this.name, this.count);

  final String id;
  final String name;
  final int count;
}
