---
title: Layout
description: 'Page structure: the shell, the content column, and the breakpoints between them.'
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

There is no page widget. A screen is assembled from the same four primitives a card is — a measure, a column of sections, a row for a header, a grid for tiles — which is why there is nothing to learn here beyond where each one belongs.

```dart
class LayoutPageExample extends StatelessWidget {
  const LayoutPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A screen is a measure, a column of sections, and a grid inside one of
    // them. There is no page widget to learn: the same four layout primitives
    // that build a card build the page around it.
    return AstryxCenter(
      axis: AstryxCenterAxis.horizontal,
      maxWidth: 760,
      paddingBlock: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing6,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            mainAxisSize: MainAxisSize.max,
            justify: AstryxStackJustify.between,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              const Flexible(
                child: AstryxHeading('Environments', level: 1),
              ),
              AstryxButton(
                label: 'New environment',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
            ],
          ),
          const AstryxDivider(),
          AstryxGrid(
            minWidth: 200,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              for (final (name, status) in const <(String, String)>[
                ('production', 'healthy'),
                ('staging', 'degraded'),
                ('preview', 'healthy'),
              ])
                AstryxCard(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxText(name, type: AstryxTextType.label),
                      AstryxBadge(
                        status,
                        variant: status == 'healthy'
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.warning,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
```


| Primitive | Its job on a page |
| --- | --- |
| [AstryxCenter](../components/center.md) | The measure. `maxWidth` stops a line of text running the width of a monitor; `paddingBlock` gives the page air. |
| [AstryxVStack](../components/stack.md) | The sections, with one `gap` doing the grouping. |
| [AstryxHStack](../components/stack.md) | A header row. `mainAxisSize: MainAxisSize.max` with `justify: between` pushes the actions to the trailing edge. |
| [AstryxGrid](../components/grid.md) | Tiles. `minWidth` sets the column count from the space available. |
| [AstryxDivider](../components/divider.md) | A rule where a gap alone is not enough. |

## Responsive without breakpoints

There is no breakpoint system, and that is deliberate. `AstryxGrid` takes a `minWidth` and works out its own column count — `repeat(auto-fit, minmax(…, 1fr))`, in CSS terms — so most responsive behaviour needs no threshold at all.

Where a layout genuinely has to change shape, use a `LayoutBuilder` and a number that lives beside the widget that needs it. A form knows the width it wants; a global breakpoint table means every screen has to agree about a number none of them chose.

```dart
// From the two-column form template.
const double formTwoColumnMinWidth = 620;

LayoutBuilder(
  builder: (context, constraints) => constraints.maxWidth < formTwoColumnMinWidth
      ? _oneColumn()
      : _twoColumns(),
)
```

> **Note**
>
> Every example on this site has a device picker above it for the same reason: a responsive decision is only judged by making the constraints smaller, not by reading the code.

## The vertical rhythm

Section gaps come from the spacing scale like everything else — `spacing6` and up between the parts of a page, `spacing3` inside a group. Set the gap on the stack rather than padding the children, and a reordered section keeps the rhythm.

## The frame around the page

Everything above is a page with nothing around it. An application has a frame too: [AstryxAppShell](../components/app_shell.md) for the window — the header, the navigation, and what happens to the navigation when the window is narrow — and [AstryxLayout](../components/layout.md) for the page inside it, whose header and footer stay put while the body scrolls.

Neither introduces a breakpoint table. `AstryxAppShell.compactBelow` is the same kind of number as the one beside the two-column form above: one threshold, owned by the widget that needs it.

## What is not here yet

Upstream’s layout page also covers the navigation itself — the nav bar, the rail, the breadcrumb trail above the content. Those carry the *Soon* badge under **Navigation** in the sidebar. Until they land, the shell’s `header` and `sidebar` take any widget, and an [AstryxList](../components/list.md) of [AstryxItem](../components/item.md)s gets a long way.

## Related

- [AstryxAppShell](../components/app_shell.md) — the frame around the whole application.
- [Spacing](spacing.md) — the scale the gaps come from.
- [Dashboard](../components/dashboard.md) — a whole screen, assembled.
- [Two-column form](../components/form_two_column.md) — the `LayoutBuilder` pattern in full.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+Layout&component=Docs%3A+Layout) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+Layout&area=Docs%3A+Layout) — both templates arrive with the page filled in.
