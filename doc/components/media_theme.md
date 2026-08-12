---
title: AstryxMediaTheme
description: The theme overrides that apply to media surfaces — captions and controls over an image.
component: true
group: Media
source: lib/src/components/media/media_theme.dart
upstream: MediaTheme
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class MediaThemeDemoExample extends StatelessWidget {
  const MediaThemeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // A caption over a picture cannot use the page's text colour: the picture
    // is whatever colour it is. `AstryxMediaTheme` forces the on-dark tokens
    // and puts a scrim behind them.
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Stands in for a photograph.
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.backgroundInverted),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AstryxMediaTheme(
                scrim: AstryxMediaScrim.top,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  mainAxisSize: MainAxisSize.max,
                  justify: AstryxStackJustify.between,
                  children: <Widget>[
                    const AstryxText(
                      '2 of 8',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.inherit,
                    ),
                    AstryxIconButton(
                      icon: AstryxIconName.close,
                      label: 'Close',
                      variant: AstryxButtonVariant.ghost,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: AstryxMediaTheme(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxText(
                      'atlas-scheduler.png',
                      color: AstryxTextColor.inherit,
                    ),
                    AstryxText(
                      'Captured at 14:02, three seconds before the timeout',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.inherit,
                    ),
                  ],
                ),
              ),
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
Stack(
  children: <Widget>[
    Image.network(url, fit: BoxFit.cover),
    Positioned(
      left: 0, right: 0, bottom: 0,
      child: AstryxMediaTheme(child: AstryxText('Atlas, 14:02')),
    ),
  ],
)
```

A caption over a photograph cannot use `--color-text-primary`: the photograph is whatever colour it is, and a near-black caption over a near-black corner is a caption nobody reads. This forces the **on-dark** tokens for its subtree and puts a scrim behind them.

> **Note**
>
> `onDark`, not `textPrimary` inverted by hand. The token exists precisely so "legible on something dark" is one decision the theme owns rather than a guess each caller makes — and a theme that changes it changes this too.

## It does not change the theme

Spacing, radius, type and motion stay exactly as they are. **Only the foreground colours and the ground behind them move**, because those are the only two things a picture underneath can break. A caller’s own tokens keep working, and nothing inside has to be re-specified.

Inside it, use `AstryxTextColor.inherit` and `AstryxIconColor.inherit`: both take the colour set here, which is how a caption and the glyph beside it stay the same shade without either naming it.

## Scrims

| `AstryxMediaScrim` | For |
| --- | --- |
| `bottom` | A caption or a control bar. The default. |
| `top` | A close button or a counter. |
| `full` | Content that covers the picture. |
| `none` | A surface already dark enough — a chart on an inverted ground. |

A scrim rather than a shadow on the text: a drop shadow under white type is a trick that works on some photographs and fails on the rest, and there is no way to tell which from here.

### AstryxMediaTheme

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content drawn over the media. |
| `scrim` | `AstryxMediaScrim` | `AstryxMediaScrim.bottom` | Which scrim to put behind it. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | Inner padding around the child. |


> **Accessibility**
>
> A scrim is what makes the contrast ratio survive a picture nobody has seen yet — and contrast is not optional over media any more than it is over a page. Text that must be read cannot rely on the image being dark in the corner it happens to sit in.

## Related

- [AstryxLightbox](lightbox.md) — the viewer whose bars use it.
- [Colour](../guides/color.md) — where `onDark` sits among the roles.
- [Accessibility](../guides/accessibility.md) — the contrast rules this exists to keep.

