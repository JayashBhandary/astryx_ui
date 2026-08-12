/// Hints that appear once the user is navigating by keyboard.
library;

import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:flutter/widgets.dart';

/// Shows its child only while the user is navigating by keyboard.
///
/// The Flutter counterpart of upstream's `useKeyboardHint`. A shortcut hint
/// beside every row is noise for somebody using a mouse and the whole point for
/// somebody who is not, so it appears when the last input was a key and steps
/// back when the last input was a pointer.
///
/// Built on the same last-input-device tracking as the focus ring
/// ([AstryxFocusVisible]), so a hint and a ring never disagree about which mode
/// the user is in.
///
/// {@tool snippet}
/// ```dart
/// AstryxItem(
///   label: 'Command palette',
///   trailing: const AstryxKeyboardHint(
///     child: AstryxKbd.hotkey(palette),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// **A hint is a reminder, never the only route.** Whatever the shortcut does
/// must also be reachable by pressing something: this widget hides a *hint*,
/// not a control. Putting a control in here is the keyboard equivalent of
/// hiding one behind hover, and it fails the same people.
class AstryxKeyboardHint extends StatelessWidget {
  /// Creates a keyboard-only hint.
  const AstryxKeyboardHint({
    required this.child,
    super.key,
    this.reserveSpace = true,
    this.otherwise,
    this.excludeFromSemantics = false,
  });

  /// The hint.
  final Widget child;

  /// Whether the hint keeps its space while it is hidden.
  ///
  /// True by default, and worth keeping: a hint that appears on the first
  /// keystroke and pushes a row's contents sideways draws the eye to the wrong
  /// thing at exactly the wrong moment.
  ///
  /// Ignored when [otherwise] is given, since that occupies the space itself.
  final bool reserveSpace;

  /// What to show instead while the user is on a pointer.
  ///
  /// For a slot that has something else worth saying — a timestamp where the
  /// shortcut would be.
  final Widget? otherwise;

  /// Whether to keep the hint out of the semantics tree.
  ///
  /// The hint is usually *the* place a shortcut is written down, so it is
  /// announced by default. Exclude it where the control it belongs to already
  /// names the shortcut and hearing it twice is the greater cost.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final keyboard = AstryxFocusVisible.of(context);

    var hint = child;
    if (excludeFromSemantics) hint = ExcludeSemantics(child: hint);

    if (keyboard) return hint;

    final fallback = otherwise;
    if (fallback != null) return fallback;

    // `maintainSize` keeps the layout still: the hint is not painted, not
    // hit-tested and not announced, but the row does not change shape when the
    // user reaches for the keyboard.
    return Visibility(
      visible: false,
      maintainSize: reserveSpace,
      maintainAnimation: reserveSpace,
      maintainState: reserveSpace,
      child: hint,
    );
  }
}
