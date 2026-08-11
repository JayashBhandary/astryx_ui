/// A disclosure: a header that shows and hides its own content.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Drives an [AstryxCollapsible] from outside it.
///
/// {@tool snippet}
/// ```dart
/// final controller = AstryxCollapsibleController(expanded: true);
/// // …
/// controller.toggle();
/// ```
/// {@end-tool}
class AstryxCollapsibleController extends ChangeNotifier {
  /// Creates a collapsible controller, collapsed unless [expanded].
  AstryxCollapsibleController({bool expanded = false}) : _expanded = expanded;

  bool _expanded;

  /// Whether the content is showing.
  bool get isExpanded => _expanded;

  /// Shows the content.
  void expand() => _set(true);

  /// Hides the content.
  void collapse() => _set(false);

  /// Shows the content if hidden, hides it if shown.
  void toggle() => _set(!_expanded);

  void _set(bool value) {
    if (_expanded == value) return;
    _expanded = value;
    notifyListeners();
  }
}

/// A header that shows and hides the content below it.
///
/// The header is the control: the whole row is one button, it carries the
/// expanded state in its semantics, and Enter or Space works it. A disclosure
/// whose arrow alone is clickable is one that fails on a phone and on a
/// keyboard both.
///
/// {@tool snippet}
/// ```dart
/// AstryxCollapsible(
///   title: 'Advanced settings',
///   description: 'Timeouts, retries and headers',
///   child: const SettingsForm(),
/// )
/// ```
/// {@end-tool}
///
/// Uncontrolled by default: it owns its own expanded state and starts from
/// [initiallyExpanded]. Pass a [controller] to own that state yourself, or drop
/// it into an `AstryxCollapsibleGroup` to have the group own it.
///
/// See also:
///
///  * `AstryxCollapsibleGroup`, for several of these as one section.
class AstryxCollapsible extends StatefulWidget {
  /// Creates a collapsible.
  const AstryxCollapsible({
    required this.title,
    required this.child,
    super.key,
    this.controller,
    this.initiallyExpanded = false,
    this.description,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.onExpansionChanged,
  });

  /// The header text, and the header button's accessible name.
  final String title;

  /// The content shown while expanded.
  ///
  /// Built only when it is on screen, so a collapsed section costs nothing and
  /// a screen reader is never offered content that is not showing.
  final Widget child;

  /// Drives the expanded state from outside. Null keeps it internal.
  final AstryxCollapsibleController? controller;

  /// Whether the content starts visible. Ignored when [controller] is set.
  final bool initiallyExpanded;

  /// Secondary text below the title.
  final String? description;

  /// A widget before the title — an icon, a status dot.
  final Widget? leading;

  /// A widget after the title, before the chevron — a count, a badge.
  ///
  /// Not interactive: the whole header is one button, so a control here would
  /// be unreachable. Put actions in the content.
  final Widget? trailing;

  /// Whether the header responds.
  final bool enabled;

  /// Called with the new state whenever the section expands or collapses.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<AstryxCollapsible> createState() => _AstryxCollapsibleState();
}

class _AstryxCollapsibleState extends State<AstryxCollapsible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: _expanded ? 1 : 0,
  );

  late bool _internal = widget.initiallyExpanded;

  bool _hovered = false;
  bool _focused = false;

  /// The state the header should be showing right now.
  ///
  /// Three owners, in order of precedence: a controller the caller passed, the
  /// group this section is in, and failing both, this state.
  bool get _expanded {
    final controller = widget.controller;
    if (controller != null) return controller.isExpanded;
    final group = AstryxCollapsibleGroupScope.maybeOf(context);
    if (group != null && group.exclusive) return group.expanded;
    return _internal;
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleControllerChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The group changing which section is open arrives here, not through
    // `didUpdateWidget`: it is an inherited value, not a constructor argument.
    _syncAnimation();
  }

  @override
  void didUpdateWidget(AstryxCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      widget.controller?.addListener(_handleControllerChange);
    }
    _syncAnimation();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChange);
    _animation.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (!mounted) return;
    setState(_syncAnimation);
  }

  void _syncAnimation() {
    _animation.duration = AstryxMotion.of(
      context,
    ).duration(AstryxDurationToken.medium);

    final expanded = _expanded;
    if (expanded && _animation.status != AnimationStatus.forward) {
      _animation.forward();
    } else if (!expanded && _animation.status != AnimationStatus.reverse) {
      _animation.reverse();
    }
  }

  void _toggle() {
    if (!widget.enabled) return;
    final next = !_expanded;

    final controller = widget.controller;
    final group = AstryxCollapsibleGroupScope.maybeOf(context);

    if (controller != null) {
      controller.toggle();
    } else if (group != null && group.exclusive) {
      group.onToggle(expand: next);
    } else {
      setState(() => _internal = next);
      _syncAnimation();
    }

    widget.onExpansionChanged?.call(next);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.enter &&
        event.logicalKey != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    _toggle();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final expanded = _expanded;
    final hover = _hovered && AstryxTheme.densityOf(context).supportsHover;

    Widget header = Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
        vertical: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      decoration: BoxDecoration(
        color: hover && widget.enabled
            ? theme.color(AstryxColorToken.overlayHover)
            : const Color(0x00000000),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
      ),
      child: Row(
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          ?widget.leading,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AstryxText(
                  widget.title,
                  type: AstryxTextType.label,
                  color: widget.enabled
                      ? AstryxTextColor.primary
                      : AstryxTextColor.disabled,
                ),
                if (widget.description != null)
                  AstryxText(
                    widget.description!,
                    type: AstryxTextType.supporting,
                    color: widget.enabled
                        ? AstryxTextColor.secondary
                        : AstryxTextColor.disabled,
                  ),
              ],
            ),
          ),
          ?widget.trailing,
          // The chevron turns rather than swapping glyphs, so the direction it
          // travels says which way the content is about to go.
          RotationTransition(
            turns: Tween<double>(begin: 0, end: 0.5).animate(_animation),
            child: AstryxIcon(
              AstryxIconName.chevronDown,
              size: AstryxIconSize.sm,
              color: widget.enabled
                  ? AstryxIconColor.secondary
                  : AstryxIconColor.disabled,
            ),
          ),
        ],
      ),
    );

    header = MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? _toggle : null,
        child: header,
      ),
    );

    header = Focus(
      canRequestFocus: widget.enabled,
      onKeyEvent: _handleKey,
      onFocusChange: (value) => setState(() => _focused = value),
      child: AstryxFocusRing(
        focused: _focused && AstryxFocusVisible.of(context),
        borderRadius: theme.borderRadius(AstryxRadiusToken.element),
        child: header,
      ),
    );

    header = Semantics(
      button: true,
      enabled: widget.enabled,
      // The `Focus` below is inside the excluded subtree, so its focusability
      // has to be republished here or the header is announced as a button
      // nothing can reach.
      focusable: widget.enabled,
      focused: _focused,
      // The state, not a synonym for it. A screen reader says "expanded" or
      // "collapsed" itself; painting a rotated chevron says it to nobody else.
      expanded: expanded,
      label: widget.title,
      hint: widget.description,
      onTap: widget.enabled ? _toggle : null,
      child: ExcludeSemantics(child: header),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AstryxTapTarget(expandHorizontally: false, child: header),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Nothing in the tree while collapsed: no layout, no semantics, no
            // focus stops behind a closed section.
            if (_animation.isDismissed) return const SizedBox.shrink();
            // `Align` with a height factor rather than a `SizeTransition`: the
            // content has to be revealed from its top edge, and a size
            // transition centres what it is shrinking.
            return ClipRect(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                heightFactor: _animation.value,
                child: FadeTransition(opacity: _animation, child: child),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing(AstryxSpacingToken.spacing2),
              0,
              theme.spacing(AstryxSpacingToken.spacing2),
              theme.spacing(AstryxSpacingToken.spacing3),
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

/// What a collapsible inside a group reads to know its state.
///
/// Published per child, so each one sees its own answer rather than the whole
/// group's and having to work out which index it is.
@internal
class AstryxCollapsibleGroupScope extends InheritedWidget {
  /// Creates a group scope for one child.
  const AstryxCollapsibleGroupScope({
    required super.child,
    required this.exclusive,
    required this.expanded,
    required this.onToggle,
    super.key,
  });

  /// Whether the group allows only one section open at a time.
  ///
  /// False leaves each section owning its own state; the group is then only
  /// layout, and this scope only tells the child that.
  final bool exclusive;

  /// Whether this child is the open one.
  final bool expanded;

  /// Asks the group to open or close this child.
  final void Function({required bool expand}) onToggle;

  /// The group configuration at [context], or null outside a group.
  static AstryxCollapsibleGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxCollapsibleGroupScope>();

  @override
  bool updateShouldNotify(AstryxCollapsibleGroupScope oldWidget) =>
      exclusive != oldWidget.exclusive || expanded != oldWidget.expanded;
}
