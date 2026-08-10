---
title: Elevation
description: The elevation levels, what each is for, and how they read in dark mode.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Eight shadow tokens: three drop shadows that lift a surface off the page, and five inset shadows that ring a control without moving it. Elevation here is a *height above the page*, and the height is decided by what the surface is — not by how much attention it wants.

```dart
class ElevationShadowsExample extends StatelessWidget {
  const ElevationShadowsExample({super.key});

  /// The three drop shadows, and what sits at each.
  static const List<(AstryxShadowToken, String)> _steps =
      <(AstryxShadowToken, String)>[
        (AstryxShadowToken.low, 'popover, tooltip, menu'),
        (AstryxShadowToken.med, 'toast, selector list'),
        (AstryxShadowToken.high, 'dialog'),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        for (final (token, uses) in _steps)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundPopover),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              boxShadow: theme.boxShadows(token),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing4),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(token.name, type: AstryxTextType.label),
                  AstryxText(
                    uses,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```


| Token | Where it is used |
| --- | --- |
| `low` | The default overlay surface — popovers, tooltips, dropdown menus. |
| `med` | Toasts, and the floating list a selector opens. |
| `high` | Dialogs, the only thing above everything else. |
| `insetHover`, `insetSelected` | A ring on a control that is hovered or chosen. No lift. |
| `insetSuccess`, `insetWarning`, `insetError` | A field’s validation state, drawn as a ring around the input. |

An inset shadow is how a control shows state without changing size: a ring painted inside the border box moves nothing around it, so a form does not shift when a field turns red.

## On a component

`AstryxButton` and `AstryxIconButton` are the two that take an elevation directly — a floating action needs it. Everything else picks its own from what it is: a dialog is `high` because it is a dialog.

```dart
class ElevationButtonExample extends StatelessWidget {
  const ElevationButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The one component that takes an elevation directly. Everything else
    // decides its own from what it is.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxButton(
            label: elevation.name,
            variant: AstryxButtonVariant.secondary,
            elevation: elevation,
            onPressed: () {},
          ),
      ],
    );
  }
}
```


```dart
AstryxButton(
  label: 'Compose',
  elevation: AstryxElevation.high,
  onPressed: compose,
)

// Anywhere else:
final theme = AstryxTheme.of(context);
final shadows = theme.boxShadows(AstryxShadowToken.med);
```

## Dark mode

A shadow is a `light-dark()` pair like every other colour value, and the dark half is *stronger*, not weaker — the alphas go from 0.1 to 0.2 and 0.3. On a dark page a faint shadow disappears, so the same shadow that separates a dialog from a white page would leave it floating in nothing.

> **Note**
>
> Shadow is a separation cue, never the only one. Every elevated surface in the package also carries a background and a border, because a shadow is invisible to a screen reader, thin at high contrast, and nearly gone on a low-quality display.

## Related

- [Shape](shape.md) — the corners those surfaces are cut with.
- [AstryxPopover](../components/popover.md) — the `low` surface in use.
- [AstryxDialog](../components/dialog.md) — the `high` one.

