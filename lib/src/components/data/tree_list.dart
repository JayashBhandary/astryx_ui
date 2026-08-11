/// A list whose rows nest.
library;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One node of an [AstryxTreeList].
@immutable
class AstryxTreeNode {
  /// Creates a node.
  const AstryxTreeNode({
    required this.id,
    required this.label,
    this.children = const <AstryxTreeNode>[],
    this.leading,
    this.description,
    this.trailing,
    this.enabled = true,
  });

  /// This node's identity, unique across the whole tree.
  ///
  /// Expansion and selection are carried as ids rather than as flags on the
  /// node, so a caller rebuilding the tree from fresh data does not lose which
  /// branches were open — the usual failure of a tree that stores its state in
  /// its own nodes.
  final String id;

  /// The visible text, and this row's accessible name.
  final String label;

  /// The nodes under this one. A non-empty list makes the row expandable.
  final List<AstryxTreeNode> children;

  /// Content between the chevron and the label — an icon, a status dot.
  final Widget? leading;

  /// Secondary text below the label.
  final String? description;

  /// Content at the reading-end edge — a count, a badge.
  final Widget? trailing;

  /// Whether this row can be chosen or opened.
  final bool enabled;

  /// Whether this row has anything under it.
  bool get hasChildren => children.isNotEmpty;
}

/// A tree of rows, expandable and navigable with the arrow keys.
///
/// **Keyboard behaviour follows the ARIA tree pattern**, which is not what
/// Flutter's focus traversal does by default. The whole tree is a single tab
/// stop; the arrows move within it, Right opens a branch and then steps into
/// it, Left closes it and then steps out to the parent. Tab leaves the tree
/// entirely. A tree whose every row were its own tab stop would take
/// forty presses to walk past.
///
/// Expansion is either yours or the widget's: pass [expanded] and
/// [onExpandedChanged] to drive it, or leave [expanded] null and let the tree
/// keep its own set, seeded from [initiallyExpanded]. Selection is always
/// yours, as it is on `AstryxRadioList`.
///
/// {@tool snippet}
/// ```dart
/// AstryxTreeList(
///   label: 'Files',
///   selected: _selected,
///   onSelectedChanged: (id) => setState(() => _selected = id),
///   nodes: const <AstryxTreeNode>[
///     AstryxTreeNode(
///       id: 'lib',
///       label: 'lib',
///       children: <AstryxTreeNode>[
///         AstryxTreeNode(id: 'main', label: 'main.dart'),
///       ],
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxList`, when the rows do not nest.
///  * `AstryxCollapsible`, for one section that opens rather than a tree of
///    them.
class AstryxTreeList extends StatefulWidget {
  /// Creates a tree.
  const AstryxTreeList({
    required this.nodes,
    super.key,
    this.expanded,
    this.initiallyExpanded = const <String>{},
    this.onExpandedChanged,
    this.selected,
    this.onSelectedChanged,
    this.label,
    this.density = AstryxItemDensity.balanced,
    this.focusNode,
    this.autofocus = false,
  });

  /// The roots, in order.
  final List<AstryxTreeNode> nodes;

  /// The ids of the open branches. Null keeps the set inside the widget.
  final Set<String>? expanded;

  /// The branches open on the first build. Ignored when [expanded] is set.
  final Set<String> initiallyExpanded;

  /// Called with the whole new set whenever a branch opens or closes.
  final ValueChanged<Set<String>>? onExpandedChanged;

  /// The id of the chosen row, or null for none.
  final String? selected;

  /// Called with the id of the row the user chose.
  ///
  /// Null makes the tree read-only: it still expands and still traverses, so a
  /// screen-reader user can read all of it, but nothing is chosen.
  final ValueChanged<String>? onSelectedChanged;

  /// The tree's accessible name — "Files", "Regions".
  final String? label;

  /// The vertical rhythm every row takes.
  final AstryxItemDensity density;

  /// The focus node for the tree, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxTreeList> createState() => _AstryxTreeListState();
}

/// One visible row: a node, how deep it sits, and its parent's id.
@immutable
class _VisibleRow {
  const _VisibleRow(this.node, this.depth, this.parentId);

  final AstryxTreeNode node;
  final int depth;
  final String? parentId;
}

class _AstryxTreeListState extends State<AstryxTreeList> {
  late Set<String> _internalExpanded = <String>{...widget.initiallyExpanded};

  /// Which row the roving focus sits on.
  ///
  /// Not the same as the selection: an unselected tree still has to put focus
  /// somewhere when it is tabbed into, and the ARIA pattern says that is the
  /// first row.
  int _activeIndex = 0;
  int? _hoveredIndex;
  bool _focused = false;

  Set<String> get _expanded => widget.expanded ?? _internalExpanded;

  bool get _interactive => widget.onSelectedChanged != null;

  /// The rows a user can see, flattened depth-first.
  List<_VisibleRow> get _rows {
    final rows = <_VisibleRow>[];
    void walk(List<AstryxTreeNode> nodes, int depth, String? parentId) {
      for (final node in nodes) {
        rows.add(_VisibleRow(node, depth, parentId));
        if (node.hasChildren && _expanded.contains(node.id)) {
          walk(node.children, depth + 1, node.id);
        }
      }
    }

    walk(widget.nodes, 0, null);
    return rows;
  }

  void _setExpanded(Set<String> next) {
    if (widget.expanded == null) {
      setState(() => _internalExpanded = next);
    }
    widget.onExpandedChanged?.call(next);
  }

  void _toggle(AstryxTreeNode node) {
    if (!node.hasChildren || !node.enabled) return;
    final next = <String>{..._expanded};
    if (!next.remove(node.id)) next.add(node.id);
    _setExpanded(next);
  }

  void _setActive(int index) {
    if (index < 0 || index >= _rows.length) return;
    setState(() => _activeIndex = index);
  }

  /// Presses a row: chooses a leaf, opens or closes a branch.
  ///
  /// A branch is also chosen, because a tree where clicking a folder does not
  /// select it is a tree where the folder can never be the answer. One press,
  /// one visible outcome per kind of row.
  void _press(int index) {
    final rows = _rows;
    if (index < 0 || index >= rows.length) return;
    final node = rows[index].node;
    if (!node.enabled) return;

    _setActive(index);
    if (node.hasChildren) {
      _toggle(node);
    }
    if (_interactive) widget.onSelectedChanged!(node.id);
  }

  /// Moves the roving focus by [delta], skipping disabled rows.
  ///
  /// No wrapping, unlike a radio group: a tree is a hierarchy, and jumping from
  /// the last leaf back to the first root loses the reader's place.
  void _move(int delta) {
    final rows = _rows;
    for (var i = _activeIndex + delta; i >= 0 && i < rows.length; i += delta) {
      if (rows[i].node.enabled) {
        _setActive(i);
        return;
      }
    }
  }

  /// Right, or Left under RTL: open a branch, then step into it.
  void _expandOrEnter() {
    final rows = _rows;
    if (_activeIndex >= rows.length) return;
    final node = rows[_activeIndex].node;
    if (!node.hasChildren || !node.enabled) return;

    if (_expanded.contains(node.id)) {
      _move(1);
    } else {
      _toggle(node);
    }
  }

  /// Left, or Right under RTL: close a branch, then step out of it.
  void _collapseOrLeave() {
    final rows = _rows;
    if (_activeIndex >= rows.length) return;
    final row = rows[_activeIndex];

    if (row.node.hasChildren && _expanded.contains(row.node.id)) {
      _toggle(row.node);
      return;
    }

    final parentId = row.parentId;
    if (parentId == null) return;
    final parentIndex = rows.indexWhere((r) => r.node.id == parentId);
    if (parentIndex >= 0) _setActive(parentIndex);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final rows = _rows;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
      case LogicalKeyboardKey.arrowRight:
        rtl ? _collapseOrLeave() : _expandOrEnter();
      case LogicalKeyboardKey.arrowLeft:
        rtl ? _expandOrEnter() : _collapseOrLeave();
      case LogicalKeyboardKey.home:
        _setActive(0);
      case LogicalKeyboardKey.end:
        _setActive(rows.length - 1);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        _press(_activeIndex);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    if (_activeIndex >= rows.length) _activeIndex = 0;

    final tree = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < rows.length; i++) _buildRow(context, rows[i], i),
      ],
    );

    // One tab stop for the whole tree, exactly as a native tree behaves.
    // `skipTraversal` is not enough — the tree itself must be focusable so the
    // arrow keys have somewhere to land.
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) {
        if (mounted) setState(() => _focused = value);
      },
      onKeyEvent: _handleKey,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label,
        child: AstryxItemScope(density: widget.density, child: tree),
      ),
    );
  }

  Widget _buildRow(BuildContext context, _VisibleRow row, int index) {
    final theme = AstryxTheme.of(context);
    final node = row.node;
    final expanded = node.hasChildren && _expanded.contains(node.id);
    final active = index == _activeIndex;
    final selected = widget.selected != null && widget.selected == node.id;
    final hovered =
        _hoveredIndex == index &&
        node.enabled &&
        AstryxTheme.densityOf(context).supportsHover;

    // A leaf pays for the chevron it does not have, so every label at a depth
    // starts at the same x — the thing that makes a tree readable at a glance.
    final chevron = SizedBox(
      width: AstryxIconSize.sm.pixels,
      child: node.hasChildren
          ? AstryxIcon(
              expanded
                  ? AstryxIconName.chevronDown
                  : AstryxIconName.chevronRight,
              size: AstryxIconSize.sm,
              color: node.enabled
                  ? AstryxIconColor.secondary
                  : AstryxIconColor.disabled,
            )
          : null,
    );

    Widget surface = AstryxItemSurface(
      label: node.label,
      density: widget.density,
      description: node.description,
      trailing: node.trailing,
      enabled: node.enabled,
      selected: selected,
      hovered: hovered,
      indent: row.depth * theme.spacing(AstryxSpacingToken.spacing4),
      leading: node.leading == null
          ? chevron
          : Row(
              spacing: theme.spacing(AstryxSpacingToken.spacing2),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[chevron, node.leading!],
            ),
    );

    surface = AstryxFocusRing(
      // Only the row the roving focus sits on shows a ring, and only while the
      // tree itself is focused — otherwise every row would ring at once.
      focused: active && _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      child: surface,
    );

    return Semantics(
      container: true,
      selected: selected ? true : null,
      expanded: node.hasChildren ? expanded : null,
      enabled: node.enabled,
      label: node.label,
      hint: node.description,
      onTap: node.enabled ? () => _press(index) : null,
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: node.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() {
            if (_hoveredIndex == index) _hoveredIndex = null;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: node.enabled ? () => _press(index) : null,
            child: AstryxTapTarget(expandHorizontally: false, child: surface),
          ),
        ),
      ),
    );
  }
}
