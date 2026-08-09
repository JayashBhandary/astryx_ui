/// The indeterminate activity indicator.
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The spinner sizes.
///
/// Chosen to sit inside a button of the matching size without changing its
/// height — upstream's own diameters and stroke widths.
enum AstryxSpinnerSize {
  /// 10px across, 2px stroke. Inside an `sm` control.
  sm(10, 2),

  /// 14px across, 3px stroke. The default.
  md(14, 3),

  /// 18px across, 3px stroke.
  lg(18, 3);

  const AstryxSpinnerSize(this.diameter, this.strokeWidth);

  /// The overall diameter, in logical pixels.
  final double diameter;

  /// The arc's stroke width.
  final double strokeWidth;
}

/// How prominent a spinner is against its surroundings.
enum AstryxSpinnerShade {
  /// The accent colour. The default.
  accent(AstryxColorToken.accent),

  /// De-emphasised, for a spinner beside secondary text.
  subtle(AstryxColorToken.iconSecondary),

  /// For a spinner on an inverted surface.
  onMedia(AstryxColorToken.onDark),

  /// Take the colour from the enclosing [IconTheme] or [DefaultTextStyle].
  ///
  /// What a button uses, so the spinner matches the label it replaces.
  inherit(null);

  const AstryxSpinnerShade(this.token);

  /// The colour token, or null for [inherit].
  final AstryxColorToken? token;
}

/// An indeterminate activity indicator.
///
/// Under reduced motion the arc stops but does **not** simply freeze: it
/// becomes a full ring, so it still reads as an indicator rather than as a
/// broken graphic, and it is announced through a live region. A spinner that
/// cannot spin still has to communicate "working".
///
/// {@tool snippet}
/// ```dart
/// const AstryxSpinner();
///
/// const AstryxSpinner(size: AstryxSpinnerSize.sm, label: 'Saving');
/// ```
/// {@end-tool}
class AstryxSpinner extends StatefulWidget {
  /// Creates a spinner.
  const AstryxSpinner({
    super.key,
    this.size = AstryxSpinnerSize.md,
    this.shade = AstryxSpinnerShade.accent,
    this.label,
    this.color,
  });

  /// {@template AstryxSpinner.size}
  /// The diameter and stroke width.
  /// {@endtemplate}
  final AstryxSpinnerSize size;

  /// {@template AstryxSpinner.shade}
  /// How prominent the spinner is.
  /// {@endtemplate}
  final AstryxSpinnerShade shade;

  /// {@template AstryxSpinner.label}
  /// What is being waited for, announced to assistive technology.
  ///
  /// Null uses the generic loading string. Set it to null *only* when a
  /// surrounding container already announces the wait — two live regions
  /// competing is worse than one.
  /// {@endtemplate}
  final String? label;

  /// {@template AstryxSpinner.color}
  /// Overrides the colour the [shade] resolves to.
  /// {@endtemplate}
  final Color? color;

  @override
  State<AstryxSpinner> createState() => _AstryxSpinnerState();
}

class _AstryxSpinnerState extends State<AstryxSpinner>
    with SingleTickerProviderStateMixin {
  // Constructed in initState, never `late final`. A lazily-created
  // controller that is only touched by dispose() would be *built* during
  // teardown, and creating a ticker does an inherited lookup — illegal
  // once the element is deactivated.
  late final AnimationController _controller;

  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 730),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller.duration = AstryxTheme.of(
      context,
    ).duration(AstryxDurationToken.slowMin);

    // A loop cannot be expressed by a zero duration, so reduced motion has to
    // stop it outright rather than race it.
    final shouldAnimate = AstryxMotionAccess.animate(context);
    if (shouldAnimate == _animating) return;
    _animating = shouldAnimate;
    if (shouldAnimate) {
      _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    // A leaked repeating controller in a design system is reproduced hundreds
    // of times in a consuming app, so this is not a formality.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final token = widget.shade.token;
    final color =
        widget.color ??
        (token == null
            ? (IconTheme.of(context).color ??
                  DefaultTextStyle.of(context).style.color ??
                  theme.color(AstryxColorToken.accent))
            : theme.color(token));

    final label = widget.label ?? AstryxLocalizations.of(context).buttonLoading;

    return Semantics(
      // A live region, so a reader announces the wait when it starts rather
      // than only if the user happens to navigate onto it.
      liveRegion: true,
      label: label,
      child: SizedBox.square(
        dimension: widget.size.diameter,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _SpinnerPainter(
                color: color,
                strokeWidth: widget.size.strokeWidth,
                turns: _controller.value,
                // A stopped arc reads as a broken graphic; a full ring reads
                // as an indicator that simply is not moving.
                complete: !_animating,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
    required this.turns,
    required this.complete,
  });

  final Color color;
  final double strokeWidth;
  final double turns;
  final bool complete;

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    if (complete) {
      // A dimmed full ring: present and legible, obviously not in motion.
      canvas.drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        Paint()
          ..color = color.withValues(alpha: color.a * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
      return;
    }

    // A three-quarter arc, which is what makes the rotation readable — a full
    // ring rotating looks static.
    canvas.drawArc(
      rect,
      turns * 2 * math.pi,
      1.5 * math.pi,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.turns != turns ||
      oldDelegate.complete != complete;
}
