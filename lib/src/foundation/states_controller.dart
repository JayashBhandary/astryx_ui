/// Interaction state, with density-aware hover.
library;

import 'package:astryx_ui/src/foundation/density.dart';
import 'package:flutter/widgets.dart';

/// Tracks a widget's interaction states.
///
/// Extends Flutter's [WidgetStatesController] with one rule: in
/// [AstryxDensity.touch], [WidgetState.hovered] is never set. Touch devices
/// generate synthetic hover events, and without this a tap leaves a control
/// looking hovered afterwards — the "sticky hover" bug. Suppressing it
/// centrally means no widget has to remember.
///
/// Widgets never keep their own `bool _hovered`. Every visual state flows
/// through here, which keeps the precedence — disabled ▸ pressed ▸ hovered ▸
/// default — in one place.
///
/// {@tool snippet}
/// ```dart
/// final controller = AstryxStatesController(density: AstryxDensity.touch);
/// controller.hovered = true;   // ignored: no hover on touch
/// controller.pressed = true;   // honoured
/// ```
/// {@end-tool}
class AstryxStatesController extends WidgetStatesController {
  /// Creates a states controller.
  AstryxStatesController({
    AstryxDensity density = AstryxDensity.pointer,
    Set<WidgetState>? value,
  }) : _density = density,
       super(_filter(value, density));

  AstryxDensity _density;

  /// The density governing whether hover is honoured.
  AstryxDensity get density => _density;

  /// Updates the density, dropping [WidgetState.hovered] if hover is no longer
  /// supported.
  ///
  /// Call this when the inherited density changes — typically from
  /// `didChangeDependencies`.
  set density(AstryxDensity value) {
    if (_density == value) return;
    _density = value;
    if (!value.supportsHover) update(WidgetState.hovered, false);
  }

  static Set<WidgetState> _filter(
    Set<WidgetState>? states,
    AstryxDensity density,
  ) {
    if (states == null) return <WidgetState>{};
    if (density.supportsHover) return states;
    return states.where((s) => s != WidgetState.hovered).toSet();
  }

  @override
  void update(WidgetState state, bool add) {
    // The one place hover is gated. Every other state passes through.
    if (state == WidgetState.hovered && add && !_density.supportsHover) return;
    super.update(state, add);
  }

  /// Whether the widget is disabled.
  bool get disabled => value.contains(WidgetState.disabled);
  set disabled(bool value) => update(WidgetState.disabled, value);

  /// Whether a pointer is over the widget.
  ///
  /// Always false in [AstryxDensity.touch].
  bool get hovered => value.contains(WidgetState.hovered);
  set hovered(bool value) => update(WidgetState.hovered, value);

  /// Whether the widget is being pressed.
  bool get pressed => value.contains(WidgetState.pressed);
  set pressed(bool value) => update(WidgetState.pressed, value);

  /// Whether the widget holds focus, however it was acquired.
  ///
  /// Whether a focus *ring* should be drawn is a different question — see
  /// `AstryxFocusVisible`.
  bool get focused => value.contains(WidgetState.focused);
  set focused(bool value) => update(WidgetState.focused, value);

  /// Whether the widget is selected.
  bool get selected => value.contains(WidgetState.selected);
  set selected(bool value) => update(WidgetState.selected, value);

  /// Whether the widget carries an error.
  bool get error => value.contains(WidgetState.error);
  set error(bool value) => update(WidgetState.error, value);

  /// Resolves [values] against the current state set.
  ///
  /// A convenience over building a `WidgetStateProperty` at every call site.
  T resolve<T>(WidgetStateProperty<T> values) => values.resolve(value);
}
