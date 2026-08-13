---
title: AstryxLightbox
description: A full-screen media viewer, navigable between items.
component: true
group: Media
source: lib/src/components/media/lightbox.dart
upstream: Lightbox
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LightboxDemoExample extends StatefulWidget {
  const LightboxDemoExample({super.key});

  @override
  State<LightboxDemoExample> createState() => _LightboxDemoExampleState();
}

class _LightboxDemoExampleState extends State<LightboxDemoExample> {
  final AstryxOverlayController _viewer = AstryxOverlayController();
  int _opened = 0;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  void _open(int index) {
    setState(() => _opened = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Press a thumbnail. The viewer opens on *that* one, pages with the arrow
    // keys, and closes on Escape.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (var i = 0; i < 3; i++)
              AstryxThumbnail(
                label: 'Screenshot ${i + 1}',
                width: 80,
                onPressed: () => _open(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: _viewer,
          initialIndex: _opened,
          items: <AstryxLightboxItem>[
            for (var i = 1; i <= 3; i++)
              AstryxLightboxItem(
                label: 'Screenshot $i',
                caption: 'Screenshot $i — the deploy at 14:0$i',
                child: SizedBox(
                  width: 420,
                  child: AstryxAspectRatio(
                    ratio: 16 / 9,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        'Screenshot $i',
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        AstryxText(
          'Opens on the thumbnail that was pressed — currently '
          '${_opened + 1}. Radius token: '
          '${theme.radius(AstryxRadiusToken.container)}px.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxLightbox(
  controller: _lightbox,
  initialIndex: _tapped,
  items: <AstryxLightboxItem>[
    for (final shot in shots)
      AstryxLightboxItem(label: shot.name, child: Image.network(shot.url)),
  ],
)
```

[AstryxOverlay](overlay.md) for the modal half — the scrim, the focus trap, Escape, the entry animation — with the paging, the counter and the caption on top. A widget in the tree, like every overlay here: it renders nothing until the controller opens it.

It opens on `initialIndex` **every time**, not on whatever was showing when it last closed. A thumbnail grid opens the thumbnail that was pressed, and remembering the previous one would make the second press of the same tile open something else.

A single item drops the paging controls and the counter: "1 of 1" with two dead arrows beside it is three pieces of furniture saying nothing.

| Key | Does |
| --- | --- |
| `←` / `→` | One item. Mirrored under RTL. |
| `Esc` | Closes, and returns focus to what opened it. |

> **Accessibility**
>
> The item’s label is the viewer’s accessible name and the position is its value, so a reader is told what they are looking at and where it sits. The top and bottom bars go through [AstryxMediaTheme](media_theme.md), which is what keeps a caption legible over a photograph of any colour.

### AstryxLightbox

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxOverlayController` | — | Opens and closes the viewer. |
| `items` *(required)* | `List<AstryxLightboxItem>` | — | The items, in order. |
| `initialIndex` | `int` | `0` | Which item to open on. |
| `onIndexChanged` | `ValueChanged<int>?` | — | Called with the item now showing. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls in the top bar beside the close button. |


### AstryxLightboxItem

One item in the viewer.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | What it is. Never optional. |
| `child` *(required)* | `Widget` | — | The media itself. |
| `caption` | `String?` | — | A line under it. |


## Related

- [AstryxThumbnail](thumbnail.md) — what usually opens it.
- [AstryxOverlay](overlay.md) — the layer underneath, and its contract.
- [AstryxMediaTheme](media_theme.md) — how its bars stay readable.

---

Something wrong with `AstryxLightbox`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxLightbox&component=AstryxLightbox) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxLightbox&area=AstryxLightbox) — both templates arrive with the component filled in.
