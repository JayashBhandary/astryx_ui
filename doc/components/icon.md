---
title: AstryxIcon
description: A glyph named semantically and resolved through the theme.
component: true
group: Layout & typography
source: lib/src/components/layout/icon.dart
upstream: Icon
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class IconDemoExample extends StatelessWidget {
  const IconDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success),
        AstryxText('Deployment finished'),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success)
```

An icon is named by *meaning*, not by glyph: `AstryxIconName.success`, not `check-circle`. The theme’s registry maps names to glyphs — Lucide by default, matching upstream — so swapping icon sets is a theme change rather than a hundred call-site edits.

## Sizes

Four steps. A null `size` inherits from the enclosing `IconTheme`, which is how a button sizes the icons in its slots — and why a spinner replacing one cannot shift the layout.

```dart
class IconSizesExample extends StatelessWidget {
  const IconSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxIconSize.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxIcon(AstryxIconName.calendar, size: size),
              AstryxText(
                '${size.name} · ${size.pixels.toInt()}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
```


## Colours

`inherit` — the default — takes the colour from the enclosing text style. That is what an icon inside a button or a coloured banner wants.

```dart
class IconColorsExample extends StatelessWidget {
  const IconColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final color in AstryxIconColor.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxIcon(AstryxIconName.info, color: color),
              AstryxText(color.name, type: AstryxTextType.supporting),
            ],
          ),
      ],
    );
  }
}
```


## Decorative or meaningful

Leave `label` null for an icon beside text that already says the same thing: the icon is then hidden from assistive technology rather than announced as an unnamed image. Set it when the icon is the only thing carrying the meaning.

```dart
class IconLabelledExample extends StatelessWidget {
  const IconLabelledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // Decorative: no label, so assistive technology skips it entirely.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxIcon(AstryxIconName.clock),
            AstryxText('Pending review'),
          ],
        ),
        // Meaningful on its own: it needs a name, because nothing else in the
        // row says what it means.
        AstryxIcon(
          AstryxIconName.warning,
          color: AstryxIconColor.warning,
          label: 'Quota nearly reached',
        ),
      ],
    );
  }
}
```


## The registry

The 28 names the default registry knows. An application needing "edit" or "delete" passes any icon widget instead — every slot that takes an icon takes a `Widget`, precisely so the registry does not have to grow to cover every product.

```dart
class IconRegistryExample extends StatelessWidget {
  const IconRegistryExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every semantic name the default registry knows. A theme can swap the
    // glyphs behind these names without a single call site changing.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final name in AstryxIconName.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxIcon(name, size: AstryxIconSize.sm),
              Flexible(
                child: AstryxText(
                  name.name,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


## RTL

Directional glyphs mirror under RTL automatically — chevrons and arrows do, a calendar does not. `mirrorForRtl` overrides that decision for a custom registry whose glyph points a different way.

### AstryxIcon

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` *(required)* | `AstryxIconName` | — | The semantic name. The positional first argument. |
| `size` | `AstryxIconSize?` | — | The size step. Null inherits from the enclosing `IconTheme`, then falls back to `md`. |
| `color` | `AstryxIconColor` | `AstryxIconColor.inherit` | The semantic colour. |
| `label` | `String?` | — | An accessible name. Null — the default — marks the icon decorative. |
| `mirrorForRtl` | `bool?` | — | Overrides whether the glyph mirrors under RTL. |
| `theme` | `AstryxIconTheme?` | — | Visual overrides, merged over `AstryxThemeData.icon`. |


## Related

- [AstryxIconButton](icon_button.md) — an icon that does something.
- [Theming](../guides/theming.md) — how to install a different registry.

---

Something wrong with `AstryxIcon`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxIcon&component=AstryxIcon) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxIcon&area=AstryxIcon) — both templates arrive with the component filled in.
