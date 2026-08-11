---
title: AstryxCode
description: Inline monospace, for a symbol or a value inside a sentence.
component: true
group: Data display
source: lib/src/components/data/code.dart
upstream: Code
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CodeDemoExample extends StatelessWidget {
  const CodeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCode('AstryxSpacingToken.spacing4'),
        AstryxCode('--color-accent'),
        AstryxCode('flutter pub get'),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxCode('AstryxSpacingToken.spacing4')
```

For the things that are wrong when they are re-typed with a capital letter in the wrong place: a class name, a flag, an environment variable, a token.

## Inside a sentence

Flutter has no inline element, so a widget cannot simply sit inside a string — the one place this port cannot follow upstream’s shape. `AstryxCode.span` is the bridge: a `WidgetSpan`, aligned to the middle of the line rather than the baseline, because the chip has padding of its own.

```dart
class CodeSpanExample extends StatelessWidget {
  const CodeSpanExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter has no inline element, so a widget cannot sit inside a string.
    // `AstryxCode.span` is the bridge: a `WidgetSpan` that lines up with the
    // sentence around it.
    return Text.rich(
      TextSpan(
        style: AstryxTheme.of(context).textStyle(AstryxTypeRole.body),
        children: <InlineSpan>[
          const TextSpan(text: 'Every gap comes from a token — pass '),
          AstryxCode.span('AstryxSpacingToken.spacing3'),
          const TextSpan(text: ' to '),
          AstryxCode.span('gap'),
          const TextSpan(text: ', never a number.'),
        ],
      ),
    );
  }
}
```


> **Accessibility**
>
> Set `semanticsLabel` for a string that is unreadable aloud — a hex colour, a token with no spaces in it. What a screen reader makes of `#0064E0` is noise, and "hex 0064E0" is not.

### AstryxCode

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `data` *(required)* | `String` | — | The code. The positional first argument. |
| `semanticsLabel` | `String?` | — | Overrides what a screen reader announces. |


## Related

- [AstryxCodeBlock](code_block.md) — more than a phrase of it.
- [AstryxKbd](kbd.md) — a key, not a symbol. `Ctrl` is not code.

