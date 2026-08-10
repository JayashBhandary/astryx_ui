---
title: Right-to-left
description: Logical throughout, so RTL is a `Directionality` and nothing more.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

There is no RTL mode to switch on. Every component is written in logical terms — start and end rather than left and right — so wrapping your app in a `Directionality` is the whole of it.

```dart
class ThemingRtlExample extends StatelessWidget {
  const ThemingRtlExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Nothing in the tree below asks about direction. Padding, alignment, icon
    // mirroring, overlay sides and keyboard arrows are all logical.
    return AstryxGrid(
      minWidth: 240,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final direction in TextDirection.values)
          Directionality(
            textDirection: direction,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    direction.name.toUpperCase(),
                    type: AstryxTextType.label,
                  ),
                  AstryxButton(
                    label: 'Next',
                    trailing: const AstryxIcon(AstryxIconName.chevronRight),
                    onPressed: () {},
                  ),
                  AstryxCheckbox(
                    label: 'Label follows the reading edge',
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


```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: const HomePage(),
)
```

**What flips, without being asked**

| Thing | Under RTL |
| --- | --- |
| Padding and alignment | `paddingInline`, `AstryxStackAlign.start`, everything logical. |
| Icons | Directional glyphs mirror — chevrons and arrows do, a calendar does not. |
| Button groups | The "first" child rounds its reading-start corners. |
| Overlay sides | `AstryxOverlaySide.left` and `.right` resolve against the direction. |
| Arrow keys | `→` and `←` swap in tab lists, radio groups, switches and submenus. |
| Toast placement | `bottomEnd` hugs the trailing edge, whichever side that is. |
| Table alignment | `AstryxTableAlignment.end` follows the reading direction. |

> **Note**
>
> The block axis never flips: `top` and `bottom` mean what they say in every locale Astryx supports.

Use the LTR/RTL switch at the top of this page on any component page. Every example on this site is written without a single reference to direction, which is the point — if one of them looks wrong in RTL, that is a bug in the widget, not in the example.

