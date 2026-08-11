/// The rows a navigation is built from.
library;

import 'package:flutter/widgets.dart';

/// One row of a navigation.
///
/// Sealed, so every walk over a navigation has to handle destinations,
/// sections and dividers alike — the compiler checks it.
///
/// The same three types feed `AstryxSideNav`, `AstryxMobileNav` and
/// `AstryxTopNav`. A list written for a rail can be handed to a bar without
/// being rewritten, which is the whole reason they share a vocabulary rather
/// than each having its own.
sealed class AstryxNavEntry {
  const AstryxNavEntry();
}

/// A destination.
class AstryxNavItem extends AstryxNavEntry {
  /// Creates a destination.
  const AstryxNavItem({
    required this.id,
    required this.label,
    this.icon,
    this.trailing,
    this.description,
    this.enabled = true,
    this.children = const <AstryxNavItem>[],
    this.panel,
  });

  /// This destination's identity, unique across the navigation.
  ///
  /// What `selectedId` matches and what `onSelected` reports, so the selection
  /// is a value the caller already has — a route name, an enum's name — rather
  /// than an index into a list it has to keep in step.
  final String id;

  /// The visible text, and this row's accessible name.
  final String label;

  /// An icon before the label.
  ///
  /// Wrap it in `AstryxNavIcon` to get the slot every other row reserves, so
  /// labels line up whether or not their neighbours have icons.
  final Widget? icon;

  /// Content at the reading-end edge — a count, a badge, a status dot.
  final Widget? trailing;

  /// Secondary text below the label. Ignored by `AstryxTopNav`, which has one
  /// line to work with.
  final String? description;

  /// Whether this destination can be chosen.
  final bool enabled;

  /// Destinations under this one.
  ///
  /// A rail indents them under their parent; a bar puts them in a menu the row
  /// opens. Same data, two presentations — which is what stops a navigation
  /// from having to be written twice.
  final List<AstryxNavItem> children;

  /// A wide panel this row opens instead of a menu — upstream's mega menu.
  ///
  /// An `AstryxTopNav` affordance: a bar has the width for a panel of featured
  /// links and a rail does not, so `AstryxSideNav` ignores it and shows
  /// [children] instead.
  final Widget? panel;

  /// Whether this row leads anywhere below itself.
  bool get hasChildren => children.isNotEmpty;
}

/// A labelled group of destinations.
class AstryxNavSection extends AstryxNavEntry {
  /// Creates a section.
  const AstryxNavSection({
    required this.label,
    this.items = const <AstryxNavItem>[],
    this.trailing,
    this.labelHidden = false,
  });

  /// The heading over the group.
  final String label;

  /// The destinations in it.
  final List<AstryxNavItem> items;

  /// Content at the trailing edge of the heading — a count, an add button.
  final Widget? trailing;

  /// Whether the heading is a name for a screen reader only.
  ///
  /// For a group that is obvious by position — the first block of a rail —
  /// where a visible heading is a word the eye has to skip but a screen reader
  /// still needs.
  final bool labelHidden;
}

/// A rule between groups of destinations.
class AstryxNavDivider extends AstryxNavEntry {
  /// Creates a divider.
  const AstryxNavDivider();
}
