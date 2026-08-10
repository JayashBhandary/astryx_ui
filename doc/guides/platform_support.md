---
title: Platform support
description: 'Which Flutter platforms are exercised, and where behaviour differs. The Flutter counterpart of upstream''s browser-support page.'
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One target, and what the package resolves for it.
///
/// The glyphs come from Lucide directly rather than from `AstryxIconName`,
/// which names only what the widget set itself needs. Every icon slot takes a
/// `Widget`, so an application's own icons go in the same way.
typedef _Target = ({
  String name,
  IconData icon,
  String density,
  AstryxPalette palette,
  String note,
});

const List<_Target> _targets = <_Target>[
  (
    name: 'Android',
    icon: LucideIcons.smartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: '48px tap targets, hover suppressed.',
  ),
  (
    name: 'iOS',
    icon: LucideIcons.tabletSmartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: 'The same, and the same tap target.',
  ),
  (
    name: 'macOS',
    icon: LucideIcons.laptop,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Menlo heads the monospace stack.',
  ),
  (
    name: 'Windows',
    icon: LucideIcons.monitor,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Consolas heads the monospace stack.',
  ),
  (
    name: 'Linux',
    icon: LucideIcons.terminal,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'The generic families stand.',
  ),
  (
    name: 'Fuchsia',
    icon: LucideIcons.cpu,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Resolved, though untested in the wild.',
  ),
  (
    name: 'Web',
    icon: LucideIcons.globe,
    density: 'either',
    palette: AstryxPalette.gray,
    note: 'Pointer precision decides, not the host OS.',
  ),
];

class PlatformTargetsExample extends StatelessWidget {
  const PlatformTargetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final target in _targets)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    // Decorative: the name is right beside it, so announcing
                    // the glyph as well would say everything twice.
                    ExcludeSemantics(
                      child: Icon(
                        target.icon,
                        size: AstryxIconSize.lg.pixels,
                        color: theme.color(AstryxColorToken.iconSecondary),
                      ),
                    ),
                    Flexible(
                      child: AstryxText(
                        target.name,
                        type: AstryxTextType.label,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                AstryxHStack(
                  children: <Widget>[
                    AstryxBadge(
                      target.density,
                      variant: AstryxBadgeVariant.palette(target.palette),
                    ),
                  ],
                ),
                AstryxText(
                  target.note,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```


Upstream publishes a browser support matrix. The Flutter counterpart is shorter than a matrix: **everywhere Flutter runs**. There is no conditional import in the package, no `dart:io`, no `kIsWeb`, no method channel and no plugin — its `flutter:` section is empty, so there is no platform for it to fail to support.

## What actually varies

| Thing | How it differs |
| --- | --- |
| Density | iOS and Android resolve to `touch`; macOS, Windows, Linux and Fuchsia to `pointer`. A `MediaQuery` reporting a coarse pointer overrides both. |
| Font stacks | A CSS generic expands to different concrete families per platform — Menlo on Apple, Consolas on Windows. A stack leading with a system alias resolves to a *null* family, which is Flutter’s way of saying "the platform UI font". |
| Everything else | Identical. Colour, spacing, type, motion, focus, semantics and keyboard behaviour are the same on every target. |

Both differences run through `TargetPlatform`, which means both are overridable: `AstryxThemeProvider.platform` forces the answer, which is how a test — or the picker at the top of this page — previews another platform’s rendering.

## The web

The web is the case worth understanding, because the platform Flutter reports there is the *host OS* rather than the input device. A Chromebook with a mouse attached reports Android; a Windows tablet with no mouse reports Windows. That is exactly why density consults pointer precision first and the platform second — see [Density](density.md).

This documentation site is the package running in Flutter web, in eight themes and both densities. It is the standing proof, and any rendering bug on the web is visible on the page you are reading.

## Deliberately the same everywhere

- **Text selection handles** are one shape on every platform, coloured from `--color-accent`. Astryx never ran natively, so imitating a platform’s own handles would be inventing rather than porting.
- **Keyboard behaviour** is the design system’s, not the platform’s: arrows inside composite controls, `Escape` closing one layer at a time, `Enter` and `Space` activating. No shortcut in the package competes with an application’s own.
- **Focus rings** appear for keyboard focus and not for a click, on every target, because the rule is `:focus-visible` rather than a platform convention.

## Versions

| Requires | Version |
| --- | --- |
| Dart | `>=3.9.0 <4.0.0` |
| Flutter | `>=3.35.0` |

## How it is verified

- Over 900 tests, run on the Dart VM. Widget tests pump the widgets directly, so they exercise the same code every target runs.
- Platform-dependent behaviour is tested by *forcing* the platform rather than by running on it: density, font-stack resolution and tap targets each have cases per `TargetPlatform`.
- The golden suite is tagged `golden` and excluded elsewhere with `--exclude-tags golden`. Rasterised output is only stable for a pinned Flutter version, so a golden failure on a newer version is a version difference rather than a regression.

> **Note**
>
> The example app in this repository has runners for Android, iOS, Linux, macOS and web — not Windows. Nothing in the package is Windows-specific and the font stack has an explicit Windows branch, but if you ship there, add the runner and look at it yourself rather than taking this page’s word for it.

## Related

- [Density](density.md) — the pointer and touch difference, in detail.
- [Typography](typography.md) — the font stacks that resolve per platform.
- [The token engine](core.md) — where platform resolution happens.

