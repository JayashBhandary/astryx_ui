---
title: AstryxRovingFocus.grid
description: Two-dimensional arrow-key traversal across a grid.
component: true
group: Hooks & controllers
source: lib/src/foundation/roving_focus.dart
upstream: useGridFocus
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookGridFocusExample extends StatefulWidget {
  const HookGridFocusExample({super.key});

  @override
  State<HookGridFocusExample> createState() => _HookGridFocusExampleState();
}

class _HookGridFocusExampleState extends State<HookGridFocusExample> {
  static const List<AstryxPalette> _palettes = AstryxPalette.values;

  AstryxPalette? _picked;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // The inline arrows move within a row, the block arrows between rows, and
    // Home and End reach the ends of *that row* rather than of the grid. It
    // does not wrap: stepping off a row's end would silently change rows.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxRovingFocus.grid(
          length: _palettes.length,
          columns: 3,
          label: 'Team colour',
          gap: AstryxSpacingToken.spacing2,
          onActivate: (index) => setState(() => _picked = _palettes[index]),
          itemBuilder: (context, item) {
            final palette = _palettes[item.index];

            return Semantics(
              button: true,
              selected: palette == _picked,
              label: palette.name,
              child: ExcludeSemantics(
                child: AstryxFocusRing(
                  focused: item.showsFocusRing,
                  borderRadius: theme.borderRadius(AstryxRadiusToken.element),
                  child: Container(
                    width: 56,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.color(palette.background),
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.element,
                      ),
                      border: Border.all(
                        color: theme.color(
                          palette == _picked
                              ? AstryxColorToken.accent
                              : palette.border,
                        ),
                        width:
                            theme.borderWidth() * (palette == _picked ? 2 : 1),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        AstryxText(
          _picked == null ? 'Nothing picked' : 'Picked ${_picked!.name}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxRovingFocus.grid(
  length: swatches.length,
  columns: 3,
  label: 'Team colour',
  onActivate: (index) => _pick(swatches[index]),
  itemBuilder: (context, item) => AstryxFocusRing(
    focused: item.showsFocusRing,
    child: _Swatch(swatches[item.index]),
  ),
)
```

The same widget as [useListFocus](use_list_focus.md) with a `columns` count, because a grid differs from a list in three details and nothing else:

| Key | In a grid |
| --- | --- |
| `←` / `→` | Moves **within the row**. Mirrored under RTL. |
| `↑` / `↓` | Moves between rows, by `columns` at a time. |
| `Home` / `End` | The ends of **that row**, not of the whole grid. |

`wrap` is off by default here, and that is the important one: stepping right off the end of a row into the next one is right for a menu of options and wrong for a calendar, where it silently changes the week.

The default layout is rows of `columns` items. Pass `layoutBuilder` where the geometry is not that — a table, a masonry wall, a month grid with a weekday header above it.

> **Note**
>
> `AstryxCalendar` is this pattern with the month arithmetic added: `Page Up` and `Page Down` for months, `Shift` with them for years. A grid whose axes mean something — a date, a seat, a cell reference — usually wants keys of its own beyond the four arrows.

## Related

- [useListFocus](use_list_focus.md) — the shared API and the not-selection rule.
- [AstryxCalendar](calendar.md) — the grid this package already ships.
- [AstryxGrid](grid.md) — laying a wall out, which is a different question.

