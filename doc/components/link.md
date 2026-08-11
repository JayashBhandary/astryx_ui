---
title: AstryxLink
description: Inline navigation in running text, with the visited and external affordances.
component: true
group: Navigation
source: lib/src/components/navigation/link.dart
upstream: Link
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LinkDemoExample extends StatelessWidget {
  const LinkDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter has no inline element, so `AstryxLink.span` is how one sits in a
    // sentence. An external link says so in its accessible name as well as in
    // its glyph: the user who cannot see the glyph is the one most disrupted
    // by a window they did not expect.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: AstryxTheme.of(context).textStyle(AstryxTypeRole.body),
            children: <InlineSpan>[
              const TextSpan(text: 'Start with the '),
              AstryxLink.span('installation guide', onPressed: () {}),
              const TextSpan(text: ', then read about '),
              AstryxLink.span('theming', onPressed: () {}),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        AstryxLink('The Flutter docs', external: true, onPressed: () {}),
        AstryxLink('Already read', visited: true, onPressed: () {}),
        const AstryxLink('Unavailable', enabled: false),
      ],
    );
  }
}
```


## Usage

```dart
AstryxLink('Read the guide', onPressed: open)
```

## Inside a sentence

Flutter has no inline element, so a widget cannot sit inside a string — the same wall [AstryxCode](code.md) runs into. `AstryxLink.span` is the bridge: a `WidgetSpan` aligned to the text baseline, for `Text.rich`.

```dart
Text.rich(
  TextSpan(
    children: <InlineSpan>[
      const TextSpan(text: 'See the '),
      AstryxLink.span('installation guide', onPressed: open),
      const TextSpan(text: ' to begin.'),
    ],
  ),
)
```

## Where it goes

Navigation is the application’s concern, so an `href` is handed to the `AstryxLinkDelegate` and this package never decides what following means. An `onPressed` is called directly. A link with both does both — the callback is yours, the delegate is your router’s.

> **Accessibility**
>
> An external link says so **in its accessible name**, not only in its glyph: the user who cannot see the glyph is exactly the one most disrupted by a window they did not expect. The underline is on by default for the same kind of reason — in running text, colour alone is the only thing telling a link from an emphasised word, and for a colour-blind reader it tells them nothing.

> **Note**
>
> `visited` is yours to track. A browser knows a link’s history and Flutter does not, so there is nothing here to read it from — pass it if your application keeps the answer, and leave it alone if it does not.

### AstryxLink

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The text. The positional first argument. |
| `onPressed` | `VoidCallback?` | — | Called when it is followed. |
| `href` | `Uri?` | — | A destination for the `AstryxLinkDelegate`. |
| `external` | `bool` | `false` | Whether following it leaves the application. Adds the glyph *and* the announcement. |
| `visited` | `bool` | `false` | Whether it has been followed. Yours to track. |
| `underline` | `AstryxLinkUnderline` | `AstryxLinkUnderline.always` | When the underline is drawn. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The type role the text takes, so a link matches the copy around it. |
| `enabled` | `bool` | `true` | Whether it can be followed. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |
| `focusNode` | `FocusNode?` | — | The focus node. |


### AstryxLinkUnderline

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `always` | `AstryxLinkUnderline` | — | The default, and what running text needs. |
| `hover` | `AstryxLinkUnderline` | — | On hover and focus only, for a link that is obviously one from its position — a row in a list, a name in a cell. |
| `never` | `AstryxLinkUnderline` | — | For a link inside something already visibly interactive. |


## Related

- [AstryxButton](button.md) — for an action. A link goes somewhere; a button does something, and the two are different promises.
- [AstryxCode](code.md) — the other widget with a `span`.

