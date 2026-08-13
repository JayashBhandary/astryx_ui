---
title: useMediaQuery → MediaQuery
description: Responding to viewport size, pointer, and motion preference.
component: true
group: Hooks & controllers
upstream: useMediaQuery
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream’s hook wraps `window.matchMedia`. Flutter’s `MediaQuery` covers the same ground, and the package has already resolved the three media features it depends on — so most of the time the answer is not a media query at all.

| CSS | Here |
| --- | --- |
| `@media (min-width: …)` | `LayoutBuilder`, or `MediaQuery.sizeOf(context)` |
| `@media (hover: hover)` | `AstryxTheme.densityOf(context).supportsHover` |
| `@media (pointer: coarse)` | `AstryxTheme.densityOf(context)`, and `.minimumTapTarget` |
| `@media (prefers-reduced-motion)` | `AstryxMotionAccess.animate(context)` |
| `@media (prefers-color-scheme)` | `AstryxColorMode.system`, resolved by the provider |

## Width: ask the box, not the window

**`LayoutBuilder` before `MediaQuery`.** "How wide is the window" is rarely the question a component has; "how much room do *I* have" is — and the two differ the moment the component sits inside a panel, a split view, or a dialog. A layout that reads the window is a layout that breaks the first time it is reused somewhere narrower.

```dart
class HookMediaQueryExample extends StatelessWidget {
  const HookMediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `LayoutBuilder` answers "how much room do *I* have" — the question a
    // component actually has. `MediaQuery` answers "how big is the window",
    // which is a different one, and the wrong one inside a panel.
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 420;

        return AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxBanner(
              status: narrow
                  ? AstryxBannerStatus.warning
                  : AstryxBannerStatus.info,
              title: narrow
                  ? 'Narrow: ${constraints.maxWidth.round()}px'
                  : 'Wide: ${constraints.maxWidth.round()}px',
              description:
                  'Drag the window. The threshold is a number this example '
                  'chose, not an entry in a breakpoint table.',
            ),
            if (narrow)
              const AstryxText('Stacked, because there is no room beside.')
            else
              const AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                children: <Widget>[
                  AstryxBadge('Side by side'),
                  AstryxBadge('While it fits'),
                ],
              ),
          ],
        );
      },
    );
  }
}
```


## There is no breakpoint table

On purpose. The width at which *your* navigation stops fitting is a fact about your navigation, and a global table means every screen has to agree about a number none of them chose. So the thresholds that exist are properties: `AstryxAppShell.compactBelow`, `AstryxGrid.minWidth`, `AstryxOverflowList`’s own measurement.

```dart
AstryxAppShell(
  compactBelow: 900,   // your number, on your screen
  sidebar: const NavRail(),
  child: page,
)

AstryxGrid(
  minWidth: 240,       // as many columns as fit, no query at all
  children: tiles,
)
```

> **Note**
>
> Reduced motion is the one media feature you should almost never read yourself: every Astryx animation already honours it through `AstryxMotion`. Read `AstryxMotionAccess.animate` only for an animation you wrote by hand.

## Related

- [Layout](../guides/layout_guide.md) — the page structure these questions are about.
- [Density](../guides/density.md) — the pointer and hover answers, resolved once.
- [Motion](../guides/motion.md) — what must not move when motion is reduced.
- [AstryxAppShell](app_shell.md) — where a width threshold actually lives.

---

Something wrong with `useMediaQuery → MediaQuery`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useMediaQuery+%E2%86%92+MediaQuery&component=useMediaQuery+%E2%86%92+MediaQuery) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useMediaQuery+%E2%86%92+MediaQuery&area=useMediaQuery+%E2%86%92+MediaQuery) — both templates arrive with the component filled in.
