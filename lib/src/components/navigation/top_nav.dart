/// A horizontal application bar.
library;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/navigation/nav_entry.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The application bar across the top of a window.
///
/// The same [AstryxNavEntry] list as `AstryxSideNav`, laid along a row instead
/// of down a column. An item with `children` opens a menu here rather than
/// indenting them, and one with a `panel` opens that panel — upstream's mega
/// menu, which a bar has the width for and a rail does not.
///
/// {@tool snippet}
/// ```dart
/// AstryxTopNav(
///   leading: const Brand(),
///   selectedId: _section,
///   onSelected: (id) => setState(() => _section = id),
///   actions: <Widget>[AccountMenu()],
///   entries: const <AstryxNavEntry>[
///     AstryxNavItem(id: 'deploys', label: 'Deploys'),
///     AstryxNavItem(
///       id: 'docs',
///       label: 'Docs',
///       children: <AstryxNavItem>[
///         AstryxNavItem(id: 'guides', label: 'Guides'),
///       ],
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxAppShell`, whose `header` this usually is.
///  * `AstryxSideNav`, the same entries as a rail.
///  * `AstryxOverflowList`, for a bar with more items than width.
class AstryxTopNav extends StatelessWidget {
  /// Creates an application bar.
  const AstryxTopNav({
    required this.entries,
    super.key,
    this.selectedId,
    this.onSelected,
    this.leading,
    this.actions = const <Widget>[],
    this.label,
    this.padding = AstryxSpacingToken.spacing3,
  });

  /// The destinations, in order.
  ///
  /// `AstryxNavSection`s become menus — a bar has no room for a heading over a
  /// group, but the group itself is exactly what a menu holds. Dividers are
  /// spacing between groups of items.
  final List<AstryxNavEntry> entries;

  /// The id of the current destination.
  final String? selectedId;

  /// Called with the id of the destination the user chose.
  final ValueChanged<String>? onSelected;

  /// Content at the reading-start edge — a logo, a product name.
  final Widget? leading;

  /// Content at the reading-end edge — search, an account menu.
  final List<Widget> actions;

  /// The bar's accessible name.
  final String? label;

  /// The inset around the bar's contents.
  final AstryxSpacingToken padding;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final gap = theme.spacing(AstryxSpacingToken.spacing1);

    final items = <Widget>[];
    for (final entry in entries) {
      switch (entry) {
        case AstryxNavItem():
          items.add(_TopNavItem(item: entry, nav: this));
        case AstryxNavSection():
          items.add(
            _TopNavItem(
              item: AstryxNavItem(
                id: entry.label,
                label: entry.label,
                children: entry.items,
              ),
              nav: this,
            ),
          );
        case AstryxNavDivider():
          items.add(
            SizedBox(width: theme.spacing(AstryxSpacingToken.spacing3)),
          );
      }
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.navLabel,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(padding),
          vertical: theme.spacing(AstryxSpacingToken.spacing2),
        ),
        child: Row(
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              SizedBox(width: theme.spacing(AstryxSpacingToken.spacing4)),
            ],
            // The destinations hug the leading edge and the actions the
            // trailing one, so adding a destination never moves the account
            // menu.
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(spacing: gap, children: items),
              ),
            ),
            const Spacer(),
            if (actions.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing(AstryxSpacingToken.spacing2),
                children: actions,
              ),
          ],
        ),
      ),
    );
  }
}

/// One destination on the bar: a row, a menu trigger, or a panel trigger.
class _TopNavItem extends StatelessWidget {
  const _TopNavItem({required this.item, required this.nav});

  final AstryxNavItem item;
  final AstryxTopNav nav;

  bool get _selected => nav.selectedId != null && nav.selectedId == item.id;

  /// The bar's own row: one line, no description, and a chevron when it opens
  /// something.
  Widget _row(
    BuildContext context, {
    VoidCallback? onPressed,
    bool open = false,
  }) {
    return AstryxItem(
      label: item.label,
      leading: item.icon,
      selected: _selected,
      enabled: item.enabled,
      density: AstryxItemDensity.compact,
      trailing: open
          ? AstryxIcon(
              AstryxIconName.chevronDown,
              size: AstryxIconSize.sm,
              color: item.enabled
                  ? AstryxIconColor.secondary
                  : AstryxIconColor.disabled,
            )
          : item.trailing,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final panel = item.panel;

    // A panel is checked first: an item given both a panel and children meant
    // the panel, which is the richer of the two.
    if (panel != null) {
      return AstryxPopover(
        label: item.label,
        content: panel,
        align: AstryxOverlayAlign.start,
        triggerBuilder: (context, controller) => IntrinsicWidth(
          child: _row(
            context,
            open: true,
            onPressed: item.enabled ? controller.toggle : null,
          ),
        ),
      );
    }

    if (item.hasChildren) {
      return AstryxDropdownMenu(
        label: item.label,
        matchTriggerWidth: false,
        entries: <AstryxMenuEntry>[
          for (final child in item.children)
            AstryxMenuItem(
              label: child.label,
              icon: child.icon,
              description: child.description,
              trailing: child.trailing,
              enabled: child.enabled && nav.onSelected != null,
              onSelected: nav.onSelected == null
                  ? null
                  : () => nav.onSelected!(child.id),
            ),
        ],
        triggerBuilder: (context, controller) => IntrinsicWidth(
          child: _row(
            context,
            open: true,
            onPressed: item.enabled ? controller.toggle : null,
          ),
        ),
      );
    }

    return IntrinsicWidth(
      child: _row(
        context,
        onPressed: nav.onSelected == null
            ? null
            : () => nav.onSelected!(item.id),
      ),
    );
  }
}
