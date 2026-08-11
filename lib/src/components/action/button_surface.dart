/// The interactive core shared by the button family.
///
/// Everything a pressable Astryx control has to get right — states, focus,
/// keyboard activation, press feedback, tap targets, cursors — lives here once.
/// `AstryxButton` and `AstryxIconButton` supply only their content and shape.
///
/// This is the reference for every interactive widget in Phases 7–10. The
/// composition order in particular is load-bearing; see the note on `build`.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/states_controller.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// A pressable, focusable surface with Astryx's interaction behaviour.
@internal
class AstryxButtonSurface extends StatefulWidget {
  /// Creates a button surface.
  const AstryxButtonSurface({
    required this.style,
    required this.child,
    required this.semanticsLabel,
    super.key,
    this.onPressed,
    this.enabled = true,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.squared = false,
    this.excludeChildSemantics = false,
    this.selected,
  });

  /// The resolved visual values.
  final ResolvedButtonStyle style;

  /// The button's content, already laid out.
  final Widget child;

  /// The accessible name.
  final String? semanticsLabel;

  /// The action, or null for a button that cannot be pressed.
  final VoidCallback? onPressed;

  /// Whether the button accepts interaction.
  ///
  /// Distinct from a null [onPressed]: a loading button is *enabled: false*
  /// while its callback still exists.
  final bool enabled;

  /// A fixed width. Null lets the content decide.
  final double? width;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Whether the button is square, sized from its height.
  final bool squared;

  /// Whether to hide the child's own semantics.
  final bool excludeChildSemantics;

  /// Whether the button is in a sticky on state — `AstryxToggleButton`.
  ///
  /// Null for a button that has no such state, which is every plain action:
  /// the flag is absent from the node rather than present and false, so a
  /// screen reader does not announce "not selected" about a Save button.
  ///
  /// Upstream spells this `aria-pressed`. Flutter has no equivalent — its
  /// `toggled` flag is the switch's on/off — so `selected` carries it, which is
  /// what `SegmentedButton` does in the framework's own widgets.
  final bool? selected;

  @override
  State<AstryxButtonSurface> createState() => _AstryxButtonSurfaceState();
}

class _AstryxButtonSurfaceState extends State<AstryxButtonSurface> {
  late final AstryxStatesController _states = AstryxStatesController();
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _interactive => widget.enabled && widget.onPressed != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Density can change under us — a window moved to a touch screen, or a
    // test switching it. Keeping the controller in step is what stops a stale
    // hover surviving the change.
    _states.density = AstryxTheme.densityOf(context);
  }

  @override
  void didUpdateWidget(AstryxButtonSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) {
      _states
        ..pressed = false
        ..hovered = false;
    }
  }

  @override
  void dispose() {
    _states.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_interactive) return;
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final motion = AstryxMotion.of(context);
    final duration = motion.duration(AstryxDurationToken.fastMin);
    final curve = motion.curve();

    return Semantics(
      container: true,
      button: true,
      label: widget.semanticsLabel,
      enabled: _interactive,
      focusable: _interactive,
      selected: widget.selected,
      // The action an assistive technology invokes. A screen reader activates
      // through this, not by synthesising a tap, so it must be wired even
      // though the GestureDetector below also handles presses.
      onTap: _interactive ? _handleTap : null,
      excludeSemantics: widget.excludeChildSemantics,
      // Semantics wraps the tap target, never the reverse — nested the other
      // way the node keeps the painted bounds and every audit sees the small
      // target however large the hit region is. ADR-020.
      child: AstryxTapTarget(
        // `Shortcuts` and `Actions` sit *above* `Focus`, not below it. A key
        // event is dispatched to the focused node and then bubbles up its
        // ancestors, so a `Shortcuts` beneath the `Focus` is never consulted —
        // the button would look wired and silently ignore Enter and Space.
        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _handleTap();
                  return null;
                },
              ),
            },
            child: Focus(
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              canRequestFocus: _interactive,
              onFocusChange: (focused) => _states.focused = focused,
              child: ListenableBuilder(
                listenable: _states,
                builder: (context, _) => AstryxFocusRing(
                  focused: _states.focused,
                  borderRadius: style.borderRadius,
                  child: MouseRegion(
                    cursor: _interactive
                        ? style.mouseCursor
                        : style.disabledMouseCursor,
                    onEnter: (_) => _states.hovered = true,
                    onExit: (_) => _states.hovered = false,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: _interactive
                          ? (_) => _states.pressed = true
                          : null,
                      onTapUp: _interactive
                          ? (_) => _states.pressed = false
                          : null,
                      onTapCancel: _interactive
                          ? () => _states.pressed = false
                          : null,
                      onTap: _interactive ? _handleTap : null,
                      child: AnimatedScale(
                        // Upstream's `transform: scale(0.98)` on `:active`.
                        scale: _states.pressed ? style.pressedScale : 1.0,
                        duration: duration,
                        curve: curve,
                        child: AnimatedOpacity(
                          opacity: widget.enabled ? 1.0 : style.disabledOpacity,
                          duration: duration,
                          curve: curve,
                          // The size is fixed, not animated. Only the
                          // state-driven properties belong in the
                          // AnimatedContainer — animating the height would
                          // make a size change tween, and every measurement
                          // in the first frame report the old value.
                          child: SizedBox(
                            height: style.height,
                            width: widget.squared ? style.height : widget.width,
                            child: AnimatedContainer(
                              duration: duration,
                              curve: curve,
                              decoration: BoxDecoration(
                                color: style.backgroundFor(
                                  hovered: _states.hovered,
                                  pressed: _states.pressed,
                                ),
                                borderRadius: style.borderRadius,
                                border: style.border == null
                                    ? null
                                    : Border.fromBorderSide(style.border!),
                                boxShadow: <BoxShadow>[
                                  for (final shadow in style.shadows)
                                    if (!shadow.inset) shadow.toBoxShadow(),
                                ],
                              ),
                              padding: style.padding,
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
