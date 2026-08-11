/// The box and the dot the selection controls share.
library;

import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/utils/color_mix.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The outline a selection indicator is drawn in.
@internal
enum AstryxSelectionIndicatorShape {
  /// A rounded square, for a checkbox.
  square,

  /// A circle, for a radio.
  circle,
}

/// The bordered box that fills when something is selected.
///
/// `AstryxCheckbox`, `AstryxRadioList` and `AstryxSelectableCard` all paint the
/// same thing: a box that takes `--color-accent` when it is on, tinted on hover
/// by upstream's three percentages — 20% on the unselected border, 5% on its
/// fill, 15% on both when selected. One copy is what stops a checkbox inside a
/// card from drifting from a checkbox beside a label.
///
/// The mark inside is the caller's, because it is the one part that differs: a
/// tick, a bar, a dot that grows in, or a spinner.
@internal
class AstryxSelectionIndicator extends StatelessWidget {
  /// Creates an indicator.
  const AstryxSelectionIndicator({
    required this.shape,
    required this.filled,
    required this.extent,
    required this.enabled,
    required this.hovered,
    required this.theme,
    super.key,
    this.child,
  });

  /// Square for a checkbox, circle for a radio.
  final AstryxSelectionIndicatorShape shape;

  /// Whether the box reads as on, which is what fills it.
  ///
  /// Not the same as "checked": an indeterminate checkbox is filled too.
  final bool filled;

  /// The edge length in logical pixels.
  final double extent;

  /// Whether the control accepts input.
  final bool enabled;

  /// Whether hover styling applies.
  ///
  /// The caller decides, because only it knows whether the pointer is over the
  /// row, the card or the box — and whether the density has hover at all.
  final bool hovered;

  /// The resolved theme, passed in rather than read, so a caller building
  /// several indicators in one pass resolves the tokens once.
  final AstryxThemeData theme;

  /// The mark inside the box.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final motion = AstryxMotion.of(context);

    final tint = theme.color(AstryxColorToken.tintHover);
    final accent = theme.color(AstryxColorToken.accent);
    final surface = theme.color(AstryxColorToken.backgroundSurface);
    final borderEmphasized = theme.color(AstryxColorToken.borderEmphasized);

    final Color background;
    final Color border;
    if (!enabled) {
      background = filled
          ? accent
          : theme.color(AstryxColorToken.backgroundMuted);
      border = theme.color(AstryxColorToken.border);
    } else if (filled) {
      background = hovered ? astryxMixColors(accent, tint, 15) : accent;
      border = background;
    } else {
      background = hovered ? astryxMixColors(surface, tint, 5) : surface;
      border = hovered
          ? astryxMixColors(borderEmphasized, tint, 20)
          : borderEmphasized;
    }

    final circle = shape == AstryxSelectionIndicatorShape.circle;

    return Opacity(
      // Upstream dims the whole disabled control rather than recolouring each
      // part, so the same 0.5 lands here.
      opacity: enabled ? 1.0 : 0.5,
      child: AnimatedContainer(
        duration: motion.duration(AstryxDurationToken.fast),
        curve: motion.curve(),
        width: extent,
        height: extent,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle
              ? null
              : theme.borderRadius(AstryxRadiusToken.inner),
          border: Border.all(color: border, width: theme.borderWidth()),
        ),
        child: child,
      ),
    );
  }
}

/// The tick, drawn as a stroked path rather than an icon.
///
/// Upstream ships an inline `<svg viewBox="0 0 10 10">` with the path
/// `M8.5 2.5L4 7.5L1.5 5` — not a Lucide glyph — so this is the same geometry
/// scaled to [extent].
@internal
class AstryxCheckmark extends StatelessWidget {
  /// Creates a checkmark.
  const AstryxCheckmark({required this.color, required this.extent, super.key});

  /// The stroke colour.
  final Color color;

  /// The edge length of the square the path is scaled into.
  final double extent;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(extent),
    painter: _CheckmarkPainter(color: color),
  );
}

class _CheckmarkPainter extends CustomPainter {
  const _CheckmarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 10;
    final path = Path()
      ..moveTo(8.5 * s, 2.5 * s)
      ..lineTo(4 * s, 7.5 * s)
      ..lineTo(1.5 * s, 5 * s);

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      color != oldDelegate.color;
}
