---
title: Styling
description: 'Extending a component''s appearance without leaving the token system.'
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Four ways to change how something looks, in the order you should reach for them. Each one is narrower than the last, and all four resolve through the same tokens — which is what keeps a customised screen themeable.

| Reach for | When |
| --- | --- |
| A widget parameter | Almost always. `variant`, `size`, `padding`, `gap` — the axes the component already has. |
| `theme:` on the widget | One instance genuinely differs. Takes that widget’s theme class. |
| `AstryxTheme` with `copyWith` | Every instance in a subtree, or in the whole app. |
| `tokens:` on the theme | The value itself is wrong for your product — a tighter radius, a different spacing step. Changes everything at once. |

```dart
class StylingScopesExample extends StatelessWidget {
  const StylingScopesExample({super.key});

  /// Square corners and a heavier label, as a component theme.
  ///
  /// Every field is nullable, and null means "fall through to the token
  /// default" — so this changes two things and inherits the rest.
  static const AstryxButtonTheme _squared = AstryxButtonTheme(
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 210,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Scope(
          title: 'the theme',
          note: 'Nothing overridden.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ),
        _Scope(
          title: 'one button',
          note: '`theme:` on the widget.',
          child: AstryxButton(
            label: 'Save',
            variant: AstryxButtonVariant.primary,
            theme: _squared,
            onPressed: () {},
          ),
        ),
        // Everything below inherits it — including a button three widgets deep
        // that knows nothing about this.
        AstryxTheme(
          data: AstryxTheme.of(context).copyWith(button: _squared),
          density: AstryxTheme.densityOf(context),
          icons: AstryxTheme.iconsOf(context),
          child: _Scope(
            title: 'a subtree',
            note: '`AstryxTheme` with `copyWith`.',
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Save',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                ),
                AstryxButton(label: 'Cancel', onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Scope extends StatelessWidget {
  const _Scope({required this.title, required this.note, required this.child});

  final String title;
  final String note;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(title, type: AstryxTextType.label),
          child,
          AstryxText(
            note,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```


## Component themes

A component theme is a small immutable class carrying only that widget’s visual properties, **every field nullable** — null means "fall through to the token default", so overriding one state does not mean restating the others. Resolution is always: the widget’s own property, then the inherited component theme, then the token.

| Class | Applies to | Carries |
| --- | --- | --- |
| `AstryxButtonTheme` | `AstryxButton`, `AstryxIconButton` | Backgrounds per state, foreground, border, radius, padding, gap, text style, height, icon size, shadows, cursors. |
| `AstryxTextTheme` | `AstryxText`, `AstryxHeading` | A `TextStyle` and an alignment. `text` and `heading` are separate slots on the theme. |
| `AstryxIconTheme` | `AstryxIcon` | Size and colour. |
| `AstryxDividerTheme` | `AstryxDivider` | Thickness, colour and inset. |

Those four are what exist today. Everything else is styled through its own parameters and the tokens beneath them.

## For a subtree, or the whole app

```dart
Builder(
  builder: (context) => AstryxTheme(
    data: AstryxTheme.of(context).copyWith(
      button: const AstryxButtonTheme(borderRadius: BorderRadius.zero),
    ),
    // Inherited scopes are not automatic — carry them across.
    density: AstryxTheme.densityOf(context),
    icons: AstryxTheme.iconsOf(context),
    child: const HomePage(),
  ),
)
```

The `Builder` is there so the `context` is *below* the provider that installed the theme. Put this immediately under `AstryxApp` or `AstryxThemeProvider` for an application-wide change, or around a single pane for a local one.

> **Note**
>
> `AstryxTheme` replaces the density and icon registry rather than inheriting them, so pass both through as above. Forget them and a custom icon set quietly reverts to Lucide, and a touch device loses its 48px targets.

## When the value itself is wrong

If every button should be square, the radius scale is the honest place to say so — not a component theme repeated in four files. `tokens:` beats every generated value, and a scale config moves a whole family at once.

```dart
final acme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    radius: AstryxRadiusScaleConfig(base: 4, multiplier: 0),
    tokens: <String, AstryxTokenValue>{
      '--color-border': AstryxTokenValue('#8F9296'),
    },
  ),
);
```

## Building something the widget set has not got

Read the tokens and compose. A widget written this way is themeable by construction: it follows all eight themes, both brightnesses and any custom accent without knowing that any of them exist.

```dart
final theme = AstryxTheme.of(context);

DecoratedBox(
  decoration: BoxDecoration(
    color: theme.color(AstryxColorToken.backgroundCard),
    borderRadius: theme.borderRadius(AstryxRadiusToken.container),
    border: Border.all(color: theme.color(AstryxColorToken.border)),
    boxShadow: theme.boxShadows(AstryxShadowToken.low),
  ),
  child: Padding(
    padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
    child: Text('…', style: theme.textStyle(AstryxTypeRole.body)),
  ),
)
```

> **Careful**
>
> The one thing not to do is reach past the system: a `Color(0xFF…)`, a `TextStyle(fontSize: 14)`, an `EdgeInsets.all(16)`. Each compiles, looks right in the theme you are using, and is wrong in the other seven — and in dark mode, and at the next density.

## A note on `components:`

A theme definition also takes a `components:` map of CSS-style property overrides. It is a faithful port of upstream’s `ComponentStyleMap` and is carried, merged and compared like the rest of a definition — but the Flutter widgets read the typed component themes above, not CSS strings. Use it when you are keeping a Dart theme definition in step with a TypeScript one; use `AstryxButtonTheme` and friends to change how a button looks.

## Related

- [Theming](theming.md) — defining a theme, and the layers within one.
- [Design tokens](tokens.md) — what the escape hatches resolve to.
- [Shape](shape.md) — the radius scale, for the square-corners case.

