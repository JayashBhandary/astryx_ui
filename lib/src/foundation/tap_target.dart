/// The touch-target guarantee.
library;

import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Guarantees a minimum hit region around [child] in touch density, without
/// changing how large it looks.
///
/// Astryx's controls are 28/32/36px tall — right for a mouse, below every
/// touch-target guideline. This expands the *hit region* to at least
/// [AstryxDensity.minimumTapTarget] on both axes while the child paints at its
/// natural size, so a design stays visually identical across platforms and only
/// its ergonomics change. See ADR-006.
///
/// In [AstryxDensity.pointer] it is a pass-through and adds nothing to the
/// tree.
///
/// This is the single mechanism behind the touch-target guarantee: every
/// interactive widget uses it, and none of them implement it.
///
/// ## Put the semantics outside
///
/// A `Semantics` node must wrap *this*, not the other way round:
///
/// ```dart
/// AstryxSemanticsButton(          // outer
///   child: AstryxTapTarget(       // inner
///     child: theVisual,
///   ),
/// )
/// ```
///
/// Nested the other way the semantics node keeps the child's small bounds, so
/// assistive technology — and `meetsGuideline(androidTapTargetGuideline)` —
/// still sees a 20×20 target however large the hit region actually is. The
/// pointer works and the accessibility guarantee silently does not.
///
/// {@tool snippet}
/// ```dart
/// AstryxTapTarget(
///   child: GestureDetector(onTap: _submit, child: const _SmallGlyph()),
/// )
/// ```
/// {@end-tool}
class AstryxTapTarget extends StatelessWidget {
  /// Creates a tap target.
  const AstryxTapTarget({
    required this.child,
    super.key,
    this.density,
    this.minimumSize,
    this.expandHorizontally = true,
    this.expandVertically = true,
  });

  /// The widget whose hit region is enlarged.
  final Widget child;

  /// Overrides the inherited density.
  final AstryxDensity? density;

  /// Overrides the minimum edge length.
  ///
  /// Defaults to the density's own minimum — 44 for touch, nothing for pointer.
  final double? minimumSize;

  /// Whether to enforce the minimum width.
  ///
  /// Set false for a control that is already wide and must not gain horizontal
  /// slop, such as a full-width row.
  final bool expandHorizontally;

  /// Whether to enforce the minimum height.
  final bool expandVertically;

  @override
  Widget build(BuildContext context) {
    final effective = density ?? AstryxTheme.densityOf(context);
    final minimum = minimumSize ?? effective.minimumTapTarget;
    if (minimum <= 0) return child;

    return _AstryxTapTargetLayout(
      minimumSize: Size(
        expandHorizontally ? minimum : 0,
        expandVertically ? minimum : 0,
      ),
      child: child,
    );
  }
}

/// Sizes itself to at least the minimum while laying the child out at its
/// natural size, centred.
///
/// A `ConstrainedBox` would grow the *child*, stretching a 20px glyph to 44px.
/// The child has to keep its own size and only the parent grow, which needs a
/// custom layout.
class _AstryxTapTargetLayout extends SingleChildRenderObjectWidget {
  const _AstryxTapTargetLayout({required this.minimumSize, super.child});

  final Size minimumSize;

  @override
  _RenderTapTarget createRenderObject(BuildContext context) =>
      _RenderTapTarget(minimumSize);

  @override
  void updateRenderObject(BuildContext context, _RenderTapTarget renderObject) {
    renderObject.minimumSize = minimumSize;
  }
}

class _RenderTapTarget extends RenderShiftedBox {
  _RenderTapTarget(this._minimumSize) : super(null);

  Size _minimumSize;

  Size get minimumSize => _minimumSize;
  set minimumSize(Size value) {
    if (_minimumSize == value) return;
    _minimumSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(_minimumSize);
      return;
    }

    child.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(
      Size(
        _max(child.size.width, _minimumSize.width),
        _max(child.size.height, _minimumSize.height),
      ),
    );
    (child.parentData! as BoxParentData).offset = Offset(
      (size.width - child.size.width) / 2,
      (size.height - child.size.height) / 2,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _max(super.computeMinIntrinsicWidth(height), _minimumSize.width);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _max(super.computeMaxIntrinsicWidth(height), _minimumSize.width);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _max(super.computeMinIntrinsicHeight(width), _minimumSize.height);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _max(super.computeMaxIntrinsicHeight(width), _minimumSize.height);

  @override
  bool hitTestSelf(Offset position) {
    // The padded area is part of the target, which is the whole point: a tap in
    // the slop around a small glyph must still count.
    return size.contains(position);
  }

  static double _max(double a, double b) => a > b ? a : b;
}
