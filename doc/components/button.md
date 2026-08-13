---
title: AstryxButton
description: A labelled action, in four levels of prominence.
component: true
group: Actions
source: lib/src/components/action/button.dart
upstream: Button
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ButtonDemoExample extends StatelessWidget {
  const ButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Save changes',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Cancel', onPressed: () {}),
      ],
    );
  }
}
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
AstryxButton(
  label: 'Save changes',
  variant: AstryxButtonVariant.primary,
  onPressed: () => save(),
)
```

A button is *always* labelled. There is no `child` slot, because a button whose content is arbitrary is a button whose accessible name is a guess — and `label` is both the visible text and that name. For an action with no room for words, use [AstryxIconButton](icon_button.md), which requires a label anyway and simply does not paint it.

## Variants

Prominence, not colour: pick the one that matches how important the action is, and let the theme decide what that looks like.

```dart
class ButtonVariantsExample extends StatelessWidget {
  const ButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        for (final variant in AstryxButtonVariant.values)
          AstryxButton(
            label: variant.name,
            variant: variant,
            onPressed: () {},
          ),
      ],
    );
  }
}
```


| Variant | For |
| --- | --- |
| `primary` | The single most important action in a view. Filled with the accent. |
| `secondary` | The default. Reads as an action without competing with `primary`. |
| `ghost` | Transparent until interacted with. Low-emphasis or repeated actions — a toolbar, a row action. |
| `destructive` | Irreversible. Filled with the error colour. Pair it with a confirmation, not with regret. |

> **Careful**
>
> One `primary` per view. Two primary buttons side by side is a question, not a recommendation.

## Sizes

Three heights, from the size scale: `sm` is 28px, `md` 32px, `lg` 36px.

```dart
class ButtonSizesExample extends StatelessWidget {
  const ButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxButtonSize.values)
          AstryxButton(label: size.name, size: size, onPressed: () {}),
      ],
    );
  }
}
```


A button with no `size` takes it from an enclosing `AstryxSizeScope`, so a dense toolbar sets the size once and everything inside it follows. The same cascade drives `AstryxIconButton` and the form controls.

```dart
class ButtonSizeScopeExample extends StatelessWidget {
  const ButtonSizeScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // One scope sizes everything inside it. Neither button names a size.
    return AstryxSizeScope(
      size: AstryxElementSize.sm,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxButton(label: 'Filter', onPressed: () {}),
          AstryxIconButton(
            icon: AstryxIconName.search,
            label: 'Search',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```


## Icons and badges

The `leading` and `trailing` slots take any widget. Their size and colour come from the button, so an `AstryxIcon` with the default `inherit` colour comes out right without being told anything.

```dart
class ButtonIconsExample extends StatelessWidget {
  const ButtonIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxButton(
          label: 'Search',
          leading: const AstryxIcon(AstryxIconName.search),
          onPressed: () {},
        ),
        AstryxButton(
          label: 'Open docs',
          variant: AstryxButtonVariant.ghost,
          trailing: const AstryxIcon(AstryxIconName.externalLink),
          onPressed: () {},
        ),
        AstryxButton(
          label: 'Inbox',
          trailing: const AstryxBadge(
            '12',
            semanticsLabel: '12 unread',
            variant: AstryxBadgeVariant.info,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
```


## States

Three different things are often confused. A null `onPressed` is a button that does nothing. `enabled: false` is a button that could do something but not now. `loading: true` is a button whose action is in flight — it keeps its callback *and* its width, so the layout cannot jump, and it reports itself as disabled to assistive technology.

```dart
class ButtonStatesExample extends StatefulWidget {
  const ButtonStatesExample({super.key});

  @override
  State<ButtonStatesExample> createState() => _ButtonStatesExampleState();
}

class _ButtonStatesExampleState extends State<ButtonStatesExample> {
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        // `loading` keeps the callback and the width — the layout cannot jump,
        // and the button reports itself as disabled while the work is in
        // flight.
        AstryxButton(
          label: 'Save',
          variant: AstryxButtonVariant.primary,
          loading: _saving,
          onPressed: _save,
        ),
        const AstryxButton(label: 'Inert'),
        AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
      ],
    );
  }
}
```


## Elevation

Flat by default. Elevation is for a button that floats above the page, not for making an ordinary button look important — that is what `variant` is for.

```dart
class ButtonElevationExample extends StatelessWidget {
  const ButtonElevationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxButton(
            label: elevation.name,
            elevation: elevation,
            onPressed: () {},
          ),
      ],
    );
  }
}
```


## Width

A button sizes to its label. `width` fixes it; a stretched stack fills the available space, which is usually what a form footer wants.

```dart
class ButtonWidthExample extends StatelessWidget {
  const ButtonWidthExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Continue',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          AstryxButton(label: 'Use a different account', onPressed: () {}),
        ],
      ),
    );
  }
}
```


## Links

Set `href` for an action that navigates. Navigation is not this package's concern, so the URI goes to the `AstryxLinkDelegate` the application installs — the seam is provided, the policy is yours.

```dart
AstryxThemeProvider(
  linkDelegate: AstryxLinkDelegate(
    onFollow: (uri) => launchUrl(uri),
  ),
  child: AstryxButton(
    label: 'Read the changelog',
    href: Uri.parse('https://example.com/changelog'),
    trailing: const AstryxIcon(AstryxIconName.externalLink),
  ),
)
```

## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves focus to the button. |
| `Enter` | Activates it. |
| `Space` | Activates it. |

> **Accessibility**
>
> The focus ring appears for keyboard focus and not for a click, which is CSS's `:focus-visible` rule ported wholesale. A disabled or loading button is announced as disabled rather than silently ignoring presses.

### AstryxButton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the accessible name. |
| `onPressed` | `VoidCallback?` | — | Called on activation, by pointer or keyboard. Null makes the button inert. |
| `variant` | `AstryxButtonVariant?` | — | How prominent the button is. Null inherits from an enclosing `AstryxButtonGroup`, then falls back to `secondary`. |
| `size` | `AstryxButtonSize?` | — | The control height. Null inherits from an enclosing `AstryxSizeScope`, then falls back to `md`. |
| `enabled` | `bool` | `true` | Whether the button accepts interaction. |
| `loading` | `bool` | `false` | Whether an action is in flight. Shows a spinner, suppresses activation, and keeps the width. |
| `leading` | `Widget?` | — | Content before the label — usually an `AstryxIcon`. |
| `trailing` | `Widget?` | — | Content after the label — an icon or a badge. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `width` | `double?` | — | A fixed width. Null lets the label decide. |
| `href` | `Uri?` | — | A destination, handed to the `AstryxLinkDelegate`. |
| `focusNode` | `FocusNode?` | — | The focus node, if the caller owns one. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `theme` | `AstryxButtonTheme?` | — | Visual overrides, merged over `AstryxThemeData.button`. |


## Related

- [AstryxIconButton](icon_button.md) — the same button, glyph only.
- [AstryxButtonGroup](button_group.md) — join or space a set of them.
- [AstryxSpinner](spinner.md) — what `loading` puts in the leading slot.

---

Something wrong with `AstryxButton`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxButton&component=AstryxButton) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxButton&area=AstryxButton) — both templates arrive with the component filled in.
