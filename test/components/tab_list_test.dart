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
}
