/// Semantic icon names and the registry that resolves them.
library;

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The semantic icon names Astryx components ask for.
///
/// These name a *purpose*, not a picture. A component asks for
/// [AstryxIconName.close]; the theme decides what that looks like. Transcribed
/// from upstream's `IconName` union in `Icon/globalIconRegistry.tsx`.
enum AstryxIconName {
  /// Dismisses a dialog, popover, toast or token.
  close,

  /// Expands a menu or select downward.
  chevronDown,

  /// Moves to the previous item or page.
  chevronLeft,

  /// Moves to the next item or page.
  chevronRight,

  /// Jumps to the first page.
  chevronsLeft,

  /// Jumps to the last page.
  chevronsRight,

  /// Marks a checkbox, radio or menu item as selected.
  check,

  /// A successful outcome.
  success,

  /// A failed outcome or a validation error.
  error,

  /// A caution that is not yet a failure.
  warning,

  /// Neutral, informational context.
  info,

  /// A date field or picker.
  calendar,

  /// A time field or picker.
  clock,

  /// A link leaving the current context.
  externalLink,

  /// A collapsed navigation menu.
  menu,

  /// An overflow menu of further actions.
  moreHorizontal,

  /// Search or filter-by-text.
  search,

  /// Ascending sort.
  arrowUp,

  /// Descending sort.
  arrowDown,

  /// A sortable column that is not currently sorted.
  arrowsUpDown,

  /// A column or data filter.
  funnel,

  /// Hides a column or value.
  eyeSlash,

  /// Chooses which columns are visible.
  viewColumns,

  /// Copies a value to the clipboard.
  copy,

  /// Confirms a copy just happened.
  checkDouble,

  /// Settings or configuration.
  wrench,

  /// Halts an in-progress operation.
  stop,

  /// Voice input.
  microphone,
}

/// Maps semantic icon names to concrete [IconData].
///
/// Astryx core ships no icons: each theme supplies a registry, and components
/// ask the registry rather than naming an icon. Mirroring that structure means
/// a consumer who wants a different icon set swaps the registry without
/// touching component code. See ADR-005.
///
/// {@tool snippet}
/// ```dart
/// // Replace one icon, keep the rest.
/// AstryxIconRegistry.defaults.copyWith(
///   const <AstryxIconName, IconData>{
///     AstryxIconName.close: Icons.cancel,
///   },
/// );
/// ```
/// {@end-tool}
@immutable
class AstryxIconRegistry {
  /// Creates a registry from an explicit map.
  ///
  /// Names absent from [icons] resolve to null from [maybeIcon] and throw from
  /// [icon]. Prefer [AstryxIconRegistry.defaults] with [copyWith] unless you
  /// are deliberately replacing the whole set.
  const AstryxIconRegistry({required this.icons});

  /// The default registry, backed by Lucide.
  ///
  /// All seven upstream themes ship the same Lucide mapping, so this is the
  /// registry rather than one theme's — a fact checked by a test, so a future
  /// theme that diverges is caught rather than silently flattened.
  static const AstryxIconRegistry defaults = AstryxIconRegistry(
    icons: <AstryxIconName, IconData>{
      AstryxIconName.close: LucideIcons.x,
      AstryxIconName.chevronDown: LucideIcons.chevronDown,
      AstryxIconName.chevronLeft: LucideIcons.chevronLeft,
      AstryxIconName.chevronRight: LucideIcons.chevronRight,
      AstryxIconName.chevronsLeft: LucideIcons.chevronsLeft,
      AstryxIconName.chevronsRight: LucideIcons.chevronsRight,
      AstryxIconName.check: LucideIcons.check,
      AstryxIconName.success: LucideIcons.circleCheck,
      AstryxIconName.error: LucideIcons.circleX,
      AstryxIconName.warning: LucideIcons.triangleAlert,
      AstryxIconName.info: LucideIcons.info,
      AstryxIconName.calendar: LucideIcons.calendar,
      AstryxIconName.clock: LucideIcons.clock,
      AstryxIconName.externalLink: LucideIcons.externalLink,
      AstryxIconName.menu: LucideIcons.menu,
      AstryxIconName.moreHorizontal: LucideIcons.ellipsis,
      AstryxIconName.search: LucideIcons.search,
      AstryxIconName.arrowUp: LucideIcons.arrowUp,
      AstryxIconName.arrowDown: LucideIcons.arrowDown,
      AstryxIconName.arrowsUpDown: LucideIcons.arrowUpDown,
      AstryxIconName.funnel: LucideIcons.funnel,
      AstryxIconName.eyeSlash: LucideIcons.eyeOff,
      AstryxIconName.viewColumns: LucideIcons.columns3,
      AstryxIconName.copy: LucideIcons.copy,
      AstryxIconName.checkDouble: LucideIcons.checkCheck,
      AstryxIconName.wrench: LucideIcons.wrench,
      AstryxIconName.stop: LucideIcons.square,
      AstryxIconName.microphone: LucideIcons.mic,
    },
  );

  /// The mapping this registry holds.
  final Map<AstryxIconName, IconData> icons;

  /// The icon for [name].
  ///
  /// Throws a [StateError] naming the gap if the registry has none. A missing
  /// icon is a theme bug, and silently painting nothing hides it.
  IconData icon(AstryxIconName name) {
    final data = icons[name];
    if (data == null) {
      throw StateError(
        'The icon registry has no entry for ${name.name}. Add one, or build '
        'the registry from AstryxIconRegistry.defaults.copyWith(...).',
      );
    }
    return data;
  }

  /// The icon for [name], or null if the registry has none.
  IconData? maybeIcon(AstryxIconName name) => icons[name];

  /// Whether every semantic name has an icon.
  bool get isComplete => AstryxIconName.values.every(icons.containsKey);

  /// Returns a copy with [overrides] applied over this registry's entries.
  AstryxIconRegistry copyWith(Map<AstryxIconName, IconData> overrides) =>
      AstryxIconRegistry(
        icons: <AstryxIconName, IconData>{...icons, ...overrides},
      );

  /// Returns a copy with every entry of [other] applied over this one.
  ///
  /// A null [other] returns this registry unchanged, which is the common case
  /// when a theme supplies no icons of its own.
  AstryxIconRegistry merge(AstryxIconRegistry? other) =>
      other == null ? this : copyWith(other.icons);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxIconRegistry &&
          const MapEquality<AstryxIconName, IconData>().equals(
            other.icons,
            icons,
          );

  @override
  int get hashCode => const MapEquality<AstryxIconName, IconData>().hash(icons);

  @override
  String toString() => 'AstryxIconRegistry(${icons.length} icons)';
}
