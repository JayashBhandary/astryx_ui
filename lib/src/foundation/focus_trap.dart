/// Keeping focus inside an overlay, and giving it back afterwards.
library;

import 'package:flutter/widgets.dart';

/// Traps keyboard focus inside its subtree and restores it on the way out.
///
/// Two behaviours, both required by the WAI-ARIA dialog pattern and both easy
/// to get subtly wrong:
///
///  1. **Trap.** Tab from the last focusable child returns to the first, and
///     Shift+Tab from the first goes to the last. Focus never escapes to the
///     page behind the overlay, which is still visible and still tabbable as
///     far as the framework is concerned. `FocusScopeNode` already defaults to
///     `TraversalEdgeBehavior.closedLoop`, which *is* the trap; this widget
///     exists for the second half.
///  2. **Restore.** On dismount, focus returns to whatever held it before —
///     normally the trigger. A user who opens a dialog with the keyboard and
///     closes it must not be dumped back at the top of the document.
///
/// The restore half matters more than it looks. `FocusScope` already restores
/// focus *within* a scope, but the node that opened the overlay is outside it,
/// so the framework has nothing to go back to. This widget records the node
/// itself.
///
/// {@tool snippet}
/// ```dart
/// AstryxFocusTrap(
///   enabled: isOpen,
///   child: const MyDialogBody(),
/// )
/// ```
/// {@end-tool}
class AstryxFocusTrap extends StatefulWidget {
  /// Creates a focus trap.
  const AstryxFocusTrap({
    required this.child,
    super.key,
    this.enabled = true,
    this.autofocus = true,
    this.restoreFocus = true,
    this.debugLabel,
  });

  /// The subtree focus is kept inside.
  final Widget child;

  /// Whether the trap is active.
  ///
  /// False lets focus move freely — for a popover that is deliberately
  /// non-modal, where trapping would be hostile rather than helpful.
  final bool enabled;

  /// Whether to move focus into the subtree when the trap activates.
  final bool autofocus;

  /// Whether to return focus to the previously-focused node on dismount.
  final bool restoreFocus;

  /// A label for the debug focus tree.
  final String? debugLabel;

  @override
  State<AstryxFocusTrap> createState() => _AstryxFocusTrapState();
}

class _AstryxFocusTrapState extends State<AstryxFocusTrap> {
  late final FocusScopeNode _node = FocusScopeNode(
    debugLabel: widget.debugLabel ?? 'AstryxFocusTrap',
  );

  /// The node that held focus when the trap activated.
  FocusNode? _previous;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _activate();
  }

  @override
  void didUpdateWidget(AstryxFocusTrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _activate();
    } else if (!widget.enabled && oldWidget.enabled) {
      _restore();
    }
  }

  @override
  void dispose() {
    // Restore *before* disposing the scope: disposing it first hands focus to
    // whatever the framework picks, and the whole point is to choose.
    _restore();
    _node.dispose();
    super.dispose();
  }

  void _activate() {
    final primary = FocusManager.instance.primaryFocus;
    // A node inside the trap is not somewhere to go back to.
    if (primary != null && !_node.descendants.contains(primary)) {
      _previous = primary;
    }
    if (!widget.autofocus) return;

    // Focus has to be *moved*, not merely offered. `FocusScope.autofocus`
    // only fires when nothing in the enclosing scope already holds focus —
    // and the trigger that opened the overlay is exactly such a node, so the
    // one case that matters is the one autofocus skips.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.enabled) return;
      final current = FocusManager.instance.primaryFocus;
      if (current != null && _node.descendants.contains(current)) return;
      _node.requestFocus();
    });
  }

  void _restore() {
    final previous = _previous;
    _previous = null;
    if (!widget.restoreFocus || previous == null) return;
    // The trigger may itself have been removed — a menu item that closes the
    // menu it lives in is the ordinary case — so this is checked, not assumed.
    if (previous.context == null || !previous.canRequestFocus) return;
    previous.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return FocusScope(
      node: _node,
      autofocus: widget.autofocus,
      child: widget.child,
    );
  }
}
