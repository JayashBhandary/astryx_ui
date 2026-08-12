---
title: AstryxLayout
description: The content frame inside the shell — header, footer, panel and scrolling body.
component: true
group: App shell
source: lib/src/components/shell/layout.dart
upstream: Layout / LayoutContent / LayoutFooter / LayoutHeader / LayoutPanel
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LayoutDemoExample extends StatelessWidget {
  const LayoutDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The header and the footer hold still; the body scrolls under them. A
    // page title that scrolls away takes the reader's place in the hierarchy
    // with it, and a Save button that scrolls away cannot be found.
    return SizedBox(
      height: 360,
      child: AstryxLayout(
        header: AstryxHStack(
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Deploys', level: 1)),
            AstryxButton(
              label: 'New deploy',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(label: 'Discard', onPressed: () {}),
            AstryxButton(
              label: 'Save',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 1; i <= 12; i++)
              AstryxCard(
                padding: AstryxSpacingToken.spacing3,
                child: AstryxText('Deploy #$i'),
              ),
          ],
        ),
      ),
    );
  }
}
```


## Usage

```dart
AstryxLayout(
  header: const AstryxHeading('Deploys', level: 1),
  footer: AstryxButton(label: 'Save', onPressed: save),
  child: const DeployTable(),
)
```

**The header and the footer do not scroll; the body does.** That is the whole of it, and the reason this is a widget rather than a `Column`: a page title that scrolls away takes the reader’s place in the hierarchy with it, and a Save button that scrolls away is a Save button people cannot find.

```text
AstryxLayout
├── header   ← pinned, with a rule under it
├── child    ← the body. Scrolls
│   └── panel ← beside the body, scrolling on its own
└── footer   ← pinned, with a rule over it
```

Upstream splits this into five components — `Layout`, `LayoutHeader`, `LayoutContent`, `LayoutPanel`, `LayoutFooter`. They are slots here, because a slot cannot be put in the wrong order, left out of its parent, or nested inside another one by mistake.

## The panel

A column beside the body — details, filters, an outline. It scrolls on its own: a panel tied to the body’s scroll position is a panel that disappears while you are reading it.

```dart
class LayoutPanelExample extends StatelessWidget {
  const LayoutPanelExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The panel scrolls on its own: one tied to the body's scroll position is
    // a panel that disappears while you are reading it.
    return SizedBox(
      height: 300,
      child: AstryxLayout(
        header: const AstryxHeading('Deploy #412'),
        panelWidth: 220,
        panel: const AstryxMetadataList(
          items: <AstryxMetadataItem>[
            AstryxMetadataItem(
              label: 'Status',
              value: AstryxBadge('Live', variant: AstryxBadgeVariant.success),
              semanticsValue: 'Live',
            ),
            AstryxMetadataItem(
              label: 'Owner',
              value: AstryxText('Ada Lovelace'),
              semanticsValue: 'Ada Lovelace',
            ),
            AstryxMetadataItem(
              label: 'Duration',
              value: AstryxText('11 minutes'),
              semanticsValue: '11 minutes',
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 1; i <= 10; i++)
              AstryxText('Step $i finished in ${i * 3} seconds.'),
          ],
        ),
      ),
    );
  }
}
```


`panelSide` is logical, so a panel at the `end` sits on the right under LTR and on the left under RTL, with no second layout to maintain.

## Scrolling and measure

| Set | When |
| --- | --- |
| `scrollable: false` | The body scrolls itself — a table with a pinned header row, a transcript that stays at the bottom. Two scroll views inside one another is one too many. |
| `maxContentWidth` | A page of prose or a single form, where a line running the width of a monitor is unreadable. Leave it null for a table. |
| `scrollController` | Something beside the body needs its scroll position — an [AstryxOutline](outline.md) in the panel tracking the reader. The body’s scroll view belongs to this widget, so the controller is handed in rather than invented. See the [documentation](documentation.md) template. |

### AstryxLayout

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The body, which is what scrolls. |
| `header` | `Widget?` | — | The band above the body — a title, a breadcrumb trail, tabs. Pinned. |
| `footer` | `Widget?` | — | The band below the body — the actions a form is submitted with. Pinned. |
| `panel` | `Widget?` | — | A column beside the body, scrolling on its own. |
| `panelSide` | `AstryxLayoutPanelSide` | `AstryxLayoutPanelSide.end` | Which edge the panel sits against. |
| `panelWidth` | `double` | `320` | How wide the panel is. |
| `scrollable` | `bool` | `true` | Whether the body scrolls. |
| `scrollController` | `ScrollController?` | — | The body’s scroll controller, for anything that has to know where the body has got to — an outline in the panel. Only legal while `scrollable` is true. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing6` | The inset around the body, the header and the footer. |
| `maxContentWidth` | `double?` | — | A measure for the body. Null lets it fill. |


### AstryxLayoutPanelSide

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `AstryxLayoutPanelSide` | — | The reading-start edge — a filter rail, a table of contents. |
| `end` | `AstryxLayoutPanelSide` | — | The reading-end edge. The default: a details panel about whatever is selected in the body. |


## Related

- [AstryxAppShell](app_shell.md) — the frame around this one.
- [AstryxCenter](center.md) — what `maxContentWidth` uses.
- [Layout](../guides/layout_guide.md) — the guide, for a page with no shell at all.

