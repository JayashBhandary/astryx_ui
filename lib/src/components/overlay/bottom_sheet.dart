/// A panel anchored to the bottom edge of the viewport.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The widest a sheet becomes before it stops growing with the window.
///
/// A sheet is a thumb-reach surface. Past this it is a dialog that happens to
/// be stuck to the bottom of a desktop window, so it centres instead.
const double _maxSheetWidth = 640;

/// How much of the viewport a sheet may occupy.
enum AstryxBottomSheetHeight {
  /// As tall as its content, up to 92% of the viewport.
  ///
  /// For a sheet whose content is short and known — a share menu, three
  /// actions, a confirmation. A sheet that hugs nothing is a sheet that hugs
  /// the top of the screen.
  hug(0.92, hugContent: true),

  /// 62% of the viewport, whatever the content. The default.
  ///
  /// The height that leaves enough of the page visible behind the scrim to keep
  /// the sheet reading as a layer over something rather than as a new screen.
  capped(0.62, hugContent: false),

  /// 92% of the viewport — a working surface, with the page a sliver above it.
  tall(0.92, hugContent: false);

  const AstryxBottomSheetHeight(this.fraction, {required this.hugContent});

  /// The share of the viewport height this budget allows.
  final double fraction;

  /// Whether the sheet sizes to its content rather than filling the budget.
  final bool hugContent;
}

/// Drives an [AstryxBottomSheet].
///
/// An [AstryxOverlayController] under a name that says what it drives, exactly
/// as `AstryxDialogController` does.
class AstryxBottomSheetController extends AstryxOverlayController {}

/// A panel that rises from the bottom edge of the viewport.
///
/// The same modal contract as `AstryxDialog` — trapped focus, Escape, a scrim
/// that dims and dismisses, focus handed back to whatever opened it — anchored
/// to an edge rather than centred, and draggable.
///
/// **Reach for a sheet on a touch screen.** It puts its content and its actions
/// inside the thumb's reach, which is the whole reason it exists; a dialog
/// centred in a tall phone window puts them where the hand is not. On a desktop
/// window `AstryxDialog` remains the right shape.
///
/// {@tool snippet}
/// ```dart
/// AstryxBottomSheet(
///   controller: _sheet,
///   label: 'Filters',
///   height: AstryxBottomSheetHeight.hug,
///   child: const FilterForm(),
/// )
/// ```
/// {@end-tool}
///
/// Like every overlay here it is a **widget in the tree**, not a
/// `showModalBottomSheet` call: it renders nothing until [controller] opens it,
/// so it sits next to whatever opens it and there is no `BuildContext` to
/// smuggle across an async gap.
///
/// ## Snap points
///
/// [snapPoints] gives the sheet more than one resting height, each a fraction
/// of the viewport, and dragging the handle moves between them. Dragging below
/// the shortest one dismisses the sheet when [dragDismissible].
///
/// A sheet with snap points must still work for someone who cannot drag: every
/// detent has to be a *convenience*, never the only way to reach something.
/// Put nothing behind a detent that the sheet does not also reach by scrolling.
///
/// See also:
///
///  * `AstryxDialog`, for the same contract centred in the viewport.
///  * `AstryxBottomSheetSwitcher`, for a flow of sheets sharing one scrim.
class AstryxBottomSheet extends StatelessWidget {
  /// Creates a bottom sheet.
  const AstryxBottomSheet({
    required this.controller,
    required this.label,
    required this.child,
    super.key,
    this.height = AstryxBottomSheetHeight.capped,
    this.snapPoints = const <double>[],
    this.initialSnapPoint,
    this.showScrim = true,
    this.showHandle = true,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
    this.dragDismissible = true,
    this.padding = AstryxSpacingToken.spacing4,
    this.onDismiss,
  });

  /// The open/closed state.
  final AstryxBottomSheetController controller;

  /// The sheet's accessible name.
  ///
  /// Required, and not optional as it is on a dialog: a sheet has no header of
  /// its own to derive a name from.
  final String label;

  /// The body. Scrolls when it is taller than the sheet.
  final Widget child;

  /// How much of the viewport the sheet may occupy.
  final AstryxBottomSheetHeight height;

  /// Extra resting heights, each a fraction of the viewport in `(0, 1]`.
  ///
  /// Order does not matter; duplicates and values outside the range are
  /// dropped. An empty list — the default — gives the sheet the single height
  /// [height] asks for.
  final List<double> snapPoints;

  /// Which of [snapPoints] the sheet opens at.
  ///
  /// Null opens at the tallest, which is the one that shows the most of what
  /// the sheet was opened for. Clamped into range.
  final int? initialSnapPoint;

  /// Whether to dim the page behind the sheet.
  final bool showScrim;

  /// Whether to draw the grab handle.
  ///
  /// False only for a sheet that cannot be dragged at all — the handle is the
  /// affordance, and a draggable sheet without one is a gesture nobody finds.
  final bool showHandle;

  /// Whether a press on the scrim closes it.
  final bool barrierDismissible;

  /// Whether Escape closes it.
  final bool escapeDismissible;

  /// Whether dragging the sheet down past its shortest height closes it.
  final bool dragDismissible;

  /// The inset between the sheet's edges and its content.
  final AstryxSpacingToken padding;

  /// Called when the sheet dismisses itself.
  final VoidCallback? onDismiss;

  void _dismiss() {
    controller.hide();
    onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) => AstryxOverlay(
    controller: controller,
    label: label,
    debugLabel: 'AstryxBottomSheet',
    alignment: AlignmentDirectional.bottomCenter,
    padding: EdgeInsets.zero,
    showScrim: showScrim,
    barrierDismissible: barrierDismissible,
    escapeDismissible: escapeDismissible,
    onDismiss: onDismiss,
    // A sheet arrives from the edge it is anchored to. Fading one in leaves no
    // trace of where it came from, which is the one thing its shape is meant
    // to say.
    transitionBuilder: (context, animation, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
    child: AstryxBottomSheetPanel(
      label: label,
      height: height,
      snapPoints: snapPoints,
      initialSnapPoint: initialSnapPoint,
      showHandle: showHandle,
      dragDismissible: dragDismissible,
      padding: padding,
      onDismiss: _dismiss,
      child: child,
    ),
  );
}

/// The sheet itself: the surface, the handle, the drag, and the scrolling body.
///
/// Separate from [AstryxBottomSheet] so `AstryxBottomSheetSwitcher` can raise
/// several of these on one layer without each one owning a layer of its own.
@internal
class AstryxBottomSheetPanel extends StatefulWidget {
  /// Creates a sheet panel.
  const AstryxBottomSheetPanel({
    required this.label,
    required this.height,
    required this.snapPoints,
    required this.showHandle,
    required this.dragDismissible,
    required this.padding,
    required this.onDismiss,
    required this.child,
    super.key,
    this.initialSnapPoint,
  });

  /// The sheet's accessible name, which the handle reports as what it moves.
  final String label;

  /// How much of the viewport the sheet may occupy.
  final AstryxBottomSheetHeight height;

  /// The extra resting heights, unvalidated.
  final List<double> snapPoints;

  /// Which detent to open at. Null opens at the tallest.
  final int? initialSnapPoint;

  /// Whether to draw the grab handle.
  final bool showHandle;

  /// Whether dragging past the shortest detent dismisses.
  final bool dragDismissible;

  /// The inset around the body.
  final AstryxSpacingToken padding;

  /// Dismisses the sheet.
  final VoidCallback onDismiss;

  /// The body.
  final Widget child;

  @override
  State<AstryxBottomSheetPanel> createState() => _AstryxBottomSheetPanelState();
}

class _AstryxBottomSheetPanelState extends State<AstryxBottomSheetPanel> {
  /// How far the sheet has been dragged from its resting height, in pixels.
  ///
  /// Positive is down — toward dismissal. Negative is up, which only means
  /// anything when there is a taller detent to grow into.
  double _drag = 0;

  /// The index into [_detents] the sheet is resting at.
  late int _detent = _initialDetent;

  /// The valid snap points, ascending, or empty when the sheet has one height.
  ///
  /// Sorted and de-duplicated once per build rather than per drag frame, and
  /// silently dropping the values that are not fractions: a snap point of `50`
  /// is a mistake, and a sheet that threw for it would take the whole screen
  /// down with it.
  List<double> get _detents {
    final points =
        widget.snapPoints
            .where((point) => point > 0 && point <= 1 && point.isFinite)
            .toSet()
            .toList()
          ..sort();
    return points;
  }

  int get _initialDetent {
    final count = _detents.length;
    if (count == 0) return 0;
    return (widget.initialSnapPoint ?? count - 1).clamp(0, count - 1);
  }

  @override
  void didUpdateWidget(AstryxBottomSheetPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A changed snap-point list can leave the resting index past the end.
    final count = _detents.length;
    if (count > 0 && _detent > count - 1) _detent = count - 1;
  }

  /// The sheet's resting height in pixels, or null when it hugs its content.
  double? _restingHeight(double available) {
    final detents = _detents;
    if (detents.isNotEmpty) {
      return available * detents[_detent].clamp(0.0, widget.height.fraction);
    }
    return widget.height.hugContent
        ? null
        : available * widget.height.fraction;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() => _drag += details.delta.dy);
  }

  void _onDragEnd(DragEndDetails details, double available) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    final detents = _detents;

    // A flick decides on its own: past this speed the direction of the gesture
    // is the answer, however far it happened to travel before the finger left.
    const flick = 600.0;

    if (detents.isEmpty) {
      final resting = _restingHeight(available) ?? available;
      final dismissed =
          widget.dragDismissible &&
          (velocity > flick || _drag > resting * 0.35);
      setState(() => _drag = 0);
      if (dismissed) widget.onDismiss();
      return;
    }

    // Where the sheet's edge actually is right now, as a fraction, so the
    // nearest detent is measured against what the user is looking at.
    final current = ((_restingHeight(available)! - _drag) / available).clamp(
      0.0,
      1.0,
    );

    var target = 0;
    var best = double.infinity;
    for (var i = 0; i < detents.length; i++) {
      final distance = (detents[i] - current).abs();
      if (distance < best) {
        best = distance;
        target = i;
      }
    }
    if (velocity > flick) target = (target - 1).clamp(-1, detents.length - 1);
    if (velocity < -flick) target = (target + 1).clamp(0, detents.length - 1);

    final belowShortest = current < detents.first * 0.5;
    final dismissed =
        widget.dragDismissible && (target < 0 || (belowShortest && _drag > 0));

    setState(() {
      _drag = 0;
      _detent = target.clamp(0, detents.length - 1);
    });
    if (dismissed) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final l10n = AstryxLocalizations.of(context);
    final radius = theme.borderRadius(AstryxRadiusToken.container);
    final border = theme.color(AstryxColorToken.border);

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        final resting = _restingHeight(available);
        final budget = available * widget.height.fraction;

        // Down is a translation; up grows the sheet toward the taller detent,
        // which is what makes a drag upward feel like it is pulling the sheet
        // open rather than sliding it off its anchor.
        final grow = _drag < 0 && resting != null ? -_drag : 0.0;
        final height = resting == null
            ? null
            : (resting + grow).clamp(0.0, budget);

        Widget panel = Container(
          constraints: BoxConstraints(
            maxWidth: _maxSheetWidth,
            maxHeight: budget,
          ),
          height: height,
          decoration: BoxDecoration(
            color: theme.color(AstryxColorToken.backgroundSurface),
            borderRadius: BorderRadiusDirectional.only(
              topStart: radius.topLeft,
              topEnd: radius.topRight,
            ),
            // A hairline on the three edges facing the scrim. The surface fill
            // separates sheet from scrim in light mode but not in dark, where
            // the two sit within a few steps of each other and the shadow is
            // black on near-black. The bottom edge is deliberately bare: it is
            // off the viewport.
            border: BorderDirectional(
              top: BorderSide(color: border, width: theme.borderWidth()),
              start: BorderSide(color: border, width: theme.borderWidth()),
              end: BorderSide(color: border, width: theme.borderWidth()),
            ),
            boxShadow: theme.boxShadows(AstryxShadowToken.high),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.showHandle)
                _Handle(
                  label: l10n.bottomSheetHandle,
                  sheetLabel: widget.label,
                  onDragUpdate: _onDragUpdate,
                  onDragEnd: (details) => _onDragEnd(details, available),
                ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.all(theme.spacing(widget.padding)),
                  child: widget.child,
                ),
              ),
            ],
          ),
        );

        if (_drag > 0) {
          panel = Transform.translate(
            offset: Offset(0, _drag),
            child: panel,
          );
        }

        // No `Align` of its own: the layer already pins the panel to the
        // bottom edge, and an aligning box here would fill the viewport and
        // swallow every press meant for the scrim.
        return AnimatedSize(
          // Only the settle after a release is animated; the drag itself is
          // the finger's, and interpolating it would put the sheet behind the
          // thumb moving it.
          duration: _drag == 0
              ? motion.duration(AstryxDurationToken.fast)
              : Duration.zero,
          curve: motion.curve(),
          alignment: AlignmentDirectional.bottomCenter,
          child: panel,
        );
      },
    );
  }
}

/// The grab handle: the pill, and the drag target around it.
class _Handle extends StatelessWidget {
  const _Handle({
    required this.label,
    required this.sheetLabel,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final String label;
  final String sheetLabel;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged<DragEndDetails> onDragEnd;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Semantics(
      label: '$label, $sheetLabel',
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: onDragUpdate,
          onVerticalDragEnd: onDragEnd,
          child: SizedBox(
            // The full 24px band is the target, not the 4px pill: a pill-sized
            // drag target on a touch screen is a pill-sized miss rate.
            height: theme.spacing(AstryxSpacingToken.spacing6),
            child: Center(
              child: Container(
                width: theme.size(AstryxSizeToken.elementLg),
                height: theme.spacing(AstryxSpacingToken.spacing1),
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.border),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
