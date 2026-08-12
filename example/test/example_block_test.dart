/// The device picker on an example.
///
/// Every responsive decision in this package comes from a `LayoutBuilder`
/// reading its constraints, so a reader can only judge one by making the
/// constraints smaller. These check that the control does that, that it is
/// offered where it makes a difference, and that it is not offered where it
/// makes none.
library;

import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_shell.dart';
import 'package:example/docs_ui/example_block.dart';
import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  /// Pumps the docs at [size] and opens the page with [pageId].
  Future<void> pumpPage(
    WidgetTester tester,
    String pageId, {
    Size size = const Size(1400, 1000),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DocsApp());
    await tester.pumpAndSettle();

    DocsScope.of(tester.element(find.byType(DocsShell))).pageId = pageId;
    await tester.pumpAndSettle();
  }

  /// The width of the first example's preview area.
  double frameWidth(WidgetTester tester) =>
      tester.getSize(find.byKey(docsPreviewFrameKey).first).width;

  /// What `DocsPreviewWidth.mobile` pins to.
  final mobileWidth = DocsPreviewWidth.mobile.width!;

  /// The picker is icon-only, so it is found by its glyphs.
  final desktop = find.byIcon(LucideIcons.monitor);
  final mobile = find.byIcon(LucideIcons.smartphone);

  testWidgets('a preview starts at the full width of the page', (tester) async {
    await pumpPage(tester, 'card');

    expect(desktop, findsWidgets);
    expect(frameWidth(tester), greaterThan(mobileWidth));
  });

  testWidgets('choosing Mobile pins the preview to a phone width', (
    tester,
  ) async {
    await pumpPage(tester, 'card');

    await tester.tap(mobile.first);
    await tester.pumpAndSettle();

    expect(frameWidth(tester), mobileWidth);
  });

  testWidgets('the picker belongs to the preview, not to the code', (
    tester,
  ) async {
    await pumpPage(tester, 'card');
    expect(mobile, findsWidgets);

    // Every example on the page has a Code tab; switching the first one is
    // enough for its own picker to go, and the rest keep theirs.
    final before = mobile.evaluate().length;
    await tester.tap(find.text('Code').first);
    await tester.pumpAndSettle();

    expect(mobile.evaluate().length, before - 1);
  });

  testWidgets('a viewport already at phone width is not offered the picker', (
    tester,
  ) async {
    await pumpPage(tester, 'card', size: const Size(420, 1400));

    expect(mobile, findsNothing);
    expect(desktop, findsNothing);
    // The preview is still there — only the choice is gone.
    expect(find.byKey(docsPreviewFrameKey), findsWidgets);
  });

  testWidgets('an icon-only picker still says what it is', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester, 'card');

    // Nothing here is written on screen, so all of it has to be in the
    // semantics: the group's name, and each glyph's own.
    expect(
      find.bySemanticsLabel(RegExp('Preview width')),
      findsWidgets,
      reason: 'the group needs a name, or the glyphs are buttons about nothing',
    );
    expect(find.bySemanticsLabel('Desktop'), findsWidgets);
    expect(find.bySemanticsLabel('Mobile'), findsWidgets);

    handle.dispose();
  });

  testWidgets('the choice is made once, for every example on the page', (
    tester,
  ) async {
    await pumpPage(tester, 'card');
    final frames = find.byKey(docsPreviewFrameKey);
    expect(
      frames.evaluate().length,
      greaterThan(1),
      reason: 'need two to tell',
    );

    await tester.tap(mobile.first);
    await tester.pumpAndSettle();

    for (final frame in frames.evaluate()) {
      expect(
        tester.getSize(find.byElementPredicate((e) => e == frame)).width,
        mobileWidth,
      );
    }
  });

  testWidgets('the choice survives navigating to another page', (tester) async {
    await pumpPage(tester, 'card');
    await tester.tap(mobile.first);
    await tester.pumpAndSettle();

    DocsScope.of(tester.element(find.byType(DocsShell))).pageId = 'button';
    await tester.pumpAndSettle();

    expect(frameWidth(tester), mobileWidth);
  });

  testWidgets('a frame narrowed after the fact does not overflow', (
    tester,
  ) async {
    await pumpPage(tester, 'card');
    await tester.tap(mobile.first);
    await tester.pumpAndSettle();
    expect(frameWidth(tester), mobileWidth);

    // The picker is gone at this width, but the choice already made is not:
    // the frame has to give way rather than overflow the page.
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(frameWidth(tester), lessThan(mobileWidth));
  });

  test('a group centres all of its examples, or none of them', () {
    // The alignment belongs to the group rather than to the example: a reader
    // scrolls a group, and one preview centred between two left-aligned ones
    // reads as a mistake whatever the reason for it. `center` is also the
    // default, so an omitted `align:` is how the rule gets broken by accident.
    const centred = <String>{
      DocGroup.actions,
      DocGroup.overlays,
      DocGroup.status,
    };

    final wrong = <String>[];
    for (final page in docPages) {
      for (final block in page.blocks) {
        if (block is! DocExample) continue;
        final isCentred = block.align == DocExampleAlign.center;
        if (isCentred != centred.contains(page.group)) {
          wrong.add(
            '${page.id}/${block.snippetId}: ${block.align.name} in '
            '"${page.group}"',
          );
        }
      }
    }

    expect(
      wrong,
      isEmpty,
      reason:
          'Actions, Overlays and Status centre their examples — every example '
          'in them is a single control with no natural edge. Every other group '
          'aligns to the reading start, with `start` or `stretch`:\n'
          '${wrong.join('\n')}',
    );
  });
}
