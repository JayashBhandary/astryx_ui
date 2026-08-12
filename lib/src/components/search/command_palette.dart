/// The keyboard-first command surface.
library;

import 'package:astryx_ui/src/components/data/empty_state.dart';
import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/data/kbd.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/foundation/hotkeys.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One command in an [AstryxCommandPalette].
@immutable
class AstryxCommandItem {
  /// Describes a command.
  const AstryxCommandItem({
    required this.label,
    required this.onSelected,
    this.description,
    this.icon,
    this.hotkey,
    this.keywords = const <String>[],
    this.enabled = true,
  });

  /// What the command is called. Also what the query matches against.
  final String label;

  /// What running it does.
  final VoidCallback onSelected;

  /// A second line, for a label that needs qualifying.
  final String? description;

  /// A glyph before the label.
  final AstryxIconName? icon;

  /// The shortcut that runs this command elsewhere in the application.
  ///
  /// Drawn on the row, from the same object that is bound — so the palette
  /// teaches the shortcut rather than describing one that may have moved.
  final AstryxHotkey? hotkey;

  /// Extra words the query should match.
  ///
  /// "Log out" found by "sign out", "exit", "quit". A palette is only as good
  /// as its synonyms: a command nobody can find by the word they thought of is
  /// a command that is not there.
  final List<String> keywords;

  /// Whether the command can be run now.
  final bool enabled;

  /// Whether [query] finds this command.
  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    if (label.toLowerCase().contains(needle)) return true;
    if (description?.toLowerCase().contains(needle) ?? false) return true;
    return keywords.any((word) => word.toLowerCase().contains(needle));
  }
}

/// A named run of commands.
@immutable
class AstryxCommandGroup {
  /// Describes a group.
  const AstryxCommandGroup({required this.label, required this.items});

  /// The heading — "Navigate", "Deploy", "Recent".
  final String label;

  /// The commands in it, in order.
  final List<AstryxCommandItem> items;
}

/// The keyboard-first command surface: a query, grouped results, a footer.
///
/// Upstream's `CommandPalette` and its six parts — the input, the list, the
/// group, the item, the empty state and the footer — as one widget, because a
/// palette assembled from six pieces is six chances to get the keyboard wrong.
///
/// {@tool snippet}
/// ```dart
/// AstryxHotkeys(
///   autofocus: true,
///   bindings: <AstryxHotkey, VoidCallback>{
///     const AstryxHotkey.mod(LogicalKeyboardKey.keyK): _palette.show,
///   },
///   child: Stack(
///     children: <Widget>[
///       page,
///       AstryxCommandPalette(controller: _palette, groups: _commands),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// Like every overlay here it is a **widget in the tree**, not a `show…` call:
/// it renders nothing until the controller opens it, so it sits next to
/// whatever opens it and there is no `BuildContext` to smuggle across an async
/// gap.
class AstryxCommandPalette extends StatefulWidget {
  /// Creates a command palette.
  const AstryxCommandPalette({
    required this.controller,
    required this.groups,
    super.key,
    this.placeholder,
    this.label,
    this.empty,
    this.footer,
    this.showFooter = true,
    this.width = 560,
    this.maxHeight = 420,
    this.clearOnClose = true,
  });

  /// Opens and closes the palette.
  final AstryxOverlayController controller;

  /// The commands, in groups.
  ///
  /// A single unnamed group is fine — pass one with an empty [
  /// AstryxCommandGroup.label] and no heading is drawn.
  final List<AstryxCommandGroup> groups;

  /// The placeholder in the query field.
  final String? placeholder;

  /// An accessible name for the palette.
  final String? label;

  /// What to show when the query matches nothing.
  final Widget? empty;

  /// Content in the footer, replacing the shortcut legend.
  final Widget? footer;

  /// Whether to draw the footer at all.
  final bool showFooter;

  /// How wide the palette is.
  final double width;

  /// The tallest the result list grows before it scrolls.
  final double maxHeight;

  /// Whether closing empties the query.
  ///
  /// True by default: a palette reopened on last week's half-typed query is a
  /// palette that has to be cleared before it is useful.
  final bool clearOnClose;

  @override
  State<AstryxCommandPalette> createState() => _AstryxCommandPaletteState();
}

class _AstryxCommandPaletteState extends State<AstryxCommandPalette> {
  final TextEditingController _query = TextEditingController();
  final FocusNode _fieldFocus = FocusNode();
  final ScrollController _scroll = ScrollController();

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleOpenChange);
    _query.addListener(_handleQueryChange);
  }

  @override
  void didUpdateWidget(AstryxCommandPalette oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleOpenChange);
      widget.controller.addListener(_handleOpenChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleOpenChange);
    _query.dispose();
    _fieldFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _handleOpenChange() {
    if (!mounted) return;
    if (widget.controller.isOpen) {
      setState(() => _activeIndex = 0);
      return;
    }
    if (widget.clearOnClose) _query.clear();
  }

  void _handleQueryChange() {
    if (!mounted) return;
    // Back to the top on every keystroke: the best match for what is typed now
    // is the first row, and leaving the highlight three rows down means Enter
    // runs something the user is no longer looking at.
    setState(() => _activeIndex = 0);
  }

  /// The matching commands, flattened, with their group headings.
  List<_Row> get _rows {
    final query = _query.text;
    final rows = <_Row>[];

    for (final group in widget.groups) {
      final matches = group.items
          .where((item) => item.matches(query))
          .toList();
      if (matches.isEmpty) continue;
      if (group.label.isNotEmpty) rows.add(_Row.heading(group.label));
      rows.addAll(matches.map(_Row.command));
    }
    return rows;
  }

  List<int> _commandIndexes(List<_Row> rows) => <int>[
    for (var i = 0; i < rows.length; i++)
      if (rows[i].item != null && rows[i].item!.enabled) i,
  ];

  void _move(int delta, List<_Row> rows) {
    final indexes = _commandIndexes(rows);
    if (indexes.isEmpty) return;

    final current = indexes.indexOf(_activeIndex);
    // Wraps, because a palette is a short list and reversing out of the bottom
    // of one is a thing nobody wants to do.
    final next = current < 0
        ? (delta > 0 ? 0 : indexes.length - 1)
        : (current + delta) % indexes.length;

    final wrapped = next < 0 ? next + indexes.length : next;
    setState(() => _activeIndex = indexes[wrapped]);
    _reveal(_activeIndex, rows.length);
  }

  void _reveal(int index, int count) {
    if (!_scroll.hasClients || count == 0) return;
    const rowHeight = 44.0;
    final position = _scroll.position;
    final target = index * rowHeight;

    if (target < position.pixels) {
      _scroll.jumpTo(target);
    } else if (target + rowHeight >
        position.pixels + position.viewportDimension) {
      _scroll.jumpTo(target + rowHeight - position.viewportDimension);
    }
  }

  void _run(AstryxCommandItem item) {
    if (!item.enabled) return;
    // Closed first: a command that opens a dialog must not open it behind the
    // palette.
    widget.controller.hide();
    item.onSelected();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event, List<_Row> rows) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _move(1, rows);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _move(-1, rows);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        final item = _activeIndex < rows.length
            ? rows[_activeIndex].item
            : null;
        if (item == null) return KeyEventResult.ignored;
        _run(item);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final rows = _rows;

    // The first *runnable* row starts active, so Enter on open runs the obvious
    // thing rather than a heading.
    final indexes = _commandIndexes(rows);
    if (indexes.isNotEmpty && !indexes.contains(_activeIndex)) {
      _activeIndex = indexes.first;
    }

    return AstryxOverlay(
      controller: widget.controller,
      label: widget.label ?? l10n.commandPaletteLabel,
      // Near the top, where a palette belongs: dead centre puts the results
      // under the user's hands rather than in front of their eyes.
      alignment: const Alignment(0, -0.6),
      child: Focus(
        onKeyEvent: (node, event) => _handleKey(node, event, rows),
        canRequestFocus: false,
        skipTraversal: true,
        child: SizedBox(
          width: widget.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundPopover),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              border: Border.all(
                color: theme.color(AstryxColorToken.border),
                width: theme.borderWidth(),
              ),
              boxShadow: theme.boxShadows(AstryxShadowToken.high),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    theme.spacing(AstryxSpacingToken.spacing3),
                  ),
                  child: AstryxTextInput(
                    label: widget.label ?? l10n.commandPaletteLabel,
                    labelHidden: true,
                    controller: _query,
                    focusNode: _fieldFocus,
                    autofocus: true,
                    placeholder:
                        widget.placeholder ?? l10n.commandPalettePlaceholder,
                    leading: const AstryxIcon(
                      AstryxIconName.search,
                      size: AstryxIconSize.sm,
                      color: AstryxIconColor.secondary,
                    ),
                  ),
                ),
                const AstryxDivider(),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: widget.maxHeight),
                    child: rows.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(
                              theme.spacing(AstryxSpacingToken.spacing4),
                            ),
                            child:
                                widget.empty ??
                                AstryxEmptyState(
                                  title: l10n.commandPaletteNoResults,
                                  description: _query.text.isEmpty
                                      ? null
                                      : '"${_query.text}"',
                                ),
                          )
                        : ListView.builder(
                            controller: _scroll,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              vertical: theme.spacing(
                                AstryxSpacingToken.spacing1,
                              ),
                            ),
                            physics: const ClampingScrollPhysics(),
                            itemCount: rows.length,
                            itemBuilder: (context, index) =>
                                _buildRow(rows[index], index),
                          ),
                  ),
                ),
                if (widget.showFooter) ...<Widget>[
                  const AstryxDivider(),
                  Padding(
                    padding: EdgeInsets.all(
                      theme.spacing(AstryxSpacingToken.spacing2),
                    ),
                    child: widget.footer ?? _Legend(l10n: l10n),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(_Row row, int index) {
    final heading = row.heading;
    if (heading != null) {
      final theme = AstryxTheme.of(context);
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: theme.spacing(AstryxSpacingToken.spacing3),
          end: theme.spacing(AstryxSpacingToken.spacing3),
          top: theme.spacing(AstryxSpacingToken.spacing3),
          bottom: theme.spacing(AstryxSpacingToken.spacing1),
        ),
        child: AstryxText(
          heading,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      );
    }

    final item = row.item!;
    return AstryxItem(
      label: item.label,
      description: item.description,
      enabled: item.enabled,
      selected: index == _activeIndex,
      leading: item.icon == null
          ? null
          : AstryxIcon(item.icon!, size: AstryxIconSize.sm),
      // The shortcut is drawn from the hotkey that is bound, so the palette
      // cannot teach a chord that has moved.
      trailing: item.hotkey == null
          ? null
          : AstryxKbd.hotkey(item.hotkey, size: AstryxKbdSize.sm),
      onPressed: () => _run(item),
    );
  }
}

/// The default footer: how to move, run and leave.
class _Legend extends StatelessWidget {
  const _Legend({required this.l10n});

  final AstryxLocalizations l10n;

  @override
  Widget build(BuildContext context) => AstryxHStack(
    gap: AstryxSpacingToken.spacing4,
    wrap: true,
    runGap: AstryxSpacingToken.spacing1,
    children: <Widget>[
      _Hint(
        keys: const <String>['↑', '↓'],
        text: l10n.commandPaletteNavigate,
      ),
      _Hint(keys: const <String>['↵'], text: l10n.commandPaletteRun),
      _Hint(keys: const <String>['Esc'], text: l10n.commandPaletteClose),
    ],
  );
}

class _Hint extends StatelessWidget {
  const _Hint({required this.keys, required this.text});

  final List<String> keys;
  final String text;

  @override
  Widget build(BuildContext context) => AstryxHStack(
    gap: AstryxSpacingToken.spacing1,
    children: <Widget>[
      AstryxKbd.chord(keys, size: AstryxKbdSize.sm),
      AstryxText(
        text,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
    ],
  );
}

/// A heading or a command, in one flat list.
///
/// Flat because the keyboard walks it: a nested structure would mean the arrow
/// keys carrying an index *and* a group, which is two things to get out of
/// step.
@immutable
class _Row {
  const _Row.heading(this.heading) : item = null;
  const _Row.command(this.item) : heading = null;

  final String? heading;
  final AstryxCommandItem? item;
}
