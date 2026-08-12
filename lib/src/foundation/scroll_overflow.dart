/// Knowing whether a scroller has more content past either edge.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What a scroller has past its edges.
///
/// "Start" and "end" are logical: under a right-to-left [Directionality] the
/// start edge of a horizontal scroller is the right one, and everything here —
/// including the fades — follows.
@immutable
class AstryxScrollEdges {
  /// Creates a description of a scroller's edges.
  const AstryxScrollEdges({
    required this.overflows,
    required this.atStart,
    required this.atEnd,
  });

  /// Nothing has been measured yet, or there is nothing to scroll.
  static const AstryxScrollEdges none = AstryxScrollEdges(
    overflows: false,
    atStart: true,
    atEnd: true,
  );

  /// Whether the content is longer than the viewport at all.
  ///
  /// False means the other two are both true and neither means anything: a
  /// scroller with nothing to scroll is at both ends at once.
  final bool overflows;

  /// Whether the scroller is at its start edge.
  final bool atStart;

  /// Whether the scroller is at its end edge.
  final bool atEnd;

  /// Whether there is content hidden *before* the viewport.
  bool get hasMoreAtStart => overflows && !atStart;

  /// Whether there is content hidden *after* the viewport.
  bool get hasMoreAtEnd => overflows && !atEnd;

  @override
  bool operator ==(Object other) =>
      other is AstryxScrollEdges &&
      other.overflows == overflows &&
      other.atStart == atStart &&
      other.atEnd == atEnd;

  @override
  int get hashCode => Object.hash(overflows, atStart, atEnd);

  @override
  String toString() =>
      'AstryxScrollEdges(overflows: $overflows, atStart: $atStart, '
      'atEnd: $atEnd)';
}

/// Reports what a scroller has past its edges, and optionally fades them.
///
/// The Flutter counterpart of upstream's `useScrollOverflow`. A clipped edge
/// with nothing at it looks like the end of the content, and a user who cannot
/// tell the difference stops scrolling — so a scroller wider than its box needs
/// to *say* there is more.
///
/// It listens to scroll notifications rather than owning a controller, so it
/// works over any scrollable — one you built, one a component built, one nested
/// three widgets down — without being handed anything.
///
/// {@tool snippet}
/// ```dart
/// AstryxScrollOverflow(
///   child: SingleChildScrollView(
///     scrollDirection: Axis.horizontal,
///     child: Row(children: chips),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// Pass [builder] instead of relying on the fades to draw your own affordance —
/// a pair of arrow buttons, a "3 more" count, a shadow.
class AstryxScrollOverflow extends StatefulWidget {
  /// Creates an overflow reporter around [child].
  const AstryxScrollOverflow({
    required this.child,
    super.key,
    this.axis = Axis.horizontal,
    this.fade = true,
    this.fadeExtent = 24,
    this.fadeColor,
    this.builder,
    this.onChanged,
  });

  /// The scrollable — or anything containing one.
  final Widget child;

  /// Which axis to watch.
  ///
  /// A notification from a scroller on the other axis is ignored, so a
  /// horizontal strip inside a vertically scrolling page reports only its own
  /// edges.
  final Axis axis;

  /// Whether to draw a gradient at an edge that has more content past it.
  final bool fade;

  /// How wide a fade is, in logical pixels.
  final double fadeExtent;

  /// The colour a fade resolves to. Defaults to `--color-background-body`.
  ///
  /// It has to match whatever is *behind* the scroller, so a strip on a card
  /// wants `backgroundCard` and one on the page wants the default.
  final AstryxColorToken? fadeColor;

  /// Wraps the child once the edges are known.
  ///
  /// Called on every change, with the child already faded if [fade] is on.
  final Widget Function(
    BuildContext context,
    AstryxScrollEdges edges,
    Widget child,
  )?
  builder;

  /// Called whenever the edges change.
  final ValueChanged<AstryxScrollEdges>? onChanged;

  @override
  State<AstryxScrollOverflow> createState() => _AstryxScrollOverflowState();
}

class _AstryxScrollOverflowState extends State<AstryxScrollOverflow> {
  AstryxScrollEdges _edges = AstryxScrollEdges.none;

  /// Reads [metrics] and publishes the result.
  ///
  /// A pixel of tolerance at each end, because a scroller resting at its
  /// maximum is routinely a fraction of a pixel short of it and a fade that
  /// flickers on and off at rest is worse than no fade.
  void _update(ScrollMetrics metrics) {
    if (metrics.axis != widget.axis) return;

    final overflows = metrics.maxScrollExtent > metrics.minScrollExtent + 1;
    final next = AstryxScrollEdges(
      overflows: overflows,
      atStart: metrics.pixels <= metrics.minScrollExtent + 1,
      atEnd: metrics.pixels >= metrics.maxScrollExtent - 1,
    );

    if (next == _edges) return;
    setState(() => _edges = next);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    var content = widget.child;

    if (widget.fade) {
      content = _EdgeFades(
        edges: _edges,
        axis: widget.axis,
        extent: widget.fadeExtent,
        color: widget.fadeColor ?? AstryxColorToken.backgroundBody,
        child: content,
      );
    }

    if (widget.builder != null) {
      content = widget.builder!(context, _edges, content);
    }

    // Two notifications, because they answer different halves. A
    // `ScrollNotification` fires when the offset moves; a
    // `ScrollMetricsNotification` fires when the *extent* changes — a resize, a
    // row added — which is the case a listener on the offset alone misses, and
    // the reason a strip that grew stayed unfaded until somebody touched it.
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        _update(notification.metrics);
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _update(notification.metrics);
          return false;
        },
        child: content,
      ),
    );
  }
}

/// Gradients at whichever edge has more content past it.
class _EdgeFades extends StatelessWidget {
  const _EdgeFades({
    required this.edges,
    required this.axis,
    required this.extent,
    required this.color,
    required this.child,
  });

  final AstryxScrollEdges edges;
  final Axis axis;
  final double extent;
  final AstryxColorToken color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!edges.overflows) return child;

    final fill = AstryxTheme.of(context).color(color);
    final horizontal = axis == Axis.horizontal;

    return Stack(
      children: <Widget>[
        child,
        // Only on the side that actually has more, so a fade is information
        // rather than decoration — and never hit-testable, so it cannot eat a
        // press meant for the row underneath it.
        if (edges.hasMoreAtStart)
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: horizontal ? 0 : null,
            end: horizontal ? null : 0,
            child: _Fade(
              color: fill,
              extent: extent,
              axis: axis,
              towardsStart: true,
            ),
          ),
        if (edges.hasMoreAtEnd)
          PositionedDirectional(
            start: horizontal ? null : 0,
            end: 0,
            top: horizontal ? 0 : null,
            bottom: 0,
            child: _Fade(
              color: fill,
              extent: extent,
              axis: axis,
              towardsStart: false,
            ),
          ),
      ],
    );
  }
}

class _Fade extends StatelessWidget {
  const _Fade({
    required this.color,
    required this.extent,
    required this.axis,
    required this.towardsStart,
  });

  final Color color;
  final double extent;
  final Axis axis;
  final bool towardsStart;

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == Axis.horizontal;

    // Directional alignments, so a horizontal gradient runs the right way under
    // RTL without this widget knowing which way that is.
    final begin = horizontal
        ? (towardsStart
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd)
        : (towardsStart ? Alignment.topCenter : Alignment.bottomCenter);
    final end = horizontal
        ? (towardsStart
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart)
        : (towardsStart ? Alignment.bottomCenter : Alignment.topCenter);

    return IgnorePointer(
      child: SizedBox(
        width: horizontal ? extent : null,
        height: horizontal ? null : extent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: <Color>[color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
