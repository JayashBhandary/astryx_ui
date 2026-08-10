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
          spans.add(
            TextSpan(
              text: token.text,
              style: theme.textStyle(AstryxTypeRole.code).copyWith(
                color: base.color,
                // A shade stronger than `--color-background-muted`, which in a
                // dark theme is too close to the page to register.
                backgroundColor: Color.lerp(
                  theme.color(AstryxColorToken.backgroundMuted),
                  theme.color(AstryxColorToken.border),
                  0.7,
                ),
                fontWeight: base.fontWeight,
                fontStyle: base.fontStyle,
                height: base.height,
              ),
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
