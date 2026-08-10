import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example layout_page -> LayoutPageExample
class LayoutPageExample extends StatelessWidget {
  const LayoutPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A screen is a measure, a column of sections, and a grid inside one of
    // them. There is no page widget to learn: the same four layout primitives
    // that build a card build the page around it.
    return AstryxCenter(
      axis: AstryxCenterAxis.horizontal,
      maxWidth: 760,
      paddingBlock: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing6,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            mainAxisSize: MainAxisSize.max,
            justify: AstryxStackJustify.between,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              const Flexible(
                child: AstryxHeading('Environments', level: 1),
              ),
              AstryxButton(
                label: 'New environment',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
            ],
          ),
          const AstryxDivider(),
          AstryxGrid(
            minWidth: 200,
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              for (final (name, status) in const <(String, String)>[
                ('production', 'healthy'),
                ('staging', 'degraded'),
                ('preview', 'healthy'),
              ])
                AstryxCard(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[
                      AstryxText(name, type: AstryxTextType.label),
                      AstryxBadge(
                        status,
                        variant: status == 'healthy'
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.warning,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
// #end
