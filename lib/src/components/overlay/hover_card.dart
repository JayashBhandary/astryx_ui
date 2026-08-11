/// A rich card revealed by hovering a trigger.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A card of preview content, shown on hover.
///
/// The case it exists for is the one a tooltip cannot hold: a user card behind
/// an @mention, a repository summary behind a link, a chart behind a metric.
/// Rich content, laid out, occasionally with a control in it.
///
/// **It stays open while the pointer is on the card**, which is what separates
/// it from a tooltip. Anything inside is reachable — a link, a button, text you
/// can select — because the pointer can travel from the trigger onto the card
/// without the card deciding it has been abandoned.
///
/// {@tool snippet}
/// ```dart
/// AstryxHoverCard(
///   label: 'Ada Lovelace',
///   content: const UserSummary(),
///   child: AstryxLink(label: '@ada', href: '/people/ada'),
/// )
/// ```
/// {@end-tool}
///
/// **Never put anything essential here alone.** A hover card is a preview of
/// something that must also be reachable by going there: it needs a pointer or
/// a deliberate long-press, it is gone the moment attention moves, and a screen
/// reader user meets it only if they happen to focus the trigger.
///
/// See also:
///
///  * `AstryxTooltip`, for a phrase rather than a panel.
///  * `AstryxPopover`, for content a press should open and keep open.
class AstryxHoverCard extends StatefulWidget {
  /// Creates a hover card.
  const AstryxHoverCard({
    required this.child,
    required this.content,
    super.key,
    this.controller,
    this.label,
    this.side = AstryxOverlaySide.bottom,
    this.align = AstryxOverlayAlign.start,
    this.width = 300,
    this.waitDuration = const Duration(milliseconds: 300),
    this.exitDuration = const Duration(milliseconds: 200),
    this.showArrow = false,
    this.enabled = true,
    this.onOpenChange,
  });

  /// The trigger.
  ///
  /// A child rather than a builder, as a tooltip takes: the card opens on
  /// hover, not on a press, so it never competes with the trigger for the tap.
  final Widget child;

  /// The card's content.
  final Widget content;

  /// Drives the card from outside, for a caller that owns the open state.
  final AstryxOverlayController? controller;

  /// An accessible name for the card.
  final String? label;

  /// The preferred side.
  final AstryxOverlaySide side;

  /// Alignment along the trigger's edge.
  final AstryxOverlayAlign align;

  /// The card's width. Null sizes to the content.
  final double? width;

  /// How long a pointer must rest on the trigger before the card appears.
  ///
  /// Longer than a tooltip's, and deliberately: a panel that appears under
  /// every mouse that crosses a link makes a page feel booby-trapped.
  final Duration waitDuration;

  /// How long after the pointer leaves both the trigger and the card before it
  /// hides.
  ///
  /// This is the grace period for crossing the gap between the two. Zero makes
  /// the card unreachable with a mouse, which defeats the component.
  final Duration exitDuration;

  /// Whether to draw a pointer at the trigger.
  final bool showArrow;

  /// Whether the card responds at all.
  final bool enabled;

  /// Called whenever the card opens or closes.
  final ValueChanged<bool>? onOpenChange;

  @override
  State<AstryxHoverCard> createState() => _AstryxHoverCardState();
}

class _AstryxHoverCardState extends State<AstryxHoverCard> {
  AstryxOverlayController? _internal;

  Timer? _showTimer;
  Timer? _hideTimer;

  /// Whether the pointer is on the trigger or on the card.
  bool _onTrigger = false;
  bool _onCard = false;

  bool _focused = false;

  /// Whether this showing was raised by a long-press.
  ///
  /// A touch has no exit event to close the card with, so that path — and only
  /// that path — arms a dismissing barrier.
  bool _touch = false;

  AstryxOverlayController get _controller =>
      widget.controller ?? (_internal ??= AstryxOverlayController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_notify);
  }

  @override
  void didUpdateWidget(AstryxHoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_notify);
      _controller.addListener(_notify);
    }
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    widget.controller?.removeListener(_notify);
    _internal?.dispose();
    super.dispose();
  }

  void _notify() => widget.onOpenChange?.call(_controller.isOpen);

  void _scheduleShow(Duration delay, {bool touch = false}) {
    if (!widget.enabled) return;
    _hideTimer?.cancel();
    if (_touch != touch) setState(() => _touch = touch);
    if (delay == Duration.zero) {
      _controller.show();
      return;
    }
    _showTimer?.cancel();
    _showTimer = Timer(delay, () {
      if (mounted) _controller.show();
    });
  }

  void _scheduleHide() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.exitDuration, () {
      // Re-checked when the timer fires, not when it is set: the pointer may
      // have arrived on the card in the meantime, which is the whole point of
      // the grace period.
      if (!mounted || _onTrigger || _onCard || _focused) return;
      _controller.hide();
    });
  }

  void _handleFocusChange(bool focused) {
    _focused = focused && AstryxFocusVisible.of(context);
    // No wait on focus: the delay filters *passing* pointers, and a keyboard
    // user did not pass through by accident.
    _focused ? _scheduleShow(Duration.zero) : _scheduleHide();
  }

  void _dismiss() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final density = AstryxTheme.densityOf(context);

    var trigger = widget.child;

    if (density.supportsHover) {
      trigger = MouseRegion(
        onEnter: (_) {
          _onTrigger = true;
          _scheduleShow(widget.waitDuration);
        },
        onExit: (_) {
          _onTrigger = false;
          _scheduleHide();
        },
        child: trigger,
      );
    }

    trigger = GestureDetector(
      // The touch path. `translucent` so the trigger's own tap still lands: a
      // long-press must reveal the card without disabling the link under it.
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _scheduleShow(Duration.zero, touch: true),
      child: trigger,
    );

    trigger = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _handleFocusChange,
      child: trigger,
    );

    return AstryxAnchoredOverlay(
      controller: _controller,
      side: widget.side,
      align: widget.align,
      semanticsLabel: widget.label,
      // Focus is never trapped — the anchored overlay's default. The page
      // behind a hover card is still live, and taking the keyboard hostage for
      // a preview would be indefensible.
      //
      // A barrier would swallow the next click on the page, so only the touch
      // path — which has no other way out — gets one.
      barrierDismissible: _touch,
      onDismiss: _dismiss,
      gap: widget.showArrow
          ? theme.spacing(AstryxSpacingToken.spacing2)
          : theme.spacing(AstryxSpacingToken.spacing1),
      overlayBuilder: (context, position) => MouseRegion(
        onEnter: (_) {
          _onCard = true;
          _hideTimer?.cancel();
        },
        onExit: (_) {
          _onCard = false;
          _scheduleHide();
        },
        child: _HoverCardPanel(
          content: widget.content,
          width: widget.width,
          showArrow: widget.showArrow,
          position: position,
          anchor: _anchorRect(),
        ),
      ),
      child: trigger,
    );
  }

  /// The trigger's rect in global coordinates, for aiming the arrow.
  Rect? _anchorRect() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

/// The floating card.
class _HoverCardPanel extends StatelessWidget {
  const _HoverCardPanel({
    required this.content,
    required this.width,
    required this.showArrow,
    required this.position,
    required this.anchor,
  });

  final Widget content;
  final double? width;
  final bool showArrow;
  final AstryxOverlayPosition position;
  final Rect? anchor;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    Widget panel = AstryxOverlaySurface(
      arrow: showArrow,
      anchor: anchor,
      position: position,
      padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing3)),
      // The content scrolls, not the panel: the positioner caps the height
      // near a screen edge, and scrolling the surface would take its border
      // and shadow with it.
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: content,
      ),
    );

    if (width != null) panel = SizedBox(width: width, child: panel);
    return panel;
  }
}
