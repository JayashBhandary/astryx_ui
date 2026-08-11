/// The rows a menu is built from.
///
/// Shared by `AstryxDropdownMenu` and `AstryxContextMenu`: the two differ only
/// in what opens them, so the row vocabulary has to be one vocabulary. A
/// consumer who has written a list of entries for a toolbar button can hand the
/// same list to a right-click target without rewriting it.
library;

import 'package:flutter/widgets.dart';

/// One row in a menu.
///
/// Sealed, so every walk over the list has to handle actions, dividers and
/// section headings alike — the compiler checks it.
sealed class AstryxMenuEntry {
  const AstryxMenuEntry();
}

/// A selectable action, or a row that opens a submenu.
class AstryxMenuItem extends AstryxMenuEntry {
  /// Creates a menu item.
  const AstryxMenuItem({
    required this.label,
    this.onSelected,
    this.icon,
    this.description,
    this.trailing,
    this.enabled = true,
    this.destructive = false,
    this.submenu = const <AstryxMenuEntry>[],
  });

  /// The visible text, and this item's accessible name.
  final String label;

  /// Called when the item is chosen. The menu closes first.
  final VoidCallback? onSelected;

  /// An icon before the label.
  ///
  /// Any widget. Pass `AstryxIcon(AstryxIconName.check)` for one of the
  /// registry's semantic names, or any other icon widget for something the
  /// registry has no name for — a consumer's menu will want "edit" and
  /// "delete", which are not in upstream's 28 (ADR-043).
  ///
  /// Size and colour come from the enclosing `IconTheme`, so an
  /// `AstryxIcon` with the default `AstryxIconColor.inherit` and a plain
  /// `Icon` both come out looking right.
  final Widget? icon;

  /// Secondary text below the label.
  final String? description;

  /// Content after the label — a shortcut hint, a badge.
  final Widget? trailing;

  /// Whether the item can be chosen.
  final bool enabled;

  /// Whether the action is irreversible, which colours it with `--color-error`.
  final bool destructive;

  /// Nested entries. A non-empty list turns this row into a submenu.
  ///
  /// Upstream models submenus the same way — an item with `items` rather than a
  /// separate row type — because a submenu row *is* an item in every respect
  /// except what happens when you choose it.
  final List<AstryxMenuEntry> submenu;

  /// Whether this row opens a submenu.
  bool get hasSubmenu => submenu.isNotEmpty;
}

/// A rule between groups of items.
class AstryxMenuDivider extends AstryxMenuEntry {
  /// Creates a divider.
  const AstryxMenuDivider();
}

/// A heading above a group of items.
class AstryxMenuSection extends AstryxMenuEntry {
  /// Creates a section heading.
  const AstryxMenuSection(this.label);

  /// The heading text.
  final String label;
}
