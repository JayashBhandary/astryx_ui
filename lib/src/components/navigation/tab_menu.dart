/// A tab whose selection opens a menu.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A tab that opens a menu instead of switching a panel.
///
/// For the strip where most tabs are views and one is a *set* of views — "More
/// reports", a saved-view picker, the tail of a strip too long for the bar. It
/// is drawn as a tab so it reads as one, and announced as a menu button so
/// nobody is told it is a tab and then handed a menu.
///
/// {@tool snippet}
/// ```dart
/// AstryxHStack(
///   children: <Widget>[
///     AstryxTabList<View>(value: _view, onChanged: _select, tabs: _tabs),
///     AstryxTabMenu(
///       label: 'More reports',
///       selected: _view.isReport,
///       entries: <AstryxMenuEntry>[
///         AstryxMenuItem(label: 'Usage', onSelected: () => _select(usage)),
///       ],
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxTabList`, for the tabs that do switch a panel.
///  * `AstryxMoreMenu`, when it does not need to look like a tab.
class AstryxTabMenu extends StatefulWidget {
  /// Creates a tab menu.
  const AstryxTabMenu({
    required this.label,
    required this.entries,
    super.key,
    this.icon,
    this.selected = false,
    this.enabled = true,
    this.menuLabel,
    this.controller,
  });

  /// The visible text, and the trigger's accessible name.
  final String label;

  /// The rows the menu shows.
  final List<AstryxMenuEntry> entries;

  /// An icon before the label.
  final Widget? icon;

  /// Whether the view currently showing came from this menu.
  ///
  /// Draws the tab's indicator, which is what keeps the strip honest: a reader
  /// looking at a report should see *something* in the strip claiming it.
  final bool selected;

  /// Whether the menu opens.
  final bool enabled;

  /// An accessible name for the menu surface. Defaults to [label].
  final String? menuLabel;

  /// Drives the menu from outside.
  final AstryxOverlayController? controller;

  @override
  State<AstryxTabMenu> createState() => _AstryxTabMenuState();
}

class _AstryxTabMenuState extends State<AstryxTabMenu> {
  bool _hovered = false;
  bool _focused = false;

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final hovered = _hovered && AstryxTheme.densityOf(context).supportsHover;

    return AstryxDropdownMenu(
      label: widget.menuLabel ?? widget.label,
      entries: widget.entries,
      controller: widget.controller,
      matchTriggerWidth: false,
      triggerBuilder: (context, controller) {
        final color = !widget.enabled
            ? AstryxTextColor.disabled
            : widget.selected || hovered
            ? AstryxTextColor.primary
            : AstryxTextColor.secondary;

        Widget trigger = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing(AstryxSpacingToken.spacing3),
                vertical: theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing(AstryxSpacingToken.spacing1_5),
                children: <Widget>[
                  ?widget.icon,
                  AstryxText(
                    widget.label,
                    type: AstryxTextType.label,
                    color: color,
                    maxLines: 1,
                  ),
                  AstryxIcon(
                    AstryxIconName.chevronDown,
                    size: AstryxIconSize.sm,
                    color: widget.enabled
                        ? AstryxIconColor.secondary
                        : AstryxIconColor.disabled,
                  ),
                ],
              ),
            ),
            // The same indicator a tab draws, for the same reason: the strip
            // has to show which of its entries the page came from.
            AnimatedContainer(
              duration: motion.duration(AstryxDurationToken.fast),
              curve: motion.curve(),
              height: 2,
              decoration: BoxDecoration(
                color: theme.color(
                  widget.selected
                      ? AstryxColorToken.accent
                      : AstryxColorToken.border,
                ),
                borderRadius: theme.borderRadius(AstryxRadiusToken.full),
              ),
            ),
          ],
        );

        trigger = AstryxFocusRing(
          focused: _focused && AstryxFocusVisible.of(context),
          borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
          child: trigger,
        );

        return Semantics(
          container: true,
          button: true,
          // A menu button, not a tab: telling a screen-reader user this is a
          // tab and then opening a menu is a promise the widget cannot keep.
          enabled: widget.enabled,
          label: widget.label,
          selected: widget.selected ? true : null,
          onTap: widget.enabled ? controller.toggle : null,
          child: ExcludeSemantics(
            child: Focus(
              canRequestFocus: widget.enabled,
              onFocusChange: (value) => _set(() => _focused = value),
              child: MouseRegion(
                cursor: widget.enabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                onEnter: (_) => _set(() => _hovered = true),
                onExit: (_) => _set(() => _hovered = false),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.enabled ? controller.toggle : null,
                  child: AstryxTapTarget(
                    expandHorizontally: false,
                    child: trigger,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
