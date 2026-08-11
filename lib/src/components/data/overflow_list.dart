/// A row that measures itself and moves what does not fit into a menu.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// One item of an [AstryxOverflowList].
///
/// Two representations of the same thing: [child] is drawn while the item fits
/// on the row, and [label] names it in the menu once it does not. A widget
/// cannot be turned into a menu row automatically, so the caller supplies both
/// — which is also the only way the menu row can be a real, operable row rather
/// than a picture of one.
@immutable
class AstryxOverflowItem {
  /// Creates an item.
  const AstryxOverflowItem({
    required this.label,
    required this.child,
    this.onSelected,
    this.icon,
    this.enabled = true,
  });

  /// The item's name, used for its menu row and as its accessible name.
  final String label;

  /// What is drawn on the row while the item fits.
  final Widget child;

  /// Called when the item is chosen from the menu.
  ///
  /// Null makes the menu row inert — right for something that is a label
  /// rather than an action, such as a tag.
  final VoidCallback? onSelected;

  /// An icon before the label in the menu.
  final Widget? icon;

  /// Whether the menu row can be chosen.
  final bool enabled;
}

/// A row of items that hides its tail behind a menu when the width runs out.
///
/// For a toolbar, a breadcrumb trail, a row of tags — anywhere the number of
/// items is not known in advance and wrapping onto a second line would break
/// the layout around it.
///
/// **Nothing is hidden that a user cannot get to.** The overflow trigger is a
/// real [AstryxDropdownMenu] with a real row per hidden item, so what falls off
/// the end stays reachable by pointer, keyboard and screen reader alike. That
/// is the difference between this and clipping the row.
///
/// {@tool snippet}
/// ```dart
/// AstryxOverflowList(
///   items: <AstryxOverflowItem>[
///     for (final tag in tags)
///       AstryxOverflowItem(
///         label: tag,
///         child: AstryxBadge(tag),
///         onSelected: () => _open(tag),
///       ),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxOverflowList extends StatefulWidget {
  /// Creates an overflow list.
  const AstryxOverflowList({
    required this.items,
    super.key,
    this.gap = AstryxSpacingToken.spacing2,
    this.menuLabel,
    this.minVisible = 1,
  });

  /// The items, in order. The tail is what overflows.
  final List<AstryxOverflowItem> items;

  /// The space between items, and before the trigger.
  final AstryxSpacingToken gap;

  /// An accessible name for the overflow menu.
  final String? menuLabel;

  /// How many items stay on the row however narrow it gets.
  ///
  /// One by default: a row that has collapsed to nothing but a "+7 more"
  /// button tells the user less than the first item would have.
  final int minVisible;

  @override
  State<AstryxOverflowList> createState() => _AstryxOverflowListState();
}

class _AstryxOverflowListState extends State<AstryxOverflowList> {
  /// How many items the last layout could not fit.
  ///
  /// A notifier rather than state: the count is only known *during* layout, and
  /// calling `setState` from there is not allowed. The trigger listens, so the
  /// count reaches the label without rebuilding the row that produced it.
  final ValueNotifier<int> _hidden = ValueNotifier<int>(0);

  @override
  void dispose() {
    _hidden.dispose();
    super.dispose();
  }

  void _reportHidden(int count) {
    if (_hidden.value == count) return;
    // Layout is in progress; the notifier's listeners must not rebuild until it
    // has finished.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _hidden.value = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final gap = theme.spacing(widget.gap);

    return _OverflowRow(
      gap: gap,
      minVisible: widget.minVisible,
      onHiddenChanged: _reportHidden,
      children: <Widget>[
        for (final item in widget.items) item.child,
        ValueListenableBuilder<int>(
          valueListenable: _hidden,
          builder: (context, hidden, _) => _OverflowTrigger(
            items: widget.items.sublist(widget.items.length - hidden),
            label: l10n.overflowMore(hidden),
            menuLabel: widget.menuLabel ?? l10n.overflowMenuLabel,
          ),
        ),
      ],
    );
  }
}

/// The "+n more" button and the menu behind it.
class _OverflowTrigger extends StatelessWidget {
  const _OverflowTrigger({
    required this.items,
    required this.label,
    required this.menuLabel,
  });

  final List<AstryxOverflowItem> items;
  final String label;
  final String menuLabel;

  @override
  Widget build(BuildContext context) {
    // Nothing is hidden, so there is no trigger — not an invisible one. A
    // button that exists but is never painted is a button a test can find, a
    // caller can reach, and nobody can see.
    if (items.isEmpty) return const SizedBox.shrink();

    return AstryxDropdownMenu(
      label: menuLabel,
      matchTriggerWidth: false,
      entries: <AstryxMenuEntry>[
        for (final item in items)
          AstryxMenuItem(
            label: item.label,
            icon: item.icon,
            enabled: item.enabled && item.onSelected != null,
            onSelected: item.onSelected,
          ),
      ],
      triggerBuilder: (context, controller) => AstryxButton(
        label: label,
        variant: AstryxButtonVariant.ghost,
        size: AstryxButtonSize.sm,
        onPressed: controller.toggle,
      ),
    );
  }
}

/// Lays out as many children as fit, then the trigger.
///
/// The last child is the trigger; everything before it is an item.
///
/// The trigger's width depends on the count it shows, and the count depends on
/// how many items fit, which depends on the trigger's width. That circle
/// settles because it only ever turns one way: a wider label hides more items,
/// hiding more items never *narrows* the label, and the count is bounded by the
/// number of items. Widening the row runs the same argument downwards. So the
/// row reaches its answer within a frame or two of any resize, and holds it.
class _OverflowRow extends MultiChildRenderObjectWidget {
  const _OverflowRow({
    required this.gap,
    required this.minVisible,
    required this.onHiddenChanged,
    required super.children,
  });

  final double gap;
  final int minVisible;
  final ValueChanged<int> onHiddenChanged;

  @override
  _RenderOverflowRow createRenderObject(BuildContext context) =>
      _RenderOverflowRow(
        gap: gap,
        minVisible: minVisible,
        onHiddenChanged: onHiddenChanged,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderOverflowRow renderObject,
  ) {
    renderObject
      ..gap = gap
      ..minVisible = minVisible
      ..onHiddenChanged = onHiddenChanged;
  }
}

class _OverflowParentData extends ContainerBoxParentData<RenderBox> {
  /// Whether this child was laid out into the row this pass.
  bool visible = false;
}

class _RenderOverflowRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _OverflowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _OverflowParentData> {
  _RenderOverflowRow({
    required double gap,
    required int minVisible,
    required this.onHiddenChanged,
  }) : _gap = gap,
       _minVisible = minVisible;

  double _gap;
  double get gap => _gap;
  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  int _minVisible;
  int get minVisible => _minVisible;
  set minVisible(int value) {
    if (_minVisible == value) return;
    _minVisible = value;
    markNeedsLayout();
  }

  /// Called at the end of every layout with how many items did not fit.
  ///
  /// Not `markNeedsLayout` on change: the callback only ever carries a number
  /// out of layout, and swapping it does not alter what was laid out.
  ValueChanged<int> onHiddenChanged;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverflowParentData) {
      child.parentData = _OverflowParentData();
    }
  }

  /// The children in order: the items, then the trigger.
  List<RenderBox> get _children => getChildrenAsList();

  @override
  void performLayout() {
    final children = _children;
    // The trailing child is the trigger.
    final itemCount = children.length - 1;
    if (itemCount <= 0) {
      size = constraints.smallest;
      return;
    }

    final items = children.sublist(0, itemCount);
    final trigger = children[itemCount];

    final loose = BoxConstraints(maxHeight: constraints.maxHeight);
    for (final child in children) {
      (child.parentData! as _OverflowParentData).visible = false;
    }

    // Every child is laid out, fitting or not. Skipping the ones that do not
    // fit would leave a render box in the tree with no size, which asserts the
    // moment anything — a hit test, a `tester.getSize` — asks it for one.
    trigger.layout(loose, parentUsesSize: true);
    for (final item in items) {
      item.layout(loose, parentUsesSize: true);
    }

    /// How many items fit in [budget], never fewer than [minVisible].
    int fit(double budget) {
      var used = 0.0;
      var count = 0;
      for (final item in items) {
        final next = used + (count == 0 ? 0 : gap) + item.size.width;
        if (next > budget && count >= minVisible) break;
        used = next;
        count++;
      }
      return count.clamp(minVisible.clamp(0, items.length), items.length);
    }

    // A first pass with nothing reserved: if everything fits, there is no
    // trigger to make room for and its width is not paid. Only when something
    // overflows does the trigger's place have to come out of the budget.
    var fitted = fit(constraints.maxWidth);
    if (fitted < items.length) {
      fitted = fit(constraints.maxWidth - trigger.size.width - gap);
    }

    final hidden = items.length - fitted;
    if (hidden > 0) {
      (trigger.parentData! as _OverflowParentData).visible = true;
    }

    var height = 0.0;
    for (var i = 0; i < fitted; i++) {
      (items[i].parentData! as _OverflowParentData).visible = true;
      height = height > items[i].size.height ? height : items[i].size.height;
    }
    if (hidden > 0) {
      height = height > trigger.size.height ? height : trigger.size.height;
    }

    // Centred on the cross axis, as a `Row` does: a badge and a button on the
    // same line should share a midline, not a top edge.
    var x = 0.0;
    for (var i = 0; i < fitted; i++) {
      final data = items[i].parentData! as _OverflowParentData;
      data.offset = Offset(x, (height - items[i].size.height) / 2);
      x += items[i].size.width + gap;
    }
    if (hidden > 0) {
      final data = trigger.parentData! as _OverflowParentData;
      data.offset = Offset(x, (height - trigger.size.height) / 2);
      x += trigger.size.width;
    } else if (fitted > 0) {
      x -= gap;
    }

    size = constraints.constrain(Size(x, height));
    onHiddenChanged(hidden);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final children = _children;
    final itemCount = children.length - 1;
    if (itemCount <= 0) return 0;
    var width = 0.0;
    for (var i = 0; i < itemCount; i++) {
      width += children[i].getMaxIntrinsicWidth(height) + (i == 0 ? 0 : gap);
    }
    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final children = _children;
    final itemCount = children.length - 1;
    if (itemCount <= 0) return 0;
    // The narrowest this can get is the rows it refuses to hide, plus the
    // trigger it would then need.
    var width = 0.0;
    for (var i = 0; i < minVisible.clamp(0, itemCount); i++) {
      width += children[i].getMinIntrinsicWidth(height) + (i == 0 ? 0 : gap);
    }
    return width + gap + children[itemCount].getMaxIntrinsicWidth(height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _children) {
      final data = child.parentData! as _OverflowParentData;
      if (data.visible) context.paintChild(child, data.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in _children.reversed) {
      final data = child.parentData! as _OverflowParentData;
      if (!data.visible) continue;
      final hit = result.addWithPaintOffset(
        offset: data.offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }

  /// Keeps a hidden child out of the semantics tree.
  ///
  /// Without this a screen reader would read the items that did not fit *and*
  /// the menu rows standing in for them, which is the same list twice.
  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final child in _children) {
      if ((child.parentData! as _OverflowParentData).visible) visitor(child);
    }
  }
}
