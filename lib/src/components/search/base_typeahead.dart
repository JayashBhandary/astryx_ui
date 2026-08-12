/// The suggestion engine every search input here is built from.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/foundation/semantics.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Everything a typeahead's builders are told, and everything they can do.
@immutable
class AstryxTypeaheadState<T> {
  /// Creates the builder's argument.
  const AstryxTypeaheadState({
    required this.query,
    required this.suggestions,
    required this.loading,
    required this.activeIndex,
    required this.isOpen,
    required this.controller,
    required this.focusNode,
    required this.select,
    required this.open,
    required this.close,
  });

  /// What has been typed.
  final String query;

  /// What the source last returned.
  final List<T> suggestions;

  /// Whether a source call is in flight.
  final bool loading;

  /// Which suggestion the keyboard is on, or -1 for none.
  ///
  /// **Not a selection.** The field keeps focus the whole time — this is the
  /// row the arrows have walked to, which `Enter` would take.
  final int activeIndex;

  /// Whether the suggestion surface is showing.
  final bool isOpen;

  /// The text being edited.
  final TextEditingController controller;

  /// The field's focus node.
  final FocusNode focusNode;

  /// Chooses a suggestion, as pressing it would.
  final ValueChanged<T> select;

  /// Shows the surface, if there is anything to show.
  final VoidCallback open;

  /// Hides the surface.
  final VoidCallback close;

  /// Whether the suggestion at [index] is the one the arrows are on.
  bool isActive(int index) => index == activeIndex;
}

/// Where suggestions come from.
///
/// Async so the common case — a request — needs no wrapper; a synchronous list
/// is `Future.value(…)`, which the analyser will tell you about once and then
/// never again.
typedef AstryxTypeaheadSource<T> =
    Future<List<T>> Function(String query);

/// The unstyled typeahead the other search inputs are built from.
///
/// Upstream's `BaseTypeahead`. It owns the parts that are the same whatever the
/// thing looks like — the query, the debounce, the in-flight request, the
/// keyboard, the overlay and the announcements — and leaves the field and the
/// rows entirely to [fieldBuilder] and [itemBuilder].
///
/// {@tool snippet}
/// ```dart
/// AstryxBaseTypeahead<City>(
///   controller: _query,
///   source: (query) => api.searchCities(query),
///   onSelected: _pick,
///   fieldBuilder: (context, state) => AstryxTextInput(
///     label: 'City',
///     controller: state.controller,
///     focusNode: state.focusNode,
///   ),
///   itemBuilder: (context, city, state) => MyRow(city, state: state),
/// )
/// ```
/// {@end-tool}
///
/// **The field never loses focus.** Arrow keys move an *active index* inside
/// the surface while the caret stays where it is, which is the ARIA combobox
/// pattern and the only arrangement in which typing, correcting and choosing
/// are one gesture. A suggestion list that steals focus makes the user tab back
/// to keep typing.
class AstryxBaseTypeahead<T> extends StatefulWidget {
  /// Creates a typeahead engine.
  const AstryxBaseTypeahead({
    required this.controller,
    required this.source,
    required this.fieldBuilder,
    required this.itemBuilder,
    super.key,
    this.onSelected,
    this.onQueryChanged,
    this.emptyBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.minQueryLength = 1,
    this.debounce = const Duration(milliseconds: 200),
    this.maxHeight = 320,
    this.matchFieldWidth = true,
    this.surfaceWidth,
    this.focusNode,
    this.label,
    this.openOnFocus = false,
  });

  /// The text being edited.
  final TextEditingController controller;

  /// Where suggestions come from.
  final AstryxTypeaheadSource<T> source;

  /// Builds the field. Wire it to `state.controller` and `state.focusNode`.
  final Widget Function(BuildContext context, AstryxTypeaheadState<T> state)
  fieldBuilder;

  /// Builds one suggestion row.
  final Widget Function(
    BuildContext context,
    T suggestion,
    AstryxTypeaheadState<T> state,
  )
  itemBuilder;

  /// Called with the suggestion that was chosen.
  final ValueChanged<T>? onSelected;

  /// Called whenever the query changes, after the debounce.
  final ValueChanged<String>? onQueryChanged;

  /// What the surface shows when a search returned nothing.
  ///
  /// Null shows a line of text. Worth supplying: "No projects match *atlas*" is
  /// a better answer than "No matches", and only the caller knows the noun.
  final Widget Function(BuildContext context, String query)? emptyBuilder;

  /// Content above the suggestions — a count, a hint.
  final Widget Function(BuildContext context, AstryxTypeaheadState<T> state)?
  headerBuilder;

  /// Content below them — a shortcut legend, a "see all" row.
  final Widget Function(BuildContext context, AstryxTypeaheadState<T> state)?
  footerBuilder;

  /// How many characters before the source is called at all.
  ///
  /// One by default. Zero calls it on focus, which is right for a list of
  /// recents and wrong for anything that costs a request.
  final int minQueryLength;

  /// How long to wait after a keystroke before calling the source.
  ///
  /// A request per keystroke is a request per keystroke: the debounce is what
  /// makes a typeahead over a network affordable.
  final Duration debounce;

  /// The tallest the surface grows before it scrolls.
  final double maxHeight;

  /// Whether the surface takes the field's width.
  final bool matchFieldWidth;

  /// A fixed width for the surface. Ignored when [matchFieldWidth].
  final double? surfaceWidth;

  /// The field's focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// An accessible name for the suggestion surface.
  final String? label;

  /// Whether to search as soon as the field takes focus.
  final bool openOnFocus;

  @override
  State<AstryxBaseTypeahead<T>> createState() => _AstryxBaseTypeaheadState<T>();
}

class _AstryxBaseTypeaheadState<T> extends State<AstryxBaseTypeahead<T>> {
  final AstryxOverlayController _overlay = AstryxOverlayController();
  final ScrollController _scroll = ScrollController();

  FocusNode? _internalFocusNode;
  Timer? _debounce;

  /// Which source call is the current one.
  ///
  /// A slow request that resolves after a faster later one must not overwrite
  /// it — the "stale results" bug every search box ships once.
  int _generation = 0;

  List<T> _suggestions = <T>[];
  bool _loading = false;
  int _activeIndex = -1;
  String _query = '';

  /// The last announcement, for the live region.
  String? _announcement;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _query = widget.controller.text;
    widget.controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AstryxBaseTypeahead<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_handleTextChange);
    widget.focusNode?.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _overlay.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      // Closed on blur, but not cleared: a user who clicked away and came back
      // has not changed their mind about what they typed.
      _close();
      return;
    }
    if (widget.openOnFocus) _search(widget.controller.text);
  }

  void _handleTextChange() {
    final text = widget.controller.text;
    if (text == _query) return;
    _query = text;
    _activeIndex = -1;

    _debounce?.cancel();
    if (text.length < widget.minQueryLength) {
      setState(() {
        _suggestions = <T>[];
        _loading = false;
      });
      _close();
      return;
    }

    setState(() => _loading = true);
    _debounce = Timer(widget.debounce, () => _search(text));
  }

  Future<void> _search(String query) async {
    if (query.length < widget.minQueryLength) return;

    final generation = ++_generation;
    widget.onQueryChanged?.call(query);
    if (mounted) setState(() => _loading = true);

    List<T> results;
    try {
      results = await widget.source(query);
    } on Object {
      // A failed source is not a crash in the field: it is an empty result and
      // a caller's problem to report. Rethrowing here would take the screen
      // down over a dropped request.
      results = <T>[];
    }

    // Stale: something newer is already in flight or landed.
    if (!mounted || generation != _generation) return;

    setState(() {
      _suggestions = results;
      _loading = false;
      _activeIndex = -1;
    });
    _announce(results.length);
    if (_focusNode.hasFocus) _overlay.show();
  }

  void _announce(int count) {
    final l10n = AstryxLocalizations.of(context);
    final message = count == 0
        ? l10n.selectorNoResults
        : l10n.typeaheadResults(count);
    if (_announcement == message) return;
    // A dropdown appearing is silent to a screen reader, so the count is
    // announced instead — otherwise there is no way to know a search answered.
    setState(() => _announcement = message);
  }

  void _select(T suggestion) {
    _close();
    widget.onSelected?.call(suggestion);
  }

  void _close() {
    if (!_overlay.isOpen) return;
    _overlay.hide();
    if (mounted) setState(() => _activeIndex = -1);
  }

  void _move(int delta) {
    if (_suggestions.isEmpty) return;
    if (!_overlay.isOpen) _overlay.show();

    final count = _suggestions.length;
    // From nowhere, down goes to the first and up to the last — the behaviour a
    // user expects from a closed-then-opened list.
    final next = _activeIndex < 0
        ? (delta > 0 ? 0 : count - 1)
        : (_activeIndex + delta).clamp(0, count - 1);

    setState(() => _activeIndex = next);
    _reveal(next);
  }

  /// Scrolls the active row into view, so arrowing past the fold works.
  void _reveal(int index) {
    if (!_scroll.hasClients) return;
    const rowHeight = 40.0;
    final target = index * rowHeight;
    final position = _scroll.position;

    if (target < position.pixels) {
      _scroll.jumpTo(target);
    } else if (target + rowHeight >
        position.pixels + position.viewportDimension) {
      _scroll.jumpTo(target + rowHeight - position.viewportDimension);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        // Enter with nothing highlighted belongs to the form, not to us: a
        // typeahead must not swallow the key that submits the search.
        if (_activeIndex < 0 || _activeIndex >= _suggestions.length) {
          return KeyEventResult.ignored;
        }
        _select(_suggestions[_activeIndex]);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        if (!_overlay.isOpen) return KeyEventResult.ignored;
        _close();
        // Handled, so Escape closes the list rather than the dialog behind it.
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  AstryxTypeaheadState<T> get _state => AstryxTypeaheadState<T>(
    query: _query,
    suggestions: _suggestions,
    loading: _loading,
    activeIndex: _activeIndex,
    isOpen: _overlay.isOpen,
    controller: widget.controller,
    focusNode: _focusNode,
    select: _select,
    open: () => _search(widget.controller.text),
    close: _close,
  );

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final state = _state;
    final announcement = _announcement;

    final field = Focus(
      // Above the field's own node, so the arrows and Escape are seen before
      // the
      // text field turns them into caret movement.
      onKeyEvent: _handleKey,
      canRequestFocus: false,
      skipTraversal: true,
      child: widget.fieldBuilder(context, state),
    );

    return AstryxAnchoredOverlay(
      controller: _overlay,
      align: AstryxOverlayAlign.start,
      matchAnchorWidth: widget.matchFieldWidth,
      // Focus stays in the field, so the surface must not trap it — and Escape
      // is handled by the field's own key handler above.
      restoreFocus: false,
      escapeDismissible: false,
      semanticsLabel: widget.label,
      overlayBuilder: (context, position) => _Surface<T>(
        state: state,
        width: widget.matchFieldWidth ? null : widget.surfaceWidth,
        maxHeight: widget.maxHeight,
        scroll: _scroll,
        position: position,
        itemBuilder: widget.itemBuilder,
        emptyBuilder: widget.emptyBuilder,
        headerBuilder: widget.headerBuilder,
        footerBuilder: widget.footerBuilder,
      ),
      // Always a `Stack`, even with nothing to announce: the overlay measures
      // this subtree the frame it opens, and a child that changed shape on that
      // frame has no size yet — which left the surface empty for as long as it
      // was open. The shape stays put and only the announcement comes and goes.
      child: Stack(
        children: <Widget>[
          field,
          // Announced, never painted: the surface below already shows the
          // results to anybody who can see them.
          if (announcement != null)
            AstryxVisuallyHidden(
              liveRegion: true,
              child: Text(
                announcement,
                style: TextStyle(
                  color: theme.color(AstryxColorToken.textPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The floating list.
class _Surface<T> extends StatelessWidget {
  const _Surface({
    required this.state,
    required this.width,
    required this.maxHeight,
    required this.scroll,
    required this.position,
    required this.itemBuilder,
    required this.emptyBuilder,
    required this.headerBuilder,
    required this.footerBuilder,
  });

  final AstryxTypeaheadState<T> state;
  final double? width;
  final double maxHeight;
  final ScrollController scroll;
  final AstryxOverlayPosition position;
  final Widget Function(BuildContext, T, AstryxTypeaheadState<T>) itemBuilder;
  final Widget Function(BuildContext, String)? emptyBuilder;
  final Widget Function(BuildContext, AstryxTypeaheadState<T>)? headerBuilder;
  final Widget Function(BuildContext, AstryxTypeaheadState<T>)? footerBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    final body = state.suggestions.isEmpty
        ? Padding(
            padding: EdgeInsets.all(
              theme.spacing(AstryxSpacingToken.spacing3),
            ),
            child:
                emptyBuilder?.call(context, state.query) ??
                Text(
                  l10n.selectorNoResults,
                  style: TextStyle(
                    color: theme.color(AstryxColorToken.textSecondary),
                  ),
                ),
          )
        : ListView.builder(
            controller: scroll,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, state.suggestions[index], state),
          );

    final panel = AstryxOverlaySurface(
      position: position,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ?headerBuilder?.call(context, state),
            Flexible(child: body),
            ?footerBuilder?.call(context, state),
          ],
        ),
      ),
    );

    return width == null ? panel : SizedBox(width: width, child: panel);
  }
}
