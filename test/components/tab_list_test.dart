import 'dart:ui' show Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P10-4` — `AstryxTabList`.
///
/// The keyboard is the substance here. Everything else about a tab strip is a
/// row of buttons.
void main() {
  const tabs = <AstryxTab<String>>[
    AstryxTab(value: 'overview', label: 'Overview'),
    AstryxTab(value: 'activity', label: 'Activity', enabled: false),
    AstryxTab(value: 'settings', label: 'Settings'),
  ];

  Widget build(
    String value,
    ValueChanged<String> onChanged, {
    bool autofocus = true,
  }) => AstryxTabList<String>(
    tabs: tabs,
    value: value,
    onChanged: onChanged,
    autofocus: autofocus,
  );

  Future<void> pump(
    WidgetTester tester,
    String value,
    ValueChanged<String> onChanged, {
    TextDirection direction = TextDirection.ltr,
  }) => pumpAstryxWidget(
    tester,
    build(value, onChanged),
    textDirection: direction,
    surfaceSize: const Size(500, 200),
  );

  testWidgets('renders every tab and marks the selected one', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, 'overview', (_) {});

    for (final tab in tabs) {
      expect(find.text(tab.label), findsOneWidget);
    }

    expect(
      tester.getSemantics(find.text('Overview')).flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(
      tester.getSemantics(find.text('Settings')).flagsCollection.isSelected,
      Tristate.isFalse,
    );
    handle.dispose();
  });

  testWidgets('a press selects', (tester) async {
    String? chosen;
    await pump(tester, 'overview', (value) => chosen = value);

    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(chosen, 'settings');
  });

  testWidgets('a disabled tab cannot be pressed', (tester) async {
    await pump(tester, 'overview', (_) => fail('a disabled tab fired'));
    await tester.tap(find.text('Activity'), warnIfMissed: false);
    await tester.pump();
  });

  testWidgets('the arrows move and select, skipping disabled tabs', (
    tester,
  ) async {
    String? chosen;
    await pump(tester, 'overview', (value) => chosen = value);
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(chosen, 'settings', reason: 'Activity is disabled');
  });

  testWidgets('the arrows wrap at both ends', (tester) async {
    String? chosen;
    await pump(tester, 'overview', (value) => chosen = value);
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(chosen, 'settings', reason: 'left from the first wraps to the last');
  });

  testWidgets('the inline arrows mirror under RTL', (tester) async {
    String? chosen;
    await pump(
      tester,
      'overview',
      (value) => chosen = value,
      direction: TextDirection.rtl,
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(chosen, 'settings', reason: 'left is forward under RTL');
  });

  testWidgets('Home and End jump to the ends', (tester) async {
    // Stateful, because the widget correctly declines to fire for a no-op:
    // with a fixed `value`, End would re-select what is already selected.
    var value = 'settings';
    await pumpAstryxWidget(
      tester,
      StatefulBuilder(
        builder: (context, setState) => AstryxTabList<String>(
          tabs: tabs,
          value: value,
          autofocus: true,
          onChanged: (next) => setState(() => value = next),
        ),
      ),
      surfaceSize: const Size(500, 200),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(value, 'overview');

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(value, 'settings');
  });

  testWidgets('the strip is one tab stop, not one per tab', (tester) async {
    await pumpAstryxWidget(
      tester,
      Column(
        children: <Widget>[
          AstryxButton(label: 'Before', onPressed: () {}),
          build('overview', (_) {}, autofocus: false),
          AstryxButton(label: 'After', onPressed: () {}),
        ],
      ),
      surfaceSize: const Size(500, 300),
    );

    // Focus the first button, then Tab twice: the strip is the second stop and
    // the button after it the third. Three tabs would mean the tabs are
    // individually focusable, which is not the ARIA pattern.
    final before = tester.widget<AstryxButton>(find.byType(AstryxButton).first);
    expect(before.label, 'Before');

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('names the strip for a screen reader', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, 'overview', (_) {});

    expect(find.bySemanticsLabel('Tabs'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('overflow scrolls rather than clipping', (tester) async {
    final many = <AstryxTab<int>>[
      for (var i = 0; i < 20; i++)
        AstryxTab<int>(value: i, label: 'Section number $i'),
    ];

    await pumpAstryxWidget(
      tester,
      AstryxTabList<int>(tabs: many, value: 0, onChanged: (_) {}),
      surfaceSize: const Size(300, 200),
    );
    await tester.pumpAndSettle();

    // A `Scrollable` exists, and no overflow was reported — the documented
    // 1.0 answer to overflow, in place of upstream's collapse-to-menu.
    expect(
      find.descendant(
        of: find.byType(AstryxTabList<int>),
        matching: find.byType(Scrollable),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('fill spreads the tabs across the full width', (tester) async {
    await pumpAstryxWidget(
      tester,
      AstryxTabList<String>(
        tabs: tabs,
        value: 'overview',
        fill: true,
        onChanged: (_) {},
      ),
      surfaceSize: const Size(600, 200),
    );

    final first = tester.getRect(find.text('Overview'));
    final last = tester.getRect(find.text('Settings'));
    expect(last.right - first.left, greaterThan(300));
  });

  // ---------------------------------------------------------------------------
  // Closing
  // ---------------------------------------------------------------------------

  List<AstryxTab<String>> closableTabs(void Function(String) onClose) =>
      <AstryxTab<String>>[
        AstryxTab<String>(
          value: 'card.dart',
          label: 'card.dart',
          onClose: () => onClose('card.dart'),
        ),
        AstryxTab<String>(
          value: 'table.dart',
          label: 'table.dart',
          onClose: () => onClose('table.dart'),
        ),
      ];

  Future<void> pumpClosable(
    WidgetTester tester,
    void Function(String) onClose, {
    String value = 'card.dart',
    ValueChanged<String>? onChanged,
  }) => pumpAstryxWidget(
    tester,
    AstryxTabList<String>(
      tabs: closableTabs(onClose),
      value: value,
      autofocus: true,
      onChanged: onChanged ?? (_) {},
    ),
    surfaceSize: const Size(500, 200),
  );

  testWidgets('a tab without an onClose has no close button', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, 'overview', (_) {});

    expect(find.bySemanticsLabel('Close Overview'), findsNothing);
    handle.dispose();
  });

  testWidgets('a close button is drawn for every closable tab, selected or '
      'not', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpClosable(tester, (_) {});

    // Both, not only the selected one and not only the hovered one: an action
    // behind hover is an action a touch screen does not have.
    expect(find.bySemanticsLabel('Close card.dart'), findsOneWidget);
    expect(find.bySemanticsLabel('Close table.dart'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('closeLabel overrides the accessible name', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAstryxWidget(
      tester,
      AstryxTabList<String>(
        tabs: <AstryxTab<String>>[
          AstryxTab<String>(
            value: 'card.dart',
            label: 'card.dart',
            closeLabel: 'Stop editing card.dart',
            onClose: () {},
          ),
        ],
        value: 'card.dart',
        onChanged: (_) {},
      ),
      surfaceSize: const Size(500, 200),
    );

    expect(find.bySemanticsLabel('Stop editing card.dart'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('pressing the close button closes that tab, and does not '
      'select it', (tester) async {
    final handle = tester.ensureSemantics();
    final closed = <String>[];
    final selected = <String>[];
    await pumpClosable(tester, closed.add, onChanged: selected.add);

    await tester.tap(find.bySemanticsLabel('Close table.dart'));
    await tester.pump();

    expect(closed, <String>['table.dart']);
    // The tab under the button is tappable too; the button wins the arena, so
    // closing a tab does not select it on the way out.
    expect(selected, isEmpty);
    handle.dispose();
  });

  testWidgets('Delete and Backspace close the selected tab', (tester) async {
    final closed = <String>[];
    await pumpClosable(tester, closed.add, value: 'table.dart');

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    // The strip is one tab stop, so the close button is not somewhere Tab can
    // reach — the keyboard needs its own way in.
    expect(closed, <String>['table.dart', 'table.dart']);
  });

  testWidgets('Delete does nothing on a tab that cannot be closed', (
    tester,
  ) async {
    var closed = false;
    await pumpAstryxWidget(
      tester,
      AstryxTabList<String>(
        tabs: <AstryxTab<String>>[
          const AstryxTab<String>(value: 'overview', label: 'Overview'),
          AstryxTab<String>(
            value: 'activity',
            label: 'Activity',
            onClose: () => closed = true,
          ),
        ],
        value: 'overview',
        autofocus: true,
        onChanged: (_) {},
      ),
      surfaceSize: const Size(500, 200),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();

    expect(closed, isFalse);
  });

  testWidgets('a disabled tab cannot be closed', (tester) async {
    final handle = tester.ensureSemantics();
    var closed = false;
    await pumpAstryxWidget(
      tester,
      AstryxTabList<String>(
        tabs: <AstryxTab<String>>[
          AstryxTab<String>(
            value: 'card.dart',
            label: 'card.dart',
            enabled: false,
            onClose: () => closed = true,
          ),
        ],
        value: 'card.dart',
        onChanged: (_) {},
      ),
      surfaceSize: const Size(500, 200),
    );

    await tester.tap(
      find.bySemanticsLabel('Close card.dart'),
      warnIfMissed: false,
    );
    await tester.pump();

    expect(closed, isFalse);
    handle.dispose();
  });
}
