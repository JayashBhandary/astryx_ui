# Surfaces

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxCard

`lib/src/components/surface/card.dart` · upstream `Card / ClickableCard`

A bordered surface with a header, a body and a footer — pressable when you give it something to do.

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

**Rules**

- **Careful:** The palettes are **categorical, not semantic**. Use them for "this belongs to the Red team", never for severity: a colour-blind user tells error from success by icon and position, not by hue. Severity belongs to AstryxBanner (references/surfaces.md) and the `error`/`warning` tokens.
- **Accessibility:** Give a pressable card a `semanticsLabel`. Without one, a screen reader announces the card’s entire contents as the button’s name — which for a card with a heading, three lines of copy and a badge is a sentence nobody can act on.

### AstryxCard

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The body. |
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

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `standard` | `AstryxCardVariant` | — | `--color-background-card`. The default. |
| `muted` | `AstryxCardVariant` | — | `--color-background-muted`, for a de-emphasised card. |
| `transparent` | `AstryxCardVariant` | — | No fill at all. |
| `palette` | `AstryxCardVariant.palette(AstryxPalette)` | — | One of the ten categorical families. |

---

## AstryxSelectableCard

`lib/src/components/surface/selectable_card.dart` · upstream `SelectableCard`

A card that carries selection state — a card-shaped radio or checkbox.

```dart
class SelectableCardDemoExample extends StatefulWidget {
  const SelectableCardDemoExample({super.key});

  @override
  State<SelectableCardDemoExample> createState() =>
      _SelectableCardDemoExampleState();
}

class _SelectableCardDemoExampleState extends State<SelectableCardDemoExample> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    // One choice out of three, where each option carries a price and a line of
    // detail — more than a radio row can hold, which is the whole reason to
    // reach for a card here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final plan in const <List<String>>[
          <String>['starter', 'Starter', r'$0', 'One project, one seat'],
          <String>['pro', 'Pro', r'$20', 'Unlimited projects, five seats'],
          <String>['scale', 'Scale', r'$80', 'Unlimited seats, SSO, audit log'],
        ])
          AstryxSelectableCard(
            label: '${plan[1]} plan',
            semanticsHint: '${plan[2]} per month. ${plan[3]}',
            control: AstryxSelectableCardControl.radio,
            selected: _plan == plan[0],
            onSelectedChanged: (_) => setState(() => _plan = plan[0]),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  justify: AstryxStackJustify.between,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: AstryxText(plan[1], type: AstryxTextType.large),
                    ),
                    AstryxText('${plan[2]}/mo'),
                  ],
                ),
                AstryxText(
                  plan[3],
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

**Rules**

- **Accessibility:** `label` is **required**, and is not painted. Without it a screen reader announces the card’s whole contents as the control’s name, which for a heading, a price and a badge is a sentence nobody can act on. The content keeps its own semantics nodes, so it is still read — after the user has been told what the card is. Put anything else it needs to hear in `semanticsHint`.
- **Note:** Each card is its own tab stop, unlike AstryxRadioList (references/forms.md), which is one tab stop with arrow-key traversal. A set of cards is a set of separate controls — there is no shared `name` to group them the way a browser groups native radios — so Tab visits each one. That is the cost of the extra content; for four or more terse options, the radio list is the better control.

| Control | Announced as | Pressing it again |
| --- | --- | --- |
| `checkbox` | a checkbox, checked or not | deselects it |
| `radio` | a radio, `inMutuallyExclusiveGroup` | **reports nothing** |

| State | Set by | Reads as |
| --- | --- | --- |
| Interactive | `onSelectedChanged` non-null, `enabled: true` | hover, press, a focus ring, a tap target |
| Inert | `onSelectedChanged: null` | not dimmed, still focusable and still announced, no tap action |
| Disabled | `enabled: false` | dimmed, skipped by Tab, `enabled: false` announced |

### AstryxSelectableCard

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content beside the control. |
| `label` **(required)** | `String` | — | The accessible name. Required, and never painted. |
| `selected` **(required)** | `bool` | — | Whether the card is selected. |
| `onSelectedChanged` | `ValueChanged<bool>?` | — | Called with the selection a press would produce. Null leaves the card inert without dimming it. |
| `control` | `AstryxSelectableCardControl` | `AstryxSelectableCardControl.checkbox` | Whether the card behaves as a checkbox or as a radio. |
| `controlSize` | `AstryxToggleSize` | `AstryxToggleSize.md` | The size of the control, not of the card. |
| `variant` | `AstryxCardVariant` | `AstryxCardVariant.standard` | The unselected fill. Selection overrides it. |
| `elevation` | `AstryxElevation` | `AstryxElevation.none` | The resting shadow. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing4` | The inner padding, and the gap between the control and the content. |
| `enabled` | `bool` | `true` | Whether the card accepts input. |
| `semanticsHint` | `String?` | — | What a screen reader reads after the name — a price, a caveat, why the card is unavailable. |
| `width` | `double?` | — | A fixed width. Null sizes to the parent. |
| `maxWidth` | `double?` | — | A ceiling on the width. |
| `minHeight` | `double?` | — | A floor under the height. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |

### AstryxSelectableCardControl

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `checkbox` | `AstryxSelectableCardControl` | — | A checkbox. Any number of cards in the set may be selected, and pressing a selected card deselects it. The default. |
| `radio` | `AstryxSelectableCardControl` | — | A radio. One card in the set is selected, and pressing it again reports nothing. |

---

## AstryxBadge

`lib/src/components/surface/badge.dart` · upstream `Badge`

A small label: a status, a count, a category.

```dart
class BadgeDemoExample extends StatelessWidget {
  const BadgeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText('atlas-api'),
        AstryxBadge('Healthy', variant: AstryxBadgeVariant.success),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** A badge is not a button. It has no press state, no focus and no tap target — if it needs to be pressable, it is a button (references/actions.md) or a pressable card (references/surfaces.md) with a badge inside it.
- **Note:** Upstream’s `stone` theme sets `--color-on-error` equal to `--color-error` — a 1.00:1 contrast failure reproduced faithfully here rather than corrected, and pinned by a test. An error badge is where that defect is most visible. Pick a different theme, or override the token.

### AstryxBadge

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | The text. The positional first argument. |
| `variant` | `AstryxBadgeVariant` | `AstryxBadgeVariant.neutral` | The colour: `neutral`, `info`, `success`, `warning`, `error`, or `AstryxBadgeVariant.palette(...)`. |
| `icon` | `Widget?` | — | An icon before the text. Any widget; size and colour come from the badge. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |

---

## AstryxBanner

`lib/src/components/surface/banner.dart` · upstream `Banner`

An inline message with a severity, announced when it appears.

```dart
class BannerDemoExample extends StatelessWidget {
  const BannerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxBanner(
      status: AstryxBannerStatus.warning,
      title: 'Your trial ends in three days',
      description: 'Add a payment method to keep your projects running.',
    );
  }
}
```

**Rules**

- **Accessibility:** Set `announce: false` for a banner that is part of the page’s initial state. A permanent notice at the top of a settings screen has nothing to announce, and announcing it on every visit is noise.

| Status | Announced | For |
| --- | --- | --- |
| `info` | politely | Neutral information. |
| `warning` | politely | Worth attention, not blocking. |
| `error` | **assertively** | Something is wrong. |
| `success` | politely | Confirmation. |

### AstryxBanner

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `title` **(required)** | `String` | — | The headline. Short and specific. |
| `status` | `AstryxBannerStatus` | `AstryxBannerStatus.info` | The sentiment, which sets the fill, the icon and the urgency. |
| `description` | `String?` | — | Supporting text below the title. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Buttons at the trailing edge of the header. |
| `onDismiss` | `VoidCallback?` | — | Shows a dismiss button that calls this. Null means it cannot be dismissed. |
| `icon` | `Widget?` | — | Overrides the status’s default icon. |
| `showIcon` | `bool` | `true` | Whether to show an icon at all. |
| `content` | `Widget?` | — | Extra content below the header, on the card background. |
| `announce` | `bool` | `true` | Whether to announce the banner when it appears or its text changes. |

---

