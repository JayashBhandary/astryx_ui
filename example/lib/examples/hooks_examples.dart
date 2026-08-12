import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// #example hook_theme -> HookThemeExample
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
// #end

// #example hook_media_query -> HookMediaQueryExample
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
// #end

// #example hook_hotkeys -> HookHotkeysExample
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
// #end

// #example hook_focus_trap -> HookFocusTrapExample
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
// #end

// #example hook_scroll_lock -> HookScrollLockExample
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
// #end

// #example hook_scroll_overflow -> HookScrollOverflowExample
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
// #end

// #example hook_list_focus -> HookListFocusExample
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
// #end

// #example hook_grid_focus -> HookGridFocusExample
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
// #end

// #example hook_clickable_container -> HookClickableContainerExample
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
// #end

// #example hook_entry_animation -> HookEntryAnimationExample
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
// #end

// #example hook_container_reveal -> HookContainerRevealExample
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
// #end

// #example hook_keyboard_hint -> HookKeyboardHintExample
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
// #end

// #example hook_streaming_text -> HookStreamingTextExample
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
// #end

// #example hook_image_mode -> HookImageModeExample
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
// #end

/// The widgets' strings, reworded for one subtree.
class TerseLocalizations extends AstryxLocalizations {
  const TerseLocalizations();

  @override
  String get fieldRequired => 'must';

  @override
  String get selectorPlaceholder => 'pick one…';

  @override
  String clearField(String label) => 'wipe $label';
}

// #example hook_translator -> HookTranslatorExample
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
// #end
