---
title: AstryxIconButton
description: A square button holding a glyph instead of words.
component: true
group: Actions
source: lib/src/components/action/icon_button.dart
upstream: IconButton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class IconButtonDemoExample extends StatelessWidget {
  const IconButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.search,
          label: 'Search',
          tooltip: 'Search',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.funnel,
          label: 'Filter',
          tooltip: 'Filter',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.moreHorizontal,
          label: 'More actions',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxIconButton(
  icon: AstryxIconName.search,
  label: 'Search',
  tooltip: 'Search',
  onPressed: () => openSearch(),
)
```

> **Accessibility**
>
> `label` is **required**, and it is not the tooltip. A glyph has no accessible name of its own, so without a label the button is announced as "button" and nothing more. `tooltip` is the sighted-user version of the same information, and it is optional.

When both are set the tooltip is left out of the semantics tree — hearing "Archive, Archive" is worse than not hearing the tooltip at all. Set `tooltip` to something the label does not already say if you want it announced.

## Variants

The same four as [AstryxButton](button.md). `ghost` is the usual choice for a toolbar or a row action, where a filled square in every row is noise.

```dart
class IconButtonVariantsExample extends StatelessWidget {
  const IconButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        for (final variant in AstryxButtonVariant.values)
          AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Approve (${variant.name})',
            variant: variant,
            onPressed: () {},
          ),
      ],
    );
  }
}
```


## Sizes

The three control heights, square. The glyph does not step in lockstep with the height: `sm` and `md` both take the 16px icon, `lg` takes 20px — upstream figures, kept.

```dart
class IconButtonSizesExample extends StatelessWidget {
  const IconButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxButtonSize.values)
          AstryxIconButton(
            icon: AstryxIconName.copy,
            label: 'Copy (${size.name})',
            size: size,
            onPressed: () {},
          ),
      ],
    );
  }
}
```


## Custom content

The default constructor goes through the icon registry, so a theme can swap every glyph in the app. `AstryxIconButton.custom` takes any widget instead — an avatar, a flag, a brand mark.

```dart
class IconButtonCustomExample extends StatelessWidget {
  const IconButtonCustomExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // `.custom` takes any widget — an avatar, a flag, a brand glyph. The
    // registry covers 28 semantic names; an application always needs more.
    return AstryxIconButton.custom(
      label: 'Ada Lovelace — account menu',
      variant: AstryxButtonVariant.ghost,
      onPressed: () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.color(AstryxColorToken.backgroundPurple),
          borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: AstryxText(
              'AL',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.inherit,
            ),
          ),
        ),
      ),
    );
  }
}
```


## States

```dart
class IconButtonStatesExample extends StatelessWidget {
  const IconButtonStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.stop,
          label: 'Stop the run',
          loading: true,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.eyeSlash,
          label: 'Hide column',
          enabled: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
```


### AstryxIconButton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `icon` | `AstryxIconName?` | — | The semantic name, resolved through the theme’s registry. Required for the default constructor. |
| `child` | `Widget?` | — | The custom content, for `AstryxIconButton.custom`. |
| `label` *(required)* | `String` | — | The accessible name. Always required. |
| `tooltip` | `String?` | — | Text shown on hover, for sighted users. Not a substitute for `label`. |
| `onPressed` | `VoidCallback?` | — | The action. |
| `variant` | `AstryxButtonVariant?` | — | How prominent it is. |
| `size` | `AstryxButtonSize?` | — | The control height. |
| `enabled` | `bool` | `true` | Whether it accepts interaction. |
| `loading` | `bool` | `false` | Whether an action is in flight. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `href` | `Uri?` | — | A destination for the link delegate. |
| `focusNode` | `FocusNode?` | — | The focus node, if you own one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides for this button. |


## Related

- [AstryxButton](button.md) — with a visible label.
- [AstryxIcon](icon.md) — the registry these names resolve through.
- [AstryxTooltip](tooltip.md) — what `tooltip` installs.

