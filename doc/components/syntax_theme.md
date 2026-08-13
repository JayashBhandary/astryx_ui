---
title: AstryxSyntaxTheme
description: The token colours a code block highlights with.
component: true
group: Providers
source: lib/src/theme/engine/syntax_theme.dart
upstream: SyntaxTheme
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A theme may carry a syntax palette: fourteen colours for the parts of a code sample. `defineTheme` writes them into the token map under `--color-syntax-`, and all seven prebuilt themes ship one.

> **Careful**
>
> **Nothing in this package paints with them.** `AstryxCodeBlock` does not highlight, by decision rather than omission: shipping a tokeniser for every language somebody might paste is not a design system’s job, and a bad one is worse than none. The palette is here so that a highlighter *you* wire takes its colours from the theme instead of from fourteen hex values sitting beside it.

## Reading the palette

```dart
final theme = AstryxTheme.of(context);

theme.syntaxColor(AstryxSyntaxToken.keyword);  // Color?, or null
theme.hasSyntaxPalette;                        // bool
theme.syntaxPalette;                           // the whole map
```

`syntaxColor` is **nullable**, unlike every other accessor on `AstryxThemeData`. A palette sits outside the 184 core tokens, so a theme either carries one or does not — and throwing would punish the caller for the theme’s silence. An app on the bare defaults, with no theme passed at all, has no palette.

```dart
class ProviderSyntaxExample extends StatelessWidget {
  const ProviderSyntaxExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final palette = theme.syntaxPalette;

    // The palette a theme carries, read back as `Color`s. Nothing in the
    // package paints with them — this is the seam for a highlighter you wire
    // yourself, so its colours come from the theme rather than from a list of
    // hex values beside it.
    if (palette.isEmpty) {
      return const AstryxEmptyState(
        title: 'This theme carries no syntax palette',
        description: 'The prebuilt themes all do.',
      );
    }

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxGrid(
          minWidth: 140,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final entry in palette.entries)
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: entry.value,
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.inner,
                      ),
                    ),
                  ),
                  Flexible(
                    child: AstryxText(
                      entry.key.key,
                      type: AstryxTextType.supporting,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const AstryxCodeBlock(
          '''
Color? keyword(BuildContext context) =>
    AstryxTheme.of(context).syntaxColor(AstryxSyntaxToken.keyword);''',
          language: 'dart',
        ),
      ],
    );
  }
}
```


## Defining one

```dart
final myTheme = defineTheme(
  AstryxThemeInput(
    name: 'acme',
    syntax: AstryxSyntaxTheme(
      name: 'acme-code',
      tokens: <String, String>{
        'keyword': 'light-dark(#700084, #efa8ff)',
        'string': 'light-dark(#005600, #a6d2a2)',
        // …twelve more
      },
    ),
  ),
)
```

Values are CSS, resolved by the same engine as every other token — so `light-dark()` gives both modes in one line, and a `var()` reference to another token is followed. `AstryxSyntaxTheme.define` takes `AstryxTokenValue`s instead, for a palette built in Dart rather than transcribed.

| The fourteen roles |   |
| --- | --- |
| `keyword` | `if`, `return`, `class`. |
| `string` | A string literal. |
| `comment` | A comment. |
| `number` | A numeric literal. |
| `function` | A function or method name. |
| `type` | A type name. |
| `variable` | A variable or parameter name. |
| `operator` | An operator — `+`, `=>`, `??`. |
| `constant` | A constant, including `null` and friends. |
| `tag` | A markup tag name. |
| `attribute` | A markup attribute name. |
| `property` | An object property or field name. |
| `punctuation` | Brackets, commas, semicolons. |
| `background` | The fill behind highlighted code. |

> **Accessibility**
>
> A palette is decoration over text that is already readable: contrast still has to hold against `background`, and colour must never be the only thing distinguishing one part of a sample from another. A reader who cannot separate the greens from the greys should still be reading code, not guessing at it.

### AstryxSyntaxTheme

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` *(required)* | `String` | — | The palette’s name. |
| `tokens` *(required)* | `Map<String, String>` | — | Resolved values keyed by short name — `keyword`, `string` — with no `--color-syntax-` prefix. |
| `AstryxSyntaxTheme.define({name, tokens})` | `factory` | — | Builds one from `AstryxTokenValue`s, flattening light/dark pairs to `light-dark()` strings. Upstream’s `defineSyntaxTheme`. |


### AstryxSyntaxToken

The typed counterpart of the string keys, and what `AstryxThemeData.syntaxColor` takes.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `String` | — | The short name — `keyword`, `string`. |
| `cssName` | `String` | — | The full token name — `--color-syntax-keyword`. |


## Related

- [AstryxCodeBlock](code_block.md) — the block this would colour.
- [Theming](../guides/theming.md) — where a palette is defined.
- [Design tokens](../guides/tokens.md) — the token map it is written into.

---

Something wrong with `AstryxSyntaxTheme`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSyntaxTheme&component=AstryxSyntaxTheme) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSyntaxTheme&area=AstryxSyntaxTheme) — both templates arrive with the component filled in.
