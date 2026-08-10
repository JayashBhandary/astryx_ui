---
title: Installation
description: Add the package, wrap your app once, and you are done.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

## Add the dependency

*pubspec.yaml*

```yaml
dependencies:
  astryx_ui: ^0.0.4-dev
```

This is a **pre-release**, and a bare `flutter pub add` will not select one — name the version:

```bash
flutter pub add astryx_ui:^0.0.4-dev
```

To track the repository rather than a release:

*pubspec.yaml — from git*

```yaml
dependencies:
  astryx_ui:
    git: https://github.com/JayashBhandary/astryx_ui.git
```

## Wrap your app

`AstryxApp` is a `WidgetsApp` with everything installed: the theme, the icon registry, the localisations, the focus-visible scope and the toast host.

```dart
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);
```

Deliberately built on `WidgetsApp`, not `MaterialApp`: Astryx has its own colour, typography and spacing model, and inheriting Material’s would mean every widget neutralising its defaults.

## Adopting incrementally

Inside an existing `MaterialApp` or `CupertinoApp`, use the provider instead. It installs the same machinery and works anywhere in the tree, so a single screen can adopt the design system without the app converting.

```dart
MaterialApp(
  home: AstryxThemeProvider(
    child: const HomePage(),
  ),
)
```

That is the whole setup. Toasts, tooltips, dialogs and focus rings all work from here with nothing else to wire.

## Import surfaces

| Import | Gives you |
| --- | --- |
| `package:astryx_ui/astryx_ui.dart` | Everything: the theme layer and every component. |
| `package:astryx_ui/theme.dart` | Tokens, `AstryxThemeData` and the engine, with no widgets — for a chart library, a custom painter, or a test. |

## Run this site

```bash
cd example
flutter run -d chrome

# after editing anything in lib/examples/
dart run tool/gen_snippets.dart
```

