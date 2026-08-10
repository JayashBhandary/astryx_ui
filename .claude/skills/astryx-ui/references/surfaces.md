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

