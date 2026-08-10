---
title: AstryxSpinner
description: An indeterminate wait, in three sizes.
component: true
group: Status
source: lib/src/components/feedback/spinner.dart
upstream: Spinner
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SpinnerDemoExample extends StatelessWidget {
  const SpinnerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxSpinner(label: 'Loading projects'),
        AstryxText('Loading projects…', color: AstryxTextColor.secondary),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxSpinner(label: 'Loading projects')
```

Reach for a spinner when the wait has no measurable extent. When it does, [AstryxProgressBar](progress_bar.md) says more; when the shape of what is arriving is known, [AstryxSkeleton](skeleton.md) says more still.

## Sizes

Diameter and stroke width move together.

```dart
class SpinnerSizesExample extends StatelessWidget {
  const SpinnerSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxSpinnerSize.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxSpinner(size: size, label: 'Loading'),
              AstryxText(
                '${size.name} · ${size.diameter.toInt()}px',
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


## Shades

`inherit` takes the colour from the enclosing text or icon theme, which is what a button uses so the spinner matches the label it replaced.

```dart
class SpinnerShadesExample extends StatelessWidget {
  const SpinnerShadesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final shade in AstryxSpinnerShade.values)
          // `onMedia` only reads on an inverted surface, so it gets one.
          ColoredBox(
            color: shade == AstryxSpinnerShade.onMedia
                ? theme.color(AstryxColorToken.backgroundInverted)
                : const Color(0x00000000),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: AstryxSpinner(shade: shade, label: 'Loading'),
            ),
          ),
      ],
    );
  }
}
```


## Inside a control

Rarely place one by hand. `loading: true` on either button installs a spinner at the right size and colour, and keeps the control’s width so the layout does not jump.

```dart
class SpinnerInButtonExample extends StatelessWidget {
  const SpinnerInButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A button's `loading` flag installs the spinner for you, at the size and
    // colour of the icon it replaces. This is the shape to reach for first.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Deploying',
          variant: AstryxButtonVariant.primary,
          loading: true,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Copying',
          loading: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> `label` is announced, and defaults to a localised "Loading" string. Set it to null *only* when a surrounding container already announces the wait — two live regions competing is worse than one.

> **Note**
>
> Under `prefers-reduced-motion` the spinner stops rotating and paints a complete ring instead, so the state is still legible without the movement.

### AstryxSpinner

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `AstryxSpinnerSize` | `AstryxSpinnerSize.md` | The diameter and stroke width: `sm` 10px, `md` 14px, `lg` 18px. |
| `shade` | `AstryxSpinnerShade` | `AstryxSpinnerShade.accent` | How prominent the spinner is: `accent`, `subtle`, `onMedia` or `inherit`. |
| `label` | `String?` | — | What is being waited for, announced to assistive technology. Null uses the localised default. |
| `color` | `Color?` | — | Overrides the colour the `shade` resolves to. |


