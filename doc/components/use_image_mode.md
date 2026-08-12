---
title: useImageMode → the resolved mode
description: Choosing the light or dark variant of an image.
component: true
group: Hooks & controllers
upstream: useImageMode
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream needs a hook because CSS cannot swap an `<img src>` on a media query without duplicating the element. Flutter can just pick, and the resolved mode is already in scope — so this is one line and there is no widget to port.

```dart
class HookImageModeExample extends StatelessWidget {
  const HookImageModeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final dark = theme.mode == AstryxThemeMode.dark;

    // One line, and it subscribes: switch the docs between light and dark and
    // this swaps with it, with nothing else wired up. Stand-ins for two real
    // assets — `Image.asset(dark ? 'logo_dark.png' : 'logo_light.png')`.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        Container(
          width: 200,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.color(
              dark
                  ? AstryxColorToken.backgroundInverted
                  : AstryxColorToken.backgroundMuted,
            ),
            borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            border: Border.all(
              color: theme.color(AstryxColorToken.border),
              width: theme.borderWidth(),
            ),
          ),
          child: AstryxText(
            dark ? 'the dark lockup' : 'the light lockup',
            color: AstryxTextColor.inherit,
            style: TextStyle(
              color: theme.color(
                dark ? AstryxColorToken.onDark : AstryxColorToken.textPrimary,
              ),
            ),
          ),
        ),
        const AstryxText(
          'Both variants take the same semantic label: they are the same '
          'picture.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


```dart
final dark = AstryxTheme.of(context).mode == AstryxThemeMode.dark;

Image.asset(dark ? 'assets/logo_dark.png' : 'assets/logo_light.png')
```

`AstryxThemeData.brightness` is the same answer as a Flutter `Brightness`, for an API that wants one. Both **subscribe**: a widget that reads either rebuilds when the mode changes, so an asset swapped this way follows a system theme change with nothing else wired up.

> **Careful**
>
> Reach for two assets only when the image genuinely has two versions — a logo with a light and a dark lockup, a diagram with dark ink. A photograph does not, and inverting one is a worse result than leaving it alone. For an icon, use `AstryxIcon`: it takes its colour from the theme already, so there is nothing to swap.

> **Accessibility**
>
> Both variants of an image are the same picture, so both take the **same** `semanticLabel`. And whatever the image conveys must survive it being unavailable: a diagram carrying information no caption repeats is information a screen-reader user does not have.

## Related

- [useTheme](use_theme.md) — everything else the resolved theme carries.
- [Colour](../guides/color.md) — the semantic roles, which almost always beat swapping an asset.
- [Illustrations](../guides/illustrations.md) — the upstream set, and what a port would need.

