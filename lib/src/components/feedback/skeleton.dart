/// Loading placeholders.
library;

import 'dart:async';

import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The shape a skeleton takes.
enum AstryxSkeletonShape {
  /// A rounded rectangle. The default.
  rectangle,

  /// A line of text, sized from the type scale.
  text,

  /// A circle, for an avatar.
  circle,
}

/// A placeholder block shown while content loads.
///
/// Excluded from the semantics tree entirely: a skeleton is not content, and a
/// screen reader announcing a row of empty boxes is noise. If a region needs to
/// announce that it is loading, that belongs on the *container* — one
/// announcement, not one per placeholder.
///
/// Under reduced motion the pulse stops and the block renders at full opacity
/// rather than at the animation's resting 0.25, which would be nearly
/// invisible.
///
/// {@tool snippet}
/// ```dart
/// // Three lines of placeholder text.
/// const AstryxVStack(
///   gap: AstryxSpacingToken.spacing2,
///   children: <Widget>[
///     AstryxSkeleton.text(),
///     AstryxSkeleton.text(),
///     AstryxSkeleton.text(widthFactor: 0.6),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxSkeleton extends StatefulWidget {
  /// Creates a rectangular placeholder.
  const AstryxSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AstryxRadiusToken.inner,
    this.delay = const Duration(milliseconds: 250),
  }) : shape = AstryxSkeletonShape.rectangle,
       widthFactor = null;

  /// Creates a placeholder for a line of text.
  ///
  /// [widthFactor] shortens the line — a paragraph's last line is rarely full
  /// width, and placeholders that are all the same length read as a table.
  const AstryxSkeleton.text({
    super.key,
    this.widthFactor,
    this.height = 14,
    this.delay = const Duration(milliseconds: 250),
  }) : shape = AstryxSkeletonShape.text,
       width = null,
       radius = AstryxRadiusToken.inner;

  /// Creates a circular placeholder, for an avatar.
  const AstryxSkeleton.circle({
    required double size,
    super.key,
    this.delay = const Duration(milliseconds: 250),
  }) : shape = AstryxSkeletonShape.circle,
       width = size,
       height = size,
       widthFactor = null,
       radius = AstryxRadiusToken.full;

  /// The shape.
  final AstryxSkeletonShape shape;

  /// A fixed width. Null fills the available space.
  final double? width;

  /// The fraction of the available width to fill, for [AstryxSkeleton.text].
  final double? widthFactor;

  /// The height.
  final double height;

  /// The corner radius token.
  final AstryxRadiusToken radius;

  /// How long to wait before the pulse begins.
  ///
  /// Content that loads quickly should not flash an animation on its way past.
  /// The block itself is visible immediately; only the pulse is delayed.
  final Duration delay;

  @override
  State<AstryxSkeleton> createState() => _AstryxSkeletonState();
}

class _AstryxSkeletonState extends State<AstryxSkeleton>
    with SingleTickerProviderStateMixin {
  // Constructed in initState, never `late final`. A lazily-created
  // controller that is only touched by dispose() would be *built* during
  // teardown, and creating a ticker does an inherited lookup — illegal
  // once the element is deactivated.
  late final AnimationController _controller;

  bool _animating = false;
  bool _delayElapsed = false;
  Timer? _delayTimer;

  /// Cached in [didChangeDependencies]: the delay timer fires outside the
  /// build phase, where an inherited lookup is not safe.
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    if (widget.delay == Duration.zero) {
      _delayElapsed = true;
      return;
    }
    // A cancellable Timer, not `Future.delayed`: a pending future cannot be
    // called off, so a skeleton disposed inside the delay window would leave a
    // timer alive — the same leak as an undisposed controller, and one the
    // test framework rightly refuses to ignore.
    _delayTimer = Timer(widget.delay, () {
      if (!mounted) return;
      setState(() => _delayElapsed = true);
      _syncAnimation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = AstryxTheme.of(
      context,
    ).duration(AstryxDurationToken.mediumMax);
    _reducedMotion = !AstryxMotionAccess.animate(context);
    _syncAnimation();
  }

  void _syncAnimation() {
    final shouldAnimate = _delayElapsed && !_reducedMotion;
    if (shouldAnimate == _animating) return;
    _animating = shouldAnimate;
    if (shouldAnimate) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    Widget block = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.skeleton),
        borderRadius: theme.borderRadius(widget.radius),
      ),
      child: SizedBox(width: widget.width, height: widget.height),
    );

    if (widget.shape == AstryxSkeletonShape.text &&
        widget.widthFactor != null) {
      block = FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: widget.widthFactor,
        child: block,
      );
    }

    // Excluded, not merely unlabelled: an unlabelled node still shows up in
    // the reading order as an anonymous element.
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Opacity(
            // Resting at 1 when stopped, so a static placeholder stays
            // perceivable; the animation's own floor of 0.25 would be nearly
            // invisible against a muted surface.
            opacity: _animating ? 0.25 + 0.75 * _controller.value : 1,
            child: child,
          ),
          child: block,
        ),
      ),
    );
  }
}
