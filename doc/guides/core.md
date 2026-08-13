---
title: The token engine
description: How a theme definition becomes resolved tokens, and where the resolution happens.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A theme is written as data, turned into a map of concrete values once, and read as Flutter types from then on. Three steps, one direction — nothing downstream can change a token, and nothing upstream knows what a `Color` is.

```text
AstryxDefineThemeInput     what you write
      │
      │  defineTheme()           expand the scales, merge the layers
      ▼
AstryxDefinedTheme         token name → CSS string, possibly a var()
      │
      │  AstryxResolvedTokenSet.resolve()
      ▼
AstryxResolvedTokenSet     terminal strings, one map per mode
      │
      │  AstryxThemeData()       parse, and pick a mode
      ▼
AstryxThemeData            Color, double, Duration, Curve, TextStyle
      │
      │  AstryxTheme             an InheritedWidget
      ▼
the widgets
```

## 1. The definition

`defineTheme` builds one flat map of CSS custom properties, in precedence order. Each layer writes over the one before it:

1. The **token defaults** — every property Astryx ships.
2. The **base theme**, when `extendsTheme` names one.
3. The **generated scales**: colour from the seed accent, and the type, radius and motion expanders.
4. The **font families** and the syntax-highlighting tokens.
5. The **explicit `tokens:` map**, which beats everything above it.

The output is an `AstryxDefinedTheme`: a name, a token map, the component overrides, the icon entries, and the on-dark and on-light sets. Still strings — nothing has been parsed yet.

## 2. Resolution

Generated themes emit derived tokens as *references*: `--color-text-accent` is literally `var(--color-accent)`, so overriding the accent re-themes everything pointing at it. In a browser the CSS cascade does that work. There is no cascade here, so the resolver replays it.

- `var()` references are followed through the map, with a cycle guard.
- `light-dark(a, b)` is split, producing **two** maps — one per mode — rather than a mode flag consulted at read time.
- `color-mix(in srgb, …)` is evaluated. Other colour spaces are **refused** rather than approximated: the expression is preserved with its references resolved, which is upstream’s behaviour and part of the contract.

Resolution is eager and happens once. A theme is read far more often than it changes, and the resulting set is cheap to compare — its hash is computed during construction, so the `updateShouldNotify` path is an identity check and at worst an integer comparison.

```dart
/// A definition: one seed accent, and one token set by hand.
final AstryxDefinedTheme _demoTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'engine-demo',
    color: AstryxColorScaleConfig(accent: '#B3261E'),
    tokens: <String, AstryxTokenValue>{
      '--radius-element': AstryxTokenValue('2px'),
    },
  ),
);

/// The engine's output: every token, concrete, in both modes.
///
/// Resolved once, at the top level — not per build. A theme is read far more
/// often than it changes.
final AstryxResolvedTokenSet _resolved = AstryxResolvedTokenSet.resolve(
  _demoTheme,
);

class CorePipelineExample extends StatelessWidget {
  const CorePipelineExample({super.key});

  static const List<AstryxToken> _shown = <AstryxToken>[
    // Generated from the seed.
    AstryxColorToken.accent,
    // Emitted as `var(--color-accent)`, followed by the resolver.
    AstryxColorToken.textAccent,
    // A `light-dark()` pair: one token, two halves.
    AstryxColorToken.backgroundCard,
    // Overridden by hand, beating the generated value.
    AstryxRadiusToken.element,
    // Untouched by the definition, so the token default stands.
    AstryxDurationToken.fast,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const _Row(cells: <String>['token', 'light', 'dark'], header: true),
        for (final token in _shown)
          _Row(
            cells: <String>[
              token.cssName,
              _resolved.value(token, AstryxThemeMode.light),
              _resolved.value(token, AstryxThemeMode.dark),
            ],
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.cells, this.header = false});

  final List<String> cells;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      mainAxisSize: MainAxisSize.max,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (index, cell) in cells.indexed)
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: AstryxText(
              cell,
              type: header ? AstryxTextType.label : AstryxTextType.code,
              color: header
                  ? AstryxTextColor.primary
                  : AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}
```


Five tokens from one small definition, and every route through the engine is visible in them: `accent` was generated from the seed; `textAccent` was a `var()` reference to it; `backgroundCard` is a `light-dark()` pair, which is why its two columns differ; `element` was overridden by hand; and `fast` was never mentioned, so the token default stands.

## 3. Flutter values

`AstryxThemeData` takes a resolved set and a mode and parses the strings into `Color`, `double`, `Duration`, `Curve`, `FontWeight`, `TextStyle` and font stacks. The conversion is driven by the **token enums**, not by name prefixes — `--text-heading-1-weight` is a font weight and does not start with `--font-weight-`, so a prefix rule would put it in the wrong bucket.

This is also where the platform enters, and the only place it does: a font stack resolves differently on Apple platforms and on Windows. Everything else is platform-independent — see [Platform support](platform_support.md).

## Running the engine on its own

Layers 0 and 1 have no Flutter dependency, so a theme can be resolved in a plain Dart test, a build script, or a tool that emits tokens for something that is not Flutter at all.

```dart
import 'package:astryx_ui/theme.dart';

final tokens = AstryxResolvedTokenSet.resolve(myTheme);

tokens.value(AstryxColorToken.accent, AstryxThemeMode.light);  // '#0064E0'
tokens.pair(AstryxSpacingToken.spacing4);                      // ('16px', '16px')
tokens.forMode(AstryxThemeMode.dark);                          // the whole map
```

## The registry

`defineTheme` registers each theme under its name as a side effect, so a theme picker can enumerate what an application has defined without being handed a list. `getRegisteredTheme(name)` and `getRegisteredThemes()` read it; registering the same name twice replaces the earlier entry.

> **Note**
>
> The engine is a port, not a design. Every expander, the HCT colour model and the contrast maths are checked against upstream’s own test fixtures, so the same definition written in Dart and in TypeScript produces the same token values. See [Principles](principles.md).

## Related

- [Theming](theming.md) — the definition, from the outside.
- [Design tokens](tokens.md) — what the output is made of.
- [Styling](styling.md) — the escape hatches at each layer.

---

Something wrong with this page, or missing from it? [Report a problem](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Docs%3A+The+token+engine&component=Docs%3A+The+token+engine) · [Suggest a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Docs%3A+The+token+engine&area=Docs%3A+The+token+engine) — both templates arrive with the page filled in.
