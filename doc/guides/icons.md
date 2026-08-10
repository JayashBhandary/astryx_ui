---
title: Icons
description: The icon registry, the Lucide mapping, and how to supply your own set.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

An icon is asked for by **meaning**, never by picture: `AstryxIconName.success`, not `circle-check`. The 28 names are a contract between the components and the theme — the component says what it means, the registry decides what that looks like, and swapping icon sets is one line rather than a hundred call sites.

```dart
class IconsRegistrySwapExample extends StatelessWidget {
  const IconsRegistrySwapExample({super.key});

  /// Built from the defaults, so the 25 names not listed still resolve.
  static final AstryxIconRegistry _custom = AstryxIconRegistry.defaults
      .copyWith(const <AstryxIconName, IconData>{
        AstryxIconName.close: LucideIcons.circleX,
        AstryxIconName.check: LucideIcons.badgeCheck,
        AstryxIconName.chevronRight: LucideIcons.arrowRight,
      });

  static const List<AstryxIconName> _shown = <AstryxIconName>[
    AstryxIconName.close,
    AstryxIconName.check,
    AstryxIconName.chevronRight,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (title, registry) in <(String, AstryxIconRegistry)>[
          ('AstryxIconRegistry.defaults', AstryxIconRegistry.defaults),
          ('defaults.copyWith(…)', _custom),
        ])
          // `AstryxTheme` rather than a nested provider: this swaps the
          // registry and inherits everything else, so the theme and density
          // pickers above still reach the icons below.
          AstryxTheme(
            data: AstryxTheme.of(context),
            density: AstryxTheme.densityOf(context),
            icons: registry,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    title,
                    type: AstryxTextType.code,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing4,
                    children: <Widget>[
                      for (final name in _shown)
                        AstryxIcon(name, size: AstryxIconSize.lg),
                    ],
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


## The default registry

`AstryxIconRegistry.defaults` maps every name onto [Lucide](https://lucide.dev), which is what upstream uses. All seven prebuilt themes ship the same mapping — a fact a test pins, so a future theme that diverges is caught rather than silently flattened.

The 28 names, live, are on the [AstryxIcon](../components/icon.md) page. They cover what the widget set itself needs — a close button, a chevron, a sort arrow, the four status glyphs — and deliberately stop there.

## Installing your own

```dart
AstryxThemeProvider(
  icons: AstryxIconRegistry.defaults.copyWith(
    const <AstryxIconName, IconData>{
      AstryxIconName.close: MyIcons.close,
      AstryxIconName.check: MyIcons.check,
    },
  ),
  child: const HomePage(),
)
```

> **Careful**
>
> Build from `defaults` unless you mean to replace the whole set. A registry is installed wholesale, not merged: `AstryxIconRegistry(icons: {…})` with two entries has exactly two, and the twenty-six names it omits throw a `StateError` when something asks for one. `isComplete` answers whether a registry covers every name.

A missing name throws rather than painting nothing on purpose — an icon that silently disappears is a theme bug you find in production, and the error names the gap.

## Icons the registry does not name

Do not widen the registry for "edit" or "delete". Every slot that takes an icon takes a `Widget`, so an application uses its own icon family directly and keeps `AstryxIconName` as the transcription of upstream’s own union that it is.

```dart
AstryxButton(
  label: 'Delete',
  leading: const Icon(MyIcons.trash),
  variant: AstryxButtonVariant.destructive,
  onPressed: confirmDelete,
)
```

## Direction

Five names mirror under RTL — the four chevrons and `externalLink` — and the rest do not. The set is explicit rather than inferred, because each of the exceptions is a plausible mistake: sort arrows are on the block axis, a clock runs clockwise in every locale, a tick is a glyph rather than a direction, and a mirrored magnifier just reads as a bug.

```dart
class IconsMirroringExample extends StatelessWidget {
  const IconsMirroringExample({super.key});

  /// Two that mirror, and two that deliberately do not.
  static const List<(AstryxIconName, String)> _cases =
      <(AstryxIconName, String)>[
        (AstryxIconName.chevronRight, 'mirrors'),
        (AstryxIconName.externalLink, 'mirrors'),
        (AstryxIconName.arrowUp, 'block axis — never flips'),
        (AstryxIconName.clock, 'an object — never flips'),
      ];

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, note) in _cases)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(name.name, type: AstryxTextType.code, maxLines: 1),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing4,
                  children: <Widget>[
                    for (final direction in TextDirection.values)
                      AstryxHStack(
                        gap: AstryxSpacingToken.spacing1,
                        children: <Widget>[
                          AstryxText(
                            direction.name,
                            type: AstryxTextType.supporting,
                            color: AstryxTextColor.secondary,
                          ),
                          Directionality(
                            textDirection: direction,
                            child: AstryxIcon(name),
                          ),
                        ],
                      ),
                  ],
                ),
                AstryxText(
                  note,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```


`mirrorForRtl` overrides the decision for one icon — for a custom registry whose glyph points the other way, or a name whose meaning in your product is directional when the default set says it is not.

## Size and colour

Both are inherited by default: a null `size` takes the enclosing `IconTheme`’s, and `AstryxIconColor.inherit` takes the surrounding text colour. That is what lets a button, a badge or a disabled menu row tint an icon it did not build — including one you supplied. See [AstryxIcon](../components/icon.md) for the four sizes and nine colours.

## Related

- [AstryxIcon](../components/icon.md) — the component, and every name it knows.
- [AstryxIconButton](../components/icon_button.md) — an icon that does something.
- [Theming](theming.md) — where the registry sits among the other theme inputs.

