/// The overflow menu a toolbar or a navigation collapses its tail into.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:flutter/widgets.dart';

/// A "…" button and the menu behind it.
///
/// One widget rather than an `AstryxIconButton` plus an `AstryxDropdownMenu`
/// written out at every call site — which is what a toolbar, a navigation and a
/// table row each need at their end, and which is exactly the composition
/// people get subtly wrong: an unnamed trigger, or one that opens a menu with
/// no name of its own.
///
/// {@tool snippet}
/// ```dart
/// AstryxMoreMenu(
///   entries: <AstryxMenuEntry>[
///     AstryxMenuItem(label: 'Rename', onSelected: rename),
///     const AstryxMenuDivider(),
///     AstryxMenuItem(label: 'Delete', destructive: true, onSelected: remove),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxOverflowList`, which measures a row and decides *what* goes in
///    here.
///  * `AstryxDropdownMenu`, for a menu with a trigger of your own.
class AstryxMoreMenu extends StatelessWidget {
  /// Creates an overflow menu.
  const AstryxMoreMenu({
    required this.entries,
    super.key,
    this.label,
    this.icon = AstryxIconName.moreHorizontal,
    this.size = AstryxButtonSize.sm,
    this.variant = AstryxButtonVariant.ghost,
    this.enabled = true,
    this.controller,
  });

  /// The rows, in order.
  final List<AstryxMenuEntry> entries;

  /// The trigger's accessible name, its tooltip, and the menu's name.
  ///
  /// All three from one string, because they are one answer to one question:
  /// what is behind this button?
  final String? label;

  /// The glyph on the trigger.
  ///
  /// [AstryxIconName.moreHorizontal] by default. A vertical one is the same
  /// menu in a narrower column.
  final AstryxIconName icon;

  /// The trigger's size.
  final AstryxButtonSize size;

  /// The trigger's variant.
  final AstryxButtonVariant variant;

  /// Whether the menu opens.
  final bool enabled;

  /// Drives the menu from outside.
  final AstryxOverlayController? controller;

  @override
  Widget build(BuildContext context) {
    final name = label ?? AstryxLocalizations.of(context).moreMenuLabel;

    return AstryxDropdownMenu(
      label: name,
      entries: entries,
      controller: controller,
      matchTriggerWidth: false,
      triggerBuilder: (context, controller) => AstryxIconButton(
        icon: icon,
        label: name,
        tooltip: name,
        size: size,
        variant: variant,
        enabled: enabled,
        onPressed: controller.toggle,
      ),
    );
  }
}
