/// Which overlay Escape closes.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// A layer that can be dismissed.
///
/// Registered with [AstryxOverlayStack] while open, unregistered when closed.
typedef AstryxDismissible = void Function();

/// The stack of open, dismissible overlays.
///
/// **Escape must close one layer, not all of them.** A popover opened from
/// inside a dialog is the case that proves it: without coordination, both
/// listen for Escape, both dismiss, and the user loses the dialog they were
/// working in because they wanted to close a colour picker.
///
/// Upstream hit exactly this and solved it with a module-level stack in
/// `useFocusTrap`; this is the same idea. Flutter's own `Navigator` gets the
/// behaviour from its route stack, but Astryx's overlays are `OverlayPortal`s
/// rather than routes — deliberately, so they do not appear in the back stack —
/// so the ordering has to be tracked here.
///
/// Order is push order. Unlike the web there is no DOM to consult for
/// containment, but there is also no equivalent of React's child-before-parent
/// effect ordering: a Flutter overlay opens when something calls `show`, and
/// the inner one is always shown after the outer one that contains its trigger.
abstract final class AstryxOverlayStack {
  static final List<AstryxDismissible> _stack = <AstryxDismissible>[];

  static final Set<AstryxDismissible> _modal =
      Set<AstryxDismissible>.identity();

  static final ValueNotifier<int> _openLayers = ValueNotifier<int>(0);
  static final ValueNotifier<int> _modalLayers = ValueNotifier<int>(0);

  /// The number of open dismissible layers. Exposed for tests.
  @visibleForTesting
  static int get depth => _stack.length;

  /// How many dismissible layers are open, as something to listen to.
  static ValueListenable<int> get openLayers => _openLayers;

  /// How many of those layers are **modal** — a scrim over the page.
  ///
  /// `AstryxScrollLock.whileModalIsOpen` is why this is public and why it is
  /// separate: "is the page claiming to be inert?" is the question a scroll
  /// lock has to answer, and a popover, a menu or a tooltip is not that.
  /// Freezing a page because a tooltip appeared would be a bug with a very
  /// confusing report.
  static ValueListenable<int> get modalLayers => _modalLayers;

  /// Registers [onDismiss] as the top-most layer.
  ///
  /// [modal] marks a layer that dims the page behind it, which is what
  /// [modalLayers] counts.
  static void push(
    AstryxDismissible onDismiss, {
    bool modal = false,
  }) {
    _stack.add(onDismiss);
    if (modal) _modal.add(onDismiss);
    _publish();
  }

  /// Removes [onDismiss], wherever it sits.
  ///
  /// Not necessarily the top: a layer can be closed programmatically while
  /// something above it is still open.
  static void remove(AstryxDismissible onDismiss) {
    final removed = _stack.remove(onDismiss);
    _modal.remove(onDismiss);
    if (removed) _publish();
  }

  /// Whether [onDismiss] is the layer Escape would close.
  static bool isTopmost(AstryxDismissible onDismiss) =>
      _stack.isNotEmpty && identical(_stack.last, onDismiss);

  /// Dismisses the top-most layer, if there is one.
  ///
  /// Returns whether anything was dismissed, so a key handler can report
  /// `KeyEventResult.ignored` and let Escape reach whatever is behind it.
  static bool dismissTopmost() {
    if (_stack.isEmpty) return false;
    _stack.last();
    return true;
  }

  /// Empties the stack. For tests, which must not leak state between cases.
  @visibleForTesting
  static void reset() {
    _stack.clear();
    _modal.clear();
    _publish();
  }

  /// Publishes the depth after the frame that changed it.
  ///
  /// Deferred, because `push` is called from an overlay's `_open` — which can
  /// run during a build — and notifying a listener mid-build is how a
  /// `setState() or markNeedsBuild() called during build` crash happens.
  static void _publish() {
    if (_openLayers.value == _stack.length &&
        _modalLayers.value == _modal.length) {
      return;
    }
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // The stack is read again on the next frame rather than captured here,
      // so a layer opened and closed within one build publishes once.
      WidgetsBinding.instance.addPostFrameCallback((_) => _publishNow());
      return;
    }
    _publishNow();
  }

  static void _publishNow() {
    _openLayers.value = _stack.length;
    _modalLayers.value = _modal.length;
  }
}
