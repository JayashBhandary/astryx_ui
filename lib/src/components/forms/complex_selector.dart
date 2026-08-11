/// A selector whose surface the caller supplies.
library;

import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// What a [AstryxComplexSelector]'s builder is given.
@immutable
class AstryxComplexSelectorState<T> {
  /// Creates the builder's argument.
  const AstryxComplexSelectorState({
    required this.value,
    required this.onChanged,
    required this.close,
  });

  /// The value the selector currently holds.
  final T value;

  /// Reports a new value. Does **not** close the surface — a multi-step picker
  /// wants to stay open, so closing is a separate decision.
  final ValueChanged<T> onChanged;

  /// Closes the surface and returns focus to the trigger.
  final VoidCallback close;
}

/// A selector with a trigger this package draws and a surface you draw.
///
/// `AstryxSelector` covers a list of options; this covers everything else — a
/// calendar, a two-pane picker, a tree, a form inside a popover. It provides
/// the parts that are tedious and easy to get wrong (the field, the trigger and
/// its status, the overlay, focus trapping, Escape, the barrier) and leaves the
/// contents entirely to you.
///
/// {@tool snippet}
/// ```dart
/// AstryxComplexSelector<DateTimeRange?>(
///   label: 'Period',
///   value: _period,
///   triggerLabel: _period == null ? null : Text(describe(_period!)),
///   onChanged: (value) => setState(() => _period = value),
///   surfaceBuilder: (context, state) => MyRangeCalendar(
///     range: state.value,
///     onPicked: (range) {
///       state.onChanged(range);
///       state.close();
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// Upstream passes `(value, onChange, close, state)` to a render prop; this
/// passes one [AstryxComplexSelectorState], because four positional arguments
/// in a builder is a call site nobody can read.
class AstryxComplexSelector<T> extends StatefulWidget {
  /// Creates a complex selector.
  const AstryxComplexSelector({
    required this.label,
    required this.value,
    required this.surfaceBuilder,
    super.key,
    this.onChanged,
    this.triggerLabel,
    this.placeholder,
    this.description,
    this.status,
    this.size,
    this.enabled = true,
    this.loading = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.side = AstryxOverlaySide.bottom,
    this.align = AstryxOverlayAlign.start,
    this.matchTriggerWidth = true,
    this.surfaceWidth,
    this.width,
    this.focusNode,
    this.autofocus = false,
  });

  /// {@macro AstryxField.label}
  final String label;

  /// The value the selector holds. Handed to [surfaceBuilder] unchanged.
  final T value;

  /// Builds the surface inside the overlay.
  final Widget Function(
    BuildContext context,
    AstryxComplexSelectorState<T> state,
  )
  surfaceBuilder;

  /// Called with a new value. Null makes the selector inert.
  final ValueChanged<T>? onChanged;

  /// What the trigger shows. Null shows [placeholder].
  ///
  /// A widget rather than a string, because the point of this component is that
  /// a value may not be describable in one: two dates, a coloured swatch, a row
  /// of avatars.
  final Widget? triggerLabel;

  /// The trigger text when there is nothing to show. Defaults to "Select…".
  final String? placeholder;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The trigger height.
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the value is being fetched. Shows a spinner in the trigger.
  final bool loading;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Which side of the trigger the surface opens on.
  final AstryxOverlaySide side;

  /// How the surface lines up with the trigger.
  final AstryxOverlayAlign align;

  /// Whether the surface takes the trigger's width.
  final bool matchTriggerWidth;

  /// A fixed width for the surface. Ignored when [matchTriggerWidth].
  final double? surfaceWidth;

  /// A fixed width for the whole field.
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  @override
  State<AstryxComplexSelector<T>> createState() =>
      _AstryxComplexSelectorState<T>();
}

class _AstryxComplexSelectorState<T> extends State<AstryxComplexSelector<T>> {
  final AstryxOverlayController _overlay = AstryxOverlayController();
  bool _open = false;

  @override
  void dispose() {
    _overlay.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.loading && widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final status = widget.status ?? scope?.status;
    final size = resolveAstryxInputSize(context, widget.size);
    final enabled = widget.enabled && (scope?.enabled ?? true);

    final selector = AstryxPopover(
      controller: _overlay,
      label: widget.label,
      side: widget.side,
      align: widget.align,
      matchTriggerWidth: widget.matchTriggerWidth,
      width: widget.matchTriggerWidth ? null : widget.surfaceWidth,
      onOpenChange: (open) {
        if (mounted) setState(() => _open = open);
      },
      content: Builder(
        builder: (context) => widget.surfaceBuilder(
          context,
          AstryxComplexSelectorState<T>(
            value: widget.value,
            onChanged: (value) => widget.onChanged?.call(value),
            close: _overlay.hide,
          ),
        ),
      ),
      triggerBuilder: (context, controller) => AstryxInputContainer(
        // The trigger is a button, not a text field, so the focus ring comes
        // from the popover's own trigger rather than from a caret being here.
        focused: _open,
        size: size,
        status: status,
        enabled: enabled && !widget.loading,
        onTap: _interactive ? controller.toggle : null,
        trailing: widget.loading
            ? AstryxSpinner(
                size: AstryxSpinnerSize.sm,
                label: l10n.buttonLoading,
              )
            : const AstryxIcon(
                AstryxIconName.chevronDown,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
        child:
            widget.triggerLabel ??
            AstryxText(
              widget.placeholder ?? l10n.selectorPlaceholder,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
      ),
    );

    return AstryxField(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: Semantics(
        container: true,
        button: true,
        label: widget.label,
        enabled: _interactive,
        expanded: _open,
        onTap: _interactive ? _overlay.toggle : null,
        child: selector,
      ),
    );
  }
}
