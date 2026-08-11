/// A vertical navigation rail.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/navigation/nav_entry.dart';
import 'package:astryx_ui/src/components/navigation/nav_rows.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The navigation rail beside an application's content.
///
/// **It collapses to its icons, and the labels do not disappear when it does.**
/// A collapsed row keeps its label as its accessible name and gains a tooltip
/// that shows on focus as well as hover, so a keyboard user gets what a mouse
/// user gets. A rail that hides its labels behind hover alone is a rail that
/// only works for people who can hover.
///
/// {@tool snippet}
/// ```dart
/// AstryxSideNav(
///   label: 'Sections',
///   selectedId: _section,
///   onSelected: (id) => setState(() => _section = id),
///   collapsed: _collapsed,
///   onCollapsedChanged: (value) => setState(() => _collapsed = value),
///   entries: const <AstryxNavEntry>[
///     AstryxNavItem(id: 'deploys', label: 'Deploys'),
///     AstryxNavSection(
///       label: 'Settings',
///       items: <AstryxNavItem>[
///         AstryxNavItem(id: 'members', label: 'Members'),
///       ],
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxAppShell`, which puts this beside the content and moves it into a
///    drawer when the window is narrow.
///  * `AstryxMobileNav`, the same rows in a drawer of their own.
///  * `AstryxTopNav`, the same entries as a horizontal bar.
class AstryxSideNav extends StatelessWidget {
  /// Creates a navigation rail.
  const AstryxSideNav({
    required this.entries,
    super.key,
    this.selectedId,
    this.onSelected,
    this.header,
    this.footer,
    this.collapsed = false,
    this.onCollapsedChanged,
    this.label,
    this.padding = AstryxSpacingToken.spacing2,
    this.density = AstryxItemDensity.compact,
  });

  /// The destinations, sections and dividers, in order.
  final List<AstryxNavEntry> entries;

  /// The id of the current destination.
  final String? selectedId;

  /// Called with the id of the destination the user chose.
  ///
  /// Null leaves the rows inert — for a rail that is being laid out rather than
  /// used.
  final ValueChanged<String>? onSelected;

  /// Content above the rows — a logo, an `AstryxNavHeadingMenu`.
  final Widget? header;

  /// Content pinned below the rows — an account row, a version string.
  ///
  /// Pinned, not appended: it stays at the bottom while the rows scroll, which
  /// is what makes it findable in a rail of forty destinations.
  final Widget? footer;

  /// Whether the rail shows its icons alone.
  final bool collapsed;

  /// Called when the collapse button is pressed.
  ///
  /// Null hides the button, which is right for a rail whose width is not the
  /// user's to change.
  final ValueChanged<bool>? onCollapsedChanged;

  /// The rail's accessible name — "Sections", "Main navigation".
  final String? label;

  /// The inset around the rows.
  final AstryxSpacingToken padding;

  /// The vertical rhythm the rows take.
  final AstryxItemDensity density;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final inset = theme.spacing(padding);

    final rows = AstryxNavRows(
      entries: entries,
      selectedId: selectedId,
      onSelected: onSelected,
      collapsed: collapsed,
      density: density,
    );

    final collapseButton = onCollapsedChanged == null
        ? null
        : Align(
            alignment: collapsed
                ? AlignmentDirectional.center
                : AlignmentDirectional.centerEnd,
            child: AstryxIconButton(
              icon: collapsed
                  ? AstryxIconName.chevronsRight
                  : AstryxIconName.chevronsLeft,
              label: collapsed ? l10n.navExpand : l10n.navCollapse,
              tooltip: collapsed ? l10n.navExpand : l10n.navCollapse,
              size: AstryxButtonSize.sm,
              variant: AstryxButtonVariant.ghost,
              onPressed: () => onCollapsedChanged!(!collapsed),
            ),
          );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label ?? l10n.navLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (header != null) ...<Widget>[
            Padding(padding: EdgeInsets.all(inset), child: header),
            const AstryxDivider(),
          ],
          // The rows scroll and the footer does not, so a long rail does not
          // push the account row off the bottom of the window.
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(inset),
              child: rows,
            ),
          ),
          if (footer != null || collapseButton != null) ...<Widget>[
            const AstryxDivider(),
            Padding(
              padding: EdgeInsets.all(inset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing(AstryxSpacingToken.spacing2),
                children: <Widget>[?footer, ?collapseButton],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
