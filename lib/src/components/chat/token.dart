/// Inline chips standing for entities, and the field that makes them.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One chip standing for an entity — a person, a file, a label.
///
/// Upstream's `Token`, with `Chip` on the end because `AstryxToken` is already
/// the **design token** interface every token enum implements. A design system
/// cannot have two things called Token, and the older one is load-bearing in
/// every theme.
///
/// Not an `AstryxBadge`: a badge is a *label*, static and never removable,
/// while
/// a token is a value somebody put there and can take away again. The two look
/// similar and behave nothing alike, which is why they are separate widgets
/// rather than a flag.
///
/// {@tool snippet}
/// ```dart
/// AstryxTokenChip(
///   'deploy-log.txt',
///   icon: AstryxIconName.copy,
///   onRemove: () => _detach(file),
/// )
/// ```
/// {@end-tool}
class AstryxTokenChip extends StatelessWidget {
  /// Creates a token.
  const AstryxTokenChip(
    this.label, {
    super.key,
    this.icon,
    this.onRemove,
    this.onPressed,
    this.enabled = true,
    this.semanticsLabel,
  });

  /// The entity's name.
  final String label;

  /// A glyph before the label.
  final AstryxIconName? icon;

  /// Called when the token's remove button is pressed.
  ///
  /// Null omits the button — for a token that is presented rather than chosen,
  /// such as a mention inside a message that has already been sent.
  final VoidCallback? onRemove;

  /// Called when the token itself is pressed — opening what it stands for.
  final VoidCallback? onPressed;

  /// Whether the token responds.
  final bool enabled;

  /// Overrides what a screen reader announces for the token.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing(AstryxSpacingToken.spacing1),
      children: <Widget>[
        if (icon != null)
          AstryxIcon(
            icon!,
            size: AstryxIconSize.xsm,
            color: enabled
                ? AstryxIconColor.secondary
                : AstryxIconColor.disabled,
          ),
        AstryxText(
          label,
          type: AstryxTextType.supporting,
          color: enabled ? AstryxTextColor.primary : AstryxTextColor.disabled,
          maxLines: 1,
        ),
        if (onRemove != null)
          AstryxIconButton(
            icon: AstryxIconName.close,
            // Named for what it removes: a row of five buttons all called
            // "Remove" is a row a screen-reader user cannot choose from.
            label: l10n.tokenRemove(label),
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            enabled: enabled,
            onPressed: onRemove,
          ),
      ],
    );

    final surface = Container(
      padding: EdgeInsetsDirectional.only(
        start: theme.spacing(AstryxSpacingToken.spacing2),
        end: onRemove == null
            ? theme.spacing(AstryxSpacingToken.spacing2)
            : theme.spacing(AstryxSpacingToken.spacing1),
        top: theme.spacing(AstryxSpacingToken.spacing1),
        bottom: theme.spacing(AstryxSpacingToken.spacing1),
      ),
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      child: content,
    );

    if (onPressed == null) {
      return Semantics(
        container: true,
        explicitChildNodes: true,
        label: semanticsLabel ?? label,
        child: surface,
      );
    }

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: semanticsLabel ?? label,
      onTap: enabled ? onPressed : null,
      // The remove button keeps its own node inside the pressable token, which
      // is the one case where nesting is right: they do different things, and a
      // reader has to be able to pick.
      explicitChildNodes: true,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: surface,
      ),
    );
  }
}

/// A field that turns what is typed into [AstryxTokenChip]s.
///
/// Upstream's `Tokenizer`. For free text that becomes a set — recipients, tags,
/// labels — where the values are not from a list. When they *are* from a list,
/// `AstryxMultiSelector` is the widget: it can show what the options are, and
/// this cannot.
///
/// {@tool snippet}
/// ```dart
/// AstryxTokenizer(
///   label: 'Recipients',
///   values: _to,
///   onChanged: (values) => setState(() => _to = values),
/// )
/// ```
/// {@end-tool}
class AstryxTokenizer extends StatefulWidget {
  /// Creates a tokenizing field.
  const AstryxTokenizer({
    required this.values,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.icon,
    this.validate,
    this.allowDuplicates = false,
    this.delimiters = const <String>[','],
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.focusNode,
    this.autofocus = false,
  });

  /// The committed values, in the order they were added.
  final List<String> values;

  /// Called with the new set whenever one is added or removed.
  final ValueChanged<List<String>>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown while the field is empty.
  final String? placeholder;

  /// A glyph on every token.
  final AstryxIconName? icon;

  /// Whether a candidate may be committed. Null accepts anything non-empty.
  ///
  /// Rejection is silent by design here: the text stays in the field, so the
  /// user can see what was refused and fix it. Use [status] to say why.
  final bool Function(String candidate)? validate;

  /// Whether the same value may appear twice.
  final bool allowDuplicates;

  /// Characters that commit the current text as a token.
  ///
  /// Enter always commits. A comma does too by default, because a list of
  /// addresses is something people paste.
  final List<String> delimiters;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// {@macro AstryxField.width}
  final double? width;

  /// The text field's focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether the field takes focus when first built.
  final bool autofocus;

  @override
  State<AstryxTokenizer> createState() => _AstryxTokenizerState();
}

class _AstryxTokenizerState extends State<AstryxTokenizer> {
  final TextEditingController _draft = TextEditingController();
  FocusNode? _internalFocusNode;
  bool _focused = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  bool get _interactive => widget.enabled && widget.onChanged != null;

  /// Commits [candidates] as one change.
  ///
  /// One `onChanged` for the whole batch, not one per value: `widget.values` is
  /// the *parent's* list and does not update until it rebuilds, so committing
  /// twice in a frame built the second value on top of a stale list and threw
  /// the first away. Pasting "a@x.com, b@x.com" is exactly that case.
  ///
  /// Returns whether anything was accepted, so the caller knows whether to
  /// clear the draft.
  bool _commitAll(Iterable<String> candidates) {
    if (!_interactive) return false;

    final next = <String>[...widget.values];
    for (final raw in candidates) {
      final candidate = raw.trim();
      if (candidate.isEmpty) continue;
      if (!(widget.validate?.call(candidate) ?? true)) continue;
      if (!widget.allowDuplicates && next.contains(candidate)) continue;
      next.add(candidate);
    }

    if (next.length == widget.values.length) return false;
    widget.onChanged!(next);
    return true;
  }

  void _commit(String raw) {
    final accepted = _commitAll(<String>[raw]);
    // A rejected candidate keeps its text, so the user can see what was refused
    // and fix it. A duplicate does not: it is already there, and leaving it in
    // the field reads as the press not having registered.
    if (accepted ||
        (!widget.allowDuplicates && widget.values.contains(raw.trim()))) {
      _draft.clear();
    }
  }

  void _removeAt(int index) {
    if (!_interactive) return;
    final next = <String>[...widget.values]..removeAt(index);
    widget.onChanged!(next);
  }

  void _handleChanged(String text) {
    // A delimiter commits everything before it, so pasting
    // "a@x.com, b@x.com," lands as two tokens rather than one long string.
    for (final delimiter in widget.delimiters) {
      if (!text.contains(delimiter)) continue;
      final parts = text.split(delimiter);
      _commitAll(parts.take(parts.length - 1));
      _draft.text = parts.last.trimLeft();
      return;
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Backspace on an empty draft takes the last token back — the behaviour
    // every tokenising field has, and the only way to undo one without reaching
    // for the pointer.
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _draft.text.isEmpty &&
        widget.values.isNotEmpty) {
      _removeAt(widget.values.length - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final label = widget.label ?? l10n.tokenizerLabel;

    final field = AstryxTextInput(
      controller: _draft,
      focusNode: _focusNode,
      label: label,
      labelHidden: true,
      placeholder: widget.values.isEmpty
          ? (widget.placeholder ?? l10n.tokenizerPlaceholder)
          : null,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: _handleChanged,
      onSubmitted: _commit,
    );

    final tokens = <Widget>[
      for (var i = 0; i < widget.values.length; i++)
        AstryxTokenChip(
          widget.values[i],
          icon: widget.icon,
          enabled: widget.enabled,
          onRemove: _interactive ? () => _removeAt(i) : null,
        ),
    ];

    final content = Wrap(
      spacing: theme.spacing(AstryxSpacingToken.spacing2),
      runSpacing: theme.spacing(AstryxSpacingToken.spacing2),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ...tokens,
        // The field takes at least this much, so there is always somewhere
        // obvious to type even when the tokens have filled the last row.
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 160),
          child: field,
        ),
      ],
    );

    return AstryxField(
      label: label,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden || widget.label == null,
      width: widget.width,
      child: Focus(
        // Above the field, so Backspace is seen before the text field consumes
        // it — the arrangement `AstryxNumberInput` uses for its arrow keys.
        onKeyEvent: _handleKey,
        canRequestFocus: false,
        skipTraversal: true,
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: label,
          value: widget.values.isEmpty
              ? null
              // Announced as a set: a reader tabbing onto the field is told
              // what
              // is already in it rather than having to walk the tokens.
              : l10n.tokenizerValue(widget.values.length),
          child: content,
        ),
      ),
    );
  }
}
