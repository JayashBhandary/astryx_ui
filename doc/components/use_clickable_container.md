---
title: useClickableContainer → onPressed
description: Making a container behave as one control without nesting interactive elements.
component: true
group: Hooks & controllers
source: lib/src/components/surface/card.dart
upstream: useClickableContainer
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream needs a hook because a `<div>` is not a button: making one behave like one means adding a role, a tab index, key handlers, and the hover and press styling by hand. Here it is a parameter. **A non-null `onPressed` makes the container a button** — hover, press, a focus ring, `Semantics(button: true)` and the tap-target guarantee, all of it.

```dart
class HookClickableContainerExample extends StatefulWidget {
  const HookClickableContainerExample({super.key});

  @override
  State<HookClickableContainerExample> createState() =>
      _HookClickableContainerExampleState();
}

class _HookClickableContainerExampleState
    extends State<HookClickableContainerExample> {
  String _last = 'Nothing pressed';

  @override
  Widget build(BuildContext context) {
    // A non-null `onPressed` makes the whole card one button: hover, press, a
    // focus ring, `Semantics(button: true)` and the tap-target guarantee. What
    // it must *not* contain is another control — a button inside a button is a
    // node a screen reader cannot describe and a keyboard cannot reach twice.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          semanticsLabel: 'Atlas scheduler',
          onPressed: () => setState(() => _last = 'Opened Atlas scheduler'),
          child: const AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxHeading(
                'Atlas scheduler',
                type: AstryxHeadingType.display3,
              ),
              AstryxText('Runs every fifteen minutes'),
            ],
          ),
        ),
        AstryxList(
          children: <Widget>[
            AstryxItem(
              label: 'Deploy log',
              description: 'The row is the control, not a link inside it',
              onPressed: () => setState(() => _last = 'Opened the deploy log'),
            ),
          ],
        ),
        AstryxText(
          _last,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


| A pressable… | Is |
| --- | --- |
| surface | `AstryxCard(onPressed:, semanticsLabel:)` |
| row | `AstryxItem(onPressed:)` |
| card that carries selection | `AstryxSelectableCard` — a *control*, announced as a checkbox or a radio, reporting a selection rather than a press |
| band of controls | `AstryxToolbar` — one tab stop |

> **Careful**
>
> **There is no `ClickableCard`.** One card, with a parameter — because two widgets that differ only in whether they respond to a press are two widgets that drift apart on padding, radius and focus.

## One control, not two

The rule the hook exists to enforce: **a pressable container must not contain another control.** A button inside a button is a node assistive technology cannot describe and a keyboard cannot reach twice, and the press that lands is a coin toss.

- Row actions belong *beside* the row, in a cell of their own — which is what `AstryxTable.rowActionsBuilder` is for.
- A card with a menu in its corner should not itself be pressable: put the navigation on a link or a title inside it.
- A checkbox and a pressable card are the same gesture competing. Use `AstryxSelectableCard`, which is that gesture done once.

## Building your own

For a surface this package has no widget for, three primitives are the whole of it — and the nesting order is not optional:

```dart
AstryxSemanticsButton(        // outer: the node, with the label
  label: 'Open the deploy log',
  onPressed: _open,
  child: AstryxTapTarget(     // inner: the 48px hit region on touch
    child: GestureDetector(onTap: _open, child: surface),
  ),
)
```

Nested the other way the semantics node keeps the child’s small bounds, so assistive technology still sees a 20×20 target however large the hit region is: the pointer works and the accessibility guarantee silently does not. State goes through `AstryxStatesController`, which suppresses hover on touch so a tap does not leave the surface looking hovered.

> **Accessibility**
>
> A pressable container needs a name of its own — `semanticsLabel` on a card — because its content is a heading, a paragraph and a badge, and a reader announcing all three as the button’s name is not a label. Hover styling is gated on `AstryxTheme.densityOf(context).supportsHover`, so nothing lives behind a hover a touch user cannot perform.

## Related

- [AstryxCard](card.md) — the surface, pressable or not.
- [AstryxSelectableCard](selectable_card.md) — the selection-carrying form.
- [AstryxItem](item.md) — the row the lists are built from.
- [Accessibility](../guides/accessibility.md) — the nesting rule, in context.

