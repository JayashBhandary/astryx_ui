/// The width rule a card follows.
library;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Gives [child] the incoming width when there is one, and its own preferred
/// width when there is not.
///
/// A card stretches its slots to its full width, which is what a block box
/// does — and what asserts the moment the card is handed an unbounded width, as
/// a `Row` or a horizontal list does. Shrinking to the content in exactly that
/// case is CSS's own rule: a block box fills a definite width and shrinks to
/// fit an indefinite one.
///
/// This is not [IntrinsicWidth]. That keys on whether the width is *tight*, so
/// it also shrinks a card sitting in a merely loose parent — a `Center`, a
/// `ConstrainedBox` — where filling is the correct block-box behaviour and what
/// the card has always done. This keys on whether the width is *bounded*, so
/// only the genuinely unbounded case changes, and pays for an intrinsic pass
/// only in that case.
@internal
class AstryxBlockWidth extends SingleChildRenderObjectWidget {
  /// Wraps [child] in the block-box width rule.
  const AstryxBlockWidth({required Widget super.child, super.key});

  @override
  RenderProxyBox createRenderObject(BuildContext context) =>
      _RenderBlockWidth();
}

class _RenderBlockWidth extends RenderProxyBox {
  BoxConstraints _innerConstraints(BoxConstraints constraints) {
    final child = this.child;
    if (child == null || constraints.hasBoundedWidth) return constraints;
    return constraints.tighten(
      width: child.getMaxIntrinsicWidth(constraints.maxHeight),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_innerConstraints(constraints), parentUsesSize: true);
    size = child.size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      child?.getDryLayout(_innerConstraints(constraints)) ??
      constraints.smallest;
}
