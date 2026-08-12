/// Rendered markdown, for model output and authored prose alike.
library;

import 'package:astryx_ui/src/components/data/blockquote.dart';
import 'package:astryx_ui/src/components/data/code.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/heading.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/navigation/link.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';

/// Renders a **subset** of markdown with the design system's own widgets.
///
/// Upstream's `Markdown`. A model answers in markdown, so something has to draw
/// it — and drawing it with `AstryxHeading`, `AstryxCodeBlock`,
/// `AstryxBlockquote` and `AstryxLink` is what keeps an answer looking like
/// part
/// of the application rather than like a web page inside it.
///
/// {@tool snippet}
/// ```dart
/// AstryxMarkdown(reply.text, onLinkPressed: _open)
/// ```
/// {@end-tool}
///
/// ## What it renders
///
/// | Markdown | Drawn as |
/// | --- | --- |
/// | `# … ######` | `AstryxHeading`, at the matching level |
/// | Paragraphs | `AstryxText` |
/// | `- ` / `* ` / `1. ` | A bullet or number and its text |
/// | ```` ``` ```` fences | `AstryxCodeBlock`, language and all |
/// | `> ` | `AstryxBlockquote` |
/// | `---` | `AstryxDivider` |
/// | `**bold**`, `*italic*`, `` `code` ``, `[text](url)` | Inline spans |
///
/// ## What it does not
///
/// **Tables, images, footnotes, nested lists, task lists, inline HTML — and
/// text selection across blocks.** They are absent
/// rather than half-drawn: a table rendered as run-together text is worse than
/// a table nobody rendered, because the reader cannot tell it was a table.
/// Reach for a real markdown package where the input is arbitrary and the
/// output
/// matters that much — this exists so a chat answer looks right, and it says
/// what it can do.
class AstryxMarkdown extends StatelessWidget {
  /// Renders [source].
  const AstryxMarkdown(
    this.source, {
    super.key,
    this.onLinkPressed,
    this.gap = AstryxSpacingToken.spacing3,
  });

  /// The markdown.
  final String source;

  /// Called with the target of a link that was followed.
  ///
  /// Null leaves links as plain text rather than as controls that do nothing —
  /// a link that cannot be followed should not look like one.
  final ValueChanged<String>? onLinkPressed;

  /// The space between blocks.
  final AstryxSpacingToken gap;

  @override
  Widget build(BuildContext context) {
    final blocks = _parse(source);

    return AstryxVStack(
      gap: gap,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final block in blocks) _block(context, block),
      ],
    );
  }

  Widget _block(BuildContext context, _Block block) => switch (block) {
    // The level carries the size as well as the outline position, which is the
    // whole point of `AstryxHeading` — so there is nothing to choose here.
    _Heading(:final level, :final text) => AstryxHeading(text, level: level),
    _Paragraph(:final text) => _inline(context, text),
    _Code(:final code, :final language) => AstryxCodeBlock(
      code,
      language: language,
    ),
    _Quote(:final text) => AstryxBlockquote(text),
    _Rule() => const AstryxDivider(),
    _ListBlock(:final items, :final ordered) => AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (var i = 0; i < items.length; i++)
          _Item(
            marker: ordered ? '${i + 1}.' : '•',
            child: _inline(context, items[i]),
          ),
      ],
    ),
  };

  /// Renders one line's inline markup.
  Widget _inline(BuildContext context, String text) {
    final theme = AstryxTheme.of(context);
    final base = theme.textStyle(AstryxTypeRole.body).copyWith(
      color: theme.color(AstryxColorToken.textPrimary),
    );

    final spans = _inlineSpans(text, base, onLinkPressed);
    if (spans.length == 1 && spans.first is TextSpan) {
      final only = spans.first as TextSpan;
      if (only.style == base) return AstryxText(only.text ?? '');
    }

    return Text.rich(TextSpan(children: spans), style: base);
  }
}

/// A bullet or number, and the line beside it.
class _Item extends StatelessWidget {
  const _Item({required this.marker, required this.child});

  final String marker;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.spacing(AstryxSpacingToken.spacing2),
      children: <Widget>[
        SizedBox(
          width: 20,
          child: AstryxText(
            marker,
            color: AstryxTextColor.secondary,
            tabularNumbers: true,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// The block parser
//
// Line-based and deliberately small: markdown's block grammar is the part a
// reader notices, and the part a hundred lines can get right. Anything needing
// a real parser is on the not-rendered list rather than approximated.
// -----------------------------------------------------------------------------

sealed class _Block {
  const _Block();
}

class _Heading extends _Block {
  const _Heading(this.level, this.text);
  final int level;
  final String text;
}

class _Paragraph extends _Block {
  const _Paragraph(this.text);
  final String text;
}

class _Code extends _Block {
  const _Code(this.code, this.language);
  final String code;
  final String? language;
}

class _Quote extends _Block {
  const _Quote(this.text);
  final String text;
}

class _Rule extends _Block {
  const _Rule();
}

class _ListBlock extends _Block {
  const _ListBlock(this.items, {required this.ordered});
  final List<String> items;
  final bool ordered;
}

final RegExp _headingLine = RegExp(r'^(#{1,6})\s+(.*)$');
final RegExp _bulletLine = RegExp(r'^\s*[-*+]\s+(.*)$');
final RegExp _orderedLine = RegExp(r'^\s*\d+[.)]\s+(.*)$');
final RegExp _ruleLine = RegExp(r'^\s*([-*_])\s*(\1\s*){2,}$');
final RegExp _fenceLine = RegExp(r'^```(.*)$');
final RegExp _quoteLine = RegExp(r'^\s*>\s?(.*)$');

List<_Block> _parse(String source) {
  final lines = source.split('\n');
  final blocks = <_Block>[];

  final paragraph = <String>[];
  final quote = <String>[];
  var listItems = <String>[];
  var listOrdered = false;

  void flushParagraph() {
    if (paragraph.isEmpty) return;
    blocks.add(_Paragraph(paragraph.join(' ').trim()));
    paragraph.clear();
  }

  void flushQuote() {
    if (quote.isEmpty) return;
    blocks.add(_Quote(quote.join(' ').trim()));
    quote.clear();
  }

  void flushList() {
    if (listItems.isEmpty) return;
    blocks.add(_ListBlock(List<String>.of(listItems), ordered: listOrdered));
    listItems = <String>[];
  }

  void flushAll() {
    flushParagraph();
    flushQuote();
    flushList();
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    final fence = _fenceLine.firstMatch(line.trimRight());
    if (fence != null) {
      flushAll();
      final language = fence.group(1)?.trim();
      final code = <String>[];
      i++;
      // Everything up to the closing fence, verbatim — indentation included,
      // because in code it is content.
      while (i < lines.length && !_fenceLine.hasMatch(lines[i].trimRight())) {
        code.add(lines[i]);
        i++;
      }
      blocks.add(
        _Code(code.join('\n'), language == null || language.isEmpty
            ? null
            : language),
      );
      continue;
    }

    if (line.trim().isEmpty) {
      flushAll();
      continue;
    }

    if (_ruleLine.hasMatch(line)) {
      flushAll();
      blocks.add(const _Rule());
      continue;
    }

    final heading = _headingLine.firstMatch(line);
    if (heading != null) {
      flushAll();
      blocks.add(
        _Heading(heading.group(1)!.length, heading.group(2)!.trim()),
      );
      continue;
    }

    final quoted = _quoteLine.firstMatch(line);
    if (quoted != null) {
      flushParagraph();
      flushList();
      quote.add(quoted.group(1)!);
      continue;
    }

    final bullet = _bulletLine.firstMatch(line);
    final ordered = _orderedLine.firstMatch(line);
    if (bullet != null || ordered != null) {
      flushParagraph();
      flushQuote();
      final isOrdered = ordered != null;
      // A change of list kind starts a new list: "1." after "-" is a different
      // list, not a stray item in the old one.
      if (listItems.isNotEmpty && isOrdered != listOrdered) flushList();
      listOrdered = isOrdered;
      listItems.add((bullet ?? ordered)!.group(1)!.trim());
      continue;
    }

    flushQuote();
    flushList();
    paragraph.add(line.trim());
  }

  flushAll();
  return blocks;
}

// -----------------------------------------------------------------------------
// The inline parser
// -----------------------------------------------------------------------------

final RegExp _inlinePattern = RegExp(
  r'(\*\*|__)(.+?)\1'
  r'|(\*|_)(.+?)\3'
  '|`([^`]+)`'
  r'|\[([^\]]+)\]\(([^)\s]+)\)',
);

List<InlineSpan> _inlineSpans(
  String text,
  TextStyle base,
  ValueChanged<String>? onLinkPressed,
) {
  final spans = <InlineSpan>[];
  var index = 0;

  for (final match in _inlinePattern.allMatches(text)) {
    if (match.start > index) {
      spans.add(TextSpan(text: text.substring(index, match.start)));
    }

    if (match.group(2) != null) {
      spans.add(
        TextSpan(
          text: match.group(2),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    } else if (match.group(4) != null) {
      spans.add(
        TextSpan(
          text: match.group(4),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else if (match.group(5) != null) {
      spans.add(AstryxCode.span(match.group(5)!));
    } else if (match.group(6) != null) {
      final label = match.group(6)!;
      final target = match.group(7)!;
      // A link with nothing to do is drawn as text: looking like a control and
      // not being one is the worse of the two failures.
      spans.add(
        onLinkPressed == null
            ? TextSpan(text: label)
            : AstryxLink.span(label, onPressed: () => onLinkPressed(target)),
      );
    }

    index = match.end;
  }

  if (index < text.length) {
    spans.add(TextSpan(text: text.substring(index)));
  }
  if (spans.isEmpty) spans.add(TextSpan(text: text));
  return spans;
}
