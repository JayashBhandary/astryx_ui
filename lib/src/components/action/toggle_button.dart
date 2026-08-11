/// The button that stays pressed, and the group that coordinates a set of them.
///
/// Upstream ships these as one file for the same reason: the button reads its
/// pressed state from the group when it is inside one, so the two halves only
/// make sense together.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/button_surface.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/components/button.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A button with a sticky on state — a setting, not an action.
///
/// A toolbar's **Bold**, a list-or-grid view switch, a filter that stays on.
/// Always a ghost button: the pressed state is the fill, so a variant of its
/// own would have nothing left to say.
///
/// Two ways to use it, and they do not mix:
///
///  * **Standalone** — supply [pressed] and [onChanged], and own the boolean.
///  * **In a group** — give it a [value] and put it in an
///    [AstryxToggleButtonGroup], which then owns which values are on. [pressed]
///    and [onChanged] are ignored, exactly as upstream ignores them.
///
/// {@tool snippet}
/// ```dart
/// AstryxToggleButton(
///   label: 'Bold',
///   icon: const AstryxIcon(AstryxIconName.bold),
///   pressed: _bold,
///   onChanged: (value) => setState(() => _bold = value),
/// )
/// ```
/// {@end-tool}
///
/// Not the widget for an on/off *setting* in a form — that is `AstryxSwitch`,
/// which is labelled, announced as a switch, and does not look like a pressed
/// button. Nor for choosing between views: that is `AstryxTabList`.
///
/// See also:
///
///  * [AstryxToggleButtonGroup], for one or several of these acting as a set.
///  * `AstryxButton`, for an action that does not stay pressed.
class AstryxToggleButton extends StatelessWidget {
  /// Creates a toggle button.
  const AstryxToggleButton({
    required this.label,
    super.key,
    this.pressed = false,
    this.onChanged,
    this.value,
    this.icon,
    this.pressedIcon,
    this.labelHidden = false,
    this.size,
    this.enabled = true,
    this.loading = false,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  });

  /// The visible text, and the accessible name.
  ///
  /// Required either way. With [labelHidden] it stops being painted and stays
  /// the name, which is the only difference — an icon-only toggle with no name
  /// announces as "button" and nothing else.
  final String label;

  /// Whether the button is on.
  ///
  /// Ignored inside an [AstryxToggleButtonGroup], which decides from its own
  /// selection and this button's [value].
  final bool pressed;

  /// Called with the state the button should move to.
  ///
  /// Null makes the button inert. Ignored inside an
  /// [AstryxToggleButtonGroup], which reports through its own callback instead.
  ///
  /// Upstream calls this `onPressedChange`; it is `onChanged` here because that
  /// is what every other stateful control in this package is called, and a
  /// widget you have to look up is worse than a name that differs from React.
  final ValueChanged<bool>? onChanged;

  /// This button's identity inside an [AstryxToggleButtonGroup].
  ///
  /// Required in a group and meaningless outside one.
  final String? value;

  /// Content before the label — usually an `AstryxIcon`.
  final Widget? icon;

  /// The icon to show while [pressed], for an outline-to-filled swap.
  ///
  /// Falls back to [icon]. Colour it by passing an already-coloured widget.
  final Widget? pressedIcon;

  /// Whether to keep [label] as the accessible name without painting it.
  ///
  /// The button becomes square, like an `AstryxIconButton`, and — unless
  /// [tooltip] says otherwise — takes the label as its tooltip, so a sighted
  /// reader who does not recognise the glyph has somewhere to look. Upstream
  /// spells this `isIconOnly`; the name here is the one the form controls
  /// already use for "keep the name, drop the text".
  final bool labelHidden;

  /// {@macro AstryxButton.size}
  ///
  /// Inside a group, the group's size applies unless this one is set.
  final AstryxButtonSize? size;

  /// {@macro AstryxButton.enabled}
  ///
  /// Inside a group the **group decides**, and this is ignored — upstream's
  /// behaviour, reproduced. Disable the group, not its children.
  final bool enabled;

  /// {@macro AstryxButton.loading}
  final bool loading;

  /// {@macro AstryxIconButton.tooltip}
  final String? tooltip;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  /// Visual overrides for this button, merged over [AstryxThemeData.button].
  final AstryxButtonTheme? theme;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);
    final group = AstryxToggleButtonGroupScope.maybeOf(context);
    final grouped = group != null;

    assert(
      !grouped || value != null,
      'A toggle button inside an AstryxToggleButtonGroup needs a value: the '
      'group has no other way to say which button is on.',
    );

    final isPressed = grouped && value != null
        ? group.selectedValues.contains(value)
        : pressed;
    // The group wins outright rather than combining, which is upstream's own
    // `group?.isDisabled ?? isDisabledProp`.
    final isEnabled = grouped ? group.enabled : enabled;

    final effectiveSize =
        size ??
        AstryxButtonSize.fromElementSize(
          AstryxSizeScope.resolve(context, group?.size?.elementSize),
        );

    // Pressed paints `--color-overlay-pressed` and keeps painting it: upstream
    // applies that background unconditionally, so a pressed toggle does not
    // change under a pointer. Reproduced rather than improved — a pressed
    // button that also lit up on hover would read as two states at once.
    final pressedFill = data.color(AstryxColorToken.overlayPressed);
    final resolvedTheme = data.button
        .merge(
          isPressed
              ? AstryxButtonTheme(
                  backgroundColor: pressedFill,
                  hoverBackgroundColor: pressedFill,
                  pressedBackgroundColor: pressedFill,
                )
              : null,
        )
        .merge(theme);

    final style = resolveAstryxButtonStyle(
      data: data,
      componentTheme: resolvedTheme,
      // Always ghost. The pressed fill is the whole visual language here.
      variant: AstryxButtonVariant.ghost,
      size: effectiveSize,
      elevation: AstryxElevation.none,
      iconOnly: labelHidden,
    );

    final interactive = isEnabled && !loading;
    final l10n = AstryxLocalizations.of(context);

    final button = AstryxButtonSurface(
      style: style,
      semanticsLabel: loading ? '$label, ${l10n.buttonLoading}' : label,
      enabled: interactive,
      squared: labelHidden,
      selected: isPressed,
      onPressed: !interactive || (!grouped && onChanged == null)
          ? null
          : () {
              if (grouped && value != null) {
                group.toggle(value!);
                return;
              }
              onChanged?.call(!isPressed);
            },
      focusNode: focusNode,
      autofocus: autofocus,
      // The surface owns the accessible name; the label below must not repeat
      // it, and the width reservation must not be read out at all.
      excludeChildSemantics: true,
      child: _ToggleButtonContent(
        label: label,
        style: style,
        pressed: isPressed,
        loading: loading,
        labelHidden: labelHidden,
        icon: isPressed ? (pressedIcon ?? icon) : icon,
      ),
    );

    // Upstream gives an icon-only toggle a tooltip from its label, because the
    // glyph is all a sighted reader has.
    final message = tooltip ?? (labelHidden ? label : null);
    if (message == null) return button;

    return AstryxTooltip(
      message: message,
      enabled: interactive,
      // The surface's own `Semantics(label:)` already carries the name.
      excludeFromSemantics: true,
      child: button,
    );
  }
}

/// The icon slot and the label, with the pressed weight shift.
class _ToggleButtonContent extends StatelessWidget {
  const _ToggleButtonContent({
    required this.label,
    required this.style,
    required this.pressed,
    required this.loading,
    required this.labelHidden,
    this.icon,
  });

  final String label;
  final ResolvedButtonStyle style;
  final bool pressed;
  final bool loading;
  final bool labelHidden;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final data = AstryxTheme.of(context);

    final slot = loading
        ? SizedBox.square(
            dimension: style.iconSize,
            child: AstryxSpinner(
              size: style.iconSize >= 20
                  ? AstryxSpinnerSize.lg
                  : AstryxSpinnerSize.md,
              shade: AstryxSpinnerShade.inherit,
              color: style.foreground,
              // The surface already announces the wait.
              label: '',
            ),
          )
        : icon;

    final iconSlot = slot == null
        ? null
        : IconTheme.merge(
            data: IconThemeData(color: style.foreground, size: style.iconSize),
            child: slot,
          );

    if (labelHidden) {
      return Center(child: iconSlot ?? const SizedBox.shrink());
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: style.gap,
      children: <Widget>[
        ?iconSlot,
        Flexible(
          child: _PressedWeightLabel(
            label: label,
            style: style,
            pressed: pressed,
            semiboldWeight: data.fontWeight(AstryxFontWeightToken.semibold),
          ),
        ),
      ],
    );
  }
}

/// The label, laid out at the width its **pressed** weight needs.
///
/// Pressing shifts the label to semibold, which is wider — so a toolbar of
/// toggles would shuffle sideways every time one was pressed.
///
/// Upstream reserves that width by rendering a second, hidden copy of the label
/// at semibold and letting the browser size the box from it. Ported literally
/// that is a `Stack` with two `Text`s, and it leaks: every toggle would answer
/// `find.text('Bold')` twice, in this package's tests and in yours. Flutter can
/// ask instead of render, so it does — one `TextPainter`, one `Text`, same
/// stable width.
class _PressedWeightLabel extends StatelessWidget {
  const _PressedWeightLabel({
    required this.label,
    required this.style,
    required this.pressed,
    required this.semiboldWeight,
  });

  final String label;
  final ResolvedButtonStyle style;
  final bool pressed;
  final FontWeight semiboldWeight;

  @override
  Widget build(BuildContext context) {
    final semibold = style.textStyle.copyWith(fontWeight: semiboldWeight);

    // Measured with the same scaler and direction the `Text` below will use, or
    // the reservation would be wrong at any text scale but 1.0.
    final painter = TextPainter(
      text: TextSpan(text: label, style: semibold),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    // Ceiling, not the raw width: a sub-pixel shortfall is enough to make the
    // pressed label ellipsize the last glyph it was measured to fit.
    final reserved = painter.size.width.ceilToDouble();
    painter.dispose();

    return SizedBox(
      width: reserved,
      child: Text(
        label,
        style: pressed ? semibold : style.textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Several [AstryxToggleButton]s acting as one control.
///
/// The group owns the selection, so its children carry a `value` rather than a
/// boolean. Which values may be on at once depends on the constructor:
///
///  * [AstryxToggleButtonGroup.single] — at most one. Pressing the one that is
///    already on turns it off, so "none" is always reachable.
///  * [AstryxToggleButtonGroup.multiple] — any number.
///
/// {@tool snippet}
/// ```dart
/// AstryxToggleButtonGroup.single(
///   label: 'View mode',
///   value: _view,
///   onChanged: (value) => setState(() => _view = value),
///   children: const <Widget>[
///     AstryxToggleButton(value: 'list', label: 'List'),
///     AstryxToggleButton(value: 'grid', label: 'Grid'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// Not a segmented control: the buttons are spaced rather than joined, and each
/// is its own tab stop. For a joined row of *actions*, see `AstryxButtonGroup`;
/// for switching between views, `AstryxTabList`.
class AstryxToggleButtonGroup extends StatelessWidget {
  /// Creates a group where at most one value is on.
  ///
  /// [value] is the one that is on, or null for none. [onChanged] receives the
  /// new value — null when the button that was on has been pressed again.
  const AstryxToggleButtonGroup.single({
    required this.label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required this.children,
    super.key,
    this.axis = Axis.horizontal,
    this.size,
    this.enabled = true,
    this.gap,
  }) : _single = value,
       _multiple = null,
       _onSingleChanged = onChanged,
       _onMultipleChanged = null;

  /// Creates a group where any number of values may be on.
  const AstryxToggleButtonGroup.multiple({
    required this.label,
    required Set<String> values,
    required ValueChanged<Set<String>> onChanged,
    required this.children,
    super.key,
    this.axis = Axis.horizontal,
    this.size,
    this.enabled = true,
    this.gap,
  }) : _multiple = values,
       _single = null,
       _onMultipleChanged = onChanged,
       _onSingleChanged = null;

  /// The group's accessible name — "View mode", "Text formatting".
  ///
  /// Required: a set of controls that belongs together has to say what it is,
  /// or a screen reader announces three unrelated buttons.
  final String label;

  /// The toggle buttons, in order.
  final List<Widget> children;

  /// Which values are currently on.
  ///
  /// A getter rather than a field so both constructors can stay `const`: a set
  /// built from a constructor argument is not a constant expression.
  Set<String> get selectedValues =>
      _multiple ?? (_single == null ? const <String>{} : <String>{_single});

  final String? _single;
  final Set<String>? _multiple;

  /// Whether the group runs horizontally or vertically.
  ///
  /// A vertical group stretches its buttons to a shared width.
  final Axis axis;

  /// The size every button takes unless it sets its own.
  final AstryxButtonSize? size;

  /// Whether the whole group accepts interaction.
  ///
  /// This is the only place to disable a grouped toggle: a child's own
  /// `enabled` is ignored inside a group.
  final bool enabled;

  /// The space between the buttons. Defaults to `--spacing-1`, as upstream.
  final AstryxSpacingToken? gap;

  final ValueChanged<String?>? _onSingleChanged;
  final ValueChanged<Set<String>>? _onMultipleChanged;

  /// Whether more than one value may be on at a time.
  bool get isMultiple => _onMultipleChanged != null;

  /// Reports the selection that pressing [value] should produce.
  void _toggle(String value) {
    final multiple = _onMultipleChanged;
    if (multiple != null) {
      multiple(
        selectedValues.contains(value)
            ? (<String>{...selectedValues}..remove(value))
            : <String>{...selectedValues, value},
      );
      return;
    }
    // Pressing the one that is already on clears the group.
    _onSingleChanged?.call(
      selectedValues.contains(value) ? null : value,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final data = AstryxTheme.of(context);
    final spacing = data.spacing(gap ?? AstryxSpacingToken.spacing1);

    final scope = AstryxToggleButtonGroupScope(
      selectedValues: selectedValues,
      toggle: _toggle,
      size: size,
      enabled: enabled,
      child: axis == Axis.vertical
          // `IntrinsicWidth` bounds the width so stretch is legal — the same
          // reason `AstryxButtonGroup` needs it for a vertical group.
          ? IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: spacing,
                children: children,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              spacing: spacing,
              children: children,
            ),
    );

    return Semantics(
      container: true,
      label: label,
      // The buttons keep their own nodes: each is separately focusable and
      // separately pressed, so flattening them into the group would lose which
      // of them is on.
      explicitChildNodes: true,
      child: scope,
    );
  }
}

/// Carries a group's selection and defaults down to its buttons.
///
/// The port of upstream's `ToggleButtonGroupContext`.
class AstryxToggleButtonGroupScope extends InheritedWidget {
  /// Creates a toggle button group scope.
  const AstryxToggleButtonGroupScope({
    required super.child,
    required this.selectedValues,
    required this.toggle,
    super.key,
    this.size,
    this.enabled = true,
  });

  /// The values currently on.
  final Set<String> selectedValues;

  /// Reports that a button's value has been pressed.
  final void Function(String value) toggle;

  /// The size every button in the group takes unless it sets its own.
  final AstryxButtonSize? size;

  /// Whether the group accepts interaction.
  final bool enabled;

  /// The group at [context], or null outside one.
  static AstryxToggleButtonGroupScope? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AstryxToggleButtonGroupScope>();

  @override
  bool updateShouldNotify(AstryxToggleButtonGroupScope oldWidget) =>
      enabled != oldWidget.enabled ||
      size != oldWidget.size ||
      toggle != oldWidget.toggle ||
      !setEquals(selectedValues, oldWidget.selectedValues);
}
