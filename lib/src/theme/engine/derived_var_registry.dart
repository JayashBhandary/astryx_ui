/// Which theme-author properties expand into which internal component slots.
///
/// A faithful port of upstream's
/// `packages/core/src/theme/derivedVarRegistry.ts`.
///
/// Upstream, this is read by the CSS emitter to turn a standard property a
/// theme author writes — `borderRadius`, `padding` — into the private CSS
/// custom properties a component actually reads. `astryx_ui` emits no CSS, so
/// nothing consumes it in Layer 1; it is ported because it is the compiled
/// record of *which* component properties are themeable and how they fan out,
/// which the component themes in Phase 3 are built against.
///
/// Upstream's source of truth is each component's `theming.derived` doc field,
/// with a repo test guarding the two against drift. Here the guard is the
/// parity fixture, which is dumped from the upstream registry itself.
library;

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// A named expansion strategy for a derived property.
enum AstryxDerivedExpansion {
  /// Expands a padding value into the container padding tokens.
  container,
}

/// One derived-variable mapping: a theme-author property and where it lands.
@immutable
class AstryxDerivedVar {
  /// Creates a derived-variable mapping.
  ///
  /// Exactly one of [vars] and [expand] is meaningful: [vars] names the target
  /// custom properties directly, [expand] delegates to a named strategy.
  const AstryxDerivedVar({
    required this.property,
    this.vars = const <String>[],
    this.expand,
  });

  /// The standard CSS property name, in camelCase, that theme authors write.
  final String property;

  /// The internal custom property names to set. Empty when [expand] is used.
  final List<String> vars;

  /// The named expansion strategy, when the mapping is not a direct list.
  final AstryxDerivedExpansion? expand;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxDerivedVar &&
          other.property == property &&
          other.expand == expand &&
          const ListEquality<String>().equals(other.vars, vars);

  @override
  int get hashCode =>
      Object.hash(property, expand, const ListEquality<String>().hash(vars));

  @override
  String toString() =>
      'AstryxDerivedVar(property: $property, vars: $vars, expand: $expand)';
}

/// Component name to its derived-variable mappings.
///
/// Keys are the lowercase component names `defineTheme` uses. Each list is
/// ordered: when several entries share a property, earlier ones apply first.
const Map<String, List<AstryxDerivedVar>> astryxDerivedVarRegistry =
    <String, List<AstryxDerivedVar>>{
      'avatar': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'fontSize',
          vars: <String>['--_avatar-fallback-font-size'],
        ),
        AstryxDerivedVar(
          property: 'fontWeight',
          vars: <String>['--_avatar-fallback-font-weight'],
        ),
        AstryxDerivedVar(
          property: 'color',
          vars: <String>['--_avatar-fallback-color'],
        ),
        AstryxDerivedVar(
          property: 'backgroundColor',
          vars: <String>['--_avatar-fallback-background'],
        ),
      ],
      'banner': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_banner-radius'],
        ),
      ],
      'button': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_button-radius'],
        ),
      ],
      'card': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_card-radius'],
        ),
        AstryxDerivedVar(
          property: 'padding',
          expand: AstryxDerivedExpansion.container,
        ),
      ],
      'chat': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_chat-composer-radius'],
        ),
        AstryxDerivedVar(
          property: 'padding',
          vars: <String>['--_chat-composer-padding'],
        ),
      ],
      'dialog': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_dialog-radius'],
        ),
        AstryxDerivedVar(
          property: 'padding',
          expand: AstryxDerivedExpansion.container,
        ),
      ],
      'dropdown-menu': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_dropdown-menu-radius'],
        ),
        AstryxDerivedVar(
          property: 'padding',
          vars: <String>['--_dropdown-menu-padding'],
        ),
      ],
      'field': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_field-radius'],
        ),
      ],
      'hovercard': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_hovercard-radius'],
        ),
      ],
      'popover': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_popover-radius'],
        ),
      ],
      'section': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'padding',
          expand: AstryxDerivedExpansion.container,
        ),
      ],
      'segmented-control': <AstryxDerivedVar>[
        AstryxDerivedVar(
          property: 'borderRadius',
          vars: <String>['--_segmented-control-radius'],
        ),
        AstryxDerivedVar(
          property: 'padding',
          vars: <String>['--_segmented-control-padding'],
        ),
      ],
    };

/// The derived-variable entries for [component] and [property], in priority
/// order.
///
/// Returns an empty list for an unknown component or an unmapped property.
List<AstryxDerivedVar> getDerivedVars(String component, String property) {
  final entries = astryxDerivedVarRegistry[component];
  if (entries == null) return const <AstryxDerivedVar>[];
  return entries.where((e) => e.property == property).toList();
}
