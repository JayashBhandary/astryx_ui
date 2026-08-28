/// Several bottom sheets, one at a time, on one shared layer.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/bottom_sheet.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// One sheet in a switcher.
///
/// A description rather than a widget, because a switcher's sheets are not all
/// in the tree at once: only the active one is built, and the rest are the
/// steps it may become. The fields are `AstryxBottomSheet`'s own, minus the
/// ones the switcher owns for the whole flow — the scrim, and how it dismisses.
@immutable
class AstryxBottomSheetPage {
  /// Creates a sheet.
  const AstryxBottomSheetPage({
    required this.id,
    required this.label,
    required this.child,
    this.height = AstryxBottomSheetHeight.hug,
    this.snapPoints = const <double>[],
    this.initialSnapPoint,
    this.showHandle = true,
    this.dragDismissible = true,
    this.padding = AstryxSpacingToken.spacing4,
  });

  /// What names this sheet in `activeSheetId`. Unique within one switcher.
  final String id;

  /// The sheet's accessible name.
  ///
  /// Each step names itself, so a screen reader announces the step the flow
  /// moved to rather than the flow it is still in.
  final String label;

  /// The body.
  final Widget child;

  /// How much of the viewport this step may occupy.
  ///
  /// Defaults to [AstryxBottomSheetHeight.hug], unlike a standalone sheet: the
  /// steps of a flow are rarely the same length, and a fixed budget would make
  /// a two-line confirmation as tall as the form before it.
  final AstryxBottomSheetHeight height;

  /// Extra resting heights, each a fraction of the viewport in `(0, 1]`.
  final List<double> snapPoints;

  /// Which of [snapPoints] this step opens at.
  final int? initialSnapPoint;

  /// Whether to draw the grab handle.
  final bool showHandle;

  /// Whether dragging past the shortest height closes the flow.
  final bool dragDismissible;

  /// The inset around the body.
  final AstryxSpacingToken padding;
}

/// A flow of bottom sheets sharing one scrim.
///
/// The step-by-step case a sheet is often asked for: choose a payment method,
/// then confirm it, then see the receipt. Each step is its own sheet with its
/// own height, and the switcher moves between them **without the scrim
/// flashing** — three separate sheets opening and closing in turn dim the page,
/// undim it, and dim it again, which reads as three interruptions rather than
/// one task.
///
/// {@tool snippet}
/// ```dart
/// AstryxBottomSheetSwitcher(
///   activeSheetId: _step,
///   onActiveSheetChanged: (id) => setState(() => _step = id),
///   sheets: <AstryxBottomSheetPage>[
///     AstryxBottomSheetPage(
///       id: 'method',
///       label: 'Payment method',
///       child: MethodList(onPicked: () => setState(() => _step = 'confirm')),
///     ),
///     AstryxBottomSheetPage(
///       id: 'confirm',
///       label: 'Confirm payment',
///       child: const Confirmation(),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// [activeSheetId] is the whole state: a non-null id is the step on screen,
/// null closes the flow. There is no controller, because a controller and an
/// id would be two sources of truth for the same thing.
///
/// ## What is not ported
///
/// Upstream choreographs the outgoing sheet — it stays present and inert,
/// travels to meet the height of the incoming one, then fades. Here the two
/// cross-fade while the layer resizes to the new step. The difference shows on
/// a large height change; everything the flow *does* is the same.
class AstryxBottomSheetSwitcher extends StatefulWidget {
  /// Creates a switcher.
  const AstryxBottomSheetSwitcher({
    required this.activeSheetId,
    required this.onActiveSheetChanged,
    required this.sheets,
    super.key,
    this.showScrim = true,
    this.barrierDismissible = true,
    this.escapeDismissible = true,
  });

  /// The id of the step on screen, or null when the flow is closed.
  final String? activeSheetId;

  /// Called with the step to move to, or null to close the flow.
  ///
  /// Called with null when the scrim, Escape or a drag dismisses the sheet, so
  /// a flow closed by the user and one closed by code take the same path.
  final ValueChanged<String?> onActiveSheetChanged;

  /// The steps. Order is documentation only — [activeSheetId] decides.
  final List<AstryxBottomSheetPage> sheets;

  /// Whether to dim the page behind the flow.
  final bool showScrim;

  /// Whether a press on the scrim closes the flow.
  final bool barrierDismissible;

  /// Whether Escape closes the flow.
  final bool escapeDismissible;

  @override
  State<AstryxBottomSheetSwitcher> createState() =>
      _AstryxBottomSheetSwitcherState();
}

class _AstryxBottomSheetSwitcherState extends State<AstryxBottomSheetSwitcher> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  /// The step the layer is showing, which outlives the widget's own
  /// `activeSheetId` by the length of the exit: a layer animating out with
  /// nothing in it is a scrim fading over an empty rectangle.
  AstryxBottomSheetPage? _shown;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(AstryxBottomSheetSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sync() {
    final page = _pageOrNull(widget.activeSheetId);
    if (page != null) _shown = page;
    if ((page != null) != _controller.isOpen) {
      page != null ? _controller.show() : _controller.hide();
    }
  }

  AstryxBottomSheetPage? _pageOrNull(String? id) {
    if (id == null) return null;
    for (final sheet in widget.sheets) {
      if (sheet.id == id) return sheet;
    }
    assert(
      false,
      'AstryxBottomSheetSwitcher has no sheet with id "$id". '
      'activeSheetId must name one of `sheets`, or be null.',
    );
    return null;
  }

  void _close() => widget.onActiveSheetChanged(null);

  @override
  Widget build(BuildContext context) {
    final motion = AstryxMotion.of(context);
    final page = _shown;

    return AstryxOverlay(
      controller: _controller,
      label: page?.label,
      debugLabel: 'AstryxBottomSheetSwitcher',
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsets.zero,
      showScrim: widget.showScrim,
      barrierDismissible: widget.barrierDismissible,
      escapeDismissible: widget.escapeDismissible,
      onDismiss: _close,
      transitionBuilder: (context, animation, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: AnimatedSwitcher(
        duration: motion.duration(AstryxDurationToken.fast),
        switchInCurve: motion.curve(),
        switchOutCurve: motion.curve(),
        // Bottom-aligned, so two steps of different heights are pinned to the
        // edge they both rise from while they cross.
        layoutBuilder: (current, previous) => Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[...previous, ?current],
        ),
        child: page == null
            ? const SizedBox.shrink()
            : AstryxBottomSheetPanel(
                // Keyed by step, which is what makes the switcher cross-fade
                // rather than mutate one panel into the next — and what resets
                // the drag state between steps.
                key: ValueKey<String>(page.id),
                label: page.label,
                height: page.height,
                snapPoints: page.snapPoints,
                initialSnapPoint: page.initialSnapPoint,
                showHandle: page.showHandle,
                dragDismissible: page.dragDismissible,
                padding: page.padding,
                onDismiss: _close,
                child: page.child,
              ),
      ),
    );
  }
}
