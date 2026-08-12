/// Text that arrives a piece at a time.
library;

import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Renders text as it arrives, at a steady rate.
///
/// The Flutter counterpart of upstream's `useStreamingText`. A model's output
/// does not arrive smoothly — it comes in bursts of a few tokens with pauses
/// between them — and rendering each burst the instant it lands reads as
/// stuttering. This reveals what has arrived at a constant
/// [charactersPerSecond], so the text appears to be typed rather than to
/// twitch.
///
/// Hand it the whole text you have so far on every build; it keeps track of how
/// much of that is already on screen.
///
/// {@tool snippet}
/// ```dart
/// AstryxStreamingText(
///   _answer,                 // grows as chunks arrive
///   streaming: _isStreaming, // false once the response ends
/// )
/// ```
/// {@end-tool}
///
/// **It never rewinds.** More text extends what is shown; text that is not a
/// continuation of what was shown is a rewrite rather than a stream, and is
/// swapped in whole — a caret walking backwards over a sentence is a bug nobody
/// can read past.
class AstryxStreamingText extends StatefulWidget {
  /// Creates streaming text.
  const AstryxStreamingText(
    this.text, {
    super.key,
    this.streaming = true,
    this.charactersPerSecond = 80,
    this.type = AstryxTextType.body,
    this.color = AstryxTextColor.primary,
    this.showCaret = true,
    this.semanticsLabel,
    this.onCompleted,
  }) : assert(charactersPerSecond > 0, 'charactersPerSecond must be positive');

  /// Everything that has arrived so far.
  final String text;

  /// Whether more text is still expected.
  ///
  /// Only affects the caret: the reveal is driven by [text] either way. Turning
  /// it off is what says "this is the whole answer", which a reader cannot
  /// otherwise tell from a long pause.
  final bool streaming;

  /// What a screen reader announces. Defaults to the whole of [text].
  final String? semanticsLabel;

  /// {@macro AstryxText.type}
  final AstryxTextType type;

  /// {@macro AstryxText.color}
  final AstryxTextColor color;

  /// How fast text is revealed, in characters per second.
  ///
  /// 80 by default — a little faster than a fast typist, slow enough to read
  /// along with. Under reduced motion the rate is ignored and everything that
  /// has arrived is shown at once.
  final double charactersPerSecond;

  /// Whether to draw a caret at the end while there is more to come.
  final bool showCaret;

  /// Called once the last of [text] has been revealed.
  ///
  /// Fires again if more text arrives and is caught up with, so it means "the
  /// screen matches what has arrived" rather than "the response is over".
  final VoidCallback? onCompleted;

  @override
  State<AstryxStreamingText> createState() => _AstryxStreamingTextState();
}

class _AstryxStreamingTextState extends State<AstryxStreamingText>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;

  /// How many characters are on screen.
  int _revealed = 0;

  /// The reveal count and elapsed time the current run started from.
  int _baseRevealed = 0;
  Duration _baseElapsed = Duration.zero;

  bool _reduced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = !AstryxMotion.of(context).animate;
    if (_reduced) {
      _finish();
    } else {
      _sync();
    }
  }

  @override
  void didUpdateWidget(AstryxStreamingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text == oldWidget.text) return;

    // A rewrite, not a continuation: swap it in whole rather than typing over
    // something that has already been read.
    if (!widget.text.startsWith(_shown)) {
      _revealed = widget.text.length;
      _stop();
      return;
    }

    if (_reduced) {
      _finish();
      return;
    }
    _sync();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  String get _shown => widget.text.substring(
    0,
    _revealed.clamp(0, widget.text.length),
  );

  /// Starts or stops the ticker to match how much is left.
  void _sync() {
    if (_revealed >= widget.text.length) {
      _stop();
      return;
    }
    if (_ticker != null && _ticker!.isActive) return;

    _baseRevealed = _revealed;
    _baseElapsed = Duration.zero;
    (_ticker ??= createTicker(_tick)).start();
  }

  void _tick(Duration elapsed) {
    final seconds = (elapsed - _baseElapsed).inMicroseconds / 1000000;
    final next =
        (_baseRevealed + seconds * widget.charactersPerSecond)
            .floor()
            .clamp(0, widget.text.length);

    if (next == _revealed) return;
    setState(() => _revealed = next);
    if (_revealed >= widget.text.length) _stop();
  }

  void _stop() {
    if (_ticker?.isActive ?? false) _ticker!.stop();
    widget.onCompleted?.call();
  }

  /// Reveals everything that has arrived, with no animation at all.
  void _finish() {
    _stop();
    if (_revealed == widget.text.length) return;
    _revealed = widget.text.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final complete = _revealed >= widget.text.length;
    // A caret while the stream is open, and while there is still backlog to
    // type out even after it closed.
    final caret = widget.showCaret && (widget.streaming || !complete);

    final rendered = AstryxText(
      _shown,
      type: widget.type,
      color: widget.color,
    );

    // The *whole* text is the accessible name, not the part that happens to be
    // on screen. A live region firing per token is unusable — a screen reader
    // would restart the sentence eighty times a second — so the partial text is
    // excluded and the node carries the complete string.
    return Semantics(
      container: true,
      label: widget.semanticsLabel ?? widget.text,
      liveRegion: false,
      child: ExcludeSemantics(
        child: caret
            // Wrapping rather than a flexible row: the caret follows the text
            // and drops to the next line if the last one is full, which a
            // fixed-width row cannot do without overflowing by the width of the
            // caret and its gap.
            ? AstryxHStack(
                wrap: true,
                gap: AstryxSpacingToken.spacing1,
                align: AstryxStackAlign.end,
                children: <Widget>[
                  rendered,
                  _Caret(theme: theme, type: widget.type),
                ],
              )
            : rendered,
      ),
    );
  }
}

/// The block at the end of a stream in flight.
///
/// Static rather than blinking: a blink is a second animation that would have
/// to
/// be suppressed under reduced motion, and the caret's job here is to say
/// "there
/// is more coming", which it does standing still.
class _Caret extends StatelessWidget {
  const _Caret({required this.theme, required this.type});

  final AstryxThemeData theme;
  final AstryxTextType type;

  @override
  Widget build(BuildContext context) {
    final height = theme.textStyle(type.role).fontSize ?? 14;

    return Container(
      width: 2,
      height: height,
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.textSecondary),
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      ),
    );
  }
}
