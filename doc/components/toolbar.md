---
title: AstryxToolbar
description: A horizontal band of controls, with arrow-key traversal as one tab stop.
component: true
group: Navigation
source: lib/src/components/navigation/toolbar.dart
upstream: Toolbar
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
AstryxToolbar(
  label: 'Formatting',
  children: <Widget>[
    AstryxToggleButton(label: 'Bold', pressed: bold, onChanged: setBold),
    const AstryxToolbarDivider(),
    AstryxMoreMenu(entries: more),
  ],
)
```

## One tab stop

**Tab reaches the toolbar, not each button in it.** A formatting bar of twelve buttons is twelve presses to walk past otherwise, which is why the ARIA toolbar pattern exists. Inside, the arrows move between the controls and wrap; Home and End go to the ends.

The children stay ordinary, traversable widgets — that is how Tab *enters* on the first one. What makes the band a single stop is that Tab pressed **inside** it leaves instead of walking on: the toolbar steps focus to its edge and lets Flutter’s own traversal carry past. Nothing is asked of the children, so anything focusable can go in.

> **Note**
>
> `AstryxToolbarDivider` is its own widget because a bare [AstryxDivider](divider.md) in a row has no height to take, and because a rule between groups of controls is a thing worth naming.

### AstryxToolbar

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The controls, in the order they are traversed. |
| `label` | `String?` | — | The toolbar’s accessible name. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The space between controls. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The inset around them. |


## Related

- [AstryxMoreMenu](more_menu.md) — for the tail that will not fit.
- [AstryxOverflowList](overflow_list.md) — which measures the row and decides what that tail is.
- [AstryxButtonGroup](button_group.md) — buttons joined into one visual control, which is a different thing: a group is *drawn* together, a toolbar is *operated* together.

---

Something wrong with `AstryxToolbar`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxToolbar&component=AstryxToolbar) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxToolbar&area=AstryxToolbar) — both templates arrive with the component filled in.
