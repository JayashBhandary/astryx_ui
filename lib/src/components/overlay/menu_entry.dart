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

/// What a menu row means when it is chosen.
///
/// Rule of thumb: a menu **performs actions**, and a row that reports a setting
/// is the exception rather than the shape to reach for. Where the choice *is*
/// the point — one value out of a list, with the current one shown — use
/// `AstryxSelector`, which announces itself as a listbox and keeps the value
/// visible on the trigger. These two roles are for the settings a menu really
/// owns: a view's density, whether a column is shown, how a list is sorted.
enum AstryxMenuItemRole {
  /// Does something. Announced as a button, and carries no state.
  action,

  /// Reports a setting that is independently on or off.
  ///
  /// Announced with `Semantics(checked:)`, and by default **leaves the menu
  /// open** so several can be toggled in one visit.
  checkbox,

  /// Reports one choice out of the rows around it.
  ///
  /// Announced with `Semantics(inMutuallyExclusiveGroup: true, checked:)`, and
  /// closes the menu on choice — the choice is made, there is nothing left to
  /// do in the menu.
  ///
  /// The group is the run of adjacent radio rows: put an [AstryxMenuDivider] or
  /// an [AstryxMenuSection] between two runs and they read as two groups.
  radio,
}

/// A selectable action, a setting, or a row that opens a submenu.
class AstryxMenuItem extends AstryxMenuEntry {
  /// Creates a menu item that performs an action.
  const AstryxMenuItem({
    required this.label,
    this.onSelected,
    this.icon,
    this.description,
    this.trailing,
    this.enabled = true,
    this.destructive = false,
    this.submenu = const <AstryxMenuEntry>[],
    this.closeOnSelect = true,
  }) : role = AstryxMenuItemRole.action,
       checked = false;

  /// Creates a row reporting a setting that is independently on or off.
  ///
  /// [checked] is the current state and [onSelected] is asked to flip it — the
  /// row is controlled, like every other selection control in this package, so
  /// nothing is toggled that the caller did not toggle.
  ///
  /// {@tool snippet}
  /// ```dart
  /// AstryxMenuItem.checkbox(
  ///   label: 'Show archived',
  ///   checked: _showArchived,
  ///   onSelected: () => setState(() => _showArchived = !_showArchived),
  /// )
  /// ```
  /// {@end-tool}
  const AstryxMenuItem.checkbox({
    required this.label,
    required this.checked,
    this.onSelected,
    this.icon,
    this.description,
    this.trailing,
    this.enabled = true,
    this.closeOnSelect = false,
  }) : role = AstryxMenuItemRole.checkbox,
       destructive = false,
       submenu = const <AstryxMenuEntry>[];

  /// Creates a row reporting one choice out of the rows around it.
  ///
  /// {@tool snippet}
  /// ```dart
  /// for (final density in AstryxTableDensity.values)
  ///   AstryxMenuItem.radio(
  ///     label: density.name,
  ///     checked: density == _density,
  ///     onSelected: () => setState(() => _density = density),
  ///   ),
  /// ```
  /// {@end-tool}
  const AstryxMenuItem.radio({
    required this.label,
    required this.checked,
    this.onSelected,
    this.icon,
    this.description,
    this.trailing,
    this.enabled = true,
    this.closeOnSelect = true,
  }) : role = AstryxMenuItemRole.radio,
       destructive = false,
       submenu = const <AstryxMenuEntry>[];

  /// The visible text, and this item's accessible name.
  final String label;

  /// Called when the item is chosen.
  ///
  /// The menu closes first, unless [closeOnSelect] is false.
  final VoidCallback? onSelected;

  /// What choosing this row means — an action, or a setting it reports.
  final AstryxMenuItemRole role;

  /// Whether the setting this row reports is currently on.
  ///
  /// Always false for [AstryxMenuItemRole.action], which reports nothing.
  final bool checked;

  /// Whether choosing the row closes the menu.
  ///
  /// True for an action and for a radio row — the thing the menu was opened for
  /// has happened. False by default for a checkbox row, so several settings can
  /// be toggled in one visit.
  final bool closeOnSelect;

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
