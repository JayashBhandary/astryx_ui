/// An anchored panel of interactive content.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A panel of interactive content anchored to a trigger.
///
/// Opens on a press, closes on a press outside or Escape, and **returns focus
/// to the trigger on close**. That last part is the one that gets skipped, and
/// it is the difference between a popover a keyboard user can use twice and one
/// they can use once.
///
/// Focus is trapped inside while open by default, matching upstream and the
/// ARIA button + dialog pattern. Set [trapFocus] false for a non-modal panel
/// where trapping would be hostile — a formatting toolbar over an editor, say.
///
/// The trigger is a **builder**, not a plain child, and that is deliberate:
/// the widget cannot wrap a button in its own `GestureDetector` and expect the
/// press to arrive, because the button wins the gesture arena. Handing the
/// caller the controller makes the wiring explicit and works with any trigger
/// at all (ADR-034).
///
/// {@tool snippet}
/// ```dart
/// AstryxPopover(
///   label: 'Settings',
///   content: const SettingsPanel(),
///   triggerBuilder: (context, controller) =>
///       AstryxButton(label: 'Settings', onPressed: controller.toggle),
/// )
/// ```
/// {@end-tool}
///
/// For a hover-triggered overlay use `AstryxTooltip`; for a list of actions use
/// `AstryxDropdownMenu`. Both are built on the same positioner.
///
/// See also:
///
///  * `AstryxDialog`, for content that should block the rest of the page.
class AstryxPopover extends StatefulWidget {
  /// Creates a popover.
  const AstryxPopover({
    required this.triggerBuilder,
    required this.content,
    super.key,
    this.controller,
    this.label,
    this.side = AstryxOverlaySide.bottom,
    this.align = AstryxOverlayAlign.center,
    this.width,
    this.matchTriggerWidth = false,
    this.showArrow = false,
    this.trapFocus = true,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
    this.onOpenChange,
  });

  /// Builds the trigger, given the controller that opens the panel.
  ///
  /// Wire it to whatever opens the popover — normally a button's `onPressed`.
  final Widget Function(
    BuildContext context,
    AstryxOverlayController controller,
  )
  triggerBuilder;

  /// The floating content.
  final Widget content;

  /// Drives the popover from outside, for a caller that owns the open state.
  ///
  /// Null makes the popover uncontrolled: it owns a controller and toggles it
  /// on a press.
  final AstryxOverlayController? controller;

  /// An accessible name for the panel.
  final String? label;

  /// The preferred side.
  final AstryxOverlaySide side;

  /// Alignment along the trigger's edge.
  final AstryxOverlayAlign align;

  /// A fixed width. Null sizes to the content.
  final double? width;

  /// Whether the panel is at least as wide as its trigger.
  final bool matchTriggerWidth;

  /// Whether to draw a pointer at the trigger.
  final bool showArrow;

  /// {@template AstryxPopover.trapFocus}
  /// Whether focus is trapped inside the panel while it is open.
  /// {@endtemplate}
  final bool trapFocus;

  /// Whether a press outside closes it.
  final bool barrierDismissible;

  /// Whether Escape closes it.
  final bool escapeDismissible;

  /// Called whenever the panel opens or closes.
  final ValueChanged<bool>? onOpenChange;

  @override
  State<AstryxPopover> createState() => _AstryxPopoverState();
}

class _AstryxPopoverState extends State<AstryxPopover> {
  AstryxOverlayController? _internal;

  AstryxOverlayController get _controller =>
      widget.controller ?? (_internal ??= AstryxOverlayController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_notify);
  }

  @override
  void didUpdateWidget(AstryxPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_notify);
      _controller.addListener(_notify);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_notify);
    _internal?.dispose();
    super.dispose();
  }

  void _notify() => widget.onOpenChange?.call(_controller.isOpen);

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxAnchoredOverlay(
      controller: _controller,
      side: widget.side,
      align: widget.align,
      matchAnchorWidth: widget.matchTriggerWidth,
      barrierDismissible: widget.barrierDismissible,
      escapeDismissible: widget.escapeDismissible,
      trapFocus: widget.trapFocus,
      semanticsLabel: widget.label,
      // The arrow needs room to sit in, so the gap grows to clear it.
      gap: widget.showArrow
          ? theme.spacing(AstryxSpacingToken.spacing2)
          : theme.spacing(AstryxSpacingToken.spacing1),
      overlayBuilder: (context, position) => _PopoverPanel(
        content: widget.content,
        width: widget.width,
        showArrow: widget.showArrow,
        position: position,
        anchor: _anchorRect(),
      ),
      child: Builder(
        builder: (context) => widget.triggerBuilder(context, _controller),
      ),
    );
  }

  /// The trigger's rect in global coordinates, for aiming the arrow.
  Rect? _anchorRect() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

/// The floating panel.
class _PopoverPanel extends StatelessWidget {
  const _PopoverPanel({
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
      // The *content* scrolls, not the panel: the positioner's `constrain`
      // caps the height, and something has to give. Scrolling the surface
      // instead would scroll its border and shadow out of view.
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: content,
      ),
    );

    if (width != null) panel = SizedBox(width: width, child: panel);
    return panel;
  }
}
