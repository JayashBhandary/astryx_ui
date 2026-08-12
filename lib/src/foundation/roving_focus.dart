/// One tab stop, arrow keys within it.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// What an [AstryxRovingFocus] tells each item about itself.
@immutable
class AstryxRovingFocusItem {
  /// Creates an item's state.
  const AstryxRovingFocusItem({
    required this.index,
    required this.isActive,
    required this.groupHasFocus,
  });

  /// Which item this is.
  final int index;

  /// Whether the roving focus sits on this item.
  ///
  /// True for exactly one item at a time, whether or not the group itself is
  /// focused — so a strip can keep showing where the caret *would* land.
  final bool isActive;

  /// Whether the group holds keyboard focus.
  final bool groupHasFocus;

  /// Whether this item should draw a focus ring.
  ///
  /// The pair of conditions, in one place: only the active item, and only while
  /// the group is focused. Hand it to `AstryxFocusRing.focused`, which applies
  /// the `:focus-visible` rule on top.
  bool get showsFocusRing => isActive && groupHasFocus;

  @override
  bool operator ==(Object other) =>
      other is AstryxRovingFocusItem &&
      other.index == index &&
      other.isActive == isActive &&
      other.groupHasFocus == groupHasFocus;

  @override
  int get hashCode => Object.hash(index, isActive, groupHasFocus);
}

/// A set of items that is **one tab stop**, traversed with the arrow keys.
///
/// The Flutter counterpart of upstream's `useListFocus` and `useGridFocus`, and
/// the ARIA composite-widget pattern both implement: Tab moves onto the group
/// and off it again, and the arrows move *within* it. A toolbar of twelve
/// buttons is twelve presses to walk past otherwise, and a calendar month is
/// thirty-one.
///
/// **Roving focus is not selection.** This moves an *active index*; what that
/// means is yours. Wire [onActivate] to commit on `Enter` and `Space` — the
/// behaviour a menu, a grid or a tab strip wants — or select as the focus
/// moves, which is what a radio group does.
///
/// Every composite in this package already behaves this way; reach for this to
/// build one the package does not have.
///
/// {@tool snippet}
/// ```dart
/// AstryxRovingFocus.list(
///   length: chips.length,
///   label: 'Filters',
///   onActivate: (index) => _toggle(chips[index]),
///   itemBuilder: (context, item) => AstryxFocusRing(
///     focused: item.showsFocusRing,
///     child: _Chip(chips[item.index]),
///   ),
/// )
/// ```
/// {@end-tool}
class AstryxRovingFocus extends StatefulWidget {
  /// Creates a one-dimensional group — a row, a column, a strip.
  const AstryxRovingFocus.list({
    required this.length,
    required this.itemBuilder,
    super.key,
    this.orientation = Axis.horizontal,
    this.wrap = true,
    this.onActivate,
    this.isEnabled,
    this.activeIndex,
    this.onActiveChanged,
    this.gap = AstryxSpacingToken.spacing1,
    this.layoutBuilder,
    this.label,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  }) : columns = null;

  /// Creates a two-dimensional group.
  ///
  /// The inline arrows move within a row and the block arrows move between
  /// them, which is what a user of a grid tries first. [wrap] is off by default
  /// here: wrapping off the end of a row into the next one is right for a menu
  /// and wrong for a calendar, where it would silently change the week.
  const AstryxRovingFocus.grid({
    required this.length,
    required int this.columns,
    required this.itemBuilder,
    super.key,
    this.wrap = false,
    this.onActivate,
    this.isEnabled,
    this.activeIndex,
    this.onActiveChanged,
    this.gap = AstryxSpacingToken.spacing1,
    this.layoutBuilder,
    this.label,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  }) : orientation = Axis.horizontal;

  /// How many items there are.
  final int length;

  /// Builds one item, told whether the focus is on it.
  final Widget Function(BuildContext context, AstryxRovingFocusItem item)
  itemBuilder;

  /// How many columns, for [AstryxRovingFocus.grid]. Null for a list.
  final int? columns;

  /// Which way a list runs. Both axes still move in either orientation, as the
  /// ARIA pattern asks and as a user who does not know which way it runs will
  /// try.
  final Axis orientation;

  /// Whether movement wraps at the ends rather than stopping.
  final bool wrap;

  /// Called with the index `Enter` or `Space` was pressed on.
  final ValueChanged<int>? onActivate;

  /// Whether the item at an index can hold the focus.
  ///
  /// Movement skips the ones that cannot. Null treats every item as available.
  final bool Function(int index)? isEnabled;

  /// The active index, for a caller that owns it. Null keeps it internal.
  final int? activeIndex;

  /// Called with the index the focus moved to.
  final ValueChanged<int>? onActiveChanged;

  /// The gap between items in the default layout.
  final AstryxSpacingToken gap;

  /// Lays the built items out. Null uses a row, a column or a grid.
  final Widget Function(BuildContext context, List<Widget> items)?
  layoutBuilder;

  /// An accessible name for the group.
  final String? label;

  /// Whether the group takes focus and responds to keys.
  final bool enabled;

  /// The group's focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether the group takes focus when first built.
  final bool autofocus;

  @override
  State<AstryxRovingFocus> createState() => _AstryxRovingFocusState();
}

class _AstryxRovingFocusState extends State<AstryxRovingFocus> {
  int _internalIndex = 0;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _internalIndex = _firstEnabled() ?? 0;
  }

  @override
  void didUpdateWidget(AstryxRovingFocus oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A shorter list must not leave the focus past its end — the classic crash
    // when a filter removes rows while a group is focused.
    if (_internalIndex >= widget.length) {
      _internalIndex = _firstEnabled() ?? 0;
    }
  }

  int get _index {
    final owned = widget.activeIndex;
    if (owned == null) return _internalIndex;
    return owned.clamp(0, widget.length == 0 ? 0 : widget.length - 1);
  }

  int get _columns => widget.columns ?? 1;

  bool get _interactive => widget.enabled && widget.length > 0;

  bool _isEnabled(int index) => widget.isEnabled?.call(index) ?? true;

  int? _firstEnabled() {
    for (var i = 0; i < widget.length; i++) {
      if (_isEnabled(i)) return i;
    }
    return null;
  }

  void _moveTo(int index) {
    if (!_interactive || index < 0 || index >= widget.length) return;
    if (!_isEnabled(index) || index == _index) return;

    if (widget.activeIndex == null) setState(() => _internalIndex = index);
    widget.onActiveChanged?.call(index);
  }

  /// Steps by [delta], skipping disabled items and wrapping if allowed.
  void _step(int delta) {
    if (!_interactive) return;
    final count = widget.length;

    for (var step = 1; step <= count; step++) {
      final raw = _index + delta * step;
      if (!widget.wrap && (raw < 0 || raw >= count)) return;
      final index = ((raw % count) + count) % count;
      if (_isEnabled(index)) {
        _moveTo(index);
        return;
      }
    }
  }

  /// Moves within a grid row, or along a list.
  void _stepInline(int delta) {
    if (widget.columns == null) return _step(delta);

    final row = _index ~/ _columns;
    final column = _index % _columns;
    final next = column + delta;

    if (next < 0 || next >= _columns) {
      // Off the end of a row: wrap into the neighbouring one when asked, and
      // otherwise stop — a calendar must not turn "left" into "a week earlier".
      if (!widget.wrap) return;
      return _step(delta);
    }
    _moveTo(row * _columns + next);
  }

  void _stepBlock(int delta) {
    if (widget.columns == null) return _step(delta);
    _step(delta * _columns);
  }

  /// The first and last index of the row [index] sits in.
  (int, int) _rowBounds(int index) {
    if (widget.columns == null) return (0, widget.length - 1);
    final row = index ~/ _columns;
    final start = row * _columns;
    final end = (start + _columns - 1).clamp(0, widget.length - 1);
    return (start, end);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final list = widget.columns == null;
    final vertical = list && widget.orientation == Axis.vertical;

    switch (event.logicalKey) {
      // The inline arrows mirror under RTL; the block arrows never do.
      case LogicalKeyboardKey.arrowRight:
        vertical ? _stepBlock(rtl ? -1 : 1) : _stepInline(rtl ? -1 : 1);
      case LogicalKeyboardKey.arrowLeft:
        vertical ? _stepBlock(rtl ? 1 : -1) : _stepInline(rtl ? 1 : -1);
      case LogicalKeyboardKey.arrowDown:
        list ? _step(1) : _stepBlock(1);
      case LogicalKeyboardKey.arrowUp:
        list ? _step(-1) : _stepBlock(-1);
      case LogicalKeyboardKey.home:
        _moveToEdge(toStart: true);
      case LogicalKeyboardKey.end:
        _moveToEdge(toStart: false);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
      case LogicalKeyboardKey.space:
        if (widget.onActivate == null) return KeyEventResult.ignored;
        if (_isEnabled(_index)) widget.onActivate!(_index);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  /// Home and End: the ends of the row in a grid, of the whole group in a list.
  void _moveToEdge({required bool toStart}) {
    final (start, end) = _rowBounds(_index);
    if (toStart) {
      for (var i = start; i <= end; i++) {
        if (_isEnabled(i)) return _moveTo(i);
      }
    } else {
      for (var i = end; i >= start; i--) {
        if (_isEnabled(i)) return _moveTo(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final active = _index;

    final items = <Widget>[
      for (var i = 0; i < widget.length; i++)
        widget.itemBuilder(
          context,
          AstryxRovingFocusItem(
            index: i,
            isActive: i == active,
            groupHasFocus: _hasFocus,
          ),
        ),
    ];

    final laid =
        widget.layoutBuilder?.call(context, items) ??
        _defaultLayout(items, theme.spacing(widget.gap));

    // One tab stop for the whole group. `skipTraversal` alone would not do it:
    // the group itself has to be focusable, or the arrow keys have nowhere to
    // land. Whatever `itemBuilder` returns must therefore *not* be focusable,
    // or Tab would step into it and the group would stop being one stop.
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: _interactive,
      onKeyEvent: _handleKey,
      onFocusChange: (focused) {
        if (mounted) setState(() => _hasFocus = focused);
      },
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label,
        child: laid,
      ),
    );
  }

  Widget _defaultLayout(List<Widget> items, double gap) {
    final columns = widget.columns;

    if (columns == null) {
      return widget.orientation == Axis.horizontal
          ? Row(mainAxisSize: MainAxisSize.min, spacing: gap, children: items)
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: gap,
              children: items,
            );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: gap,
      children: <Widget>[
        for (var row = 0; row * columns < items.length; row++)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: gap,
            children: items.sublist(
              row * columns,
              ((row + 1) * columns).clamp(0, items.length),
            ),
          ),
      ],
    );
  }
}
