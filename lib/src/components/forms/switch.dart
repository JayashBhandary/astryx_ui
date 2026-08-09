/// A switch, for a setting that takes effect immediately.
library;

import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/utils/color_mix.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A switch with a label.
///
/// Use a switch for a setting that applies the moment it is flipped, and a
/// `AstryxCheckbox` for one that applies when a form is submitted. The
/// distinction is not cosmetic: a switch that needs a Save button is a switch
/// that has lied to the user.
///
/// {@tool snippet}
/// ```dart
/// AstryxSwitch(
///   label: 'Email notifications',
///   value: _notify,
///   labelSpacing: AstryxToggleLabelSpacing.spread,
///   onChanged: (value) => setState(() => _notify = value),
/// )
/// ```
/// {@end-tool}
class AstryxSwitch extends StatefulWidget {
  /// Creates a switch.
  const AstryxSwitch({
    required this.label,
    required this.value,
    super.key,
    this.onChanged,
    this.description,
    this.status,
    this.size = AstryxToggleSize.md,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.labelHidden = false,
    this.labelPosition = AstryxToggleLabelPosition.end,
    this.labelSpacing = AstryxToggleLabelSpacing.hug,
    this.focusNode,
    this.autofocus = false,
  });

  /// The visible text, and the control's accessible name.
  final String label;

  /// Whether the switch is on.
  final bool value;

  /// Called with the state a press would produce.
  final ValueChanged<bool>? onChanged;

  /// Helper text below the label.
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The control size.
  final AstryxToggleSize size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the state is shown but cannot be changed.
  final bool readOnly;

  /// Whether a change is in flight, which shows a spinner in the thumb.
  final bool loading;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Which side the label sits on.
  final AstryxToggleLabelPosition labelPosition;

  /// Whether the row hugs its contents or spreads them.
  final AstryxToggleLabelSpacing labelSpacing;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxSwitch> createState() => _AstryxSwitchState();
}

class _AstryxSwitchState extends State<AstryxSwitch>
    with AstryxToggleStateMixin<AstryxSwitch> {
  bool get _interactive =>
      widget.enabled &&
      !widget.readOnly &&
      !widget.loading &&
      widget.onChanged != null;

  void _toggle() {
    if (!_interactive) return;
    widget.onChanged!(!widget.value);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!_interactive) return KeyEventResult.ignored;

    // Space toggles, as on a native switch. The arrow keys set an explicit
    // state rather than toggling — the ARIA switch pattern, and the behaviour
    // that lets a user hold an arrow without oscillating.
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space) {
      _toggle();
      return KeyEventResult.handled;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final target = switch (key) {
      LogicalKeyboardKey.arrowRight => !rtl,
      LogicalKeyboardKey.arrowLeft => rtl,
      _ => null,
    };
    if (target == null) return KeyEventResult.ignored;
    if (target != widget.value) widget.onChanged!(target);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final enabled = widget.enabled && (scope?.enabled ?? true);
    final status = widget.status ?? scope?.status;

    final track = _SwitchTrack(
      value: widget.value,
      size: widget.size,
      enabled: enabled,
      loading: widget.loading,
      hovered: hoverApplies(context) && _interactive,
      theme: theme,
    );

    final row = AstryxToggleRow(
      control: AstryxFocusRing(
        focused: focusVisible(context),
        borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        child: track,
      ),
      label: widget.label,
      size: widget.size,
      description: widget.description,
      labelHidden: widget.labelHidden,
      enabled: enabled,
      labelPosition: widget.labelPosition,
      labelSpacing: widget.labelSpacing,
      onTap: _toggle,
    );

    return Semantics(
      container: true,
      toggled: widget.value,
      enabled: enabled,
      label: widget.label,
      hint: _hint(scope, status),
      onTap: _interactive ? _toggle : null,
      child: ExcludeSemantics(
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          canRequestFocus: enabled,
          onFocusChange: handleFocusChange,
          onKeyEvent: _handleKey,
          child: withHover(row),
        ),
      ),
    );
  }

  String? _hint(AstryxFieldScope? scope, AstryxFieldStatus? status) {
    final parts = <String>[
      if (widget.description != null) widget.description!,
      if (status?.message != null) status!.message!,
    ];
    return parts.isEmpty ? scope?.semanticsHint : parts.join('. ');
  }
}

/// The track and the thumb that slides along it.
class _SwitchTrack extends StatelessWidget {
  const _SwitchTrack({
    required this.value,
    required this.size,
    required this.enabled,
    required this.loading,
    required this.hovered,
    required this.theme,
  });

  final bool value;
  final AstryxToggleSize size;
  final bool enabled;
  final bool loading;
  final bool hovered;
  final AstryxThemeData theme;

  /// The track's outer dimensions: 32×20 at `sm`, 40×24 at `md`.
  Size get _trackSize =>
      size == AstryxToggleSize.sm ? const Size(32, 20) : const Size(40, 24);

  /// The inset between the track's edge and the thumb.
  double get _padding => size == AstryxToggleSize.sm ? 2 : 4;

  /// The thumb grows when the switch is on — 14→16 at `sm`, 16→20 at `md`.
  ///
  /// That growth is upstream's, and it is what makes the on state legible
  /// without relying on the track colour alone.
  double get _thumbExtent => switch ((size, value)) {
    (AstryxToggleSize.sm, false) => 14,
    (AstryxToggleSize.sm, true) => 16,
    (AstryxToggleSize.md, false) => 16,
    (AstryxToggleSize.md, true) => 20,
  };

  @override
  Widget build(BuildContext context) {
    final motion = AstryxMotion.of(context);
    final duration = motion.duration(AstryxDurationToken.fast);
    final curve = motion.curve();

    final tint = theme.color(AstryxColorToken.tintHover);
    final accent = theme.color(AstryxColorToken.accent);
    final off = theme.color(AstryxColorToken.backgroundGray);

    final Color trackColor;
    if (!enabled) {
      trackColor = value ? accent : off;
    } else if (value) {
      trackColor = hovered ? astryxMixColors(accent, tint, 15) : accent;
    } else {
      trackColor = hovered ? astryxMixColors(off, tint, 5) : off;
    }

    final track = _trackSize;
    final thumb = _thumbExtent;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: track.width,
        height: track.height,
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        ),
        // `AlignmentDirectional` rather than a signed translation: the thumb
        // rests at the reading-start edge and travels toward the reading-end
        // edge, so RTL mirrors it without any arithmetic. Upstream needs a
        // negated `translateX` for the same result because flexbox and
        // transforms disagree about direction; Flutter's directional alignment
        // does not have that problem.
        alignment: value
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          width: thumb,
          height: thumb,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.color(AstryxColorToken.backgroundSurface),
            shape: BoxShape.circle,
          ),
          child: loading
              ? AstryxSpinner(
                  size: AstryxSpinnerSize.sm,
                  color: theme.color(AstryxColorToken.accent),
                )
              : null,
        ),
      ),
    );
  }
}
