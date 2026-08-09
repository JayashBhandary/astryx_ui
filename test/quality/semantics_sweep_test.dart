import 'dart:ui' show CheckedState, Tristate;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/golden.dart';

/// `P11-1` — the accessibility checklist, applied across the whole surface.
///
/// The per-widget test files already assert each widget's own semantics. This
/// file exists for the part those cannot see: **consistency between widgets**.
/// An interface where two of three toggles report `enabled` and the third
/// forgets is worse than one where none of them do, because nobody notices.
///
/// Four rules are checked mechanically over every interactive widget:
///
///  1. A disabled control reports `enabled: false`.
///  2. A disabled control offers no tap action — a screen reader must not
///     announce something it cannot do.
///  3. Every interactive widget has a non-empty accessible name.
///  4. Nothing announces its own name twice.
void main() {
  /// One interactive widget, in both its enabled and disabled forms.
  ///
  /// The name is what the widget should announce; `finder` locates the node
  /// that owns the semantics, which is not always the widget's own type.
  ///
  /// `finder` is a *callback*, not a `Finder`: `find.bySemanticsLabel` throws
  /// unless semantics are already enabled, and this table is built at `main()`
  /// scope, long before any test calls `ensureSemantics`.
  ({Widget enabled, Widget disabled, Finder Function() finder, String name})
  spec({
    required Widget enabled,
    required Widget disabled,
    required Finder Function() finder,
    required String name,
  }) => (enabled: enabled, disabled: disabled, finder: finder, name: name);

  final cases =
      <
        String,
        ({
          Widget enabled,
          Widget disabled,
          Finder Function() finder,
          String name,
        })
      >{
        'AstryxButton': spec(
          enabled: AstryxButton(label: 'Save', onPressed: () {}),
          disabled: const AstryxButton(label: 'Save'),
          finder: () => find.byType(AstryxButton),
          name: 'Save',
        ),
        'AstryxIconButton': spec(
          enabled: AstryxIconButton(
            icon: AstryxIconName.close,
            label: 'Close',
            onPressed: () {},
          ),
          disabled: const AstryxIconButton(
            icon: AstryxIconName.close,
            label: 'Close',
            enabled: false,
          ),
          finder: () => find.byType(AstryxIconButton),
          name: 'Close',
        ),
        'AstryxCheckbox': spec(
          enabled: AstryxCheckbox(
            label: 'Accept',
            value: false,
            onChanged: (_) {},
          ),
          disabled: AstryxCheckbox(
            label: 'Accept',
            value: false,
            enabled: false,
            onChanged: (_) {},
          ),
          finder: () => find.byType(AstryxCheckbox),
          name: 'Accept',
        ),
        'AstryxSwitch': spec(
          enabled: AstryxSwitch(
            label: 'Notify',
            value: false,
            onChanged: (_) {},
          ),
          disabled: AstryxSwitch(
            label: 'Notify',
            value: false,
            enabled: false,
            onChanged: (_) {},
          ),
          finder: () => find.byType(AstryxSwitch),
          name: 'Notify',
        ),
        'AstryxTextInput': spec(
          enabled: const AstryxTextInput(label: 'Email', width: 280),
          disabled: const AstryxTextInput(
            label: 'Email',
            enabled: false,
            width: 280,
          ),
          finder: () => find.byType(EditableText),
          name: 'Email',
        ),
        'AstryxSelector': spec(
          enabled: AstryxSelector<String>(
            label: 'Owner',
            value: null,
            width: 280,
            onChanged: (_) {},
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'a', label: 'Ada'),
            ],
          ),
          disabled: const AstryxSelector<String>(
            label: 'Owner',
            value: null,
            enabled: false,
            width: 280,
            options: <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'a', label: 'Ada'),
            ],
          ),
          finder: () => find.bySemanticsLabel('Owner'),
          name: 'Owner',
        ),
        'AstryxCard': spec(
          enabled: AstryxCard(
            semanticsLabel: 'Open report',
            onPressed: () {},
            child: const AstryxText('Body'),
          ),
          // A card with no callback is inert rather than disabled, so the
          // "disabled" form here is a card that reports no button at all.
          disabled: const AstryxCard(child: AstryxText('Body')),
          finder: () => find.byType(AstryxCard),
          name: 'Open report',
        ),
      };

  group('every interactive widget has an accessible name', () {
    for (final entry in cases.entries) {
      testWidgets(entry.key, (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(tester, entry.value.enabled);

        final node = tester.getSemantics(entry.value.finder());
        expect(
          node.getSemanticsData().label,
          entry.value.name,
          reason: '${entry.key} announced the wrong name',
        );
        handle.dispose();
      });
    }
  });

  group('a disabled control reports itself disabled', () {
    for (final entry in cases.entries) {
      if (entry.key == 'AstryxCard') continue;
      testWidgets(entry.key, (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(tester, entry.value.disabled);

        final data = tester
            .getSemantics(entry.value.finder())
            .getSemanticsData();
        expect(
          data.flagsCollection.isEnabled,
          Tristate.isFalse,
          reason: '${entry.key} did not report enabled: false',
        );
        handle.dispose();
      });
    }
  });

  group('a disabled control offers no tap action', () {
    for (final entry in cases.entries) {
      if (entry.key == 'AstryxCard') continue;
      testWidgets(entry.key, (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAstryxWidget(tester, entry.value.disabled);

        final data = tester
            .getSemantics(entry.value.finder())
            .getSemanticsData();
        expect(
          data.hasAction(SemanticsAction.tap),
          isFalse,
          reason: '${entry.key} offered a tap action while disabled',
        );
        handle.dispose();
      });
    }
  });

  group('a name is announced once, not twice', () {
    for (final entry in cases.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpAstryxWidget(tester, entry.value.enabled);

        // The visible label appears exactly once in the widget tree. Every
        // widget in this package wraps its own visible text in
        // `ExcludeSemantics` and puts the string on the control instead; a
        // second `Text` would mean a screen reader hears it twice.
        expect(
          find.text(entry.value.name).evaluate().length,
          lessThanOrEqualTo(1),
          reason: '${entry.key} rendered its name more than once',
        );
      });
    }
  });

  group('state is reflected, not merely painted', () {
    testWidgets('a checkbox reports checked, unchecked and mixed', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      const expected = <AstryxCheckboxValue, CheckedState>{
        AstryxCheckboxValue.unchecked: CheckedState.isFalse,
        AstryxCheckboxValue.checked: CheckedState.isTrue,
        AstryxCheckboxValue.indeterminate: CheckedState.mixed,
      };

      for (final entry in expected.entries) {
        await pumpAstryxWidget(
          tester,
          AstryxCheckbox.tristate(
            label: 'Scopes',
            value: entry.key,
            onChanged: (_) {},
          ),
        );
        expect(
          tester
              .getSemantics(find.byType(AstryxCheckbox))
              .flagsCollection
              .isChecked,
          entry.value,
          reason: entry.key.name,
        );
      }
      handle.dispose();
    });

    testWidgets('a switch reports toggled, never checked', (tester) async {
      final handle = tester.ensureSemantics();
      for (final value in <bool>[false, true]) {
        await pumpAstryxWidget(
          tester,
          AstryxSwitch(label: 'Notify', value: value, onChanged: (_) {}),
        );
        final flags = tester
            .getSemantics(find.byType(AstryxSwitch))
            .flagsCollection;
        expect(
          flags.isToggled,
          value ? Tristate.isTrue : Tristate.isFalse,
          reason: 'value: $value',
        );
        // A switch and a checkbox are different roles and a screen reader
        // says different words for them. Reporting both would be worse than
        // reporting the wrong one.
        expect(flags.isChecked, CheckedState.none);
      }
      handle.dispose();
    });

    testWidgets('a tab reports selected', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxTabList<String>(
          value: 'a',
          onChanged: (_) {},
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'First'),
            AstryxTab(value: 'b', label: 'Second'),
          ],
        ),
        surfaceSize: const Size(400, 200),
      );

      expect(
        tester.getSemantics(find.text('First')).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      expect(
        tester.getSemantics(find.text('Second')).flagsCollection.isSelected,
        Tristate.isFalse,
      );
      handle.dispose();
    });

    testWidgets('a selector reports expanded while its list is open', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        Center(
          child: AstryxSelector<String>(
            label: 'Owner',
            value: null,
            width: 260,
            onChanged: (_) {},
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'a', label: 'Ada'),
            ],
          ),
        ),
      );

      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Owner'))
            .flagsCollection
            .isExpanded,
        Tristate.isFalse,
      );

      await tester.tap(find.byType(AstryxSelector<String>));
      await tester.pumpAndSettle();

      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Owner'))
            .flagsCollection
            .isExpanded,
        Tristate.isTrue,
      );
      handle.dispose();
    });

    testWidgets('a radio option is in a mutually exclusive group', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxRadioList<String>(
          value: 'a',
          onChanged: (_) {},
          options: const <AstryxRadioOption<String>>[
            AstryxRadioOption(value: 'a', label: 'First'),
            AstryxRadioOption(value: 'b', label: 'Second'),
          ],
        ),
      );

      final first = tester.getSemantics(find.text('First')).flagsCollection;
      expect(first.isInMutuallyExclusiveGroup, isTrue);
      expect(first.isChecked, CheckedState.isTrue);
      expect(
        tester.getSemantics(find.text('Second')).flagsCollection.isChecked,
        CheckedState.isFalse,
      );
      handle.dispose();
    });
  });

  group('dynamic content announces itself', () {
    testWidgets('a spinner, a banner and a toast are all live regions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await pumpAstryxWidget(tester, const AstryxSpinner(label: 'Saving'));
      expect(
        tester
            .getSemantics(find.byType(AstryxSpinner))
            .flagsCollection
            .isLiveRegion,
        isTrue,
        reason: 'spinner',
      );

      await pumpAstryxWidget(
        tester,
        const AstryxBanner(title: 'Could not save'),
      );
      expect(
        tester
            .getSemantics(find.byType(AstryxBanner))
            .flagsCollection
            .isLiveRegion,
        isTrue,
        reason: 'banner',
      );

      final toasts = AstryxToastController();
      addTearDown(toasts.dispose);
      await pumpAstryxWidget(
        tester,
        const SizedBox.expand(),
        toastController: toasts,
      );
      toasts.show(
        const AstryxToast(message: 'Archived', duration: Duration.zero),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Notifications'))
            .flagsCollection
            .isLiveRegion,
        isTrue,
        reason: 'toast host',
      );
      handle.dispose();
    });

    testWidgets('a decorative indicator stays out of the tree', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        const AstryxSkeleton(width: 100, height: 20),
      );

      // A skeleton is a placeholder for content that has not arrived. There
      // is nothing to announce, and announcing "loading" for each of twelve
      // skeleton rows is actively hostile.
      expect(
        find.descendant(
          of: find.byType(AstryxSkeleton),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('nothing is conveyed by colour alone', () {
    testWidgets('every field status carries an icon as well as a colour', (
      tester,
    ) async {
      for (final type in AstryxFieldStatusType.values) {
        await pumpAstryxWidget(
          tester,
          AstryxTextInput(
            label: 'Email',
            status: AstryxFieldStatus(type, 'A message'),
            width: 300,
          ),
        );
        // Two icons: one in the field, one beside the message. Either alone
        // would do; the point is that neither is absent.
        expect(
          find.byType(AstryxIcon),
          findsWidgets,
          reason: '${type.name} had no icon',
        );
      }
    });

    testWidgets('every banner status carries an icon', (tester) async {
      for (final status in AstryxBannerStatus.values) {
        await pumpAstryxWidget(
          tester,
          AstryxBanner(status: status, title: 'Title'),
        );
        expect(
          find.byType(AstryxIcon),
          findsOneWidget,
          reason: '${status.name} had no icon',
        );
      }
    });

    testWidgets('a selected table row is marked, not just tinted', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpAstryxWidget(
        tester,
        AstryxTable<_Row>(
          rows: const <_Row>[_Row('a', 'Alpha')],
          keyOf: (row) => row.id,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: const <Object>{'a'},
          rowLabelOf: (row) => row.name,
          onSelectionChanged: (_) {},
          columns: <AstryxTableColumn<_Row>>[
            AstryxTableColumn<_Row>(
              id: 'name',
              header: 'Name',
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
          ],
        ),
      );

      // The checkbox is the non-colour signal, and it reports its own state.
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Select Alpha'))
            .flagsCollection
            .isChecked,
        CheckedState.isTrue,
      );
      handle.dispose();
    });
  });

  group('tap targets meet the platform guidelines', () {
    testWidgets('every interactive widget, at touch density', (tester) async {
      final handle = tester.ensureSemantics();

      for (final entry in cases.entries) {
        await pumpAstryxWidget(
          tester,
          Center(child: entry.value.enabled),
          density: AstryxDensity.touch,
        );
        await expectLater(
          tester,
          meetsGuideline(androidTapTargetGuideline),
        );
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      }
      handle.dispose();
    });
  });
}

class _Row {
  const _Row(this.id, this.name);

  final String id;
  final String name;
}
