---
title: AstryxMoreMenu
description: The overflow menu a toolbar or nav collapses its tail into.
component: true
group: Navigation
source: lib/src/components/navigation/more_menu.dart
upstream: MoreMenu
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ToolbarDemoExample extends StatefulWidget {
  const ToolbarDemoExample({super.key});

  @override
  State<ToolbarDemoExample> createState() => _ToolbarDemoExampleState();
}

class _ToolbarDemoExampleState extends State<ToolbarDemoExample> {
  final Set<String> _marks = <String>{'bold'};

  @override
  Widget build(BuildContext context) {
    // Tab reaches the band once and leaves it once, however many controls sit
    // between; the arrows move inside it. A formatting bar of twelve buttons
    // is twelve presses to walk past otherwise.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing1,
      child: AstryxToolbar(
        label: 'Formatting',
        children: <Widget>[
          for (final mark in const <List<String>>[
            <String>['bold', 'Bold'],
            <String>['italic', 'Italic'],
            <String>['code', 'Code'],
          ])
            AstryxToggleButton(
              label: mark[1],
              pressed: _marks.contains(mark[0]),
              size: AstryxButtonSize.sm,
              onChanged: (on) => setState(() {
                on ? _marks.add(mark[0]) : _marks.remove(mark[0]);
              }),
            ),
          const AstryxToolbarDivider(),
          AstryxMoreMenu(
            label: 'More formatting',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Strikethrough', onSelected: () {}),
              AstryxMenuItem(label: 'Superscript', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Clear formatting',
                destructive: true,
                onSelected: () => setState(_marks.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxMoreMenu(
  entries: <AstryxMenuEntry>[
    AstryxMenuItem(label: 'Rename', onSelected: rename),
    const AstryxMenuDivider(),
    AstryxMenuItem(label: 'Delete', destructive: true, onSelected: remove),
  ],
)
```

One widget rather than an [AstryxIconButton](icon_button.md) plus an [AstryxDropdownMenu](dropdown_menu.md) written out at every call site — which is what a toolbar, a navigation and a table row each need at their end, and which is exactly the composition people get subtly wrong: an unnamed trigger, or one that opens a menu with no name of its own.

> **Accessibility**
>
> `label` is the trigger’s name, its tooltip **and** the menu’s name — one string, because they are one answer to one question: what is behind this button? [AstryxBreadcrumbs](breadcrumbs.md) uses this widget for its collapsed steps, which is why that trigger is named "Show 3 hidden steps" rather than "…".

### AstryxMoreMenu

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` *(required)* | `List<AstryxMenuEntry>` | — | The rows, in order. |
| `label` | `String?` | — | The trigger’s name, its tooltip, and the menu’s name. |
| `icon` | `AstryxIconName` | `AstryxIconName.moreHorizontal` | The glyph on the trigger. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.sm` | The trigger’s size. |
| `variant` | `AstryxButtonVariant` | `AstryxButtonVariant.ghost` | The trigger’s variant. |
| `enabled` | `bool` | `true` | Whether the menu opens. |
| `controller` | `AstryxOverlayController?` | — | Drives the menu from outside. |


---

Something wrong with `AstryxMoreMenu`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxMoreMenu&component=AstryxMoreMenu) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxMoreMenu&area=AstryxMoreMenu) — both templates arrive with the component filled in.
