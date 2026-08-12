/// A text field that suggests completions as you type.
library;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/search/base_typeahead.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// One suggestion in an [AstryxTypeahead].
@immutable
class AstryxTypeaheadItem<T> {
  /// Describes a suggestion.
  const AstryxTypeaheadItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.trailing,
  });

  /// What choosing this produces.
  final T value;

  /// The visible text, and this row's accessible name.
  final String label;

  /// A second line — the thing that tells two similar labels apart.
  final String? description;

  /// A glyph before the label.
  final AstryxIconName? icon;

  /// Content at the end of the row — a kind, a count, a shortcut.
  final Widget? trailing;
}

/// A field that suggests completions as you type.
///
/// Upstream's `Typeahead` and `TypeaheadItem`: [AstryxBaseTypeahead] with this
/// package's own field and rows on it. Reach for the base one only when the
/// field or the rows have to look like something this cannot draw.
///
/// {@tool snippet}
/// ```dart
/// AstryxTypeahead<Project>(
///   label: 'Project',
///   controller: _query,
///   source: (query) async => <AstryxTypeaheadItem<Project>>[
///     for (final project in await api.search(query))
///       AstryxTypeaheadItem(value: project, label: project.name),
///   ],
///   onSelected: _open,
/// )
/// ```
/// {@end-tool}
///
/// **It is not an `AstryxSelector`.** A selector picks from a set it can show
/// you; a typeahead searches a set it cannot — a thousand projects, every user,
/// the whole log. If the options fit in a list, use the selector: it can be
/// browsed, and this can only be queried.
class AstryxTypeahead<T> extends StatefulWidget {
  /// Creates a typeahead field.
  const AstryxTypeahead({
    required this.controller,
    required this.source,
    super.key,
    this.onSelected,
    this.label,
    this.description,
    this.status,
    this.placeholder,
    this.emptyBuilder,
    this.footerBuilder,
    this.minQueryLength = 1,
    this.debounce = const Duration(milliseconds: 200),
    this.maxHeight = 320,
    this.size,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.openOnFocus = false,
    this.clearOnSelect = false,
  });

  /// The query being typed.
  final TextEditingController controller;

  /// Where suggestions come from.
  final AstryxTypeaheadSource<AstryxTypeaheadItem<T>> source;

  /// Called with the value of the suggestion that was chosen.
  final ValueChanged<T>? onSelected;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// Text shown while the field is empty.
  final String? placeholder;

  /// What the surface shows when a search returned nothing.
  final Widget Function(BuildContext context, String query)? emptyBuilder;

  /// Content below the suggestions — a "see all results" row, a hint.
  final Widget Function(BuildContext context, int count)? footerBuilder;

  /// How many characters before the source is called.
  final int minQueryLength;

  /// How long to wait after a keystroke before calling it.
  final Duration debounce;

  /// The tallest the suggestion surface grows.
  final double maxHeight;

  /// {@macro AstryxButton.size}
  final AstryxInputSize? size;

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

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  /// Whether to search as soon as the field takes focus.
  final bool openOnFocus;

  /// Whether choosing a suggestion empties the field.
  ///
  /// False leaves the query — right for a field that *is* the value. True is
  /// for a search box that dispatches somewhere and comes back ready for the
  /// next query.
  final bool clearOnSelect;

  @override
  State<AstryxTypeahead<T>> createState() => _AstryxTypeaheadState<T>();
}

class _AstryxTypeaheadState<T> extends State<AstryxTypeahead<T>> {
  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    return AstryxBaseTypeahead<AstryxTypeaheadItem<T>>(
      controller: widget.controller,
      source: widget.source,
      focusNode: widget.focusNode,
      minQueryLength: widget.minQueryLength,
      debounce: widget.debounce,
      maxHeight: widget.maxHeight,
      openOnFocus: widget.openOnFocus,
      label: widget.label ?? l10n.typeaheadLabel,
      emptyBuilder: widget.emptyBuilder,
      footerBuilder: widget.footerBuilder == null
          ? null
          : (context, state) =>
                widget.footerBuilder!(context, state.suggestions.length),
      onSelected: (item) {
        if (widget.clearOnSelect) {
          widget.controller.clear();
        } else {
          // The chosen label, not the fragment that found it: a field left
          // holding "atl" after picking "Atlas" reads as a failed search.
          widget.controller.value = TextEditingValue(
            text: item.label,
            selection: TextSelection.collapsed(offset: item.label.length),
          );
        }
        widget.onSelected?.call(item.value);
      },
      fieldBuilder: (context, state) => AstryxTextInput(
        label: widget.label,
        description: widget.description,
        status: widget.status,
        controller: state.controller,
        focusNode: state.focusNode,
        placeholder: widget.placeholder ?? l10n.typeaheadPlaceholder,
        size: widget.size,
        enabled: widget.enabled,
        required: widget.required,
        optional: widget.optional,
        labelHidden: widget.labelHidden,
        width: widget.width,
        autofocus: widget.autofocus,
        showClear: true,
        leading: const AstryxIcon(
          AstryxIconName.search,
          size: AstryxIconSize.sm,
          color: AstryxIconColor.secondary,
        ),
        trailing: state.loading
            ? AstryxSpinner(
                size: AstryxSpinnerSize.sm,
                label: l10n.typeaheadSearching,
              )
            : null,
      ),
      itemBuilder: (context, item, state) {
        final index = state.suggestions.indexOf(item);

        return AstryxItem(
          label: item.label,
          description: item.description,
          leading: item.icon == null
              ? null
              : AstryxIcon(item.icon!, size: AstryxIconSize.sm),
          trailing: item.trailing,
          // The row the arrows are on is drawn selected, so the keyboard and
          // the
          // pointer agree about where you are.
          selected: state.isActive(index),
          onPressed: () => state.select(item),
        );
      },
    );
  }
}
