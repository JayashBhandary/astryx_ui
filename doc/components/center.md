---
title: AstryxCenter
description: Centres a child, with token padding and a measure.
component: true
group: Layout & typography
source: lib/src/components/layout/center.dart
upstream: Center
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CenterDemoExample extends StatelessWidget {
  const CenterDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      minHeight: 200,
      padding: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxIcon(
            AstryxIconName.search,
            size: AstryxIconSize.lg,
            color: AstryxIconColor.secondary,
          ),
          const AstryxHeading('No projects yet', level: 4),
          const AstryxText(
            'Create one to start collecting requests.',
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          AstryxButton(
            label: 'New project',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxCenter(
  minHeight: 200,
  padding: AstryxSpacingToken.spacing6,
  child: emptyState,
)
```

The empty-state box, mostly. `minHeight` stops it collapsing to the height of its message, and the padding parameters are logical: `paddingInline` flips under RTL, `paddingBlock` does not.

## Axis

```dart
class CenterAxisExample extends StatelessWidget {
  const CenterAxisExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final axis in AstryxCenterAxis.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(axis.name, type: AstryxTextType.label),
              SizedBox(
                height: 72,
                child: AstryxCard(
                  variant: AstryxCardVariant.muted,
                  padding: AstryxSpacingToken.spacing2,
                  child: AstryxCenter(
                    axis: axis,
                    child: const AstryxBadge('content'),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


## Measure

`maxWidth` is what keeps centred prose readable on a wide display: the box centres, the line length stays put.

```dart
class CenterMeasureExample extends StatelessWidget {
  const CenterMeasureExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `maxWidth` is what keeps a centred column of prose readable on a wide
    // display: the box centres, the measure stays put.
    return const AstryxCenter(
      maxWidth: 360,
      paddingBlock: AstryxSpacingToken.spacing4,
      child: AstryxText(
        'A line length of roughly sixty to seventy characters is comfortable '
        'to read. A centring box with no ceiling on its width gives you the '
        'window instead, which is not the same thing.',
        justify: AstryxTextJustify.center,
      ),
    );
  }
}
```


### AstryxCenter

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The widget to centre. |
| `axis` | `AstryxCenterAxis` | `AstryxCenterAxis.both` | Which axes to centre on. |
| `padding` | `AstryxSpacingToken?` | — | Padding on every side. The two axis-specific values override it. |
| `paddingInline` | `AstryxSpacingToken?` | — | Padding on the inline axis — start and end, so it flips under RTL. |
| `paddingBlock` | `AstryxSpacingToken?` | — | Padding on the block axis — top and bottom. |
| `width` | `double?` | — | A fixed width. |
| `height` | `double?` | — | A fixed height. |
| `maxWidth` | `double?` | — | A ceiling on the width, for a centred column of text. |
| `minHeight` | `double?` | — | A floor under the height, so an empty state does not collapse. |


## Related

- [AstryxHStack & AstryxVStack](stack.md) — for more than one child.
- [AstryxTable](table.md) — whose `emptyState` this usually holds.

---

Something wrong with `AstryxCenter`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCenter&component=AstryxCenter) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCenter&area=AstryxCenter) — both templates arrive with the component filled in.
