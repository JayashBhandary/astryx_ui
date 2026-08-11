/// The navigation drawer a narrow window gets, and the button that opens it.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/navigation/nav_entry.dart';
import 'package:astryx_ui/src/components/navigation/side_nav.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/components/shell/app_shell.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// The navigation as a drawer, for a window with no room for a rail.
///
/// The same [AstryxNavEntry] list as `AstryxSideNav` — the rows are drawn by
/// the same code, so a drawer cannot drift from the rail it stands in for.
///
/// **Inside an `AstryxAppShell` you do not need this.** Give the shell an
/// `AstryxSideNav` as its `sidebar` and it moves that into a drawer itself when
/// the window is narrow. This is for the application that has no shell, or one
/// whose navigation is somewhere else entirely.
///
/// {@tool snippet}
/// ```dart
/// AstryxMobileNav(
///   controller: _nav,
///   selectedId: _section,
///   onSelected: (id) {
///     setState(() => _section = id);
///     _nav.hide();
///   },
///   entries: _entries,
/// )
/// ```
/// {@end-tool}
class AstryxMobileNav extends StatelessWidget {
  /// Creates a navigation drawer.
  const AstryxMobileNav({
    required this.controller,
    required this.entries,
    super.key,
    this.selectedId,
    this.onSelected,
    this.header,
    this.footer,
    this.label,
    this.width = 280,
    this.density = AstryxItemDensity.compact,
  });

  /// The open/closed state.
  ///
  /// An `AstryxOverlayController`, because the drawer is one of this package's
  /// overlays: it traps focus, closes on Escape or a press on the scrim, hands
  /// focus back to whatever opened it, and joins the same dismissal stack as
  /// every dialog and menu.
  final AstryxOverlayController controller;

  /// The destinations, sections and dividers, in order.
  final List<AstryxNavEntry> entries;

  /// The id of the current destination.
  final String? selectedId;

  /// Called with the id of the destination the user chose.
  ///
  /// **Closing the drawer is yours to do.** A drawer that closed itself would
  /// take a mis-tap as a navigation, and a drawer that never closed would cover
  /// the page the user just asked for.
  final ValueChanged<String>? onSelected;

  /// Content above the rows.
  final Widget? header;

  /// Content pinned below the rows.
  final Widget? footer;

  /// The drawer's accessible name.
  final String? label;

  /// How wide the drawer is.
  final double width;

  /// The vertical rhythm the rows take.
  final AstryxItemDensity density;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    return AstryxOverlay(
      controller: controller,
      label: label ?? l10n.navLabel,
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.zero,
      // Nothing to slide from: the primitive treats `slide` as a fade with no
      // anchor, which is what every other modal in this package does.
      transition: AstryxOverlayTransition.fade,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: ColoredBox(
          color: theme.color(AstryxColorToken.backgroundSurface),
          child: AstryxSideNav(
            entries: entries,
            selectedId: selectedId,
            onSelected: onSelected,
            header: header,
            footer: footer,
            label: label ?? l10n.navLabel,
            density: density,
          ),
        ),
      ),
    );
  }
}

/// The button that opens a navigation drawer.
///
/// With no [controller] it drives the drawer of the enclosing
/// `AstryxAppShell` — which is the common case, and the one where wiring a
/// controller by hand would mean two sources of truth for whether the
/// navigation is open.
///
/// {@tool snippet}
/// ```dart
/// // Inside an AstryxAppShell, in its header:
/// if (AstryxAppShell.of(context).compact) const AstryxMobileNavToggle()
/// ```
/// {@end-tool}
class AstryxMobileNavToggle extends StatelessWidget {
  /// Creates a navigation toggle.
  const AstryxMobileNavToggle({
    super.key,
    this.controller,
    this.label,
    this.size = AstryxButtonSize.md,
    this.variant = AstryxButtonVariant.ghost,
  });

  /// The drawer to open. Null uses the enclosing shell's.
  final AstryxOverlayController? controller;

  /// Overrides the button's accessible name and tooltip.
  final String? label;

  /// The button size.
  final AstryxButtonSize size;

  /// The button variant.
  final AstryxButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);
    final target = controller ?? AstryxAppShell.of(context).controller;
    final name = label ?? l10n.navOpen;

    return AstryxIconButton(
      icon: AstryxIconName.menu,
      label: name,
      tooltip: name,
      size: size,
      variant: variant,
      onPressed: target.toggle,
    );
  }
}
