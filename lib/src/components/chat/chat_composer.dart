/// The input a message is written in.
library;

import 'package:astryx_ui/src/components/chat/chat_buttons.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The composer at the foot of a conversation.
///
/// A port of upstream's `ChatComposer`, `ChatComposerInput` and
/// `ChatComposerDrawer`: a field that grows with what is typed, a send control
/// that doubles as *stop generating*, a row for the controls beside it, and a
/// drawer above it for what has been attached.
///
/// {@tool snippet}
/// ```dart
/// AstryxChatComposer(
///   controller: _draft,
///   generating: _isGenerating,
///   onSubmit: _send,
///   onStop: _stop,
/// )
/// ```
/// {@end-tool}
///
/// **Enter sends; Shift+Enter starts a line.** That is the convention every
/// chat interface has settled on, and getting it backwards is the single
/// fastest way to make a composer feel wrong. A newline is still reachable, and
/// on a touch keyboard the return key inserts one — there is no Shift to hold,
/// so the send button is the only way to send there, which is why it is always
/// present rather than appearing on hover.
class AstryxChatComposer extends StatefulWidget {
  /// Creates a composer.
  const AstryxChatComposer({
    required this.controller,
    super.key,
    this.onSubmit,
    this.onStop,
    this.generating = false,
    this.placeholder,
    this.label,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.drawer,
    this.footer,
    this.minLines = 1,
    this.maxLines = 8,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.submitOnEnter = true,
  });

  /// The draft being written.
  ///
  /// Required, unlike most text fields here: a composer's text is read by the
  /// send button, cleared on submit and often restored from a draft, so an
  /// internal controller nobody can reach would be useless.
  final TextEditingController controller;

  /// Called with the trimmed draft when it is sent.
  ///
  /// Not called for an empty or whitespace-only draft, so a stray Enter cannot
  /// post nothing. Clearing the controller afterwards is the caller's — a send
  /// that failed should not have thrown the text away.
  final ValueChanged<String>? onSubmit;

  /// Called when the user asks to stop generating.
  ///
  /// The send control becomes a stop control while [generating]; without this
  /// callback it is simply disabled, because a stop button that does nothing is
  /// worse than none.
  final VoidCallback? onStop;

  /// Whether a reply is currently being generated.
  final bool generating;

  /// Text shown while the field is empty.
  final String? placeholder;

  /// The field's accessible name. Defaults to "Message".
  ///
  /// Not shown: the composer's purpose is obvious from where it sits, and a
  /// visible label above a chat input is a label nobody needs. It is still
  /// announced, which is the part that matters.
  final String? label;

  /// Controls before the field — attach, a model picker, a tool menu.
  final List<Widget> leading;

  /// Controls between the field and the send button — dictation, a template
  /// picker.
  final List<Widget> trailing;

  /// Content above the field, inside the same surface.
  ///
  /// Upstream's `ChatComposerDrawer`: the attachments, the referenced files,
  /// the selected context. Part of the composer rather than floating above it,
  /// so it is obvious what is about to be sent.
  final Widget? drawer;

  /// Content below the whole composer — a hint, a token count, a disclaimer.
  final Widget? footer;

  /// The smallest number of visible lines.
  final int minLines;

  /// The most lines before the field scrolls instead of growing.
  ///
  /// Eight by default. A composer that grows without limit eventually leaves no
  /// transcript to write about.
  final int maxLines;

  /// Whether the composer accepts input.
  final bool enabled;

  /// Whether the field takes focus when first built.
  final bool autofocus;

  /// The field's focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether Enter sends.
  ///
  /// False makes Enter a newline and the button the only way to send — right
  /// for a composer whose messages are routinely several paragraphs.
  final bool submitOnEnter;

  @override
  State<AstryxChatComposer> createState() => _AstryxChatComposerState();
}

class _AstryxChatComposerState extends State<AstryxChatComposer> {
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(AstryxChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    // The listener comes off the *caller's* controller: this widget attached
    // it, so this widget removes it.
    widget.controller.removeListener(_handleTextChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  /// Rebuilds so the send button can follow the draft between empty and not.
  void _handleTextChange() {
    if (mounted) setState(() {});
  }

  bool get _hasDraft => widget.controller.text.trim().isNotEmpty;

  bool get _canSend =>
      widget.enabled &&
      !widget.generating &&
      _hasDraft &&
      widget.onSubmit != null;

  void _submit() {
    if (!_canSend) return;
    widget.onSubmit!(widget.controller.text.trim());
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.submitOnEnter) return KeyEventResult.ignored;

    final isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter) return KeyEventResult.ignored;

    // Shift+Enter is a newline, so it is left for the field. Nothing else is
    // claimed, which keeps IME composition — where Enter commits a candidate
    // — working: a composing Enter never reaches here.
    if (HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }

    _submit();
    // Handled either way: an Enter that could not send must not also insert a
    // line nobody asked for.
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    final field = AstryxTextInput.multiline(
      controller: widget.controller,
      focusNode: _focusNode,
      label: widget.label ?? l10n.chatComposerLabel,
      labelHidden: true,
      placeholder: widget.placeholder ?? l10n.chatComposerPlaceholder,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
    );

    // The control is `AstryxChatSendButton`, not a private copy of it: the
    // send-becomes-stop behaviour is a component upstream ships on its own, and
    // two implementations of it would eventually disagree.
    final sendButton = AstryxChatSendButton(
      canSend: _canSend,
      generating: widget.generating,
      enabled: widget.enabled,
      onSend: _submit,
      onStop: widget.onStop,
    );

    final row = AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ...widget.leading,
        // The field takes the leftover width; every control keeps its own.
        Expanded(
          child: Focus(
            // Above the field's own node, so Enter is seen before the text
            // field turns it into a newline — the same arrangement
            // `AstryxNumberInput` uses for its arrow keys.
            onKeyEvent: _handleKey,
            canRequestFocus: false,
            skipTraversal: true,
            child: field,
          ),
        ),
        ...widget.trailing,
        sendButton,
      ],
    );

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        if (widget.drawer != null)
          Container(
            padding: EdgeInsets.all(
              theme.spacing(AstryxSpacingToken.spacing2),
            ),
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundMuted),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            ),
            child: widget.drawer,
          ),
        row,
        ?widget.footer,
      ],
    );
  }
}
