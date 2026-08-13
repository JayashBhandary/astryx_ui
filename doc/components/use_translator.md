---
title: useTranslator → AstryxLocalizations.of
description: Looking up a translated string.
component: true
group: Hooks & controllers
source: lib/src/localizations/astryx_localizations.dart
upstream: useTranslator
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream looks a key up in a map. Here the strings are **getters and methods on a class**, so a missing one is a compile error rather than a blank on screen, and a typo in a key is not expressible.

```dart
class HookTranslatorExample extends StatelessWidget {
  const HookTranslatorExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Getters and methods on a class, not keys in a map: a missing string is a
    // compile error, and a method keeps word order in the translator's hands.
    final l10n = AstryxLocalizations.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxMetadataList(
          items: <AstryxMetadataItem>[
            AstryxMetadataItem.text(
              label: 'fieldRequired',
              value: l10n.fieldRequired,
            ),
            AstryxMetadataItem.text(
              label: 'clearField(…)',
              value: l10n.clearField('Email'),
            ),
            AstryxMetadataItem.text(
              label: 'paginationPage(…)',
              value: l10n.paginationPage(3, 20),
            ),
          ],
        ),
        const AstryxDivider(label: 'Overridden for the subtree below'),
        AstryxLocalizationsScope(
          localizations: const TerseLocalizations(),
          child: Builder(
            builder: (context) {
              final terse = AstryxLocalizations.of(context);

              return AstryxMetadataList(
                items: <AstryxMetadataItem>[
                  AstryxMetadataItem.text(
                    label: 'fieldRequired',
                    value: terse.fieldRequired,
                  ),
                  AstryxMetadataItem.text(
                    label: 'clearField(…)',
                    value: terse.clearField('Email'),
                  ),
                  AstryxMetadataItem.text(
                    label: 'paginationPage(…)',
                    // Not overridden, so the English default still answers.
                    value: terse.paginationPage(3, 20),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
```


```dart
final l10n = AstryxLocalizations.of(context);

l10n.dialogClose;              // 'Close'
l10n.clearField('Email');      // 'Clear Email'
l10n.paginationPage(3, 20);    // 'Page 3 of 20'

```

A method rather than an interpolated template for anything with a placeholder: word order is part of a translation, and a template like "{count} items" cannot be reordered by a translator while a Dart method can.

> **Note**
>
> `of(context)` **never returns null**, falling back to the English defaults. A missing localisation should not be an exception in front of a user, and a partial translation should be a working app with some English in it.

It is also a subscription: override the strings for a subtree with an [AstryxLocalizationsScope](internationalization_provider.md) and everything below it rebuilds.

## These are the widgets’ strings, not yours

`AstryxLocalizations` covers what the *widget set* says — "Required", "No matches", "Sort ascending", "3 minutes ago". Your own copy belongs in your own localisations, through `flutter_localizations` and the ARB tooling, which this package neither wraps nor replaces.

> **Careful**
>
> Do not read a string out of here to label something of your own — `l10n.tableNoData` on your empty state ties your copy to a widget’s wording, and the next release is entitled to change it.

## Related

- [AstryxLocalizationsScope](internationalization_provider.md) — installing and overriding the strings.
- [Right-to-left](../guides/rtl.md) — the other half of internationalisation, which is a `Directionality` and nothing else.

---

Something wrong with `useTranslator → AstryxLocalizations.of`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useTranslator+%E2%86%92+AstryxLocalizations.of&component=useTranslator+%E2%86%92+AstryxLocalizations.of) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useTranslator+%E2%86%92+AstryxLocalizations.of&area=useTranslator+%E2%86%92+AstryxLocalizations.of) — both templates arrive with the component filled in.
