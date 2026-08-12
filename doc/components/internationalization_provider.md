---
title: AstryxLocalizationsScope
description: Locale, text direction and the strings, supplied to the tree.
component: true
group: Providers
source: lib/src/localizations/astryx_localizations.dart
upstream: InternationalizationProvider
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream’s `InternationalizationProvider` carries three things: the strings, the text direction, and the locale. In Flutter those already live in three different places, and only the first is this package’s to supply.

| Upstream | Here | Installed by |
| --- | --- | --- |
| Translated strings | `AstryxLocalizations` + `AstryxLocalizationsScope` | `AstryxThemeProvider(localizations: …)` |
| `dir="rtl"` | `Directionality` | Flutter’s own, from the locale or set by hand |
| The locale | `Locale`, `localizationsDelegates` | `AstryxApp` / `MaterialApp` |

## Usage

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

**Subclass and override only what changes.** Every string has a default, so a partial translation is a working app with some English in it rather than a crash or a run of missing-key placeholders. `AstryxLocalizations.of(context)` never returns null for the same reason: a missing localisation should not be an exception in front of a user.

```dart
class ProviderLocalizationsExample extends StatefulWidget {
  const ProviderLocalizationsExample({super.key});

  @override
  State<ProviderLocalizationsExample> createState() =>
      _ProviderLocalizationsExampleState();
}

class _ProviderLocalizationsExampleState
    extends State<ProviderLocalizationsExample> {
  bool _rtl = false;
  DateTime? _day;

  @override
  Widget build(BuildContext context) {
    // Two halves, and they are independent. The strings come from a
    // localisations subclass; the direction comes from `Directionality`, which
    // is Flutter's own and needs nothing from this package.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSwitch(
          label: 'Right to left',
          value: _rtl,
          onChanged: (value) => setState(() => _rtl = value),
        ),
        AstryxLocalizationsScope(
          localizations: const FrenchLocalizations(),
          child: Directionality(
            textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
            child: AstryxCard(
              child: AstryxCalendar(
                selected: _day,
                today: DateTime(2026, 8, 4),
                onChanged: (day) => setState(() => _day = day),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```


> **Note**
>
> English only for 1.0, and that is deliberate: what matters now is the delegate *structure*, so adding a locale later is additive rather than breaking. The same seam is where a product rewords a string to its own voice — "Dismiss notification" is not wrong, but it may not be yours.

## What is in there

| Group | Covers |
| --- | --- |
| Actions | Closing a dialog, a popover, a banner, a toast. `bannerDismiss` and `toastDismiss` are deliberately separate — one is persistent and one transient, and they translate differently. |
| Forms | The required and optional markers, placeholders, the clear button, character counts, and the rejection messages a number, date or time field announces. |
| Date and time | The month and weekday names, `am`/`pm`, the calendar’s buttons, and the relative phrases a timestamp uses. There is no `intl` dependency, so these are the whole of it. |
| Text selection | Cut, copy, paste and friends — Astryx builds its own selection toolbar rather than Material’s, so it needs its own strings. |
| Tables, lists, navigation | Sort directions, row selection, overflow counts, pagination, and `linkExternal` — the phrase said after a link that leaves the app. |

## Text direction

RTL is a `Directionality` and nothing else. The widget set is logical throughout — `start`/`end`, `EdgeInsetsDirectional`, mirrored icons — so nothing else has to be told. That is why this page has no `textDirection` property to document.

### AstryxLocalizations

An immutable class of getters and methods, not a map of keys — so a missing override is a compile-time impossibility rather than a runtime blank.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `of(context)` | `AstryxLocalizations` | — | The strings in scope, falling back to the English defaults. |


### AstryxLocalizationsScope

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `localizations` *(required)* | `AstryxLocalizations` | — | The strings for this subtree. |
| `child` *(required)* | `Widget` | — | The subtree. |


## Related

- [Right-to-left](../guides/rtl.md) — the rules that make a `Directionality` enough.
- [Accessibility](../guides/accessibility.md) — where these strings end up.

