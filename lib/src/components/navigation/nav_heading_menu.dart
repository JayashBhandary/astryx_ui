/// A navigation heading that is itself a menu trigger.
library;

import 'package:astryx_ui/src/components/data/item.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/overlay/dropdown_menu.dart';
import 'package:astryx_ui/src/components/overlay/menu_entry.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:flutter/widgets.dart';

/// The heading at the top of a navigation, which opens a menu.
///
/// What a workspace or project switcher is: the name of the thing you are
/// looking at, and the way to look at a different one. Upstream ships it as its
/// own component because the two jobs are hard to combine by hand — a heading
/// is not a button, and a button that looks like a heading usually stops being
/// operable somewhere along the way.
///
/// {@tool snippet}
/// ```dart
/// AstryxNavHeadingMenu(
///   label: 'Acme Corp',
///   description: 'Production',
///   entries: <AstryxMenuEntry>[
///     AstryxMenuItem(label: 'Acme Corp', onSelected: () => switchTo('acme')),
///     AstryxMenuItem(label: 'Globex', onSelected: () => switchTo('globex')),
///     const AstryxMenuDivider(),
///     AstryxMenuItem(label: 'New workspace', onSelected: create),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxSideNav`, whose `header` this usually is.
///  * `AstryxNavSection`, for a heading that only labels a group.
class AstryxNavHeadingMenu extends StatelessWidget {
  /// Creates a heading menu.
  const AstryxNavHeadingMenu({
    required this.label,
    required this.entries,
    super.key,
    this.description,
    this.leading,
    this.collapsed = false,
    this.enabled = true,
    this.menuLabel,
    this.menuWidth,
  });

  /// The name of the thing being looked at, and the row's accessible name.
  final String label;

  /// Secondary text under the label — the environment, the plan, the role.
  final String? description;

  /// Content at the reading-start edge — a logo, an avatar.
  final Widget? leading;

  /// Whether the enclosing rail is collapsed.
  ///
  /// The label then becomes the accessible name alone, exactly as a collapsed
  /// rail's rows do, and the chevron goes with it: a chevron with nothing
  /// beside it is a button whose purpose has left.
  final bool collapsed;

  /// Whether the heading opens its menu.
  final bool enabled;

  /// An accessible name for the menu surface. Defaults to [label].
  final String? menuLabel;

  /// A fixed width for the menu. Null matches the trigger.
  final double? menuWidth;

  /// The rows the menu shows.
  final List<AstryxMenuEntry> entries;

  @override
  Widget build(BuildContext context) {
    return AstryxDropdownMenu(
      label: menuLabel ?? label,
      entries: entries,
      width: menuWidth,
      matchTriggerWidth: menuWidth == null,
      triggerBuilder: (context, controller) => AstryxItem(
        label: label,
        description: collapsed ? null : description,
        leading: leading,
        labelHidden: collapsed,
        enabled: enabled,
        density: AstryxItemDensity.balanced,
        // The chevron is the whole difference between this and a heading, so
        // it goes where a screen reader has already been told there is a menu:
        // beside the name, not instead of it.
        trailing: collapsed
            ? null
            : AstryxIcon(
                AstryxIconName.chevronDown,
                size: AstryxIconSize.sm,
                color: enabled
                    ? AstryxIconColor.secondary
                    : AstryxIconColor.disabled,
              ),
        onPressed: enabled ? controller.toggle : null,
        semanticsLabel: description == null || collapsed
            ? label
            : '$label, $description',
      ),
    );
  }
}
