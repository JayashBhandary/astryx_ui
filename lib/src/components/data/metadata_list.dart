/// Label-and-value pairs.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Which way a pair runs.
enum AstryxMetadataListDirection {
  /// Label above value. The default, and the one that survives a narrow
  /// column.
  stacked,

  /// Label beside value, in two aligned columns.
  ///
  /// Reads faster when there are many short values, and needs a
  /// [AstryxMetadataList.labelWidth] to line up.
  inline,
}

/// One label-and-value pair.
@immutable
class AstryxMetadataItem {
  /// Creates a pair whose value is a widget.
  const AstryxMetadataItem({
    required this.label,
    required this.value,
    this.icon,
    this.semanticsValue,
  });

  /// Creates a pair whose value is text.
  ///
  /// The common case, and the one that gets the announcement right without the
  /// caller thinking about it.
  AstryxMetadataItem.text({
    required this.label,
    required String value,
    this.icon,
  }) : value = AstryxText(value),
       semanticsValue = value;

  /// What the value is — "Owner", "Created", "Region".
  final String label;

  /// The value itself. A badge, a status dot and a date all belong here.
  final Widget value;

  /// An icon before the label.
  final Widget? icon;

  /// What a screen reader reads as the value.
  ///
  /// Set it whenever [value] is not plain text: "green dot, Healthy" is what a
  /// widget-valued pair announces without it, and only the second word is
  /// information.
  final String? semanticsValue;
}

/// The details panel of a record: what it is, and what it is set to.
///
/// For facts about one thing. For rows *of* things use `AstryxList`, and for
/// many things with the same fields use `AstryxTable`.
///
/// {@tool snippet}
/// ```dart
/// AstryxMetadataList(
///   items: <AstryxMetadataItem>[
///     AstryxMetadataItem.text(label: 'Owner', value: 'Ada Lovelace'),
///     AstryxMetadataItem(label: 'Status', value: const AstryxBadge('Live')),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxMetadataList extends StatelessWidget {
  /// Creates a metadata list.
  const AstryxMetadataList({
    required this.items,
    super.key,
    this.direction = AstryxMetadataListDirection.stacked,
    this.labelWidth = 140,
    this.gap = AstryxSpacingToken.spacing3,
  });

  /// The pairs, in order.
  final List<AstryxMetadataItem> items;

  /// Whether a label sits above its value or beside it.
  final AstryxMetadataListDirection direction;

  /// The width of the label column when [direction] is
  /// [AstryxMetadataListDirection.inline].
  ///
  /// A number rather than "as wide as the widest label", which CSS grid does
  /// for free and Flutter would pay for by laying every label out twice — the
  /// same trade `AstryxFormLayout.labelWidth` makes.
  final double labelWidth;

  /// The space between pairs.
  final AstryxSpacingToken gap;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(gap),
      children: <Widget>[
        for (final item in items) _Pair(item: item, list: this),
      ],
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.item, required this.list});

  final AstryxMetadataItem item;
  final AstryxMetadataList list;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final inline = list.direction == AstryxMetadataListDirection.inline;

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(AstryxSpacingToken.spacing1_5),
      children: <Widget>[
        if (item.icon != null)
          IconTheme.merge(
            data: IconThemeData(
              size: AstryxIconSize.sm.pixels,
              color: theme.color(AstryxColorToken.iconSecondary),
            ),
            child: item.icon!,
          ),
        Flexible(
          child: AstryxText(
            item.label,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ),
      ],
    );

    final pair = inline
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: theme.spacing(AstryxSpacingToken.spacing3),
            children: <Widget>[
              SizedBox(width: list.labelWidth, child: label),
              Expanded(child: item.value),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing(AstryxSpacingToken.spacing0_5),
            children: <Widget>[label, item.value],
          );

    // One node per pair, so a screen reader reads "Owner, Ada Lovelace" rather
    // than stopping between the two halves of one fact.
    return Semantics(
      container: true,
      label: item.label,
      value: item.semanticsValue,
      // With an explicit value the widget's own text would be read a second
      // time; without one it *is* the value.
      child: item.semanticsValue == null
          ? MergeSemantics(child: pair)
          : ExcludeSemantics(child: pair),
    );
  }
}
