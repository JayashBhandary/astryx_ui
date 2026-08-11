---
title: AstryxMobileNav
description: The navigation drawer a narrow viewport gets instead of the rail.
component: true
group: Navigation
source: lib/src/components/navigation/mobile_nav.dart
upstream: MobileNav / MobileNavToggle
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class MobileNavDemoExample extends StatefulWidget {
  const MobileNavDemoExample({super.key});

  @override
  State<MobileNavDemoExample> createState() => _MobileNavDemoExampleState();
}

class _MobileNavDemoExampleState extends State<MobileNavDemoExample> {
  final AstryxOverlayController _nav = AstryxOverlayController();
  String _section = 'deploys';

  @override
  void dispose() {
    _nav.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The drawer is a real overlay: it traps focus, closes on Escape or a
    // press on the scrim, and hands focus back to the button that opened it.
    // Closing it after a choice is the caller's, which is why `onSelected`
    // hides it here.
    return SizedBox(
      height: 260,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxMobileNavToggle(
                controller: _nav,
                size: AstryxButtonSize.sm,
              ),
              AstryxText('Showing $_section'),
            ],
          ),
          AstryxMobileNav(
            controller: _nav,
            entries: _entries,
            selectedId: _section,
            onSelected: (id) {
              setState(() => _section = id);
              _nav.hide();
            },
          ),
        ],
      ),
    );
  }
}
```


## Usage

```dart
AstryxMobileNav(
  controller: _nav,
  selectedId: _section,
  onSelected: (id) {
    setState(() => _section = id);
    _nav.hide();
  },
  entries: _entries,
)
```

> **Note**
>
> **Inside an [AstryxAppShell](app_shell.md) you do not need this.** Give the shell an [AstryxSideNav](side_nav.md) as its `sidebar` and it moves that into a drawer itself when the window is narrow. Reach for this when there is no shell, or when the navigation lives somewhere the shell does not know about.

The rows are drawn by the same code as the rail’s, so a drawer cannot drift from the navigation it stands in for.

## It is a real overlay

The `controller` is an `AstryxOverlayController`, and the drawer behaves like every other overlay in the package: focus is trapped in it, Escape and a press on the scrim close it, focus returns to the button that opened it, and it joins the same dismissal stack — so Escape closes the topmost thing rather than whatever was opened first.

> **Careful**
>
> **Closing the drawer after a choice is yours to do.** A drawer that closed itself would take a mis-tap as a navigation; one that never closed would cover the page the user just asked for. The `onSelected` in the snippet above calls `hide` for that reason.

## The toggle

`AstryxMobileNavToggle` with no `controller` drives the drawer of the enclosing shell — the common case, and the one where wiring a controller by hand would mean two sources of truth for whether the navigation is open.

```dart
// In an AstryxAppShell's header:
if (AstryxAppShell.of(context).compact) const AstryxMobileNavToggle()
```

### AstryxMobileNav

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` *(required)* | `AstryxOverlayController` | — | The open/closed state. |
| `entries` *(required)* | `List<AstryxNavEntry>` | — | The destinations, sections and dividers, in order. |
| `selectedId` | `String?` | — | The id of the current destination. |
| `onSelected` | `ValueChanged<String>?` | — | Called with the id the user chose. Closing the drawer is the caller’s. |
| `header` | `Widget?` | — | Content above the rows. |
| `footer` | `Widget?` | — | Content pinned below the rows. |
| `label` | `String?` | — | The drawer’s accessible name. |
| `width` | `double` | `280` | How wide the drawer is. |
| `density` | `AstryxItemDensity` | `AstryxItemDensity.compact` | The vertical rhythm the rows take. |


### AstryxMobileNavToggle

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `controller` | `AstryxOverlayController?` | — | The drawer to open. Null uses the enclosing shell’s. |
| `label` | `String?` | — | Overrides the accessible name and the tooltip. |
| `size` | `AstryxButtonSize` | `AstryxButtonSize.md` | The button size. |
| `variant` | `AstryxButtonVariant` | `AstryxButtonVariant.ghost` | The button variant. |


