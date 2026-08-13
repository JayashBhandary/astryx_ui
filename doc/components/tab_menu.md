---
title: AstryxTabMenu
description: A tab whose selection opens a menu rather than switching a panel.
component: true
group: Navigation
source: lib/src/components/navigation/tab_menu.dart
upstream: TabMenu
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TabMenuDemoExample extends StatefulWidget {
  const TabMenuDemoExample({super.key});

  @override
  State<TabMenuDemoExample> createState() => _TabMenuDemoExampleState();
}

class _TabMenuDemoExampleState extends State<TabMenuDemoExample> {
  String _view = 'overview';

  static const Set<String> _reports = <String>{'usage', 'billing'};

  @override
  Widget build(BuildContext context) {
    // Most tabs are views; this one is a *set* of them. It is drawn as a tab so
    // it reads as one, and announced as a menu button so nobody is told it is
    // a tab and then handed a menu.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxHStack(
          children: <Widget>[
            AstryxTabList<String>(
              label: 'Views',
              value: _reports.contains(_view) ? null : _view,
              onChanged: (value) => setState(() => _view = value),
              tabs: const <AstryxTab<String>>[
                AstryxTab(value: 'overview', label: 'Overview'),
                AstryxTab(value: 'activity', label: 'Activity'),
              ],
            ),
            AstryxTabMenu(
              label: 'Reports',
              selected: _reports.contains(_view),
              entries: <AstryxMenuEntry>[
                for (final report in _reports)
                  AstryxMenuItem(
                    label: report,
                    onSelected: () => setState(() => _view = report),
                  ),
              ],
            ),
          ],
        ),
        AstryxText('Showing $_view'),
      ],
    );
  }
}
```


## Usage

```dart
AstryxTabMenu(
  label: 'Reports',
  selected: view.isReport,
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Usage', onSelected: () => select(usage)),
  ],
)
```

For the strip where most tabs are views and one is a *set* of them — "More reports", a saved-view picker, the tail of a strip too long for the bar. It sits beside an [AstryxTabList](tab_list.md) and is drawn to match, indicator and all, so a reader looking at a report still sees something in the strip claiming it.

> **Accessibility**
>
> It announces itself as a **menu button**, not a tab. Telling a screen-reader user this is a tab and then opening a menu is a promise the widget cannot keep — `selected` still reports which entry the page came from.

### AstryxTabMenu

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the trigger’s accessible name. |
| `entries` *(required)* | `List<AstryxMenuEntry>` | — | The rows the menu shows. |
| `icon` | `Widget?` | — | An icon before the label. |
| `selected` | `bool` | `false` | Whether the view currently showing came from this menu. Draws the tab’s indicator. |
| `enabled` | `bool` | `true` | Whether the menu opens. |
| `menuLabel` | `String?` | — | A name for the menu surface. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |


## Related

- [AstryxTabList](tab_list.md) — the tabs that do switch a panel.
- [AstryxMoreMenu](more_menu.md) — when it does not need to look like a tab.

---

Something wrong with `AstryxTabMenu`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTabMenu&component=AstryxTabMenu) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTabMenu&area=AstryxTabMenu) — both templates arrive with the component filled in.
