import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example elevation_shadows -> ElevationShadowsExample
class ElevationShadowsExample extends StatelessWidget {
  const ElevationShadowsExample({super.key});

  /// The three drop shadows, and what sits at each.
  static const List<(AstryxShadowToken, String)> _steps =
      <(AstryxShadowToken, String)>[
        (AstryxShadowToken.low, 'popover, tooltip, menu'),
        (AstryxShadowToken.med, 'toast, selector list'),
        (AstryxShadowToken.high, 'dialog'),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        for (final (token, uses) in _steps)
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundPopover),
              borderRadius: theme.borderRadius(AstryxRadiusToken.container),
              boxShadow: theme.boxShadows(token),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing4),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(token.name, type: AstryxTextType.label),
                  AstryxText(
                    uses,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
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

// #example elevation_button -> ElevationButtonExample
class ElevationButtonExample extends StatelessWidget {
  const ElevationButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The one component that takes an elevation directly. Everything else
    // decides its own from what it is.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxButton(
            label: elevation.name,
            variant: AstryxButtonVariant.secondary,
            elevation: elevation,
            onPressed: () {},
          ),
      ],
    );
  }
}
// #end
