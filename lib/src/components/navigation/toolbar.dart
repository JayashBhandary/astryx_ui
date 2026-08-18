/// A horizontal band of controls.
library;

import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A band of controls that behaves as one control.
///
/// **Tab reaches the toolbar, not each button in it.** A formatting bar of
/// twelve buttons is twelve presses to walk past otherwise, which is the reason
/// the ARIA toolbar pattern exists. Inside it, the arrows move between the
/// controls and wrap at the ends.
///
/// The children are ordinary widgets — `AstryxButton`, `AstryxIconButton`,
/// `AstryxSegmentedControl`, anything focusable — and the toolbar makes them
/// one stop by taking traversal away from them and driving focus itself.
///
/// {@tool snippet}
/// ```dart
/// AstryxToolbar(
///   label: 'Formatting',
///   children: <Widget>[
///     AstryxIconButton(icon: …, label: 'Bold', onPressed: bold),
///     AstryxIconButton(icon: …, label: 'Italic', onPressed: italic),
///     const AstryxToolbarDivider(),
///     AstryxMoreMenu(entries: more),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxMoreMenu`, for the tail of a toolbar that will not fit.
///  * `AstryxOverflowList`, which measures the row and decides what that tail
///    is.
///  * `AstryxButtonGroup`, for buttons joined into one visual control, which is
///    a different thing: a group is drawn together, a toolbar is *operated*
///    together.
class AstryxToolbar extends StatefulWidget {
  /// Creates a toolbar.
  const AstryxToolbar({
    required this.children,
    super.key,
    this.label,
    this.gap = AstryxSpacingToken.spacing1,
    this.padding = AstryxSpacingToken.spacing1,
  });

  /// The controls, in the order they are traversed.
  final List<Widget> children;

  /// The toolbar's accessible name — "Formatting", "Table actions".
  final String? label;

  /// The space between controls.
  final AstryxSpacingToken gap;

  /// The inset around them.
  final AstryxSpacingToken padding;

  @override
  State<AstryxToolbar> createState() => _AstryxToolbarState();
}

class _AstryxToolbarState extends State<AstryxToolbar> {
  /// The node the controls hang under.
  ///
  /// Not itself a tab stop: it watches its descendants' key events as they
  /// bubble, which is how the toolbar can answer for keys pressed on a button
  /// inside it.
  final FocusNode _inner = FocusNode(
    debugLabel: 'AstryxToolbar',
    canRequestFocus: false,
  );

  @override
  void dispose() {
    _inner.dispose();
    super.dispose();
  }

  /// The controls, in visual order.
  List<FocusNode> get _stops =>
      _inner.descendants.where((node) => node.canRequestFocus).toList();

  void _moveTo(int index) {
    final stops = _stops;
    if (stops.isEmpty) return;
    final wrapped = index % stops.length;
    stops[wrapped < 0 ? wrapped + stops.length : wrapped].requestFocus();
  }

  void _move(int delta) {
    final stops = _stops;
    if (stops.isEmpty) return;
    final current = stops.indexWhere((node) => node.hasFocus);
    _moveTo(current < 0 ? 0 : current + delta);
  }

  /// Leaves the toolbar in one press, whichever control is focused.
  ///
  /// This is what makes the band *one* tab stop: entering costs a Tab and
  /// leaving costs a Tab, however many controls sit between. Traversal itself
  /// is left alone — the trick is to step to the edge first and then let
  /// Flutter's own traversal carry on past it.
  bool _escape({required bool forward}) {
    final stops = _stops;
    if (stops.isEmpty) return false;
    (forward ? stops.last : stops.first).requestFocus();
    return forward ? stops.last.nextFocus() : stops.first.previousFocus();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final shift =
        HardwareKeyboard.instance.isShiftPressed ||
        event.logicalKey == LogicalKeyboardKey.shiftLeft;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        _move(rtl ? -1 : 1);
      case LogicalKeyboardKey.arrowLeft:
        _move(rtl ? 1 : -1);
      case LogicalKeyboardKey.home:
        _moveTo(0);
      case LogicalKeyboardKey.end:
        _moveTo(_stops.length - 1);
      case LogicalKeyboardKey.tab:
        if (!_escape(forward: !shift)) return KeyEventResult.ignored;
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label ?? AstryxLocalizations.of(context).toolbarLabel,
      // Tab lands on the first control, because the controls stay traversable;
      // what stops the band being twelve stops is that Tab pressed *inside* it
      // leaves rather than walking on.
      child: Focus(
        focusNode: _inner,
        onKeyEvent: _handleKey,
        child: Padding(
          padding: EdgeInsets.all(theme.spacing(widget.padding)),
          // A `Wrap` rather than a `Row`, and it behaves as a row in every
          // window wide enough for one: a single run, hugging its controls.
          // Narrower than that it takes a second run instead of running off
          // the edge — a formatting bar whose last two buttons are past the
          // right-hand side is a bar those buttons have left. Arrow-key
          // traversal is unchanged, because it walks the focus nodes rather
          // than the geometry.
          child: Wrap(
            spacing: theme.spacing(widget.gap),
            runSpacing: theme.spacing(widget.gap),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

/// A rule between two groups of toolbar controls.
///
/// Its own widget because a bare [AstryxDivider] in a toolbar needs a height it
/// has no way to know, and because a rule between groups is a thing a caller
/// should be able to name.
class AstryxToolbarDivider extends StatelessWidget {
  /// Creates a toolbar divider.
  const AstryxToolbarDivider({super.key, this.height = 20});

  /// How tall the rule is.
  final double height;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AstryxTheme.of(
        context,
      ).spacing(AstryxSpacingToken.spacing1),
    ),
    child: SizedBox(
      height: height,
      child: const AstryxDivider(axis: Axis.vertical),
    ),
  );
}
