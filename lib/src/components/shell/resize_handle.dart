/// A draggable divider that resizes the region beside it.
library;

import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Which edge of the frame the resized region sits against.
///
/// One value rather than an axis and a direction, because the two can be set
/// inconsistently and this cannot: the edge decides the axis, which way a drag
/// grows the region, and which arrow keys apply.
enum AstryxResizeEdge {
  /// A panel at the reading-start edge. Dragging away from it grows it.
  start(Axis.vertical),

  /// A panel at the reading-end edge. Dragging away from it grows it.
  end(Axis.vertical),

  /// A band at the top. Dragging down grows it.
  top(Axis.horizontal),

  /// A band at the bottom. Dragging up grows it.
  bottom(Axis.horizontal);

  const AstryxResizeEdge(this.handleAxis);

  /// Which way the handle itself runs — a vertical bar between two columns,
  /// a horizontal bar between two rows.
  final Axis handleAxis;

  /// Whether the region is resized along the horizontal axis.
  bool get isHorizontal => handleAxis == Axis.vertical;
}

/// A drag target between two regions, which reports the size the one beside it
/// should take.
///
/// It holds no size of its own: [size] comes in and [onResize] goes out, so the
/// number lives in the state that also lays the region out, and a resize
/// survives a rebuild the way every other value in this package does.
///
/// **It is operable from the keyboard**, which is the part hand-rolled resize
/// handles almost always miss. Tab reaches it, the arrow keys move it by
/// [step], Home and End take it to [min] and [max], and it announces itself as
/// a slider carrying the current size — because a divider that only a pointer
/// can move is a layout only some people can use.
///
/// {@tool snippet}
/// ```dart
/// Row(
///   children: <Widget>[
///     SizedBox(width: _width, child: const Filters()),
///     AstryxResizeHandle(
///       label: 'Resize the filters',
///       edge: AstryxResizeEdge.start,
///       size: _width,
///       min: 180,
///       max: 480,
///       onResize: (width) => setState(() => _width = width),
///     ),
///     const Expanded(child: Results()),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxResizeHandle extends StatefulWidget {
  /// Creates a resize handle.
  const AstryxResizeHandle({
    required this.label,
    required this.size,
    super.key,
    this.onResize,
    this.edge = AstryxResizeEdge.start,
    this.min = 0,
    this.max = double.infinity,
    this.step = 16,
    this.onResizeEnd,
    this.enabled = true,
    this.thickness = 8,
    this.focusNode,
    this.autofocus = false,
  });

  /// The handle's accessible name — "Resize the sidebar".
  ///
  /// Required. Nothing is painted on a handle, so without a name a screen
  /// reader has a slider and no idea what it sizes.
  final String label;

  /// The current size of the region beside the handle.
  final double size;

  /// Called with the size the region should take.
  ///
  /// Fired continuously during a drag. Null makes the handle inert — the same
  /// rule `AstryxCard.onPressed` follows, for the same reason.
  final ValueChanged<double>? onResize;

  /// Which edge the resized region sits against.
  final AstryxResizeEdge edge;

  /// The smallest the region may become.
  final double min;

  /// The largest the region may become.
  final double max;

  /// How far one arrow-key press moves the handle.
  final double step;

  /// Called when a drag finishes, for the caller that wants to persist the
  /// size rather than write it on every frame.
  final ValueChanged<double>? onResizeEnd;

  /// Whether the handle responds.
  final bool enabled;

  /// How wide the drag target is.
  ///
  /// Wider than the hairline it draws: a one-pixel target is a target nobody
  /// hits, and the rule is painted in the middle of it.
  final double thickness;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxResizeHandle> createState() => _AstryxResizeHandleState();
}

class _AstryxResizeHandleState extends State<AstryxResizeHandle> {
  bool _hovered = false;
  bool _dragging = false;
  bool _focused = false;

  bool get _interactive => widget.enabled && widget.onResize != null;

  double _clamp(double value) => value.clamp(widget.min, widget.max);

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  /// Applies a pointer delta, in the handle's own drag axis.
  void _drag(double delta) {
    if (!_interactive) return;

    // The inline axis mirrors: under RTL a drag toward the reading end is a
    // *negative* dx. The block axis never mirrors.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final directional = widget.edge.isHorizontal && rtl ? -delta : delta;

    // A region at the start grows as the handle moves away from the start; one
    // at the end grows as it moves the other way.
    final grows = switch (widget.edge) {
      AstryxResizeEdge.start || AstryxResizeEdge.top => directional,
      AstryxResizeEdge.end || AstryxResizeEdge.bottom => -directional,
    };

    widget.onResize!(_clamp(widget.size + grows));
  }

  void _nudge(double delta) {
    if (!_interactive) return;
    final next = _clamp(widget.size + delta);
    if (next == widget.size) return;
    widget.onResize!(next);
    widget.onResizeEnd?.call(next);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final horizontal = widget.edge.isHorizontal;
    final grow = switch (widget.edge) {
      AstryxResizeEdge.start || AstryxResizeEdge.top => 1.0,
      AstryxResizeEdge.end || AstryxResizeEdge.bottom => -1.0,
    };
    final mirror = horizontal && rtl ? -1.0 : 1.0;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight when horizontal:
        _nudge(widget.step * grow * mirror);
      case LogicalKeyboardKey.arrowLeft when horizontal:
        _nudge(-widget.step * grow * mirror);
      case LogicalKeyboardKey.arrowDown when !horizontal:
        _nudge(widget.step * grow);
      case LogicalKeyboardKey.arrowUp when !horizontal:
        _nudge(-widget.step * grow);
      case LogicalKeyboardKey.home:
        _nudge(widget.min - widget.size);
      case LogicalKeyboardKey.end:
        if (widget.max.isFinite) _nudge(widget.max - widget.size);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final density = AstryxTheme.densityOf(context);
    final active = _dragging || (_hovered && density.supportsHover);
    final vertical = widget.edge.handleAxis == Axis.vertical;

    // The rule is the same hairline `AstryxDivider` draws until the handle is
    // in use, when it takes the accent: the affordance appears where the
    // pointer already is, rather than a permanent seam down the page.
    final rule = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      width: vertical ? (active ? 2 : theme.borderWidth()) : null,
      height: vertical ? null : (active ? 2 : theme.borderWidth()),
      decoration: BoxDecoration(
        color: theme.color(
          active && _interactive
              ? AstryxColorToken.accent
              : AstryxColorToken.border,
        ),
        borderRadius: theme.borderRadius(AstryxRadiusToken.full),
      ),
    );

    Widget handle = SizedBox(
      width: vertical ? widget.thickness : null,
      height: vertical ? null : widget.thickness,
      child: Center(child: rule),
    );

    handle = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.full),
      child: handle,
    );

    if (_interactive) {
      handle = MouseRegion(
        cursor: vertical
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // One axis is wired and the other is left null, so the handle never
          // competes for a drag it has no use for — a vertical bar that also
          // claimed vertical drags would fight the scroll view behind it.
          onHorizontalDragStart: vertical ? (_) => _startDrag() : null,
          onHorizontalDragUpdate: vertical
              ? (details) => _drag(details.delta.dx)
              : null,
          onHorizontalDragEnd: vertical ? (_) => _endDrag() : null,
          onHorizontalDragCancel: vertical ? _endDrag : null,
          onVerticalDragStart: vertical ? null : (_) => _startDrag(),
          onVerticalDragUpdate: vertical
              ? null
              : (details) => _drag(details.delta.dy),
          onVerticalDragEnd: vertical ? null : (_) => _endDrag(),
          onVerticalDragCancel: vertical ? null : _endDrag,
          child: handle,
        ),
      );
    }

    handle = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.enabled,
      onFocusChange: (value) => _set(() => _focused = value),
      onKeyEvent: _handleKey,
      child: handle,
    );

    final rounded = widget.size.round();

    return Semantics(
      container: true,
      slider: true,
      enabled: widget.enabled,
      label: widget.label,
      // The size in pixels, which is the only number there is to report: a
      // resize handle has no units of its own.
      value: '$rounded',
      increasedValue: '${_clamp(widget.size + widget.step).round()}',
      decreasedValue: '${_clamp(widget.size - widget.step).round()}',
      onIncrease: _interactive ? () => _nudge(widget.step) : null,
      onDecrease: _interactive ? () => _nudge(-widget.step) : null,
      child: ExcludeSemantics(child: handle),
    );
  }

  void _startDrag() => _set(() => _dragging = true);

  void _endDrag() {
    _set(() => _dragging = false);
    widget.onResizeEnd?.call(widget.size);
  }
}
