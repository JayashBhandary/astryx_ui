/// The column of rows a rail and a drawer share.
library;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/navigation/nav_entry.dart';
import 'package:astryx_ui/src/components/overlay/tooltip.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/foundation/semantics.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Renders navigation entries as a column of rows.
///
/// `AstryxSideNav` and `AstryxMobileNav` are the same list of destinations in
/// two containers — a column beside the content and a column inside a drawer —
/// so the rows themselves are written once. A rail that drifted from its own
/// drawer would be two navigations for one application.
@internal
class AstryxNavRows extends StatelessWidget {
  /// Creates the rows.
  const AstryxNavRows({
    required this.entries,
    super.key,
    this.selectedId,
    this.onSelected,
    this.collapsed = false,
    this.density = AstryxItemDensity.compact,
  });

  /// The destinations, sections and dividers, in order.
  final List<AstryxNavEntry> entries;

  /// The id of the current destination.
  final String? selectedId;

  /// Called with the id of the destination the user chose.
  final ValueChanged<String>? onSelected;

  /// Whether the rows show their icons alone.
  final bool collapsed;

  /// The vertical rhythm the rows take.
  final AstryxItemDensity density;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final rows = <Widget>[];

    for (final entry in entries) {
      switch (entry) {
        case AstryxNavItem():
          rows.add(_row(context, entry, 0));
          for (final child in entry.children) {
            rows.add(_row(context, child, 1));
          }
        case AstryxNavSection():
          rows.add(_heading(context, entry));
          for (final item in entry.items) {
            rows.add(_row(context, item, 0));
          }
        case AstryxNavDivider():
          rows.add(
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: const AstryxDivider(),
            ),
          );
      }
    }

    return Column(
      crossAxisAlignment: collapsed
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(AstryxSpacingToken.spacing0_5),
      children: rows,
    );
  }

  Widget _heading(BuildContext context, AstryxNavSection section) {
    final theme = AstryxTheme.of(context);

    // A collapsed rail has no width for a heading, and a heading nobody can
    // read is a heading that is only taking space — so it becomes a name the
    // screen reader still gets.
    if (collapsed || section.labelHidden) {
      return AstryxVisuallyHidden(
        child: AstryxText(section.label, type: AstryxTextType.label),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: theme.spacing(AstryxSpacingToken.spacing2),
        end: theme.spacing(AstryxSpacingToken.spacing2),
        top: theme.spacing(AstryxSpacingToken.spacing3),
        bottom: theme.spacing(AstryxSpacingToken.spacing1),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AstryxText(
              section.label,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
          ?section.trailing,
        ],
      ),
    );
  }

  Widget _row(BuildContext context, AstryxNavItem item, int depth) {
    final theme = AstryxTheme.of(context);
    final selected = selectedId != null && selectedId == item.id;
    final icon = item.icon;

    Widget row = AstryxItem(
      label: item.label,
      description: collapsed ? null : item.description,
      leading: icon,
      trailing: collapsed ? null : item.trailing,
      selected: selected,
      enabled: item.enabled,
      density: density,
      labelHidden: collapsed,
      onPressed: onSelected == null ? null : () => onSelected!(item.id),
    );

    if (collapsed) {
      // The label is still the accessible name; this is what puts it back
      // within reach of everyone else. `AstryxTooltip` shows on focus as well
      // as hover, so a keyboard user is not left with a column of glyphs.
      return AstryxTooltip(
        message: item.label,
        // Beside the rail rather than above the row: the sides are physical,
        // and `resolve` is what turns "away from the rail" into one of them.
        side: AstryxOverlaySide.resolve(
          AstryxOverlaySide.right,
          Directionality.of(context),
        ),
        excludeFromSemantics: true,
        child: row,
      );
    }

    if (depth > 0) {
      row = Padding(
        padding: EdgeInsetsDirectional.only(
          start: theme.spacing(AstryxSpacingToken.spacing4) * depth,
        ),
        child: row,
      );
    }

    return row;
  }
}
