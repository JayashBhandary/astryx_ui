/// Progress through a sequence of steps, and the steps themselves.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The 4px connector, from `--spacing-1`.
const AstryxSpacingToken _barToken = AstryxSpacingToken.spacing1;

/// The 16px box every indicator occupies, from `--spacing-4`.
///
/// One box for the numbered badge, the check, the status glyph and anything a
/// caller supplies, so `auto` swapping a number for a check as a step completes
/// never nudges the label or the track.
const AstryxSpacingToken _indicatorToken = AstryxSpacingToken.spacing4;

/// Indicator (16px) plus the label-row gap (8px), from `--spacing-6`.
///
/// The indent that lines a description or a content slot up with the label
/// above it rather than with the indicator.
const AstryxSpacingToken _gutterToken = AstryxSpacingToken.spacing6;

/// Which way a stepper runs.
enum AstryxStepperOrientation {
  /// Left to right — logical, so right to left under RTL. The default.
  horizontal,

  /// Top to bottom. The orientation to reach for when steps carry content.
  vertical,
}

/// Where a step's indicator sits relative to the connector.
enum AstryxStepperIndicatorPosition {
  /// In the label row, with the connector a separate bar. The default.
  separated,

  /// Slotted into the connector as a node on the track, with the label beside
  /// it (vertical) or below it (horizontal).
  onTrack,
}

/// The vertical rhythm a stepper's steps take.
enum AstryxStepDensity {
  /// Tight, for a stepper beside other content.
  compact(AstryxSpacingToken.spacing1),

  /// The default.
  balanced(AstryxSpacingToken.spacing2),

  /// Generous, for a stepper that is the page.
  spacious(AstryxSpacingToken.spacing3);

  const AstryxStepDensity(this.padding);

  /// The padding above and below a step's label row.
  final AstryxSpacingToken padding;
}

/// A semantic colour for one step.
///
/// Mapped onto the global semantic tokens, and **colour only for the
/// indicator**: it never recolours the connector, which reports progress and
/// nothing else. This is not a lifecycle enum — whether a step is done is
/// derived from the stepper's `activeStep`, not declared here. The step the
/// flow is on keeps its current-step indicator whatever this says.
///
/// Because the glyphs are decorative, the status also reaches assistive
/// technology as words, appended to the step's accessible name.
enum AstryxStepStatus {
  /// Emphasis, in `--color-accent`. Colour only — no glyph.
  accent(AstryxColorToken.accent, AstryxColorToken.onAccent, null),

  /// Done and correct, in `--color-success`.
  success(
    AstryxColorToken.success,
    AstryxColorToken.onSuccess,
    AstryxIconName.success,
  ),

  /// Done, with something to look at, in `--color-warning`.
  warning(
    AstryxColorToken.warning,
    AstryxColorToken.onWarning,
    AstryxIconName.warning,
  ),

  /// Failed, in `--color-error`.
  error(AstryxColorToken.error, AstryxColorToken.onError, AstryxIconName.error);

  const AstryxStepStatus(this.color, this.onColor, this.icon);

  /// The token the indicator takes.
  final AstryxColorToken color;

  /// The token text on top of [color] takes.
  final AstryxColorToken onColor;

  /// The glyph `auto` shows for this status, if any.
  final AstryxIconName? icon;
}

/// What a step draws as its indicator.
enum AstryxStepIndicator {
  /// A numbered badge until the step is passed, then a check. The default.
  auto,

  /// Always a numbered badge.
  number,

  /// Nothing — the connector and the label carry the step on their own.
  none,
}

/// One step of a flow.
///
/// A description of a step rather than a widget: [AstryxStepper] takes a list
/// of these and derives each one's progress from its position, so two steps
/// cannot claim the same index — the mistake upstream has to warn about at
/// runtime cannot be written here.
@immutable
class AstryxStep {
  /// Creates a step.
  const AstryxStep({
    required this.label,
    this.description,
    this.status,
    this.enabled = true,
    this.optional = false,
    this.trailing,
    this.indicator = AstryxStepIndicator.auto,
    this.icon,
    this.content,
    this.density,
  });

  /// The step's name, and its accessible name.
  final String label;

  /// A supporting line below the label.
  final String? description;

  /// A semantic colour, and in `auto` a matching glyph.
  ///
  /// Null leaves the step coloured by its progress alone, which is the common
  /// case: a flow whose every step is coloured has told the reader nothing.
  final AstryxStepStatus? status;

  /// Whether the step can be chosen.
  ///
  /// A disabled step is still shown and still counted — it is part of the flow
  /// — it simply cannot be navigated to.
  final bool enabled;

  /// Whether the step may be skipped, which appends an "Optional" note.
  final bool optional;

  /// Content at the end of the label row — a timestamp, a badge.
  final Widget? trailing;

  /// Which indicator preset to draw. Ignored when [icon] is given.
  final AstryxStepIndicator indicator;

  /// An indicator of your own, drawn instead of the preset.
  ///
  /// Sized into the same 16px box as every other indicator, so a step with one
  /// still lines up with the steps around it.
  final Widget? icon;

  /// Content below the label — the fields of this step of a form.
  ///
  /// Vertical steppers only in practice: a horizontal step is one column of a
  /// row and has no room for it.
  final Widget? content;

  /// Overrides the stepper's density for this step.
  final AstryxStepDensity? density;
}

/// Progress through a sequence of steps.
///
/// A stepper says *where in a flow the user is*. It is not navigation: the
/// steps are the stages of one task, not the destinations of an application, so
/// it announces itself as a labelled group of steps rather than as a landmark.
///
/// {@tool snippet}
/// ```dart
/// AstryxStepper(
///   activeStep: _step,
///   steps: const <AstryxStep>[
///     AstryxStep(label: 'Account'),
///     AstryxStep(label: 'Profile', description: 'Name and photo'),
///     AstryxStep(label: 'Review'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// [activeStep] is a zero-based index. A stepper is **controlled**: it draws
/// what it is given and reports presses through [onStepPressed], which is what
/// makes a flow that validates before advancing possible.
///
/// See also:
///
///  * `AstryxProgressBar`, for a wait with a known extent but no stages.
///  * `AstryxTabList`, for switching between views rather than advancing
///    through them.
class AstryxStepper extends StatelessWidget {
  /// Creates a stepper.
  const AstryxStepper({
    required this.activeStep,
    required this.steps,
    super.key,
    this.orientation = AstryxStepperOrientation.horizontal,
    this.indicatorPosition = AstryxStepperIndicatorPosition.separated,
    this.onStepPressed,
    this.label,
    this.density = AstryxStepDensity.balanced,
  });

  /// The zero-based index of the step the flow is on.
  ///
  /// A value past the last step marks the whole flow complete, which is what a
  /// confirmation screen wants.
  final int activeStep;

  /// The steps, in order. Each one's index is its position here.
  final List<AstryxStep> steps;

  /// Which way the stepper runs.
  final AstryxStepperOrientation orientation;

  /// Where each indicator sits relative to the connector.
  final AstryxStepperIndicatorPosition indicatorPosition;

  /// Called with the index of a step the user pressed.
  ///
  /// Non-null makes every enabled step pressable — including the ones ahead,
  /// which is the free navigation a flow the user may revisit wants. Null makes
  /// the stepper a read-out.
  final ValueChanged<int>? onStepPressed;

  /// The stepper's accessible name. Defaults to a localised "Progress".
  final String? label;

  /// The vertical rhythm the steps take, unless a step overrides it.
  final AstryxStepDensity density;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final horizontal = orientation == AstryxStepperOrientation.horizontal;
    // On-track steps abut, so their segments form one continuous line. The
    // separated bars are distinct per step and take a hairline gap.
    final gap = indicatorPosition == AstryxStepperIndicatorPosition.onTrack
        ? 0.0
        : AstryxTheme.of(context).spacing(AstryxSpacingToken.spacing0_5);

    final children = <Widget>[
      for (var i = 0; i < steps.length; i++)
        _StepView(
          step: steps[i],
          index: i,
          total: steps.length,
          activeStep: activeStep,
          orientation: orientation,
          indicatorPosition: indicatorPosition,
          density: steps[i].density ?? density,
          onPressed: onStepPressed,
        ),
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.stepperLabel,
      child: horizontal
          ? Row(
              spacing: gap,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final child in children) Expanded(child: child),
              ],
            )
          : Column(
              spacing: gap,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}

/// How far the flow has got past one step.
enum _Progress {
  /// Behind the flow.
  completed,

  /// Where the flow is.
  current,

  /// Ahead of the flow.
  upcoming,
}

/// One step, in whichever of the four layouts applies.
class _StepView extends StatefulWidget {
  const _StepView({
    required this.step,
    required this.index,
    required this.total,
    required this.activeStep,
    required this.orientation,
    required this.indicatorPosition,
    required this.density,
    required this.onPressed,
  });

  final AstryxStep step;
  final int index;
  final int total;
  final int activeStep;
  final AstryxStepperOrientation orientation;
  final AstryxStepperIndicatorPosition indicatorPosition;
  final AstryxStepDensity density;
  final ValueChanged<int>? onPressed;

  @override
  State<_StepView> createState() => _StepViewState();
}

class _StepViewState extends State<_StepView> {
  bool _focused = false;

  _Progress get _progress =>
      switch (widget.index.compareTo(widget.activeStep)) {
        < 0 => _Progress.completed,
        0 => _Progress.current,
        _ => _Progress.upcoming,
      };

  bool get _pressable => widget.onPressed != null && widget.step.enabled;

  void _press() {
    if (_pressable) widget.onPressed!(widget.index);
  }

  /// The name a screen reader hears: position, label, and whatever the picture
  /// alone would have said.
  String _semanticsLabel(AstryxLocalizations l10n) {
    final step = widget.step;
    final parts = <String>[
      l10n.stepPosition(widget.index + 1, widget.total),
      step.label,
      if (step.description != null) step.description!,
      if (step.optional) l10n.stepOptional,
      if (_progress == _Progress.current)
        l10n.stepCurrent
      else if (_progress == _Progress.completed)
        l10n.stepCompleted,
      // The status glyph is decorative, so the word it stands for is said here
      // or nowhere.
      if (step.status != null && step.status != AstryxStepStatus.accent)
        step.status!.name,
    ];
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final vertical = widget.orientation == AstryxStepperOrientation.vertical;
    final onTrack =
        widget.indicatorPosition == AstryxStepperIndicatorPosition.onTrack;

    var body = onTrack
        ? _onTrack(theme, vertical: vertical)
        : _separated(theme, vertical: vertical);

    if (_pressable) {
      body = AstryxFocusRing(
        focused: _focused && AstryxFocusVisible.of(context),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
        child: body,
      );
      body = Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: (node, event) => KeyEventResult.ignored,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _press,
            child: body,
          ),
        ),
      );
    }

    return Semantics(
      button: _pressable,
      enabled: widget.step.enabled,
      selected: _progress == _Progress.current,
      label: _semanticsLabel(l10n),
      onTap: _pressable ? _press : null,
      child: ExcludeSemantics(child: body),
    );
  }

  // ---------------------------------------------------------------------------
  // Separated: the connector is a bar of its own, the indicator is in the label
  // row.
  // ---------------------------------------------------------------------------

  Widget _separated(AstryxThemeData theme, {required bool vertical}) {
    final pad = theme.spacing(widget.density.padding);
    final bar = _Connector(
      filled: widget.index <= widget.activeStep,
      vertical: vertical,
    );

    final labelBlock = Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: _labelBlock(theme, indent: true),
    );

    if (!vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          bar,
          SizedBox(height: theme.spacing(AstryxSpacingToken.spacing0_5)),
          labelBlock,
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: theme.spacing(AstryxSpacingToken.spacing0_5),
        children: <Widget>[bar, Expanded(child: labelBlock)],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // On-track: the indicator is a node in the line, and the segments either side
  // of it are the connector.
  // ---------------------------------------------------------------------------

  Widget _onTrack(AstryxThemeData theme, {required bool vertical}) {
    final pad = theme.spacing(widget.density.padding);
    final first = widget.index == 0;
    final last = widget.index == widget.total - 1;

    // The leading half fills once the flow has reached this step; the trailing
    // half only once it has passed it. That is what puts the growing edge at
    // the node the user is on.
    final lead = _Connector(
      filled: widget.index <= widget.activeStep,
      vertical: vertical,
      hidden: first,
    );
    final trail = _Connector(
      filled: widget.index < widget.activeStep,
      vertical: vertical,
      hidden: last,
    );

    final indicator = _Indicator(
      step: widget.step,
      index: widget.index,
      progress: _progress,
      theme: theme,
    );

    if (!vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: lead),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing(AstryxSpacingToken.spacing1),
                ),
                child: indicator,
              ),
              Expanded(child: trail),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: pad),
            child: _labelBlock(theme, indent: false, center: true),
          ),
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          Column(
            children: <Widget>[
              // Fixed above the node, flexible below it: the node sits at the
              // top of its step's slice however tall the step's content makes
              // that slice.
              SizedBox(height: pad, child: lead),
              indicator,
              Expanded(child: trail),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: pad),
              child: _labelBlock(theme, indent: false),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------------

  /// The label row, the description under it, and the content slot under that.
  ///
  /// [indent] draws the indicator inside the row, so the description below has
  /// to be pushed past it by the gutter. On-track layouts have the indicator on
  /// the line instead and there is nothing to clear.
  Widget _labelBlock(
    AstryxThemeData theme, {
    required bool indent,
    bool center = false,
  }) {
    final step = widget.step;
    final l10n = AstryxLocalizations.of(context);
    final gutter = indent ? theme.spacing(_gutterToken) : 0.0;

    final labelColor = switch (_progress) {
      _ when !step.enabled => AstryxTextColor.disabled,
      _Progress.upcoming => AstryxTextColor.secondary,
      _ => AstryxTextColor.primary,
    };

    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          mainAxisSize: center ? MainAxisSize.max : MainAxisSize.min,
          spacing: theme.spacing(AstryxSpacingToken.spacing2),
          children: <Widget>[
            if (indent)
              _Indicator(
                step: step,
                index: widget.index,
                progress: _progress,
                theme: theme,
              ),
            Flexible(
              child: AstryxText(
                step.label,
                color: labelColor,
                justify: center ? AstryxTextJustify.center : null,
              ),
            ),
            if (step.optional)
              AstryxText(
                // A word, not a glyph: "optional" is information, and a dot
                // beside a label is not.
                l10n.stepOptional,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ?step.trailing,
          ],
        ),
        if (step.description != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: gutter),
            child: AstryxText(
              step.description!,
              type: AstryxTextType.supporting,
              color: step.enabled
                  ? AstryxTextColor.secondary
                  : AstryxTextColor.disabled,
              justify: center ? AstryxTextJustify.center : null,
            ),
          ),
        if (step.content != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: gutter,
              top: theme.spacing(AstryxSpacingToken.spacing2),
            ),
            child: step.content,
          ),
      ],
    );
  }
}

/// A segment of the connector: the track, and the accent that grows along it.
///
/// The track never changes colour; the fill grows out of its leading edge, so
/// the line reads as progress travelling rather than as a bar changing state.
/// It paints at its final length on the first frame — a stepper that opens on
/// step three shows three filled segments rather than playing its own history
/// back at the reader.
class _Connector extends StatefulWidget {
  const _Connector({
    required this.filled,
    required this.vertical,
    this.hidden = false,
  });

  final bool filled;
  final bool vertical;

  /// Whether the segment is a spacer rather than a line — the leading half of
  /// the first node, the trailing half of the last.
  final bool hidden;

  @override
  State<_Connector> createState() => _ConnectorState();
}

class _ConnectorState extends State<_Connector> {
  /// The fill the last frame painted. Seeded from the widget's own `filled` so
  /// the first frame is the answer rather than the start of a journey to it.
  late double _from = widget.filled ? 1 : 0;

  @override
  void didUpdateWidget(_Connector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filled != widget.filled) _from = oldWidget.filled ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final thickness = theme.spacing(_barToken);
    final radius = theme.borderRadius(AstryxRadiusToken.full);

    if (widget.hidden) {
      // A zero-sized child, not an empty box: a `SizedBox` with one dimension
      // tight and the other unconstrained reports an infinite intrinsic in the
      // free axis, and the vertical layouts measure themselves with one.
      return SizedBox(
        width: widget.vertical ? thickness : null,
        height: widget.vertical ? null : thickness,
        child: const SizedBox.shrink(),
      );
    }

    return SizedBox(
      width: widget.vertical ? thickness : null,
      height: widget.vertical ? null : thickness,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.color(AstryxColorToken.border),
          borderRadius: radius,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: _from, end: widget.filled ? 1 : 0),
          duration: motion.duration(AstryxDurationToken.medium),
          curve: motion.curve(),
          // Scaled rather than sized: a fraction of a box is measured by
          // dividing by that fraction, and a segment that is 0% full would
          // report an infinite height to the row measuring it. A transform is
          // also the cheaper of the two — it repaints without relaying out.
          builder: (context, value, child) => Transform.scale(
            scaleX: widget.vertical ? 1 : value,
            scaleY: widget.vertical ? value : 1,
            alignment: widget.vertical
                ? AlignmentDirectional.topCenter
                : AlignmentDirectional.centerStart,
            child: child,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.accent),
              borderRadius: radius,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

/// The badge, the check, the status glyph, or whatever the caller supplied.
///
/// Always the same 16px box, whichever of those it is.
class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.step,
    required this.index,
    required this.progress,
    required this.theme,
  });

  final AstryxStep step;
  final int index;
  final _Progress progress;
  final AstryxThemeData theme;

  @override
  Widget build(BuildContext context) {
    final extent = theme.spacing(_indicatorToken);
    final child = _content(extent);
    return SizedBox(width: extent, height: extent, child: child);
  }

  Widget? _content(double extent) {
    if (step.icon != null) return Center(child: step.icon);
    if (step.indicator == AstryxStepIndicator.none) return null;

    final status = step.status;
    final done = progress == _Progress.completed;

    // A status glyph replaces the badge, but never on the step the flow is on:
    // that one keeps its current-step indicator whatever its status says, so
    // "where am I" survives "how did that go".
    if (step.indicator == AstryxStepIndicator.auto &&
        progress != _Progress.current &&
        status?.icon != null) {
      return Center(
        child: AstryxIcon(
          status!.icon!,
          size: AstryxIconSize.sm,
          color: step.enabled
              ? _iconColor(status)
              : AstryxIconColor.disabled,
        ),
      );
    }

    if (step.indicator == AstryxStepIndicator.auto && done) {
      return Center(
        child: AstryxIcon(
          AstryxIconName.check,
          size: AstryxIconSize.sm,
          color: step.enabled
              ? AstryxIconColor.accent
              : AstryxIconColor.disabled,
        ),
      );
    }

    return _NumberBadge(
      number: index + 1,
      progress: progress,
      status: status,
      enabled: step.enabled,
      theme: theme,
      extent: extent,
    );
  }

  AstryxIconColor _iconColor(AstryxStepStatus status) => switch (status) {
    AstryxStepStatus.accent => AstryxIconColor.accent,
    AstryxStepStatus.success => AstryxIconColor.success,
    AstryxStepStatus.warning => AstryxIconColor.warning,
    AstryxStepStatus.error => AstryxIconColor.error,
  };
}

/// The numbered badge: a filled circle once the flow has reached the step, a
/// muted one before it.
class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.number,
    required this.progress,
    required this.status,
    required this.enabled,
    required this.theme,
    required this.extent,
  });

  final int number;
  final _Progress progress;
  final AstryxStepStatus? status;
  final bool enabled;
  final AstryxThemeData theme;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final reached = progress != _Progress.upcoming;

    final Color background;
    final Color foreground;
    if (!enabled) {
      background = theme.color(AstryxColorToken.backgroundMuted);
      foreground = theme.color(AstryxColorToken.textDisabled);
    } else if (status != null && reached) {
      background = theme.color(status!.color);
      foreground = theme.color(status!.onColor);
    } else if (reached) {
      background = theme.color(AstryxColorToken.accent);
      foreground = theme.color(AstryxColorToken.onAccent);
    } else {
      background = theme.color(AstryxColorToken.backgroundMuted);
      foreground = theme.color(AstryxColorToken.textSecondary);
    }

    return Opacity(
      // Upstream dims the whole disabled indicator rather than recolouring each
      // part of it, which is what the selection controls do too.
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Center(
          child: AstryxText(
            '$number',
            // The digit has to read at the weight of the check glyph it
            // alternates with inside a 16px circle, which `body` overfills
            // once the step number reaches two digits.
            type: AstryxTextType.supporting,
            weight: AstryxTextWeight.semibold,
            style: TextStyle(color: foreground, height: 1),
          ),
        ),
      ),
    );
  }
}
