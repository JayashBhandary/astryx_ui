---
title: AstryxCollapsible
description: 'A disclosure: a header that shows and hides its own content.'
component: true
group: Overlays
source: lib/src/components/overlay/collapsible.dart
upstream: Collapsible / useCollapsible
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CollapsibleDemoExample extends StatelessWidget {
  const CollapsibleDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The whole header is the button, and it carries the expanded state in its
    // semantics — so a screen reader says "collapsed" without seeing a chevron.
    return const SizedBox(
      width: 360,
      child: AstryxCollapsible(
        title: 'Advanced settings',
        description: 'Timeouts, retries and headers',
        child: AstryxText(
          'Requests time out after 30 seconds and are retried twice with an '
          'exponential backoff.',
        ),
      ),
    );
  }
}
```


## Usage

```dart
AstryxCollapsible(
  title: 'Advanced settings',
  description: 'Timeouts, retries and headers',
  child: const SettingsForm(),
)
```

**The whole header is the button.** Not the chevron: a disclosure whose arrow alone is pressable fails on a phone and on a keyboard both.

## Composition

```text
AstryxCollapsible
├── leading       ← an icon, a status dot
├── title         ← the header text, and its accessible name
├── description   ← secondary text, announced as a hint
├── trailing      ← a count, a badge. Never a control
└── child         ← the content. Built only while it is showing
```

```dart
class CollapsibleRichExample extends StatelessWidget {
  const CollapsibleRichExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `leading` and `trailing` take any widget. Nothing interactive belongs in
    // either: the header is one button, so a control inside it is unreachable.
    return const SizedBox(
      width: 360,
      child: AstryxCollapsible(
        initiallyExpanded: true,
        leading: AstryxStatusDot(
          AstryxStatusDotVariant.warning,
          label: 'Degraded',
        ),
        title: 'Failed deliveries',
        trailing: AstryxBadge('3'),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxText('POST /hooks/billing — 502 at 14:02'),
            AstryxText('POST /hooks/billing — 502 at 14:07'),
            AstryxText('POST /hooks/audit — timeout at 14:31'),
          ],
        ),
      ),
    );
  }
}
```


## Controlled and uncontrolled

With no `controller` it owns its own state and starts from `initiallyExpanded`. Pass one and the state is yours: anything can open the section, and you can watch it. Drop it into a [group](collapsible_group.md) instead and the group owns it.

```dart
class CollapsibleControlledExample extends StatefulWidget {
  const CollapsibleControlledExample({super.key});

  @override
  State<CollapsibleControlledExample> createState() =>
      _CollapsibleControlledExampleState();
}

class _CollapsibleControlledExampleState
    extends State<CollapsibleControlledExample> {
  final AstryxCollapsibleController _controller = AstryxCollapsibleController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // With a controller the state is yours: anything can open the section, and
    // you can watch it. Dispose one you own.
    return SizedBox(
      width: 360,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(label: 'Expand', onPressed: _controller.expand),
              AstryxButton(label: 'Collapse', onPressed: _controller.collapse),
            ],
          ),
          AstryxCollapsible(
            controller: _controller,
            title: 'Request headers',
            child: const AstryxText(
              'Accept: application/json\nX-Request-Id: 9f2c…',
              type: AstryxTextType.code,
            ),
          ),
        ],
      ),
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves to the header, which takes focus. |
| `Enter` / `Space` | Expands or collapses it. |

> **Accessibility**
>
> The header is a button that carries `expanded` in its semantics, so a screen reader announces the state rather than the user inferring it from a rotated chevron. Collapsed content is **not in the tree** — no layout, no semantics, and no focus stops behind a closed section.

### AstryxCollapsible

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `title` *(required)* | `String` | — | The header text, and the header button’s accessible name. |
| `child` *(required)* | `Widget` | — | The content shown while expanded. |
| `controller` | `AstryxCollapsibleController?` | — | Drives the expanded state from outside. Null keeps it internal. |
| `initiallyExpanded` | `bool` | `false` | Whether the content starts visible. Ignored with a `controller`. |
| `description` | `String?` | — | Secondary text below the title. |
| `leading` | `Widget?` | — | A widget before the title. |
| `trailing` | `Widget?` | — | A widget after the title. Not interactive — the header is one button. |
| `enabled` | `bool` | `true` | Whether the header responds. |
| `onExpansionChanged` | `ValueChanged<bool>?` | — | Called with the new state whenever it expands or collapses. |


### AstryxCollapsibleController

A `ChangeNotifier`. Dispose one you own.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `isExpanded` | `bool` | — | Whether the content is showing. |
| `expand()` | `void` | — | Shows it. |
| `collapse()` | `void` | — | Hides it. |
| `toggle()` | `void` | — | Shows it if hidden, hides it if shown. |


## Related

- [AstryxCollapsibleGroup](collapsible_group.md) — several of these as one section.
- [AstryxTabList](tab_list.md) — when the sections are alternatives rather than details.

