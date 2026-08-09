/// Grouped buttons with joined edges.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Carries a group's shared configuration down to its buttons.
///
/// The port of upstream's `ButtonGroupContext`. Upstream reshapes the end caps
/// by setting the `--_button-radius` custom property on the first and last
/// child; here the group supplies a per-position [AstryxButtonTheme] that the
/// button merges, which is the same idea without a cascade.
class AstryxButtonGroupScope extends InheritedWidget {
  /// Creates a button group scope.
  const AstryxButtonGroupScope({
    required super.child,
    super.key,
    this.variant,
    this.size,
    this.buttonTheme,
  });

  /// The variant every button in the group takes, unless it sets its own.
  final AstryxButtonVariant? variant;

  /// The size every button takes, unless it sets its own.
  final AstryxButtonSize? size;

  /// Position-dependent visual overrides — chiefly the corner radii.
  final AstryxButtonTheme? buttonTheme;

  /// The group configuration at [context], or null outside a group.
  static AstryxButtonGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxButtonGroupScope>();

  @override
  bool updateShouldNotify(AstryxButtonGroupScope oldWidget) =>
      variant != oldWidget.variant ||
      size != oldWidget.size ||
      buttonTheme != oldWidget.buttonTheme;
}

/// A row or column of related actions with joined edges.
///
/// The group squares the inner corners so the buttons read as one control, and
/// keeps the outer corners rounded. It also cascades [variant] and [size], so a
/// group is configured once rather than per child.
///
/// The joining is **direction-aware**: the outer corners are logical, so under
/// RTL the first child keeps its rounded corners on the right.
///
/// It also cascades through `AstryxSizeScope`, so a size set on the group
/// reaches buttons nested inside other widgets, not only direct children.
///
/// {@tool snippet}
/// ```dart
/// AstryxButtonGroup(
///   size: AstryxButtonSize.sm,
///   children: <Widget>[
///     AstryxButton(label: 'Day', onPressed: _day),
///     AstryxButton(label: 'Week', onPressed: _week),
///     AstryxButton(label: 'Month', onPressed: _month),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxButton`, the usual child.
class AstryxButtonGroup extends StatelessWidget {
  /// Creates a button group.
  const AstryxButtonGroup({
    required this.children,
    super.key,
    this.variant,
    this.size,
    this.axis = Axis.horizontal,
    this.attached = true,
    this.gap,
  });

  /// The buttons, in order.
  final List<Widget> children;

  /// The variant every child takes unless it sets its own.
  final AstryxButtonVariant? variant;

  /// The size every child takes unless it sets its own.
  final AstryxButtonSize? size;

  /// Whether the group runs horizontally or vertically.
  final Axis axis;

  /// Whether the buttons are joined into one visual control.
  ///
  /// False leaves each button its own shape and spaces them by [gap] — a
  /// related *set* of actions rather than a segmented control.
  final bool attached;

  /// The space between detached buttons. Ignored when [attached].
  final AstryxSpacingToken? gap;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final data = AstryxTheme.of(context);
    final radius = data.borderRadius(AstryxRadiusToken.element);

    final wrapped = <Widget>[
      for (var i = 0; i < children.length; i++)
        AstryxButtonGroupScope(
          variant: variant,
          size: size,
          buttonTheme: attached
              ? AstryxButtonTheme(
                  borderRadius: _radiusFor(
                    index: i,
                    count: children.length,
                    radius: radius,
                  ),
                )
              : null,
          child: children[i],
        ),
    ];

    final spacing = attached
        ? 0.0
        : (gap == null
              ? data.spacing(AstryxSpacingToken.spacing2)
              : data.spacing(gap!));

    if (axis == Axis.vertical) {
      // `IntrinsicWidth` is what makes cross-axis stretch legal in a column:
      // it bounds the width, so the buttons share the widest one instead of
      // filling the parent.
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: wrapped,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      // Centre (the default), not stretch: the buttons already share a height
      // through their size token, and stretching would grow them to the
      // parent's height.
      spacing: spacing,
      children: wrapped,
    );
  }

  /// The corner radii for the child at [index].
  ///
  /// Directional, so the "first" child rounds its reading-start corners — the
  /// left in LTR, the right in RTL — without the group knowing which it is.
  BorderRadiusGeometry _radiusFor({
    required int index,
    required int count,
    required BorderRadius radius,
  }) {
    final isFirst = index == 0;
    final isLast = index == count - 1;
    if (count == 1) return radius;

    final corner = radius.topLeft;

    if (axis == Axis.horizontal) {
      return BorderRadiusDirectional.horizontal(
        start: isFirst ? corner : Radius.zero,
        end: isLast ? corner : Radius.zero,
      );
    }
    // The block axis does not flip, so a plain BorderRadius is correct here.
    return BorderRadius.vertical(
      top: isFirst ? corner : Radius.zero,
      bottom: isLast ? corner : Radius.zero,
    );
  }
}
