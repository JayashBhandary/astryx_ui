/// A vertical list of rows.
library;

import 'dart:ui' show SemanticsRole;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A stack of rows, separated and spaced consistently.
///
/// Upstream ships `List` and `ListItem`; the item here is [AstryxItem], which
/// is also usable on its own, so this widget is only the container: the
/// dividers, the density every row inherits, and the `list` role a screen
/// reader needs to say "list, 5 items" before reading the first one.
///
/// **It does not scroll and does not virtualise.** A list is a `Column`, so a
/// long one belongs inside the page's scroll view, and a very long one belongs
/// in a paginated `AstryxTable` instead — the same limit the table carries, for
/// the same reason.
///
/// {@tool snippet}
/// ```dart
/// AstryxList(
///   label: 'Team',
///   children: <Widget>[
///     AstryxItem(label: 'Ada Lovelace', description: 'Owner'),
///     AstryxItem(label: 'Alan Turing', description: 'Admin'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxItem], the row.
///  * `AstryxTreeList`, when the rows nest.
///  * `AstryxEmptyState`, for what to show when [children] is empty.
class AstryxList extends StatelessWidget {
  /// Creates a list.
  const AstryxList({
    required this.children,
    super.key,
    this.label,
    this.density = AstryxItemDensity.balanced,
    this.showDividers = false,
    this.gap,
    this.empty,
  });

  /// The rows, in order. Usually [AstryxItem]s, but any widget will do.
  final List<Widget> children;

  /// The list's accessible name — "Team", "Recent deploys".
  ///
  /// Announced before the first row, which is what tells a screen-reader user
  /// what they have arrived in.
  final String? label;

  /// The vertical rhythm every row inherits.
  final AstryxItemDensity density;

  /// Whether to draw a rule between rows.
  ///
  /// Rules are for rows that would otherwise run together — two lines of text
  /// each. A list of one-line rows reads better spaced than ruled.
  final bool showDividers;

  /// Overrides the space between rows.
  ///
  /// Defaults to nothing when [showDividers] is set, and to the density's own
  /// step otherwise: a rule and a gap doing the same job is one too many.
  final AstryxSpacingToken? gap;

  /// What to show when [children] is empty.
  ///
  /// Null renders nothing at all — correct when the caller already handles the
  /// empty case. Otherwise this is where an `AstryxEmptyState` goes.
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return empty ?? const SizedBox.shrink();

    final theme = AstryxTheme.of(context);
    final spacing = gap ?? (showDividers ? null : AstryxSpacingToken.spacing0);

    final rows = <Widget>[
      for (var i = 0; i < children.length; i++) ...<Widget>[
        if (showDividers && i > 0) const AstryxDivider(),
        // Every row is its own node, and says so — without the role a screen
        // reader reads five rows and never says how many there were.
        Semantics(role: SemanticsRole.listItem, child: children[i]),
      ],
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: SemanticsRole.list,
      label: label,
      child: AstryxItemScope(
        density: density,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: spacing == null ? 0 : theme.spacing(spacing),
          children: rows,
        ),
      ),
    );
  }
}
