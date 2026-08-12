# Providers

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxThemeProvider

`lib/src/app/astryx_theme_provider.dart` · upstream `Theme`

The provider that puts a resolved theme in scope — and everything else the widgets need.

```dart
AstryxApp(
  theme: neutralTheme,
  home: const HomePage(),
)
```

**Rules**

- **Careful:** `AstryxTheme.of` throws a `FlutterError` with a fix-it when there is no provider above it, rather than falling back to a default. A widget silently painting unthemed colours is a bug that ships; an exception on the first frame is one that does not.

| `AstryxColorMode` | Resolves to |
| --- | --- |
| `system` | The platform’s own preference, through `MediaQuery.platformBrightnessOf` — so the theme tracks a change without the app rebuilding anything. The default. |
| `light` | Always light. |
| `dark` | Always dark. |

### AstryxThemeProvider

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The subtree to theme. |
| `theme` | `AstryxDefinedTheme?` | — | The theme to resolve. Null uses the Astryx defaults, which are a complete and usable theme rather than a placeholder. |
| `mode` | `AstryxColorMode` | `AstryxColorMode.system` | Which colour mode to resolve. |
| `density` | `AstryxDensity?` | — | Overrides the resolved interaction density. Null derives it from the platform and the pointer precision `MediaQuery` reports. |
| `icons` | `AstryxIconRegistry?` | — | The icon registry for this subtree. Null uses the Lucide-backed defaults. |
| `localizations` | `AstryxLocalizations` | `AstryxLocalizations()` | The strings the widgets use. |
| `platform` | `TargetPlatform?` | — | Overrides the platform used for density and font-stack resolution. For tests, and for previewing another platform. |
| `linkDelegate` | `AstryxLinkDelegate?` | — | What following a link means. Null means links do nothing. |
| `toastController` | `AstryxToastController?` | — | The controller the toast host renders from. Null lets the provider own one. |
| `toastPosition` | `AstryxToastPosition?` | — | Where the toast stack sits. Null follows the resolved density. |

### AstryxTheme

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `of(context)` | `AstryxThemeData` | — | The resolved theme. Throws when there is none. |
| `maybeOf(context)` | `AstryxThemeData?` | — | The resolved theme, or null — for a widget where a theme is genuinely optional. |
| `densityOf(context)` | `AstryxDensity` | — | The density in effect, falling back to the platform. |
| `iconsOf(context)` | `AstryxIconRegistry` | — | The icon registry in effect. |

---

## The overlay layer

`lib/src/foundation/overlay_stack.dart` · upstream `LayerProvider`

The stacking context overlays are raised into.

```dart
class ProviderLayerExample extends StatefulWidget {
  const ProviderLayerExample({super.key});

  @override
  State<ProviderLayerExample> createState() => _ProviderLayerExampleState();
}

class _ProviderLayerExampleState extends State<ProviderLayerExample> {
  final AstryxOverlayController _layer = AstryxOverlayController();

  @override
  void dispose() {
    _layer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two layers, one on top of the other. Escape closes the popover and leaves
    // the panel — the stack keeps the order, so one press is one layer.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Raise a layer', onPressed: _layer.show),
        AstryxOverlay(
          controller: _layer,
          label: 'Export',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Export',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'Open the menu, then press Escape twice: the menu goes '
                  'first, this panel second.',
                ),
                AstryxDropdownMenu(
                  label: 'Format',
                  entries: <AstryxMenuEntry>[
                    AstryxMenuItem(label: 'CSV', onSelected: () {}),
                    AstryxMenuItem(label: 'JSON', onSelected: () {}),
                  ],
                  triggerBuilder: (context, controller) => AstryxButton(
                    label: 'Format',
                    onPressed: controller.toggle,
                  ),
                ),
                AstryxButton(label: 'Close', onPressed: _layer.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** Order is push order, and that is sound rather than lucky: a Flutter overlay opens when something calls `show`, and the inner one is always shown after the outer one that contains its trigger.
- **Accessibility:** A modal layer sets `scopesRoute` in its semantics, which is what tells a screen reader the page behind it is inert. Set it false for a layer that is merely floating — announcing a page as unavailable when it is not is worse than saying nothing.

### AstryxOverlayStack

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `push(onDismiss)` | `void` | — | Registers a layer as the top-most one. |
| `remove(onDismiss)` | `void` | — | Removes a layer, wherever it sits — a layer can be closed programmatically while something above it is still open. |
| `isTopmost(onDismiss)` | `bool` | — | Whether that layer is the one Escape would close. |
| `dismissTopmost()` | `bool` | — | Dismisses the top-most layer, and reports whether there was one — so a key handler can let Escape reach what is behind it. |

---

## AstryxLinkScope

`lib/src/foundation/link_delegate.dart` · upstream `LinkProvider`

How links navigate — supplied once, so components need not know the router.

```dart
AstryxApp(
  linkDelegate: AstryxLinkDelegate.fromCallback((uri, {target}) {
    if (uri.hasScheme) {
      launchUrl(uri);            // package:url_launcher
    } else {
      GoRouter.of(context).go(uri.toString());
    }
  }),
  home: const HomePage(),
)
```

**Rules**

- **Careful:** `href` goes through the delegate; `onPressed` does not. A link with an `onPressed` calls it directly, which is the right choice for something that is not really a destination — opening a panel, revealing a row. Give a link one or the other, not both.

### AstryxLinkDelegate

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `followLink(uri, {target})` | `void` | — | Follows `uri`. `target` carries a hint about where to open, for the web; other platforms may ignore it. |
| `AstryxLinkDelegate.fromCallback(onFollow)` | `factory` | — | Builds one from a callback, which is what most apps want. |
| `AstryxLinkDelegate.none` | `static const` | — | The default: a debug warning, and nothing else. |
| `of(context)` | `AstryxLinkDelegate` | — | The delegate in scope, or `none` when there is none. |

### AstryxLinkScope

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `delegate` **(required)** | `AstryxLinkDelegate` | — | The delegate for this subtree. |
| `child` **(required)** | `Widget` | — | The subtree. |

---

## AstryxLocalizationsScope

`lib/src/localizations/astryx_localizations.dart` · upstream `InternationalizationProvider`

Locale, text direction and the strings, supplied to the tree.

```dart
class FrLocalizations extends AstryxLocalizations {
  const FrLocalizations();

  @override
  String get dialogClose => 'Fermer';

  @override
  String clearField(String label) => 'Effacer $label';
}

AstryxApp(
  localizations: const FrLocalizations(),
  home: const HomePage(),
)
```

**Rules**

- **Note:** English only for 1.0, and that is deliberate: what matters now is the delegate *structure*, so adding a locale later is additive rather than breaking. The same seam is where a product rewords a string to its own voice — "Dismiss notification" is not wrong, but it may not be yours.

| Upstream | Here | Installed by |
| --- | --- | --- |
| Translated strings | `AstryxLocalizations` + `AstryxLocalizationsScope` | `AstryxThemeProvider(localizations: …)` |
| `dir="rtl"` | `Directionality` | Flutter’s own, from the locale or set by hand |
| The locale | `Locale`, `localizationsDelegates` | `AstryxApp` / `MaterialApp` |

| Group | Covers |
| --- | --- |
| Actions | Closing a dialog, a popover, a banner, a toast. `bannerDismiss` and `toastDismiss` are deliberately separate — one is persistent and one transient, and they translate differently. |
| Forms | The required and optional markers, placeholders, the clear button, character counts, and the rejection messages a number, date or time field announces. |
| Date and time | The month and weekday names, `am`/`pm`, the calendar’s buttons, and the relative phrases a timestamp uses. There is no `intl` dependency, so these are the whole of it. |
| Text selection | Cut, copy, paste and friends — Astryx builds its own selection toolbar rather than Material’s, so it needs its own strings. |
| Tables, lists, navigation | Sort directions, row selection, overflow counts, pagination, and `linkExternal` — the phrase said after a link that leaves the app. |

### AstryxLocalizations

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `of(context)` | `AstryxLocalizations` | — | The strings in scope, falling back to the English defaults. |

### AstryxLocalizationsScope

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `localizations` **(required)** | `AstryxLocalizations` | — | The strings for this subtree. |
| `child` **(required)** | `Widget` | — | The subtree. |

---

## AstryxSyntaxTheme

`lib/src/theme/engine/syntax_theme.dart` · upstream `SyntaxTheme`

The token colours a code block highlights with.

```dart
final theme = AstryxTheme.of(context);

theme.syntaxColor(AstryxSyntaxToken.keyword);  // Color?, or null
theme.hasSyntaxPalette;                        // bool
theme.syntaxPalette;                           // the whole map
```

**Rules**

- **Careful:** **Nothing in this package paints with them.** `AstryxCodeBlock` does not highlight, by decision rather than omission: shipping a tokeniser for every language somebody might paste is not a design system’s job, and a bad one is worse than none. The palette is here so that a highlighter *you* wire takes its colours from the theme instead of from fourteen hex values sitting beside it.
- **Accessibility:** A palette is decoration over text that is already readable: contrast still has to hold against `background`, and colour must never be the only thing distinguishing one part of a sample from another. A reader who cannot separate the greens from the greys should still be reading code, not guessing at it.

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

### AstryxSyntaxTheme

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `name` **(required)** | `String` | — | The palette’s name. |
| `tokens` **(required)** | `Map<String, String>` | — | Resolved values keyed by short name — `keyword`, `string` — with no `--color-syntax-` prefix. |
| `AstryxSyntaxTheme.define({name, tokens})` | `factory` | — | Builds one from `AstryxTokenValue`s, flattening light/dark pairs to `light-dark()` strings. Upstream’s `defineSyntaxTheme`. |

### AstryxSyntaxToken

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `key` | `String` | — | The short name — `keyword`, `string`. |
| `cssName` | `String` | — | The full token name — `--color-syntax-keyword`. |

---

