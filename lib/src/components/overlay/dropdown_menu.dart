/// A menu of actions, optionally nested.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/components/overlay/menu_surface.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:flutter/widgets.dart';

/// A menu of actions anchored to a trigger.
///
/// **The keyboard is the whole point of this widget.** Arrows move the
/// highlight, Home and End jump to the ends, typing jumps to the first match,
/// Enter activates, Escape closes, and Right and Left open and close submenus —
/// mirrored under RTL, where Left is "forward". Nothing is activated merely by
/// being highlighted.
///
/// {@tool snippet}
/// ```dart
/// AstryxDropdownMenu(
///   entries: <AstryxMenuEntry>[
///     AstryxMenuItem(
///       label: 'Edit',
///       icon: AstryxIconName.edit,
///       onSelected: _edit,
///     ),
///     const AstryxMenuDivider(),
///     AstryxMenuItem(label: 'Delete', destructive: true, onSelected: _delete),
///   ],
///   triggerBuilder: (context, controller) =>
///       AstryxButton(label: 'Actions', onPressed: controller.toggle),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxContextMenu`, for the same rows raised by a secondary click.
class AstryxDropdownMenu extends StatefulWidget {
  /// Creates a dropdown menu.
  const AstryxDropdownMenu({
    required this.entries,
    required this.triggerBuilder,
    super.key,
    this.controller,
    this.label,
    this.side = AstryxOverlaySide.bottom,
    this.align = AstryxOverlayAlign.start,
    this.width,
    this.matchTriggerWidth = true,
    this.maxHeight = 300,
    this.onOpenChange,
  });

  /// The rows, in order.
  final List<AstryxMenuEntry> entries;

  /// Builds the trigger, given the controller that opens the menu.
  ///
  /// A builder rather than a child because a button consumes its own taps —
  /// see ADR-034.
  final Widget Function(
    BuildContext context,
    AstryxOverlayController controller,
  )
  triggerBuilder;

  /// Drives the menu from outside.
  final AstryxOverlayController? controller;

  /// An accessible name for the menu surface.
  final String? label;

  /// The preferred side.
  final AstryxOverlaySide side;

  /// Alignment along the trigger's edge.
  final AstryxOverlayAlign align;

  /// A fixed width. Null sizes to the widest row.
  final double? width;

  /// Whether the menu is at least as wide as its trigger.
  final bool matchTriggerWidth;

  /// The tallest the menu may be before it scrolls.
  final double maxHeight;

  /// Called whenever the menu opens or closes.
  final ValueChanged<bool>? onOpenChange;

  @override
  State<AstryxDropdownMenu> createState() => _AstryxDropdownMenuState();
}

class _AstryxDropdownMenuState extends State<AstryxDropdownMenu> {
  AstryxOverlayController? _internal;
  final FocusNode _menuFocus = FocusNode(debugLabel: 'AstryxDropdownMenu');

  AstryxOverlayController get _controller =>
      widget.controller ?? (_internal ??= AstryxOverlayController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleOpenChange);
  }

  @override
  void didUpdateWidget(AstryxDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleOpenChange);
      _controller.addListener(_handleOpenChange);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleOpenChange);
    _internal?.dispose();
    _menuFocus.dispose();
    super.dispose();
  }

  void _handleOpenChange() {
    widget.onOpenChange?.call(_controller.isOpen);
    if (!_controller.isOpen) return;
    // The menu takes focus so the arrows have somewhere to land. Deferred a
    // frame, because the surface does not exist until the portal builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isOpen) _menuFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) => AstryxAnchoredOverlay(
    controller: _controller,
    side: widget.side,
    align: widget.align,
    matchAnchorWidth: widget.matchTriggerWidth,
    semanticsLabel: widget.label,
    overlayBuilder: (context, position) => AstryxMenuSurface(
      entries: widget.entries,
      focusNode: _menuFocus,
      width: widget.width,
      maxHeight: widget.maxHeight,
      onClose: _controller.hide,
    ),
    child: Builder(
      builder: (context) => widget.triggerBuilder(context, _controller),
    ),
  );
}
