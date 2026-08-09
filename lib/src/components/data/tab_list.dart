/// Tabs with an animated selection indicator.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/surface/badge.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/size_scope.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The tab heights, from the `--size-element-*` tokens.
enum AstryxTabSize {
  /// 28px.
  sm(AstryxSizeToken.elementSm, AstryxElementSize.sm),

  /// 32px. The default.
  md(AstryxSizeToken.elementMd, AstryxElementSize.md),

  /// 36px.
  lg(AstryxSizeToken.elementLg, AstryxElementSize.lg);

  const AstryxTabSize(this.token, this.elementSize);

  /// The size token giving the tab's height.
  final AstryxSizeToken token;

  /// The equivalent [AstryxElementSize].
  final AstryxElementSize elementSize;

  /// The tab size matching an inherited [AstryxElementSize].
  static AstryxTabSize fromElementSize(AstryxElementSize size) =>
      switch (size) {
        AstryxElementSize.sm => AstryxTabSize.sm,
        AstryxElementSize.md => AstryxTabSize.md,
        AstryxElementSize.lg => AstryxTabSize.lg,
      };
}

/// One tab.
@immutable
class AstryxTab<T> {
  /// Creates a tab.
  const AstryxTab({
    required this.value,
    required this.label,
    this.icon,
    this.badge,
    this.enabled = true,
  });

  /// What selecting this tab produces.
  final T value;

  /// The visible text, and this tab's accessible name.
  final String label;

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

  /// A count or status after the label.
  final AstryxBadge? badge;

  /// Whether the tab can be selected.
  final bool enabled;
}

/// A row of tabs with an animated indicator.
///
/// **Keyboard follows the ARIA tab pattern**, which Flutter's default traversal
/// does not: the strip is one tab stop, arrows move *and select* within it,
/// Home and End jump to the ends, and the inline arrows mirror under RTL. Tab
/// leaves the strip for the panel below.
///
/// {@tool snippet}
/// ```dart
/// AstryxTabList<String>(
///   value: _tab,
///   onChanged: (value) => setState(() => _tab = value),
///   tabs: const <AstryxTab<String>>[
///     AstryxTab(value: 'overview', label: 'Overview'),
///     AstryxTab(value: 'activity', label: 'Activity'),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// ## Overflow
///
/// Too many tabs for the available width **scroll horizontally**, with a fade
/// at whichever edge has more to show. Upstream collapses the overflow into a
/// menu via `OverflowList`; that widget is outside Tier-1 scope, so
/// overflow-to-menu is a 1.x feature. Scrolling keeps every tab reachable in
/// the meantime, which is the part that matters.
class AstryxTabList<T> extends StatefulWidget {
  /// Creates a tab list.
  const AstryxTabList({
    required this.tabs,
    required this.value,
    super.key,
    this.onChanged,
    this.size,
    this.showDivider = true,
    this.fill = false,
    this.label,
    this.focusNode,
    this.autofocus = false,
  });

  /// The tabs, in order.
  final List<AstryxTab<T>> tabs;

  /// The selected value.
  final T? value;

  /// Called with the newly selected value.
  final ValueChanged<T>? onChanged;

  /// The tab height.
  final AstryxTabSize? size;

  /// Whether to draw a rule under the strip.
  final bool showDivider;

  /// Whether the tabs share the full width equally.
  final bool fill;

  /// An accessible name for the strip.
  final String? label;

  /// The focus node for the strip, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxTabList<T>> createState() => _AstryxTabListState<T>();
}

class _AstryxTabListState<T> extends State<AstryxTabList<T>> {
  final ScrollController _scroll = ScrollController();
  final Map<int, GlobalKey> _tabKeys = <int, GlobalKey>{};

  bool _focused = false;
  bool _canScrollStart = false;
  bool _canScrollEnd = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_updateFades);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFades());
  }

  @override
  void didUpdateWidget(AstryxTabList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _updateFades() {
    if (!_scroll.hasClients) return;
    final start = _scroll.offset > 1;
    final end = _scroll.offset < _scroll.position.maxScrollExtent - 1;
    if (start == _canScrollStart && end == _canScrollEnd) return;
    setState(() {
      _canScrollStart = start;
      _canScrollEnd = end;
    });
  }

  int get _selectedIndex =>
      widget.tabs.indexWhere((tab) => tab.value == widget.value);

  bool get _interactive => widget.onChanged != null;

  void _select(int index) {
    final tab = widget.tabs[index];
    if (!_interactive || !tab.enabled) return;
    if (tab.value != widget.value) widget.onChanged!(tab.value);
    _revealSelected(index: index);
  }

  /// Scrolls a tab into view.
  ///
  /// The keyboard can move to a tab that is scrolled off the end, and a
  /// selection the user cannot see is worse than no selection at all.
  void _revealSelected({int? index}) {
    final target = index ?? _selectedIndex;
    if (target < 0 || !_scroll.hasClients) return;
    final key = _tabKeys[target];
    final box = key?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final viewport = _scroll.position.viewportDimension;
    final scrollBox = context.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;
    final start =
        box.localToGlobal(Offset.zero, ancestor: scrollBox).dx + _scroll.offset;
    final end = start + box.size.width;

    final double? next;
    if (start < _scroll.offset) {
      next = start;
    } else if (end > _scroll.offset + viewport) {
      next = end - viewport;
    } else {
      next = null;
    }
    if (next == null) return;
    _scroll.jumpTo(next.clamp(0.0, _scroll.position.maxScrollExtent));
  }

  /// Moves selection by [delta], skipping disabled tabs and wrapping.
  void _move(int delta) {
    if (!_interactive || widget.tabs.isEmpty) return;
    final count = widget.tabs.length;
    final start = _selectedIndex < 0 ? (delta > 0 ? -1 : 0) : _selectedIndex;

    for (var step = 1; step <= count; step++) {
      final raw = (start + delta * step) % count;
      final index = raw < 0 ? raw + count : raw;
      if (widget.tabs[index].enabled) {
        _select(index);
        return;
      }
    }
  }

  void _edge({required bool last}) {
    final index = last
        ? widget.tabs.lastIndexWhere((t) => t.enabled)
        : widget.tabs.indexWhere((t) => t.enabled);
    if (index >= 0) _select(index);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final key = event.logicalKey;

    // A horizontal strip, so the inline arrows are the primary axis and they
    // mirror. The block arrows work too, and never mirror.
    final delta = switch (key) {
      LogicalKeyboardKey.arrowRight => rtl ? -1 : 1,
      LogicalKeyboardKey.arrowLeft => rtl ? 1 : -1,
      LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowUp => -1,
      _ => 0,
    };
    if (delta != 0) {
      _move(delta);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.home) {
      _edge(last: false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      _edge(last: true);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final size =
        widget.size ??
        AstryxTabSize.fromElementSize(AstryxSizeScope.resolve(context, null));

    final tabs = <Widget>[
      for (var i = 0; i < widget.tabs.length; i++)
        Builder(
          builder: (context) {
            final tab = widget.tabs[i];
            final selected = tab.value == widget.value;
            final child = _Tab<T>(
              key: _tabKeys.putIfAbsent(i, GlobalKey.new),
              tab: tab,
              size: size,
              selected: selected,
              // The strip is one tab stop, so exactly one indicator is drawn
              // and only when the strip itself is focused.
              showFocusRing:
                  selected && _focused && AstryxFocusVisible.of(context),
              onTap: () => _select(i),
            );
            return widget.fill ? Expanded(child: child) : child;
          },
        ),
    ];

    Widget strip = Row(
      mainAxisSize: widget.fill ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: theme.spacing(AstryxSpacingToken.spacing0_5),
      children: tabs,
    );

    if (!widget.fill) {
      strip = SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: strip,
      );

      // The fade says "there is more this way". Only drawn on the side that
      // actually has more, so it is information rather than decoration.
      strip = _EdgeFades(
        showStart: _canScrollStart,
        showEnd: _canScrollEnd,
        child: strip,
      );
    }

    if (widget.showDivider) {
      strip = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.color(AstryxColorToken.border),
              width: theme.borderWidth(),
            ),
          ),
        ),
        child: strip,
      );
    }

    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: _interactive,
      onFocusChange: (value) => setState(() => _focused = value),
      onKeyEvent: _handleKey,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.label ?? l10n.tabListLabel,
        child: SizedBox(height: theme.size(size.token), child: strip),
      ),
    );
  }
}

/// One tab button.
class _Tab<T> extends StatefulWidget {
  const _Tab({
    required this.tab,
    required this.size,
    required this.selected,
    required this.showFocusRing,
    required this.onTap,
    super.key,
  });

  final AstryxTab<T> tab;
  final AstryxTabSize size;
  final bool selected;
  final bool showFocusRing;
  final VoidCallback onTap;

  @override
  State<_Tab<T>> createState() => _TabState<T>();
}

class _TabState<T> extends State<_Tab<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final density = AstryxTheme.densityOf(context);
    final enabled = widget.tab.enabled;

    final color = theme.color(
      !enabled
          ? AstryxColorToken.textDisabled
          : (widget.selected
                ? AstryxColorToken.textPrimary
                : AstryxColorToken.textSecondary),
    );

    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: theme.spacing(AstryxSpacingToken.spacing1),
        children: <Widget>[
          if (widget.tab.icon != null)
            IconTheme.merge(
              data: IconThemeData(
                size: AstryxIconSize.sm.pixels,
                color: color,
              ),
              child: widget.tab.icon!,
            ),
          Flexible(
            child: Text(
              widget.tab.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme
                  .textStyle(AstryxTypeRole.label)
                  .copyWith(
                    color: color,
                    // The selected tab is heavier as well as darker: weight
                    // survives a colour-blind viewer and a monochrome print.
                    fontWeight: theme.fontWeight(
                      widget.selected
                          ? AstryxFontWeightToken.semibold
                          : AstryxFontWeightToken.normal,
                    ),
                  ),
            ),
          ),
          ?widget.tab.badge,
        ],
      ),
    );

    content = Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Positioned.fill(
          child: AnimatedContainer(
            duration: motion.duration(AstryxDurationToken.fast),
            curve: motion.curve(),
            decoration: BoxDecoration(
              color: _hovered && enabled && density.supportsHover
                  ? theme.color(AstryxColorToken.overlayHover)
                  : const Color(0x00000000),
              borderRadius: theme.borderRadius(AstryxRadiusToken.element),
            ),
          ),
        ),
        Center(child: content),
        // The indicator is per-tab and fades, rather than one bar that slides
        // between tabs. A sliding bar needs every tab's geometry before it can
        // move; this reads the same and cannot desynchronise from the layout.
        PositionedDirectional(
          start: theme.spacing(AstryxSpacingToken.spacing3),
          end: theme.spacing(AstryxSpacingToken.spacing3),
          bottom: 0,
          child: AnimatedOpacity(
            opacity: widget.selected ? 1 : 0,
            duration: motion.duration(AstryxDurationToken.fast),
            curve: motion.curve(),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.accent),
                borderRadius: theme.borderRadius(AstryxRadiusToken.full),
              ),
            ),
          ),
        ),
      ],
    );

    content = AstryxFocusRing(
      focused: widget.showFocusRing,
      borderRadius: theme.borderRadius(AstryxRadiusToken.element),
      child: content,
    );

    content = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onTap : null,
        child: content,
      ),
    );

    return Semantics(
      selected: widget.selected,
      enabled: enabled,
      button: true,
      label: widget.tab.label,
      onTap: enabled ? widget.onTap : null,
      child: ExcludeSemantics(child: content),
    );
  }
}

/// Fades at whichever edge has more to scroll to.
class _EdgeFades extends StatelessWidget {
  const _EdgeFades({
    required this.showStart,
    required this.showEnd,
    required this.child,
  });

  final bool showStart;
  final bool showEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final background = AstryxTheme.of(
      context,
    ).color(AstryxColorToken.backgroundBody);

    return Stack(
      children: <Widget>[
        child,
        if (showStart)
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: _Fade(color: background, towardsStart: true),
          ),
        if (showEnd)
          PositionedDirectional(
            end: 0,
            top: 0,
            bottom: 0,
            child: _Fade(color: background, towardsStart: false),
          ),
      ],
    );
  }
}

class _Fade extends StatelessWidget {
  const _Fade({required this.color, required this.towardsStart});

  final Color color;
  final bool towardsStart;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox(
      width: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Directional, so the gradient runs the right way under RTL.
            begin: towardsStart
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            end: towardsStart
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    ),
  );
}
