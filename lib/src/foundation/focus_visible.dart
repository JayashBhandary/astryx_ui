/// The `:focus-visible` port — last-input-device tracking.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// How the user most recently interacted.
enum AstryxInputDevice {
  /// A keyboard, or an assistive technology driving one.
  keyboard,

  /// A mouse, trackpad, stylus or finger.
  pointer,
}

/// Tracks the last input device for the whole app.
///
/// Astryx draws focus rings with `:focus-visible`, which browsers show for
/// keyboard focus and hide for a mouse click. Flutter's `Focus` reports focus
/// identically however it was acquired, so a naive port draws a keyboard focus
/// ring on every mouse click — which reads as a bug. See ADR-007.
///
/// This watches raw pointer and key events at the root and exposes the answer
/// through an [InheritedWidget]. `AstryxThemeProvider` installs it, so both
/// entry points get it.
///
/// {@tool snippet}
/// ```dart
/// // Draw a ring only when focus should be visible.
/// if (hasFocus && AstryxFocusVisible.of(context)) const AstryxFocusRing(…)
/// ```
/// {@end-tool}
class AstryxFocusVisibleScope extends StatefulWidget {
  /// Creates a focus-visible scope.
  const AstryxFocusVisibleScope({required this.child, super.key});

  /// The widget below this in the tree.
  final Widget child;

  @override
  State<AstryxFocusVisibleScope> createState() =>
      _AstryxFocusVisibleScopeState();
}

class _AstryxFocusVisibleScopeState extends State<AstryxFocusVisibleScope> {
  // Keyboard, so the first focus of a session — which a keyboard user reaches
  // by tabbing — is visible. A spurious ring is a cosmetic issue; a missing one
  // is an accessibility failure.
  AstryxInputDevice _lastDevice = AstryxInputDevice.keyboard;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) _setDevice(AstryxInputDevice.keyboard);
    // Never claim the event — this only observes.
    return false;
  }

  void _onPointer(PointerEvent event) {
    // Hover and scroll do not move focus, so they must not suppress a ring the
    // keyboard just earned. Only a press does.
    if (event is PointerDownEvent) _setDevice(AstryxInputDevice.pointer);
  }

  void _setDevice(AstryxInputDevice device) {
    if (_lastDevice == device) return;
    setState(() => _lastDevice = device);
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: _onPointer,
    // Translucent, not the default `deferToChild`: a press on empty space is
    // still pointer input and must still suppress the ring. Deferring would
    // only see presses that landed on a hit-testable descendant.
    behavior: HitTestBehavior.translucent,
    child: AstryxFocusVisible(
      lastInputDevice: _lastDevice,
      child: widget.child,
    ),
  );
}

/// Exposes whether focus should currently be drawn.
class AstryxFocusVisible extends InheritedWidget {
  /// Creates a focus-visible scope value.
  const AstryxFocusVisible({
    required this.lastInputDevice,
    required super.child,
    super.key,
  });

  /// The device the user most recently used.
  final AstryxInputDevice lastInputDevice;

  /// Whether a focus ring should be drawn for a focused widget.
  bool get isVisible => lastInputDevice == AstryxInputDevice.keyboard;

  /// Whether focus should be visible at [context].
  ///
  /// Returns **true** when no scope is installed. A missing scope must fail
  /// toward showing the ring: an invisible focus indicator is an accessibility
  /// failure, a spurious one is cosmetic.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AstryxFocusVisible>()
          ?.isVisible ??
      true;

  /// The last input device at [context], or null if no scope is installed.
  static AstryxInputDevice? maybeDeviceOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AstryxFocusVisible>()
      ?.lastInputDevice;

  @override
  bool updateShouldNotify(AstryxFocusVisible oldWidget) =>
      lastInputDevice != oldWidget.lastInputDevice;
}
