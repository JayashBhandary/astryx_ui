/// Renders a list of [DocBlock]s.
///
/// Lifted out of `doc_page_view.dart` when the landing page started rendering
/// the README: two renderers for the same model is two places for a heading to
/// take a different size, and the front page is the one screen where that shows
/// most.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs_ui/api_table.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/example_block.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:flutter/widgets.dart';

/// A column of rendered blocks.
class DocsBlocks extends StatelessWidget {
  const DocsBlocks({
    required this.blocks,
    required this.onNavigate,
    super.key,
    this.gap = AstryxSpacingToken.spacing6,
  });

  final List<DocBlock> blocks;

  /// Called with a page id, or with a URL for anything off the site.
  final ValueChanged<String> onNavigate;

  /// The space between blocks.
  final AstryxSpacingToken gap;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: gap,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final block in blocks) docsBlock(context, block, onNavigate),
      ],
    );
  }
}

/// One rendered block.
///
/// [onNavigate] takes a page id or a URL; a caller with nowhere to send the
/// reader can pass a callback that ignores it, and the links render as accent
/// text.
Widget docsBlock(
  BuildContext context,
  DocBlock block,
  ValueChanged<String> onNavigate,
) {
  final theme = AstryxTheme.of(context);

  return switch (block) {
    // More space above a heading than the stack's own gap, so a new section
    // reads as a break rather than as another paragraph. Nothing below it: a
    // heading belongs to what follows, and the gap supplies that already.
    DocHeading() => Padding(
      padding: EdgeInsets.only(top: theme.spacing(AstryxSpacingToken.spacing5)),
      child: AstryxHeading(block.text, level: block.level + 1),
    ),
    DocProse() => DocsInlineText(block.text, onLinkPressed: onNavigate),
    DocList() => _List(block: block, onNavigate: onNavigate),
    DocExample() => DocsExampleBlock(block),
    DocCode() => DocsCodeBlock(
      source: block.code,
      language: block.language,
      title: block.title,
    ),
    DocTree() => DocsCodeBlock(
      source: block.tree,
      language: 'text',
      title: 'composition',
    ),
    DocCallout() => _Callout(callout: block),
    DocApi() => DocsApiTable(block),
    DocTable() => DocsDataTable(block),
    DocAction() => _Action(block: block, onNavigate: onNavigate),
  };
}

class _List extends StatelessWidget {
  const _List({required this.block, required this.onNavigate});

  final DocList block;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      // A list item is often two lines long, so items need more between them
      // than the lines inside one item, or the list reads as a single block.
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (var i = 0; i < block.items.length; i++)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.start,
            children: <Widget>[
              // Wide enough for `10.`, and no wider: a 20-pixel column left the
              // bullet stranded a third of an inch from the text it marks.
              SizedBox(
                width: block.ordered ? 20 : 10,
                child: AstryxText(
                  block.ordered ? '${i + 1}.' : '•',
                  color: AstryxTextColor.secondary,
                ),
              ),
              Expanded(
                child: DocsInlineText(
                  block.items[i],
                  onLinkPressed: onNavigate,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({required this.callout});

  final DocCallout callout;

  @override
  Widget build(BuildContext context) {
    return AstryxBanner(
      status: switch (callout.kind) {
        DocCalloutKind.note => AstryxBannerStatus.info,
        DocCalloutKind.warning => AstryxBannerStatus.warning,
        DocCalloutKind.accessibility => AstryxBannerStatus.success,
      },
      title: callout.kind.label,
      announce: false,
      icon: switch (callout.kind) {
        DocCalloutKind.note => const AstryxIcon(AstryxIconName.info),
        DocCalloutKind.warning => const AstryxIcon(AstryxIconName.warning),
        DocCalloutKind.accessibility => const AstryxIcon(
          AstryxIconName.checkDouble,
        ),
      },
      content: DocsInlineText(callout.text),
    );
  }
}

/// A [DocAction]: the button that does what the prose just asked for.
class _Action extends StatelessWidget {
  const _Action({required this.block, required this.onNavigate});

  final DocAction block;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxButton(
          label: block.label,
          variant: AstryxButtonVariant.primary,
          // Trailing, and this icon: the button leaves the site, and saying so
          // before the click is cheaper than a reader losing their place.
          trailing: const AstryxIcon(AstryxIconName.externalLink),
          onPressed: () => onNavigate(block.url),
        ),
        if (block.note case final String note)
          DocsInlineText(
            note,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            onLinkPressed: onNavigate,
          ),
      ],
    );
  }
}
