/// Dialogs and sheets as routes: `showAstryxDialog` and friends.
library;

import 'package:astryx_ui/src/components/overlay/alert_dialog.dart';
import 'package:astryx_ui/src/components/overlay/bottom_sheet.dart';
import 'package:astryx_ui/src/components/overlay/dialog.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/components/bottom_sheet.dart';
import 'package:astryx_ui/src/theme/components/dialog.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Shows a dialog as a route and completes with the value it is popped with.
///
/// The Material equivalent is `showDialog`. Where [AstryxDialog] is a widget
/// you keep in the tree and open with a controller, this pushes a route, so:
///
///  * the result comes back as a `Future` — pop with
///    `Navigator.pop(context, value)` from inside [builder] or
///    [footerBuilder];
///  * the system back button and the Android back gesture close it;
///  * focus returns to whatever opened it when it closes.
///
/// The panel is the same one [AstryxDialog] draws: title, description, close
/// button, scrolling body, pinned footer. Closing it any way other than a
/// `pop` with a value — the close button, the barrier, Escape, back —
/// completes with null.
///
/// {@tool snippet}
/// ```dart
/// final name = await showAstryxDialog<String>(
///   context: context,
///   title: 'Rename project',
///   builder: (context) => AstryxTextInput(controller: _name, label: 'Name'),
///   footerBuilder: (context) => AstryxButton(
///     label: 'Rename',
///     variant: AstryxButtonVariant.primary,
///     onPressed: () => Navigator.pop(context, _name.text),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// The dialog keeps the theme of [context], including any
/// `AstryxComponentTheme` above it, even when it is pushed onto the root
/// navigator.
Future<T?> showAstryxDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  String? description,
  WidgetBuilder? footerBuilder,
  double? width,
  bool showCloseButton = true,
  bool barrierDismissible = true,
  bool escapeDismissible = true,
  AstryxDialogTheme? theme,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final resolved = AstryxTheme.of(context).dialog.merge(theme);
  return navigator.push<T>(
    AstryxDialogRoute<T>(
      context: context,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      label: title,
      settings: routeSettings,
      barrierDismissible: barrierDismissible,
      escapeDismissible: escapeDismissible,
      scrimColor: resolved.scrimColor,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width ?? resolved.maxWidth ?? 480,
        ),
        child: AstryxDialogPanel(
          title: title,
          description: description,
          footer: footerBuilder?.call(context),
          showCloseButton: showCloseButton,
          onClose: () => Navigator.maybePop(context),
          resolved: resolved,
          child: builder(context),
        ),
      ),
    ),
  );
}

/// Asks one question and completes with the answer: true for confirm, false
/// for anything else.
///
/// The route form of [AstryxAlertDialog], with the same safeguards: the
/// barrier does not dismiss it by default, there is no close button, and focus
/// starts on cancel. Back and Escape count as cancel.
///
/// {@tool snippet}
/// ```dart
/// if (await showAstryxAlertDialog(
///   context: context,
///   title: 'Delete project',
///   description: 'Atlas will be removed. This cannot be undone.',
///   confirmLabel: 'Delete project',
///   destructive: true,
/// )) {
///   await _delete();
/// }
/// ```
/// {@end-tool}
Future<bool> showAstryxAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
  bool showCancel = true,
  bool barrierDismissible = false,
  bool escapeDismissible = true,
  double? width,
  Widget? child,
  AstryxDialogTheme? theme,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) async {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final resolved = AstryxTheme.of(context).dialog.merge(theme);
  final confirmed = await navigator.push<bool>(
    AstryxDialogRoute<bool>(
      context: context,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      label: title,
      settings: routeSettings,
      barrierDismissible: barrierDismissible,
      escapeDismissible: escapeDismissible,
      scrimColor: resolved.scrimColor,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width ?? resolved.maxWidth ?? 420,
        ),
        child: AstryxDialogPanel(
          title: title,
          description: null,
          showCloseButton: false,
          onClose: () => Navigator.pop(context, false),
          resolved: resolved,
          footer: AstryxAlertDialogParts.footer(
            context,
            resolved: resolved,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            showCancel: showCancel,
            destructive: destructive,
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
          child: AstryxAlertDialogParts.body(
            context,
            resolved: resolved,
            description: description,
            child: child,
          ),
        ),
      ),
    ),
  );
  return confirmed ?? false;
}

/// Shows a bottom sheet as a route and completes with the value it is popped
/// with.
///
/// The Material equivalent is `showModalBottomSheet`. The sheet is the one
/// [AstryxBottomSheet] draws — handle, snap points, drag to dismiss — but as a
/// route, so it returns a result and closes on the system back button.
///
/// {@tool snippet}
/// ```dart
/// final choice = await showAstryxBottomSheet<String>(
///   context: context,
///   label: 'Share',
///   height: AstryxBottomSheetHeight.hug,
///   builder: (context) => AstryxButton(
///     label: 'Copy link',
///     onPressed: () => Navigator.pop(context, 'copy'),
///   ),
/// );
/// ```
/// {@end-tool}
Future<T?> showAstryxBottomSheet<T>({
  required BuildContext context,
  required String label,
  required WidgetBuilder builder,
  AstryxBottomSheetHeight height = AstryxBottomSheetHeight.capped,
  List<double> snapPoints = const <double>[],
  int? initialSnapPoint,
  bool showScrim = true,
  bool showHandle = true,
  bool barrierDismissible = true,
  bool escapeDismissible = true,
  bool dragDismissible = true,
  AstryxSpacingToken? padding,
  AstryxBottomSheetTheme? theme,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final resolved = AstryxTheme.of(context).bottomSheet.merge(theme);
  return navigator.push<T>(
    AstryxBottomSheetRoute<T>(
      context: context,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      label: label,
      settings: routeSettings,
      showScrim: showScrim,
      barrierDismissible: barrierDismissible,
      escapeDismissible: escapeDismissible,
      scrimColor: resolved.scrimColor,
      builder: (context) => AstryxBottomSheetPanel(
        label: label,
        height: height,
        snapPoints: snapPoints,
        initialSnapPoint: initialSnapPoint,
        showHandle: showHandle,
        dragDismissible: dragDismissible,
        padding: padding,
        theme: theme,
        onDismiss: () => Navigator.maybePop(context),
        child: builder(context),
      ),
    ),
  );
}

/// The route behind [showAstryxDialog] and [showAstryxAlertDialog].
///
/// The Material equivalent is `DialogRoute`. Push one directly for a dialog
/// whose content is not the standard panel — [builder] is centred over a
/// scrim and given the same entry motion as [AstryxDialog].
class AstryxDialogRoute<T> extends _AstryxModalRoute<T> {
  /// Creates a dialog route.
  ///
  /// [context] is where the theme comes from. [themes] are the inherited
  /// themes to carry into the route; null captures everything between
  /// [context] and its nearest navigator, so a subtree's theme survives the
  /// trip. Pass `InheritedTheme.capture(from: context, to: root.context)`
  /// when pushing onto a different navigator.
  AstryxDialogRoute({
    required super.context,
    required super.builder,
    super.themes,
    super.label,
    super.settings,
    super.barrierDismissible = true,
    super.escapeDismissible = true,
    super.scrimColor,
  }) : super(alignment: Alignment.center, inset: true);

  @override
  Widget _transition(Animation<double> curved, Widget child) => FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
      child: child,
    ),
  );
}

/// The route behind [showAstryxBottomSheet].
///
/// The Material equivalent is `ModalBottomSheetRoute`. [builder] is pinned to
/// the bottom edge and slides up from it.
class AstryxBottomSheetRoute<T> extends _AstryxModalRoute<T> {
  /// Creates a bottom-sheet route.
  AstryxBottomSheetRoute({
    required super.context,
    required super.builder,
    super.themes,
    super.label,
    super.settings,
    super.barrierDismissible = true,
    super.escapeDismissible = true,
    super.scrimColor,
    super.showScrim,
  }) : super(alignment: AlignmentDirectional.bottomCenter, inset: false);

  @override
  Widget _transition(Animation<double> curved, Widget child) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(curved),
    child: child,
  );
}

/// What the dialog and sheet routes share: the captured theme, the scrim, the
/// Escape handling, the motion tokens and the route semantics.
abstract class _AstryxModalRoute<T> extends PopupRoute<T> {
  _AstryxModalRoute({
    required BuildContext context,
    required this.builder,
    required this.alignment,
    required this.inset,
    CapturedThemes? themes,
    this.label,
    super.settings,
    bool barrierDismissible = true,
    this.escapeDismissible = true,
    Color? scrimColor,
    bool showScrim = true,
  }) : _barrierDismissible = barrierDismissible,
       _themes =
           themes ??
           InheritedTheme.capture(
             from: context,
             to: Navigator.of(context).context,
           ),
       _barrierColor = !showScrim
           ? null
           : scrimColor ??
                 AstryxTheme.of(context).color(AstryxColorToken.overlay),
       _motion = AstryxMotion.of(context);

  /// Builds the dialog or sheet itself.
  final WidgetBuilder builder;

  /// The accessible name of the route.
  final String? label;

  /// Whether Escape closes the route.
  ///
  /// Separate from [barrierDismissible], as on [AstryxDialog]: an alert that
  /// a stray click must not dismiss can still be cancelled from the keyboard.
  final bool escapeDismissible;

  /// Where [builder]'s widget sits in the viewport.
  final AlignmentGeometry alignment;

  /// Whether to keep clear of the safe area and the keyboard, with a margin.
  final bool inset;
  final bool _barrierDismissible;
  final CapturedThemes _themes;
  final Color? _barrierColor;
  final AstryxMotion _motion;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  Color? get barrierColor => _barrierColor;

  @override
  String? get barrierLabel => label;

  @override
  Duration get transitionDuration =>
      _motion.duration(AstryxDurationToken.mediumMax);

  @override
  Curve get barrierCurve => _motion.curve();

  Widget _transition(Animation<double> curved, Widget child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => _transition(
    CurvedAnimation(parent: animation, curve: _motion.curve()),
    child,
  );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Widget content = Builder(builder: builder);

    content = Align(alignment: alignment, child: content);

    if (inset) {
      // Clear of the keyboard and the notch, then the panel's own margin.
      content = SafeArea(
        child: Padding(
          padding:
              MediaQuery.viewInsetsOf(context) +
              EdgeInsets.all(
                AstryxTheme.of(
                  context,
                ).spacing(AstryxSpacingToken.spacing4),
              ),
          child: content,
        ),
      );
    }

    content = FocusScope(
      // A scope rather than a plain `Focus`: it takes focus when nothing
      // inside asks for it, so Escape always reaches [_handleKey] — yet an
      // `autofocus` inside still wins, because it is that scope's first
      // focused child rather than a rival for the route's.
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Semantics(
        scopesRoute: true,
        namesRoute: label != null,
        explicitChildNodes: true,
        label: label,
        child: content,
      ),
    );

    return _themes.wrap(content);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    // Handled either way: when Escape is not allowed to close this route it
    // must not fall through to the route's own dismiss action either.
    if (escapeDismissible && isCurrent) navigator?.maybePop();
    return KeyEventResult.handled;
  }
}
