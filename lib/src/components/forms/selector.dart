/// A dropdown that picks one or several options from a list.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/forms/field.dart';
import 'package:astryx_ui/src/components/forms/field_status.dart';
import 'package:astryx_ui/src/components/forms/input_container.dart';
import 'package:astryx_ui/src/components/forms/text_input.dart';
import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One entry in a [AstryxSelector]'s list.
///
/// Sealed because the list is heterogeneous — options, dividers and section
/// headings — and every place that walks it has to handle all three. A sealed
/// hierarchy makes the compiler check that, which an enum tag on one class
/// would not.
sealed class AstryxSelectorEntry<T> {
  const AstryxSelectorEntry();
}

/// A selectable option.
class AstryxSelectorOption<T> extends AstryxSelectorEntry<T> {
  /// Creates an option.
  const AstryxSelectorOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.enabled = true,
  });

  /// What choosing this option produces.
  final T value;

  /// The visible text, and this option's accessible name.
  final String label;

  /// Secondary text below the label.
  final String? description;

  /// An icon before the label.
  ///
  /// Any widget. Pass `AstryxIcon(AstryxIconName.check)` for one of the
  /// registry's semantic names, or any other icon widget for something the
  /// registry has no name for — a consumer's menu will want "edit" and
  /// "delete", which are not in upstream's 28 (ADR-043).
  ///
  /// Size and colour come from the enclosing `IconTheme`, so an
  /// `AstryxIcon` with the default `AstryxIconColor.inherit` and a plain
  /// `Icon` both come out looking right.
  final Widget? icon;

  /// Whether the option can be chosen.
  final bool enabled;
}

/// A horizontal rule between groups of options.
class AstryxSelectorDivider<T> extends AstryxSelectorEntry<T> {
  /// Creates a divider.
  const AstryxSelectorDivider();
}

/// A heading above a group of options.
class AstryxSelectorSection<T> extends AstryxSelectorEntry<T> {
  /// Creates a section heading.
  const AstryxSelectorSection(this.label);

  /// The heading text.
  final String label;
}

/// A dropdown for choosing among a list of options.
///
/// **Not a Material `DropdownButton`.** The list is positioned by the Phase 9
/// overlay positioner, so it flips, shifts and shrinks against the real
/// viewport rather than being clipped or pushed off-screen — the behaviour CSS
/// anchor positioning gives upstream.
///
/// The keyboard follows the ARIA combobox pattern: arrows move a *highlight*
/// without committing, Enter commits, Escape closes and restores, Home and End
/// jump, and typing jumps to the first match. Nothing is selected merely by
/// being highlighted, which is what lets a keyboard user browse the list
/// without firing `onChanged` at every step.
///
/// {@tool snippet}
/// ```dart
/// AstryxSelector<String>(
///   label: 'Owner',
///   value: _owner,
///   onChanged: (value) => setState(() => _owner = value),
///   options: const <AstryxSelectorEntry<String>>[
///     AstryxSelectorOption(value: 'ada', label: 'Ada Lovelace'),
///     AstryxSelectorOption(value: 'alan', label: 'Alan Turing'),
///   ],
/// )
/// ```
/// {@end-tool}
class AstryxSelector<T> extends StatefulWidget {
  /// Creates a single-select dropdown.
  const AstryxSelector({
    required this.options,
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.description,
    this.placeholder,
    this.status,
    this.size,
    this.enabled = true,
    this.required = false,
    this.optional = false,
    this.labelHidden = false,
    this.showClear = false,
    this.showSearch = false,
    this.searchPlaceholder,
    this.emptyLabel,
    this.leading,
    this.maxListHeight = 320,
    this.width,
    this.focusNode,
    this.autofocus = false,
  });

  /// The entries to show, in order.
  final List<AstryxSelectorEntry<T>> options;

  /// The selected value, or null for none.
  final T? value;

  /// Called with the newly chosen value, or null when the value is cleared.
  final ValueChanged<T?>? onChanged;

  /// {@macro AstryxField.label}
  final String? label;

  /// {@macro AstryxField.description}
  final String? description;

  /// Text shown when nothing is selected.
  final String? placeholder;

  /// {@macro AstryxField.status}
  final AstryxFieldStatus? status;

  /// The trigger height.
  final AstryxInputSize? size;

  /// {@macro AstryxField.enabled}
  final bool enabled;

  /// {@macro AstryxField.required}
  final bool required;

  /// {@macro AstryxField.optional}
  final bool optional;

  /// {@macro AstryxField.labelHidden}
  final bool labelHidden;

  /// Whether to offer a button that clears the selection.
  final bool showClear;

  /// Whether the list has a search box at the top.
  ///
  /// Worth turning on past roughly a dozen options; below that it is a box to
  /// tab past for no gain.
  final bool showSearch;

  /// Placeholder for the search box.
  final String? searchPlaceholder;

  /// Text shown when the search matches nothing.
  final String? emptyLabel;

  /// Content before the value in the trigger.
  final Widget? leading;

  /// The tallest the list may be before it scrolls.
  ///
  /// The positioner may shrink it further to fit the viewport; this is a
  /// ceiling, not a promise.
  final double maxListHeight;

  /// {@macro AstryxField.width}
  final double? width;

  /// The focus node for the trigger, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxSelector<T>> createState() => _AstryxSelectorState<T>();
}

class _AstryxSelectorState<T> extends State<AstryxSelector<T>> {
  final OverlayPortalController _portal = OverlayPortalController();
  final GlobalKey _triggerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusScopeNode _listFocusScope = FocusScopeNode(
    debugLabel: 'AstryxSelector list',
  );

  FocusNode? _internalFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  TextEditingController? _searchController;

  bool _open = false;
  bool _focused = false;
  int _highlighted = -1;

  /// The last few characters typed, for jump-to-match.
  String _typeAhead = '';
  DateTime? _typeAheadAt;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AstryxSelector<T> oldWidget) {
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
    _searchController?.dispose();
    _scrollController.dispose();
    _listFocusScope.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  // ---------------------------------------------------------------------------
  // Option list
  // ---------------------------------------------------------------------------

  /// The options that survive the current search, in list order.
  List<AstryxSelectorEntry<T>> get _visibleEntries {
    final query = _searchController?.text.trim().toLowerCase() ?? '';
    if (query.isEmpty) return widget.options;

    final result = <AstryxSelectorEntry<T>>[];
    for (final entry in widget.options) {
      switch (entry) {
        case AstryxSelectorOption<T>():
          if (entry.label.toLowerCase().contains(query) ||
              (entry.description?.toLowerCase().contains(query) ?? false)) {
            result.add(entry);
          }
        // A divider or heading with nothing under it is noise, so structural
        // entries are dropped while filtering rather than left hanging.
        case AstryxSelectorDivider<T>():
        case AstryxSelectorSection<T>():
          break;
      }
    }
    return result;
  }

  List<AstryxSelectorOption<T>> get _selectableOptions =>
      <AstryxSelectorOption<T>>[
        for (final entry in _visibleEntries)
          if (entry is AstryxSelectorOption<T>) entry,
      ];

  AstryxSelectorOption<T>? get _selectedOption {
    for (final entry in widget.options) {
      if (entry is AstryxSelectorOption<T> && entry.value == widget.value) {
        return entry;
      }
    }
    return null;
  }

  bool get _interactive => widget.enabled && widget.onChanged != null;

  // ---------------------------------------------------------------------------
  // Open and close
  // ---------------------------------------------------------------------------

  void _openList() {
    if (!_interactive || _open) return;
    final options = _selectableOptions;
    final selectedIndex = options.indexWhere((o) => o.value == widget.value);
    setState(() {
      _open = true;
      // Opening lands the highlight on the current selection, so Enter is a
      // no-op rather than a surprise.
      _highlighted = selectedIndex >= 0
          ? selectedIndex
          : options.indexWhere((o) => o.enabled);
    });
    _portal.show();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlighted());
  }

  void _closeList({bool restoreFocus = true}) {
    if (!_open) return;
    setState(() {
      _open = false;
      _highlighted = -1;
      _typeAhead = '';
    });
    _searchController?.clear();
    _portal.hide();
    if (restoreFocus) _focusNode.requestFocus();
  }

  void _toggleList() => _open ? _closeList() : _openList();

  void _choose(AstryxSelectorOption<T> option) {
    if (!option.enabled) return;
    widget.onChanged?.call(option.value);
    _closeList();
  }

  void _clear() {
    widget.onChanged?.call(null);
  }

  // ---------------------------------------------------------------------------
  // Keyboard
  // ---------------------------------------------------------------------------

  void _moveHighlight(int delta) {
    final options = _selectableOptions;
    if (options.isEmpty) return;

    final start = _highlighted < 0 ? (delta > 0 ? -1 : 0) : _highlighted;
    for (var step = 1; step <= options.length; step++) {
      final raw = (start + delta * step) % options.length;
      final index = raw < 0 ? raw + options.length : raw;
      if (options[index].enabled) {
        setState(() => _highlighted = index);
        _scrollToHighlighted();
        return;
      }
    }
  }

  void _highlightEdge({required bool last}) {
    final options = _selectableOptions;
    final index = last
        ? options.lastIndexWhere((o) => o.enabled)
        : options.indexWhere((o) => o.enabled);
    if (index < 0) return;
    setState(() => _highlighted = index);
    _scrollToHighlighted();
  }

  /// Jumps to the first option starting with what was typed.
  ///
  /// The buffer resets after a second of silence, so "ba" finds "Banana" but a
  /// later "n" starts over rather than searching for "ban".
  void _handleTypeAhead(String character) {
    final now = DateTime.now();
    final expired =
        _typeAheadAt == null ||
        now.difference(_typeAheadAt!) > const Duration(seconds: 1);
    _typeAhead = (expired ? '' : _typeAhead) + character.toLowerCase();
    _typeAheadAt = now;

    final options = _selectableOptions;
    final index = options.indexWhere(
      (o) => o.enabled && o.label.toLowerCase().startsWith(_typeAhead),
    );
    if (index < 0) return;
    setState(() => _highlighted = index);
    _scrollToHighlighted();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (!_open) {
      if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.space) {
        _openList();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        _moveHighlight(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveHighlight(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.home:
        _highlightEdge(last: false);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.end:
        _highlightEdge(last: true);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        _closeList();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.tab:
        // Tab commits and moves on, as a native select does — it does not
        // leave an open list floating over the next field.
        _commitHighlighted();
        return KeyEventResult.ignored;
      case LogicalKeyboardKey.enter:
        _commitHighlighted();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.space:
        if (widget.showSearch) return KeyEventResult.ignored;
        _commitHighlighted();
        return KeyEventResult.handled;
    }

    // Type-ahead is off while the search box is open: the characters belong to
    // the search field, and doing both would fight over them.
    final character = event.character;
    if (!widget.showSearch &&
        character != null &&
        character.length == 1 &&
        character.trim().isNotEmpty) {
      _handleTypeAhead(character);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _commitHighlighted() {
    final options = _selectableOptions;
    if (_highlighted < 0 || _highlighted >= options.length) {
      _closeList();
      return;
    }
    _choose(options[_highlighted]);
  }

  void _scrollToHighlighted() {
    if (!_scrollController.hasClients || _highlighted < 0) return;
    // Rows are a uniform height, so the offset is arithmetic rather than a
    // render-object hunt — and the list may hold hundreds of rows.
    final rowHeight = _rowHeight;
    final target = _highlighted * rowHeight;
    final viewport = _scrollController.position.viewportDimension;
    final current = _scrollController.offset;

    final double? next;
    if (target < current) {
      next = target;
    } else if (target + rowHeight > current + viewport) {
      next = target + rowHeight - viewport;
    } else {
      next = null;
    }
    if (next == null) return;
    _scrollController.jumpTo(
      next.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  double get _rowHeight {
    final size = resolveAstryxInputSize(context, widget.size);
    return AstryxTheme.of(context).size(size.token);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final scope = AstryxFieldScope.maybeOf(context);
    final status = widget.status ?? scope?.status;
    final size = resolveAstryxInputSize(context, widget.size);
    final enabled = widget.enabled && (scope?.enabled ?? true);
    final selected = _selectedOption;

    final trigger = AstryxInputContainer(
      key: _triggerKey,
      focused: _focused || _open,
      size: size,
      status: status,
      enabled: enabled,
      onTap: _toggleList,
      leading: widget.leading,
      trailing: _buildTriggerTrailing(theme, status, enabled, l10n),
      child: Text(
        selected?.label ?? widget.placeholder ?? l10n.selectorPlaceholder,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme
            .textStyle(AstryxTypeRole.body)
            .copyWith(
              color: theme.color(
                !enabled
                    ? AstryxColorToken.textDisabled
                    : (selected == null
                          ? AstryxColorToken.textSecondary
                          : AstryxColorToken.textPrimary),
              ),
            ),
      ),
    );

    final control = OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: enabled,
        onKeyEvent: _handleKey,
        child: trigger,
      ),
    );

    final semantic = Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: widget.label ?? scope?.label,
      value: selected?.label,
      hint: _hint(scope, status),
      expanded: _open,
      onTap: _interactive ? _toggleList : null,
      child: ExcludeSemantics(child: control),
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

  String? _hint(AstryxFieldScope? scope, AstryxFieldStatus? status) {
    final parts = <String>[
      if (widget.description != null) widget.description!,
      if (status?.message != null) status!.message!,
    ];
    return parts.isEmpty ? scope?.semanticsHint : parts.join('. ');
  }

  Widget _buildTriggerTrailing(
    AstryxThemeData theme,
    AstryxFieldStatus? status,
    bool enabled,
    AstryxLocalizations l10n,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      if (widget.showClear && widget.value != null && enabled)
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
      // The chevron rotates rather than swapping glyphs, so the open state
      // reads as the same control in a different position.
      AnimatedRotation(
        turns: _open ? 0.5 : 0,
        duration: const Duration(milliseconds: 150),
        child: AstryxIcon(
          AstryxIconName.chevronDown,
          size: AstryxIconSize.sm,
          color: enabled ? AstryxIconColor.secondary : AstryxIconColor.disabled,
        ),
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Overlay
  // ---------------------------------------------------------------------------

  Widget _buildOverlay(BuildContext overlayContext) {
    final theme = AstryxTheme.of(context);
    final anchorBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) {
      return const SizedBox.shrink();
    }

    final anchorOffset = anchorBox.localToGlobal(Offset.zero);
    final anchor = anchorOffset & anchorBox.size;

    final media = MediaQuery.of(overlayContext);
    // The safe area, not the raw window: a list that flips "up" into the
    // status bar has not solved anything.
    final viewport = Rect.fromLTRB(
      media.padding.left,
      media.padding.top,
      media.size.width - media.padding.right,
      media.size.height - media.padding.bottom,
    );

    final entries = _visibleEntries;
    final rowHeight = _rowHeight;
    final searchHeight = widget.showSearch
        ? theme.size(AstryxSizeToken.elementMd) +
              theme.spacing(AstryxSpacingToken.spacing2) * 2
        : 0.0;
    final contentHeight = entries.isEmpty
        ? rowHeight
        : entries.fold<double>(
            0,
            (sum, e) => sum + (e is AstryxSelectorOption<T> ? rowHeight : 12),
          );

    final desired = Size(
      // The list is at least as wide as the trigger, which is what makes it
      // read as belonging to it rather than floating beside it.
      anchor.width,
      (contentHeight +
              searchHeight +
              theme.spacing(AstryxSpacingToken.spacing1) * 2)
          .clamp(0.0, widget.maxListHeight),
    );

    final position = resolveAstryxOverlayPosition(
      anchor: anchor,
      overlaySize: desired,
      viewport: viewport,
      align: AstryxOverlayAlign.start,
      gap: theme.spacing(AstryxSpacingToken.spacing1),
      padding: theme.spacing(AstryxSpacingToken.spacing2),
    );

    return Stack(
      children: <Widget>[
        // A full-screen dismiss layer, below the list. Without it a press
        // outside the dropdown does nothing and the list has to be dismissed
        // with Escape — which is how dropdowns get called broken.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeList,
          ),
        ),
        Positioned(
          left: position.offset.dx,
          top: position.offset.dy,
          width: position.size.width,
          height: position.size.height,
          child: FocusScope(
            node: _listFocusScope,
            child: _SelectorList<T>(
              entries: entries,
              selected: widget.value,
              highlighted: _highlighted,
              rowHeight: rowHeight,
              scrollController: _scrollController,
              searchController: widget.showSearch ? _searchOrCreate() : null,
              searchPlaceholder: widget.searchPlaceholder,
              emptyLabel: widget.emptyLabel,
              onSearchChanged: (_) => setState(() => _highlighted = 0),
              onSelect: _choose,
              onHighlight: (index) => setState(() => _highlighted = index),
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController _searchOrCreate() =>
      _searchController ??= TextEditingController();
}

/// The floating list itself.
class _SelectorList<T> extends StatelessWidget {
  const _SelectorList({
    required this.entries,
    required this.selected,
    required this.highlighted,
    required this.rowHeight,
    required this.scrollController,
    required this.onSelect,
    required this.onHighlight,
    required this.onSearchChanged,
    this.searchController,
    this.searchPlaceholder,
    this.emptyLabel,
  });

  final List<AstryxSelectorEntry<T>> entries;
  final T? selected;
  final int highlighted;
  final double rowHeight;
  final ScrollController scrollController;
  final TextEditingController? searchController;
  final String? searchPlaceholder;
  final String? emptyLabel;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AstryxSelectorOption<T>> onSelect;
  final ValueChanged<int> onHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    var optionIndex = -1;
    final rows = <Widget>[];
    for (final entry in entries) {
      switch (entry) {
        case AstryxSelectorOption<T>():
          optionIndex++;
          final index = optionIndex;
          rows.add(
            _SelectorRow<T>(
              option: entry,
              height: rowHeight,
              selected: entry.value == selected,
              highlighted: index == highlighted,
              onTap: () => onSelect(entry),
              onHover: () => onHighlight(index),
            ),
          );
        case AstryxSelectorDivider<T>():
          rows.add(const AstryxDivider());
        case AstryxSelectorSection<T>():
          rows.add(
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(AstryxSpacingToken.spacing2),
                vertical: theme.spacing(AstryxSpacingToken.spacing1),
              ),
              child: AstryxText(
                entry.label,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
          );
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundPopover),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
        boxShadow: theme.boxShadows(AstryxShadowToken.med),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (searchController != null)
              Padding(
                padding: EdgeInsets.all(
                  theme.spacing(AstryxSpacingToken.spacing2),
                ),
                child: AstryxTextInput(
                  controller: searchController,
                  autofocus: true,
                  size: AstryxInputSize.sm,
                  placeholder:
                      searchPlaceholder ?? l10n.selectorSearchPlaceholder,
                  onChanged: onSearchChanged,
                  leading: const AstryxIcon(
                    AstryxIconName.search,
                    size: AstryxIconSize.sm,
                    color: AstryxIconColor.secondary,
                  ),
                ),
              ),
            Flexible(
              child: rows.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(
                        theme.spacing(AstryxSpacingToken.spacing3),
                      ),
                      child: AstryxText(
                        emptyLabel ?? l10n.tableNoData,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                    )
                  : ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        vertical: theme.spacing(AstryxSpacingToken.spacing1),
                      ),
                      children: rows,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One selectable row.
class _SelectorRow<T> extends StatelessWidget {
  const _SelectorRow({
    required this.option,
    required this.height,
    required this.selected,
    required this.highlighted,
    required this.onTap,
    required this.onHover,
  });

  final AstryxSelectorOption<T> option;
  final double height;
  final bool selected;
  final bool highlighted;
  final VoidCallback onTap;
  final VoidCallback onHover;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final content = Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      color: highlighted
          ? theme.color(AstryxColorToken.overlayHover)
          : const Color(0x00000000),
      child: Row(
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          if (option.icon != null)
            IconTheme.merge(
              data: IconThemeData(
                size: AstryxIconSize.sm.pixels,
                color: theme.color(
                  option.enabled
                      ? AstryxColorToken.iconSecondary
                      : AstryxColorToken.iconDisabled,
                ),
              ),
              child: option.icon!,
            ),
          Expanded(
            child: AstryxText(
              option.label,
              color: option.enabled
                  ? AstryxTextColor.primary
                  : AstryxTextColor.disabled,
              maxLines: 1,
            ),
          ),
          // The tick marks the selection; the highlight marks where the
          // keyboard is. Two different things, so two different signals.
          if (selected)
            const AstryxIcon(
              AstryxIconName.check,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.accent,
            ),
        ],
      ),
    );

    return Semantics(
      selected: selected,
      enabled: option.enabled,
      button: true,
      label: option.label,
      hint: option.description,
      onTap: option.enabled ? onTap : null,
      child: ExcludeSemantics(
        child: MouseRegion(
          cursor: option.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) {
            if (option.enabled) onHover();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: option.enabled ? onTap : null,
            child: content,
          ),
        ),
      ),
    );
  }
}
