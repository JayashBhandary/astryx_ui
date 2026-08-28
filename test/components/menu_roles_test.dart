import 'dart:ui' show CheckedState;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// The selectable menu rows, checked against
/// `packages/core/src/DropdownMenu/DropdownMenuCheckboxItem.tsx` and
/// `DropdownMenuRadioItem.tsx`.
void main() {
  /// Mounts a dropdown over [entries] and opens it.
  Future<void> openMenu(
    WidgetTester tester,
    List<AstryxMenuEntry> entries,
  ) async {
    // A fresh tree each time: the dropdown keeps its own open state, and a
    // second `openMenu` in one test would otherwise toggle the first shut.
    await pumpAstryxWidget(tester, const SizedBox.shrink());
    await pumpAstryxWidget(
      tester,
      AstryxDropdownMenu(
        entries: entries,
        triggerBuilder: (context, controller) =>
            AstryxButton(label: 'Options', onPressed: controller.toggle),
      ),
      surfaceSize: const Size(400, 500),
    );
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
  }

  testWidgets('an action row still closes the menu when chosen', (
    tester,
  ) async {
    var chosen = 0;
    await openMenu(tester, <AstryxMenuEntry>[
      AstryxMenuItem(label: 'Rename', onSelected: () => chosen++),
    ]);

    await tester.tap(find.text('Rename'));
    await tester.pumpAndSettle();

    expect(chosen, 1);
    expect(find.text('Rename'), findsNothing);
  });

  testWidgets('a checkbox row stays open so several can be toggled', (
    tester,
  ) async {
    final toggled = <String>[];
    await openMenu(tester, <AstryxMenuEntry>[
      AstryxMenuItem.checkbox(
        label: 'Show archived',
        checked: false,
        onSelected: () => toggled.add('archived'),
      ),
      AstryxMenuItem.checkbox(
        label: 'Show drafts',
        checked: true,
        onSelected: () => toggled.add('drafts'),
      ),
    ]);

    await tester.tap(find.text('Show archived'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show drafts'));
    await tester.pumpAndSettle();

    expect(toggled, <String>['archived', 'drafts']);
    expect(
      find.text('Show archived'),
      findsOneWidget,
      reason: 'a checkbox row that closed the menu would allow one toggle',
    );
  });

  testWidgets('a radio row closes the menu — the choice is made', (
    tester,
  ) async {
    var chosen = 0;
    await openMenu(tester, <AstryxMenuEntry>[
      AstryxMenuItem.radio(
        label: 'Compact',
        checked: false,
        onSelected: () => chosen++,
      ),
    ]);

    await tester.tap(find.text('Compact'));
    await tester.pumpAndSettle();

    expect(chosen, 1);
    expect(find.text('Compact'), findsNothing);
  });

  testWidgets('closeOnSelect overrides either default', (tester) async {
    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem.checkbox(
        label: 'Wrap lines',
        checked: false,
        closeOnSelect: true,
      ),
    ]);

    await tester.tap(find.text('Wrap lines'));
    await tester.pumpAndSettle();

    expect(find.text('Wrap lines'), findsNothing);
  });

  testWidgets('a checkbox row is announced as checked, not as a button', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem.checkbox(label: 'Show archived', checked: true),
    ]);

    final node = tester.getSemantics(
      find.bySemanticsLabel(RegExp('Show archived')),
    );
    expect(node.flagsCollection.isChecked, CheckedState.isTrue);
    expect(node.flagsCollection.isButton, isFalse);

    handle.dispose();
  });

  testWidgets('a radio row is announced as one of a group', (tester) async {
    final handle = tester.ensureSemantics();
    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem.radio(label: 'Compact', checked: true),
      const AstryxMenuItem.radio(label: 'Balanced', checked: false),
    ]);

    final compact = tester.getSemantics(
      find.bySemanticsLabel(RegExp('Compact')),
    );
    expect(compact.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
    expect(compact.flagsCollection.isChecked, CheckedState.isTrue);

    final balanced = tester.getSemantics(
      find.bySemanticsLabel(RegExp('Balanced')),
    );
    expect(balanced.flagsCollection.isChecked, isNot(CheckedState.isTrue));

    handle.dispose();
  });

  testWidgets('an action row keeps its button role', (tester) async {
    final handle = tester.ensureSemantics();
    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem(label: 'Rename'),
    ]);

    final node = tester.getSemantics(find.bySemanticsLabel(RegExp('Rename')));
    expect(node.flagsCollection.isButton, isTrue);
    expect(node.flagsCollection.isChecked, isNot(CheckedState.isTrue));

    handle.dispose();
  });

  testWidgets('a menu with no selectable row keeps its tight layout', (
    tester,
  ) async {
    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem(label: 'Rename'),
    ]);
    final tight = tester.getTopLeft(find.text('Rename')).dx;

    await openMenu(tester, <AstryxMenuEntry>[
      const AstryxMenuItem(label: 'Rename'),
      const AstryxMenuItem.checkbox(label: 'Show archived', checked: false),
    ]);
    final indented = tester.getTopLeft(find.text('Rename')).dx;

    // One gutter for the whole menu: the action's label moves right to line up
    // with the checkbox's, rather than the two starting at different columns.
    expect(indented, greaterThan(tight));
  });
}
