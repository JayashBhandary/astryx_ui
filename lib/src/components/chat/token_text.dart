/// Entities inside a run of text — shown, and typed.
library;

import 'package:astryx_ui/src/components/chat/token.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What one entity in a run of text stands for.
///
/// The value a caller cares about — a user id, a file path — travels in
/// [value],
/// so a press can act on the thing rather than on the string that named it.
@immutable
class AstryxTextToken {
  /// Describes an entity.
  const AstryxTextToken({this.icon, this.onPressed, this.value, this.tooltip});

  /// A glyph on the chip.
  final AstryxIconName? icon;

  /// Called when the chip is pressed.
  final VoidCallback? onPressed;

  /// What the entity *is*, for the caller's own use.
  final Object? value;

  /// A phrase describing the entity, if the label alone is cryptic.
  final String? tooltip;

  @override
  bool operator ==(Object other) =>
      other is AstryxTextToken &&
      other.icon == icon &&
      other.value == value &&
      other.tooltip == tooltip;

  @override
  int get hashCode => Object.hash(icon, value, tooltip);
}

/// Text with its mentions and references drawn as [AstryxTokenChip]s.
///
/// Upstream's `ChatTokenizedText`. Read-only, which is what makes it
/// straightforward: the chips are `WidgetSpan`s inside a `Text.rich`, and there
/// is no caret to walk into the middle of one.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatTokenizedText(
///   'Ask @ada about deploy-log.txt before 14:00',
///   tokens: <String, AstryxTextToken>{
///     '@ada': AstryxTextToken(value: ada.id, onPressed: _openProfile),
///     'deploy-log.txt': AstryxTextToken(icon: AstryxIconName.copy),
///   },
/// )
/// ```
/// {@end-tool}
///
/// Matching is by literal run, longest first — so `@ada` and `@adam` can both
/// be
/// tokens without the shorter one eating the longer.
class AstryxChatTokenizedText extends StatelessWidget {
  /// Creates tokenized text.
  const AstryxChatTokenizedText(
    this.text, {
    required this.tokens,
    super.key,
    this.type = AstryxTextType.body,
    this.color = AstryxTextColor.primary,
    this.semanticsLabel,
  });

  /// The whole message.
  final String text;

  /// The runs to draw as chips, keyed by the literal text they appear as.
  final Map<String, AstryxTextToken> tokens;

  /// {@macro AstryxText.type}
  final AstryxTextType type;

  /// {@macro AstryxText.color}
  final AstryxTextColor color;

  /// What a screen reader announces. Defaults to [text], chips included.
  ///
  /// The plain string is the right announcement: "Ask at-ada about
  /// deploy-log.txt" is the sentence. A chip announced as a separate control
  /// mid-sentence is a sentence nobody can follow.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final style = theme.textStyle(type.role);

    if (tokens.isEmpty) {
      return AstryxText(text, type: type, color: color);
    }

    return Semantics(
      container: true,
      label: semanticsLabel ?? text,
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(children: _spans(context, theme, style)),
          style: style,
        ),
      ),
    );
  }

  List<InlineSpan> _spans(
    BuildContext context,
    AstryxThemeData theme,
    TextStyle style,
  ) {
    // Longest first, so `@adam` is matched before `@ada` and a longer mention
    // is
    // never chopped in half by a shorter one that happens to prefix it.
    final keys = tokens.keys.where((key) => key.isNotEmpty).toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    var index = 0;

    void flush() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }

    while (index < text.length) {
      final key = keys.firstWhere(
        (candidate) => text.startsWith(candidate, index),
        orElse: () => '',
      );

      if (key.isEmpty) {
        buffer.write(text[index]);
        index++;
        continue;
      }

      flush();
      final token = tokens[key]!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AstryxTokenChip(
            key,
            icon: token.icon,
            onPressed: token.onPressed,
            semanticsLabel: token.tooltip,
          ),
        ),
      );
      index += key.length;
    }

    flush();
    return spans;
  }
}

/// A [TextEditingController] that styles the tokens inside what is being typed.
///
/// The port of upstream's `ChatComposerTokenElement`, and the honest shape of
/// it: upstream can put a real element inside a `contenteditable`, and
/// Flutter's
/// `EditableText` edits a **`String`**. A `WidgetSpan` in an editable's span
/// tree breaks the caret — arrow keys step over a chip as if it were one
/// character, selection maths goes wrong, and backspace deletes something other
/// than what is highlighted.
///
/// So a token here is *styled text*, not a widget: an accent colour on a tinted
/// ground, rendered by [buildTextSpan]. It reads as a chip, the caret behaves
/// exactly as it does anywhere else, and nothing about editing is surprising.
/// [AstryxChatTokenizedText] draws the real chips once the message is sent,
/// where there is no caret to protect.
///
/// {@tool snippet}
/// ```dart
/// final controller = AstryxTokenTextController(
///   tokens: <String, AstryxTextToken>{'@ada': const AstryxTextToken()},
/// );
///
/// AstryxChatComposer(controller: controller, onSubmit: _send)
/// ```
/// {@end-tool}
class AstryxTokenTextController extends TextEditingController {
  /// Creates a controller that styles [tokens].
  AstryxTokenTextController({
    Map<String, AstryxTextToken> tokens = const <String, AstryxTextToken>{},
    super.text,
  }) : _tokens = tokens;

  Map<String, AstryxTextToken> _tokens;

  /// The runs to style, keyed by the literal text they appear as.
  Map<String, AstryxTextToken> get tokens => _tokens;

  set tokens(Map<String, AstryxTextToken> value) {
    if (_tokens == value) return;
    _tokens = value;
    // Notifies so the field repaints: the text did not change, but what it
    // *means* did.
    notifyListeners();
  }

  /// The token runs present in the current text, in the order they appear.
  ///
  /// What a caller sends alongside the message — the ids of everybody
  /// mentioned.
  List<String> get present {
    final found = <String>[];
    var index = 0;
    final keys = _sortedKeys;

    while (index < text.length) {
      final key = keys.firstWhere(
        (candidate) => text.startsWith(candidate, index),
        orElse: () => '',
      );
      if (key.isEmpty) {
        index++;
        continue;
      }
      found.add(key);
      index += key.length;
    }
    return found;
  }

  List<String> get _sortedKeys =>
      _tokens.keys.where((key) => key.isNotEmpty).toList()
        ..sort((a, b) => b.length.compareTo(a.length));

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // Composing text is mid-IME and must be left exactly as the framework wants
    // it: styling a half-typed candidate would fight the underline the platform
    // draws under it.
    if (_tokens.isEmpty || (withComposing && !value.isComposingRangeValid)) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    final theme = AstryxTheme.maybeOf(context);
    if (theme == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    final tokenStyle = TextStyle(
      color: theme.color(AstryxColorToken.textAccent),
      backgroundColor: theme.color(AstryxColorToken.accentMuted),
      fontWeight: theme.fontWeight(AstryxFontWeightToken.medium),
    );

    final keys = _sortedKeys;
    final children = <InlineSpan>[];
    final buffer = StringBuffer();
    var index = 0;

    void flush() {
      if (buffer.isEmpty) return;
      children.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }

    while (index < text.length) {
      final key = keys.firstWhere(
        (candidate) => text.startsWith(candidate, index),
        orElse: () => '',
      );
      if (key.isEmpty) {
        buffer.write(text[index]);
        index++;
        continue;
      }
      flush();
      // A `TextSpan`, never a `WidgetSpan`: every character still counts as
      // itself, so the caret, selection and backspace are untouched.
      children.add(TextSpan(text: key, style: tokenStyle));
      index += key.length;
    }
    flush();

    return TextSpan(style: style, children: children);
  }
}
