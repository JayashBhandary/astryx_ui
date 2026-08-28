/// A menu raised by a secondary click, at the pointer.
library;

import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/components/overlay/menu_surface.dart';
import 'package:astryx_ui/src/foundation/browser_context_menu.dart';
import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:flutter/widgets.dart';

/// The actions for the thing under the pointer, raised where the pointer is.
///
/// It takes the same [AstryxMenuEntry] rows as `AstryxDropdownMenu` and gives
/// them the same keyboard model — arrows, type-ahead, submenus, Escape. What
/// differs is what opens it and where it lands: a **secondary click** on a
/// pointer, a **long-press** on touch, and the menu appears at the pointer
/// rather than against the trigger's edge.
///
/// {@tool snippet}
/// ```dart
/// AstryxContextMenu(
///   entries: <AstryxMenuEntry>[
///     AstryxMenuItem(label: 'Rename', onSelected: _rename),
///     const AstryxMenuDivider(),
///     AstryxMenuItem(label: 'Delete', destructive: true, onSelected: _delete),
///   ],
///   child: const RowOfTheTable(),
/// )
/// ```
/// {@end-tool}
///
/// **Nothing may live only here.** A right-click has no keyboard equivalent
/// Flutter can offer and no discoverable affordance at all: a user who does not
/// try it never learns the actions exist. Every entry needs a second home — a
/// toolbar, a row menu, a details panel — and this is the shortcut for people
/// who already know it is there.
///
/// ## The browser's own menu
///
/// On the web a secondary click is the browser's before it is the
/// application's, so without help the browser raises its Back / Reload /
/// Inspect menu on top of this one — two menus for one click, and the one the
/// user wanted underneath.
///
/// **This widget handles it.** While one is mounted and able to open, the
/// browser's menu is suppressed; when the last one goes, it comes back. Flutter
/// offers no way to suppress it over one region only — `BrowserContextMenu` is
/// whole-document — so "while the page has a context menu of its own" is the
/// narrowest scope available. Set [suppressBrowserMenu] to false to opt one
/// widget out of that.
///
/// An app that wants the browser's menu off everywhere should still say so
/// once at startup, and this will not turn back on what it did not turn off:
///
/// ```dart
/// if (kIsWeb) await BrowserContextMenu.disableContextMenu();
/// ```
class AstryxContextMenu extends StatefulWidget {
  /// Creates a context menu.
  const AstryxContextMenu({
    required this.entries,
    required this.child,
    super.key,
    this.label,
    this.enabled = true,
    this.width,
    this.maxWidth = 280,
    this.maxHeight = 300,
    this.longPressOnTouch = true,
    this.suppressBrowserMenu = true,
    this.onOpenChange,
  });

  /// The rows, in order.
  final List<AstryxMenuEntry> entries;

  /// The region a secondary click opens the menu over.
  final Widget child;

  /// An accessible name for the menu surface.
  final String? label;

  /// Whether the menu can be opened.
  final bool enabled;

  /// A fixed width. Null lets the menu size itself up to [maxWidth].
  final double? width;

  /// The widest the menu may become.
  ///
  /// A dropdown menu is bounded by its trigger. This one is anchored to a
  /// point, so without a bound it would stretch to the viewport — which is not
  /// a menu, it is a banner with rows.
  final double maxWidth;

  /// The tallest the menu may be before it scrolls.
  final double maxHeight;

  /// Whether a long-press opens the menu in touch density.
  ///
  /// The only way to reach it without a secondary button. Set false where the
  /// child has its own long-press — a drag handle, a message bubble — and give
  /// the actions another home instead.
  final bool longPressOnTouch;

  /// Whether to keep the browser's own right-click menu out of the way.
  ///
  /// Web only, and whole-document rather than local — see the note on this
  /// class. False leaves the browser's menu alone, which is what a region that
  /// wants both, or an app that manages the setting itself, should say.
  final bool suppressBrowserMenu;

  /// Called whenever the menu opens or closes.
  final ValueChanged<bool>? onOpenChange;

  @override
  State<AstryxContextMenu> createState() => _AstryxContextMenuState();
}

class _AstryxContextMenuState extends State<AstryxContextMenu> {
  final AstryxOverlayController _controller = AstryxOverlayController();
  final FocusNode _menuFocus = FocusNode(debugLabel: 'AstryxContextMenu');

  /// Where the menu was raised, in global coordinates.
  Offset? _at;

  /// Whether this widget is currently holding the browser menu down.
  bool _claimed = false;

  /// Whether a secondary click here would actually open something.
  ///
  /// A menu that cannot open has no quarrel with the browser's, and taking the
  /// browser's menu away over a widget that does nothing with the click is a
  /// worse bug than the one this fixes.
  bool get _wantsBrowserMenuSuppressed =>
      widget.suppressBrowserMenu && widget.enabled && widget.entries.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleOpenChange);
    _syncBrowserMenuClaim();
  }

  @override
  void didUpdateWidget(AstryxContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // `enabled` and `entries` both move over a widget's life — a row whose
    // actions depend on selection empties and refills — so the claim is
    // re-derived rather than taken once at mount.
    _syncBrowserMenuClaim();
  }

  @override
  void dispose() {
    _releaseBrowserMenuClaim();
    _controller.removeListener(_handleOpenChange);
    _controller.dispose();
    _menuFocus.dispose();
    super.dispose();
  }

  void _syncBrowserMenuClaim() {
    if (_wantsBrowserMenuSuppressed == _claimed) return;
    if (_claimed) {
      _releaseBrowserMenuClaim();
    } else {
      _claimed = true;
      AstryxBrowserContextMenu.claim();
    }
  }

  void _releaseBrowserMenuClaim() {
    if (!_claimed) return;
    _claimed = false;
    AstryxBrowserContextMenu.release();
  }

  void _handleOpenChange() {
    widget.onOpenChange?.call(_controller.isOpen);
    if (!_controller.isOpen) return;
    // The menu takes focus so the arrows have somewhere to land. Deferred a
    // frame, because the surface does not exist until the portal builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isOpen) _menuFocus.requestFocus();
    });
  }

  void _openAt(Offset global) {
    if (!widget.enabled || widget.entries.isEmpty) return;
    // A second click somewhere else moves the menu rather than opening a
    // second one, which is what every native menu does.
    setState(() => _at = global);
    _controller.show();
  }

  @override
  Widget build(BuildContext context) {
    final density = AstryxTheme.densityOf(context);
    final at = _at;

    return AstryxAnchoredOverlay(
      controller: _controller,
      // A point, not a rect: the menu belongs to where the pointer was, and
      // aligning it to the child's edge would put it somewhere the user was
      // not looking.
      anchorRect: at == null ? null : Rect.fromLTWH(at.dx, at.dy, 0, 0),
      align: AstryxOverlayAlign.start,
      gap: 0,
      semanticsLabel: widget.label,
      overlayBuilder: (context, position) => AstryxMenuSurface(
        entries: widget.entries,
        focusNode: _menuFocus,
        width: widget.width,
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
        onClose: _controller.hide,
      ),
      child: GestureDetector(
        // Translucent, not opaque: the child's own taps, drags and hovers all
        // have to keep working. This adds a gesture, it does not take one.
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: widget.enabled
            ? (details) => _openAt(details.globalPosition)
            : null,
        onLongPressStart:
            widget.enabled && widget.longPressOnTouch && !density.supportsHover
            ? (details) => _openAt(details.globalPosition)
            : null,
        child: widget.child,
      ),
    );
  }
}
