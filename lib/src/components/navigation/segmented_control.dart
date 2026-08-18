/// A small set of mutually exclusive views.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One segment of an [AstryxSegmentedControl].
@immutable
class AstryxSegment<T> {
  /// Creates a segment.
  const AstryxSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.labelHidden = false,
  });

  /// What choosing this segment produces.
  final T value;

  /// The visible text, and this segment's accessible name.
  final String label;

  /// An icon before the label.
  final Widget? icon;

  /// Whether this segment can be chosen.
  final bool enabled;

  /// Whether the label is a name for a screen reader only.
  ///
  /// For an icon-only control — a list-or-grid switch. Requires [icon]; a
  /// segment with neither is a segment nobody can see.
  final bool labelHidden;
}

/// A row of mutually exclusive choices, all of them visible.
///
/// **It is not tabs and it is not toggle buttons.** Tabs switch what a page
/// *shows* and belong at the top of the thing they switch; toggle buttons are
/// settings that happen to sit together. This is one choice out of a few — a
/// filter, a range, a density — and it announces itself as a radio group,
/// which is what it is.
///
/// **Keyboard behaviour follows the ARIA radiogroup pattern**: the whole
/// control is a single tab stop, the arrows move *and choose* within it and
/// wrap at both ends, and Tab leaves. That is what a set of native radios does,
/// and it has to be built by hand here.
///
/// {@tool snippet}
/// ```dart
/// AstryxSegmentedControl<Range>(
///   label: 'Range',
///   value: _range,
///   onChanged: (range) => setState(() => _range = range),
///   segments: const <AstryxSegment<Range>>[
///     AstryxSegment(value: Range.day, label: 'Day'),
///     AstryxSegment(value: Range.week, label: 'Week'),
///     AstryxSegment(value: Range.month, label: 'Month'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxTabList`, for switching a page's content.
///  * `AstryxRadioList`, for the same choice when there are more than about
///    five options, or the labels are longer than a word or two.
class AstryxSegmentedControl<T> extends StatefulWidget {
  /// Creates a segmented control.
  const AstryxSegmentedControl({
    required this.segments,
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.size = AstryxButtonSize.md,
    this.expand = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// The choices, in the order they are shown and traversed.
  final List<AstryxSegment<T>> segments;

  /// The chosen value.
  final T? value;

  /// Called with the newly chosen value. Null makes the control read-only.
  final ValueChanged<T>? onChanged;

  /// The control's accessible name — "Range", "Density".
  final String? label;

  /// The control's size.
  final AstryxButtonSize size;

  /// Whether the segments share the width equally.
  ///
  /// False hugs the labels, which is right in a toolbar. True fills the parent
  /// and gives every segment the same width, which is right above a table.
  final bool expand;

  /// The focus node for the control, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxSegmentedControl<T>> createState() =>
      _AstryxSegmentedControlState<T>();
}

class _AstryxSegmentedControlState<T> extends State<AstryxSegmentedControl<T>> {
  /// Which segment the roving focus sits on.
  int _activeIndex = 0;
  int? _hoveredIndex;
  bool _focused = false;

  bool get _interactive => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _activeIndex = _indexOfValue() ?? _firstEnabled() ?? 0;
  }

  @override
  void didUpdateWidget(AstryxSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _activeIndex = _indexOfValue() ?? _activeIndex;
    }
    if (_activeIndex >= widget.segments.length) {
      _activeIndex = _firstEnabled() ?? 0;
    }
  }

  int? _indexOfValue() {
    final index = widget.segments.indexWhere((s) => s.value == widget.value);
    return index < 0 ? null : index;
  }

  int? _firstEnabled() {
    final index = widget.segments.indexWhere((s) => s.enabled);
    return index < 0 ? null : index;
  }

  void _choose(int index) {
    final segment = widget.segments[index];
    if (!_interactive || !segment.enabled) return;
    setState(() => _activeIndex = index);
    if (segment.value != widget.value) widget.onChanged!(segment.value);
  }

  /// Moves by [delta], skipping disabled segments and wrapping.
  ///
  /// The wrap is what makes this a radio group rather than a list: the arrows
  /// cycle instead of stopping, so nobody has to reverse out of the end.
  void _move(int delta) {
    if (!_interactive) return;
    final count = widget.segments.length;
    if (count == 0) return;

    for (var step = 1; step <= count; step++) {
      final next = (_activeIndex + delta * step) % count;
      final index = next < 0 ? next + count : next;
      if (widget.segments[index].enabled) {
        _choose(index);
        return;
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Both axes, as the ARIA pattern asks: a user who does not know which way
    // the control runs will try either. The inline arrows mirror under RTL.
    final delta = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowRight => rtl ? -1 : 1,
      LogicalKeyboardKey.arrowLeft => rtl ? 1 : -1,
      LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowUp => -1,
      _ => 0,
    };

    if (delta != 0) {
      _move(delta);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _choose(_activeIndex);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final inset = theme.spacing(AstryxSpacingToken.spacing0_5);

    final segments = <Widget>[
      for (var i = 0; i < widget.segments.length; i++)
        if (widget.expand)
          Expanded(child: _segment(context, i))
        else
          // Loose, not tight: the control still hugs its labels wherever
          // there is room for them, and gives ground rather than overflowing
          // where there is not. A four-segment filter is 420 logical pixels
          // of label, which is wider than a phone — and a track that runs off
          // the edge hides the segment on the end, which is a filter nobody
          // can reach rather than a filter that looks cramped.
          Flexible(child: _segment(context, i)),
    ];

    // The track is the inset the chosen segment sits in — what makes a
    // segmented control read as one control rather than as three buttons.
    final track = Container(
      padding: EdgeInsets.all(inset),
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
      ),
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        spacing: inset,
        children: segments,
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.label,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: _interactive,
        onFocusChange: (value) {
          if (mounted) setState(() => _focused = value);
        },
        onKeyEvent: _handleKey,
        child: track,
      ),
    );
  }

  Widget _segment(BuildContext context, int index) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final segment = widget.segments[index];
    final chosen = widget.value != null && segment.value == widget.value;
    final active = index == _activeIndex;
    final hovered =
        _hoveredIndex == index &&
        segment.enabled &&
        AstryxTheme.densityOf(context).supportsHover;

    final Color background;
    if (chosen) {
      background = theme.color(AstryxColorToken.backgroundSurface);
    } else if (hovered && _interactive) {
      background = theme.color(AstryxColorToken.overlayHover);
    } else {
      background = const Color(0x00000000);
    }

    Widget content = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing3),
        vertical: theme.spacing(AstryxSpacingToken.spacing1_5),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
        boxShadow: chosen ? theme.boxShadows(AstryxShadowToken.low) : null,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(AstryxSpacingToken.spacing1_5),
        children: <Widget>[
          if (segment.icon != null)
            IconTheme.merge(
              data: IconThemeData(
                size: widget.size.iconSize,
                color: theme.color(
                  !segment.enabled
                      ? AstryxColorToken.iconDisabled
                      : chosen
                      ? AstryxColorToken.iconPrimary
                      : AstryxColorToken.iconSecondary,
                ),
              ),
              child: segment.icon!,
            ),
          if (!segment.labelHidden)
            // Flexible for the same reason the segment is: the last thing to
            // give way is the text, and it gives way by ellipsis rather than
            // by running past the track it sits in.
            Flexible(
              child: AstryxText(
                segment.label,
                type: AstryxTextType.label,
                color: !segment.enabled
                    ? AstryxTextColor.disabled
                    : chosen
                    ? AstryxTextColor.primary
                    : AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );

    content = AstryxFocusRing(
      // Only the segment the roving focus sits on rings, and only while the
      // control itself is focused.
      focused: active && _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      child: content,
    );

    return Semantics(
      container: true,
      inMutuallyExclusiveGroup: true,
      checked: chosen,
      enabled: segment.enabled,
      label: segment.label,
      onTap: segment.enabled && _interactive ? () => _choose(index) : null,
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: segment.enabled && _interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() {
            if (_hoveredIndex == index) _hoveredIndex = null;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _choose(index),
            child: AstryxTapTarget(expandHorizontally: false, child: content),
          ),
        ),
      ),
    );
  }
}
