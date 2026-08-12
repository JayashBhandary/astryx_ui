/// A horizontally paged strip of items.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A horizontally paged strip, with controls and keyboard traversal.
///
/// Upstream's `Carousel`. One item at a time, a control at each end, a position
/// readout, and **one tab stop**: the arrows move between items while the strip
/// itself is what Tab lands on.
///
/// {@tool snippet}
/// ```dart
/// AstryxCarousel(
///   label: 'Screenshots',
///   items: <Widget>[
///     for (final shot in shots) AstryxAspectRatio(ratio: 16 / 9, child: shot),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// **There is no autoplay, and that is deliberate.** Content that moves on its
/// own for more than five seconds has to be pausable (WCAG 2.2.1), it takes the
/// thing a reader was looking at away mid-sentence, and the pause control is
/// invariably the least obvious thing on the screen. If a set of items deserves
/// attention on its own schedule, it deserves a page rather than a timer.
class AstryxCarousel extends StatefulWidget {
  /// Creates a carousel.
  const AstryxCarousel({
    required this.items,
    super.key,
    this.label,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.showControls = true,
    this.showPosition = true,
    this.height,
    this.viewportFraction = 1,
    this.focusNode,
  }) : assert(
         viewportFraction > 0 && viewportFraction <= 1,
         'viewportFraction must be in (0, 1]',
       );

  /// The items, in order.
  final List<Widget> items;

  /// What the strip is. "Screenshots", "Attachments".
  final String? label;

  /// Which item to open on.
  final int initialIndex;

  /// Called with the item now showing.
  final ValueChanged<int>? onIndexChanged;

  /// Whether to draw the previous and next controls.
  ///
  /// True, and worth leaving true: a strip that can only be swiped is a strip a
  /// mouse user has to drag and a keyboard user cannot reach at all.
  final bool showControls;

  /// Whether to draw the "3 of 8" readout.
  final bool showPosition;

  /// A fixed height for the strip. Null lets the items decide.
  final double? height;

  /// The strip's focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// How much of the viewport one item takes.
  ///
  /// Less than one leaves the next item peeking in, which is the only reliable
  /// way to say "there is more this way" on a touch device with no hover and no
  /// visible controls.
  final double viewportFraction;

  @override
  State<AstryxCarousel> createState() => _AstryxCarouselState();
}

class _AstryxCarouselState extends State<AstryxCarousel> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
    viewportFraction: widget.viewportFraction,
  );

  late int _index = widget.initialIndex;

  FocusNode? _internalFocusNode;

  /// The node the arrows are handled on.
  ///
  /// A real node rather than the one `Focus` makes for itself: the strip is the
  /// single tab stop for the whole carousel, so something has to be able to
  /// *hold* the focus and be handed it programmatically.
  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _canGoBack => _index > 0;
  bool get _canGoOn => _index < widget.items.length - 1;

  void _go(int delta) {
    final next = _index + delta;
    if (next < 0 || next >= widget.items.length) return;

    final motion = AstryxMotion.of(context);
    if (!motion.animate) {
      _controller.jumpToPage(next);
      return;
    }
    _controller.animateToPage(
      next,
      duration: motion.duration(AstryxDurationToken.medium),
      curve: motion.curve(),
    );
  }

  void _handlePageChanged(int index) {
    if (index == _index) return;
    setState(() => _index = index);
    widget.onIndexChanged?.call(index);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        _go(rtl ? -1 : 1);
      case LogicalKeyboardKey.arrowLeft:
        _go(rtl ? 1 : -1);
      case LogicalKeyboardKey.home:
        _go(-_index);
      case LogicalKeyboardKey.end:
        _go(widget.items.length - 1 - _index);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final position = l10n.carouselPosition(_index + 1, widget.items.length);

    final strip = PageView.builder(
      controller: _controller,
      onPageChanged: _handlePageChanged,
      itemCount: widget.items.length,
      itemBuilder: (context, index) => widget.items[index],
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label ?? l10n.carouselLabel,
      // The position is the container's *value*, so a reader landing on the
      // strip is told where in the set they are before anything else.
      value: position,
      child: Focus(
        focusNode: _focusNode,
        // One tab stop: the strip is focusable and the items are not, so Tab
        // walks past a carousel of forty screenshots in one press.
        canRequestFocus: true,
        onKeyEvent: _handleKey,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            SizedBox(height: widget.height, child: strip),
            if (widget.showControls || widget.showPosition)
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                justify: AstryxStackJustify.between,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (widget.showControls)
                    AstryxIconButton(
                      icon: AstryxIconName.chevronLeft,
                      label: l10n.carouselPrevious,
                      tooltip: l10n.carouselPrevious,
                      variant: AstryxButtonVariant.secondary,
                      size: AstryxButtonSize.sm,
                      // Disabled at the ends rather than hidden: a control that
                      // vanishes moves the one beside it.
                      enabled: _canGoBack,
                      onPressed: () => _go(-1),
                    )
                  else
                    const SizedBox.shrink(),
                  if (widget.showPosition)
                    AstryxText(
                      position,
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      tabularNumbers: true,
                    ),
                  if (widget.showControls)
                    AstryxIconButton(
                      icon: AstryxIconName.chevronRight,
                      label: l10n.carouselNext,
                      tooltip: l10n.carouselNext,
                      variant: AstryxButtonVariant.secondary,
                      size: AstryxButtonSize.sm,
                      enabled: _canGoOn,
                      onPressed: () => _go(1),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
