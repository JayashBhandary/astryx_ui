/// A selector that keeps several choices, shown as tokens.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/feedback/spinner.dart';
import 'package:astryx_ui/src/components/forms/checkbox.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/selector.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/popover.dart';
import 'package:astryx_ui/src/components/surface/badge.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// What a [AstryxMultiSelector]'s trigger shows.
enum AstryxMultiSelectorTriggerDisplay {
  /// A badge per choice, up to `maxBadges`, then "+n more". The default.
  badges,

  /// A count — "3 selected". For a field that is often full.
  count,
}

/// A dropdown that keeps several choices at once.
///
/// The same option list as [AstryxSelector] — [AstryxSelectorOption],
/// [AstryxSelectorSection] and [AstryxSelectorDivider] all work here, because
/// upstream shares those types between the two components too. What differs is
/// the value (a set), the rows (checkboxes, and the list stays open as they are
/// ticked), and the trigger (tokens rather than one label).
///
/// {@tool snippet}
/// ```dart
/// AstryxMultiSelector<String>(
///   label: 'Reviewers',
///   values: _reviewers,
///   onChanged: (values) => setState(() => _reviewers = values),
///   options: const <AstryxSelectorEntry<String>>[
///     AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
///     AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// For one choice out of many, [AstryxSelector]. For a handful always worth
/// showing, `AstryxCheckboxList` — a dropdown that hides three checkboxes
/// costs a click and saves nothing.
class AstryxMultiSelector<T> extends StatefulWidget {
  /// Creates a multiple-choice selector.
  const AstryxMultiSelector({
    required this.label,
    required this.options,
    required this.values,
    super.key,
    this.onChanged,
    this.description,
    this.status,
    this.placeholder,
    this.size,
    this.triggerDisplay = AstryxMultiSelectorTriggerDisplay.badges,
    this.maxBadges = 3,
    this.showSelectAll = false,
    this.selectAllLabel,
    this.showSearch = false,
    this.searchPlaceholder,
    this.emptyLabel,
    this.enabled = true,
    this.loading = false,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.maxListHeight = 320,
    this.width,
    this.focusNode,
    this.autofocus = false,
  }) : assert(maxBadges > 0, 'maxBadges must be positive');

  /// {@macro AstryxField.label}
  final String label;

  /// The options, sections and dividers, in order.
  final List<AstryxSelectorEntry<T>> options;

  /// The values currently chosen.
  final Set<T> values;

  /// Called with a new set. Null makes the selector inert.
  final ValueChanged<Set<T>>? onChanged;

  /// {@macro AstryxField.description}
  final String? description;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The trigger text when nothing is chosen. Defaults to "Select…".
  final String? placeholder;

  /// The trigger height.
  final AstryxInputSize? size;

  /// Whether the trigger shows tokens or a count.
  final AstryxMultiSelectorTriggerDisplay triggerDisplay;

  /// How many badges the trigger shows before collapsing the rest into "+n".
  final int maxBadges;

  /// Whether to offer a row that ticks and unticks everything.
  final bool showSelectAll;

  /// The label on that row. Defaults to "Select all".
  final String? selectAllLabel;

  /// Whether to offer a search field above the list.
  final bool showSearch;

  /// The search field's placeholder.
  final String? searchPlaceholder;

  /// What to show when a search matches nothing.
  final String? emptyLabel;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// Whether the options are being fetched. Shows a spinner in the trigger.
  final bool loading;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// The tallest the list may be before it scrolls.
  final double maxListHeight;

  /// A fixed width for the whole field.
  final double? width;

  /// {@macro AstryxButton.focusNode}
  final FocusNode? focusNode;

  /// {@macro AstryxButton.autofocus}
  final bool autofocus;

  @override
  State<AstryxMultiSelector<T>> createState() => _AstryxMultiSelectorState<T>();
}

class _AstryxMultiSelectorState<T> extends State<AstryxMultiSelector<T>> {
  final AstryxOverlayController _overlay = AstryxOverlayController();
  final TextEditingController _search = TextEditingController();

  bool _open = false;

  @override
  void dispose() {
    _overlay.dispose();
    _search.dispose();
    super.dispose();
  }

  bool get _interactive =>
      widget.enabled && !widget.loading && widget.onChanged != null;

  /// Every option, ignoring the sections and dividers between them.
  Iterable<AstryxSelectorOption<T>> get _allOptions =>
      widget.options.whereType<AstryxSelectorOption<T>>();

  /// The options a search leaves visible, and the headings that still have one.
  List<AstryxSelectorEntry<T>> get _visible {
    final query = _search.text.trim().toLowerCase();
    if (!widget.showSearch || query.isEmpty) return widget.options;

    final kept = <AstryxSelectorEntry<T>>[];
    for (final entry in widget.options) {
      if (entry is AstryxSelectorOption<T>) {
        if (entry.label.toLowerCase().contains(query)) kept.add(entry);
      } else if (entry is AstryxSelectorSection<T>) {
        // A heading survives only if something under it did; a filtered list of
        // five headings and no options is worse than an empty one.
        kept.add(entry);
      }
    }

    return <AstryxSelectorEntry<T>>[
      for (var i = 0; i < kept.length; i++)
        if (kept[i] is! AstryxSelectorSection<T> ||
            (i + 1 < kept.length && kept[i + 1] is AstryxSelectorOption<T>))
          kept[i],
    ];
  }

  /// Rebuilds the list as the query changes.
  void _onSearchChanged(String _) {
    if (mounted) setState(() {});
  }

  void _toggle(T value) {
    if (!_interactive) return;
    widget.onChanged!(
      widget.values.contains(value)
          ? (<T>{...widget.values}..remove(value))
          : <T>{...widget.values, value},
    );
  }

  void _toggleAll() {
    if (!_interactive) return;
    final selectable = _allOptions
        .where((option) => option.enabled)
        .map((option) => option.value)
        .toSet();
    // Anything short of all of them means "select all"; only a full set clears.
    widget.onChanged!(
      widget.values.containsAll(selectable) ? <T>{} : selectable,
    );
  }

  void _clear() {
    if (!_interactive) return;
    widget.onChanged!(<T>{});
  }

  /// The label of every chosen value, in the order the options are declared.
  List<String> get _chosenLabels => <String>[
    for (final option in _allOptions)
      if (widget.values.contains(option.value)) option.label,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final status = widget.status ?? scope?.status;
    final size = resolveAstryxInputSize(context, widget.size);
    final enabled = widget.enabled && (scope?.enabled ?? true);
    final chosen = _chosenLabels;

    final selector = AstryxPopover(
      controller: _overlay,
      label: widget.label,
      matchTriggerWidth: true,
      // The list must not close as options are ticked — that is the whole
      // difference from a single selector — so focus stays trapped and the
      // barrier only dismisses on a press outside.
      onOpenChange: (open) {
        if (!mounted) return;
        setState(() => _open = open);
        if (!open) _search.clear();
      },
      content: _MultiSelectorList<T>(state: this),
      triggerBuilder: (context, controller) => AstryxInputContainer(
        focused: _open,
        size: size,
        status: status,
        enabled: enabled && !widget.loading,
        onTap: _interactive ? controller.toggle : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.loading)
              AstryxSpinner(
                size: AstryxSpinnerSize.sm,
                label: l10n.buttonLoading,
              )
            else if (chosen.isNotEmpty && _interactive)
              AstryxIconButton(
                icon: AstryxIconName.close,
                label: l10n.clearField(widget.label),
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: _clear,
              ),
            const AstryxIcon(
              AstryxIconName.chevronDown,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            ),
          ],
        ),
        child: _Trigger<T>(state: this, chosen: chosen),
      ),
    );

    return AstryxField(
      label: widget.label,
      description: widget.description,
      status: widget.status,
      required: widget.required,
      optional: widget.optional,
      enabled: widget.enabled,
      labelHidden: widget.labelHidden,
      width: widget.width,
      child: Semantics(
        container: true,
        button: true,
        label: widget.label,
        // The chosen labels are the field's value; a count alone would leave a
        // reader knowing how many without knowing which.
        value: chosen.isEmpty
            ? (widget.placeholder ?? l10n.selectorPlaceholder)
            : chosen.join(', '),
        enabled: _interactive,
        expanded: _open,
        onTap: _interactive ? _overlay.toggle : null,
        // Not excluded: the clear button inside keeps its own name, which is
        // the only way a reader can reach it.
        child: selector,
      ),
    );
  }
}

/// What the trigger paints: tokens, a count, or the placeholder.
class _Trigger<T> extends StatelessWidget {
  const _Trigger({required this.state, required this.chosen});

  final _AstryxMultiSelectorState<T> state;
  final List<String> chosen;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final theme = AstryxTheme.of(context);
    final widget = state.widget;

    if (chosen.isEmpty) {
      return AstryxText(
        widget.placeholder ?? l10n.selectorPlaceholder,
        color: AstryxTextColor.secondary,
        maxLines: 1,
      );
    }

    if (widget.triggerDisplay == AstryxMultiSelectorTriggerDisplay.count) {
      return AstryxText(
        l10n.multiSelectorSelected(chosen.length),
        maxLines: 1,
      );
    }

    final shown = chosen.take(widget.maxBadges).toList();
    final extra = chosen.length - shown.length;

    // One line of badges, clipped rather than wrapped: the trigger is a control
    // of fixed height, and one that grew would move every field below it.
    //
    // A viewport rather than a `ClipRect`: clipping hides the overflow but the
    // row still reports it, which is a debug assertion every time a long
    // selection is shown. Scrolling is disabled — this is a trigger, not a
    // list — so the viewport is only here to let the row exceed it in peace.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing(AstryxSpacingToken.spacing1),
        children: <Widget>[
          for (final label in shown) AstryxBadge(label),
          if (extra > 0) AstryxText(l10n.multiSelectorMore(extra)),
        ],
      ),
    );
  }
}

/// The overlay: the search field, the select-all row, and the options.
class _MultiSelectorList<T> extends StatelessWidget {
  const _MultiSelectorList({required this.state});

  final _AstryxMultiSelectorState<T> state;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final theme = AstryxTheme.of(context);
    final widget = state.widget;
    final entries = state._visible;

    final selectable = state._allOptions
        .where((option) => option.enabled)
        .map((option) => option.value)
        .toSet();
    final all = selectable.isNotEmpty && widget.values.containsAll(selectable);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.showSearch)
          Padding(
            padding: EdgeInsets.all(
              theme.spacing(AstryxSpacingToken.spacing2),
            ),
            child: AstryxTextInput(
              label: l10n.selectorSearchOptions,
              labelHidden: true,
              controller: state._search,
              placeholder:
                  widget.searchPlaceholder ?? l10n.selectorSearchPlaceholder,
              size: AstryxInputSize.sm,
              leading: const AstryxIcon(
                AstryxIconName.search,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
              autofocus: true,
              onChanged: state._onSearchChanged,
            ),
          ),
        if (widget.showSelectAll) ...<Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing(AstryxSpacingToken.spacing2),
              vertical: theme.spacing(AstryxSpacingToken.spacing1),
            ),
            child: AstryxCheckbox(
              label: widget.selectAllLabel ?? l10n.multiSelectorSelectAll,
              value: all,
              size: AstryxToggleSize.sm,
              enabled: state._interactive && selectable.isNotEmpty,
              onChanged: (_) => state._toggleAll(),
            ),
          ),
          const AstryxDivider(),
        ],
        if (entries.isEmpty)
          Padding(
            padding: EdgeInsets.all(
              theme.spacing(AstryxSpacingToken.spacing3),
            ),
            child: AstryxText(
              widget.emptyLabel ?? l10n.selectorNoResults,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxListHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final entry in entries)
                    switch (entry) {
                      final AstryxSelectorSection<T> section => Padding(
                        padding: EdgeInsets.fromLTRB(
                          theme.spacing(AstryxSpacingToken.spacing2),
                          theme.spacing(AstryxSpacingToken.spacing2),
                          theme.spacing(AstryxSpacingToken.spacing2),
                          theme.spacing(AstryxSpacingToken.spacing1),
                        ),
                        child: AstryxText(
                          section.label,
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                        ),
                      ),
                      AstryxSelectorDivider<T>() => const AstryxDivider(),
                      final AstryxSelectorOption<T> option => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacing(
                            AstryxSpacingToken.spacing2,
                          ),
                          vertical: theme.spacing(AstryxSpacingToken.spacing1),
                        ),
                        child: AstryxCheckbox(
                          label: option.label,
                          description: option.description,
                          value: widget.values.contains(option.value),
                          size: AstryxToggleSize.sm,
                          enabled: state._interactive && option.enabled,
                          onChanged: (_) => state._toggle(option.value),
                        ),
                      ),
                    },
                ],
              ),
            ),
          ),
      ],
    );
  }
}
