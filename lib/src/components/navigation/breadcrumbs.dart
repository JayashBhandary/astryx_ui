/// The trail back up a hierarchy.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/navigation/more_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// One step of a breadcrumb trail.
@immutable
class AstryxBreadcrumb {
  /// Creates a step.
  const AstryxBreadcrumb({required this.label, this.onPressed, this.icon});

  /// The name of this level.
  final String label;

  /// Goes there. Null makes the step a label rather than a link.
  ///
  /// The last step is where the user already is, so it usually has none: a
  /// link to the current page is a link that does nothing, and offering it is
  /// how a trail stops telling the user where they are.
  final VoidCallback? onPressed;

  /// An icon before the label — a home glyph on the first step.
  final Widget? icon;
}

/// Where the reader is, and every level above them.
///
/// **It collapses in the middle when it will not fit**, never at the ends. The
/// first step is the way out to the top and the last is where the user
/// is — dropping either to save room throws away the two the trail exists for.
/// What is dropped goes into a menu, so it stays reachable.
///
/// {@tool snippet}
/// ```dart
/// AstryxBreadcrumbs(
///   items: <AstryxBreadcrumb>[
///     AstryxBreadcrumb(label: 'Projects', onPressed: () => go('/')),
///     AstryxBreadcrumb(label: 'astryx_ui', onPressed: () => go('/astryx')),
///     const AstryxBreadcrumb(label: 'Deploy #412'),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxBreadcrumbs extends StatefulWidget {
  /// Creates a breadcrumb trail.
  const AstryxBreadcrumbs({
    required this.items,
    super.key,
    this.label,
    this.separator,
  });

  /// The steps, from the top of the hierarchy to where the reader is.
  final List<AstryxBreadcrumb> items;

  /// The trail's accessible name.
  final String? label;

  /// What goes between two steps. Defaults to a chevron, mirrored under RTL.
  final Widget? separator;

  @override
  State<AstryxBreadcrumbs> createState() => _AstryxBreadcrumbsState();
}

class _AstryxBreadcrumbsState extends State<AstryxBreadcrumbs> {
  /// How many middle steps the last layout could not fit.
  ///
  /// A notifier rather than state: the count is only known *during* layout, so
  /// it reaches the menu without rebuilding the row that measured it.
  final ValueNotifier<int> _hidden = ValueNotifier<int>(0);

  @override
  void dispose() {
    _hidden.dispose();
    super.dispose();
  }

  void _reportHidden(int count) {
    if (_hidden.value == count) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _hidden.value = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final items = widget.items;

    if (items.isEmpty) return const SizedBox.shrink();

    final separator =
        widget.separator ??
        const AstryxIcon(
          AstryxIconName.chevronRight,
          size: AstryxIconSize.xsm,
          color: AstryxIconColor.tertiary,
        );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label ?? l10n.breadcrumbsLabel,
      child: _CrumbRow(
        gap: theme.spacing(AstryxSpacingToken.spacing2),
        onHiddenChanged: _reportHidden,
        children: <Widget>[
          _Crumb(item: items.first, current: items.length == 1),
          // The trigger sits second in the child list and second on the row,
          // which is where the steps it stands in for used to be.
          ValueListenableBuilder<int>(
            valueListenable: _hidden,
            builder: (context, hidden, _) => _CollapsedCrumbs(
              // The hidden steps are the ones after the first, in order.
              items: items.sublist(1, 1 + hidden),
              separator: separator,
              label: l10n.breadcrumbsMore(hidden),
            ),
          ),
          for (var i = 1; i < items.length; i++)
            _Crumb(
              item: items[i],
              current: i == items.length - 1,
              separator: separator,
            ),
        ],
      ),
    );
  }
}

/// One step, with the separator that precedes it.
class _Crumb extends StatelessWidget {
  const _Crumb({required this.item, required this.current, this.separator});

  final AstryxBreadcrumb item;
  final bool current;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final content = item.onPressed == null
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing(AstryxSpacingToken.spacing1),
            ),
            child: AstryxText(
              item.label,
              type: AstryxTextType.supporting,
              // The step the reader is on is the one they cannot go to, so it
              // is the one that does not look like a link.
              color: current
                  ? AstryxTextColor.primary
                  : AstryxTextColor.secondary,
              maxLines: 1,
            ),
          )
        : AstryxButton(
            label: item.label,
            leading: item.icon,
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: item.onPressed,
          );

    if (separator == null) return content;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(AstryxSpacingToken.spacing2),
      children: <Widget>[
        // Decoration: a screen reader gets the trail's structure from the
        // nodes, not from a chevron read aloud between every pair.
        ExcludeSemantics(child: separator),
        content,
      ],
    );
  }
}

/// The menu standing in for the steps that did not fit.
class _CollapsedCrumbs extends StatelessWidget {
  const _CollapsedCrumbs({
    required this.items,
    required this.separator,
    required this.label,
  });

  final List<AstryxBreadcrumb> items;
  final Widget separator;
  final String label;

  @override
  Widget build(BuildContext context) {
    // Nothing was dropped, so there is no trigger — not an invisible one.
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = AstryxTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(AstryxSpacingToken.spacing2),
      children: <Widget>[
        ExcludeSemantics(child: separator),
        // The same overflow menu a toolbar uses, which is what stops the
        // trail's "…" from being a button assembled by hand and named
        // differently from every other one in the package.
        AstryxMoreMenu(
          label: label,
          entries: <AstryxMenuEntry>[
            for (final item in items)
              AstryxMenuItem(
                label: item.label,
                icon: item.icon,
                enabled: item.onPressed != null,
                onSelected: item.onPressed,
              ),
          ],
        ),
      ],
    );
  }
}

/// Lays out the trail, dropping middle steps until it fits.
///
/// The children are the first step, the collapsed-steps trigger, and then every
/// step after the first. The first and the last are always laid out; the ones
/// between are added back from the end — nearest the reader first — while there
/// is room.
///
/// The count settles for the reason `AstryxOverflowList`'s does: hiding more
/// steps never widens the trigger past what hiding fewer would need, so the
/// answer converges within a frame or two of a resize.
class _CrumbRow extends MultiChildRenderObjectWidget {
  const _CrumbRow({
    required this.gap,
    required this.onHiddenChanged,
    required super.children,
  });

  final double gap;
  final ValueChanged<int> onHiddenChanged;

  @override
  _RenderCrumbRow createRenderObject(BuildContext context) =>
      _RenderCrumbRow(gap: gap, onHiddenChanged: onHiddenChanged);

  @override
  void updateRenderObject(BuildContext context, _RenderCrumbRow renderObject) {
    renderObject
      ..gap = gap
      ..onHiddenChanged = onHiddenChanged;
  }
}

class _CrumbParentData extends ContainerBoxParentData<RenderBox> {
  /// Whether this child was placed on the row this pass.
  bool visible = false;
}

class _RenderCrumbRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CrumbParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CrumbParentData> {
  _RenderCrumbRow({required double gap, required this.onHiddenChanged})
    : _gap = gap;

  double _gap;
  double get gap => _gap;
  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  /// Called at the end of every layout with how many middle steps were dropped.
  ValueChanged<int> onHiddenChanged;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CrumbParentData) {
      child.parentData = _CrumbParentData();
    }
  }

  @override
  void performLayout() {
    final children = getChildrenAsList();
    if (children.length < 2) {
      size = constraints.smallest;
      return;
    }

    final first = children.first;
    final trigger = children[1];
    final rest = children.sublist(2);

    final loose = BoxConstraints(maxHeight: constraints.maxHeight);
    for (final child in children) {
      (child.parentData! as _CrumbParentData).visible = false;
      child.layout(loose, parentUsesSize: true);
    }

    // The two that are never dropped.
    var used = first.size.width;
    final shown = <RenderBox>[first];
    if (rest.isNotEmpty) {
      final last = rest.last;
      used += last.size.width;
      shown.add(last);
    }

    // Then back up the trail from the reader, while there is room. Reserving
    // the trigger's width only once anything has been dropped is what lets a
    // trail that fits pay nothing for the machinery.
    final middle = <RenderBox>[
      if (rest.length > 1) ...rest.sublist(0, rest.length - 1),
    ];
    final placed = <RenderBox>[];
    for (final crumb in middle.reversed) {
      final wouldHide = placed.length < middle.length - 1;
      final reserve = wouldHide ? trigger.size.width : 0.0;
      if (used + crumb.size.width + reserve > constraints.maxWidth) break;
      used += crumb.size.width;
      placed.add(crumb);
    }

    final hidden = middle.length - placed.length;

    var height = 0.0;
    void show(RenderBox child) {
      (child.parentData! as _CrumbParentData).visible = true;
      height = height > child.size.height ? height : child.size.height;
    }

    show(first);
    if (hidden > 0) show(trigger);
    for (final crumb in middle) {
      if (placed.contains(crumb)) show(crumb);
    }
    if (rest.isNotEmpty) show(rest.last);

    // Reading order: the first step, the dropped-steps menu where they were,
    // then the steps that survived, then the reader's own step.
    var x = 0.0;
    void place(RenderBox child) {
      final data = child.parentData! as _CrumbParentData;
      if (!data.visible) return;
      data.offset = Offset(x, (height - child.size.height) / 2);
      x += child.size.width;
    }

    place(first);
    if (hidden > 0) place(trigger);
    for (final crumb in middle) {
      if (placed.contains(crumb)) place(crumb);
    }
    if (rest.isNotEmpty) place(rest.last);

    size = constraints.constrain(Size(x, height));
    onHiddenChanged(hidden);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var width = 0.0;
    var index = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      // Skip the trigger: at full width nothing is dropped, so it is not shown.
      if (index != 1) width += child.getMaxIntrinsicWidth(height);
      index++;
    }
    return width;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final data = child.parentData! as _CrumbParentData;
      if (data.visible) context.paintChild(child, data.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in getChildrenAsList().reversed) {
      final data = child.parentData! as _CrumbParentData;
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

  /// Keeps a dropped step out of the semantics tree.
  ///
  /// Otherwise a screen reader would read the steps that did not fit *and* the
  /// menu rows standing in for them — the same trail twice.
  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (var child = firstChild; child != null; child = childAfter(child)) {
      if ((child.parentData! as _CrumbParentData).visible) visitor(child);
    }
  }
}
