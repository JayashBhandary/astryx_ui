/// Page routes with Astryx transitions, and the iOS-style back swipe.
library;

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// How a page enters, and how the page beneath it gets out of the way.
///
/// The Material equivalent is `PageTransitionsTheme`: one setting, resolved
/// per platform unless the app picks one.
enum AstryxPageTransition {
  /// The new page fades in while rising a short way, over a still page.
  ///
  /// The default everywhere except Apple platforms.
  fade,

  /// The new page slides in from the reading-end edge while the page beneath
  /// drifts a third of the way out, and a swipe from the reading-start edge
  /// goes back.
  ///
  /// The default on iOS and macOS, where it is what a user expects.
  slide,

  /// No animation: the new page is simply there.
  none;

  /// The transition [platform]'s users expect.
  static AstryxPageTransition platformDefault(TargetPlatform platform) =>
      switch (platform) {
        TargetPlatform.iOS ||
        TargetPlatform.macOS => AstryxPageTransition.slide,
        _ => AstryxPageTransition.fade,
      };
}

/// Sets the page transition for the [AstryxPageRoute]s beneath it.
///
/// `AstryxApp(pageTransition:)` and `AstryxThemeProvider(pageTransition:)`
/// install one; a route's own `transition:` wins over it.
class AstryxPageTransitionScope extends InheritedWidget {
  /// Creates a page-transition scope.
  const AstryxPageTransitionScope({
    required this.transition,
    required super.child,
    super.key,
  });

  /// The transition, or null to follow the platform.
  final AstryxPageTransition? transition;

  /// The transition in effect at [context].
  ///
  /// The nearest scope's, or the platform default when there is none — the
  /// platform being the theme's, so `AstryxApp(platform:)` previews another
  /// platform's navigation too.
  static AstryxPageTransition of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AstryxPageTransitionScope>()
          ?.transition ??
      AstryxPageTransition.platformDefault(
        AstryxTheme.maybeOf(context)?.platform ?? defaultTargetPlatform,
      );

  @override
  bool updateShouldNotify(AstryxPageTransitionScope oldWidget) =>
      transition != oldWidget.transition;
}

/// A full-screen page with the Astryx transition.
///
/// The Material equivalent is `MaterialPageRoute`, and it is what
/// `AstryxApp` builds for every entry in `routes:` and for `home:`. Push one
/// yourself the same way:
///
/// {@tool snippet}
/// ```dart
/// final saved = await Navigator.of(context).push<bool>(
///   AstryxPageRoute<bool>(builder: (context) => const EditProfilePage()),
/// );
/// ```
/// {@end-tool}
///
/// The page is painted on `--color-background-body`, so a transition never
/// shows the page beneath through a page that forgot its own background.
///
/// The transition is [transition], else the enclosing
/// [AstryxPageTransitionScope]'s, else the platform's. Under reduced motion no
/// transition runs.
class AstryxPageRoute<T> extends PageRoute<T> {
  /// Creates a page route.
  AstryxPageRoute({
    required this.builder,
    super.settings,
    super.requestFocus,
    this.transition,
    this.maintainState = true,
    Duration? transitionDuration,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  }) : _transitionDuration = transitionDuration;

  /// Builds the page.
  final WidgetBuilder builder;

  /// The transition for this route, or null to inherit one.
  final AstryxPageTransition? transition;

  @override
  final bool maintainState;

  final Duration? _transitionDuration;

  /// The length of the push and pop.
  ///
  /// Defaults to `--duration-medium-min` from the theme above the navigator,
  /// and to zero when the platform asks for reduced motion.
  @override
  Duration get transitionDuration {
    if (_transitionDuration != null) return _transitionDuration;
    // Read without a dependency: this is asked once, when the route is
    // installed, outside any build.
    final context = navigator?.context;
    if (context == null) return const Duration(milliseconds: 310);
    final media = context.getInheritedWidgetOfExactType<MediaQuery>()?.data;
    if (media?.disableAnimations ?? false) return Duration.zero;
    final theme = context.getInheritedWidgetOfExactType<AstryxTheme>()?.data;
    return theme?.duration(AstryxDurationToken.mediumMin) ??
        const Duration(milliseconds: 310);
  }

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is PageRoute && !nextRoute.fullscreenDialog;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final theme = AstryxTheme.maybeOf(context);
    final content = _buildContent(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: theme == null
          ? content
          : ColoredBox(
              color: theme.color(AstryxColorToken.backgroundBody),
              child: content,
            ),
    );
  }

  /// The page's content. A page-based route reads its current page here, so
  /// an updated `Navigator.pages` entry shows its new child.
  Widget _buildContent(BuildContext context) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => AstryxPageTransitions.build(
    this,
    context,
    animation,
    secondaryAnimation,
    child,
    transition ?? AstryxPageTransitionScope.of(context),
  );

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

/// A [Page] that builds an [AstryxPageRoute], for `Navigator.pages` and
/// routers such as `go_router`.
///
/// The Material equivalent is `MaterialPage`.
///
/// {@tool snippet}
/// ```dart
/// GoRoute(
///   path: '/settings',
///   pageBuilder: (context, state) =>
///       AstryxPage<void>(key: state.pageKey, child: const SettingsPage()),
/// )
/// ```
/// {@end-tool}
class AstryxPage<T> extends Page<T> {
  /// Creates a page.
  const AstryxPage({
    required this.child,
    this.transition,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    super.key,
    super.canPop,
    super.onPopInvoked,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The page's content.
  final Widget child;

  /// See [AstryxPageRoute.transition].
  final AstryxPageTransition? transition;

  /// See [ModalRoute.maintainState].
  final bool maintainState;

  /// See [PageRoute.fullscreenDialog].
  final bool fullscreenDialog;

  /// See [ModalRoute.allowSnapshotting].
  final bool allowSnapshotting;

  @override
  Route<T> createRoute(BuildContext context) => _PageBasedAstryxPageRoute<T>(
    page: this,
    allowSnapshotting: allowSnapshotting,
  );
}

class _PageBasedAstryxPageRoute<T> extends AstryxPageRoute<T> {
  _PageBasedAstryxPageRoute({
    required AstryxPage<T> page,
    super.allowSnapshotting,
  }) : super(
         settings: page,
         builder: (_) => page.child, // Unused: see _buildContent.
         transition: page.transition,
         fullscreenDialog: page.fullscreenDialog,
       );

  AstryxPage<T> get _page => settings as AstryxPage<T>;

  @override
  bool get maintainState => _page.maintainState;

  @override
  AstryxPageTransition? get transition => _page.transition;

  @override
  Widget _buildContent(BuildContext context) => _page.child;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

/// The transitions themselves, shared by every Astryx page route.
///
/// Public so a custom `PageRoute` — a `PageRouteBuilder`, a router's own page
/// class — can use the same motion:
///
/// {@tool snippet}
/// ```dart
/// PageRouteBuilder<void>(
///   pageBuilder: (context, _, _) => const DetailPage(),
///   transitionsBuilder: (context, animation, secondary, child) =>
///       AstryxPageTransitions.fade(animation, child),
/// )
/// ```
/// {@end-tool}
abstract final class AstryxPageTransitions {
  /// The [AstryxPageTransition.fade] motion for an incoming page.
  ///
  /// It rises an eighth of the way from below, which is enough to say "new
  /// layer" without travelling far enough to read as a sheet.
  static Widget fade(Animation<double> animation, Widget child) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    );
  }

  /// The [AstryxPageTransition.slide] motion: the page in from the
  /// reading-end edge, the page beneath out by a third.
  ///
  /// [linear] drops the easing, for while a finger is driving the animation —
  /// eased motion under a finger feels like the page is slipping.
  static Widget slide(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    required TextDirection textDirection,
    bool linear = false,
  }) {
    Animation<double> curve(Animation<double> parent) => linear
        ? parent
        : CurvedAnimation(
            parent: parent,
            curve: Curves.fastEaseInToSlowEaseOut,
            reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
          );

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1 / 3, 0),
      ).animate(curve(secondaryAnimation)),
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curve(animation)),
        textDirection: textDirection,
        child: DecoratedBox(
          // The edge shadow is what keeps the two pages from reading as one
          // sheet while they overlap.
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: Color(0x1F000000), blurRadius: 16),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  /// The motion for a full-screen dialog: up from the bottom edge, with the
  /// page beneath left where it is.
  static Widget rise(Animation<double> animation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastEaseInToSlowEaseOut,
                reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
              ),
            ),
        child: child,
      );

  /// Builds [route]'s transition for [transition], including the back swipe.
  static Widget build<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    AstryxPageTransition transition,
  ) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;

    if (route.fullscreenDialog) {
      return transition == AstryxPageTransition.none
          ? child
          : rise(animation, child);
    }

    return switch (transition) {
      AstryxPageTransition.none => child,
      AstryxPageTransition.fade => fade(animation, child),
      AstryxPageTransition.slide => _BackSwipeDetector<T>(
        route: route,
        child: slide(
          animation,
          secondaryAnimation,
          child,
          textDirection: Directionality.of(context),
          linear: route.popGestureInProgress,
        ),
      ),
    };
  }
}

/// The strip along the reading-start edge that a swipe back starts from.
class _BackSwipeDetector<T> extends StatefulWidget {
  const _BackSwipeDetector({required this.route, required this.child});

  final PageRoute<T> route;
  final Widget child;

  @override
  State<_BackSwipeDetector<T>> createState() => _BackSwipeDetectorState<T>();
}

class _BackSwipeDetectorState<T> extends State<_BackSwipeDetector<T>> {
  late final HorizontalDragGestureRecognizer _recognizer =
      HorizontalDragGestureRecognizer(debugOwner: this)
        ..onStart = _handleDragStart
        ..onUpdate = _handleDragUpdate
        ..onEnd = _handleDragEnd
        ..onCancel = _handleDragCancel;

  _BackSwipeController? _swipe;

  @override
  void dispose() {
    _recognizer.dispose();
    // A route disposed mid-swipe must still tell the navigator the gesture
    // is over, or every later route thinks a finger is down.
    final navigator = _swipe?.navigator;
    _swipe = null;
    if (navigator != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator.mounted) navigator.didStopUserGesture();
      });
    }
    super.dispose();
  }

  double get _width => context.size!.width;

  /// A drag toward the reading end is positive in both directions.
  double _forward(double value) =>
      Directionality.of(context) == TextDirection.rtl ? -value : value;

  void _handleDragStart(DragStartDetails details) {
    _swipe = _BackSwipeController(widget.route);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _swipe?.update(_forward(details.primaryDelta!) / _width);
  }

  void _handleDragEnd(DragEndDetails details) {
    _swipe?.end(_forward(details.velocity.pixelsPerSecond.dx) / _width);
    _swipe = null;
  }

  void _handleDragCancel() {
    // The arena took the pointer away: settle back where the page was.
    _swipe?.end(0);
    _swipe = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.route.popGestureEnabled) _recognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final edge = math.max<double>(rtl ? padding.right : padding.left, 20);

    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0,
          width: edge,
          top: 0,
          bottom: 0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

/// Drives a route's own animation from a finger, then lets go.
///
/// The same decision Cupertino makes: a fling decides by its direction, a
/// slow release by whether the page is more than half gone.
class _BackSwipeController {
  _BackSwipeController(this.route) : navigator = route.navigator! {
    navigator.didStartUserGesture();
  }

  final PageRoute<dynamic> route;
  final NavigatorState navigator;

  AnimationController get _controller => _RouteControllerAccess.of(route);

  /// Moves the page by [fraction] of its width toward the reading end.
  void update(double fraction) => _controller.value -= fraction;

  /// Releases the page with [velocity] in widths per second.
  void end(double velocity) {
    const curve = Curves.fastLinearToSlowEaseIn;
    final controller = _controller;
    final current = route.isCurrent;

    final bool stay;
    if (!current) {
      stay = route.isActive;
    } else if (velocity.abs() >= 1) {
      stay = velocity <= 0;
    } else {
      stay = controller.value > 0.5;
    }

    if (stay) {
      final ms = math.min(lerpDouble(800, 0, controller.value)!.floor(), 300);
      controller.animateTo(
        1,
        duration: Duration(milliseconds: ms),
        curve: curve,
      );
    } else {
      if (current) navigator.pop();
      if (controller.isAnimating) {
        final ms = lerpDouble(0, 800, controller.value)!.floor();
        controller.animateBack(
          0,
          duration: Duration(milliseconds: ms),
          curve: curve,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener done;
      done = (_) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(done);
      };
      controller.addStatusListener(done);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

/// Reaches a route's animation controller, which `TransitionRoute` keeps
/// protected.
///
/// The back swipe has to drive the controller directly — that is what makes
/// the page follow the finger — and works for any [PageRoute], not only
/// [AstryxPageRoute], so it cannot rely on being a subclass.
abstract final class _RouteControllerAccess {
  static AnimationController of(TransitionRoute<dynamic> route) =>
      // The one protected read in the package, and why this class exists.
      // ignore: invalid_use_of_protected_member
      route.controller!;
}
