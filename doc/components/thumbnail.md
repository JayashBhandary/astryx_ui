---
title: AstryxThumbnail
description: A small fixed-ratio preview of an image or file.
component: true
group: Media
source: lib/src/components/media/thumbnail.dart
upstream: Thumbnail
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ThumbnailDemoExample extends StatefulWidget {
  const ThumbnailDemoExample({super.key});

  @override
  State<ThumbnailDemoExample> createState() => _ThumbnailDemoExampleState();
}

class _ThumbnailDemoExampleState extends State<ThumbnailDemoExample> {
  static const List<({String label, AstryxIconName icon})> _files =
      <({String label, AstryxIconName icon})>[
        (label: 'atlas-scheduler.png', icon: AstryxIconName.copy),
        (label: 'deploy-log.txt', icon: AstryxIconName.copy),
        (label: 'metrics.csv', icon: AstryxIconName.viewColumns),
        (label: 'runbook.md', icon: AstryxIconName.copy),
      ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    // Nothing here can be previewed, so every tile falls back to a glyph and
    // leans on its name — which is why the name is required.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (var i = 0; i < _files.length; i++)
          AstryxThumbnail(
            label: _files[i].label,
            icon: _files[i].icon,
            showCaption: true,
            selected: i == _selected,
            onPressed: () => setState(() => _selected = i),
          ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxThumbnail(
  label: 'atlas-scheduler.png',
  image: NetworkImage(file.url),
  onPressed: () => _lightbox.show(),
)
```

An [AstryxAspectRatio](aspect_ratio.md) with a picture in it, a glyph when there is no picture, and an optional caption — which covers the two cases a thumbnail actually has: something that can be shown, and something that can only be named.

> **Accessibility**
>
> **`label` is required**, for the same reason an avatar’s `name` is: a wall of thumbnails with no names is a wall of unlabelled images, and a failed load is a grey square with nothing to say for itself. `selected` is announced as well as ringed — a ring alone is invisible to a screen reader and to anybody who cannot separate the hues.

A file that cannot be previewed gets a glyph rather than a rendering of its first page: a PDF, a spreadsheet and a log are all "a file with a name" at 96 pixels, and a picture nobody can read at that size is worse than an honest icon.

`showCaption` is off by default. In a grid the names are usually beside the grid, and a caption under every tile doubles the wall’s height; turn it on for a thumbnail standing on its own.

### AstryxThumbnail

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | What this is a picture of. The accessible name, and the caption. |
| `image` | `ImageProvider?` | — | The picture, if there is one. |
| `icon` | `AstryxIconName?` | — | A glyph for a file that cannot be previewed. |
| `ratio` | `double` | `1` | Width over height. |
| `width` | `double` | `96` | How wide the tile is. |
| `showCaption` | `bool` | `false` | Whether to draw the label under the picture. |
| `selected` | `bool` | `false` | Whether this is the chosen one in a set. |
| `onPressed` | `VoidCallback?` | — | Usually opens a lightbox. |


## Related

- [AstryxLightbox](lightbox.md) — what a thumbnail usually opens.
- [AstryxAspectRatio](aspect_ratio.md) — the box underneath it.
- [AstryxFileInput](file_input.md) — choosing the files these preview.

