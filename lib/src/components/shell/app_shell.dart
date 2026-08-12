/// The outer frame an application sits in.
library;

import 'package:astryx_ui/src/components/layout/divider.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Drives the navigation drawer the compact shell shows.
///
/// An [AstryxOverlayController], because the drawer *is* one of this package's
/// overlays: `show`, `hide` and `toggle` mean here what they mean on a dialog,
/// and the drawer joins the same dismissal stack, so Escape closes the topmost
/// thing rather than whatever was opened first.
class AstryxAppShellController extends AstryxOverlayController {}

/// What the shell tells the widgets inside it about itself.
///
/// The port of upstream's `useAppShellMobile`: a header cannot know whether to
/// draw a menu button without knowing whether the navigation is beside the
/// content or behind a drawer, and that answer belongs to the shell.
///
/// {@tool snippet}
/// ```dart
/// final shell = AstryxAppShell.of(context);
/// if (shell.compact)
///   AstryxIconButton(
///     icon: AstryxIconName.menu,
///     label: 'Open navigation',
///     onPressed: shell.controller.toggle,
///   )
/// ```
/// {@end-tool}
class AstryxAppShellScope extends InheritedWidget {
  /// Puts the shell's state in scope.
  const AstryxAppShellScope({
    required this.compact,
    required this.controller,
    required super.child,
    super.key,
  });

  /// Whether the navigation is behind a drawer rather than beside the content.
  final bool compact;

  /// The drawer's controller.
  final AstryxAppShellController controller;

  /// The nearest shell, or null when there is none.
  static AstryxAppShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxAppShellScope>();

  /// The nearest shell.
  ///
  /// Throws when there is none: a menu button that silently does nothing
  /// outside a shell is a bug that ships.
  static AstryxAppShellScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No AstryxAppShell above this widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AstryxAppShellScope oldWidget) =>
      compact != oldWidget.compact || controller != oldWidget.controller;
}

/// The frame around a whole application: a header, navigation, and the content.
///
/// **Wide, the navigation sits beside the content. Narrow, it moves behind a
/// drawer** — and the drawer is a real [AstryxOverlay], so it traps focus,
/// closes on Escape or a press on the scrim, and hands focus back to the button
/// that opened it. A shell that hides navigation without any of that is a shell
/// that loses keyboard users at the first tap.
///
/// The threshold is [compactBelow], a number rather than an entry in a
/// breakpoint table. This package has no breakpoint system on purpose: the
/// width at which *your* navigation stops fitting is a fact about your
/// navigation, and a global table means every screen has to agree about a
/// number none of them chose.
///
/// {@tool snippet}
/// ```dart
/// AstryxAppShell(
///   header: const AppBar(),
///   sidebar: const NavRail(),
///   child: AstryxLayout(
///     header: const AstryxHeading('Deploys', level: 1),
///     child: const DeployTable(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxLayout`, the frame *inside* the shell — the page's own header,
///    body, panel and footer.
class AstryxAppShell extends StatefulWidget {
  /// Creates an application shell.
  const AstryxAppShell({
    required this.child,
    super.key,
    this.header,
    this.sidebar,
    this.controller,
    this.sidebarWidth = 260,
    this.compactBelow = 900,
    this.navLabel,
  });

  /// The content: usually one `AstryxLayout`.
  final Widget child;

  /// The bar across the top, above both the navigation and the content.
  ///
  /// Full width by design: an application's identity and its account menu
  /// belong to the whole window, not to the column beside the nav.
  final Widget? header;

  /// The navigation, beside the content when there is room and behind a drawer
  /// when there is not.
  ///
  /// Usually an `AstryxSideNav`, which is the rail this slot was shaped for —
  /// but any widget will do, and an `AstryxList` of `AstryxItem`s gets a long
  /// way.
  final Widget? sidebar;

  /// Drives the drawer from outside. Null keeps one inside the shell.
  final AstryxAppShellController? controller;

  /// How wide the navigation is when it sits beside the content.
  final double sidebarWidth;

  /// The width below which the navigation moves into the drawer.
  final double compactBelow;

  /// The drawer's accessible name — "Navigation", "Sections".
  final String? navLabel;

  /// The shell's state, from a descendant's context.
  ///
  /// Shorthand for [AstryxAppShellScope.of].
  static AstryxAppShellScope of(BuildContext context) =>
      AstryxAppShellScope.of(context);

  @override
  State<AstryxAppShell> createState() => _AstryxAppShellState();
}

class _AstryxAppShellState extends State<AstryxAppShell> {
  AstryxAppShellController? _internal;

  AstryxAppShellController get _controller =>
      widget.controller ?? (_internal ??= AstryxAppShellController());

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < widget.compactBelow;

        // Growing out of the compact layout puts the navigation back beside the
        // content, so a drawer left open would be a second copy of it. Closed
        // after the frame, because a controller notifying its listeners during
        // build is a `setState` during build.
        if (!compact && _controller.isOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _controller.hide();
          });
        }

        final sidebar = widget.sidebar;

        var body = widget.child;
        if (sidebar != null && !compact) {
          body = Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(width: widget.sidebarWidth, child: sidebar),
              // A vertical rule needs a bounded height, which the `stretch`
              // above is what gives it.
              const AstryxDivider(axis: Axis.vertical),
              Expanded(child: body),
            ],
          );
        }

        Widget frame = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.header != null) ...<Widget>[
              widget.header!,
              const AstryxDivider(),
            ],
            Expanded(child: body),
          ],
        );

        if (sidebar != null && compact) {
          frame = Stack(
            children: <Widget>[
              frame,
              // The overlay renders nothing in place — it portals to the top of
              // the app — so it costs a zero-sized child here and nothing else
              // while the drawer is closed.
              AstryxOverlay(
                controller: _controller,
                label: widget.navLabel,
                alignment: AlignmentDirectional.centerStart,
                padding: EdgeInsets.zero,
                // Nothing to slide from: the primitive treats `slide` as a fade
                // when there is no anchor, which is what every other modal in
                // this package does too.
                transition: AstryxOverlayTransition.fade,
                child: SizedBox(
                  width: widget.sidebarWidth,
                  height: double.infinity,
                  child: ColoredBox(
                    color: theme.color(AstryxColorToken.backgroundSurface),
                    child: sidebar,
                  ),
                ),
              ),
            ],
          );
        }

        return AstryxAppShellScope(
          compact: compact,
          controller: _controller,
          child: frame,
        );
      },
    );
  }
}
