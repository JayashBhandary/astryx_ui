/// The floating menu, and everything the keyboard does to it.
///
/// Extracted from `dropdown_menu.dart` so `AstryxContextMenu` renders the same
/// rows with the same keyboard model. A right-click menu that arrows
/// differently from the same product's toolbar menu is a bug the user cannot
/// name but does notice.
library;

import 'dart:async';

import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/components/overlay/overlay_surface.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The panel a menu's rows are painted on, and its keyboard model.
///
/// **The keyboard is the whole point.** Arrows move the highlight, Home and End
/// jump to the ends, typing jumps to the first match, Enter activates, and
/// forward and back open and close submenus — mirrored under RTL, where Left is
/// "forward". Nothing is activated merely by being highlighted.
@internal
class AstryxMenuSurface extends StatefulWidget {
  /// Creates a menu surface.
  const AstryxMenuSurface({
    required this.entries,
    required this.focusNode,
    required this.maxHeight,
    required this.onClose,
    super.key,
    this.width,
    this.maxWidth = double.infinity,
    this.autofocus = true,
  });

  /// The rows, in order.
  final List<AstryxMenuEntry> entries;

  /// The node that owns the arrow keys while the menu is open.
  final FocusNode focusNode;

  /// The tallest the menu may be before it scrolls.
  final double maxHeight;

  /// Closes the whole menu, including any open submenu.
  final VoidCallback onClose;

  /// A fixed width. Null lets the surface fill what it is given.
  final double? width;

  /// The widest the surface may become.
  ///
  /// A menu's rows stretch to the width they are offered, which is the whole
  /// viewport for a menu with nothing else bounding it. A dropdown is bounded
  /// by its trigger; a context menu, anchored to a point, is bounded by this.
  final double maxWidth;

  /// Whether the surface takes focus when it appears.
  ///
  /// False for a submenu, whose parent keeps the arrows.
  final bool autofocus;

  @override
  State<AstryxMenuSurface> createState() => _AstryxMenuSurfaceState();
}

class _AstryxMenuSurfaceState extends State<AstryxMenuSurface> {
  final ScrollController _scroll = ScrollController();

  int _highlighted = -1;

  /// The index whose submenu is open, or -1.
  int _openSubmenu = -1;

  /// Delays opening and closing a submenu so diagonal mouse travel from a
  /// parent row to its flyout does not close the thing it is travelling to.
  Timer? _submenuTimer;

  String _typeAhead = '';
  DateTime? _typeAheadAt;

  List<AstryxMenuItem> get _items => <AstryxMenuItem>[
    for (final entry in widget.entries)
      if (entry is AstryxMenuItem) entry,
  ];

  @override
  void dispose() {
    _submenuTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _move(int delta) {
    final items = _items;
    if (items.isEmpty) return;

    final start = _highlighted < 0 ? (delta > 0 ? -1 : 0) : _highlighted;
    for (var step = 1; step <= items.length; step++) {
      final raw = (start + delta * step) % items.length;
      final index = raw < 0 ? raw + items.length : raw;
      if (items[index].enabled) {
        _setHighlight(index);
        return;
      }
    }
  }

  void _edge({required bool last}) {
    final items = _items;
    final index = last
        ? items.lastIndexWhere((i) => i.enabled)
        : items.indexWhere((i) => i.enabled);
    if (index >= 0) _setHighlight(index);
  }

  void _setHighlight(int index) {
    setState(() {
      _highlighted = index;
      // Moving off a row closes its flyout. Leaving it open would leave two
      // highlights on screen and no way to tell which one Enter would take.
      if (_openSubmenu != index) _openSubmenu = -1;
    });
    _scrollTo(index);
  }

  void _scrollTo(int index) {
    if (!_scroll.hasClients) return;
    // Rows vary in height once descriptions are involved, so this is an
    // estimate rather than arithmetic — enough to keep the highlight on
    // screen, which is all it has to do.
    final estimate =
        _scroll.position.maxScrollExtent / (_items.isEmpty ? 1 : _items.length);
    final target = (index * estimate).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    final viewport = _scroll.position.viewportDimension;
    if (target < _scroll.offset) {
      _scroll.jumpTo(target);
    } else if (target > _scroll.offset + viewport - estimate) {
      _scroll.jumpTo(
        (target - viewport + estimate).clamp(
          0.0,
          _scroll.position.maxScrollExtent,
        ),
      );
    }
  }

  void _typeTo(String character) {
    final now = DateTime.now();
    final expired =
        _typeAheadAt == null ||
        now.difference(_typeAheadAt!) > const Duration(seconds: 1);
    _typeAhead = (expired ? '' : _typeAhead) + character.toLowerCase();
    _typeAheadAt = now;

    final index = _items.indexWhere(
      (i) => i.enabled && i.label.toLowerCase().startsWith(_typeAhead),
    );
    if (index >= 0) _setHighlight(index);
  }

  void _activate(int index) {
    final items = _items;
    if (index < 0 || index >= items.length) return;
    final item = items[index];
    if (!item.enabled) return;

    if (item.hasSubmenu) {
      setState(() => _openSubmenu = index);
      return;
    }
    // Close first, then act. The callback may push a route or open another
    // overlay, and a menu still on screen behind it is a bug users notice.
    widget.onClose();
    item.onSelected?.call();
  }

  void _scheduleSubmenu(int index, {required bool open}) {
    _submenuTimer?.cancel();
    _submenuTimer = Timer(
      // Opening waits longer than closing: the delay before a flyout appears
      // is what stops a menu flickering as the pointer crosses it.
      Duration(milliseconds: open ? 150 : 300),
      () {
        if (!mounted) return;
        setState(() {
          if (open) {
            _highlighted = index;
            _openSubmenu = index;
          } else if (_openSubmenu == index) {
            _openSubmenu = -1;
          }
        });
      },
    );
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    // Forward opens a submenu, back closes it. Which arrow is which depends on
    // the reading direction, exactly as it does in a native menu bar.
    final forward = rtl
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;
    final backward = rtl
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;

    if (key == LogicalKeyboardKey.arrowDown) {
      _move(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _move(-1);
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
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activate(_highlighted);
      return KeyEventResult.handled;
    }
    if (key == forward) {
      final items = _items;
      if (_highlighted >= 0 &&
          _highlighted < items.length &&
          items[_highlighted].hasSubmenu) {
        setState(() => _openSubmenu = _highlighted);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == backward) {
      if (_openSubmenu >= 0) {
        setState(() => _openSubmenu = -1);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    final character = event.character;
    if (character != null &&
        character.length == 1 &&
        character.trim().isNotEmpty) {
      _typeTo(character);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final padding = theme.spacing(AstryxSpacingToken.spacing1);

    var index = -1;
    final rows = <Widget>[];
    for (final entry in widget.entries) {
      switch (entry) {
        case AstryxMenuItem():
          index++;
          final i = index;
          rows.add(
            _MenuRow(
              item: entry,
              highlighted: i == _highlighted,
              submenuOpen: i == _openSubmenu,
              onTap: () => _activate(i),
              onHover: () {
                if (!entry.enabled) return;
                setState(() => _highlighted = i);
                if (entry.hasSubmenu) {
                  _scheduleSubmenu(i, open: true);
                } else if (_openSubmenu >= 0) {
                  _scheduleSubmenu(_openSubmenu, open: false);
                }
              },
              onClose: widget.onClose,
              maxHeight: widget.maxHeight,
            ),
          );
        case AstryxMenuDivider():
          rows.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: padding / 2),
              child: const AstryxDivider(),
            ),
          );
        case AstryxMenuSection():
          rows.add(
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(AstryxSpacingToken.spacing2),
                vertical: padding,
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

    Widget surface = AstryxOverlaySurface(
      padding: EdgeInsets.all(padding),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        child: rows.isEmpty
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                controller: _scroll,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: rows,
                ),
              ),
      ),
    );

    if (widget.width != null) {
      surface = SizedBox(width: widget.width, child: surface);
    } else if (widget.maxWidth.isFinite) {
      surface = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: surface,
      );
    }

    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        // No `menu` role exists in Flutter's semantics vocabulary, so the
        // surface is a plain container and each row carries `button` — which
        // is what a screen reader reports for a menu item anyway.
        child: surface,
      ),
    );
  }
}

/// One row.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.item,
    required this.highlighted,
    required this.submenuOpen,
    required this.onTap,
    required this.onHover,
    required this.onClose,
    required this.maxHeight,
  });

  final AstryxMenuItem item;
  final bool highlighted;
  final bool submenuOpen;
  final VoidCallback onTap;
  final VoidCallback onHover;
  final VoidCallback onClose;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final labelColor = !item.enabled
        ? AstryxTextColor.disabled
        : (item.destructive
              ? AstryxTextColor.inherit
              : AstryxTextColor.primary);

    Widget row = Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
        vertical: theme.spacing(AstryxSpacingToken.spacing1_5),
      ),
      decoration: BoxDecoration(
        color: highlighted
            ? theme.color(AstryxColorToken.overlayHover)
            : const Color(0x00000000),
        // The inner radius, so a highlighted row's corners sit inside the
        // menu's own — upstream computes the same thing with a `calc()`.
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      ),
      child: Row(
        spacing: theme.spacing(AstryxSpacingToken.spacing2),
        children: <Widget>[
          if (item.icon != null)
            IconTheme.merge(
              data: IconThemeData(
                size: AstryxIconSize.sm.pixels,
                color: theme.color(
                  !item.enabled
                      ? AstryxColorToken.iconDisabled
                      : (item.destructive
                            ? AstryxColorToken.error
                            : AstryxColorToken.iconSecondary),
                ),
              ),
              child: item.icon!,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AstryxText(
                  item.label,
                  type: AstryxTextType.label,
                  color: labelColor,
                  maxLines: 1,
                  style: item.destructive && item.enabled
                      ? TextStyle(
                          color: theme.color(AstryxColorToken.error),
                        )
                      : null,
                ),
                if (item.description != null)
                  AstryxText(
                    item.description!,
                    type: AstryxTextType.supporting,
                    color: item.enabled
                        ? AstryxTextColor.secondary
                        : AstryxTextColor.disabled,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          ?item.trailing,
          if (item.hasSubmenu)
            AstryxIcon(
              AstryxIconName.chevronRight,
              size: AstryxIconSize.sm,
              color: item.enabled
                  ? AstryxIconColor.secondary
                  : AstryxIconColor.disabled,
            ),
        ],
      ),
    );

    row = MouseRegion(
      cursor: item.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.enabled ? onTap : null,
        child: row,
      ),
    );

    row = Semantics(
      button: true,
      enabled: item.enabled,
      label: item.label,
      hint: item.description,
      expanded: item.hasSubmenu ? submenuOpen : null,
      onTap: item.enabled ? onTap : null,
      child: ExcludeSemantics(child: row),
    );

    if (!item.hasSubmenu) return row;

    // The flyout is another anchored overlay, anchored to this row — the same
    // positioner call, so it flips to the other side near a screen edge just
    // as the parent menu does.
    return _Submenu(
      item: item,
      open: submenuOpen,
      onClose: onClose,
      maxHeight: maxHeight,
      child: row,
    );
  }
}

/// A flyout anchored to its parent row.
class _Submenu extends StatefulWidget {
  const _Submenu({
    required this.item,
    required this.open,
    required this.onClose,
    required this.maxHeight,
    required this.child,
  });

  final AstryxMenuItem item;
  final bool open;
  final VoidCallback onClose;
  final double maxHeight;
  final Widget child;

  @override
  State<_Submenu> createState() => _SubmenuState();
}

class _SubmenuState extends State<_Submenu> {
  final AstryxOverlayController _controller = AstryxOverlayController();
  final FocusNode _focus = FocusNode(debugLabel: 'AstryxMenuSurface submenu');

  @override
  void initState() {
    super.initState();
    if (widget.open) _controller.show();
  }

  @override
  void didUpdateWidget(_Submenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open == oldWidget.open) return;
    widget.open ? _controller.show() : _controller.hide();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AstryxAnchoredOverlay(
    controller: _controller,
    side: AstryxOverlaySide.right,
    align: AstryxOverlayAlign.start,
    // The parent menu owns dismissal. A submenu that registered its own
    // barrier would swallow the press meant to close the whole thing.
    barrierDismissible: false,
    escapeDismissible: false,
    overlayBuilder: (context, position) => AstryxMenuSurface(
      entries: widget.item.submenu,
      focusNode: _focus,
      maxHeight: widget.maxHeight,
      onClose: widget.onClose,
      // Focus stays with the parent menu, whose key handler owns the arrows;
      // taking it here would break Left-to-go-back.
      autofocus: false,
    ),
    child: widget.child,
  );
}
