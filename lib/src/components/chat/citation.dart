/// A numbered reference from generated text back to its source.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A numbered marker pointing at where an answer came from.
///
/// Upstream's `Citation`. Small, pressable, and **named for its source rather
/// than its number**: "1" is not a destination, and a screen-reader user
/// offered
/// a row of bare numerals has been given a puzzle instead of a bibliography.
///
/// {@tool snippet}
/// ```dart
/// Text.rich(
///   TextSpan(
///     children: <InlineSpan>[
///       const TextSpan(text: 'The check gives up at 30 seconds'),
///       AstryxCitation.span(1, source: 'scheduler/health.md',
///           onPressed: _open),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
class AstryxCitation extends StatefulWidget {
  /// Creates a citation marker.
  const AstryxCitation(
    this.number, {
    super.key,
    this.source,
    this.onPressed,
    this.enabled = true,
  });

  /// Puts one inside a sentence.
  ///
  /// The same widget in a `WidgetSpan`, aligned so the marker sits with the
  /// text
  /// rather than on the line below it.
  static InlineSpan span(
    int number, {
    String? source,
    VoidCallback? onPressed,
    bool enabled = true,
  }) => WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: AstryxCitation(
      number,
      source: source,
      onPressed: onPressed,
      enabled: enabled,
    ),
  );

  /// Which reference this is, as the reader counts them. One-based.
  final int number;

  /// What it points at — a file, a page title, a URL.
  ///
  /// Shown on hover and focus, and **always** part of the accessible name. A
  /// citation whose source is only reachable by pointer is a citation that does
  /// not work.
  final String? source;

  /// Called when the marker is pressed.
  final VoidCallback? onPressed;

  /// Whether the marker responds.
  final bool enabled;

  @override
  State<AstryxCitation> createState() => _AstryxCitationState();
}

class _AstryxCitationState extends State<AstryxCitation> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  bool get _interactive => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final density = AstryxTheme.densityOf(context);

    final tinted = _interactive && (_hovered && density.supportsHover);

    final marker = Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing1),
      ),
      decoration: BoxDecoration(
        color: theme.color(
          tinted
              ? AstryxColorToken.accentMuted
              : AstryxColorToken.backgroundMuted,
        ),
        borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      child: AstryxText(
        '${widget.number}',
        type: AstryxTextType.supporting,
        color: _interactive
            ? AstryxTextColor.accent
            : AstryxTextColor.secondary,
        tabularNumbers: true,
      ),
    );

    // The number is the whole visible marker, so the name has to carry the
    // rest:
    // "Source 1: scheduler/health.md" rather than "1".
    final name = widget.source == null
        ? l10n.citationLabel(widget.number)
        : l10n.citationLabelled(widget.number, widget.source!);

    Widget result = Semantics(
      container: true,
      button: _interactive,
      link: _interactive,
      enabled: widget.enabled,
      label: name,
      onTap: _interactive ? widget.onPressed : null,
      child: ExcludeSemantics(
        child: AstryxFocusRing(
          focused: _focused,
          borderRadius: theme.borderRadius(AstryxRadiusToken.full),
          child: AstryxTapTarget(
            child: MouseRegion(
              cursor: _interactive
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onTap: _interactive ? widget.onPressed : null,
                child: marker,
              ),
            ),
          ),
        ),
      ),
    );

    if (_interactive) {
      result = Focus(
        focusNode: _focusNode,
        canRequestFocus: true,
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          final key = event.logicalKey;
          if (key != LogicalKeyboardKey.enter &&
              key != LogicalKeyboardKey.numpadEnter &&
              key != LogicalKeyboardKey.space) {
            return KeyEventResult.ignored;
          }
          widget.onPressed?.call();
          return KeyEventResult.handled;
        },
        child: result,
      );
    }

    final source = widget.source;
    if (source == null) return result;

    return AstryxTooltip(
      message: source,
      // The name above already carries the source; a tooltip that repeats it
      // makes a screen reader say it twice.
      excludeFromSemantics: true,
      child: result,
    );
  }
}
