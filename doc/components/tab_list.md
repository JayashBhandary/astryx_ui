---
title: AstryxTabList
description: A strip of tabs that reports a value and owns no panel.
component: true
group: Data display
source: lib/src/components/data/tab_list.dart
upstream: TabList / Tab
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TabListDemoExample extends StatefulWidget {
  const TabListDemoExample({super.key});

  @override
  State<TabListDemoExample> createState() => _TabListDemoExampleState();
}

class _TabListDemoExampleState extends State<TabListDemoExample> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    // The strip owns no panel. It reports a value; the application decides what
    // that value shows — which is what keeps a tab bar usable with routing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Project sections',
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'overview', label: 'Overview'),
            AstryxTab(value: 'activity', label: 'Activity'),
            AstryxTab(value: 'settings', label: 'Settings'),
          ],
        ),
        AstryxText(switch (_tab) {
          'overview' => '4,201 requests this month.',
          'activity' => 'Ada deployed 20 minutes ago.',
          _ => 'Two admins, twenty-two members.',
        }),
      ],
    );
  }
}
```


## Usage

```dart
AstryxTabList<String>(
  value: _tab,
  onChanged: (value) => setState(() => _tab = value),
  tabs: const <AstryxTab<String>>[
    AstryxTab(value: 'overview', label: 'Overview'),
    AstryxTab(value: 'activity', label: 'Activity'),
  ],
)
```

There is no `TabController`, no `TabBarView` and no panel. The strip reports a value; what that value shows is the application’s business — which is what makes the same widget work for a local `setState`, a router and a stored preference alike.

## Composition

```text
AstryxTabList<T>
└── tabs
    └── AstryxTab<T>
        ├── value    ← what selecting it produces
        ├── label    ← the visible text, and its accessible name
        ├── icon     ← optional. Any widget
        ├── badge    ← optional. An AstryxBadge
        └── onClose  ← optional. Draws a close button after the label
```

## Icons and badges

```dart
class TabListIconsExample extends StatefulWidget {
  const TabListIconsExample({super.key});

  @override
  State<TabListIconsExample> createState() => _TabListIconsExampleState();
}

class _TabListIconsExampleState extends State<TabListIconsExample> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    return AstryxTabList<String>(
      value: _tab,
      onChanged: (value) => setState(() => _tab = value),
      tabs: const <AstryxTab<String>>[
        AstryxTab(
          value: 'overview',
          label: 'Overview',
          icon: AstryxIcon(AstryxIconName.info),
        ),
        AstryxTab(
          value: 'activity',
          label: 'Activity',
          badge: AstryxBadge(
            '12',
            semanticsLabel: '12 new',
            variant: AstryxBadgeVariant.info,
          ),
        ),
        AstryxTab(
          value: 'settings',
          label: 'Settings',
          icon: AstryxIcon(AstryxIconName.wrench),
        ),
        AstryxTab(value: 'archive', label: 'Archive', enabled: false),
      ],
    );
  }
}
```


## Closable tabs

An `onClose` puts a close button after the label — editor tabs, open documents, anything the user can put away. The strip owns no list of its own, so removing the tab and choosing what is selected afterwards stays with the caller.

```dart
class TabListClosableExample extends StatefulWidget {
  const TabListClosableExample({super.key});

  @override
  State<TabListClosableExample> createState() => _TabListClosableExampleState();
}

class _TabListClosableExampleState extends State<TabListClosableExample> {
  List<String> _open = <String>['card.dart', 'table.dart', 'tab_list.dart'];
  String _file = 'table.dart';

  void _close(String file) {
    setState(() {
      final index = _open.indexOf(file);
      _open = List<String>.of(_open)..removeAt(index);
      if (_file != file) return;
      // The neighbour, not the first tab: closing what you were reading should
      // not move you to the other end of the strip.
      _file = _open.isEmpty
          ? ''
          : _open[index < _open.length ? index : _open.length - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    // An onClose puts a close button after the label. The strip owns no list,
    // so removing the tab — and deciding what is selected afterwards — is the
    // caller's job.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Open files',
          value: _file,
          size: AstryxTabSize.sm,
          onChanged: (value) => setState(() => _file = value),
          tabs: <AstryxTab<String>>[
            for (final file in _open)
              AstryxTab<String>(
                value: file,
                label: file,
                onClose: () => _close(file),
              ),
          ],
        ),
        AstryxText(_open.isEmpty ? 'Nothing open.' : 'Editing $_file.'),
      ],
    );
  }
}
```


> **Accessibility**
>
> The close button is always drawn, not revealed on hover — hover raises its contrast and nothing more. Touch has no hover, and an action that only exists under a cursor does not exist on a phone. The keyboard reaches it with `Delete` on the strip.

## Sizes

```dart
class TabListSizesExample extends StatefulWidget {
  const TabListSizesExample({super.key});

  @override
  State<TabListSizesExample> createState() => _TabListSizesExampleState();
}

class _TabListSizesExampleState extends State<TabListSizesExample> {
  String _tab = 'a';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final size in AstryxTabSize.values)
          AstryxTabList<String>(
            size: size,
            value: _tab,
            onChanged: (value) => setState(() => _tab = value),
            tabs: const <AstryxTab<String>>[
              AstryxTab(value: 'a', label: 'First'),
              AstryxTab(value: 'b', label: 'Second'),
              AstryxTab(value: 'c', label: 'Third'),
            ],
          ),
      ],
    );
  }
}
```


## Fill and the divider

`fill` splits the width equally — for two or three tabs in a narrow panel, where a left-packed strip looks unfinished.

```dart
class TabListFillExample extends StatefulWidget {
  const TabListFillExample({super.key});

  @override
  State<TabListFillExample> createState() => _TabListFillExampleState();
}

class _TabListFillExampleState extends State<TabListFillExample> {
  String _tab = 'a';

  @override
  Widget build(BuildContext context) {
    // `fill` splits the width equally — for two or three tabs in a narrow
    // panel, where a left-packed strip looks unfinished.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          fill: true,
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'Monthly'),
            AstryxTab(value: 'b', label: 'Yearly'),
          ],
        ),
        AstryxTabList<String>(
          showDivider: false,
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'No divider'),
            AstryxTab(value: 'b', label: 'Under the strip'),
          ],
        ),
      ],
    );
  }
}
```


## Overflow

Too many tabs scroll rather than shrink, with a fade at whichever edge has more. Arrowing to a tab that is off-screen scrolls it into view: a selection the user cannot see is worse than no selection at all.

```dart
class TabListOverflowExample extends StatefulWidget {
  const TabListOverflowExample({super.key});

  @override
  State<TabListOverflowExample> createState() => _TabListOverflowExampleState();
}

class _TabListOverflowExampleState extends State<TabListOverflowExample> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    // Too many tabs scroll rather than shrink, with a fade at whichever edge
    // has more. Arrowing to an off-screen tab scrolls it into view — a
    // selection you cannot see is worse than none.
    return SizedBox(
      width: 360,
      child: AstryxTabList<int>(
        value: _tab,
        onChanged: (value) => setState(() => _tab = value),
        tabs: <AstryxTab<int>>[
          for (var i = 0; i < 16; i++)
            AstryxTab<int>(value: i, label: 'Section $i'),
        ],
      ),
    );
  }
}
```


> **Note**
>
> The overflow scrolls; it does not collapse into a "more" menu. If a strip needs sixteen tabs, the navigation probably needs rethinking before the widget does.

## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Enters or leaves the strip — one stop for the whole strip. |
| `→` / `←` | Selects the next or previous enabled tab, wrapping. Mirrored under RTL. |
| `Home` / `End` | Selects the first or last enabled tab. |
| `Delete` / `Backspace` | Closes the selected tab, when it has an `onClose`. |

> **Accessibility**
>
> Arrow keys select as they move, which is the ARIA pattern for tabs whose panels are cheap to render. Give the strip a `label` when the page has more than one.

### AstryxTabList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `tabs` *(required)* | `List<AstryxTab<T>>` | — | The tabs, in order. |
| `value` *(required)* | `T?` | — | The selected value. |
| `onChanged` | `ValueChanged<T>?` | — | Called with the newly selected value. |
| `size` | `AstryxTabSize?` | — | The tab height. Null inherits from an `AstryxSizeScope`. |
| `showDivider` | `bool` | `true` | Whether to draw a rule under the strip. |
| `fill` | `bool` | `false` | Whether the tabs share the full width equally. |
| `label` | `String?` | — | An accessible name for the strip. |
| `focusNode` | `FocusNode?` | — | The strip’s focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


### AstryxTab

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `T` | — | What selecting this tab produces. |
| `label` *(required)* | `String` | — | The visible text, and this tab’s accessible name. |
| `icon` | `Widget?` | — | An icon before the label. |
| `badge` | `AstryxBadge?` | — | A count or status after it. |
| `enabled` | `bool` | `true` | Whether the tab can be selected. |
| `onClose` | `VoidCallback?` | — | Called when the tab’s close button is pressed. Non-null draws the button. |
| `closeLabel` | `String?` | — | The accessible name of the close button. Defaults to “Close {label}”. |


## Related

- [AstryxButtonGroup](button_group.md) — for actions, not for views.

---

Something wrong with `AstryxTabList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTabList&component=AstryxTabList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTabList&area=AstryxTabList) — both templates arrive with the component filled in.
