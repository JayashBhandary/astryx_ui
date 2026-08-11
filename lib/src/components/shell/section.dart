/// A titled band of page content.
library;

import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/heading.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How deep the section around this one sits.
///
/// Carried down the tree so a nested section does not have to be told its own
/// heading level. Getting that wrong is the commonest accessibility fault on a
/// long page — an outline that jumps from `h2` to `h4`, or repeats `h2` for
/// something that is plainly a sub-part — and it is a fault a caller cannot see
/// by looking at the screen.
class AstryxSectionScope extends InheritedWidget {
  /// Puts [level] in scope for the sections below.
  const AstryxSectionScope({
    required this.level,
    required super.child,
    super.key,
  });

  /// The heading level of the section that established this scope.
  final int level;

  /// The nearest section's level, or null at the top of the page.
  static int? levelOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxSectionScope>()?.level;

  @override
  bool updateShouldNotify(AstryxSectionScope oldWidget) =>
      level != oldWidget.level;
}

/// A band of page content with a heading, its own spacing, and a place in the
/// document outline.
///
/// **The heading level looks after itself.** A section inside another section
/// is one level deeper, so a page assembled from parts nobody wrote together
/// still produces an outline a screen reader can navigate. Pass [level]
/// explicitly only when the nesting and the outline genuinely disagree.
///
/// {@tool snippet}
/// ```dart
/// AstryxSection(
///   title: 'Environments',
///   description: 'Where this project is deployed.',
///   actions: <Widget>[
///     AstryxButton(label: 'New environment', onPressed: create),
///   ],
///   child: const EnvironmentGrid(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxLayout`, the page these sit in.
///  * `AstryxOutline`, which is the same structure read back as a table of
///    contents.
class AstryxSection extends StatelessWidget {
  /// Creates a section.
  const AstryxSection({
    required this.child,
    super.key,
    this.title,
    this.description,
    this.actions = const <Widget>[],
    this.level,
    this.gap = AstryxSpacingToken.spacing4,
    this.showDivider = false,
    this.headerKey,
  });

  /// The section's content.
  final Widget child;

  /// The heading. Null for a band that is grouped but not titled.
  final String? title;

  /// A line under the title, saying what the section is for.
  final String? description;

  /// Controls at the trailing edge of the heading row.
  final List<Widget> actions;

  /// Overrides the heading level.
  ///
  /// Defaults to one deeper than the enclosing section, and to 2 at the top of
  /// a page — where 1 belongs to the page's own title, usually in
  /// `AstryxLayout.header`.
  final int? level;

  /// The space between the heading block and the content.
  final AstryxSpacingToken gap;

  /// Whether to draw a rule under the heading block.
  ///
  /// For a page of many sections, where the gap alone stops doing the work.
  final bool showDivider;

  /// A key on the heading, for an `AstryxOutline` to find and scroll to.
  final Key? headerKey;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final parent = AstryxSectionScope.levelOf(context);
    // Six is where HTML stops, and where a heading stops meaning anything.
    final resolved = (level ?? (parent == null ? 2 : parent + 1)).clamp(1, 6);

    final heading = title == null && description == null && actions.isEmpty
        ? null
        : Row(
            key: headerKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: theme.spacing(AstryxSpacingToken.spacing3),
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: theme.spacing(AstryxSpacingToken.spacing1),
                  children: <Widget>[
                    if (title != null) AstryxHeading(title!, level: resolved),
                    if (description != null)
                      AstryxText(
                        description!,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                  ],
                ),
              ),
              if (actions.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: theme.spacing(AstryxSpacingToken.spacing2),
                  children: actions,
                ),
            ],
          );

    // The rule belongs to the heading block, not between two children of the
    // section: spaced as a sibling it would be paid for twice, once on each
    // side, and read as a divider between two sections rather than under one
    // heading.
    final headerBlock = heading == null
        ? null
        : (showDivider
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: theme.spacing(AstryxSpacingToken.spacing3),
                  children: <Widget>[heading, const AstryxDivider()],
                )
              : heading);

    return AstryxSectionScope(
      level: resolved,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(gap),
        children: <Widget>[?headerBlock, child],
      ),
    );
  }
}
