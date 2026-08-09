/// Single-line and multi-line text entry.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_selection.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A single-line text field.
///
/// Built on [EditableText] rather than Material's `TextField`, per ADR-002.
/// That means the platform behaviours come for free and are expected to work:
/// selection handles and the context menu on mobile, the right-click menu on
/// desktop, IME composition, autofill, and the iOS keyboard appearance.
///
/// {@tool snippet}
/// ```dart
/// AstryxTextInput(
///   label: 'Email',
///   controller: _email,
///   status: _error == null ? null : AstryxFieldStatus.error(_error!),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxTextArea], for multi-line entry.
///  * [AstryxField], the label and validation wrapper this builds on.
class AstryxTextInput extends StatefulWidget {
  /// Creates a single-line text field.
  const AstryxTextInput({
    super.key,
    this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.description,
    this.status,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.showClear = false,
    this.leading,
    this.trailing,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.width,
  }) : minLines = 1,
       maxLines = 1,
       _multiline = false;

  /// Creates a multi-line text field.
  const AstryxTextInput.multiline({
    super.key,
    this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.description,
    this.status,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.leading,
    this.trailing,
    this.autofocus = false,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.width,
    this.minLines = 3,
    this.maxLines = 6,
  }) : obscureText = false,
       showClear = false,
       keyboardType = TextInputType.multiline,
       textInputAction = TextInputAction.newline,
       _multiline = true;

  /// {@macro AstryxField.label}
  ///
  /// Null omits the field wrapper entirely, for an input inside a layout that
  /// labels it some other way — a table cell, a toolbar.
  final String? label;

  /// The text being edited.
  ///
  /// A controller is required for anything but a throwaway field; without one
  /// this widget owns an internal controller it disposes itself.
  final TextEditingController? controller;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Text shown when the field is empty.
  final String? placeholder;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The control height.
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the value can be read but not changed.
  final bool readOnly;

  /// Whether to hide the value, as for a password.
  final bool obscureText;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Whether to show a button that clears the value.
  final bool showClear;

  /// Content before the text.
  final Widget? leading;

  /// Content after the text, before the clear and status icons.
  final Widget? trailing;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// The keyboard to request.
  final TextInputType? keyboardType;

  /// What the keyboard's action key does.
  final TextInputAction? textInputAction;

  /// Formatters applied as the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// Autofill hints, so the platform can offer to fill the field.
  final Iterable<String>? autofillHints;

  /// The maximum number of characters.
  final int? maxLength;

  /// {@macro AstryxField.width}
  final double? width;

  /// The minimum number of visible lines.
  final int minLines;

  /// The maximum number of visible lines before scrolling.
  final int maxLines;

  final bool _multiline;

  @override
  State<AstryxTextInput> createState() => _AstryxTextInputState();
}

class _AstryxTextInputState extends State<AstryxTextInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;

  late final ScrollController _scrollController = ScrollController();

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool _focused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(AstryxTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      _controller.addListener(_handleTextChange);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    // Listeners come off the *caller's* objects too — this widget attached
    // them, so this widget removes them.
    widget.focusNode?.removeListener(_handleFocusChange);
    widget.controller?.removeListener(_handleTextChange);
    _internalFocusNode?.dispose();
    _internalController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (!mounted || hasText == _hasText) return;
    setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final status = widget.status ?? scope?.status;
    final size = resolveAstryxInputSize(context, widget.size);
    final enabled = widget.enabled && (scope?.enabled ?? true);

    final style = theme
        .textStyle(AstryxTypeRole.body)
        .copyWith(
          color: theme.color(
            enabled
                ? AstryxColorToken.textPrimary
                : AstryxColorToken.textDisabled,
          ),
        );

    final editable = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: style,
      cursorColor: theme.color(AstryxColorToken.accent),
      backgroundCursorColor: theme.color(AstryxColorToken.textDisabled),
      selectionColor: theme.color(AstryxColorToken.accentMuted),
      // Without a delegate there are no selection handles on mobile and no
      // context menu anywhere — two of the platform behaviours this widget is
      // required to keep working.
      selectionControls: AstryxTextSelectionControls(
        color: theme.color(AstryxColorToken.accent),
      ),
      contextMenuBuilder: AstryxTextSelectionToolbar.forEditableText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly || !enabled,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: <TextInputFormatter>[
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
        ...?widget.inputFormatters,
      ],
      autofillHints: widget.autofillHints,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      scrollController: _scrollController,
      // The control scrolls its own overflow. Without this a multiline field
      // inside a ListView hands its scroll to the list and the caret runs off
      // the bottom — the classic bug this widget has to avoid.
      scrollPhysics: const ClampingScrollPhysics(),
      rendererIgnoresPointer: true,
      enableInteractiveSelection: enabled,
      showCursor: enabled && !widget.readOnly,
      keyboardAppearance: theme.brightness,
    );

    final placeholder = widget.placeholder;
    final content = placeholder == null
        ? editable
        : Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              if (!_hasText)
                // Excluded: `Semantics.hint` on the control already carries
                // the description, and a placeholder read as content would be
                // announced as if the user had typed it.
                ExcludeSemantics(
                  child: Text(
                    placeholder,
                    style: style.copyWith(
                      color: theme.color(AstryxColorToken.textSecondary),
                    ),
                    maxLines: widget._multiline ? null : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              editable,
            ],
          );

    final container = AstryxInputContainer(
      focused: _focused,
      size: size,
      status: status,
      enabled: enabled,
      readOnly: widget.readOnly,
      multiline: widget._multiline,
      minHeight: widget._multiline ? theme.size(size.token) * 2 : null,
      onTap: () => _focusNode.requestFocus(),
      leading: widget.leading,
      trailing: _buildTrailing(context, status, enabled, l10n),
      child: content,
    );

    final label = widget.label ?? scope?.label;

    final semantic = Semantics(
      container: true,
      textField: true,
      // The label reaches the control here rather than sitting beside it —
      // Flutter has no `<label for>`, so this association *is* the label.
      label: label,
      hint: _hintFor(scope),
      enabled: enabled,
      readOnly: widget.readOnly,
      obscured: widget.obscureText,
      multiline: widget._multiline,
      focused: _focused,
      validationResult: status?.type == AstryxFieldStatusType.error
          ? SemanticsValidationResult.invalid
          : SemanticsValidationResult.none,
      child: ExcludeSemantics(child: container),
    );

    if (widget.label == null) {
      return widget.width == null
          ? semantic
          : SizedBox(width: widget.width, child: semantic);
    }

    return AstryxField(
      label: widget.label!,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: semantic,
    );
  }

  /// The hint: the description, then the status message.
  String? _hintFor(AstryxFieldScope? scope) {
    final parts = <String>[
      if (widget.description != null && widget.description!.isNotEmpty)
        widget.description!,
      if (widget.status?.message != null && widget.status!.message!.isNotEmpty)
        widget.status!.message!,
    ];
    if (parts.isNotEmpty) return parts.join('. ');
    return scope?.semanticsHint;
  }

  Widget? _buildTrailing(
    BuildContext context,
    AstryxFieldStatus? status,
    bool enabled,
    AstryxLocalizations l10n,
  ) {
    final items = <Widget>[
      if (widget.trailing != null) widget.trailing!,
      if (widget.showClear && _hasText && enabled && !widget.readOnly)
        AstryxIconButton(
          icon: AstryxIconName.close,
          label: l10n.clearField(widget.label ?? ''),
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: _clear,
        ),
      if (status != null)
        AstryxIcon(
          status.type.icon,
          size: AstryxIconSize.sm,
          color: switch (status.type) {
            AstryxFieldStatusType.error => AstryxIconColor.error,
            AstryxFieldStatusType.warning => AstryxIconColor.warning,
            AstryxFieldStatusType.success => AstryxIconColor.success,
          },
        ),
    ];

    if (items.isEmpty) return null;
    if (items.length == 1) return items.first;
    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}

/// A multi-line text field.
///
/// An alias for [AstryxTextInput.multiline], so the widget a caller reaches for
/// matches the name upstream uses.
///
/// {@tool snippet}
/// ```dart
/// AstryxTextArea(
///   label: 'Notes',
///   controller: _notes,
///   minLines: 4,
/// )
/// ```
/// {@end-tool}
class AstryxTextArea extends StatelessWidget {
  /// Creates a multi-line text field.
  const AstryxTextArea({
    super.key,
    this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.placeholder,
    this.description,
    this.status,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.autofocus = false,
    this.maxLength,
    this.width,
    this.minLines = 3,
    this.maxLines = 6,
  });

  /// {@macro AstryxField.label}
  final String? label;

  /// The text being edited.
  final TextEditingController? controller;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Text shown when the field is empty.
  final String? placeholder;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The control height step.
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the value can be read but not changed.
  final bool readOnly;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// The maximum number of characters.
  final int? maxLength;

  /// {@macro AstryxField.width}
  final double? width;

  /// The minimum number of visible lines.
  final int minLines;

  /// The maximum number of visible lines before the field scrolls.
  final int maxLines;

  @override
  Widget build(BuildContext context) => AstryxTextInput.multiline(
    label: label,
    controller: controller,
    focusNode: focusNode,
    onChanged: onChanged,
    placeholder: placeholder,
    description: description,
    status: status,
    size: size,
    enabled: enabled,
    readOnly: readOnly,
    required: required,
    optional: optional,
    labelHidden: labelHidden,
    autofocus: autofocus,
    maxLength: maxLength,
    width: width,
    minLines: minLines,
    maxLines: maxLines,
  );
}
