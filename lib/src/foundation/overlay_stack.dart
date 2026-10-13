/// Which overlay Escape closes.
library;

import 'dart:async';

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
///
/// **The system back button follows the same rule.** A layer pushed with a
/// `route` blocks that route from popping while it is open, and a back press
/// — Android's button or gesture, or `Navigator.maybePop` — closes the
/// top-most layer instead of leaving the page. That is what Material gets by
/// making its menus and dialogs routes; these stay `OverlayPortal`s and say
/// so to the route directly.
abstract final class AstryxOverlayStack {
  static final List<AstryxDismissible> _stack = <AstryxDismissible>[];

  static final Set<AstryxDismissible> _modal =
      Set<AstryxDismissible>.identity();

  static final Map<AstryxDismissible, _BackEntry> _backEntries =
      Map<AstryxDismissible, _BackEntry>.identity();

  static final List<AstryxDismissible> _backRequests = <AstryxDismissible>[];

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
  ///
  /// [route] is the route the layer's owner sits in. While the layer is open
  /// that route will not pop: a back press closes the top-most layer instead.
  static void push(
    AstryxDismissible onDismiss, {
    bool modal = false,
    ModalRoute<Object?>? route,
  }) {
    _stack.add(onDismiss);
    if (modal) _modal.add(onDismiss);
    if (route != null) {
      final entry = _BackEntry(onDismiss, route);
      _backEntries[onDismiss] = entry;
      route.registerPopEntry(entry);
    }
    _publish();
  }

  /// Removes [onDismiss], wherever it sits.
  ///
  /// Not necessarily the top: a layer can be closed programmatically while
  /// something above it is still open.
  static void remove(AstryxDismissible onDismiss) {
    final removed = _stack.remove(onDismiss);
    _modal.remove(onDismiss);
    final entry = _backEntries.remove(onDismiss);
    if (entry != null) entry.route.unregisterPopEntry(entry);
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
    for (final entry in _backEntries.values) {
      entry.route.unregisterPopEntry(entry);
    }
    _backEntries.clear();
    _backRequests.clear();
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

  /// Records that a back press reached [onDismiss]'s route.
  ///
  /// A route tells **every** pop entry it holds about a blocked pop, so with a
  /// popover open over a dialog both hear the same press. The requests are
  /// collected and settled once, after the route has finished notifying:
  /// only the top-most of them closes.
  static void _requestBack(AstryxDismissible onDismiss) {
    if (_backRequests.isEmpty) scheduleMicrotask(_settleBack);
    _backRequests.add(onDismiss);
  }

  static void _settleBack() {
    final requests = List<AstryxDismissible>.of(_backRequests);
    _backRequests.clear();
    for (final layer in _stack.reversed) {
      if (requests.any((r) => identical(r, layer))) {
        layer();
        return;
      }
    }
  }

  static void _publishNow() {
    _openLayers.value = _stack.length;
    _modalLayers.value = _modal.length;
  }
}

/// The pop entry an open layer registers with its route.
class _BackEntry extends PopEntry<Object?> {
  _BackEntry(this.onDismiss, this.route);

  final AstryxDismissible onDismiss;
  final ModalRoute<Object?> route;

  // Always false: an entry only exists while its layer is open.
  final ValueNotifier<bool> _canPop = ValueNotifier<bool>(false);

  @override
  ValueListenable<bool> get canPopNotifier => _canPop;

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;
    AstryxOverlayStack._requestBack(onDismiss);
  }
}
