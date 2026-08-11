/// A group of mutually exclusive options.
library;

import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/selection_indicator.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Which way a [AstryxRadioList] runs.
enum AstryxRadioListOrientation {
  /// One option per line. The default.
  vertical,

  /// Options side by side, for two or three short labels.
  horizontal,
}

/// One option in a [AstryxRadioList].
@immutable
class AstryxRadioOption<T> {
  /// Creates an option.
  const AstryxRadioOption({
    required this.value,
    required this.label,
    this.description,
    this.enabled = true,
  });

  /// What selecting this option produces.
  final T value;

  /// The visible text, and this option's accessible name.
  final String label;

  /// Helper text below the label.
  final String? description;

  /// Whether this option can be chosen.
  final bool enabled;
}

/// A radio group: one choice among several.
///
/// **Keyboard behaviour follows the ARIA radiogroup pattern**, which is not
/// what Flutter's focus traversal does by default. The group is a single tab
/// stop; the arrow keys move *and select* within it, wrapping at both ends.
/// Tab leaves the group entirely. This is the behaviour a browser gives a set
/// of native radios for free, and it has to be built by hand here.
///
/// {@tool snippet}
/// ```dart
/// AstryxRadioList<Plan>(
///   label: 'Plan',
///   value: _plan,
///   onChanged: (plan) => setState(() => _plan = plan),
///   options: const <AstryxRadioOption<Plan>>[
///     AstryxRadioOption(value: Plan.free, label: 'Free'),
///     AstryxRadioOption(value: Plan.pro, label: 'Pro'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxCheckbox`, for independent choices.
class AstryxRadioList<T> extends StatefulWidget {
  /// Creates a radio group.
  const AstryxRadioList({
    required this.options,
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.size = AstryxToggleSize.md,
    this.orientation = AstryxRadioListOrientation.vertical,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// The options, in the order they are shown and traversed.
  final List<AstryxRadioOption<T>> options;

  /// The selected value, or null for no selection.
  final T? value;

  /// Called with the newly selected value.
  final ValueChanged<T>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The control size.
  final AstryxToggleSize size;

  /// Which way the options run.
  final AstryxRadioListOrientation orientation;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// The focus node for the group, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxRadioList<T>> createState() => _AstryxRadioListState<T>();
}

class _AstryxRadioListState<T> extends State<AstryxRadioList<T>>
    with AstryxToggleStateMixin<AstryxRadioList<T>> {
  /// Which option the roving focus sits on.
  ///
  /// Not the same as the selection: an empty group still has to put focus
  /// somewhere when it is tabbed into, and the ARIA pattern says that is the
  /// first enabled option.
  int _activeIndex = 0;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = _indexOfSelection() ?? _firstEnabled() ?? 0;
  }

  @override
  void didUpdateWidget(AstryxRadioList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _activeIndex = _indexOfSelection() ?? _activeIndex;
    }
    if (_activeIndex >= widget.options.length) {
      _activeIndex = _firstEnabled() ?? 0;
    }
  }

  int? _indexOfSelection() {
    final index = widget.options.indexWhere((o) => o.value == widget.value);
    return index < 0 ? null : index;
  }

  int? _firstEnabled() {
    final index = widget.options.indexWhere((o) => o.enabled);
    return index < 0 ? null : index;
  }

  bool get _interactive => widget.enabled && widget.onChanged != null;

  void _select(int index) {
    final option = widget.options[index];
    if (!_interactive || !option.enabled) return;
    setState(() => _activeIndex = index);
    if (option.value != widget.value) widget.onChanged!(option.value);
  }

  /// Moves selection by [delta], skipping disabled options and wrapping.
  ///
  /// The wrap is what makes this an ARIA radiogroup rather than a list: the
  /// arrow keys cycle instead of stopping, so a user never has to reverse.
  void _move(int delta) {
    if (!_interactive) return;
    final count = widget.options.length;
    if (count == 0) return;

    for (var step = 1; step <= count; step++) {
      final next = (_activeIndex + delta * step) % count;
      final index = next < 0 ? next + count : next;
      if (widget.options[index].enabled) {
        _select(index);
        return;
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Both axes work in both orientations, which is what the ARIA pattern
    // asks for and what a user who does not know which way the group runs
    // will try. The inline arrows mirror under RTL; the block arrows never do.
    final delta = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowUp => -1,
      LogicalKeyboardKey.arrowRight => rtl ? -1 : 1,
      LogicalKeyboardKey.arrowLeft => rtl ? 1 : -1,
      _ => 0,
    };

    if (delta != 0) {
      _move(delta);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      _select(_activeIndex);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final enabled = widget.enabled && (scope?.enabled ?? true);

    final items = <Widget>[
      for (var i = 0; i < widget.options.length; i++)
        _buildOption(context, theme, i, enabled),
    ];

    final gap = theme.spacing(AstryxSpacingToken.spacing2);
    final group = widget.orientation == AstryxRadioListOrientation.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: gap,
            children: items,
          )
        : Wrap(spacing: gap * 2, runSpacing: gap, children: items);

    // One tab stop for the whole group, exactly as a set of native radios
    // behaves. `skipTraversal` is not enough — the group itself must be
    // focusable so the arrow keys have somewhere to land.
    final focusable = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: enabled && _interactive,
      onFocusChange: handleFocusChange,
      onKeyEvent: _handleKey,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label ?? scope?.label,
        child: group,
      ),
    );

    if (widget.label == null) return focusable;

    return AstryxField(
      label: widget.label!,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      child: focusable,
    );
  }

  Widget _buildOption(
    BuildContext context,
    AstryxThemeData theme,
    int index,
    bool groupEnabled,
  ) {
    final option = widget.options[index];
    final selected = option.value == widget.value;
    final enabled = groupEnabled && option.enabled;
    final active = index == _activeIndex;

    final dot = _RadioDot(
      selected: selected,
      size: widget.size,
      enabled: enabled,
      hovered:
          _hoveredIndex == index &&
          enabled &&
          AstryxTheme.densityOf(context).supportsHover,
      theme: theme,
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      label: option.label,
      hint: option.description,
      onTap: enabled && _interactive ? () => _select(index) : null,
      child: ExcludeSemantics(
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() {
            if (_hoveredIndex == index) _hoveredIndex = null;
          }),
          child: AstryxToggleRow(
            control: AstryxFocusRing(
              // Only the option the roving focus sits on shows a ring, and
              // only when the group itself is focused — otherwise every
              // option would ring at once.
              focused: active && focusVisible(context),
              borderRadius: BorderRadius.circular(
                AstryxToggleRow.extent(widget.size),
              ),
              child: dot,
            ),
            label: option.label,
            size: widget.size,
            description: option.description,
            enabled: enabled,
            onTap: () => _select(index),
          ),
        ),
      ),
    );
  }
}

/// The circle and its dot.
///
/// The circle, its fill and its hover tints are
/// [AstryxSelectionIndicator]'s — shared with the checkbox and the selectable
/// card. What belongs to a radio is the dot that grows in.
class _RadioDot extends StatelessWidget {
  const _RadioDot({
    required this.selected,
    required this.size,
    required this.enabled,
    required this.hovered,
    required this.theme,
  });

  final bool selected;
  final AstryxToggleSize size;
  final bool enabled;
  final bool hovered;
  final AstryxThemeData theme;

  @override
  Widget build(BuildContext context) {
    final motion = AstryxMotion.of(context);
    final dot = size == AstryxToggleSize.sm ? 8.0 : 10.0;

    return AstryxSelectionIndicator(
      shape: AstryxSelectionIndicatorShape.circle,
      filled: selected,
      extent: AstryxToggleRow.extent(size),
      enabled: enabled,
      hovered: hovered,
      theme: theme,
      child: AnimatedScale(
        // The dot grows in rather than appearing, which is the only motion
        // in the control and the only thing distinguishing the two states
        // for a user who cannot rely on the fill colour.
        scale: selected ? 1 : 0,
        duration: motion.duration(AstryxDurationToken.fast),
        curve: motion.curve(),
        child: Container(
          width: dot,
          height: dot,
          decoration: BoxDecoration(
            color: theme.color(AstryxColorToken.onAccent),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
