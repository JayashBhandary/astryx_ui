/// Monospace, inline and in a block.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A symbol or a value, set in the code family.
///
/// For a class name, a flag, an environment variable — the things that are
/// wrong when they are re-typed with a capital letter in the wrong place.
///
/// {@tool snippet}
/// ```dart
/// const AstryxCode('AstryxSpacingToken.spacing4')
/// ```
/// {@end-tool}
///
/// Flutter has no inline element, so a widget cannot simply sit inside a
/// string. To put one *inside* a sentence, use [AstryxCode.span] with
/// `Text.rich`:
///
/// {@tool snippet}
/// ```dart
/// Text.rich(
///   TextSpan(
///     children: <InlineSpan>[
///       const TextSpan(text: 'Pass '),
///       AstryxCode.span('padding'),
///       const TextSpan(text: ' a token.'),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
class AstryxCode extends StatelessWidget {
  /// Creates inline code.
  const AstryxCode(this.data, {super.key, this.semanticsLabel});

  /// The code itself.
  final String data;

  /// Overrides what a screen reader announces.
  ///
  /// Worth setting for a string that is unreadable aloud — a hex colour, a
  /// token with no spaces in it — where the spoken version is noise.
  final String? semanticsLabel;

  /// This code as an inline span, for use inside `Text.rich`.
  ///
  /// [PlaceholderAlignment.middle] rather than baseline: the chip has padding
  /// of its own, and aligning its baseline to the sentence's pushes the fill
  /// below the line.
  static InlineSpan span(String data, {String? semanticsLabel}) => WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: AstryxCode(data, semanticsLabel: semanticsLabel),
  );

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing1),
        vertical: theme.spacing(AstryxSpacingToken.spacing0_5),
      ),
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      ),
      child: AstryxText(
        data,
        type: AstryxTextType.code,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

/// A fenced block of code, with the language, a copy button and line numbers.
///
/// **Nothing is highlighted.** Upstream colours its blocks with a JavaScript
/// tokeniser that has no counterpart here, and a half-right highlighter is
/// worse than none: code coloured by a grammar that does not match the
/// language is code that lies about what it means. The block is otherwise
/// complete — the copy button carries the real string, including the lines
/// scrolled out of sight.
///
/// {@tool snippet}
/// ```dart
/// AstryxCodeBlock(
///   'flutter pub add astryx_ui',
///   language: 'bash',
/// )
/// ```
/// {@end-tool}
class AstryxCodeBlock extends StatefulWidget {
  /// Creates a code block.
  const AstryxCodeBlock(
    this.code, {
    super.key,
    this.language,
    this.showLineNumbers = false,
    this.showCopy = true,
    this.wrap = false,
    this.maxHeight,
    this.semanticsLabel,
  });

  /// The code, newline-separated.
  final String code;

  /// The language, shown in the header — `dart`, `bash`, `yaml`.
  ///
  /// A label, not a highlighting instruction: nothing reads it but the reader.
  final String? language;

  /// Whether to number the lines.
  ///
  /// The numbers are decoration: they are not selected with the code and not
  /// read by a screen reader, because "1 2 3 4" is not the program.
  final bool showLineNumbers;

  /// Whether to offer a copy button.
  final bool showCopy;

  /// Whether long lines wrap instead of scrolling sideways.
  ///
  /// Off by default: wrapping breaks the indentation a reader uses to follow
  /// structure, and in code a line break is not a neutral event.
  final bool wrap;

  /// The tallest the block may be before it scrolls.
  final double? maxHeight;

  /// What a screen reader announces instead of the code.
  final String? semanticsLabel;

  @override
  State<AstryxCodeBlock> createState() => _AstryxCodeBlockState();
}

class _AstryxCodeBlockState extends State<AstryxCodeBlock> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;

    // The button says what happened rather than a toast doing it: the answer
    // belongs where the question was asked, and a toast for every copy in a
    // page of ten blocks is a page that shouts.
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final lines = widget.code.split('\n');

    final code = AstryxText(
      widget.code,
      type: AstryxTextType.code,
      softWrap: widget.wrap,
      semanticsLabel: widget.semanticsLabel,
    );

    var body = widget.showLineNumbers
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing(AstryxSpacingToken.spacing3),
            children: <Widget>[
              ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var i = 1; i <= lines.length; i++)
                      AstryxText(
                        '$i',
                        type: AstryxTextType.code,
                        color: AstryxTextColor.disabled,
                      ),
                  ],
                ),
              ),
              Flexible(child: code),
            ],
          )
        : code;

    if (!widget.wrap) {
      body = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: body,
      );
    }

    if (widget.maxHeight != null) {
      body = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        child: SingleChildScrollView(child: body),
      );
    }

    final showHeader = widget.language != null || widget.showCopy;
    final pad = theme.spacing(AstryxSpacingToken.spacing3);

    return Container(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showHeader)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: pad,
                end: theme.spacing(AstryxSpacingToken.spacing1),
                top: theme.spacing(AstryxSpacingToken.spacing1),
                bottom: theme.spacing(AstryxSpacingToken.spacing1),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: widget.language == null
                        ? const SizedBox.shrink()
                        : AstryxText(
                            widget.language!,
                            type: AstryxTextType.supporting,
                            color: AstryxTextColor.secondary,
                          ),
                  ),
                  if (widget.showCopy)
                    AstryxIconButton(
                      icon: _copied
                          ? AstryxIconName.check
                          : AstryxIconName.copy,
                      label: _copied ? l10n.codeCopied : l10n.codeCopy,
                      size: AstryxButtonSize.sm,
                      variant: AstryxButtonVariant.ghost,
                      onPressed: _copy,
                    ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(pad, showHeader ? 0 : pad, pad, pad),
            child: body,
          ),
        ],
      ),
    );
  }
}
