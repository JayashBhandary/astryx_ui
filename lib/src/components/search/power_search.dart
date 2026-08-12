/// A search input with structured filters alongside the free text.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/chat/token.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One filter applied to a search.
@immutable
class AstryxSearchFilter {
  /// Describes an applied filter.
  const AstryxSearchFilter({
    required this.field,
    required this.value,
    this.label,
    this.icon,
  });

  /// What is being filtered on — `status`, `owner`, `after`.
  final String field;

  /// What it is being filtered to — `failed`, `ada`, `2026-08-01`.
  final String value;

  /// How to write it. Defaults to `field:value`.
  final String? label;

  /// A glyph on the chip.
  final AstryxIconName? icon;

  /// The chip's text.
  String get text => label ?? '$field:$value';

  @override
  bool operator ==(Object other) =>
      other is AstryxSearchFilter &&
      other.field == field &&
      other.value == value &&
      other.label == label &&
      other.icon == icon;

  @override
  int get hashCode => Object.hash(field, value, label, icon);
}

/// A filter a user can add, and the values it takes.
@immutable
class AstryxSearchFilterOption {
  /// Describes an available filter.
  const AstryxSearchFilterOption({
    required this.field,
    required this.label,
    required this.values,
    this.icon,
  });

  /// The field it filters on.
  final String field;

  /// What the field is called in the menu — "Status", "Owner".
  final String label;

  /// The values it can take.
  ///
  /// A closed list on purpose: a power search whose filters accept free text is
  /// a query language, and a query language needs a parser, a grammar and an
  /// error message this component cannot write for you.
  final List<String> values;

  /// A glyph on the menu row and the resulting chip.
  final AstryxIconName? icon;
}

/// What a power search currently is.
@immutable
class AstryxSearchQuery {
  /// Describes a search.
  const AstryxSearchQuery({this.text = '', this.filters = const <
      AstryxSearchFilter>[]});

  /// The free text.
  final String text;

  /// The structured filters.
  final List<AstryxSearchFilter> filters;

  /// Whether there is nothing to search for.
  bool get isEmpty => text.trim().isEmpty && filters.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is AstryxSearchQuery &&
      other.text == text &&
      _sameFilters(other.filters, filters);

  @override
  int get hashCode => Object.hash(text, Object.hashAll(filters));

  static bool _sameFilters(
    List<AstryxSearchFilter> a,
    List<AstryxSearchFilter> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Free text and structured filters in one control.
///
/// Upstream's `PowerSearch`. The filters are **chips beside the text**, not
/// syntax inside it: `status:failed` typed into a box is a thing a user has to
/// learn, get wrong, and be told off about, and the error message for a
/// mistyped query is a whole feature nobody budgets for.
///
/// {@tool snippet}
/// ```dart
/// AstryxPowerSearch(
///   query: _query,
///   options: <AstryxSearchFilterOption>[
///     AstryxSearchFilterOption(
///       field: 'status',
///       label: 'Status',
///       values: <String>['failed', 'running', 'succeeded'],
///     ),
///   ],
///   onChanged: (query) => setState(() => _query = query),
/// )
/// ```
/// {@end-tool}
class AstryxPowerSearch extends StatefulWidget {
  /// Creates a power search field.
  const AstryxPowerSearch({
    required this.query,
    required this.options,
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.enabled = true,
    this.labelHidden = true,
    this.width,
    this.focusNode,
    this.autofocus = false,
  });

  /// What is being searched for now.
  final AstryxSearchQuery query;

  /// The filters that can be added.
  final List<AstryxSearchFilterOption> options;

  /// Called whenever the text or the filters change.
  final ValueChanged<AstryxSearchQuery>? onChanged;

  /// Called when the search is submitted from the keyboard.
  final ValueChanged<AstryxSearchQuery>? onSubmitted;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown while the field is empty.
  final String? placeholder;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.labelHidden}
  ///
  /// Hidden by default: a search field beside a magnifier is the one case where
  /// a visible label is redundant to everybody who can see it.
  final bool labelHidden;

  /// {@macro AstryxField.width}
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  @override
  State<AstryxPowerSearch> createState() => _AstryxPowerSearchState();
}

class _AstryxPowerSearchState extends State<AstryxPowerSearch> {
  late final TextEditingController _text = TextEditingController(
    text: widget.query.text,
  );
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void didUpdateWidget(AstryxPowerSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A query replaced from outside — a saved search, a cleared filter bar — is
    // shown, unless the user is mid-edit in the field.
    if (widget.query.text != _text.text && !_focusNode.hasFocus) {
      _text.text = widget.query.text;
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    _text.dispose();
    super.dispose();
  }

  bool get _interactive => widget.enabled && widget.onChanged != null;

  void _emit({String? text, List<AstryxSearchFilter>? filters}) {
    widget.onChanged?.call(
      AstryxSearchQuery(
        text: text ?? _text.text,
        filters: filters ?? widget.query.filters,
      ),
    );
  }

  void _add(AstryxSearchFilterOption option, String value) {
    final filter = AstryxSearchFilter(
      field: option.field,
      value: value,
      icon: option.icon,
    );
    if (widget.query.filters.contains(filter)) return;
    _emit(filters: <AstryxSearchFilter>[...widget.query.filters, filter]);
  }

  void _remove(AstryxSearchFilter filter) => _emit(
    filters: <AstryxSearchFilter>[...widget.query.filters]..remove(filter),
  );

  void _clear() {
    _text.clear();
    _emit(text: '', filters: const <AstryxSearchFilter>[]);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Backspace on empty text takes the last filter back — the same bargain
    // `AstryxTokenizer` makes, and the only way to undo one from the keyboard.
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _text.text.isEmpty &&
        widget.query.filters.isNotEmpty &&
        _interactive) {
      _remove(widget.query.filters.last);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final label = widget.label ?? l10n.powerSearchLabel;

    final field = AstryxTextInput(
      label: label,
      labelHidden: true,
      controller: _text,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      placeholder: widget.placeholder ?? l10n.powerSearchPlaceholder,
      leading: const AstryxIcon(
        AstryxIconName.search,
        size: AstryxIconSize.sm,
        color: AstryxIconColor.secondary,
      ),
      trailing: widget.query.isEmpty && _text.text.isEmpty
          ? null
          : AstryxIconButton(
              icon: AstryxIconName.close,
              label: l10n.powerSearchClear,
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              enabled: _interactive,
              onPressed: _clear,
            ),
      onChanged: (text) => _emit(text: text),
      onSubmitted: (text) => widget.onSubmitted?.call(
        AstryxSearchQuery(text: text, filters: widget.query.filters),
      ),
    );

    final addFilter = AstryxDropdownMenu(
      label: l10n.powerSearchAddFilter,
      // A section per field rather than a submenu per field: the values are
      // what the user came for, and a flyout puts them behind a hover a touch
      // user cannot perform.
      entries: <AstryxMenuEntry>[
        for (final option in widget.options) ...<AstryxMenuEntry>[
          AstryxMenuSection(option.label),
          for (final value in option.values)
            AstryxMenuItem(
              label: value,
              icon: option.icon == null
                  ? null
                  : AstryxIcon(option.icon!, size: AstryxIconSize.sm),
              onSelected: _interactive ? () => _add(option, value) : null,
            ),
        ],
      ],
      triggerBuilder: (context, controller) => AstryxIconButton(
        icon: AstryxIconName.funnel,
        label: l10n.powerSearchAddFilter,
        tooltip: l10n.powerSearchAddFilter,
        variant: AstryxButtonVariant.ghost,
        enabled: _interactive && widget.options.isNotEmpty,
        onPressed: controller.toggle,
      ),
    );

    return AstryxField(
      label: label,
      description: widget.description,
      status: widget.status,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: Focus(
        onKeyEvent: _handleKey,
        canRequestFocus: false,
        skipTraversal: true,
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: label,
          value: widget.query.filters.isEmpty
              ? null
              // Announced as a count, so a reader knows the field is narrowed
              // before they wonder why their search found nothing.
              : l10n.powerSearchFilters(widget.query.filters.length),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: theme.spacing(AstryxSpacingToken.spacing2),
            children: <Widget>[
              Row(
                spacing: theme.spacing(AstryxSpacingToken.spacing2),
                children: <Widget>[Expanded(child: field), addFilter],
              ),
              if (widget.query.filters.isNotEmpty)
                Wrap(
                  spacing: theme.spacing(AstryxSpacingToken.spacing2),
                  runSpacing: theme.spacing(AstryxSpacingToken.spacing2),
                  children: <Widget>[
                    for (final filter in widget.query.filters)
                      AstryxTokenChip(
                        filter.text,
                        icon: filter.icon,
                        enabled: widget.enabled,
                        onRemove: _interactive
                            ? () => _remove(filter)
                            : null,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
