import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// #example platform_targets -> PlatformTargetsExample
/// One target, and what the package resolves for it.
///
/// The glyphs come from Lucide directly rather than from `AstryxIconName`,
/// which names only what the widget set itself needs. Every icon slot takes a
/// `Widget`, so an application's own icons go in the same way.
typedef _Target = ({
  String name,
  IconData icon,
  String density,
  AstryxPalette palette,
  String note,
});

const List<_Target> _targets = <_Target>[
  (
    name: 'Android',
    icon: LucideIcons.smartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: '48px tap targets, hover suppressed.',
  ),
  (
    name: 'iOS',
    icon: LucideIcons.tabletSmartphone,
    density: 'touch',
    palette: AstryxPalette.blue,
    note: 'The same, and the same tap target.',
  ),
  (
    name: 'macOS',
    icon: LucideIcons.laptop,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Menlo heads the monospace stack.',
  ),
  (
    name: 'Windows',
    icon: LucideIcons.monitor,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Consolas heads the monospace stack.',
  ),
  (
    name: 'Linux',
    icon: LucideIcons.terminal,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'The generic families stand.',
  ),
  (
    name: 'Fuchsia',
    icon: LucideIcons.cpu,
    density: 'pointer',
    palette: AstryxPalette.purple,
    note: 'Resolved, though untested in the wild.',
  ),
  (
    name: 'Web',
    icon: LucideIcons.globe,
    density: 'either',
    palette: AstryxPalette.gray,
    note: 'Pointer precision decides, not the host OS.',
  ),
];

class PlatformTargetsExample extends StatelessWidget {
  const PlatformTargetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final target in _targets)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    // Decorative: the name is right beside it, so announcing
                    // the glyph as well would say everything twice.
                    ExcludeSemantics(
                      child: Icon(
                        target.icon,
                        size: AstryxIconSize.lg.pixels,
                        color: theme.color(AstryxColorToken.iconSecondary),
                      ),
                    ),
                    Flexible(
                      child: AstryxText(
                        target.name,
                        type: AstryxTextType.label,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                AstryxHStack(
                  children: <Widget>[
                    AstryxBadge(
                      target.density,
                      variant: AstryxBadgeVariant.palette(target.palette),
                    ),
                  ],
                ),
                AstryxText(
                  target.note,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end
