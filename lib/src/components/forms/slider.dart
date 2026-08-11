/// A value chosen by dragging along a track.
library;

import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// How a [AstryxSlider] shows the value it is holding.
enum AstryxSliderValueDisplay {
  /// A bubble above the thumb while it is dragged or focused. The default.
  tooltip,

  /// A number beside the label, always visible.
  text,

  /// Nothing. For a slider whose effect is visible elsewhere.
  none,
}

/// Which way a [AstryxSlider] runs.
enum AstryxSliderOrientation {
  /// Along the reading axis. The default.
  horizontal,

  /// Bottom to top.
  vertical,
}

/// A labelled tick on a slider's track.
@immutable
class AstryxSliderMark {
  /// Creates a mark.
  const AstryxSliderMark(this.value, {this.label});

  /// Where on the scale the tick sits.
  final num value;

  /// Optional text under (or beside) the tick.
  final String? label;
}

/// A slider: one value, or a range, chosen by dragging.
///
/// {@tool snippet}
/// ```dart
/// AstryxSlider(
///   label: 'Threshold',
///   value: _threshold,
///   max: 100,
///   onChanged: (value) => setState(() => _threshold = value),
/// )
/// ```
/// {@end-tool}
///
/// [AstryxSlider.range] takes two values and keeps them in order, with
/// `minStepsBetweenThumbs` gaps between them.
///
/// A slider is the wrong control for a value that has to be exact — a port
/// number, a price. Use `AstryxNumberInput` for those, or put one beside the
/// slider: dragging is for *approximately*, and no amount of thumb precision
/// changes that.
class AstryxSlider extends StatefulWidget {
  /// Creates a single-value slider.
  const AstryxSlider({
    required this.label,
    required num this.value,
    super.key,
    ValueChanged<num>? onChanged,
    ValueChanged<num>? onChangeEnd,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.orientation = AstryxSliderOrientation.horizontal,
    this.valueDisplay = AstryxSliderValueDisplay.tooltip,
    this.marks = const <AstryxSliderMark>[],
    this.formatValue,
    this.description,
    this.status,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.length = 200,
  }) : values = null,
       minStepsBetweenThumbs = 0,
       _onSingleChanged = onChanged,
       _onSingleChangeEnd = onChangeEnd,
       _onRangeChanged = null,
       _onRangeChangeEnd = null,
       assert(min < max, 'min must be less than max'),
       assert(step > 0, 'step must be positive');

  /// Creates a two-thumb slider over a range.
  const AstryxSlider.range({
    required this.label,
    required (num, num) this.values,
    super.key,
    ValueChanged<(num, num)>? onChanged,
    ValueChanged<(num, num)>? onChangeEnd,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.minStepsBetweenThumbs = 0,
    this.orientation = AstryxSliderOrientation.horizontal,
    this.valueDisplay = AstryxSliderValueDisplay.tooltip,
    this.marks = const <AstryxSliderMark>[],
    this.formatValue,
    this.description,
    this.status,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.length = 200,
  }) : value = null,
       _onRangeChanged = onChanged,
       _onRangeChangeEnd = onChangeEnd,
       _onSingleChanged = null,
       _onSingleChangeEnd = null,
       assert(min < max, 'min must be less than max'),
       assert(step > 0, 'step must be positive');

  /// {@macro AstryxField.label}
  final String label;

  /// The value, for a single-thumb slider.
  final num? value;

  /// The two values, for [AstryxSlider.range]. In order, low then high.
  final (num, num)? values;

  /// The bottom of the scale.
  final num min;

  /// The top of the scale.
  final num max;

  /// The granularity. Every reported value is a whole number of steps from
  /// [min].
  final num step;

  /// The fewest steps that may separate the two thumbs of a range.
  final int minStepsBetweenThumbs;

  /// Which way the track runs.
  final AstryxSliderOrientation orientation;

  /// How the current value is shown.
  final AstryxSliderValueDisplay valueDisplay;

  /// Ticks along the track.
  final List<AstryxSliderMark> marks;

  /// Formats a value for display and for assistive technology.
  ///
  /// Without it a value is written plainly, and an integral one drops its `.0`.
  /// With it, a screen reader hears what a sighted user reads: "40%", "1.5 s".
  final String Function(num value)? formatValue;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// A fixed width for the whole field.
  final double? width;

  /// The track's extent along its own axis.
  ///
  /// A horizontal slider stretches to its parent and ignores this; a vertical
  /// one has nothing to stretch to, so it needs a height.
  final double length;

  final ValueChanged<num>? _onSingleChanged;
  final ValueChanged<num>? _onSingleChangeEnd;
  final ValueChanged<(num, num)>? _onRangeChanged;
  final ValueChanged<(num, num)>? _onRangeChangeEnd;

  /// Whether this slider has two thumbs.
  bool get isRange => values != null;

  @override
  State<AstryxSlider> createState() => _AstryxSliderState();
}

class _AstryxSliderState extends State<AstryxSlider> {
  final List<FocusNode> _thumbFocus = <FocusNode>[];

  /// Which thumb is being dragged.
  ///
  /// -1 rather than null while nothing is dragged: the analyser reads a
  /// never-null-assigned private field as one that wants `late`, and a `late`
  /// field with no resting value is exactly what this must not be.
  int _dragging = -1;

  @override
  void initState() {
    super.initState();
    _syncFocusNodes();
  }

  @override
  void didUpdateWidget(AstryxSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncFocusNodes();
  }

  void _syncFocusNodes() {
    final wanted = widget.isRange ? 2 : 1;
    while (_thumbFocus.length < wanted) {
      _thumbFocus.add(FocusNode(debugLabel: 'AstryxSlider thumb'));
    }
  }

  @override
  void dispose() {
    for (final node in _thumbFocus) {
      node.dispose();
    }
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled &&
      (widget.isRange
          ? widget._onRangeChanged != null || widget._onRangeChangeEnd != null
          : widget._onSingleChanged != null ||
                widget._onSingleChangeEnd != null);

  List<num> get _current => widget.isRange
      ? <num>[widget.values!.$1, widget.values!.$2]
      : <num>[widget.value!];

  /// Snaps [raw] to the step grid and clamps it into range.
  num _snap(num raw) {
    final steps = ((raw - widget.min) / widget.step).round();
    final snapped = widget.min + steps * widget.step;
    if (snapped < widget.min) return widget.min;
    if (snapped > widget.max) return widget.max;
    // A whole-number scale should not hand back 4.000000001.
    return widget.step is int && widget.min is int ? snapped.round() : snapped;
  }

  /// Where [value] sits along the track, 0 at [AstryxSlider.min].
  double _fraction(num value) =>
      ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  /// Moves thumb [index] to [raw], keeping the thumbs in order.
  void _moveTo(int index, num raw, {required bool end}) {
    if (!_interactive) return;

    final values = _current;
    var next = _snap(raw);

    if (widget.isRange) {
      final gap = widget.minStepsBetweenThumbs * widget.step;
      if (index == 0) {
        final ceiling = values[1] - gap;
        if (next > ceiling) next = ceiling;
      } else {
        final floor = values[0] + gap;
        if (next < floor) next = floor;
      }
      // The clamp above can push a thumb out of range when the gap does not
      // fit; the scale still wins.
      if (next < widget.min) next = widget.min;
      if (next > widget.max) next = widget.max;
    }

    if (next == values[index] && !end) return;
    values[index] = next;

    if (widget.isRange) {
      final pair = (values[0], values[1]);
      widget._onRangeChanged?.call(pair);
      if (end) widget._onRangeChangeEnd?.call(pair);
    } else {
      widget._onSingleChanged?.call(values[0]);
      if (end) widget._onSingleChangeEnd?.call(values[0]);
    }
  }

  /// The thumb nearest to [fraction], for a press on the track.
  int _nearestThumb(double fraction) {
    if (!widget.isRange) return 0;
    final values = _current;
    final target = widget.min + (widget.max - widget.min) * fraction;
    return (target - values[0]).abs() <= (values[1] - target).abs() ? 0 : 1;
  }

  num _valueAt(double fraction) =>
      widget.min + (widget.max - widget.min) * fraction;

  /// The fraction a local offset along the track corresponds to.
  double _fractionFor(Offset local, Size size) {
    if (widget.orientation == AstryxSliderOrientation.vertical) {
      // Bottom to top, so a low offset is a high value.
      return size.height == 0
          ? 0
          : (1 - local.dy / size.height).clamp(0.0, 1.0);
    }
    final raw = size.width == 0 ? 0.0 : local.dx / size.width;
    // The inline axis mirrors under RTL; the block axis never does.
    return (Directionality.of(context) == TextDirection.rtl ? 1 - raw : raw)
        .clamp(0.0, 1.0);
  }

  KeyEventResult _handleKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final value = _current[index];
    final page = widget.step * 10;

    final next = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowUp => value + widget.step,
      LogicalKeyboardKey.arrowDown => value - widget.step,
      LogicalKeyboardKey.arrowRight =>
        value + (rtl ? -widget.step : widget.step),
      LogicalKeyboardKey.arrowLeft =>
        value + (rtl ? widget.step : -widget.step),
      LogicalKeyboardKey.pageUp => value + page,
      LogicalKeyboardKey.pageDown => value - page,
      LogicalKeyboardKey.home => widget.min,
      LogicalKeyboardKey.end => widget.max,
      _ => null,
    };

    if (next == null) return KeyEventResult.ignored;
    // Keyboard moves are committed immediately: there is no drag to end, and a
    // consumer waiting for `onChangeEnd` would never hear about them.
    _moveTo(index, next, end: true);
    return KeyEventResult.handled;
  }

  /// How a value reads, to a person and to a screen reader.
  String _format(num value) {
    final formatter = widget.formatValue;
    if (formatter != null) return formatter(value);
    if (value is int) return '$value';
    return value == value.roundToDouble() ? '${value.toInt()}' : '$value';
  }

  String get _valueText => widget.isRange
      ? '${_format(_current[0])} – ${_format(_current[1])}'
      : _format(_current[0]);

  @override
  Widget build(BuildContext context) {
    final scope = AstryxFieldScope.maybeOf(context);
    final enabled = widget.enabled && (scope?.enabled ?? true);
    final vertical = widget.orientation == AstryxSliderOrientation.vertical;

    final track = _SliderTrack(
      state: this,
      enabled: enabled,
      vertical: vertical,
    );

    final sized = vertical
        ? SizedBox(height: widget.length, child: track)
        : track;

    return AstryxField(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: widget.valueDisplay == AstryxSliderValueDisplay.text
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Excluded: the thumbs announce the value, and a reader hearing
                // it twice learns nothing the second time.
                ExcludeSemantics(
                  child: AstryxText(
                    _valueText,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ),
                sized,
              ],
            )
          : sized,
    );
  }
}

/// The track, the filled span, the marks and the thumbs.
class _SliderTrack extends StatelessWidget {
  const _SliderTrack({
    required this.state,
    required this.enabled,
    required this.vertical,
  });

  final _AstryxSliderState state;
  final bool enabled;
  final bool vertical;

  static const double _thickness = 4;
  static const double _thumb = 16;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final widget = state.widget;
    final values = state._current;

    final trackColour = theme.color(AstryxColorToken.track);
    final fillColour = theme.color(
      enabled ? AstryxColorToken.accent : AstryxColorToken.border,
    );

    final low = widget.isRange ? state._fraction(values[0]) : 0.0;
    final high = state._fraction(values[widget.isRange ? 1 : 0]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = vertical
            ? constraints.maxHeight
            : (constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : widget.length);
        final size = vertical ? Size(_thumb, extent) : Size(extent, _thumb);

        return AstryxTapTarget(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled && state._interactive
                ? (details) {
                    final fraction = state._fractionFor(
                      details.localPosition,
                      size,
                    );
                    final index = state._nearestThumb(fraction);
                    state._thumbFocus[index].requestFocus();
                    state._moveTo(index, state._valueAt(fraction), end: true);
                  }
                : null,
            onHorizontalDragUpdate: enabled && !vertical
                ? (details) => _drag(details.localPosition, size)
                : null,
            onVerticalDragUpdate: enabled && vertical
                ? (details) => _drag(details.localPosition, size)
                : null,
            onHorizontalDragEnd: enabled && !vertical ? _endDrag : null,
            onVerticalDragEnd: enabled && vertical ? _endDrag : null,
            child: SizedBox(
              width: vertical ? _thumb : null,
              height: vertical ? null : _thumb,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  // The rail.
                  Positioned.fill(
                    child: Center(
                      child: _Rail(
                        vertical: vertical,
                        thickness: _thickness,
                        colour: trackColour,
                        radius: theme.radius(AstryxRadiusToken.full),
                      ),
                    ),
                  ),
                  // The filled span: from the low thumb to the high one, or
                  // from the start of the rail to the only thumb.
                  if (vertical)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: low * extent,
                      height: (high - low) * extent,
                      child: Center(
                        child: _Fill(
                          vertical: true,
                          thickness: _thickness,
                          colour: fillColour,
                          radius: theme.radius(AstryxRadiusToken.full),
                        ),
                      ),
                    )
                  else
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 0,
                      bottom: 0,
                      start: low * extent,
                      width: (high - low) * extent,
                      child: Center(
                        child: _Fill(
                          vertical: false,
                          thickness: _thickness,
                          colour: fillColour,
                          radius: theme.radius(AstryxRadiusToken.full),
                        ),
                      ),
                    ),
                  for (final mark in widget.marks)
                    _positioned(
                      context,
                      state._fraction(mark.value),
                      extent,
                      _Mark(
                        vertical: vertical,
                        colour: theme.color(AstryxColorToken.borderEmphasized),
                      ),
                    ),
                  for (var i = 0; i < values.length; i++)
                    _positioned(
                      context,
                      state._fraction(values[i]),
                      extent,
                      _Thumb(
                        state: state,
                        index: i,
                        enabled: enabled,
                        extent: _thumb,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _drag(Offset local, Size size) {
    final fraction = state._fractionFor(local, size);
    final index = state._dragging >= 0
        ? state._dragging
        : state._nearestThumb(fraction);
    state._dragging = index;
    state._moveTo(index, state._valueAt(fraction), end: false);
  }

  void _endDrag(DragEndDetails details) {
    final index = state._dragging;
    state._dragging = -1;
    if (index < 0) return;
    // Re-report the settled value so a consumer that only listens to the end of
    // a drag hears the value it landed on.
    state._moveTo(index, state._current[index], end: true);
  }

  /// Places [child] at [fraction] along the track.
  Widget _positioned(
    BuildContext context,
    double fraction,
    double extent,
    Widget child,
  ) {
    if (vertical) {
      return Positioned(
        bottom: fraction * extent - _thumb / 2,
        left: 0,
        right: 0,
        child: Center(child: child),
      );
    }
    // Directional, so a slider mirrors under RTL without being asked to.
    return Positioned.directional(
      textDirection: Directionality.of(context),
      start: fraction * extent - _thumb / 2,
      top: 0,
      bottom: 0,
      child: Center(child: child),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.vertical,
    required this.thickness,
    required this.colour,
    required this.radius,
  });

  final bool vertical;
  final double thickness;
  final Color colour;
  final double radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: colour,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: SizedBox(
      width: vertical ? thickness : double.infinity,
      height: vertical ? double.infinity : thickness,
    ),
  );
}

class _Fill extends StatelessWidget {
  const _Fill({
    required this.vertical,
    required this.thickness,
    required this.colour,
    required this.radius,
  });

  final bool vertical;
  final double thickness;
  final Color colour;
  final double radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: colour,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: SizedBox(
      width: vertical ? thickness : double.infinity,
      height: vertical ? double.infinity : thickness,
    ),
  );
}

class _Mark extends StatelessWidget {
  const _Mark({required this.vertical, required this.colour});

  final bool vertical;
  final Color colour;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(1),
      ),
      child: SizedBox(
        width: vertical ? 8 : 2,
        height: vertical ? 2 : 8,
      ),
    ),
  );
}

/// One draggable thumb, which is also the slider's keyboard control.
class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.state,
    required this.index,
    required this.enabled,
    required this.extent,
  });

  final _AstryxSliderState state;
  final int index;
  final bool enabled;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final widget = state.widget;
    final value = state._current[index];
    final interactive = enabled && state._interactive;

    final name = widget.isRange
        ? '${widget.label}, ${index == 0 ? 'start' : 'end'}'
        : widget.label;

    return Semantics(
      slider: true,
      label: name,
      // The formatted value, not the raw number: a screen reader should hear
      // "40%" when the page shows 40%.
      value: state._format(value),
      enabled: interactive,
      focusable: interactive,
      increasedValue: state._format(
        state._snap(value + widget.step),
      ),
      decreasedValue: state._format(
        state._snap(value - widget.step),
      ),
      onIncrease: interactive
          ? () => state._moveTo(index, value + widget.step, end: true)
          : null,
      onDecrease: interactive
          ? () => state._moveTo(index, value - widget.step, end: true)
          : null,
      child: Focus(
        focusNode: state._thumbFocus[index],
        canRequestFocus: interactive,
        onKeyEvent: (_, event) => state._handleKey(index, event),
        child: Builder(
          builder: (context) {
            final focused = Focus.of(context).hasFocus;

            return AstryxFocusRing(
              focused: focused,
              borderRadius: BorderRadius.circular(extent),
              child: AnimatedContainer(
                duration: motion.duration(AstryxDurationToken.fastMin),
                curve: motion.curve(),
                width: extent,
                height: extent,
                decoration: BoxDecoration(
                  color: theme.color(
                    enabled
                        ? AstryxColorToken.backgroundSurface
                        : AstryxColorToken.backgroundMuted,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.color(
                      enabled
                          ? AstryxColorToken.accent
                          : AstryxColorToken.border,
                    ),
                    width: theme.borderWidth() * 2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
