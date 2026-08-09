/// Overlay geometry.
///
/// A **pure function**. No `BuildContext`, no widgets, no `Overlay` — given an
/// anchor, a size and a viewport it returns where the overlay goes and which
/// side it ended up on.
///
/// That separation is deliberate. Five widgets in Phase 9 and two outside it
/// depend on this geometry, and a bug found through a rendered popover is far
/// harder to diagnose than one found in a table of rectangles.
///
/// The behaviours match CSS anchor positioning, which is what upstream uses:
/// **flip** to the opposite side when the preferred one does not fit, **shift**
/// along the cross axis to stay on screen, and **constrain** to the viewport
/// rather than overflowing it.
library;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Which side of the anchor an overlay prefers.
///
/// Physical, not logical: an overlay flips on available space, and space is a
/// property of the screen rather than of the reading direction. Use
/// [AstryxOverlaySide.resolve] to turn a logical preference into one of these.
enum AstryxOverlaySide {
  /// Above the anchor.
  top,

  /// Below the anchor. The usual default.
  bottom,

  /// Left of the anchor.
  left,

  /// Right of the anchor.
  right;

  /// The side directly opposite this one.
  AstryxOverlaySide get opposite => switch (this) {
    AstryxOverlaySide.top => AstryxOverlaySide.bottom,
    AstryxOverlaySide.bottom => AstryxOverlaySide.top,
    AstryxOverlaySide.left => AstryxOverlaySide.right,
    AstryxOverlaySide.right => AstryxOverlaySide.left,
  };

  /// Whether this side stacks the overlay above or below the anchor.
  bool get isVertical =>
      this == AstryxOverlaySide.top || this == AstryxOverlaySide.bottom;

  /// The physical side for [side] under [direction].
  ///
  /// Only meaningful on the inline axis; [top] and [bottom] are returned
  /// unchanged, because the block axis does not flip in any locale Astryx
  /// supports.
  static AstryxOverlaySide resolve(
    AstryxOverlaySide side,
    TextDirection direction,
  ) {
    if (side.isVertical) return side;
    if (direction == TextDirection.ltr) return side;
    return side.opposite;
  }
}

/// How an overlay lines up along the anchor's cross axis.
enum AstryxOverlayAlign {
  /// Flush with the anchor's leading edge — its top for a side overlay, its
  /// left for one above or below.
  start,

  /// Centred on the anchor.
  center,

  /// Flush with the anchor's trailing edge.
  end,
}

/// Where an overlay ended up, and how it got there.
@immutable
class AstryxOverlayPosition {
  /// Creates a resolved position.
  const AstryxOverlayPosition({
    required this.offset,
    required this.side,
    required this.size,
    required this.flipped,
    required this.shift,
    required this.constrained,
  });

  /// The overlay's top-left corner, in the same space as the inputs.
  final Offset offset;

  /// The side actually used, which is not the preferred one when [flipped].
  final AstryxOverlaySide side;

  /// The size the overlay should take, at most the viewport minus its padding.
  final Size size;

  /// Whether the preferred side had too little room.
  final bool flipped;

  /// How far the overlay slid along the cross axis to stay on screen.
  ///
  /// Zero when it fitted where it wanted. An arrow tracking the anchor's
  /// centre subtracts this, which is what keeps it pointing at the anchor
  /// after a shift.
  final double shift;

  /// Whether the overlay had to be shrunk to fit the viewport.
  final bool constrained;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxOverlayPosition &&
          other.offset == offset &&
          other.side == side &&
          other.size == size &&
          other.flipped == flipped &&
          other.shift == shift &&
          other.constrained == constrained;

  @override
  int get hashCode =>
      Object.hash(offset, side, size, flipped, shift, constrained);

  @override
  String toString() =>
      'AstryxOverlayPosition($offset, ${side.name}, $size, '
      'flipped: $flipped, shift: $shift)';
}

/// Resolves where an overlay of [overlaySize] should sit against [anchor].
///
/// [viewport] is the space the overlay may occupy, already reduced by any safe
/// area the caller cares about. [padding] keeps the overlay off the very edge.
/// [gap] is the space between the anchor and the overlay.
///
/// The algorithm, in order — the order matters, because flipping changes which
/// axis the shift applies to:
///
/// 1. **Flip.** If the preferred side has less room than the overlay needs
///    *and* the opposite side has more, use the opposite side.
/// 2. **Constrain.** Clamp the overlay to the viewport minus padding. A caller
///    that receives a smaller [AstryxOverlayPosition.size] than it asked for
///    should scroll its content rather than overflow.
/// 3. **Shift.** Slide along the cross axis until the overlay is inside the
///    viewport, recording how far it moved.
///
/// {@tool snippet}
/// ```dart
/// final position = resolveAstryxOverlayPosition(
///   anchor: anchorRect,
///   overlaySize: const Size(200, 120),
///   viewport: Offset.zero & screenSize,
///   preferredSide: AstryxOverlaySide.bottom,
/// );
/// ```
/// {@end-tool}
AstryxOverlayPosition resolveAstryxOverlayPosition({
  required Rect anchor,
  required Size overlaySize,
  required Rect viewport,
  AstryxOverlaySide preferredSide = AstryxOverlaySide.bottom,
  AstryxOverlayAlign align = AstryxOverlayAlign.center,
  double gap = 8,
  double padding = 8,
  bool allowFlip = true,
  bool allowShift = true,
}) {
  final safe = Rect.fromLTRB(
    viewport.left + padding,
    viewport.top + padding,
    viewport.right - padding,
    viewport.bottom - padding,
  );

  // 1. Flip. Room is measured from the anchor's edge, less the gap.
  var side = preferredSide;
  var flipped = false;

  if (allowFlip) {
    final roomFor = <AstryxOverlaySide, double>{
      AstryxOverlaySide.top: anchor.top - safe.top - gap,
      AstryxOverlaySide.bottom: safe.bottom - anchor.bottom - gap,
      AstryxOverlaySide.left: anchor.left - safe.left - gap,
      AstryxOverlaySide.right: safe.right - anchor.right - gap,
    };
    final needed = preferredSide.isVertical
        ? overlaySize.height
        : overlaySize.width;

    // Only flip when the other side is genuinely better. Flipping into a space
    // that is also too small trades one overflow for another and makes the
    // overlay jump for no gain.
    if (roomFor[preferredSide]! < needed &&
        roomFor[preferredSide.opposite]! > roomFor[preferredSide]!) {
      side = preferredSide.opposite;
      flipped = true;
    }
  }

  // 2. Constrain. Along the placement axis the overlay may use the room on its
  // chosen side; across it, the whole safe width or height.
  final available = side.isVertical
      ? Size(
          safe.width,
          side == AstryxOverlaySide.top
              ? anchor.top - safe.top - gap
              : safe.bottom - anchor.bottom - gap,
        )
      : Size(
          side == AstryxOverlaySide.left
              ? anchor.left - safe.left - gap
              : safe.right - anchor.right - gap,
          safe.height,
        );

  final size = Size(
    math.min(overlaySize.width, math.max(0, available.width)),
    math.min(overlaySize.height, math.max(0, available.height)),
  );
  final constrained = size != overlaySize;

  // 3. Place along the main axis, then align and shift along the cross axis.
  final double mainX;
  final double mainY;
  switch (side) {
    case AstryxOverlaySide.top:
      mainY = anchor.top - gap - size.height;
      mainX = _alignedCross(
        anchorStart: anchor.left,
        anchorExtent: anchor.width,
        overlayExtent: size.width,
        align: align,
      );
    case AstryxOverlaySide.bottom:
      mainY = anchor.bottom + gap;
      mainX = _alignedCross(
        anchorStart: anchor.left,
        anchorExtent: anchor.width,
        overlayExtent: size.width,
        align: align,
      );
    case AstryxOverlaySide.left:
      mainX = anchor.left - gap - size.width;
      mainY = _alignedCross(
        anchorStart: anchor.top,
        anchorExtent: anchor.height,
        overlayExtent: size.height,
        align: align,
      );
    case AstryxOverlaySide.right:
      mainX = anchor.right + gap;
      mainY = _alignedCross(
        anchorStart: anchor.top,
        anchorExtent: anchor.height,
        overlayExtent: size.height,
        align: align,
      );
  }

  var x = mainX;
  var y = mainY;
  var shift = 0.0;

  if (allowShift) {
    if (side.isVertical) {
      x = _shiftInto(mainX, size.width, safe.left, safe.right);
      shift = x - mainX;
    } else {
      y = _shiftInto(mainY, size.height, safe.top, safe.bottom);
      shift = y - mainY;
    }
  }

  // The main axis is clamped too, so a viewport too small for the overlay
  // pushes it flush against the edge rather than off it.
  if (side.isVertical) {
    y = _shiftInto(y, size.height, safe.top, safe.bottom);
  } else {
    x = _shiftInto(x, size.width, safe.left, safe.right);
  }

  return AstryxOverlayPosition(
    offset: Offset(x, y),
    side: side,
    size: size,
    flipped: flipped,
    shift: shift,
    constrained: constrained,
  );
}

/// The cross-axis start for [align], before any shift.
double _alignedCross({
  required double anchorStart,
  required double anchorExtent,
  required double overlayExtent,
  required AstryxOverlayAlign align,
}) => switch (align) {
  AstryxOverlayAlign.start => anchorStart,
  AstryxOverlayAlign.center => anchorStart + (anchorExtent - overlayExtent) / 2,
  AstryxOverlayAlign.end => anchorStart + anchorExtent - overlayExtent,
};

/// Slides a span of [extent] starting at [start] into `[min, max]`.
///
/// A span wider than the range is pinned to [min] rather than centred, so the
/// overlay's own start stays visible — the end is what gets cut off, and the
/// start is where the content begins.
double _shiftInto(double start, double extent, double min, double max) {
  if (extent >= max - min) return min;
  if (start < min) return min;
  if (start + extent > max) return max - extent;
  return start;
}

/// Where an arrow should sit along the overlay's edge, so it keeps pointing at
/// the anchor's centre after a shift.
///
/// Returns a distance from the overlay's leading edge along its cross axis,
/// clamped so the arrow stays within the overlay's rounded corners.
double resolveAstryxOverlayArrowOffset({
  required Rect anchor,
  required AstryxOverlayPosition position,
  required double arrowExtent,
  double cornerInset = 8,
}) {
  final anchorCentre = position.side.isVertical
      ? anchor.center.dx
      : anchor.center.dy;
  final overlayStart = position.side.isVertical
      ? position.offset.dx
      : position.offset.dy;
  final overlayExtent = position.side.isVertical
      ? position.size.width
      : position.size.height;

  final ideal = anchorCentre - overlayStart - arrowExtent / 2;
  final limit = overlayExtent - arrowExtent - cornerInset;

  // A limit below the inset means the overlay is narrower than its own corners
  // allow for; centring is the least-wrong answer there.
  if (limit < cornerInset) return (overlayExtent - arrowExtent) / 2;
  return ideal.clamp(cornerInset, limit);
}
