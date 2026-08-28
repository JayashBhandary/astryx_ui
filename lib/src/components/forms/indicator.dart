/// The stateful control visuals, as widgets in their own right.
///
/// An **indicator** is the picture a control draws for its state: the box a
/// checkbox fills, the circle a radio fills, the mark on a chosen row. Upstream
/// componentised them (`CheckboxIndicator`, `RadioIndicator`, `CheckIndicator`)
/// so a theme can restyle or replace one and every control that draws it
/// follows. The same three are here for the same reason, and for the case the
/// registry cannot cover: a row this package has no widget for — a custom
/// listbox, a menu of layer visibilities, a table cell — that must draw the
/// *same* box as a real checkbox rather than an approximation of one.
///
/// They are **decorative**. Each is hidden from assistive technology, owns no
/// role, no focus and no gesture; the control hosting one keeps all of that and
/// supplies the accessible name. An indicator turns [AstryxIndicatorState] into
/// a picture and does nothing else.
///
/// Reach for `AstryxCheckbox`, `AstryxRadioList` or `AstryxSelectableCard`
/// first: they are these visuals plus the label, the semantics, the focus ring
/// and the tap target, and hand-building those around a bare indicator is how a
/// control ends up unreachable by keyboard.
library;

import 'package:astryx_ui/src/components/forms/selection_indicator.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What an indicator is asked to draw.
///
/// One enum rather than upstream's two families. Upstream separates single from
/// multi selection so that a radio replacement cannot be handed
/// `indeterminate`; here the same guarantee comes from the widget — a
/// [AstryxRadioIndicator] given [indeterminate] asserts in debug, and there is
/// no generic registry through which a wrong pairing could arrive silently.
enum AstryxIndicatorState {
  /// Not chosen.
  unchecked,

  /// Chosen.
  checked,

  /// Partially chosen — some of what this stands for, not all of it.
  ///
  /// Multi-selection only. A radio has no picture for it.
  indeterminate;

  /// Whether the chrome reads as on, which is what fills it.
  ///
  /// Indeterminate fills too: a partially-checked parent is not an unchecked
  /// one, and the bar inside needs a filled ground to read against.
  bool get isFilled => this != AstryxIndicatorState.unchecked;
}

/// The indicator sizes, matching the control sizes of the inputs that host one.
enum AstryxIndicatorSize {
  /// A 20px control, for a dense row.
  sm(AstryxToggleSize.sm),

  /// A 24px control. The default.
  md(AstryxToggleSize.md);

  const AstryxIndicatorSize(this.toggleSize);

  /// The equivalent [AstryxToggleSize], which is what the controls take.
  final AstryxToggleSize toggleSize;

  /// The edge length of the chrome, in logical pixels.
  double get extent => AstryxToggleRow.extent(toggleSize);
}

/// The box of a checkbox: the chrome, its fill, and the mark inside it.
///
/// Draws in all three states, including [AstryxIndicatorState.indeterminate].
///
/// {@tool snippet}
/// ```dart
/// AstryxCheckboxIndicator(
///   state: selected.contains(row)
///       ? AstryxIndicatorState.checked
///       : AstryxIndicatorState.unchecked,
///   size: AstryxIndicatorSize.sm,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxCheckbox`, which is this plus the label, semantics and gesture.
class AstryxCheckboxIndicator extends StatelessWidget {
  /// Creates a checkbox indicator.
  const AstryxCheckboxIndicator({
    required this.state,
    super.key,
    this.size = AstryxIndicatorSize.md,
    this.enabled = true,
    this.hovered = false,
    this.child,
  });

  /// Which state to draw.
  final AstryxIndicatorState state;

  /// The control size.
  final AstryxIndicatorSize size;

  /// Whether the hosting control accepts input.
  ///
  /// Purely visual: the host still owns the disabled semantics.
  final bool enabled;

  /// Whether hover styling applies.
  ///
  /// The host decides, because only it knows whether the pointer is over the
  /// row or only over the box — and whether the density has hover at all. Gate
  /// it on `AstryxTheme.densityOf(context).supportsHover`.
  final bool hovered;

  /// Drawn inside the chrome *instead of* the state mark.
  ///
  /// What `AstryxCheckbox` puts a spinner in while a change is in flight.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final onAccent = theme.color(AstryxColorToken.onAccent);

    final mark =
        child ??
        switch (state) {
          AstryxIndicatorState.checked => AstryxCheckmark(
            extent: size == AstryxIndicatorSize.sm ? 12 : 14,
            color: onAccent,
          ),
          // The partial state is a bar, not a half-tick: it says "some of
          // these", and a tick at any weight says "all of these".
          AstryxIndicatorState.indeterminate => Container(
            width: size == AstryxIndicatorSize.sm ? 10 : 12,
            height: 2,
            decoration: BoxDecoration(
              color: onAccent,
              borderRadius: theme.borderRadius(AstryxRadiusToken.full),
            ),
          ),
          AstryxIndicatorState.unchecked => const SizedBox.shrink(),
        };

    return ExcludeSemantics(
      child: AstryxSelectionIndicator(
        shape: AstryxSelectionIndicatorShape.square,
        filled: state.isFilled,
        extent: size.extent,
        enabled: enabled,
        hovered: hovered,
        theme: theme,
        child: mark,
      ),
    );
  }
}

/// The circle of a radio, and the dot that grows into it.
///
/// Two states only. [AstryxIndicatorState.indeterminate] asserts in debug: a
/// radio stands for one choice out of several, and "partly this one" is not a
/// thing it can mean.
///
/// {@tool snippet}
/// ```dart
/// AstryxRadioIndicator(
///   state: value == option
///       ? AstryxIndicatorState.checked
///       : AstryxIndicatorState.unchecked,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxRadioList`, which is this plus the group, the roving focus and the
///    labels.
class AstryxRadioIndicator extends StatelessWidget {
  /// Creates a radio indicator.
  const AstryxRadioIndicator({
    required this.state,
    super.key,
    this.size = AstryxIndicatorSize.md,
    this.enabled = true,
    this.hovered = false,
    this.child,
  }) : assert(
         state != AstryxIndicatorState.indeterminate,
         'AstryxRadioIndicator has no picture for the indeterminate state. '
         'Use AstryxCheckboxIndicator where a partial state is possible.',
       );

  /// Which state to draw. Never [AstryxIndicatorState.indeterminate].
  final AstryxIndicatorState state;

  /// The control size.
  final AstryxIndicatorSize size;

  /// Whether the hosting control accepts input.
  final bool enabled;

  /// Whether hover styling applies. See [AstryxCheckboxIndicator.hovered].
  final bool hovered;

  /// Drawn inside the chrome *instead of* the dot.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final selected = state == AstryxIndicatorState.checked;
    final dot = size == AstryxIndicatorSize.sm ? 8.0 : 10.0;

    return ExcludeSemantics(
      child: AstryxSelectionIndicator(
        shape: AstryxSelectionIndicatorShape.circle,
        filled: selected,
        extent: size.extent,
        enabled: enabled,
        hovered: hovered,
        theme: theme,
        child:
            child ??
            AnimatedScale(
              // The dot grows in rather than appearing, which is the only
              // motion in the control and the only thing distinguishing the two
              // states for a user who cannot rely on the fill colour.
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
      ),
    );
  }
}

/// The mark on a chosen row: a tick when chosen, nothing when not.
///
/// The mark a menu row, a selector option or a command palette result carries,
/// where a full checkbox would be wrong — a listbox that draws an empty box
/// beside every row has turned a list of choices into a form.
///
/// Unlike the other two it draws **no chrome of its own**: it is the glyph, in
/// a reserved 16px slot so a row does not shift when the mark appears.
///
/// {@tool snippet}
/// ```dart
/// AstryxCheckIndicator(
///   state: value == option
///       ? AstryxIndicatorState.checked
///       : AstryxIndicatorState.unchecked,
/// )
/// ```
/// {@end-tool}
class AstryxCheckIndicator extends StatelessWidget {
  /// Creates a check indicator.
  const AstryxCheckIndicator({
    required this.state,
    super.key,
    this.size = AstryxIndicatorSize.md,
    this.enabled = true,
    this.child,
  }) : assert(
         state != AstryxIndicatorState.indeterminate,
         'AstryxCheckIndicator marks one chosen row and has no picture for '
         'the indeterminate state.',
       );

  /// Which state to draw. Never [AstryxIndicatorState.indeterminate].
  final AstryxIndicatorState state;

  /// The control size.
  ///
  /// The glyph is `sm` at both — this only reserves the slot, and the mark has
  /// to read at the same weight beside a dense row as a roomy one.
  final AstryxIndicatorSize size;

  /// Whether the hosting control accepts input.
  final bool enabled;

  /// Drawn in the slot *instead of* the mark — a spinner, while a change is in
  /// flight.
  final Widget? child;

  /// The slot's edge length. `AstryxIconSize.sm`, so the mark and a spinner
  /// standing in for it occupy the same box.
  static double get extent => AstryxIconSize.sm.pixels;

  @override
  Widget build(BuildContext context) {
    final checked = state == AstryxIndicatorState.checked;

    return ExcludeSemantics(
      child: SizedBox(
        width: extent,
        height: extent,
        child: Center(
          child:
              child ??
              (checked
                  ? AstryxIcon(
                      AstryxIconName.check,
                      size: AstryxIconSize.sm,
                      color: enabled
                          ? AstryxIconColor.accent
                          : AstryxIconColor.disabled,
                    )
                  // Nothing when unchecked: the slot stays, the glyph does not.
                  : const SizedBox.shrink()),
        ),
      ),
    );
  }
}
