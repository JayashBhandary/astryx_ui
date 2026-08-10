import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A code block with Dart syntax highlighting, a file caption and a copy
/// button.
///
/// Every colour is a theme token, so a code block in the `gothic` theme is
/// still legible — which a hard-coded highlighting palette cannot promise.
class DocsCodeBlock extends StatelessWidget {
  const DocsCodeBlock({
    required this.source,
    super.key,
    this.language = 'dart',
    this.title,
    this.showLineNumbers = false,
    this.bordered = true,
  });

  final String source;
  final String language;
  final String? title;
  final bool showLineNumbers;

  /// Whether to draw the block's own border and corners.
  ///
  /// False when the block already sits inside a card, where a second border
  /// only reads as a mistake.
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final lines = source.trimRight().split('\n');
    final gutterWidth = '${lines.length}'.length * 9.0 + 12;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: bordered
            ? theme.borderRadius(AstryxRadiusToken.container)
            : null,
        border: bordered
            ? Border.all(color: theme.color(AstryxColorToken.border))
            : null,
      ),
      child: AstryxVStack(
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          _Bar(source: source, language: language, title: title),
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing(AstryxSpacingToken.spacing4),
              theme.spacing(AstryxSpacingToken.spacing3),
              theme.spacing(AstryxSpacingToken.spacing4),
              theme.spacing(AstryxSpacingToken.spacing4),
            ),
            // Code does not wrap: a broken line is harder to read than a
            // scrollbar is to drag.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showLineNumbers)
                    SizedBox(
                      width: gutterWidth,
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            for (var i = 1; i <= lines.length; i++)
                              TextSpan(text: '$i\n'),
                          ],
                        ),
                        textAlign: TextAlign.right,
                        style: theme
                            .textStyle(AstryxTypeRole.code)
                            .copyWith(
                              color: theme.color(
                                AstryxColorToken.textDisabled,
                              ),
                            ),
                      ),
                    ),
                  Text.rich(
                    TextSpan(
                      children: highlightDocsCode(
                        source.trimRight(),
                        language: language,
                        theme: theme,
                      ),
                    ),
                    style: theme.textStyle(AstryxTypeRole.code),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The caption strip: the language or file name, and the copy button.
class _Bar extends StatelessWidget {
  const _Bar({required this.source, required this.language, this.title});

  final String source;
  final String language;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        theme.spacing(AstryxSpacingToken.spacing4),
        theme.spacing(AstryxSpacingToken.spacing2),
        theme.spacing(AstryxSpacingToken.spacing2),
        0,
      ),
      child: AstryxHStack(
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: AstryxText(
              title ?? language,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
          _CopyButton(source: source),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.source});

  final String source;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.source));
    if (!mounted) return;
    setState(() => _copied = true);
    AstryxToastScope.maybeOf(context)?.show(
      const AstryxToast(
        message: 'Copied to the clipboard',
        duration: Duration(seconds: 2),
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AstryxIconButton(
      icon: _copied ? AstryxIconName.check : AstryxIconName.copy,
      label: _copied ? 'Copied' : 'Copy the code',
      tooltip: _copied ? 'Copied' : 'Copy',
      variant: AstryxButtonVariant.ghost,
      size: AstryxButtonSize.sm,
      onPressed: _copy,
    );
  }
}

/// Tokenises [source] into coloured spans.
///
/// Handles Dart, and degrades gracefully for `yaml`, `bash` and `text`, where
/// only comments and strings are marked.
List<InlineSpan> highlightDocsCode(
  String source, {
  required AstryxThemeData theme,
  String language = 'dart',
}) {
  final plain = theme.color(AstryxColorToken.textPrimary);
  final comment = theme.color(AstryxColorToken.textSecondary);
  final string = theme.color(AstryxColorToken.textGreen);
  final keyword = theme.color(AstryxColorToken.textPurple);
  final number = theme.color(AstryxColorToken.textOrange);
  final type = theme.color(AstryxColorToken.textBlue);
  final annotation = theme.color(AstryxColorToken.textTeal);

  final dart = language == 'dart';
  final spans = <InlineSpan>[];
  final buffer = StringBuffer();

  void flush() {
    if (buffer.isEmpty) return;
    spans.add(
      TextSpan(text: buffer.toString(), style: TextStyle(color: plain)),
    );
    buffer.clear();
  }

  void emit(String text, Color color) {
    flush();
    spans.add(TextSpan(text: text, style: TextStyle(color: color)));
  }

  var i = 0;
  while (i < source.length) {
    final char = source[i];
    final rest = source.substring(i);

    // Comments run to the end of the line.
    if (rest.startsWith('//') || (!dart && char == '#')) {
      final end = source.indexOf('\n', i);
      final stop = end == -1 ? source.length : end;
      emit(source.substring(i, stop), comment);
      i = stop;
      continue;
    }

    // Strings, including Dart's raw and triple-quoted forms.
    if (char == "'" || char == '"') {
      final raw = i > 0 && source[i - 1] == 'r';
      final triple = rest.startsWith(char * 3);
      final quote = triple ? char * 3 : char;
      var j = i + quote.length;
      while (j < source.length) {
        if (!raw && source[j] == r'\') {
          j += 2;
          continue;
        }
        if (source.startsWith(quote, j)) {
          j += quote.length;
          break;
        }
        j++;
      }
      emit(source.substring(i, j.clamp(0, source.length)), string);
      i = j;
      continue;
    }

    // Annotations.
    if (dart && char == '@') {
      var j = i + 1;
      while (j < source.length && _isWordChar(source[j])) {
        j++;
      }
      emit(source.substring(i, j), annotation);
      i = j;
      continue;
    }

    // Numbers.
    if (_isDigit(char) && (i == 0 || !_isWordChar(source[i - 1]))) {
      var j = i;
      while (j < source.length &&
          (_isDigit(source[j]) || source[j] == '.' || source[j] == '_')) {
        j++;
      }
      emit(source.substring(i, j), number);
      i = j;
      continue;
    }

    // Words: keywords, type names, everything else.
    if (_isWordStart(char)) {
      var j = i;
      while (j < source.length && _isWordChar(source[j])) {
        j++;
      }
      final word = source.substring(i, j);
      if (dart && _dartKeywords.contains(word)) {
        emit(word, keyword);
      } else if (!dart && _otherKeywords.contains(word)) {
        emit(word, keyword);
      } else if (word[0].toUpperCase() == word[0] &&
          word[0].toLowerCase() != word[0]) {
        emit(word, type);
      } else {
        buffer.write(word);
      }
      i = j;
      continue;
    }

    buffer.write(char);
    i++;
  }

  flush();
  return spans;
}

bool _isDigit(String c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

bool _isWordStart(String c) =>
    RegExp(r'[A-Za-z_$]').hasMatch(c);

bool _isWordChar(String c) => RegExp(r'[A-Za-z0-9_$]').hasMatch(c);

const Set<String> _dartKeywords = <String>{
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension',
  'external', 'factory', 'false', 'final', 'finally', 'for', 'get', 'hide',
  'if', 'implements', 'import', 'in', 'interface', 'is', 'late', 'library',
  'mixin', 'new', 'null', 'on', 'operator', 'part', 'required', 'rethrow',
  'return', 'sealed', 'set', 'show', 'static', 'super', 'switch', 'sync',
  'this', 'throw', 'true', 'try', 'typedef', 'var', 'void', 'when', 'while',
  'with', 'yield',
};

const Set<String> _otherKeywords = <String>{
  'dependencies', 'dev_dependencies', 'flutter', 'sdk', 'name', 'version',
  'true', 'false', 'null', 'cd', 'dart', 'run', 'add', 'get', 'pub',
};
