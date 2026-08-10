---
title: AstryxBanner
description: An inline message with a severity, announced when it appears.
component: true
group: Surfaces
source: lib/src/components/surface/banner.dart
upstream: Banner
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
const AstryxBanner(
  status: AstryxBannerStatus.warning,
  title: 'Your trial ends in three days',
  description: 'Add a payment method to keep your projects running.',
)
```

A banner is for a message tied to the page it sits on — a condition to resolve, a state to know about. For something transient and unrelated to the current view, use a [toast](toast.md).

## Statuses

Each status brings its own muted fill, its own icon, and its own urgency. **Only an error interrupts** a screen reader; a success banner that talks over what the user is doing has turned good news into an obstacle.

```dart
class BannerStatusesExample extends StatelessWidget {
  const BannerStatusesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final status in AstryxBannerStatus.values)
          AstryxBanner(
            status: status,
            title: 'status: ${status.name}',
            description: 'Each status brings its own fill, icon and urgency.',
          ),
      ],
    );
  }
}
```


| Status | Announced | For |
| --- | --- | --- |
| `info` | politely | Neutral information. |
| `warning` | politely | Worth attention, not blocking. |
| `error` | **assertively** | Something is wrong. |
| `success` | politely | Confirmation. |

## Actions and dismissal

A null `onDismiss` means the banner cannot be dismissed — correct for a condition the user has to *resolve* rather than acknowledge.

```dart
class BannerActionsExample extends StatefulWidget {
  const BannerActionsExample({super.key});

  @override
  State<BannerActionsExample> createState() => _BannerActionsExampleState();
}

class _BannerActionsExampleState extends State<BannerActionsExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return AstryxButton(
        label: 'Bring the banner back',
        size: AstryxButtonSize.sm,
        onPressed: () => setState(() => _visible = true),
      );
    }

    return AstryxBanner(
      title: 'A new version is available',
      description: 'Reload to pick up the latest deploy.',
      actions: <Widget>[
        AstryxButton(
          label: 'Reload',
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
      onDismiss: () => setState(() => _visible = false),
    );
  }
}
```


## Detail

Detail belongs in `content`, which sits on the card background below the header. The coloured area’s contrast tokens are tuned for one line of text, not for a paragraph or a list.

```dart
class BannerContentExample extends StatelessWidget {
  const BannerContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Detail belongs in `content`, on the card background — the coloured area's
    // contrast is tuned for one line, not a paragraph or a list.
    return const AstryxBanner(
      status: AstryxBannerStatus.error,
      title: 'Could not save three fields',
      content: AstryxVStack(
        gap: AstryxSpacingToken.spacing1,
        children: <Widget>[
          AstryxText('Email — that address is already in use.'),
          AstryxText('Postcode — not valid for the chosen country.'),
          AstryxText('Phone — include the country code.'),
        ],
      ),
    );
  }
}
```


```text
AstryxBanner
├── header      ← icon, title, description, actions, dismiss
│   ├── icon    ← from `status`, or your own
│   └── actions ← buttons at the trailing edge
└── content     ← optional detail, on the card background
```

## Icons

```dart
class BannerIconExample extends StatelessWidget {
  const BannerIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxBanner(
          title: 'A different icon, same status',
          icon: AstryxIcon(AstryxIconName.microphone),
        ),
        AstryxBanner(
          title: 'No icon at all',
          showIcon: false,
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> Set `announce: false` for a banner that is part of the page’s initial state. A permanent notice at the top of a settings screen has nothing to announce, and announcing it on every visit is noise.

### AstryxBanner

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `title` *(required)* | `String` | — | The headline. Short and specific. |
| `status` | `AstryxBannerStatus` | `AstryxBannerStatus.info` | The sentiment, which sets the fill, the icon and the urgency. |
| `description` | `String?` | — | Supporting text below the title. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Buttons at the trailing edge of the header. |
| `onDismiss` | `VoidCallback?` | — | Shows a dismiss button that calls this. Null means it cannot be dismissed. |
| `icon` | `Widget?` | — | Overrides the status’s default icon. |
| `showIcon` | `bool` | `true` | Whether to show an icon at all. |
| `content` | `Widget?` | — | Extra content below the header, on the card background. |
| `announce` | `bool` | `true` | Whether to announce the banner when it appears or its text changes. |


