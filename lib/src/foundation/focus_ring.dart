/// The focus indicator.
library;

import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Draws a focus ring around [child] when it holds keyboard focus.
///
/// The ring is painted *outside* the child's bounds, offset by [offset], so it
/// never changes layout or overlaps the control's own border. Widgets pass a
/// shape, not a painted decoration.
///
/// Two conditions must both hold: [focused], and
/// [AstryxFocusVisible.of] — the `:focus-visible` rule, so a mouse click does
/// not raise a ring. See ADR-007.
///
/// {@tool snippet}
/// ```dart
/// AstryxFocusRing(
///   focused: _node.hasFocus,
///   borderRadius: theme.borderRadius(AstryxRadiusToken.element),
///   child: const AstryxButtonSurface(…),
/// )
/// ```
/// {@end-tool}
class AstryxFocusRing extends StatelessWidget {
  /// Creates a focus ring.
  const AstryxFocusRing({
    required this.focused,
    required this.child,
    super.key,
    this.borderRadius,
    this.color,
    this.width,
    this.offset = 2,
    this.enabled = true,
  });

  /// Identifies the painted ring.
  ///
  /// Exposed so a test can distinguish the ring from the decoration of the
  /// control it surrounds, which is otherwise another `DecoratedBox`.
  static const Key ringKey = ValueKey<String>('astryx.focusRing');

  /// Whether the wrapped widget holds focus.
  final bool focused;

  /// The widget the ring surrounds.
  final Widget child;

  /// The ring's shape. Defaults to the child's own corner radius, or square.
  final BorderRadiusGeometry? borderRadius;

  /// The ring's colour. Defaults to `--color-accent`.
  final Color? color;

  /// The ring's thickness. Defaults to `--border-width`, doubled — a
  /// hairline focus indicator fails WCAG 2.4.11's minimum area.
  final double? width;

  /// The gap between the child's bounds and the ring.
  final double offset;

  /// Whether the ring may be drawn at all.
  ///
  /// Set false where a widget paints its own indicator, such as a control whose
  /// focus state is expressed by an inset shadow token.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || !focused || !AstryxFocusVisible.of(context)) return child;

    final theme = AstryxTheme.maybeOf(context);
    final ringColor =
        color ??
        theme?.color(AstryxColorToken.accent) ??
        const Color(0xFF0064E0);
    final ringWidth = width ?? (theme?.borderWidth() ?? 1) * 2;
    final radius = borderRadius ?? BorderRadius.zero;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        // Non-hit-testing and outside the layout, so the ring can never
        // intercept a pointer or shift the control it decorates.
        Positioned(
          top: -offset - ringWidth,
          left: -offset - ringWidth,
          right: -offset - ringWidth,
          bottom: -offset - ringWidth,
          child: IgnorePointer(
            child: DecoratedBox(
              key: ringKey,
              decoration: BoxDecoration(
                borderRadius: radius.add(
                  BorderRadius.circular(offset + ringWidth),
                ),
                border: Border.all(color: ringColor, width: ringWidth),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
