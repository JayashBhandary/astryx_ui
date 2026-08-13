---
title: useTheme → AstryxTheme.of
description: Reading the theme in scope, and why there is no hook.
component: true
group: Hooks & controllers
source: lib/src/theme/astryx_theme.dart
upstream: useTheme
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream needs a hook because CSS custom properties are invisible to JavaScript: a component that wants the resolved value of `--color-accent` has to ask a context for it. Flutter has one mechanism for exactly this, and it is older than hooks.

```dart
final theme = AstryxTheme.of(context);

theme.color(AstryxColorToken.accent);         // Color
theme.spacing(AstryxSpacingToken.spacing3);   // 8.0
theme.textStyle(AstryxTypeRole.body);         // TextStyle
theme.duration(AstryxDurationToken.fast);     // Duration
```

`of(context)` **subscribes** as well as reads: a widget that calls it rebuilds when the theme above it changes, and nothing has to be wired up to make that happen. That is the half a hook is usually praised for, and here it is the framework’s.

```dart
class HookThemeExample extends StatelessWidget {
  const HookThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `AstryxTheme.of(context)` is the whole of `useTheme`: a lookup up the
    // tree, and a subscription to it — this widget rebuilds when the theme
    // changes, with nothing wired up to make that happen.
    final theme = AstryxTheme.of(context);

    return AstryxMetadataList(
      items: <AstryxMetadataItem>[
        AstryxMetadataItem.text(label: 'Mode', value: theme.mode.name),
        AstryxMetadataItem.text(
          label: 'Platform',
          value: theme.platform.name,
        ),
        AstryxMetadataItem.text(
          label: 'Density',
          value: AstryxTheme.densityOf(context).name,
        ),
        AstryxMetadataItem(
          label: 'accent',
          value: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.accent),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
                ),
              ),
              AstryxCode(
                'spacing3 = ${theme.spacing(AstryxSpacingToken.spacing3)}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```


## The rest of the family

| Upstream hook | Here |
| --- | --- |
| `useTheme` | `AstryxTheme.of(context)` |
| `useTheme().mode` | `AstryxTheme.of(context).mode`, and `.brightness` for the Flutter enum |
| — (a media query upstream) | `AstryxTheme.densityOf(context)`, which is the pointer/touch answer |
| `useIcons` | `AstryxTheme.iconsOf(context)` |
| `useTranslator` | `AstryxLocalizations.of(context)` |
| `useLinkComponent` | `AstryxLinkDelegate.of(context)` |

> **Careful**
>
> Reach for this only when building something the design system has no widget for — a custom painter, a chart, a one-off surface. A raw token read inside a screen is usually a sign that a component exists and was not used.

> **Note**
>
> `AstryxTheme.of` throws when there is no provider above it, with a fix-it naming both entry points. `maybeOf` is the nullable form, for a widget that must survive outside a theme.

## Related

- [AstryxThemeProvider](theme.md) — what installs the scope.
- [Design tokens](../guides/tokens.md) — everything reachable through it.
- [Styling](../guides/styling.md) — extending a component without leaving the tokens.

---

Something wrong with `useTheme → AstryxTheme.of`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useTheme+%E2%86%92+AstryxTheme.of&component=useTheme+%E2%86%92+AstryxTheme.of) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useTheme+%E2%86%92+AstryxTheme.of&area=useTheme+%E2%86%92+AstryxTheme.of) — both templates arrive with the component filled in.
