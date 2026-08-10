---
title: Density
description: One widget set that is honest on a mouse and on a thumb.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Astryx targets pointer and touch equally. The density is resolved from the platform *and* the pointer precision `MediaQuery` reports — which matters on the web, where the reported platform is the host OS rather than the input device: a Chromebook with a mouse attached reports Android, and a Windows tablet without one reports Windows.

```dart
class ThemingDensityExample extends StatelessWidget {
  const ThemingDensityExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Touch density raises every tap target to 48px and suppresses hover-only
    // affordances. The control's painted height does not change — the region
    // that responds to a finger does.
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final density in AstryxDensity.values)
          AstryxThemeProvider(
            density: density,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    '${density.name} · min target '
                    '${density.minimumTapTarget.toInt()}px',
                    type: AstryxTextType.label,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxButton(label: 'Save', onPressed: () {}),
                      AstryxIconButton(
                        icon: AstryxIconName.copy,
                        label: 'Copy',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  AstryxCheckbox(
                    label: 'Also a target',
                    value: true,
                    onChanged: (_) {},
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


|   | `pointer` | `touch` |
| --- | --- | --- |
| Minimum tap target | the control’s own height | 48px |
| Hover affordances | active | suppressed |
| Default toast position | a corner | the bottom |

Note what does **not** change: the control’s painted height. Touch density grows the region that responds to a finger, not the button — so a form does not reflow when someone plugs in a mouse.

## Overriding it

```dart
AstryxThemeProvider(
  density: AstryxDensity.touch,
  child: const HomePage(),
)
```

Leave it null to follow the platform, which is what an application should normally do. The density picker at the top of this page has an `auto` setting for exactly that.

## Reading it

Gate every hover style on `supportsHover`, never on the platform: a widget on a touch device must not offer a state the user cannot reach.

```dart
final density = AstryxTheme.densityOf(context);

if (density.supportsHover && _hovered) {
  // …hover styling.
}
```

> **Careful**
>
> Nothing important may live behind hover alone. That is why [table](../components/table.md) row actions are always visible, and why a [tooltip](../components/tooltip.md) may never be the only place a piece of information appears.

48px is the strictest of the three guidelines that apply — Apple’s HIG and WCAG 2.5.5 both say 44, Material says 48. Meeting the strictest means one number satisfies every platform, rather than a control that passes on iOS and fails on Android.

