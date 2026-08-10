import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example typography_roles -> TypographyRolesExample
class TypographyRolesExample extends StatelessWidget {
  const TypographyRolesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Fourteen roles. Each one is a size, a weight and a line height together —
    // ask for the role and the three cannot come apart.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final role in AstryxTypeRole.values)
          Builder(
            builder: (context) {
              final style = theme.textStyle(role);

              return AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.end,
                children: <Widget>[
                  SizedBox(
                    width: 92,
                    child: AstryxText(
                      role.name,
                      type: AstryxTextType.code,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: 76,
                    child: AstryxText(
                      '${style.fontSize?.round()}px · '
                      '${style.fontWeight?.value}',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'The quick brown fox',
                      style: style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
// #end

// #example typography_in_context -> TypographyInContextExample
class TypographyInContextExample extends StatelessWidget {
  const TypographyInContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The roles doing their jobs. Nothing here names a size: the heading takes
    // a level, everything else takes a type.
    return AstryxCard(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Deployment failed', level: 3),
          const AstryxText(
            'The build finished, but the health check never went green. '
            'Nothing was promoted.',
          ),
          const AstryxText('Exit code', type: AstryxTextType.label),
          const AstryxText('137 — out of memory', type: AstryxTextType.code),
          const AstryxText(
            'Retried twice. Last attempt 4 minutes ago.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(label: 'Retry', onPressed: () {}),
              AstryxButton(
                label: 'View log',
                variant: AstryxButtonVariant.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// #end
