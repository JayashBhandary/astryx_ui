import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Renders the docs' inline markup: `` `code` ``, `**bold**`, `*emphasis*` and
/// `[label](target)`.
///
/// Deliberately tiny. A markdown package would render more than these pages
/// use, and the same four rules have to work in `tool/gen_docs_md.dart`, where
/// they are simply left as written.
class DocsInlineText extends StatelessWidget {
  const DocsInlineText(
    this.text, {
    super.key,
    this.type = AstryxTextType.body,
    this.color = AstryxTextColor.primary,
    this.justify,
    this.onLinkPressed,
  });

  final String text;
  final AstryxTextType type;
  final AstryxTextColor color;
  final AstryxTextJustify? justify;

  /// Called with a link's target. Null renders links as plain accent text.
  final ValueChanged<String>? onLinkPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final base = theme.textStyle(type.role).copyWith(
      color: color.token == null ? null : theme.color(color.token!),
    );

    return Text.rich(
      TextSpan(children: _spans(theme, text, base)),
      textAlign: justify?.textAlign,
    );
  }

  /// Builds the spans for [source], with [base] as the surrounding style.
  ///
  /// Recursive, so markup nests: `` **bold with `code` in it** `` keeps both.
  List<InlineSpan> _spans(
    AstryxThemeData theme,
    String source,
    TextStyle base,
  ) {
    final spans = <InlineSpan>[];

    for (final token in parseDocsInline(source)) {
      switch (token.kind) {
        case DocsInlineKind.plain:
          spans.add(TextSpan(text: token.text, style: base));
        case DocsInlineKind.code:
          // Code does not nest: whatever is between the backticks is literal.
          //
          // A `WidgetSpan`, not a `TextSpan` with `backgroundColor`. A text
          // span's background is painted to the glyphs' exact bounds, so the
          // first and last character sit flush against the edge of the
          // highlight — the chip reads as a printing error rather than a chip.
          // A widget span can be padded and rounded.
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: _CodeChip(text: token.text, base: base),
            ),
          );
        case DocsInlineKind.bold:
          spans.addAll(
            _spans(
              theme,
              token.text,
              base.copyWith(
                fontWeight: theme.fontWeight(AstryxFontWeightToken.semibold),
              ),
            ),
          );
        case DocsInlineKind.emphasis:
          spans.addAll(
            _spans(
              theme,
              token.text,
              base.copyWith(fontStyle: FontStyle.italic),
            ),
          );
        case DocsInlineKind.link:
          final target = token.target ?? '';
          final accent = theme.color(AstryxColorToken.textAccent);
          spans.add(
            TextSpan(
              children: _spans(
                theme,
                token.text,
                base.copyWith(
                  color: accent,
                  decoration: TextDecoration.underline,
                  decorationColor: accent,
                ),
              ),
              recognizer: onLinkPressed == null
                  ? null
                  : (TapGestureRecognizer()
                      ..onTap = () => onLinkPressed!(target)),
            ),
          );
      }
    }

    return spans;
  }
}

/// What a parsed inline token is.
enum DocsInlineKind { plain, code, bold, emphasis, link }

/// One parsed inline token.
class DocsInlineToken {
  const DocsInlineToken(this.kind, this.text, {this.target});

  final DocsInlineKind kind;
  final String text;

  /// A link's destination — a page id, or a URL.
  final String? target;
}

final RegExp _inline = RegExp(
  '`([^`]+)`'
  r'|\*\*([^*]+)\*\*'
  r'|\*([^*]+)\*'
  r'|\[([^\]]+)\]\(([^)]+)\)',
);

/// Splits [text] into plain runs and marked-up ones.
List<DocsInlineToken> parseDocsInline(String text) {
  final tokens = <DocsInlineToken>[];
  var index = 0;

  for (final match in _inline.allMatches(text)) {
    if (match.start > index) {
      tokens.add(
        DocsInlineToken(
          DocsInlineKind.plain,
          text.substring(index, match.start),
        ),
      );
    }

    if (match.group(1) != null) {
      tokens.add(DocsInlineToken(DocsInlineKind.code, match.group(1)!));
    } else if (match.group(2) != null) {
      tokens.add(DocsInlineToken(DocsInlineKind.bold, match.group(2)!));
    } else if (match.group(3) != null) {
      tokens.add(DocsInlineToken(DocsInlineKind.emphasis, match.group(3)!));
    } else {
      tokens.add(
        DocsInlineToken(
          DocsInlineKind.link,
          match.group(4)!,
          target: match.group(5),
        ),
      );
    }

    index = match.end;
  }

  if (index < text.length) {
    tokens.add(DocsInlineToken(DocsInlineKind.plain, text.substring(index)));
  }

  return tokens;
}

/// One `` `code` `` span, as a padded chip.
///
/// Vertical padding is deliberately 1: a baseline-aligned widget span grows the
/// line box, so a generous inset here would loosen the leading of every
/// paragraph that mentions a symbol. Horizontal padding is where a chip needs
/// the room anyway.
class _CodeChip extends StatelessWidget {
  const _CodeChip({required this.text, required this.base});

  final String text;

  /// The surrounding text's style, so a chip inside bold or italic prose keeps
  /// the weight and slant of the sentence it sits in.
  final TextStyle base;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        // A shade stronger than `--color-background-muted`, which in a dark
        // theme is too close to the page to register.
        color: Color.lerp(
          theme.color(AstryxColorToken.backgroundMuted),
          theme.color(AstryxColorToken.border),
          0.7,
        ),
        borderRadius: BorderRadius.circular(
          theme.radius(AstryxRadiusToken.inner),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Text(
          text,
          style: theme
              .textStyle(AstryxTypeRole.code)
              .copyWith(
                color: base.color,
                fontWeight: base.fontWeight,
                fontStyle: base.fontStyle,
                height: base.height,
              ),
        ),
      ),
    );
  }
}
