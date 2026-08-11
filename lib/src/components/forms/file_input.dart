/// A file field: what has been chosen, and the control that chooses it.
library;

import 'package:astryx_ui/src/components/action/button.dart';
import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// A file that has been chosen.
///
/// Deliberately not `dart:io`'s `File`: that type does not exist on the web,
/// and this package builds for every platform Flutter does. What the field
/// needs is the metadata it displays and validates — a name, a size, a type —
/// so that is what it takes, and [handle] carries whatever the application's
/// own picker returned so it can be uploaded later.
@immutable
class AstryxFile {
  /// Creates a chosen file.
  const AstryxFile({
    required this.name,
    this.size,
    this.mimeType,
    this.handle,
  });

  /// The file name, with its extension. Shown, and matched against `accept`.
  final String name;

  /// The size in bytes, if the picker reported one.
  ///
  /// Null means unknown, and an unknown size **passes** a `maxSize` check: a
  /// field must not reject a file because its picker was reticent.
  final int? size;

  /// The MIME type, if the picker reported one.
  final String? mimeType;

  /// The application's own object for this file — an `XFile`, a `File`, a byte
  /// buffer, an upload ticket.
  ///
  /// The package never looks inside it.
  final Object? handle;

  /// The lower-cased extension, including the dot, or null when there is none.
  String? get extension {
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) return null;
    return name.substring(dot).toLowerCase();
  }
}

/// What a [AstryxFileInput] asks its picker for.
@immutable
class AstryxFilePickRequest {
  /// Creates a request.
  const AstryxFilePickRequest({
    this.accept = const <String>[],
    this.multiple = false,
  });

  /// The accepted types, in the HTML `accept` vocabulary — `.pdf`, `image/*`,
  /// `text/csv`.
  ///
  /// A hint for the dialog. The field re-checks whatever comes back, because a
  /// platform dialog is free to ignore it.
  final List<String> accept;

  /// Whether more than one file may be returned.
  final bool multiple;
}

/// Opens a file dialog and returns what was chosen.
///
/// Return an empty list for a cancelled dialog.
///
/// **This is a seam, not an omission.** Flutter has no file picker in its core
/// libraries, and a design system that reached for a plugin would make every
/// consumer inherit that plugin's platform setup. Navigation works the same way
/// here — see `AstryxLinkDelegate`. Wire `file_selector`, `image_picker`, a
/// platform channel of your own, or a fake in a test.
typedef AstryxFilePicker =
    Future<List<AstryxFile>> Function(AstryxFilePickRequest request);

/// How a [AstryxFileInput] presents itself.
enum AstryxFileInputMode {
  /// A control the height of a text field, with a button at the end.
  input,

  /// A tall bordered panel with an icon, for a form whose subject *is* the
  /// upload.
  dropzone,
}

/// A field for choosing files.
///
/// It owns the chosen list, the display, and the validation — the count, the
/// size and the accepted types, with upstream's own messages. It does not own
/// the dialog: [onPick] supplies that. See [AstryxFilePicker] for why.
///
/// {@tool snippet}
/// ```dart
/// AstryxFileInput(
///   label: 'Attachments',
///   files: _files,
///   accept: const <String>['.pdf', 'image/*'],
///   multiple: true,
///   maxFiles: 3,
///   maxSize: 5 * 1024 * 1024,
///   onPick: (request) => myPicker.open(request),
///   onChanged: (files) => setState(() => _files = files),
/// )
/// ```
/// {@end-tool}
///
/// Rejected files never reach [onChanged]; the field keeps the ones that passed
/// and shows the first complaint as an error. Pass a [status] of your own and
/// it wins, so a server-side rejection is not overwritten by a local one.
class AstryxFileInput extends StatefulWidget {
  /// Creates a file field.
  const AstryxFileInput({
    required this.label,
    required this.files,
    super.key,
    this.onChanged,
    this.onPick,
    this.accept = const <String>[],
    this.multiple = false,
    this.maxFiles,
    this.maxSize,
    this.mode = AstryxFileInputMode.input,
    this.description,
    this.status,
    this.placeholder,
    this.enabled = true,
    this.loading = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.focusNode,
    this.autofocus = false,
  }) : assert(maxFiles == null || maxFiles > 0, 'maxFiles must be positive'),
       assert(maxSize == null || maxSize > 0, 'maxSize must be positive');

  /// {@macro AstryxField.label}
  final String label;

  /// The files currently chosen. Empty for none.
  final List<AstryxFile> files;

  /// Called with the new list — the files that passed validation.
  ///
  /// Null makes the field inert.
  final ValueChanged<List<AstryxFile>>? onChanged;

  /// Opens the dialog. Null leaves the field inert, as a null [onChanged] does.
  final AstryxFilePicker? onPick;

  /// The accepted types, in the HTML `accept` vocabulary.
  ///
  /// `.pdf` matches an extension, `image/*` a type family, `text/csv` exactly.
  /// A file whose MIME type is unknown is matched on its extension alone.
  final List<String> accept;

  /// Whether more than one file may be chosen.
  final bool multiple;

  /// The most files that may be chosen. Ignored unless [multiple].
  ///
  /// A longer selection is **truncated** to this many, with a complaint —
  /// upstream's behaviour.
  final int? maxFiles;

  /// The largest accepted size in bytes.
  final int? maxSize;

  /// Whether to present as a field or as a panel.
  final AstryxFileInputMode mode;

  /// {@macro AstryxField.description}
  ///
  /// The place to say what the limits are *before* somebody hits one.
  final String? description;

  /// {@macro AstryxField.status}
  ///
  /// Takes precedence over the field's own validation message.
  final AstryxFieldStatus? status;

  /// The text shown when nothing is chosen. Defaults to "Choose file".
  final String? placeholder;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether an upload is in flight. Shows a spinner and refuses the dialog.
  final bool loading;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// A fixed width for the whole field.
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  /// Formats [bytes] the way upstream's `formatFileSize` does.
  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  State<AstryxFileInput> createState() => _AstryxFileInputState();
}

class _AstryxFileInputState extends State<AstryxFileInput> {
  FocusNode? _internalFocusNode;
  bool _focused = false;

  /// The first complaint from the last selection, or null.
  String? _validationError;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AstryxFileInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  bool get _interactive =>
      widget.enabled &&
      !widget.loading &&
      widget.onChanged != null &&
      widget.onPick != null;

  /// Whether [file] matches one of the `accept` patterns.
  bool _accepts(AstryxFile file) {
    if (widget.accept.isEmpty) return true;

    final type = file.mimeType?.toLowerCase();
    final extension = file.extension;

    for (final raw in widget.accept) {
      final pattern = raw.trim().toLowerCase();
      if (pattern.isEmpty) continue;

      if (pattern.startsWith('.')) {
        if (extension == pattern) return true;
        continue;
      }
      if (pattern.endsWith('/*')) {
        final family = pattern.substring(0, pattern.length - 1);
        if (type != null && type.startsWith(family)) return true;
        continue;
      }
      if (type != null && type == pattern) return true;
    }

    return false;
  }

  /// Filters [picked], collecting the complaints. Upstream's `validateFiles`.
  (List<AstryxFile>, List<String>) _validate(
    List<AstryxFile> picked,
    AstryxLocalizations l10n,
  ) {
    final errors = <String>[];
    var valid = <AstryxFile>[];

    for (final file in picked) {
      if (!_accepts(file)) {
        errors.add(l10n.fileInputWrongType(file.name));
        continue;
      }
      // An unknown size passes: the picker not saying is not the file being
      // too big.
      final size = file.size;
      if (widget.maxSize != null && size != null && size > widget.maxSize!) {
        errors.add(
          l10n.fileInputTooLarge(
            file.name,
            AstryxFileInput.formatSize(widget.maxSize!),
          ),
        );
        continue;
      }
      valid.add(file);
    }

    if (!widget.multiple && valid.length > 1) {
      valid = valid.sublist(0, 1);
    }
    if (widget.multiple &&
        widget.maxFiles != null &&
        valid.length > widget.maxFiles!) {
      errors.add(l10n.fileInputTooMany(widget.maxFiles!));
      valid = valid.sublist(0, widget.maxFiles);
    }

    return (valid, errors);
  }

  Future<void> _pick() async {
    if (!_interactive) return;

    final l10n = AstryxLocalizations.of(context);
    final picked = await widget.onPick!(
      AstryxFilePickRequest(accept: widget.accept, multiple: widget.multiple),
    );

    if (!mounted) return;
    // A cancelled dialog leaves the selection and the last complaint alone: a
    // user who backed out has not fixed or broken anything.
    if (picked.isEmpty) return;

    final (valid, errors) = _validate(picked, l10n);
    setState(() => _validationError = errors.isEmpty ? null : errors.first);
    widget.onChanged!(valid);
  }

  void _clear() {
    if (widget.onChanged == null || !widget.enabled || widget.loading) return;
    setState(() => _validationError = null);
    widget.onChanged!(const <AstryxFile>[]);
    _focusNode.requestFocus();
  }

  /// What the field says it is holding.
  String _summary(AstryxLocalizations l10n) {
    if (widget.files.isEmpty) {
      return widget.placeholder ??
          (widget.multiple
              ? l10n.fileInputChooseFiles
              : l10n.fileInputChooseFile);
    }
    if (widget.files.length == 1) {
      final file = widget.files.first;
      final size = file.size;
      return size == null
          ? file.name
          : '${file.name} · ${AstryxFileInput.formatSize(size)}';
    }
    return l10n.fileInputSelected(widget.files.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final enabled = widget.enabled && (scope?.enabled ?? true);

    // The caller's status wins: a server said no for a reason this widget
    // cannot know, and overwriting it with "wrong file type" would be a lie.
    final status =
        widget.status ??
        (_validationError == null
            ? null
            : AstryxFieldStatus.error(_validationError));

    final control = switch (widget.mode) {
      AstryxFileInputMode.input => _buildInput(context, l10n, enabled, status),
      AstryxFileInputMode.dropzone => _buildDropzone(
        context,
        l10n,
        enabled,
        status,
      ),
    };

    return AstryxField(
      label: widget.label,
      description: widget.description,
      status: status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: Semantics(
        container: true,
        button: true,
        label: widget.label,
        // The summary is the field's value: a reader needs "Attachments,
        // report.pdf", not "Attachments, button".
        value: _summary(l10n),
        enabled: _interactive,
        onTap: _interactive ? _pick : null,
        validationResult: status?.type == AstryxFieldStatusType.error
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        // The buttons inside keep their own nodes: "Choose files" and "Remove
        // the files chosen for Attachments" are the two things a reader has to
        // be able to find, and folding them into this node would lose both.
        child: control,
      ),
    );
  }

  /// The field-height presentation: summary, then the controls.
  Widget _buildInput(
    BuildContext context,
    AstryxLocalizations l10n,
    bool enabled,
    AstryxFieldStatus? status,
  ) {
    final theme = AstryxTheme.of(context);

    return Row(
      spacing: theme.spacing(AstryxSpacingToken.spacing2),
      children: <Widget>[
        Expanded(
          child: AstryxText(
            _summary(l10n),
            color: widget.files.isEmpty
                ? AstryxTextColor.secondary
                : AstryxTextColor.primary,
            maxLines: 1,
          ),
        ),
        if (widget.loading) AstryxSpinner(label: l10n.buttonLoading),
        if (widget.files.isNotEmpty && enabled && !widget.loading)
          AstryxIconButton(
            icon: AstryxIconName.close,
            label: l10n.fileInputClear(widget.label),
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: _clear,
          ),
        AstryxButton(
          label: widget.multiple
              ? l10n.fileInputChooseFiles
              : l10n.fileInputChooseFile,
          size: AstryxButtonSize.sm,
          enabled: _interactive,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onPressed: _interactive ? _pick : null,
        ),
      ],
    );
  }

  /// The panel presentation: a pressable bordered area.
  Widget _buildDropzone(
    BuildContext context,
    AstryxLocalizations l10n,
    bool enabled,
    AstryxFieldStatus? status,
  ) {
    final theme = AstryxTheme.of(context);

    final border = switch (status?.type) {
      AstryxFieldStatusType.error => theme.color(AstryxColorToken.error),
      AstryxFieldStatusType.warning => theme.color(AstryxColorToken.warning),
      AstryxFieldStatusType.success => theme.color(AstryxColorToken.success),
      null => theme.color(
        _focused ? AstryxColorToken.accent : AstryxColorToken.borderEmphasized,
      ),
    };

    final panel = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        border: Border.all(color: border, width: theme.borderWidth()),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing(AstryxSpacingToken.spacing2),
          children: <Widget>[
            if (widget.loading)
              AstryxSpinner(
                size: AstryxSpinnerSize.lg,
                label: l10n.buttonLoading,
              )
            else
              const AstryxIcon(
                AstryxIconName.arrowUp,
                size: AstryxIconSize.lg,
                color: AstryxIconColor.secondary,
              ),
            AstryxText(
              _summary(l10n),
              color: widget.files.isEmpty
                  ? AstryxTextColor.secondary
                  : AstryxTextColor.primary,
              maxLines: 2,
            ),
            if (widget.files.isNotEmpty && enabled && !widget.loading)
              AstryxButton(
                label: l10n.fileInputClear(widget.label),
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: _clear,
              ),
          ],
        ),
      ),
    );

    return AstryxFocusRing(
      focused: _focused,
      borderRadius: theme.borderRadius(AstryxRadiusToken.container),
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: _interactive,
        child: AstryxTapTarget(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _interactive ? _pick : null,
            child: panel,
          ),
        ),
      ),
    );
  }
}
