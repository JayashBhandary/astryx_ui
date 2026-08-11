/// What a list, a table or a panel shows when it has nothing to show.
library;

import 'package:astryx_ui/src/components/layout/center.dart';
import 'package:astryx_ui/src/components/layout/heading.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How much room an empty state takes.
enum AstryxEmptyStateSize {
  /// For an empty state inside a card, a popover or a table body.
  compact(AstryxSpacingToken.spacing6, AstryxIconSize.md),

  /// The default, for an empty page or a full-width panel.
  standard(AstryxSpacingToken.spacing10, AstryxIconSize.lg);

  const AstryxEmptyStateSize(this.padding, this.iconSize);

  /// The padding around the block.
  final AstryxSpacingToken padding;

  /// The size of the icon above the title.
  final AstryxIconSize iconSize;
}

/// A centred explanation of why there is nothing here, and what to do next.
///
/// **An empty state is not an error.** Nothing has gone wrong when a new
/// project has no deploys, so this does not announce itself, take a status
/// colour, or borrow `AstryxBanner`'s urgency. What it does carry is the one
/// action that ends the emptiness — the difference between "No results" and a
/// screen a user can leave.
///
/// {@tool snippet}
/// ```dart
/// AstryxEmptyState(
///   icon: const AstryxIcon(AstryxIconName.search),
///   title: 'No matching deploys',
///   description: 'Try a wider date range.',
///   actions: <Widget>[
///     AstryxButton(label: 'Clear filters', onPressed: _clear),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxList.empty` and `AstryxTable`, the two places this most often
///    goes.
///  * `AstryxBanner`, when something *has* gone wrong.
class AstryxEmptyState extends StatelessWidget {
  /// Creates an empty state.
  const AstryxEmptyState({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.actions = const <Widget>[],
    this.size = AstryxEmptyStateSize.standard,
    this.minHeight,
    this.maxWidth = 380,
  });

  /// What is missing, in a few words — "No deploys yet".
  ///
  /// A heading at level 3: an empty state stands in for content, so it belongs
  /// in the outline where that content would have been.
  final String title;

  /// A line under the title, saying why, or what would fill it.
  final String? description;

  /// An icon above the title.
  ///
  /// Decorative — the title carries the meaning — so it is kept out of the
  /// semantics tree rather than announced.
  final Widget? icon;

  /// The way out: one action, or two at most.
  final List<Widget> actions;

  /// How much room the block takes.
  final AstryxEmptyStateSize size;

  /// A floor under the height, for an empty state standing in for a list whose
  /// height should not jump when rows arrive.
  final double? minHeight;

  /// A ceiling on the text's width, so the description stays readable.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxCenter(
      minHeight: minHeight,
      padding: size.padding,
      maxWidth: maxWidth,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          if (icon != null)
            ExcludeSemantics(
              child: IconTheme.merge(
                data: IconThemeData(
                  size: size.iconSize.pixels,
                  color: theme.color(AstryxColorToken.iconSecondary),
                ),
                child: icon!,
              ),
            ),
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxHeading(title, level: 3, type: AstryxHeadingType.display3),
              if (description != null)
                AstryxText(
                  description!,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  justify: AstryxTextJustify.center,
                ),
            ],
          ),
          if (actions.isNotEmpty)
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: actions,
            ),
        ],
      ),
    );
  }
}
