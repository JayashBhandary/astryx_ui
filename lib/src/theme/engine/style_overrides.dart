/// Per-component style overrides carried on a theme.
///
/// A port of upstream's `StyleOverrides` and `ComponentStyleMap` from
/// `packages/core/src/theme/defineTheme.ts`, with one representational change.
///
/// Upstream a style override is one flat record whose values are *either* a CSS
/// value string *or*, when the key starts with `:`, a nested record for a
/// pseudo-class. Dart has no untagged unions, and `Map<String, Object>` would
/// push the type test onto every consumer. [AstryxStyleOverrides] splits the
/// two cases into named fields instead. Merge semantics are unchanged: a
/// property replaces a property, and a pseudo-class block replaces the whole
/// block, exactly as upstream's object spread does.
library;

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Component style overrides, keyed by component name then by style key.
///
/// The style key is `base` for every instance, `prop:value` for a single
/// matching visual prop, or `prop:value+prop:value` for an intersection.
typedef AstryxComponentStyleMap =
    Map<String, Map<String, AstryxStyleOverrides>>;

/// CSS property overrides for one style rule, plus any pseudo-class blocks.
///
/// {@tool snippet}
/// ```dart
/// const AstryxStyleOverrides(
///   properties: <String, String>{'borderColor': '#8F9296'},
///   pseudo: <String, Map<String, String>>{
///     ':hover': <String, String>{'borderColor': '#6E7175'},
///   },
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxStyleOverrides {
  /// Creates a set of style overrides.
  const AstryxStyleOverrides({
    this.properties = const <String, String>{},
    this.pseudo = const <String, Map<String, String>>{},
  });

  /// CSS properties in camelCase, mapped to their values.
  final Map<String, String> properties;

  /// Pseudo-class blocks, keyed by selector — `:hover`, `:focus-visible`,
  /// `:active`, `:disabled` and so on — each mapping properties to values.
  final Map<String, Map<String, String>> pseudo;

  /// Whether this carries no overrides at all.
  bool get isEmpty => properties.isEmpty && pseudo.isEmpty;

  /// Returns these overrides with every entry of [other] applied on top.
  ///
  /// Properties merge key by key. A pseudo-class block in [other] replaces the
  /// matching block wholesale rather than merging into it, matching upstream's
  /// object spread.
  AstryxStyleOverrides merge(AstryxStyleOverrides? other) {
    if (other == null) return this;
    return AstryxStyleOverrides(
      properties: <String, String>{...properties, ...other.properties},
      pseudo: <String, Map<String, String>>{...pseudo, ...other.pseudo},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxStyleOverrides &&
          const MapEquality<String, String>().equals(
            other.properties,
            properties,
          ) &&
          const DeepCollectionEquality().equals(other.pseudo, pseudo);

  @override
  int get hashCode => Object.hash(
    const MapEquality<String, String>().hash(properties),
    const DeepCollectionEquality().hash(pseudo),
  );

  @override
  String toString() =>
      'AstryxStyleOverrides(properties: $properties, pseudo: $pseudo)';
}

/// Deep-merges two component style maps, with [overrides] taking precedence.
///
/// This is what lets the type-scale-generated component rules be overridden by
/// a theme's explicit `components` entry. Returns null only when both inputs
/// are null.
AstryxComponentStyleMap? deepMergeComponents(
  AstryxComponentStyleMap? base,
  AstryxComponentStyleMap? overrides,
) {
  if (base == null && overrides == null) return null;
  if (base == null) return overrides;
  if (overrides == null) return base;

  final result = <String, Map<String, AstryxStyleOverrides>>{};

  for (final entry in base.entries) {
    result[entry.key] = <String, AstryxStyleOverrides>{...entry.value};
  }

  for (final entry in overrides.entries) {
    final existing = result[entry.key];
    if (existing == null) {
      result[entry.key] = <String, AstryxStyleOverrides>{...entry.value};
    } else {
      for (final rule in entry.value.entries) {
        final current = existing[rule.key] ?? const AstryxStyleOverrides();
        existing[rule.key] = current.merge(rule.value);
      }
    }
  }

  return result;
}
