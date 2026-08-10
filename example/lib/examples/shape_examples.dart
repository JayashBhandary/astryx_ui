import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example shape_scale -> ShapeScaleExample
class ShapeScaleExample extends StatelessWidget {
  const ShapeScaleExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxGrid(
      minWidth: 130,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final token in AstryxRadiusToken.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundMuted),
                  borderRadius: theme.borderRadius(token),
                  border: Border.all(
                    color: theme.color(AstryxColorToken.border),
                  ),
                ),
                child: const SizedBox(height: 56),
              ),
              AstryxText(
                '${token.name} · ${theme.radius(token).round()}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example shape_nesting -> ShapeNestingExample
class ShapeNestingExample extends StatelessWidget {
  const ShapeNestingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Three steps of the scale, nested in the order they are meant to nest:
    // container outside, element inside it, inner innermost. Each step is one
    // notch tighter than the one around it, so the curves stay concentric.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxText('container · card', type: AstryxTextType.label),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(AstryxColorToken.backgroundMuted),
              borderRadius: theme.borderRadius(AstryxRadiusToken.element),
              border: Border.all(color: theme.color(AstryxColorToken.border)),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxText(
                    'element · button, input',
                    type: AstryxTextType.supporting,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.color(AstryxColorToken.backgroundCard),
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.inner,
                      ),
                      border: Border.all(
                        color: theme.color(AstryxColorToken.border),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        theme.spacing(AstryxSpacingToken.spacing2),
                      ),
                      child: const AstryxText(
                        'inner · a chip inside it',
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// #end
