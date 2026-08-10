import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example spacing_gap -> SpacingGapExample
class SpacingGapExample extends StatelessWidget {
  const SpacingGapExample({super.key});

  /// Three steps of the scale, applied to the same layout.
  static const List<AstryxSpacingToken> _steps = <AstryxSpacingToken>[
    AstryxSpacingToken.spacing1,
    AstryxSpacingToken.spacing3,
    AstryxSpacingToken.spacing6,
  ];

  @override
  Widget build(BuildContext context) {
    // One token drives the padding *and* the gap, which is what keeps the
    // rhythm of a screen consistent — two numbers cannot drift apart.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final step in _steps)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(step.name, type: AstryxTextType.code),
              AstryxCard(
                padding: step,
                child: AstryxHStack(
                  gap: step,
                  wrap: true,
                  runGap: step,
                  children: const <Widget>[
                    AstryxBadge('build'),
                    AstryxBadge('test'),
                    AstryxBadge('deploy'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end
