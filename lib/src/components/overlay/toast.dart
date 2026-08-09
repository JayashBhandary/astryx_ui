/// Transient notifications, and the host that stacks them.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/engine/engine.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The two kinds of toast upstream ships.
enum AstryxToastType {
  /// The default. An inverted surface.
  neutral(AstryxColorToken.backgroundInverted),

  /// Something went wrong. An inverted error surface.
  error(AstryxColorToken.backgroundErrorInverted);

  const AstryxToastType(this.background);

  /// The fill token.
  final AstryxColorToken background;
}

/// Where toasts stack.
enum AstryxToastPosition {
  /// Bottom trailing corner. The pointer default.
  bottomEnd,

  /// Bottom leading corner.
  bottomStart,

  /// Top trailing corner.
  topEnd,

  /// Top leading corner.
  topStart;

  /// Whether new toasts appear at the bottom of the screen.
  bool get isBottom =>
      this == AstryxToastPosition.bottomEnd ||
      this == AstryxToastPosition.bottomStart;

  /// Whether the stack hugs the trailing edge.
  bool get isEnd =>
      this == AstryxToastPosition.bottomEnd ||
      this == AstryxToastPosition.topEnd;

  /// The default for [density].
  ///
  /// **Bottom-centre-ish on touch, corner on pointer.** A toast in the top
  /// corner of a phone is under the status bar and out of thumb reach; a toast
  /// across the bottom of a desktop window is in the way.
  static AstryxToastPosition defaultFor(AstryxDensity density) =>
      density == AstryxDensity.touch
      ? AstryxToastPosition.bottomStart
      : AstryxToastPosition.bottomEnd;
}

/// One queued notification.
@immutable
class AstryxToast {
  /// Creates a toast.
  const AstryxToast({
    required this.message,
    this.type = AstryxToastType.neutral,
    this.action,
    this.duration = const Duration(seconds: 5),
    this.dismissible = true,
  });

  /// What to tell the user.
  final String message;

  /// Which surface to use.
  final AstryxToastType type;

  /// An optional action — "Undo", "Retry".
  final Widget? action;

  /// How long it stays. [Duration.zero] keeps it until dismissed.
  final Duration duration;

  /// Whether to show a dismiss button.
  final bool dismissible;
}

/// Shows and dismisses toasts.
///
/// Reached through [AstryxToastScope.of]; installed by `AstryxThemeProvider`,
/// so toasts work with no extra setup.
///
/// {@tool snippet}
/// ```dart
/// AstryxToastScope.of(context).show(
///   const AstryxToast(message: 'Project archived'),
/// );
/// ```
/// {@end-tool}
class AstryxToastController extends ChangeNotifier {
  /// Creates a toast controller.
  AstryxToastController({this.maxVisible = 5});

  /// How many toasts are shown at once. Older ones wait their turn.
  final int maxVisible;

  final List<_ToastEntry> _entries = <_ToastEntry>[];

  /// The toasts currently on screen, oldest first.
  List<AstryxToast> get visible => <AstryxToast>[
    for (final entry in _entries.take(maxVisible)) entry.toast,
  ];

  /// Queues [toast] and returns a handle that dismisses it.
  VoidCallback show(AstryxToast toast) {
    final entry = _ToastEntry(toast);
    _entries.add(entry);
    notifyListeners();
    return () => dismiss(entry);
  }

  /// Removes [entry], if it is still queued.
  void dismiss(Object entry) {
    if (entry is! _ToastEntry) return;
    if (_entries.remove(entry)) notifyListeners();
  }

  /// Removes everything.
  void clear() {
    if (_entries.isEmpty) return;
    _entries.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _entries.clear();
    super.dispose();
  }
}

/// A queued toast and its identity.
class _ToastEntry {
  _ToastEntry(this.toast);

  final AstryxToast toast;
}

/// Publishes an [AstryxToastController] to the widgets beneath it.
class AstryxToastScope extends InheritedNotifier<AstryxToastController> {
  /// Creates a toast scope.
  const AstryxToastScope({
    required AstryxToastController super.notifier,
    required super.child,
    super.key,
  });

  /// The controller at [context].
  ///
  /// Throws if there is none, because a caller reaching for this has already
  /// decided to show a toast and a silent no-op would be worse than the error.
  static AstryxToastController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No AstryxToastScope found. Wrap the app in an AstryxThemeProvider, '
      'which installs one.',
    );
    return controller!;
  }

  /// The controller at [context], or null outside a scope.
  static AstryxToastController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxToastScope>()?.notifier;
}

/// Renders the toast stack.
///
/// Installed by `AstryxThemeProvider` above the app's content. Uses an
/// `Overlay`-free `Stack` so it works in the same tree as the provider without
/// needing a navigator.
class AstryxToastHost extends StatelessWidget {
  /// Creates a toast host.
  const AstryxToastHost({
    required this.controller,
    required this.child,
    super.key,
    this.position,
  });

  /// The controller whose toasts are rendered.
  final AstryxToastController controller;

  /// The app content the toasts float over.
  final Widget child;

  /// Where the stack sits. Defaults to [AstryxToastPosition.defaultFor].
  final AstryxToastPosition? position;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final toasts = controller.visible;
      // Nothing showing, nothing mounted. Not just an optimisation: the
      // provider installs this host unconditionally, including in trees with
      // no `Directionality` above it, and a directional `Align` would throw
      // there for a stack that has nothing in it.
      if (toasts.isEmpty) return child;

      final theme = AstryxTheme.of(context);
      final l10n = AstryxLocalizations.of(context);
      final resolved =
          position ??
          AstryxToastPosition.defaultFor(
            AstryxTheme.densityOf(context),
          );

      return Stack(
        // Explicit and non-directional: the app content below is already
        // laid out, and the stack itself has no reading order.
        alignment: Alignment.topLeft,
        children: <Widget>[
          child,
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(
                  theme.spacing(AstryxSpacingToken.spacing4),
                ),
                child: Align(
                  alignment: switch (resolved) {
                    AstryxToastPosition.bottomEnd =>
                      AlignmentDirectional.bottomEnd,
                    AstryxToastPosition.bottomStart =>
                      AlignmentDirectional.bottomStart,
                    AstryxToastPosition.topEnd => AlignmentDirectional.topEnd,
                    AstryxToastPosition.topStart =>
                      AlignmentDirectional.topStart,
                  },
                  // The stack scrolls when it is taller than the space it has.
                  // Five toasts on a landscape phone is a real case, and the
                  // alternative is pushing the oldest off-screen where it can
                  // neither be read nor dismissed (ADR-042).
                  child: SingleChildScrollView(
                    // Anchored to the bottom, so the newest toast is the one
                    // held in view when the stack overflows.
                    reverse: resolved.isBottom,
                    physics: const ClampingScrollPhysics(),
                    child: Semantics(
                      container: true,
                      // A live region: a toast the user did not ask for still
                      // has to reach a screen-reader user, and it is gone
                      // before they could go looking for it.
                      liveRegion: true,
                      label: l10n.toastViewport,
                      explicitChildNodes: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: resolved.isEnd
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        spacing: theme.spacing(AstryxSpacingToken.spacing3),
                        children: <Widget>[
                          // Newest nearest the screen edge the stack grows
                          // from, so a new toast never pushes an older one
                          // under the user's cursor.
                          for (final toast
                              in resolved.isBottom ? toasts : toasts.reversed)
                            _ToastCard(
                              toast: toast,
                              onDismiss: () => _dismiss(toast),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  void _dismiss(AstryxToast toast) {
    for (final entry in controller._entries) {
      if (identical(entry.toast, toast)) {
        controller.dismiss(entry);
        return;
      }
    }
  }
}

/// One toast, including its own timeout.
class _ToastCard extends StatefulWidget {
  const _ToastCard({required this.toast, required this.onDismiss});

  final AstryxToast toast;
  final VoidCallback onDismiss;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> {
  Timer? _timer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restart() {
    _timer?.cancel();
    if (_paused || widget.toast.duration == Duration.zero) return;
    _timer = Timer(widget.toast.duration, () {
      if (mounted) widget.onDismiss();
    });
  }

  /// Hover and focus both pause the timeout.
  ///
  /// A toast that vanishes while the user is reaching for its "Undo" button is
  /// a toast that has actively made things worse.
  void _setPaused({required bool paused}) {
    if (_paused == paused) return;
    _paused = paused;
    paused ? _timer?.cancel() : _restart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final density = AstryxTheme.densityOf(context);

    // The surface is inverted, so *everything inside it* has to resolve its
    // tokens for the opposite mode — the text, the dismiss button, an "Undo"
    // action the caller passed in. Upstream does this by wrapping the toast in
    // `MediaTheme`; here the same token set is re-resolved for the flipped
    // mode, which is exactly what that does.
    final inverted = AstryxThemeData(
      tokens: theme.tokens,
      mode: theme.mode == AstryxThemeMode.light
          ? AstryxThemeMode.dark
          : AstryxThemeMode.light,
      platform: theme.platform,
    );

    Widget card = Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing4)),
      decoration: BoxDecoration(
        color: theme.color(widget.toast.type.background),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        boxShadow: theme.boxShadows(AstryxShadowToken.med),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: theme.spacing(AstryxSpacingToken.spacing3),
        children: <Widget>[
          Flexible(
            child: AstryxText(widget.toast.message),
          ),
          ?widget.toast.action,
          if (widget.toast.dismissible)
            AstryxIconButton(
              icon: AstryxIconName.close,
              label: l10n.toastDismiss,
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: widget.onDismiss,
            ),
        ],
      ),
    );

    card = AstryxTheme(data: inverted, child: card);

    card = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) => _setPaused(paused: focused),
      child: card,
    );

    if (density.supportsHover) {
      card = MouseRegion(
        onEnter: (_) => _setPaused(paused: true),
        onExit: (_) => _setPaused(paused: false),
        child: card,
      );
    }

    if (widget.toast.dismissible) {
      card = Dismissible(
        // Swipe to dismiss, the gesture a touch user reaches for before they
        // look for a close button.
        key: ObjectKey(widget.toast),
        onDismissed: (_) => widget.onDismiss(),
        child: card,
      );
    }

    if (!AstryxMotionAccess.animate(context)) return card;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AstryxMotion.of(context).duration(AstryxDurationToken.fastMax),
      curve: AstryxMotion.of(context).curve(),
      builder: (context, t, child) => Opacity(
        opacity: t,
        // Rises into place, which is what marks it as arriving rather than
        // as something that was always there.
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - t)),
          child: child,
        ),
      ),
      child: card,
    );
  }
}
