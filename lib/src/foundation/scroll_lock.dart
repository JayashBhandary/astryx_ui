/// Freezing the page behind a modal.
library;

import 'package:astryx_ui/src/foundation/overlay_stack.dart';
import 'package:flutter/widgets.dart';

/// Stops the scrollables in its subtree from moving while it is locked.
///
/// The Flutter counterpart of upstream's `useScrollLock`, which sets
/// `overflow: hidden` on the document while a modal is open. There is no
/// document here and no global scroll to freeze, so the lock is a **scope**: it
/// wraps the page and the page stops scrolling, while the modal above it — in
/// its own overlay, outside this subtree — scrolls normally.
///
/// Why it is needed at all: an overlay's scrim blocks *presses* on the page
/// behind it, and a wheel or a trackpad is not a press. Without a lock the
/// content behind an open dialog still scrolls under the pointer, which reads
/// as the modal having failed to take over.
///
/// {@tool snippet}
/// ```dart
/// AstryxScrollLock.whileModalIsOpen(
///   child: AstryxAppShell(child: page),
/// )
/// ```
/// {@end-tool}
///
/// One of those, once, near the root is the whole setup. It is not wired in by
/// default because the lock belongs to the scrollable a product wants frozen,
/// and this package cannot know which that is.
///
/// **A locked subtree takes no pointer events at all**, not merely no scrolls.
/// Blocking the pointer is the only thing that reliably stops a wheel — see the
/// note in the implementation — and behind a modal it costs nothing, because
/// the scrim was already swallowing presses. Do not reach for a lock around
/// something that has to stay clickable while it is locked.
class AstryxScrollLock extends StatelessWidget {
  /// Locks the subtree while [locked] is true.
  const AstryxScrollLock({
    required this.locked,
    required this.child,
    super.key,
  }) : _automatic = false;

  /// Locks the subtree whenever a **modal** layer is open.
  ///
  /// Reads [AstryxOverlayStack.modalLayers] — the same registry Escape
  /// consults — so a dialog, an alert dialog and the shell's navigation drawer
  /// all lock the page without knowing this widget exists. A popover, a menu or
  /// a tooltip does not: those are not claims that the page is inert, and
  /// freezing a page because a tooltip appeared would be a bug with a very
  /// confusing report.
  const AstryxScrollLock.whileModalIsOpen({required this.child, super.key})
    : locked = false,
      _automatic = true;

  /// Whether the subtree is currently frozen.
  final bool locked;

  /// The subtree to freeze.
  final Widget child;

  final bool _automatic;

  @override
  Widget build(BuildContext context) {
    if (!_automatic) return _wrap(context, locked);

    return ValueListenableBuilder<int>(
      valueListenable: AstryxOverlayStack.modalLayers,
      builder: (context, modals, _) => _wrap(context, modals > 0),
    );
  }

  Widget _wrap(BuildContext context, bool active) {
    if (!active) return child;

    // Two mechanisms, because neither is enough on its own.
    //
    // `AbsorbPointer` is what actually stops a wheel, a trackpad and a drag. A
    // physics override cannot: a page-level `ListView` with no controller is
    // `primary: true`, and `ScrollView` wraps the ambient physics in
    // `AlwaysScrollableScrollPhysics` for exactly that case — which overrules
    // anything handed down through `ScrollConfiguration`.
    //
    // The physics override is still worth keeping for the scrollables that do
    // honour it, and for a keyboard: `Space` and the arrow keys scroll a
    // focused scroller, and no pointer is involved in that at all.
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        physics: const NeverScrollableScrollPhysics(),
      ),
      child: AbsorbPointer(child: child),
    );
  }
}
