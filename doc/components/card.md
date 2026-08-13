---
title: AstryxCard
description: A bordered surface with a header, a body and a footer — pressable when you give it something to do.
component: true
group: Surfaces
source: lib/src/components/surface/card.dart
upstream: Card / ClickableCard
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CardDemoExample extends StatefulWidget {
  const CardDemoExample({super.key});

  @override
  State<CardDemoExample> createState() => _CardDemoExampleState();
}

class _CardDemoExampleState extends State<CardDemoExample> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 380,
      header: AstryxHStack(
        justify: AstryxStackJustify.between,
        align: AstryxStackAlign.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading('Login to your account', level: 4),
                AstryxText(
                  'Enter your email below to login.',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
          AstryxButton(
            label: 'Sign up',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Login',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          AstryxButton(label: 'Login with SSO', onPressed: () {}),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          AstryxTextInput(
            label: 'Password',
            controller: _password,
            required: true,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
AstryxCard(
  header: const AstryxHeading('Usage', level: 4),
  footer: AstryxButton(label: 'See details', onPressed: open),
  child: const AstryxText('4,201 requests this month.'),
)
```

## Composition

Three slots, and one number governing all of them. `padding` is both the card’s inset *and* the gap between its slots, which is why a card’s internal rhythm cannot drift the way a hand-spaced column can.

```text
AstryxCard
├── header    ← optional. A heading, a row, an image
├── child     ← the body. Required
└── footer    ← optional. Usually actions
```

```dart
class CardSlotsExample extends StatelessWidget {
  const CardSlotsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three slots, one gap. The card's `padding` is both its inset and the
    // space between header, body and footer — so the rhythm cannot drift.
    return AstryxCard(
      maxWidth: 360,
      header: const AstryxHeading('Usage', level: 4),
      footer: AstryxButton(
        label: 'See details',
        size: AstryxButtonSize.sm,
        onPressed: () {},
      ),
      child: const AstryxText('4,201 requests this month.'),
    );
  }
}
```


## Variants

Three neutral fills. `transparent` is for grouping without visual weight — structure without claiming to be a distinct surface. Pair it with `showBorder: false`.

```dart
class CardVariantsExample extends StatelessWidget {
  const CardVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxCard(child: AstryxText('standard')),
        AstryxCard(
          variant: AstryxCardVariant.muted,
          child: AstryxText('muted'),
        ),
        AstryxCard(
          variant: AstryxCardVariant.transparent,
          showBorder: false,
          child: AstryxText('transparent'),
        ),
      ],
    );
  }
}
```


Plus the ten categorical families, through `AstryxCardVariant.palette`.

```dart
class CardPalettesExample extends StatelessWidget {
  const CardPalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The nine categorical families. Colour by *category* — a team, a
    // workstream — never by severity, which the semantic tokens carry.
    return AstryxGrid(
      minWidth: 120,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxCard(
            variant: AstryxCardVariant.palette(palette),
            padding: AstryxSpacingToken.spacing3,
            child: AstryxText(palette.name),
          ),
      ],
    );
  }
}
```


> **Careful**
>
> The palettes are **categorical, not semantic**. Use them for "this belongs to the Red team", never for severity: a colour-blind user tells error from success by icon and position, not by hue. Severity belongs to [AstryxBanner](banner.md) and the `error`/`warning` tokens.

## Elevation

```dart
class CardElevationExample extends StatelessWidget {
  const CardElevationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 120,
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxCard(
            elevation: elevation,
            padding: AstryxSpacingToken.spacing3,
            child: AstryxText(elevation.name),
          ),
      ],
    );
  }
}
```


## Pressable

Upstream ships two widgets — `Card` and `ClickableCard`. This is one, because a nullable `onPressed` says the same thing with half the API, and that is how every other Flutter widget expresses the distinction.

With `onPressed` set, the card gains hover and press states, a focus ring, `Semantics(button: true)` and tap-target enforcement. Without it the card is inert and contributes nothing to the semantics tree beyond its children.

```dart
class CardPressableExample extends StatefulWidget {
  const CardPressableExample({super.key});

  @override
  State<CardPressableExample> createState() => _CardPressableExampleState();
}

class _CardPressableExampleState extends State<CardPressableExample> {
  String? _selected = 'pro';

  @override
  Widget build(BuildContext context) {
    // A nullable `onPressed` is the whole difference between a card and
    // upstream's second `ClickableCard`: set it and the card gains hover,
    // press, a focus ring, `Semantics(button: true)` and a tap target.
    return AstryxGrid(
      minWidth: 160,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final plan in const <List<String>>[
          <String>['free', 'Free', 'One project'],
          <String>['pro', 'Pro', 'Unlimited projects'],
        ])
          AstryxCard(
            semanticsLabel: 'Choose the ${plan[1]} plan',
            variant: _selected == plan[0]
                ? const AstryxCardVariant.palette(AstryxPalette.blue)
                : AstryxCardVariant.standard,
            onPressed: () => setState(() => _selected = plan[0]),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText(plan[1], type: AstryxTextType.large),
                AstryxText(
                  plan[2],
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


> **Accessibility**
>
> Give a pressable card a `semanticsLabel`. Without one, a screen reader announces the card’s entire contents as the button’s name — which for a card with a heading, three lines of copy and a badge is a sentence nobody can act on.

## Scrolling

With a fixed `height`, `scrollable: true` scrolls the body only — the header and the footer stay put. Without a height the card grows instead, and `scrollable` does nothing.

```dart
class CardScrollableExample extends StatelessWidget {
  const CardScrollableExample({super.key});

  @override
  Widget build(BuildContext context) {
    // With a fixed `height`, `scrollable` scrolls the body only — the header
    // and footer stay put.
    return AstryxCard(
      maxWidth: 380,
      height: 240,
      scrollable: true,
      header: const AstryxHeading('Terms of service', level: 4),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxButton(label: 'Decline', onPressed: () {}),
          AstryxButton(
            label: 'Accept',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (var clause = 1; clause <= 12; clause++)
            AstryxText(
              'Clause $clause. The body scrolls; the footer does not.',
              type: AstryxTextType.supporting,
            ),
        ],
      ),
    );
  }
}
```


## Width

A card fills a definite width and shrinks to fit an indefinite one — CSS’s own block-box rule. So a card in a `Row` or a horizontal list sizes to its content instead of asserting, and one in a column fills it.

```dart
class CardUnboundedExample extends StatelessWidget {
  const CardUnboundedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A card fills a definite width and shrinks to fit an indefinite one —
    // CSS's own block-box rule. So a card inside a horizontal list sizes to
    // its content instead of asserting.
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (final owner in const <String>['Ada', 'Alan', 'Grace'])
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AstryxCard(
                padding: AstryxSpacingToken.spacing3,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxText(owner),
                    const AstryxText(
                      'On call',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```


### AstryxCard

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The body. |
| `header` | `Widget?` | — | Content above the body, separated by the card’s own padding. |
| `footer` | `Widget?` | — | Content below the body. |
| `variant` | `AstryxCardVariant` | `AstryxCardVariant.standard` | The fill. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The inner padding, and the gap between slots. |
| `showBorder` | `bool` | `true` | Whether to draw a hairline border. |
| `onPressed` | `VoidCallback?` | — | Makes the whole card a button. Null leaves it inert. |
| `semanticsLabel` | `String?` | — | The card’s accessible name when it is pressable. |
| `width` | `double?` | — | A fixed width. Null sizes to the parent. |
| `height` | `double?` | — | A fixed height. |
| `maxWidth` | `double?` | — | A ceiling on the width. |
| `minHeight` | `double?` | — | A floor under the height. |
| `focusNode` | `FocusNode?` | — | The focus node. Only used when pressable. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |
| `scrollable` | `bool` | `false` | Whether the body scrolls when it exceeds `height`. |


### AstryxCardVariant

Three neutral constants plus a palette constructor — thirteen fills in all, matching upstream’s `variantStyles` exactly.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `standard` | `AstryxCardVariant` | — | `--color-background-card`. The default. |
| `muted` | `AstryxCardVariant` | — | `--color-background-muted`, for a de-emphasised card. |
| `transparent` | `AstryxCardVariant` | — | No fill at all. |
| `palette` | `AstryxCardVariant.palette(AstryxPalette)` | — | One of the ten categorical families. |


## Related

- [AstryxSelectableCard](selectable_card.md) — a card that records a choice rather than performing an action.
- [AstryxBanner](banner.md) — for a message with a severity.
- [AstryxGrid](grid.md) — for a wall of cards.
- [AstryxPopover](popover.md) — a floating surface rather than an inline one.

---

Something wrong with `AstryxCard`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCard&component=AstryxCard) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCard&area=AstryxCard) — both templates arrive with the component filled in.
