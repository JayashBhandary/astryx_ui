/// The icon slot in a navigation row.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A fixed square holding a navigation row's icon.
///
/// **The square is the point, not the icon.** Every row reserves the same slot,
/// so labels line up whether or not their neighbours have icons, and a rail
/// that collapses to icons alone keeps them on one axis instead of shuffling
/// as the labels go. An icon dropped straight into a row gets neither.
///
/// It also carries the row's state: the glyph takes the accent when the row is
/// selected, and dims when it is disabled.
///
/// {@tool snippet}
/// ```dart
/// AstryxNavItem(
///   id: 'deploys',
///   label: 'Deploys',
///   icon: const AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
/// )
/// ```
/// {@end-tool}
class AstryxNavIcon extends StatelessWidget {
  /// Creates an icon slot.
  const AstryxNavIcon(
    this.icon, {
    super.key,
    this.selected = false,
    this.enabled = true,
    this.size = AstryxIconSize.md,
  });

  /// The glyph. Any widget; size and colour come from the slot.
  final Widget icon;

  /// Whether the row this belongs to is the current destination.
  final bool selected;

  /// Whether the row accepts input.
  final bool enabled;

  /// How large the glyph is drawn. The slot is sized from it.
  final AstryxIconSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final color = !enabled
        ? AstryxColorToken.iconDisabled
        : selected
        ? AstryxColorToken.iconAccent
        : AstryxColorToken.iconSecondary;

    return SizedBox.square(
      dimension: size.pixels,
      child: Center(
        child: IconTheme.merge(
          data: IconThemeData(size: size.pixels, color: theme.color(color)),
          child: icon,
        ),
      ),
    );
  }
}
