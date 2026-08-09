/// Which overlay Escape closes.
library;

import 'package:flutter/foundation.dart';

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

  /// The number of open dismissible layers. Exposed for tests.
  @visibleForTesting
  static int get depth => _stack.length;

  /// Registers [onDismiss] as the top-most layer.
  static void push(AstryxDismissible onDismiss) => _stack.add(onDismiss);

  /// Removes [onDismiss], wherever it sits.
  ///
  /// Not necessarily the top: a layer can be closed programmatically while
  /// something above it is still open.
  static void remove(AstryxDismissible onDismiss) => _stack.remove(onDismiss);

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
  static void reset() => _stack.clear();
}
