/// Determinate and indeterminate progress.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What the fill colour means.
enum AstryxProgressVariant {
  /// Neutral progress. The default.
  accent(AstryxColorToken.accent),

  /// A successful outcome.
  success(AstryxColorToken.success),

  /// A caution.
  warning(AstryxColorToken.warning),

  /// A failure.
  error(AstryxColorToken.error),

  /// De-emphasised.
  neutral(AstryxColorToken.iconSecondary);

  const AstryxProgressVariant(this.token);

  /// The fill colour token.
  final AstryxColorToken token;
}

/// A horizontal progress indicator.
///
/// Determinate when [value] is given, indeterminate otherwise. The fill grows
/// from the reading start, so it runs right-to-left under RTL without the
/// caller doing anything.
///
/// {@tool snippet}
/// ```dart
/// AstryxProgressBar(label: 'Uploading', value: 0.4);
///
/// const AstryxProgressBar(label: 'Loading');   // indeterminate
/// ```
/// {@end-tool}
class AstryxProgressBar extends StatefulWidget {
  /// Creates a progress bar.
  const AstryxProgressBar({
    required this.label,
    super.key,
    this.value,
    this.variant = AstryxProgressVariant.accent,
    this.showLabel = true,
    this.showValueLabel = false,
    this.formatValue,
    this.enabled = true,
  }) : assert(
         value == null || (value >= 0 && value <= 1),
         'value must be between 0 and 1',
       );

  /// {@template AstryxProgressBar.label}
  /// What is progressing.
  ///
  /// Always the accessible name, whether or not it is shown.
  /// {@endtemplate}
  final String label;

  /// {@template AstryxProgressBar.value}
  /// Progress from 0 to 1, or null for indeterminate.
  ///
  /// A fraction rather than upstream's `value`/`max` pair: two numbers that
  /// must agree is a bug waiting to happen, and the caller already knows how
  /// to divide.
  /// {@endtemplate}
  final double? value;

  /// {@template AstryxProgressBar.variant}
  /// What the fill colour means.
  /// {@endtemplate}
  final AstryxProgressVariant variant;

  /// {@template AstryxProgressBar.showLabel}
  /// Whether to render [label] above the track.
  ///
  /// False hides it visually; it still names the bar for assistive technology.
  /// {@endtemplate}
  final bool showLabel;

  /// {@template AstryxProgressBar.showValueLabel}
  /// Whether to render the percentage beside the label.
  /// {@endtemplate}
  final bool showValueLabel;

  /// {@template AstryxProgressBar.formatValue}
  /// Formats the value label. Defaults to a whole percentage.
  /// {@endtemplate}
  final String Function(double value)? formatValue;

  /// {@template AstryxProgressBar.enabled}
  /// Whether the bar reads as active.
  /// {@endtemplate}
  final bool enabled;

  @override
  State<AstryxProgressBar> createState() => _AstryxProgressBarState();
}

class _AstryxProgressBarState extends State<AstryxProgressBar>
    with SingleTickerProviderStateMixin {
  // Constructed in initState, never `late final`. A lazily-created
  // controller that is only touched by dispose() would be *built* during
  // teardown, and creating a ticker does an inherited lookup — illegal
  // once the element is deactivated.
  late final AnimationController _controller;

  bool _animating = false;

  /// Cached in [didChangeDependencies] rather than read on demand.
  ///
  /// An inherited lookup is only legal while the element is active, and
  /// `didUpdateWidget` can run when it is not. Caching is the pattern
  /// Flutter's own error message recommends.
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = !AstryxMotionAccess.animate(context);
    _syncAnimation();
  }

  @override
  void didUpdateWidget(AstryxProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final shouldAnimate = widget.value == null && !_reducedMotion;
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
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) =>
      widget.formatValue?.call(value) ?? '${(value * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final value = widget.value;

    final fill = theme.color(
      widget.enabled ? widget.variant.token : AstryxColorToken.iconDisabled,
    );

    final track = ClipRRect(
      borderRadius: theme.borderRadius(AstryxRadiusToken.full),
      child: SizedBox(
        height: 8,
        child: ColoredBox(
          color: theme.color(AstryxColorToken.track),
          child: value == null
              ? _IndeterminateFill(controller: _controller, color: fill)
              : _DeterminateFill(
                  value: value,
                  color: fill,
                  duration: motion.duration(AstryxDurationToken.medium),
                  curve: motion.curve(),
                ),
        ),
      ),
    );

    return Semantics(
      container: true,
      label: widget.label,
      // A percentage string, not `value`/`increasedValue`: those describe an
      // *adjustable* control, and a progress bar is read-only. A reader
      // offering to increase it would be wrong.
      value: value == null ? null : _formatValue(value),
      // Only determinate progress is worth announcing as it changes; an
      // indeterminate bar would announce nothing new, repeatedly.
      liveRegion: value != null,
      enabled: widget.enabled,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing(AstryxSpacingToken.spacing1),
          children: <Widget>[
            if (widget.showLabel || widget.showValueLabel)
              Row(
                children: <Widget>[
                  if (widget.showLabel)
                    Expanded(
                      child: AstryxText(
                        widget.label,
                        type: AstryxTextType.supporting,
                        color: widget.enabled
                            ? AstryxTextColor.secondary
                            : AstryxTextColor.disabled,
                      ),
                    )
                  else
                    const Spacer(),
                  if (widget.showValueLabel && value != null)
                    AstryxText(
                      _formatValue(value),
                      type: AstryxTextType.supporting,
                      color: widget.enabled
                          ? AstryxTextColor.secondary
                          : AstryxTextColor.disabled,
                    ),
                ],
              ),
            track,
          ],
        ),
      ),
    );
  }
}

/// The fill for a known amount of progress.
class _DeterminateFill extends StatelessWidget {
  const _DeterminateFill({
    required this.value,
    required this.color,
    required this.duration,
    required this.curve,
  });

  final double value;
  final Color color;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) => Align(
    // Directional, so the fill grows from the reading edge and the bar runs
    // right-to-left under RTL with no caller involvement.
    alignment: AlignmentDirectional.centerStart,
    child: TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animated, _) => FractionallySizedBox(
        widthFactor: animated.clamp(0.0, 1.0),
        // `heightFactor` is not optional: without it the box's height
        // constraint stays loose and a childless `ColoredBox` collapses to
        // zero, so the fill paints nothing at all.
        heightFactor: 1,
        child: ColoredBox(color: color),
      ),
    ),
  );
}

/// The sliding fill for an unknown amount of progress.
class _IndeterminateFill extends StatelessWidget {
  const _IndeterminateFill({required this.controller, required this.color});

  final AnimationController controller;
  final Color color;

  /// The fraction of the track the moving fill occupies.
  static const double _extent = 0.4;

  /// The [Alignment] x that puts the fill just off the reading start.
  ///
  /// `Align` places a child at `(x + 1) / 2 * (parent - child)`. With a child
  /// of `_extent` the fill is flush at x = ±1, so sliding it *fully* off each
  /// end needs a value beyond that range — which `Alignment` allows.
  static const double _offStart = 2 * -_extent / (1 - _extent) - 1;
  static const double _offEnd = 2 / (1 - _extent) - 1;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      final t = Curves.easeInOut.transform(controller.value);
      final x = _offStart + (_offEnd - _offStart) * t;

      return Align(
        // Directional, so the fill travels along the reading direction —
        // left-to-right in LTR, right-to-left in RTL.
        alignment: AlignmentDirectional(x, 0),
        child: child,
      );
    },
    child: FractionallySizedBox(
      widthFactor: _extent,
      // See the note in _DeterminateFill: without heightFactor the fill has
      // no height and paints nothing.
      heightFactor: 1,
      child: ColoredBox(color: color),
    ),
  );
}
