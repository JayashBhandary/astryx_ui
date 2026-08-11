---
title: AstryxCodeBlock
description: A fenced block of code, with the language, copy control and optional line numbers.
component: true
group: Data display
source: lib/src/components/data/code.dart
upstream: CodeBlock
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CodeBlockDemoExample extends StatelessWidget {
  const CodeBlockDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxCodeBlock('''
AstryxCard(
  header: const AstryxHeading('Usage', level: 4),
  child: const AstryxText('4,201 requests this month.'),
)''', language: 'dart');
  }
}
```


## Usage

```dart
const AstryxCodeBlock(
  'flutter pub add astryx_ui',
  language: 'bash',
)
```

> **Careful**
>
> **Nothing is highlighted.** Upstream colours its blocks with a JavaScript tokeniser that has no counterpart here, and a half-right highlighter is worse than none: code coloured by a grammar that does not match the language is code that lies about what it means. `language` is a label the reader sees, not an instruction.

## Copying

The copy button carries the **whole** string, including the lines scrolled out of sight — which is the difference between a copy button and a selection. It reports back in place, by becoming a tick for two seconds, rather than raising a [toast](toast.md): a page of ten blocks that shouts once per copy is a page nobody reads.

## Line numbers and long lines

A long line scrolls sideways rather than wrapping, because in code a line break is not a neutral event and the indentation a reader follows is destroyed by one. `wrap: true` where the code matters less than the layout around it.

```dart
class CodeBlockNumbersExample extends StatelessWidget {
  const CodeBlockNumbersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The numbers are decoration: not copied with the code, not read aloud.
    // A long line scrolls sideways rather than wrapping, because in code a
    // line break is not a neutral event.
    return const AstryxCodeBlock(
      'void main() {\n'
      '  runApp(AstryxApp(title: '
      "'My internal tool', home: const HomePage()));\n"
      '}',
      language: 'dart',
      showLineNumbers: true,
    );
  }
}
```


> **Accessibility**
>
> The line numbers are decoration: they are not copied with the code and not read aloud, because "1 2 3 4" is not the program.

### AstryxCodeBlock

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `code` *(required)* | `String` | — | The code, newline-separated. The positional first argument. |
| `language` | `String?` | — | The language, shown in the header. A label, not a highlighting instruction. |
| `showLineNumbers` | `bool` | `false` | Whether to number the lines. |
| `showCopy` | `bool` | `true` | Whether to offer a copy button. |
| `wrap` | `bool` | `false` | Whether long lines wrap instead of scrolling sideways. |
| `maxHeight` | `double?` | — | The tallest the block may be before it scrolls. |
| `semanticsLabel` | `String?` | — | What a screen reader announces instead of the code. |


