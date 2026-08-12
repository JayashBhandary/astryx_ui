# Hooks & controllers

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## useTheme → AstryxTheme.of

`lib/src/theme/astryx_theme.dart` · upstream `useTheme`

Reading the theme in scope, and why there is no hook.

```dart
final theme = AstryxTheme.of(context);

theme.color(AstryxColorToken.accent);         // Color
theme.spacing(AstryxSpacingToken.spacing3);   // 8.0
theme.textStyle(AstryxTypeRole.body);         // TextStyle
theme.duration(AstryxDurationToken.fast);     // Duration
```

**Rules**

- **Careful:** Reach for this only when building something the design system has no widget for — a custom painter, a chart, a one-off surface. A raw token read inside a screen is usually a sign that a component exists and was not used.
- **Note:** `AstryxTheme.of` throws when there is no provider above it, with a fix-it naming both entry points. `maybeOf` is the nullable form, for a widget that must survive outside a theme.

| Upstream hook | Here |
| --- | --- |
| `useTheme` | `AstryxTheme.of(context)` |
| `useTheme().mode` | `AstryxTheme.of(context).mode`, and `.brightness` for the Flutter enum |
| — (a media query upstream) | `AstryxTheme.densityOf(context)`, which is the pointer/touch answer |
| `useIcons` | `AstryxTheme.iconsOf(context)` |
| `useTranslator` | `AstryxLocalizations.of(context)` |
| `useLinkComponent` | `AstryxLinkDelegate.of(context)` |

---

## useMediaQuery → MediaQuery

upstream `useMediaQuery`

Responding to viewport size, pointer, and motion preference.

```dart
class HookMediaQueryExample extends StatelessWidget {
  const HookMediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `LayoutBuilder` answers "how much room do *I* have" — the question a
    // component actually has. `MediaQuery` answers "how big is the window",
    // which is a different one, and the wrong one inside a panel.
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 420;

        return AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxBanner(
              status: narrow
                  ? AstryxBannerStatus.warning
                  : AstryxBannerStatus.info,
              title: narrow
                  ? 'Narrow: ${constraints.maxWidth.round()}px'
                  : 'Wide: ${constraints.maxWidth.round()}px',
              description:
                  'Drag the window. The threshold is a number this example '
                  'chose, not an entry in a breakpoint table.',
            ),
            if (narrow)
              const AstryxText('Stacked, because there is no room beside.')
            else
              const AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                children: <Widget>[
                  AstryxBadge('Side by side'),
                  AstryxBadge('While it fits'),
                ],
              ),
          ],
        );
      },
    );
  }
}
```

**Rules**

- **Note:** Reduced motion is the one media feature you should almost never read yourself: every Astryx animation already honours it through `AstryxMotion`. Read `AstryxMotionAccess.animate` only for an animation you wrote by hand.

| CSS | Here |
| --- | --- |
| `@media (min-width: …)` | `LayoutBuilder`, or `MediaQuery.sizeOf(context)` |
| `@media (hover: hover)` | `AstryxTheme.densityOf(context).supportsHover` |
| `@media (pointer: coarse)` | `AstryxTheme.densityOf(context)`, and `.minimumTapTarget` |
| `@media (prefers-reduced-motion)` | `AstryxMotionAccess.animate(context)` |
| `@media (prefers-color-scheme)` | `AstryxColorMode.system`, resolved by the provider |

---

## AstryxHotkeys

`lib/src/foundation/hotkeys.dart` · upstream `useHotkeys`

Binding keyboard shortcuts to actions.

```dart
class HookHotkeysExample extends StatefulWidget {
  const HookHotkeysExample({super.key});

  @override
  State<HookHotkeysExample> createState() => _HookHotkeysExampleState();
}

class _HookHotkeysExampleState extends State<HookHotkeysExample> {
  static const AstryxHotkey _save = AstryxHotkey.mod(LogicalKeyboardKey.keyS);
  static const AstryxHotkey _palette = AstryxHotkey.mod(
    LogicalKeyboardKey.keyK,
  );

  final List<String> _log = <String>[];

  void _record(String what) => setState(() {
    _log.insert(0, what);
    if (_log.length > 3) _log.removeLast();
  });

  @override
  Widget build(BuildContext context) {
    // One definition per shortcut: bound here, and drawn by `AstryxKbd.hotkey`
    // below from the same object — so the hint can never describe a key that is
    // not the one bound. `mod` is ⌘ on a Mac and Ctrl elsewhere.
    return AstryxHotkeys(
      autofocus: true,
      bindings: <AstryxHotkey, VoidCallback>{
        _save: () => _record('Saved'),
        _palette: () => _record('Opened the palette'),
      },
      child: AstryxCard(
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxList(
              children: <Widget>[
                AstryxItem(
                  label: 'Save',
                  trailing: AstryxKbd.hotkey(_save),
                ),
                AstryxItem(
                  label: 'Command palette',
                  trailing: AstryxKbd.hotkey(_palette),
                ),
              ],
            ),
            AstryxText(
              _log.isEmpty ? 'Press one of them' : _log.join(' · '),
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **Key events walk *up* from whatever holds focus.** Until something inside the subtree is focused there is nothing for them to walk through, so an application-wide scope needs `autofocus: true` — otherwise `⌘K` does nothing on a freshly loaded page and gets reported as broken. The node is still skipped by Tab, so this costs no tab stop.
- **Accessibility:** A shortcut is an accelerator, never the only way to do something (WCAG 2.1.1). Every hotkey in a screen needs a control that does the same job, and the shortcut belongs *on* that control as a hint — which is what `AstryxKbd.hotkey` is for.

### AstryxHotkeys

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `bindings` **(required)** | `Map<AstryxHotkey, VoidCallback>` | — | What each hotkey does. |
| `child` **(required)** | `Widget` | — | The subtree the bindings apply to. |
| `enabled` | `bool` | `true` | Whether the bindings are live. |
| `autofocus` | `bool` | `false` | Whether the scope takes focus when built. Set it on an application-wide scope; leave it off around a control. |
| `platform` | `TargetPlatform?` | — | Overrides the platform `mod` resolves against. For tests, and for previewing another platform’s shortcuts. |

### AstryxHotkey

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `AstryxHotkey(key, {control, shift, alt, meta})` | `constructor` | — | A shortcut with fixed modifiers. |
| `AstryxHotkey.mod(key, {shift, alt})` | `constructor` | — | A shortcut on the platform’s own command modifier. |
| `activatorFor(platform)` | `ShortcutActivator` | — | The binding, resolved — so a hotkey can be handed to Flutter’s own `Shortcuts` too. |
| `capsFor(platform)` | `List<String>` | — | The caps to draw: `⌘ K` on Apple platforms, `Ctrl K` elsewhere. |
| `describeFor(platform)` | `String` | — | The spoken form — "Command K". A row of symbols read aloud is not a shortcut anybody can follow. |

---

## AstryxFocusTrap

`lib/src/foundation/focus_trap.dart` · upstream `useFocusTrap`

Holding focus inside an open overlay, and giving it back.

```dart
class HookFocusTrapExample extends StatefulWidget {
  const HookFocusTrapExample({super.key});

  @override
  State<HookFocusTrapExample> createState() => _HookFocusTrapExampleState();
}

class _HookFocusTrapExampleState extends State<HookFocusTrapExample> {
  bool _trapped = true;

  @override
  Widget build(BuildContext context) {
    // Tab round the three buttons inside the panel. Trapped, focus loops inside
    // it; untrapped, it escapes to the switch above and onto the page. Every
    // Astryx overlay uses this — reach for it directly only for a layer you are
    // building yourself.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSwitch(
          label: 'Trap focus',
          value: _trapped,
          onChanged: (value) => setState(() => _trapped = value),
        ),
        AstryxFocusTrap(
          enabled: _trapped,
          // Nothing is stealing focus on the way in here: the panel is already
          // on the page, unlike an overlay that has just opened.
          autofocus: false,
          child: AstryxCard(
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(label: 'First', onPressed: () {}),
                AstryxButton(label: 'Second', onPressed: () {}),
                AstryxButton(label: 'Third', onPressed: () {}),
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

- **Accessibility:** A trap without a way out is a cage. Whatever you put inside one needs Escape, or a close control, or both — which is why the overlays own the trap rather than leaving it to a caller who might forget.

### AstryxFocusTrap

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The subtree focus is kept inside. |
| `enabled` | `bool` | `true` | Whether the trap is active. |
| `autofocus` | `bool` | `true` | Whether to move focus into the subtree when the trap activates. |
| `restoreFocus` | `bool` | `true` | Whether to return focus to the previously-focused node on dismount. |
| `debugLabel` | `String?` | — | A label for the debug focus tree. |

---

## AstryxScrollLock

`lib/src/foundation/scroll_lock.dart` · upstream `useScrollLock`

Freezing the page behind a modal.

```dart
class HookScrollLockExample extends StatefulWidget {
  const HookScrollLockExample({super.key});

  @override
  State<HookScrollLockExample> createState() => _HookScrollLockExampleState();
}

class _HookScrollLockExampleState extends State<HookScrollLockExample> {
  final AstryxOverlayController _modal = AstryxOverlayController();

  @override
  void dispose() {
    _modal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Open the panel, then try to scroll the list behind it. Locked, it does
    // not move — a scrim blocks presses, and a wheel is not a press.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxButton(label: 'Open the panel', onPressed: _modal.show),
        AstryxOverlay(
          controller: _modal,
          label: 'Panel',
          child: AstryxCard(
            width: 280,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxText('Now try to scroll the list behind this.'),
                AstryxButton(label: 'Close', onPressed: _modal.hide),
              ],
            ),
          ),
        ),
        AstryxScrollLock.whileModalIsOpen(
          child: AstryxCard(
            padding: AstryxSpacingToken.spacing0,
            // Bounded here rather than around the card: a card lays its body
            // out in a column, and a column hands its child unbounded height.
            child: SizedBox(
              height: 160,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  for (var i = 1; i <= 20; i++) AstryxItem(label: 'Row $i'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **A locked subtree takes no pointer events at all**, not merely no scrolls. Blocking the pointer is the only thing that reliably stops a wheel: a page-level `ListView` with no controller is `primary: true`, and `ScrollView` wraps the ambient physics in `AlwaysScrollableScrollPhysics` for that case — which overrules anything handed down through `ScrollConfiguration`. Behind a modal that costs nothing, because the scrim was already swallowing presses. Do not lock something that has to stay clickable.

### AstryxScrollLock

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `locked` **(required)** | `bool` | — | Whether the subtree is frozen. The manual form. |
| `child` **(required)** | `Widget` | — | The subtree to freeze. |
| `AstryxScrollLock.whileModalIsOpen({child})` | `constructor` | — | Freezes whenever a modal layer is open, with nothing to wire up. |

### AstryxOverlayStack

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `openLayers` | `ValueListenable<int>` | — | How many dismissible layers are open. |
| `modalLayers` | `ValueListenable<int>` | — | How many of those dim the page — what the automatic lock listens to. |

---

## AstryxScrollOverflow

`lib/src/foundation/scroll_overflow.dart` · upstream `useScrollOverflow`

Knowing whether a scroller has content beyond either edge, for fading its edges.

```dart
class HookScrollOverflowExample extends StatefulWidget {
  const HookScrollOverflowExample({super.key});

  @override
  State<HookScrollOverflowExample> createState() =>
      _HookScrollOverflowExampleState();
}

class _HookScrollOverflowExampleState extends State<HookScrollOverflowExample> {
  AstryxScrollEdges _edges = AstryxScrollEdges.none;

  @override
  Widget build(BuildContext context) {
    // Scroll the strip. The fade appears only on the side that has more, so it
    // is information rather than decoration — and it is never hit-testable, so
    // a chip underneath it stays pressable.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxScrollOverflow(
          onChanged: (edges) => setState(() => _edges = edges),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                for (final region in <String>[
                  'us-east-1',
                  'us-west-2',
                  'eu-west-1',
                  'eu-central-1',
                  'ap-south-1',
                  'ap-northeast-1',
                  'sa-east-1',
                ])
                  AstryxBadge(region),
              ],
            ),
          ),
        ),
        AstryxText(
          _edges.overflows
              ? 'More at the start: ${_edges.hasMoreAtStart} · '
                    'more at the end: ${_edges.hasMoreAtEnd}'
              : 'Everything fits',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** A fade is decoration: it is not announced, and it is not reachable without sight or a pointer. It must never be the *only* way to reach what is past the edge — the content behind it stays in the semantics tree and stays reachable by keyboard, which is what makes the fade an extra rather than a gate. The fades never hit-test, so a control under one is still pressable.
- **Note:** `AstryxTabList` does this for its own strip. Its copy predates this primitive and behaves identically; the two are worth merging, and until they are, this is the one to reach for in your own code.

| `AstryxScrollEdges` | Means |
| --- | --- |
| `overflows` | The content is longer than the viewport at all. False makes the other two meaningless — a scroller with nothing to scroll is at both ends at once. |
| `atStart` / `atEnd` | Resting against that edge. |
| `hasMoreAtStart` / `hasMoreAtEnd` | The pair a fade or an arrow keys off: overflowing **and** not at that edge. |

### AstryxScrollOverflow

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The scrollable, or anything containing one. |
| `axis` | `Axis` | `Axis.horizontal` | Which axis to watch. A notification from the other axis is ignored, so a horizontal strip inside a scrolling page reports only its own edges. |
| `fade` | `bool` | `true` | Whether to draw a gradient at an edge with more past it. |
| `fadeExtent` | `double` | `24` | How wide a fade is. |
| `fadeColor` | `AstryxColorToken?` | — | What a fade resolves to. It has to match what is *behind* the scroller, so a strip on a card wants `backgroundCard`. |
| `builder` | `Widget Function(context, edges, child)?` | — | Wraps the child once the edges are known. |
| `onChanged` | `ValueChanged<AstryxScrollEdges>?` | — | Called whenever the edges change. |

---

## useOverflow → AstryxOverflowList

`lib/src/components/data/overflow_list.dart` · upstream `useOverflow`

Measuring which children do not fit, so a component can collapse its tail.

```dart
class OverflowListDemoExample extends StatefulWidget {
  const OverflowListDemoExample({super.key});

  @override
  State<OverflowListDemoExample> createState() =>
      _OverflowListDemoExampleState();
}

class _OverflowListDemoExampleState extends State<OverflowListDemoExample> {
  static const List<String> _tags = <String>[
    'billing',
    'infra',
    'urgent',
    'customer-reported',
    'regression',
    'needs-repro',
  ];

  String? _chosen;

  @override
  Widget build(BuildContext context) {
    // Narrow the window and the tail moves into the menu; widen it and the
    // items come back. Nothing is ever unreachable — what does not fit is a
    // real menu row, not a clipped one.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxOverflowList(
          menuLabel: 'More tags',
          items: <AstryxOverflowItem>[
            for (final tag in _tags)
              AstryxOverflowItem(
                label: tag,
                onSelected: () => setState(() => _chosen = tag),
                child: AstryxBadge(tag),
              ),
          ],
        ),
        AstryxText(
          _chosen == null ? 'Nothing chosen yet' : 'Chose $_chosen',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** Measuring costs a layout pass and a rebuild. A row of six chips is a fine use; a table of two hundred cells is not, and the answer there is a column strategy rather than measurement.

| When the row will not fit | Reach for |
| --- | --- |
| The items are equals and order matters — tags, filters | `AstryxOverflowList`, so the tail is still reachable |
| The items are destinations and the strip is navigation | `AstryxTabList`, which scrolls and fades — see useScrollOverflow (references/hooks.md) |
| The tail is *actions* rather than content | `AstryxMoreMenu`, which is the "…" trigger and its menu as one widget |
| A second line is fine | `AstryxHStack(wrap: true)` — no measurement needed at all |

---

## AstryxRovingFocus.list

`lib/src/foundation/roving_focus.dart` · upstream `useListFocus`

Arrow-key traversal across a list as one tab stop.

```dart
class HookListFocusExample extends StatefulWidget {
  const HookListFocusExample({super.key});

  @override
  State<HookListFocusExample> createState() => _HookListFocusExampleState();
}

class _HookListFocusExampleState extends State<HookListFocusExample> {
  static const List<String> _filters = <String>[
    'Open',
    'Merged',
    'Closed',
    'Draft',
  ];

  final Set<int> _on = <int>{0};

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Tab onto the strip, then use the arrows — one tab stop for four chips.
    // `Draft` is disabled, and movement skips it rather than landing on it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxRovingFocus.list(
          length: _filters.length,
          label: 'Filters',
          gap: AstryxSpacingToken.spacing2,
          isEnabled: (index) => _filters[index] != 'Draft',
          onActivate: (index) => setState(() {
            _on.contains(index) ? _on.remove(index) : _on.add(index);
          }),
          itemBuilder: (context, item) {
            final selected = _on.contains(item.index);
            final enabled = _filters[item.index] != 'Draft';

            return Semantics(
              // The items are announced individually even though only the group
              // takes focus: `explicitChildNodes` on the group keeps them.
              inMutuallyExclusiveGroup: false,
              checked: selected,
              enabled: enabled,
              label: _filters[item.index],
              child: ExcludeSemantics(
                child: AstryxFocusRing(
                  focused: item.showsFocusRing,
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                  child: AstryxBadge(
                    _filters[item.index],
                    variant: selected
                        ? AstryxBadgeVariant.info
                        : AstryxBadgeVariant.neutral,
                  ),
                ),
              ),
            );
          },
        ),
        AstryxText(
          'Enter or Space toggles. Selected: '
          '${_on.map((i) => _filters[i]).join(', ')}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **Nothing `itemBuilder` returns may be focusable.** A focusable item would be its own tab stop, and the group would stop being one — the exact thing this widget exists to prevent. Build plain visuals, and use `item.showsFocusRing` to draw the ring.
- **Accessibility:** The group carries the accessible name and `explicitChildNodes`, so each item keeps a node of its own — a reader hears "Open, checked" rather than one field of indeterminate content. Give every item a `Semantics` with its label and state; the group cannot infer either.

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the group, and off it. |
| `←` / `→` | Moves along a horizontal list. **Mirrored under RTL.** |
| `↑` / `↓` | Moves along a vertical one. Both axes work in either orientation, which is what a user who does not know which way the group runs will try. |
| `Home` / `End` | The first and last available item. |
| `Enter` / `Space` | Calls `onActivate` with the index. |

### AstryxRovingFocus

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `length` **(required)** | `int` | — | How many items there are. |
| `itemBuilder` **(required)** | `Widget Function(context, AstryxRovingFocusItem)` | — | Builds one item, told whether the focus is on it. |
| `columns` | `int` | — | Required by `AstryxRovingFocus.grid`; absent for a list. |
| `orientation` | `Axis` | `Axis.horizontal` | Which way a list runs. |
| `wrap` | `bool` | `true` | Whether movement cycles at the ends. True for a list, false for a grid. |
| `onActivate` | `ValueChanged<int>?` | — | Called with the index `Enter` or `Space` was pressed on. |
| `isEnabled` | `bool Function(int)?` | — | Whether an index can hold the focus. Movement skips the rest. |
| `activeIndex` | `int?` | — | The active index, for a caller that owns it. Null keeps it internal. |
| `onActiveChanged` | `ValueChanged<int>?` | — | Called with the index the focus moved to. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing1` | The gap in the default layout. |
| `layoutBuilder` | `Widget Function(context, List<Widget>)?` | — | Lays the items out. Null uses a row, a column or a grid. |
| `label` | `String?` | — | An accessible name for the group. |

### AstryxRovingFocusItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `index` | `int` | — | Which item this is. |
| `isActive` | `bool` | — | Whether the roving focus sits here — true for exactly one item, whether or not the group is focused. |
| `groupHasFocus` | `bool` | — | Whether the group holds focus. |
| `showsFocusRing` | `bool` | — | Both conditions in one place: active **and** the group focused. Hand it to `AstryxFocusRing.focused`. |

---

## AstryxRovingFocus.grid

`lib/src/foundation/roving_focus.dart` · upstream `useGridFocus`

Two-dimensional arrow-key traversal across a grid.

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

**Rules**

- **Note:** `AstryxCalendar` is this pattern with the month arithmetic added: `Page Up` and `Page Down` for months, `Shift` with them for years. A grid whose axes mean something — a date, a seat, a cell reference — usually wants keys of its own beyond the four arrows.

| Key | In a grid |
| --- | --- |
| `←` / `→` | Moves **within the row**. Mirrored under RTL. |
| `↑` / `↓` | Moves between rows, by `columns` at a time. |
| `Home` / `End` | The ends of **that row**, not of the whole grid. |

---

## useTreeFocus → AstryxTreeList

`lib/src/components/data/tree_list.dart` · upstream `useTreeFocus`

Arrow-key traversal across a tree, including expand and collapse.

```dart
class TreeListDemoExample extends StatefulWidget {
  const TreeListDemoExample({super.key});

  @override
  State<TreeListDemoExample> createState() => _TreeListDemoExampleState();
}

class _TreeListDemoExampleState extends State<TreeListDemoExample> {
  String? _selected = 'list';

  @override
  Widget build(BuildContext context) {
    // Tab lands on the tree once; the arrows do the rest. Right opens a branch
    // and then steps into it, Left closes it and then steps out.
    return AstryxTreeList(
      label: 'Files',
      nodes: _files,
      initiallyExpanded: const <String>{'lib', 'components'},
      selected: _selected,
      onSelectedChanged: (id) => setState(() => _selected = id),
    );
  }
}
```

**Rules**

- **Accessibility:** A collapsed subtree is **not in the widget tree**: no layout, no semantics, and no focus stops behind a closed node. Each row carries its expanded state in its semantics, so a reader is told rather than left to infer it from a rotated chevron.

| Key | In a tree |
| --- | --- |
| `↑` / `↓` | Moves through the **visible** rows — so collapsing a node changes what "next" means, mid-traversal. |
| `→` | Expands a collapsed node, then moves into it. Not "next item". |
| `←` | Collapses an expanded node, or moves to its parent. Mirrored under RTL. |
| `Enter` / `Space` | Presses the row. |

---

## useLayer → Overlay and the stack

`lib/src/foundation/overlay_stack.dart` · upstream `useLayer`

Placing content in the overlay stack at the right depth.

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

- **Careful:** The unregister-on-dispose line is the one that gets forgotten, and the bug it causes is remote from its cause: Escape stops working somewhere else on the page, long after the layer that broke it has gone.

---

## useClickableContainer → onPressed

`lib/src/components/surface/card.dart` · upstream `useClickableContainer`

Making a container behave as one control without nesting interactive elements.

```dart
class HookClickableContainerExample extends StatefulWidget {
  const HookClickableContainerExample({super.key});

  @override
  State<HookClickableContainerExample> createState() =>
      _HookClickableContainerExampleState();
}

class _HookClickableContainerExampleState
    extends State<HookClickableContainerExample> {
  String _last = 'Nothing pressed';

  @override
  Widget build(BuildContext context) {
    // A non-null `onPressed` makes the whole card one button: hover, press, a
    // focus ring, `Semantics(button: true)` and the tap-target guarantee. What
    // it must *not* contain is another control — a button inside a button is a
    // node a screen reader cannot describe and a keyboard cannot reach twice.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          semanticsLabel: 'Atlas scheduler',
          onPressed: () => setState(() => _last = 'Opened Atlas scheduler'),
          child: const AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxHeading(
                'Atlas scheduler',
                type: AstryxHeadingType.display3,
              ),
              AstryxText('Runs every fifteen minutes'),
            ],
          ),
        ),
        AstryxList(
          children: <Widget>[
            AstryxItem(
              label: 'Deploy log',
              description: 'The row is the control, not a link inside it',
              onPressed: () => setState(() => _last = 'Opened the deploy log'),
            ),
          ],
        ),
        AstryxText(
          _last,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **There is no `ClickableCard`.** One card, with a parameter — because two widgets that differ only in whether they respond to a press are two widgets that drift apart on padding, radius and focus.
- **Accessibility:** A pressable container needs a name of its own — `semanticsLabel` on a card — because its content is a heading, a paragraph and a badge, and a reader announcing all three as the button’s name is not a label. Hover styling is gated on `AstryxTheme.densityOf(context).supportsHover`, so nothing lives behind a hover a touch user cannot perform.

| A pressable… | Is |
| --- | --- |
| surface | `AstryxCard(onPressed:, semanticsLabel:)` |
| row | `AstryxItem(onPressed:)` |
| card that carries selection | `AstryxSelectableCard` — a *control*, announced as a checkbox or a radio, reporting a selection rather than a press |
| band of controls | `AstryxToolbar` — one tab stop |

---

## useInputContainer → the field

`lib/src/components/forms/input_container.dart` · upstream `useInputContainer`

Sharing focus, hover and validation state between a field and its affixes.

```dart
class FieldScopeExample extends StatelessWidget {
  const FieldScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Controls that *do* have their own label read the scope instead of
    // repeating it: `enabled` and `status` cascade down from the field.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Region',
        description: 'Both controls inherit the field being disabled.',
        enabled: false,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxTextInput(label: 'Region', labelHidden: true),
            AstryxCheckbox(
              label: 'Replicate to a second region',
              value: false,
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Note:** It is not exported. Three controls drifting apart on border colour and focus ring is exactly how a design system stops looking like one, so the container is shared between the text inputs and the selector and is not offered as a building block. What is public is everything you would reach for it *through*.
- **Accessibility:** Flutter has no `<label for>`, so a label rendered merely *next to* a control is invisible to a screen reader. `AstryxField` publishes its label, description and status through a scope and each input folds them into the semantics node it already owns — which is the entire reason that widget exists.

| To… | Use |
| --- | --- |
| put an icon, a unit or a button inside a field | `leading` and `trailing` on `AstryxTextInput` — the slots the container lays out |
| join several controls into one bordered row | AstryxInputGroup (references/forms.md), with `AstryxInputGroupText` for the affixes |
| give your own control a label, a description and validation | AstryxField (references/forms.md), which publishes them through `AstryxFieldScope` |
| read that state in your own control | `AstryxFieldScope.maybeOf(context)` — the label, the status and whether the field is enabled |

---

## AstryxKeyboardHint

`lib/src/foundation/keyboard_hint.dart` · upstream `useKeyboardHint`

Showing shortcut hints only once the user is navigating by keyboard.

```dart
class HookKeyboardHintExample extends StatelessWidget {
  const HookKeyboardHintExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Press a key, then move the mouse: the hints follow the same last-input
    // signal as the focus ring, so a hint and a ring never disagree about which
    // mode the user is in. They keep their space either way.
    return AstryxList(
      children: <Widget>[
        AstryxItem(
          label: 'Command palette',
          onPressed: () {},
          trailing: const AstryxKeyboardHint(
            child: AstryxKbd.hotkey(
              AstryxHotkey.mod(LogicalKeyboardKey.keyK),
            ),
          ),
        ),
        AstryxItem(
          label: 'Save',
          onPressed: () {},
          trailing: const AstryxKeyboardHint(
            child: AstryxKbd.hotkey(
              AstryxHotkey.mod(LogicalKeyboardKey.keyS),
            ),
          ),
        ),
        AstryxItem(
          label: 'Deploy log',
          onPressed: () {},
          // Nothing to hint, so the slot says something else on a pointer.
          trailing: const AstryxKeyboardHint(
            otherwise: AstryxText(
              '2 minutes ago',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            child: AstryxKbd.chord(<String>['G', 'L']),
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **A hint is a reminder, never the only route.** Whatever the shortcut does must also be reachable by pressing something: this hides a *hint*, not a control. Putting a control in here is the keyboard equivalent of hiding one behind hover, and it fails the same people.

### AstryxKeyboardHint

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The hint. |
| `reserveSpace` | `bool` | `true` | Whether the hint keeps its space while hidden. |
| `otherwise` | `Widget?` | — | What to show instead while the user is on a pointer. |
| `excludeFromSemantics` | `bool` | `false` | Whether to keep the hint out of the semantics tree. It is announced by default, because the hint is usually where the shortcut is written down. |

---

## AstryxEntryAnimation

`lib/src/foundation/entry_animation.dart` · upstream `useEntryAnimation`

Animating an element as it enters, respecting reduced-motion.

```dart
class HookEntryAnimationExample extends StatefulWidget {
  const HookEntryAnimationExample({super.key});

  @override
  State<HookEntryAnimationExample> createState() =>
      _HookEntryAnimationExampleState();
}

class _HookEntryAnimationExampleState extends State<HookEntryAnimationExample> {
  int _generation = 0;
  AstryxEntryTransition _transition = AstryxEntryTransition.fadeUp;

  @override
  Widget build(BuildContext context) {
    // It runs once per element. Replaying it is a *key* change, not a flag: a
    // new key tells Flutter this is new content rather than the old content
    // updated, which is the same thing the animation is trying to say.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSegmentedControl<AstryxEntryTransition>(
              label: 'Transition',
              value: _transition,
              segments: const <AstryxSegment<AstryxEntryTransition>>[
                AstryxSegment(
                  value: AstryxEntryTransition.fade,
                  label: 'Fade',
                ),
                AstryxSegment(
                  value: AstryxEntryTransition.fadeUp,
                  label: 'Up',
                ),
                AstryxSegment(
                  value: AstryxEntryTransition.fadeScale,
                  label: 'Scale',
                ),
              ],
              onChanged: (value) => setState(() {
                _transition = value;
                _generation++;
              }),
            ),
            AstryxButton(
              label: 'Replay',
              onPressed: () => setState(() => _generation++),
            ),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 0; i < 3; i++)
              AstryxEntryAnimation(
                key: ValueKey<String>('$_generation.$i'),
                transition: _transition,
                // A stagger, kept short: one a user has to wait out has become
                // a loading state.
                delay: Duration(milliseconds: 60 * i),
                child: AstryxCard(
                  child: AstryxText('Row ${i + 1}'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** A `delay` is for staggering a list, and the total matters more than the step: keep it under about a quarter of a second. A stagger a user has to wait out has stopped being an animation and become a loading state.
- **Accessibility:** Under `prefers-reduced-motion` the child is simply *there* — no frame of it is animated. A shorter animation is still an animation, and the setting exists for people whom motion makes unwell. Nothing about the content, the layout or the semantics differs between the two paths.

| `AstryxEntryTransition` | For |
| --- | --- |
| `fade` | The safe default. Nothing moves, so nothing can be read as a layout shift. |
| `fadeUp` | Says "this is new" rather than "this was always here", which a fade alone cannot. |
| `fadeScale` | Something that appeared *at* a point — a card just created, a panel with a source. |

### AstryxEntryAnimation

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content that enters. |
| `transition` | `AstryxEntryTransition` | `AstryxEntryTransition.fade` | How it enters. |
| `duration` | `AstryxDurationToken` | `AstryxDurationToken.mediumMin` | How long the entry takes. |
| `ease` | `AstryxEaseToken` | `AstryxEaseToken.standard` | The easing curve. |
| `delay` | `Duration` | `Duration.zero` | How long to wait before starting. |
| `offset` | `double` | `8` | How far `fadeUp` rises, in logical pixels. |
| `enabled` | `bool` | `true` | Whether to animate at all. |

---

## AstryxContainerReveal

`lib/src/foundation/entry_animation.dart` · upstream `useContainerReveal`

Revealing content as its container scrolls into view.

```dart
class HookContainerRevealExample extends StatelessWidget {
  const HookContainerRevealExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Scroll the panel. Each card is laid out from the start — so the scrollbar
    // does not lie about the length — and painted as it comes into view.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      // Bounded inside the card: a card lays its body out in a column, and a
      // column hands its child unbounded height — which a scroller reads as
      // "no need to scroll".
      child: SizedBox(
        height: 220,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (var i = 1; i <= 8; i++)
                AstryxContainerReveal(
                  child: AstryxCard(
                    child: AstryxHStack(
                      gap: AstryxSpacingToken.spacing2,
                      children: <Widget>[
                        AstryxBadge('$i'),
                        const AstryxText('Revealed on the way in'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Note:** **With no enclosing scrollable it reveals immediately.** There is nothing to wait for, and content that never appears because a widget was looking for a viewport that does not exist is the worse failure by a wide margin.
- **Careful:** Reveal-on-scroll is a decoration, and a page of forty of them is forty listeners and forty rebuilds. Use it for a handful of substantial blocks — a chart, a section — not for every row of a table. It stops listening the moment it has fired, so the cost is bounded, but the cost of never adding it is zero.

### AstryxContainerReveal

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content revealed. |
| `transition` | `AstryxEntryTransition` | `AstryxEntryTransition.fadeUp` | How it enters once in view. |
| `fraction` | `double` | `0.1` | How much of the child must be in view before it reveals, 0 to 1. |
| `enabled` | `bool` | `true` | Whether to wait at all. False reveals on the first frame. |
| `onRevealed` | `VoidCallback?` | — | Called once, when the child is first revealed. |

---

## useImageMode → the resolved mode

upstream `useImageMode`

Choosing the light or dark variant of an image.

```dart
class HookImageModeExample extends StatelessWidget {
  const HookImageModeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final dark = theme.mode == AstryxThemeMode.dark;

    // One line, and it subscribes: switch the docs between light and dark and
    // this swaps with it, with nothing else wired up. Stand-ins for two real
    // assets — `Image.asset(dark ? 'logo_dark.png' : 'logo_light.png')`.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        Container(
          width: 200,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.color(
              dark
                  ? AstryxColorToken.backgroundInverted
                  : AstryxColorToken.backgroundMuted,
            ),
            borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            border: Border.all(
              color: theme.color(AstryxColorToken.border),
              width: theme.borderWidth(),
            ),
          ),
          child: AstryxText(
            dark ? 'the dark lockup' : 'the light lockup',
            color: AstryxTextColor.inherit,
            style: TextStyle(
              color: theme.color(
                dark ? AstryxColorToken.onDark : AstryxColorToken.textPrimary,
              ),
            ),
          ),
        ),
        const AstryxText(
          'Both variants take the same semantic label: they are the same '
          'picture.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** Reach for two assets only when the image genuinely has two versions — a logo with a light and a dark lockup, a diagram with dark ink. A photograph does not, and inverting one is a worse result than leaving it alone. For an icon, use `AstryxIcon`: it takes its colour from the theme already, so there is nothing to swap.
- **Accessibility:** Both variants of an image are the same picture, so both take the **same** `semanticLabel`. And whatever the image conveys must survive it being unavailable: a diagram carrying information no caption repeats is information a screen-reader user does not have.

---

## AstryxStreamingText

`lib/src/components/data/streaming_text.dart` · upstream `useStreamingText`

Rendering text as it arrives token by token.

```dart
class HookStreamingTextExample extends StatefulWidget {
  const HookStreamingTextExample({super.key});

  @override
  State<HookStreamingTextExample> createState() =>
      _HookStreamingTextExampleState();
}

class _HookStreamingTextExampleState extends State<HookStreamingTextExample> {
  static const List<String> _chunks = <String>[
    'The deploy finished in 41 seconds. ',
    'Three services restarted, ',
    'and the health check passed on the first attempt.',
  ];

  String _text = '';
  int _next = 0;

  bool get _streaming => _next < _chunks.length;

  void _send() {
    if (!_streaming) {
      setState(() {
        _text = '';
        _next = 0;
      });
      return;
    }
    setState(() {
      _text += _chunks[_next];
      _next++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Press "Send a chunk" a few times. Text arrives in bursts and is revealed
    // at a steady rate, so it reads as typing rather than twitching — and the
    // caret says more is coming.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          child: _text.isEmpty
              ? const AstryxText(
                  'Nothing yet',
                  color: AstryxTextColor.secondary,
                )
              : AstryxStreamingText(
                  _text,
                  streaming: _streaming,
                  charactersPerSecond: 40,
                ),
        ),
        AstryxButton(
          label: _streaming ? 'Send a chunk' : 'Start again',
          onPressed: _send,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** **The whole text is the accessible name from the first frame**, not the part that happens to be on screen. A live region firing per token would restart the sentence eighty times a second, which is not a reading experience — it is a denial of one. The partial text is excluded from semantics and the node carries the complete string, so a screen-reader user gets the answer once, in full.
- **Note:** Under reduced motion everything that has arrived is shown at once. The caret is static rather than blinking, for the same reason: a blink is a second animation that would have to be suppressed, and the caret’s job — "there is more coming" — it does standing still.

### AstryxStreamingText

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `text` **(required)** | `String` | — | Everything that has arrived so far. |
| `streaming` | `bool` | `true` | Whether more is expected. Only affects the caret — the reveal is driven by `text` either way. |
| `charactersPerSecond` | `double` | `80` | How fast text is revealed. 80 is a little faster than a fast typist and slow enough to read along with. |
| `showCaret` | `bool` | `true` | Whether to draw a caret while there is more to come. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Defaults to the whole of `text`. |
| `onCompleted` | `VoidCallback?` | — | Called once the screen matches what has arrived — which is not the same as the response being over. |

---

## useTranslator → AstryxLocalizations.of

`lib/src/localizations/astryx_localizations.dart` · upstream `useTranslator`

Looking up a translated string.

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

**Rules**

- **Note:** `of(context)` **never returns null**, falling back to the English defaults. A missing localisation should not be an exception in front of a user, and a partial translation should be a working app with some English in it.
- **Careful:** Do not read a string out of here to label something of your own — `l10n.tableNoData` on your empty state ties your copy to a widget’s wording, and the next release is entitled to change it.

---

