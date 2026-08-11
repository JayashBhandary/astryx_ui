/// A small coloured dot standing for a state.
library;

import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What a [AstryxStatusDot] means.
enum AstryxStatusDotVariant {
  /// Healthy, online, passing.
  success(AstryxColorToken.success),

  /// Degraded, nearly out, needs attention but is not down.
  warning(AstryxColorToken.warning),

  /// Down, failed, rejected.
  error(AstryxColorToken.error),

  /// In progress, or "this one" — a state the theme's accent describes better
  /// than a status colour does.
  accent(AstryxColorToken.accent),

  /// Off, idle, unknown. Deliberately not grey-as-in-disabled: an unknown state
  /// is a state.
  neutral(AstryxColorToken.iconSecondary);

  const AstryxStatusDotVariant(this.token);

  /// The colour token this variant fills with.
  final AstryxColorToken token;
}

/// An 8px dot that stands for a state.
///
/// {@tool snippet}
/// ```dart
/// AstryxHStack(
///   gap: AstryxSpacingToken.spacing2,
///   children: const <Widget>[
///     AstryxStatusDot(AstryxStatusDotVariant.success, label: 'Online'),
///     AstryxText('api-gateway'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// **Never the only thing that says what the state is.** Upstream's own
/// description of this component is "always paired with text", and that is the
/// whole rule: colour alone excludes anybody who cannot tell green from amber,
/// and a dot is too small to carry a shape as well. [label] keeps the state
/// readable to a screen reader, but a sighted reader who cannot see the hue
/// needs the words on the screen beside it.
///
/// It is not an `AstryxBadge`: a badge carries its own text and can stand
/// alone. Reach for a dot when the text is already there — a table cell, a list
/// row, a header — and a badge when it is not.
class AstryxStatusDot extends StatelessWidget {
  /// Creates a status dot.
  const AstryxStatusDot(
    this.variant, {
    required this.label,
    super.key,
    this.pulsing = false,
    this.tooltip,
  });

  /// What the dot means, and therefore what colour it is.
  final AstryxStatusDotVariant variant;

  /// What the state is, in words.
  ///
  /// Required, and the dot's accessible name — a dot with no name announces as
  /// nothing at all, which is worse than being absent. Where the same words are
  /// already beside it, they will be read twice; that is the right trade, and
  /// `ExcludeSemantics` around the dot is the escape hatch if it grates.
  final String label;

  /// Whether the dot breathes, to say the state is live rather than settled.
  ///
  /// Honours reduced motion: the dot then holds still at full opacity rather
  /// than disappearing, so the state stays legible without the movement.
  final bool pulsing;

  /// Hover text explaining the state.
  ///
  /// Not a substitute for [label] and not a substitute for the words beside the
  /// dot: a third of users have no hover at all.
  final String? tooltip;

  /// The dot's diameter. Fixed, as upstream fixes it.
  static const double extent = 8;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final dot = _Dot(
      colour: theme.color(variant.token),
      pulsing: pulsing,
    );

    final message = tooltip;

    // The name goes on the *outside*, around the tooltip rather than inside it.
    // Nested the other way the tooltip's own node is what a reader meets first,
    // and the dot's name sits on a child of it — which is to say the dot with a
    // tooltip announced as nothing at all.
    return Semantics(
      label: label,
      // Flutter's nearest thing to upstream's `role="img"`: something to be
      // described rather than read or operated.
      image: true,
      child: message == null
          ? dot
          : AstryxTooltip(
              message: message,
              // The label above already says what the state is; announcing the
              // tooltip as well would say it twice.
              excludeFromSemantics: true,
              child: dot,
            ),
    );
  }
}

/// The painted circle, and the pulse.
class _Dot extends StatefulWidget {
  const _Dot({required this.colour, required this.pulsing});

  final Color colour;
  final bool pulsing;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    // Upstream's two seconds, ease-in-out, forever.
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ).drive(Tween<double>(begin: 1, end: 0.5));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(_Dot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing != oldWidget.pulsing) _syncAnimation();
  }

  /// Runs the pulse only while it is both wanted and allowed.
  void _syncAnimation() {
    final reduced = AstryxMotion.of(context).reduced;
    if (widget.pulsing && !reduced) {
      // `repeat(reverse: true)` rather than a three-stop keyframe: 1 → 0.5 → 1
      // is a reversed half-cycle, and the controller can say so itself.
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true, period: const Duration(seconds: 2));
      }
      return;
    }
    _controller
      ..stop()
      // Back to full, not to wherever the fade had reached. A dot left at half
      // opacity reads as a different state.
      ..value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.colour,
        shape: BoxShape.circle,
      ),
      child: const SizedBox.square(dimension: AstryxStatusDot.extent),
    );

    if (!widget.pulsing) return dot;

    return FadeTransition(opacity: _opacity, child: dot);
  }
}
