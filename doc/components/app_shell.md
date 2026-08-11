---
title: AstryxAppShell
description: 'The outer frame of an application: header, navigation, content, and the responsive behaviour joining them.'
component: true
group: App shell
source: lib/src/components/shell/app_shell.dart
upstream: AppShell / useAppShellMobile
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class AppShellDemoExample extends StatefulWidget {
  const AppShellDemoExample({super.key});

  @override
  State<AppShellDemoExample> createState() => _AppShellDemoExampleState();
}

class _AppShellDemoExampleState extends State<AppShellDemoExample> {
  String _section = 'deploys';

  @override
  Widget build(BuildContext context) {
    // Narrow the frame and the navigation moves behind a drawer; widen it and
    // it comes back beside the content. The threshold is `compactBelow`, a
    // number that lives beside the widget that needs it.
    return SizedBox(
      height: 420,
      child: AstryxAppShell(
        compactBelow: 600,
        navLabel: 'Sections',
        header: const _ShellHeader(),
        sidebar: AstryxList(
          label: 'Sections',
          density: AstryxItemDensity.compact,
          children: <Widget>[
            for (final section in const <List<String>>[
              <String>['deploys', 'Deploys'],
              <String>['environments', 'Environments'],
              <String>['settings', 'Settings'],
            ])
              AstryxItem(
                label: section[1],
                selected: _section == section[0],
                onPressed: () => setState(() => _section = section[0]),
              ),
          ],
        ),
        child: AstryxLayout(
          header: AstryxHeading(_section, level: 1),
          child: const AstryxText(
            'The shell holds the application together. The page inside it is '
            'an AstryxLayout, which holds this heading still while the body '
            'scrolls under it.',
          ),
        ),
      ),
    );
  }
}

/// The bar across the top, with the menu button the compact layout needs.
class _ShellHeader extends StatelessWidget {
  const _ShellHeader();

  @override
  Widget build(BuildContext context) {
    // `AstryxAppShell.of` is the port of upstream's `useAppShellMobile`: a
    // header cannot know whether to draw a menu button without knowing where
    // the navigation went, and that answer belongs to the shell.
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Acme', type: AstryxTextType.label),
          const Spacer(),
          const AstryxBadge('Production'),
        ],
      ),
    );
  }
}
```


## Usage

```dart
import 'package:astryx_ui/astryx_ui.dart';
```

```dart
AstryxAppShell(
  header: const AppBar(),
  sidebar: const NavRail(),
  child: AstryxLayout(
    header: const AstryxHeading('Deploys', level: 1),
    child: const DeployTable(),
  ),
)
```

```text
AstryxAppShell
├── header    ← full width, above everything
├── sidebar   ← beside the content, or behind a drawer
└── child     ← the content. Usually one AstryxLayout
```

The header spans the whole window by design: an application’s identity and its account menu belong to the window, not to the column beside the navigation.

## Wide, and narrow

Above `compactBelow` the navigation sits beside the content. Below it, the navigation moves behind a drawer — and the drawer is a real [AstryxOverlay](overlay.md), so it traps focus, closes on Escape or a press on the scrim, and hands focus back to the button that opened it. A shell that hides navigation without any of that is a shell that loses keyboard users at the first tap.

Growing back out of the compact layout closes the drawer, because a drawer left open would be a second copy of the navigation now sitting beside the content.

> **Note**
>
> `compactBelow` is a number, not an entry in a breakpoint table. This package has [no breakpoint system](../guides/layout_guide.md) on purpose: the width at which *your* navigation stops fitting is a fact about your navigation, and a global table means every screen has to agree about a number none of them chose.

## Asking the shell where the navigation went

`AstryxAppShell.of(context)` is the port of upstream’s `useAppShellMobile`. A header cannot know whether to draw a menu button without knowing whether the navigation is beside the content or behind a drawer, and that answer belongs to the shell.

```dart
final shell = AstryxAppShell.of(context);

if (shell.compact)
  AstryxIconButton(
    icon: AstryxIconName.menu,
    label: 'Open navigation',
    onPressed: shell.controller.toggle,
  )
```

`AstryxAppShellController` is an `AstryxOverlayController`, because the drawer *is* one of this package’s overlays: `show`, `hide` and `toggle` mean here what they mean on a [dialog](dialog.md), and the drawer joins the same dismissal stack — so Escape closes the topmost thing rather than whatever was opened first.

> **Careful**
>
> There is no navigation rail in this package yet — `SideNav`, `TopNav` and `MobileNav` are still to come. `header` and `sidebar` take any widget, and an [AstryxList](list.md) of [AstryxItem](item.md)s gets a long way in the meantime.

### AstryxAppShell

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content: usually one `AstryxLayout`. |
| `header` | `Widget?` | — | The bar across the top, above both the navigation and the content. |
| `sidebar` | `Widget?` | — | The navigation. Beside the content when there is room, behind a drawer when there is not. |
| `controller` | `AstryxAppShellController?` | — | Drives the drawer from outside. Null keeps one inside the shell. |
| `sidebarWidth` | `double` | `260` | How wide the navigation is when it sits beside the content. |
| `compactBelow` | `double` | `900` | The width below which the navigation moves into the drawer. |
| `navLabel` | `String?` | — | The drawer’s accessible name. |


### AstryxAppShellScope

What `AstryxAppShell.of(context)` returns.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `compact` | `bool` | — | Whether the navigation is behind a drawer rather than beside the content. |
| `controller` | `AstryxAppShellController` | — | The drawer’s controller — `show`, `hide`, `toggle`, `isOpen`. |


## Related

- [AstryxLayout](layout.md) — the frame *inside* this one.
- [AstryxOverlay](overlay.md) — the primitive the drawer is built on.

