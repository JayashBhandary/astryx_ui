import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example motion_durations -> MotionDurationsExample
class MotionDurationsExample extends StatefulWidget {
  const MotionDurationsExample({super.key});

  @override
  State<MotionDurationsExample> createState() => _MotionDurationsExampleState();
}

class _MotionDurationsExampleState extends State<MotionDurationsExample> {
  /// The three bases. Each has a `-min` and a `-max` variant beside it.
  static const List<AstryxDurationToken> _bases = <AstryxDurationToken>[
    AstryxDurationToken.fast,
    AstryxDurationToken.medium,
    AstryxDurationToken.slow,
  ];

  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Durations come from `AstryxMotion`, never from the theme directly: it is
    // the layer that returns zero when the platform asks for reduced motion.
    final motion = AstryxMotion.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final token in _bases)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(
                '${token.name} · ${motion.duration(token).inMilliseconds}ms',
                type: AstryxTextType.code,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundMuted),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                ),
                child: SizedBox(
                  height: 28,
                  child: AnimatedAlign(
                    duration: motion.duration(token),
                    curve: motion.curve(),
                    alignment: _moved
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing(AstryxSpacingToken.spacing1),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color(AstryxColorToken.accent),
                          borderRadius: theme.borderRadius(
                            AstryxRadiusToken.full,
                          ),
                        ),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: _moved ? 'Send back' : 'Send across',
              onPressed: () => setState(() => _moved = !_moved),
            ),
          ],
        ),
      ],
    );
  }
}
// #end
