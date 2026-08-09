/// The engine every anchored overlay is built on.
library;

import 'package:astryx_ui/src/foundation/focus_trap.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/foundation/overlay_stack.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Drives an [AstryxAnchoredOverlay] from outside it.
///
/// {@tool snippet}
/// ```dart
/// final controller = AstryxOverlayController();
/// // …
/// controller.toggle();
/// ```
/// {@end-tool}
class AstryxOverlayController extends ChangeNotifier {
  bool _open = false;

  /// Whether the overlay is showing.
  bool get isOpen => _open;

  /// Shows the overlay.
  void show() {
    if (_open) return;
    _open = true;
    notifyListeners();
  }

  /// Hides the overlay.
  void hide() {
    if (!_open) return;
    _open = false;
    notifyListeners();
  }

  /// Shows the overlay if hidden, hides it if shown.
  void toggle() => _open ? hide() : show();
}

/// How an overlay enters and leaves.
enum AstryxOverlayTransition {
  /// Fades, and slides a little from the side it is anchored to.
  ///
  /// The slide is what tells the user *where the thing came from*, which is
  /// worth more than the fade.
  slide,

  /// Fades only.
  fade,

  /// Fades and scales up from 96%. For a dialog, which has no anchor to slide
  /// from.
  scale,
}

/// Positions floating content against [child] and manages its lifecycle.
///
/// This is the shared machinery behind `AstryxPopover`, `AstryxTooltip`,
/// `AstryxDropdownMenu` and the selector's list: measure the anchor, ask
/// [resolveAstryxOverlayPosition] where the content goes, and handle dismissal,
/// focus and animation identically for all of them.
///
/// Layout is a single pass. `CustomSingleChildLayout` hands its delegate the
/// child's *measured* size, so flip, shift and constrain all run with a real
/// size rather than a guess — no offstage measuring pass, no first-frame jump.
@internal
class AstryxAnchoredOverlay extends StatefulWidget {
  /// Creates an anchored overlay.
  const AstryxAnchoredOverlay({
    required this.controller,
    required this.overlayBuilder,
    required this.child,
    super.key,
    this.side = AstryxOverlaySide.bottom,
    this.align = AstryxOverlayAlign.center,
    this.gap,
    this.viewportPadding,
    this.allowFlip = true,
    this.allowShift = true,
    this.matchAnchorWidth = false,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
    this.trapFocus = false,
    this.restoreFocus = true,
    this.transition = AstryxOverlayTransition.slide,
    this.interactive = true,
    this.onDismiss,
    this.semanticsLabel,
  });

  /// The open/closed state.
  final AstryxOverlayController controller;

  /// Builds the floating content.
  ///
  /// Called with the resolved position so a caller can point an arrow at the
  /// anchor — the side may not be the one that was asked for.
  final Widget Function(BuildContext context, AstryxOverlayPosition position)
  overlayBuilder;

  /// The anchor.
  final Widget child;

  /// The preferred side.
  final AstryxOverlaySide side;

  /// Alignment along the anchor's edge.
  final AstryxOverlayAlign align;

  /// The gap between the anchor and the overlay. Defaults to `--spacing-1`.
  final double? gap;

  /// The minimum distance from the viewport edge. Defaults to `--spacing-2`.
  final double? viewportPadding;

  /// Whether the overlay may move to the opposite side to fit.
  final bool allowFlip;

  /// Whether the overlay may slide along the anchor's edge to fit.
  final bool allowShift;

  /// Whether the overlay is at least as wide as its anchor.
  ///
  /// Upstream gets this from `min-width: anchor-size(width)`, which is what
  /// makes a dropdown look like it belongs to the control above it.
  final bool matchAnchorWidth;

  /// Whether a press outside the overlay closes it.
  final bool barrierDismissible;

  /// Whether Escape closes it — and only it, never the layer beneath.
  final bool escapeDismissible;

  /// Whether focus is trapped inside while open.
  final bool trapFocus;

  /// Whether focus returns to the trigger on close.
  final bool restoreFocus;

  /// How the overlay enters and leaves.
  final AstryxOverlayTransition transition;

  /// Whether the overlay accepts pointer events.
  ///
  /// False for a tooltip, which must not eat the press meant for what it is
  /// describing, and must not steal the hover that is keeping it open.
  final bool interactive;

  /// Called when the overlay dismisses itself.
  final VoidCallback? onDismiss;

  /// An accessible name for the floating surface.
  final String? semanticsLabel;

  @override
  State<AstryxAnchoredOverlay> createState() => _AstryxAnchoredOverlayState();
}

class _AstryxAnchoredOverlayState extends State<AstryxAnchoredOverlay>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _anchorKey = GlobalKey();

  /// The last resolved position, published from layout.
  ///
  /// A `ValueNotifier` rather than `setState`, because the value is produced
  /// *during* layout — where calling `setState` is illegal. Listeners rebuild
  /// on the next frame, which is why an arrow is centred for one frame before
  /// it tracks. At 150 ms of entry animation, nobody sees it.
  final ValueNotifier<AstryxOverlayPosition?> _position =
      ValueNotifier<AstryxOverlayPosition?>(null);

  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final AstryxDismissible _dismissEntry = _dismiss;

  bool _registered = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
    _animation.addStatusListener(_handleAnimationStatus);
    if (widget.controller.isOpen) _open();
  }

  @override
  void didUpdateWidget(AstryxAnchoredOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChange);
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    // Unregistering here is what stops a disposed overlay from swallowing the
    // next Escape — the leak class `P9-7` exists to catch.
    _unregister();
    widget.controller.removeListener(_handleControllerChange);
    _animation.dispose();
    _position.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (!mounted) return;
    widget.controller.isOpen ? _open() : _close();
  }

  void _open() {
    // `OverlayPortalController.show()` asserts if called during build, and a
    // legitimate caller does exactly that: a submenu opens because its parent
    // rebuilt with `submenuOpen: true`. Deferring one frame is the fix, and it
    // is invisible — the entry animation starts on that same frame.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.controller.isOpen) _open();
      });
      return;
    }
    _portal.show();
    _register();
    final duration = AstryxMotion.of(context).duration(
      AstryxDurationToken.fastMax,
    );
    _animation
      ..duration = duration
      ..forward();
  }

  void _close() {
    _unregister();
    _animation.reverse();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    // The portal stays mounted through the exit animation and comes down only
    // when it finishes — otherwise closing is a disappearance, not an exit.
    if (status == AnimationStatus.dismissed && _portal.isShowing) {
      _portal.hide();
    }
  }

  void _register() {
    if (_registered || !widget.escapeDismissible) return;
    AstryxOverlayStack.push(_dismissEntry);
    _registered = true;
  }

  void _unregister() {
    if (!_registered) return;
    AstryxOverlayStack.remove(_dismissEntry);
    _registered = false;
  }

  void _dismiss() {
    widget.controller.hide();
    widget.onDismiss?.call();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (!widget.escapeDismissible || !widget.controller.isOpen) {
      return KeyEventResult.ignored;
    }
    // Only the top-most layer responds. A popover inside a dialog closes the
    // popover; the dialog stays.
    if (!AstryxOverlayStack.isTopmost(_dismissEntry)) {
      return KeyEventResult.ignored;
    }
    _dismiss();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _portal,
    overlayChildBuilder: _buildOverlay,
    child: KeyedSubtree(key: _anchorKey, child: widget.child),
  );

  Widget _buildOverlay(BuildContext overlayContext) {
    final theme = AstryxTheme.of(context);
    final anchorBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return const SizedBox.shrink();

    final anchor = anchorBox.localToGlobal(Offset.zero) & anchorBox.size;

    final media = MediaQuery.of(overlayContext);
    // The safe area, not the raw window. An overlay that flips up into the
    // status bar has traded one clipping problem for another.
    final viewport = Rect.fromLTRB(
      media.padding.left,
      media.padding.top,
      media.size.width - media.padding.right,
      media.size.height - media.padding.bottom,
    );

    final direction = Directionality.of(context);
    final side = AstryxOverlaySide.resolve(widget.side, direction);
    final gap = widget.gap ?? theme.spacing(AstryxSpacingToken.spacing1);
    final padding =
        widget.viewportPadding ?? theme.spacing(AstryxSpacingToken.spacing2);

    Widget surface = ValueListenableBuilder<AstryxOverlayPosition?>(
      valueListenable: _position,
      builder: (context, position, _) => _Transitioned(
        animation: _animation,
        transition: widget.transition,
        side: position?.side ?? side,
        child: widget.overlayBuilder(
          context,
          position ??
              AstryxOverlayPosition(
                offset: Offset.zero,
                side: side,
                size: Size.zero,
                flipped: false,
                shift: 0,
                constrained: false,
              ),
        ),
      ),
    );

    if (widget.semanticsLabel != null) {
      surface = Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticsLabel,
        child: surface,
      );
    }

    if (widget.trapFocus) {
      surface = AstryxFocusTrap(
        restoreFocus: widget.restoreFocus,
        child: surface,
      );
    }

    if (!widget.interactive) {
      surface = IgnorePointer(child: surface);
    }

    return Focus(
      autofocus: widget.trapFocus,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _handleKey,
      child: Stack(
        children: <Widget>[
          if (widget.barrierDismissible)
            // A translucent full-screen layer *below* the surface. Without it
            // an outside press does nothing, and the only way out is Escape —
            // which is how overlays get called broken.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _dismiss,
              ),
            ),
          Positioned.fill(
            child: CustomSingleChildLayout(
              delegate: _AnchoredLayoutDelegate(
                anchor: anchor,
                viewport: viewport,
                side: side,
                align: widget.align,
                gap: gap,
                padding: padding,
                allowFlip: widget.allowFlip,
                allowShift: widget.allowShift,
                minWidth: widget.matchAnchorWidth ? anchor.width : 0,
                onResolved: _publishPosition,
              ),
              child: surface,
            ),
          ),
        ],
      ),
    );
  }

  void _publishPosition(AstryxOverlayPosition position) {
    if (_position.value == position) return;
    // Layout is in progress; notifying now would rebuild mid-layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _position.value = position;
    });
  }
}

/// Places the overlay using [resolveAstryxOverlayPosition].
class _AnchoredLayoutDelegate extends SingleChildLayoutDelegate {
  const _AnchoredLayoutDelegate({
    required this.anchor,
    required this.viewport,
    required this.side,
    required this.align,
    required this.gap,
    required this.padding,
    required this.allowFlip,
    required this.allowShift,
    required this.minWidth,
    required this.onResolved,
  });

  final Rect anchor;
  final Rect viewport;
  final AstryxOverlaySide side;
  final AstryxOverlayAlign align;
  final double gap;
  final double padding;
  final bool allowFlip;
  final bool allowShift;
  final double minWidth;
  final ValueChanged<AstryxOverlayPosition> onResolved;

  /// The constrain half of the contract, applied before the child is measured.
  ///
  /// The block-axis maximum is the *better* of the two sides rather than the
  /// preferred one, because the positioner is allowed to flip. Constraining to
  /// the preferred side would cap an overlay that was about to move somewhere
  /// roomier.
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final available = <double>[
      _room(side),
      if (allowFlip) _room(side.opposite),
    ].reduce((a, b) => a > b ? a : b);

    final isVertical =
        side == AstryxOverlaySide.top || side == AstryxOverlaySide.bottom;

    final maxCross =
        (isVertical ? viewport.width : viewport.height) - padding * 2;

    return BoxConstraints(
      minWidth: minWidth.clamp(0.0, isVertical ? maxCross : available),
      maxWidth: isVertical ? maxCross : available.clamp(0.0, maxCross),
      maxHeight: isVertical
          ? available.clamp(0.0, viewport.height - padding * 2)
          : maxCross,
    );
  }

  /// The room between the anchor and the viewport edge on [candidate].
  double _room(AstryxOverlaySide candidate) {
    final raw = switch (candidate) {
      AstryxOverlaySide.top => anchor.top - viewport.top,
      AstryxOverlaySide.bottom => viewport.bottom - anchor.bottom,
      AstryxOverlaySide.left => anchor.left - viewport.left,
      AstryxOverlaySide.right => viewport.right - anchor.right,
    };
    final room = raw - gap - padding;
    return room < 0 ? 0 : room;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final position = resolveAstryxOverlayPosition(
      anchor: anchor,
      overlaySize: childSize,
      viewport: viewport,
      preferredSide: side,
      align: align,
      gap: gap,
      padding: padding,
      allowFlip: allowFlip,
      allowShift: allowShift,
    );
    onResolved(position);
    return position.offset;
  }

  @override
  bool shouldRelayout(_AnchoredLayoutDelegate oldDelegate) =>
      anchor != oldDelegate.anchor ||
      viewport != oldDelegate.viewport ||
      side != oldDelegate.side ||
      align != oldDelegate.align ||
      gap != oldDelegate.gap ||
      padding != oldDelegate.padding ||
      allowFlip != oldDelegate.allowFlip ||
      allowShift != oldDelegate.allowShift ||
      minWidth != oldDelegate.minWidth;
}

/// The entry and exit animation.
class _Transitioned extends StatelessWidget {
  const _Transitioned({
    required this.animation,
    required this.transition,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final AstryxOverlayTransition transition;
  final AstryxOverlaySide side;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Reduced motion collapses the duration to zero upstream; here the whole
    // transition is skipped, which is the same thing without a one-frame
    // opacity layer nobody asked for.
    if (!AstryxMotionAccess.animate(context)) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: AstryxMotion.of(context).curve(),
    );

    final faded = FadeTransition(opacity: curved, child: child);

    return switch (transition) {
      AstryxOverlayTransition.fade => faded,
      AstryxOverlayTransition.scale => ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
        child: faded,
      ),
      // The slide comes *from* the anchor: an overlay below its trigger rises
      // into place, one above it descends.
      AstryxOverlayTransition.slide => SlideTransition(
        position: Tween<Offset>(
          begin: switch (side) {
            AstryxOverlaySide.bottom => const Offset(0, -0.04),
            AstryxOverlaySide.top => const Offset(0, 0.04),
            AstryxOverlaySide.right => const Offset(-0.04, 0),
            AstryxOverlaySide.left => const Offset(0.04, 0),
          },
          end: Offset.zero,
        ).animate(curved),
        child: faded,
      ),
    };
  }
}
