/// A short description shown on hover, focus or long-press.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';

/// A short, non-interactive description of its trigger.
///
/// **Reachable without a mouse.** Hover shows it after a delay on a pointer
/// device; keyboard focus shows it immediately; and on touch a **long-press**
/// shows it. A hover-only tooltip is invisible on half the platforms Astryx
/// targets, which is what ADR-006 committed against.
///
/// The content is also attached to the trigger's semantics, so a screen-reader
/// user gets it without performing any gesture at all.
///
/// **Never put essential information in a tooltip alone.** If the user must
/// know it to complete the task, it belongs in the interface. Upstream's
/// best-practice list says the same thing, and it is the single most common way
/// tooltips are misused.
///
/// {@tool snippet}
/// ```dart
/// AstryxTooltip(
///   message: 'Archive this conversation',
///   child: AstryxIconButton(
///     icon: AstryxIconName.archive,
///     label: 'Archive',
///     onPressed: _archive,
///   ),
/// )
/// ```
/// {@end-tool}
class AstryxTooltip extends StatefulWidget {
  /// Creates a tooltip.
  const AstryxTooltip({
    required this.message,
    required this.child,
    super.key,
    this.side = AstryxOverlaySide.top,
    this.align = AstryxOverlayAlign.center,
    this.waitDuration = const Duration(milliseconds: 200),
    this.exitDuration = Duration.zero,
    this.showDuration = const Duration(milliseconds: 1500),
    this.showArrow = false,
    this.maxWidth = 300,
    this.enabled = true,
    this.excludeFromSemantics = false,
  });

  /// The text to show. Keep it short.
  final String message;

  /// The trigger.
  final Widget child;

  /// The preferred side. Defaults to above, as upstream does.
  final AstryxOverlaySide side;

  /// Alignment along the trigger's edge.
  final AstryxOverlayAlign align;

  /// How long a pointer must rest before the tooltip appears.
  ///
  /// The delay is what stops a tooltip firing at everything a mouse crosses on
  /// its way somewhere else.
  final Duration waitDuration;

  /// How long after the pointer leaves before the tooltip hides.
  final Duration exitDuration;

  /// How long a long-press tooltip stays after the finger lifts.
  ///
  /// A touch tooltip cannot hide on release: the finger is over the thing it
  /// describes, and letting go is how you get out of the way to read it. So it
  /// lingers instead. Hover has no such problem, which is why this applies only
  /// to the touch path.
  final Duration showDuration;

  /// Whether to draw a pointer at the trigger.
  final bool showArrow;

  /// The widest the tooltip may be before its text wraps.
  final double maxWidth;

  /// Whether the tooltip responds at all.
  final bool enabled;

  /// Whether to leave [message] out of the trigger's semantics.
  ///
  /// For a trigger whose accessible name already says the same thing — an
  /// `AstryxIconButton` labelled "Archive" with the tooltip "Archive". Hearing
  /// it twice is worse than not hearing it.
  final bool excludeFromSemantics;

  @override
  State<AstryxTooltip> createState() => _AstryxTooltipState();
}

class _AstryxTooltipState extends State<AstryxTooltip> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  /// `Timer`, not `Future.delayed` — a delayed future cannot be cancelled, and
  /// a tooltip whose pointer has already left must not appear anyway (ADR-025).
  Timer? _showTimer;
  Timer? _hideTimer;

  bool _focused = false;

  @override
  void dispose() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleShow(Duration delay) {
    if (!widget.enabled) return;
    _hideTimer?.cancel();
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
    // Focus outranks hover: a tooltip shown because the trigger is focused
    // must not vanish when the mouse wanders off it.
    if (_focused) return;
    if (widget.exitDuration == Duration.zero) {
      _controller.hide();
      return;
    }
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.exitDuration, () {
      if (mounted) _controller.hide();
    });
  }

  /// Shows for [AstryxTooltip.showDuration], then hides itself.
  void _showForTouch() {
    _scheduleShow(Duration.zero);
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.showDuration, () {
      if (mounted) _controller.hide();
    });
  }

  void _handleFocusChange(bool focused) {
    _focused = focused && AstryxFocusVisible.of(context);
    // Immediately on focus, with no wait: the delay exists to filter *passing*
    // pointers, and a keyboard user did not pass through by accident.
    _focused ? _scheduleShow(Duration.zero) : _scheduleHide();
  }

  @override
  Widget build(BuildContext context) {
    final density = AstryxTheme.densityOf(context);

    var trigger = widget.child;

    if (density.supportsHover) {
      trigger = MouseRegion(
        onEnter: (_) => _scheduleShow(widget.waitDuration),
        onExit: (_) => _scheduleHide(),
        child: trigger,
      );
    }

    trigger = GestureDetector(
      // The touch path. `translucent` so the trigger's own tap still lands —
      // a long-press must reveal the tooltip without disabling the button.
      behavior: HitTestBehavior.translucent,
      onLongPress: _showForTouch,
      child: trigger,
    );

    trigger = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _handleFocusChange,
      child: trigger,
    );

    if (!widget.excludeFromSemantics) {
      // The content, on the trigger, with no gesture required — this is what
      // makes a tooltip reachable by a screen reader at all. Merged into the
      // trigger's own node rather than left as a parent, so it is announced as
      // "Archive, button, Archive this conversation" and not as two separate
      // things the user has to navigate between.
      trigger = MergeSemantics(
        child: Semantics(tooltip: widget.message, child: trigger),
      );
    }

    return AstryxAnchoredOverlay(
      controller: _controller,
      side: widget.side,
      align: widget.align,
      // A tooltip never takes a press and never takes focus. Both would be
      // wrong: it is a description, not a control.
      interactive: false,
      barrierDismissible: false,
      gap: AstryxTheme.of(context).spacing(AstryxSpacingToken.spacing1),
      overlayBuilder: (context, position) => _TooltipBubble(
        message: widget.message,
        maxWidth: widget.maxWidth,
        showArrow: widget.showArrow,
        position: position,
        anchor: _anchorRect(),
      ),
      child: trigger,
    );
  }

  Rect? _anchorRect() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

/// The bubble.
class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({
    required this.message,
    required this.maxWidth,
    required this.showArrow,
    required this.position,
    required this.anchor,
  });

  final String message;
  final double maxWidth;
  final bool showArrow;
  final AstryxOverlayPosition position;
  final Rect? anchor;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AstryxOverlaySurface(
        // Inverted, as upstream is: `--color-text-primary` as the fill and
        // `--color-background-surface` as the text. A tooltip that matches the
        // surface it floats over reads as part of it.
        background: AstryxColorToken.textPrimary,
        foreground: AstryxColorToken.backgroundSurface,
        showBorder: false,
        arrow: showArrow,
        anchor: anchor,
        position: position,
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing2),
          vertical: theme.spacing(AstryxSpacingToken.spacing1),
        ),
        child: Text(
          message,
          style: theme
              .textStyle(AstryxTypeRole.body)
              .copyWith(
                color: theme.color(AstryxColorToken.backgroundSurface),
              ),
        ),
      ),
    );
  }
}
