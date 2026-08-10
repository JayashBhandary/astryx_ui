import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// #example icons_registry_swap -> IconsRegistrySwapExample
class IconsRegistrySwapExample extends StatelessWidget {
  const IconsRegistrySwapExample({super.key});

  /// Built from the defaults, so the 25 names not listed still resolve.
  static final AstryxIconRegistry _custom = AstryxIconRegistry.defaults
      .copyWith(const <AstryxIconName, IconData>{
        AstryxIconName.close: LucideIcons.circleX,
        AstryxIconName.check: LucideIcons.badgeCheck,
        AstryxIconName.chevronRight: LucideIcons.arrowRight,
      });

  static const List<AstryxIconName> _shown = <AstryxIconName>[
    AstryxIconName.close,
    AstryxIconName.check,
    AstryxIconName.chevronRight,
  ];

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 220,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (title, registry) in <(String, AstryxIconRegistry)>[
          ('AstryxIconRegistry.defaults', AstryxIconRegistry.defaults),
          ('defaults.copyWith(…)', _custom),
        ])
          // `AstryxTheme` rather than a nested provider: this swaps the
          // registry and inherits everything else, so the theme and density
          // pickers above still reach the icons below.
          AstryxTheme(
            data: AstryxTheme.of(context),
            density: AstryxTheme.densityOf(context),
            icons: registry,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(
                    title,
                    type: AstryxTextType.code,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing4,
                    children: <Widget>[
                      for (final name in _shown)
                        AstryxIcon(name, size: AstryxIconSize.lg),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example icons_mirroring -> IconsMirroringExample
class IconsMirroringExample extends StatelessWidget {
  const IconsMirroringExample({super.key});

  /// Two that mirror, and two that deliberately do not.
  static const List<(AstryxIconName, String)> _cases =
      <(AstryxIconName, String)>[
        (AstryxIconName.chevronRight, 'mirrors'),
        (AstryxIconName.externalLink, 'mirrors'),
        (AstryxIconName.arrowUp, 'block axis — never flips'),
        (AstryxIconName.clock, 'an object — never flips'),
      ];

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final (name, note) in _cases)
          AstryxCard(
            padding: AstryxSpacingToken.spacing3,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(name.name, type: AstryxTextType.code, maxLines: 1),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing4,
                  children: <Widget>[
                    for (final direction in TextDirection.values)
                      AstryxHStack(
                        gap: AstryxSpacingToken.spacing1,
                        children: <Widget>[
                          AstryxText(
                            direction.name,
                            type: AstryxTextType.supporting,
                            color: AstryxTextColor.secondary,
                          ),
                          Directionality(
                            textDirection: direction,
                            child: AstryxIcon(name),
                          ),
                        ],
                      ),
                  ],
                ),
                AstryxText(
                  note,
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
