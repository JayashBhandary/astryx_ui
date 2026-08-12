/// Entering, and entering when scrolled to.
library;

import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How something enters.
enum AstryxEntryTransition {
  /// Fades in. The safe default: nothing moves, so nothing can be read as a
  /// layout shift.
  fade,

  /// Fades in and rises a little.
  ///
  /// The rise is what says "this is new" rather than "this was always here",
  /// which a fade alone cannot.
  fadeUp,

  /// Fades in and scales up from 96%.
  ///
  /// For something that appeared *at* a point — a card that was just created, a
  /// panel with a source.
  fadeScale,
}

/// Animates its child in once, the first time it is built.
///
/// The Flutter counterpart of upstream's `useEntryAnimation`. Two things a
/// hand-rolled `AnimationController` in a `StatefulWidget` routinely gets
/// wrong, and this does not: the duration and easing come from **tokens**, and
/// reduced motion means not animating rather than animating quickly.
///
/// {@tool snippet}
/// ```dart
/// AstryxEntryAnimation(
///   transition: AstryxEntryTransition.fadeUp,
///   child: AstryxCard(child: summary),
/// )
/// ```
/// {@end-tool}
///
/// It runs **once per element**. To replay it — a list that re-animates when
/// its filter changes — give it a `key` that changes with the content, which is
/// what tells Flutter this is a new element rather than the old one updated.
class AstryxEntryAnimation extends StatefulWidget {
  /// Creates an entry animation.
  const AstryxEntryAnimation({
    required this.child,
    super.key,
    this.transition = AstryxEntryTransition.fade,
    this.duration = AstryxDurationToken.mediumMin,
    this.ease = AstryxEaseToken.standard,
    this.delay = Duration.zero,
    this.offset = 8,
    this.enabled = true,
  });

  /// The content that enters.
  final Widget child;

  /// How it enters.
  final AstryxEntryTransition transition;

  /// How long the entry takes.
  final AstryxDurationToken duration;

  /// The easing curve.
  final AstryxEaseToken ease;

  /// How long to wait before starting.
  ///
  /// For staggering a list — `Duration(milliseconds: 40 * index)`. Keep the
  /// total under about a quarter of a second: a stagger a user has to wait out
  /// is an animation that has become a loading state.
  final Duration delay;

  /// How far [AstryxEntryTransition.fadeUp] rises, in logical pixels.
  final double offset;

  /// Whether to animate at all.
  ///
  /// False renders the child outright — for a rebuild where the entry has
  /// already been paid for, or a screen restoring saved state.
  final bool enabled;

  @override
  State<AstryxEntryAnimation> createState() => _AstryxEntryAnimationState();
}

class _AstryxEntryAnimationState extends State<AstryxEntryAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    // A real duration is set from the theme in `didChangeDependencies`, the
    // first place a token can be resolved.
    duration: const Duration(milliseconds: 200),
  );

  bool _started = false;

  @override
  void initState() {
    super.initState();
    // Rebuilt on completion so `build` can drop the transition widgets. The
    // animation drives itself without rebuilding, so without this the opacity
    // layer outlives the animation it was for.
    _controller.addStatusListener(_handleStatus);
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final motion = AstryxMotion.of(context);
    _controller.duration = motion.duration(widget.duration);

    if (_started) return;
    _started = true;

    // Reduced motion, or animation turned off: the child is simply there. Not a
    // fast animation — the setting exists for people whom motion makes unwell.
    if (!widget.enabled || !motion.animate) {
      _controller.value = 1;
      return;
    }

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = AstryxMotion.of(context);

    if (_controller.isCompleted && !_controller.isAnimating) {
      // Nothing left to animate: drop the transition widgets rather than
      // leaving an opacity layer on every card for the rest of the session.
      return widget.child;
    }

    final curved = CurvedAnimation(
      parent: _controller,
      curve: motion.curve(widget.ease),
    );

    final faded = FadeTransition(opacity: curved, child: widget.child);

    return switch (widget.transition) {
      AstryxEntryTransition.fade => faded,
      AstryxEntryTransition.fadeScale => ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
        child: faded,
      ),
      AstryxEntryTransition.fadeUp => AnimatedBuilder(
        animation: curved,
        // A pixel offset rather than a `SlideTransition` fraction: a fixed rise
        // reads the same on a 40px row and a 400px panel, and a fraction does
        // not.
        builder: (context, child) => Transform.translate(
          offset: Offset(0, widget.offset * (1 - curved.value)),
          child: child,
        ),
        child: faded,
      ),
    };
  }
}

/// Runs an entry animation the first time its child is scrolled into view.
///
/// The Flutter counterpart of upstream's `useContainerReveal`. Flutter has no
/// `IntersectionObserver`, so this watches the enclosing [Scrollable]'s
/// position and compares its own bounds against the viewport's.
///
/// {@tool snippet}
/// ```dart
/// AstryxContainerReveal(
///   transition: AstryxEntryTransition.fadeUp,
///   child: AstryxCard(child: chart),
/// )
/// ```
/// {@end-tool}
///
/// **With no enclosing scrollable it reveals immediately.** There is nothing to
/// wait for, and content that never appears because a widget was looking for a
/// viewport that does not exist is the worse failure by a wide margin.
class AstryxContainerReveal extends StatefulWidget {
  /// Creates a scroll-triggered reveal.
  const AstryxContainerReveal({
    required this.child,
    super.key,
    this.transition = AstryxEntryTransition.fadeUp,
    this.duration = AstryxDurationToken.mediumMin,
    this.ease = AstryxEaseToken.standard,
    this.fraction = 0.1,
    this.offset = 8,
    this.enabled = true,
    this.onRevealed,
  });

  /// The content that is revealed.
  final Widget child;

  /// How it enters once it is in view.
  final AstryxEntryTransition transition;

  /// How long the entry takes.
  final AstryxDurationToken duration;

  /// The easing curve.
  final AstryxEaseToken ease;

  /// How much of the child has to be in view before it reveals, 0 to 1.
  ///
  /// A tenth by default: enough that a reveal fires as something starts to
  /// appear rather than once it is already read.
  final double fraction;

  /// How far [AstryxEntryTransition.fadeUp] rises, in logical pixels.
  final double offset;

  /// Whether to wait at all. False reveals on the first frame.
  final bool enabled;

  /// Called once, when the child is first revealed.
  final VoidCallback? onRevealed;

  @override
  State<AstryxContainerReveal> createState() => _AstryxContainerRevealState();
}

class _AstryxContainerRevealState extends State<AstryxContainerReveal> {
  ScrollPosition? _position;
  bool _revealed = false;
  bool _checkScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_scheduleCheck);
      _position = position;
      _position?.addListener(_scheduleCheck);
    }

    // Nothing to wait for: no scrollable, or waiting turned off.
    if (!widget.enabled || _position == null) {
      _reveal();
      return;
    }
    _scheduleCheck();
  }

  @override
  void dispose() {
    _position?.removeListener(_scheduleCheck);
    super.dispose();
  }

  /// Measures after the frame, not during it.
  ///
  /// A scroll position notifies its listeners *before* the frame that moves
  /// anything, so `localToGlobal` inside the callback returns the previous
  /// frame's geometry — which is how a reveal ends up measuring a position the
  /// child has already left. One coalesced post-frame check per frame instead.
  void _scheduleCheck() {
    if (_revealed || _checkScheduled) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _check();
    });
  }

  void _check() {
    if (_revealed || !mounted) return;

    final box = context.findRenderObject() as RenderBox?;
    final viewport =
        _position?.context.storageContext.findRenderObject() as RenderBox?;
    if (box == null || viewport == null || !box.hasSize || !viewport.hasSize) {
      return;
    }

    final self = box.localToGlobal(Offset.zero) & box.size;
    final port = viewport.localToGlobal(Offset.zero) & viewport.size;
    final overlap = self.intersect(port);
    if (overlap.isEmpty) return;

    // A fraction of the child's own area, so the threshold means the same thing
    // for a tall panel and a short row.
    final area = self.width * self.height;
    if (area <= 0) return;
    final visible = (overlap.width * overlap.height) / area;

    if (visible >= widget.fraction) _reveal();
  }

  void _reveal() {
    if (_revealed) return;
    _revealed = true;
    // Listening stops the moment it has fired: this runs once, and a listener
    // that outlives its purpose is a scroll that rebuilds for nothing.
    _position?.removeListener(_scheduleCheck);
    if (mounted) setState(() {});
    widget.onRevealed?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_revealed) {
      // Laid out but not painted, so the scroll extent is correct from the
      // start: a reveal that changes the page height as it fires moves
      // everything below it, including the thing the reader was looking at.
      return Opacity(opacity: 0, child: widget.child);
    }

    return AstryxEntryAnimation(
      transition: widget.transition,
      duration: widget.duration,
      ease: widget.ease,
      offset: widget.offset,
      child: widget.child,
    );
  }
}
