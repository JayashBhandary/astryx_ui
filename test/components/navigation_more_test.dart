import 'dart:ui' show CheckedState, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The rest of the navigation set: the link, the segmented control, the
/// toolbar, the overflow menu, the tab menu and pagination.
void main() {
  setUp(AstryxOverlayStack.reset);

  group('AstryxLink', () {
    testWidgets('follows on press, on Enter and through the delegate', (
      tester,
    ) async {
      final followed = <Uri>[];
      var pressed = 0;

      await pumpAstryxWidget(
        tester,
        AstryxLinkScope(
          delegate: AstryxLinkDelegate.fromCallback(
            (uri, {String? target}) => followed.add(uri),
          ),
          child: AstryxLink(
            'Read the guide',
            href: Uri.parse('/guide'),
            onPressed: () => pressed++,
          ),
        ),
      );

      await tester.tap(find.byType(AstryxLink));
      await tester.pump();

      // Both: the callback is the app's, the delegate is the router's, and a
      // link with each does each.
      expect(pressed, 1);
      expect(followed, <Uri>[Uri.parse('/guide')]);
    });

    testWidgets('an external link says so in its name', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxLink('Docs', external: true, onPressed: () {}),
      );

      final node = tester.getSemantics(find.byType(AstryxLink));
      // A user who cannot see the glyph is the one most disrupted by a window
      // they did not expect.
      expect(node.label, 'Docs, opens in a new window');
      expect(node.flagsCollection.isLink, isTrue);
      handle.dispose();
    });

    testWidgets('goes inside a sentence as a span', (tester) async {
      var pressed = 0;
      await pumpAstryxWidget(
        tester,
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'See the '),
              AstryxLink.span('guide', onPressed: () => pressed++),
              const TextSpan(text: ' to begin.'),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      await tester.tap(find.text('guide'));
      await tester.pump();
      expect(pressed, 1);
    });

    testWidgets('a link with nowhere to go is not a control', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, const AstryxLink('Nowhere'));

      final data = tester
          .getSemantics(find.byType(AstryxLink))
          .getSemanticsData();
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });
  });

  group('AstryxSegmentedControl', () {
    Widget build({
      String? value = 'week',
      ValueChanged<String>? onChanged,
      FocusNode? focusNode,
    }) => AstryxSegmentedControl<String>(
      label: 'Range',
      value: value,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: focusNode != null,
      segments: const <AstryxSegment<String>>[
        AstryxSegment(value: 'day', label: 'Day'),
        AstryxSegment(value: 'week', label: 'Week'),
        AstryxSegment(value: 'month', label: 'Month'),
      ],
    );

    testWidgets('announces a radio group, not a set of buttons', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(tester, build(onChanged: (_) {}));

      final node = tester.getSemantics(find.bySemanticsLabel('Week'));
      expect(node.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });

    testWidgets('the whole control is one tab stop', (tester) async {
      await pumpAstryxWidget(tester, build(onChanged: (_) {}));

      final stops = tester
          .widgetList<Focus>(find.byType(Focus))
          .where((focus) => focus.canRequestFocus && !focus.skipTraversal)
          .length;
      expect(stops, 1);
    });

    testWidgets('the arrows move and choose, and wrap', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        build(onChanged: chosen.add, focusNode: node),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(chosen, <String>['month']);

      // Wrapping is what makes it a radio group rather than a list.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(chosen.last, 'day');
    });

    testWidgets('the arrows mirror under RTL', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        build(onChanged: chosen.add, focusNode: node),
        textDirection: TextDirection.rtl,
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(chosen, <String>['day']);
    });

    testWidgets('a null callback leaves it read-only', (tester) async {
      await pumpAstryxWidget(tester, build());

      await tester.tap(find.text('Day'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('AstryxToolbar', () {
    Widget build({FocusNode? first}) => AstryxToolbar(
      label: 'Formatting',
      children: <Widget>[
        AstryxButton(label: 'Bold', focusNode: first, onPressed: () {}),
        AstryxButton(label: 'Italic', onPressed: () {}),
        const AstryxToolbarDivider(),
        AstryxButton(label: 'Link', onPressed: () {}),
      ],
    );

    testWidgets('Tab reaches the toolbar and lands on the first control', (
      tester,
    ) async {
      final before = FocusNode();
      addTearDown(before.dispose);

      await pumpAstryxWidget(
        tester,
        Column(
          children: <Widget>[
            AstryxButton(
              label: 'Before',
              focusNode: before,
              onPressed: () {},
            ),
            build(),
            AstryxButton(label: 'After', onPressed: () {}),
          ],
        ),
        surfaceSize: const Size(600, 400),
      );

      before.requestFocus();
      await tester.pumpAndSettle();
      // `nextFocus` is what the application's Tab shortcut calls; the test
      // harness has no app above it to install that shortcut.
      before.nextFocus();
      await tester.pumpAndSettle();

      // One stop past "Before" lands *inside* the toolbar, on its first
      // control — not on the band itself, which would be a stop that does
      // nothing.
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<AstryxButton>()
            ?.label,
        'Bold',
      );
    });

    testWidgets('the arrows move between the controls, and wrap', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        build(first: node),
        surfaceSize: const Size(600, 200),
      );

      node.requestFocus();
      await tester.pumpAndSettle();

      String? focusedLabel() {
        final context = FocusManager.instance.primaryFocus?.context;
        if (context == null) return null;
        final button = context.findAncestorWidgetOfExactType<AstryxButton>();
        return button?.label;
      }

      expect(focusedLabel(), 'Bold');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(focusedLabel(), 'Italic');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(focusedLabel(), 'Link');

      // Past the end and round: a toolbar the arrows dead-end in is a toolbar
      // people reverse out of.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(focusedLabel(), 'Bold');
    });

    testWidgets('Tab leaves the toolbar rather than walking it', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await pumpAstryxWidget(
        tester,
        Column(
          children: <Widget>[
            build(first: node),
            AstryxButton(label: 'After', onPressed: () {}),
          ],
        ),
        surfaceSize: const Size(600, 400),
      );

      node.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Three controls, one press: the reason the ARIA toolbar pattern exists.
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<AstryxButton>()
            ?.label,
        'After',
      );
    });
  });

  group('AstryxMoreMenu', () {
    testWidgets('one string names the trigger and the menu', (tester) async {
      final handle = tester.ensureSemantics();
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        AstryxMoreMenu(
          label: 'Row actions',
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(label: 'Rename', onSelected: () => chosen.add('r')),
          ],
        ),
        surfaceSize: const Size(400, 400),
      );

      expect(find.bySemanticsLabel('Row actions'), findsOneWidget);

      await tester.tap(find.byType(AstryxIconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();
      expect(chosen, <String>['r']);
      handle.dispose();
    });
  });

  group('AstryxTabMenu', () {
    testWidgets('looks like a tab and announces a menu button', (tester) async {
      final handle = tester.ensureSemantics();
      final chosen = <String>[];

      await pumpAstryxWidget(
        tester,
        AstryxTabMenu(
          label: 'More reports',
          selected: true,
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(label: 'Usage', onSelected: () => chosen.add('u')),
          ],
        ),
        surfaceSize: const Size(400, 400),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('More reports'));
      // Not a tab: telling a screen-reader user this is a tab and then opening
      // a menu is a promise the widget cannot keep.
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isSelected, Tristate.isTrue);

      await tester.tap(find.text('More reports'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Usage'));
      await tester.pumpAndSettle();
      expect(chosen, <String>['u']);
      handle.dispose();
    });
  });

  group('AstryxPagination', () {
    test('the page list keeps the ends and gaps the middle', () {
      List<int?> pages(int page, int count) =>
          AstryxPagination.pagesFor(page: page, pageCount: count);

      expect(pages(1, 5), <int?>[1, 2, null, 5]);
      expect(pages(10, 20), <int?>[1, null, 9, 10, 11, null, 20]);
      // A gap of one page is drawn as the page: "1 … 3" hides nothing and
      // costs a press.
      expect(pages(3, 5), <int?>[1, 2, 3, 4, 5]);
      expect(pages(1, 1), <int?>[1]);
    });

    testWidgets('the ends disable rather than disappear', (tester) async {
      final pages = <int>[];
      await pumpAstryxWidget(
        tester,
        AstryxPagination(page: 1, pageCount: 9, onPageChanged: pages.add),
        surfaceSize: const Size(600, 200),
      );

      final previous = tester.widget<AstryxIconButton>(
        find.byType(AstryxIconButton).first,
      );
      expect(previous.enabled, isFalse);

      await tester.tap(find.text('2'));
      await tester.pump();
      expect(pages, <int>[2]);
    });

    testWidgets('it says where the reader is', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxPagination(page: 3, pageCount: 20, onPageChanged: (_) {}),
        surfaceSize: const Size(600, 200),
      );

      expect(
        tester.getSemantics(find.byType(AstryxPagination)).value,
        'Page 3 of 20',
      );
      handle.dispose();
    });

    testWidgets('one page needs no controls', (tester) async {
      await pumpAstryxWidget(
        tester,
        const AstryxPagination(page: 1, pageCount: 1),
      );

      expect(find.byType(AstryxButton), findsNothing);
    });
  });
}
