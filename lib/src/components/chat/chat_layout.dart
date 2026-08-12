/// The frame of a conversation.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A scrolling transcript with a pinned composer.
///
/// A port of upstream's `ChatLayout` and `ChatLayoutScrollButton`. It owns the
/// scrolling, which is the part that is easy to get wrong in three separate
/// ways:
///
///  * **It sticks to the newest turn** while the reader is at the bottom, and
///    **does not** yank the view when they have scrolled up to re-read
///    something. A transcript that jumps as an answer streams in cannot be
///    read.
///  * The transcript is built **reversed**, so "the bottom" is offset zero.
///    Growing content therefore cannot move what is on screen — no scroll
///    correction, no post-frame `jumpTo`, none of the jitter those produce.
///  * A **jump-to-latest** button appears once the reader is away from the
///    bottom: a conversation that moved on while you were reading is otherwise
///    something you have to scroll to discover.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatLayout(
///   messages: <Widget>[
///     for (final turn in conversation) AstryxChatMessage(…),
///   ],
///   composer: AstryxChatComposer(controller: _draft, onSubmit: _send),
/// )
/// ```
/// {@end-tool}
///
/// The turns go in oldest-first, as they read. The reversal is an
/// implementation detail and never reaches the caller — or the semantics tree,
/// where the order is the reading order.
class AstryxChatLayout extends StatefulWidget {
  /// Creates a conversation frame.
  const AstryxChatLayout({
    required this.messages,
    required this.composer,
    super.key,
    this.header,
    this.empty,
    this.controller,
    this.maxWidth = 760,
    this.padding,
    this.showScrollButton = true,
    this.scrollButtonThreshold = 240,
  });

  /// The turns, oldest first.
  final List<Widget> messages;

  /// The composer, pinned below the transcript.
  final Widget composer;

  /// Content pinned above the transcript — a title, a model picker, a banner.
  final Widget? header;

  /// What to show when there are no turns yet.
  ///
  /// A conversation with nothing in it is the *first* thing most users of one
  /// see, so it is a slot rather than a blank: a heading, a line of guidance, a
  /// few suggested prompts.
  final Widget? empty;

  /// The transcript's scroll controller, if the caller owns one.
  ///
  /// Note the reversal: offset zero is the **newest** turn, and the maximum
  /// extent is the oldest.
  final ScrollController? controller;

  /// The widest the transcript and composer grow.
  ///
  /// A measure, for the same reason prose has one: a line of text 1,400 pixels
  /// wide is one nobody's eye can track back from.
  final double maxWidth;

  /// Padding around the transcript. Defaults to `--spacing-4`.
  final EdgeInsetsGeometry? padding;

  /// Whether to offer the jump-to-latest button.
  final bool showScrollButton;

  /// How far from the newest turn the button appears, in logical pixels.
  final double scrollButtonThreshold;

  @override
  State<AstryxChatLayout> createState() => _AstryxChatLayoutState();
}

class _AstryxChatLayoutState extends State<AstryxChatLayout> {
  ScrollController? _internalController;

  ScrollController get _scroll =>
      widget.controller ?? (_internalController ??= ScrollController());

  bool _away = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(AstryxChatLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleScroll);
      _scroll.addListener(_handleScroll);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleScroll);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scroll.hasClients) return;
    // Reversed, so distance from the newest turn *is* the offset.
    final away = _scroll.offset > widget.scrollButtonThreshold;
    if (away == _away || !mounted) return;
    setState(() => _away = away);
  }

  void _jumpToLatest() {
    if (!_scroll.hasClients) return;

    final motion = AstryxMotion.of(context);
    if (!motion.animate) {
      _scroll.jumpTo(0);
      return;
    }
    _scroll.animateTo(
      0,
      duration: motion.duration(AstryxDurationToken.medium),
      curve: motion.curve(),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // A frame needs a height to divide between the transcript and the
      // composer. Unbounded, the raw failure is a `RenderFlex ... incoming
      // height constraints are unbounded` from three widgets down, which says
      // nothing about what to do — so it is caught here and named.
      assert(
        constraints.hasBoundedHeight,
        'AstryxChatLayout was given an unbounded height. It divides the space '
        'it is in between the transcript and the composer, so it needs one — '
        'put it in an Expanded, a SizedBox with a height, or the body of a '
        'page rather than inside a Column that hands its children infinity.',
      );
      return _build(context);
    },
  );

  Widget _build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final gutter = theme.spacing(AstryxSpacingToken.spacing4);

    final empty = widget.messages.isEmpty && widget.empty != null;

    // No reason to build a scroller for an empty state, and every reason not
    // to: a centred welcome inside a reversed list sits at the bottom.
    Widget transcript = empty
        // Scrollable even here: an empty state with a heading, a line of
        // guidance and three suggested prompts is taller than a short window,
        // and a welcome that overflows is a worse first impression than one
        // that scrolls.
        ? SingleChildScrollView(
            padding: widget.padding ?? EdgeInsets.all(gutter),
            child: Center(child: widget.empty),
          )
        : ListView(
            controller: _scroll,
            // Reversed with reversed children: the newest turn is at offset
            // zero, so appending to a conversation cannot move what the reader
            // is looking at.
            reverse: true,
            padding: widget.padding ?? EdgeInsets.all(gutter),
            children: widget.messages.reversed.toList(),
          );

    transcript = Align(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: transcript,
      ),
    );

    if (widget.showScrollButton && !empty) {
      transcript = Stack(
        children: <Widget>[
          transcript,
          Positioned(
            bottom: gutter,
            left: 0,
            right: 0,
            child: Align(
              // Present or absent, never faded in place: a control that is
              // half-there is a control a user cannot decide about.
              child: _away
                  ? AstryxButton(
                      label: l10n.chatScrollToLatest,
                      leading: const AstryxIcon(AstryxIconName.arrowDown),
                      variant: AstryxButtonVariant.secondary,
                      size: AstryxButtonSize.sm,
                      onPressed: _jumpToLatest,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        ?widget.header,
        // The transcript takes everything left over and the composer keeps its
        // own height: a composer that grows to eight lines must eat into the
        // transcript, not off the bottom of the window.
        Expanded(child: transcript),
        Align(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: gutter,
                end: gutter,
                bottom: gutter,
              ),
              child: widget.composer,
            ),
          ),
        ),
      ],
    );
  }
}
