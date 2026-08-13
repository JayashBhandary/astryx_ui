---
title: AstryxKbd
description: A keyboard key or chord, rendered as a key.
component: true
group: Data display
source: lib/src/components/data/kbd.dart
upstream: Kbd
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class KbdDemoExample extends StatelessWidget {
  const KbdDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxKbd('K'),
        const AstryxKbd.chord(<String>['Ctrl', 'K']),
        const AstryxKbd.chord(
          <String>['⌘', '⇧', 'P'],
          // A string of symbols is not a shortcut anyone can follow.
          semanticsLabel: 'Command Shift P',
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxKbd('K')
const AstryxKbd.chord(<String>['Ctrl', 'K'])
```

Two constructors because a single key is the common case and `AstryxKbd(<String>['K'])` is a list nobody wants to type.

> **Note**
>
> **The glyphs are yours.** This does not translate `Ctrl` to `⌘` on a Mac, because only the caller knows whether the shortcut is the platform’s or the product’s own — and a key cap showing the wrong modifier is worse than one showing a name.

## Beside what it does

Where a key cap usually belongs: at the trailing edge of the row whose action it triggers.

```dart
class KbdInContextExample extends StatelessWidget {
  const KbdInContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    // What a key cap is usually for: the shortcut beside the thing it does.
    return AstryxList(
      label: 'Shortcuts',
      density: AstryxItemDensity.compact,
      children: <Widget>[
        for (final shortcut in const <List<String>>[
          <String>['Search', 'K'],
          <String>['New deploy', 'D'],
          <String>['Command palette', 'P'],
        ])
          AstryxItem(
            label: shortcut[0],
            trailing: AstryxKbd.chord(
              <String>['Ctrl', shortcut[1]],
              size: AstryxKbdSize.sm,
            ),
          ),
      ],
    );
  }
}
```


> **Accessibility**
>
> A chord is one semantics node, not one per cap. Set `semanticsLabel` whenever the caps are symbols: `⌘ ⇧ P` read out as a string of glyphs is not a shortcut anyone can follow.

### AstryxKbd

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `keys` *(required)* | `List<String>` | — | The keys, in the order they are shown. The positional argument of `AstryxKbd.chord`; the default constructor takes one `String`. |
| `size` | `AstryxKbdSize` | `AstryxKbdSize.md` | How large the caps are drawn. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to the keys, space-separated. |


### AstryxKbdSize

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `sm` | `AstryxKbdSize` | — | Beside `supporting` text — a hint in a menu row, a footnote. |
| `md` | `AstryxKbdSize` | — | The default, beside `body` text. |


---

Something wrong with `AstryxKbd`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxKbd&component=AstryxKbd) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxKbd&area=AstryxKbd) — both templates arrive with the component filled in.
