import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example skeleton_demo -> SkeletonDemoExample
class SkeletonDemoExample extends StatelessWidget {
  const SkeletonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSkeleton.text(),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.6),
        ],
      ),
    );
  }
}
// #end

// #example skeleton_shapes -> SkeletonShapesExample
class SkeletonShapesExample extends StatelessWidget {
  const SkeletonShapesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSkeleton.circle(size: 40),
        SizedBox(width: 120, child: AstryxSkeleton.text()),
        AstryxSkeleton(width: 96, height: 32),
      ],
    );
  }
}
// #end

// #example skeleton_card -> SkeletonCardExample
class SkeletonCardExample extends StatelessWidget {
  const SkeletonCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A placeholder is worth having only when it has the shape of what
    // arrives. Match the real card's slots, not a generic grey box.
    return const AstryxCard(
      maxWidth: 360,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxSkeleton.circle(size: 40),
              Expanded(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxSkeleton.text(widthFactor: 0.5),
                    AstryxSkeleton.text(widthFactor: 0.3, height: 12),
                  ],
                ),
              ),
            ],
          ),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.8),
          AstryxSkeleton(height: 32, radius: AstryxRadiusToken.element),
        ],
      ),
    );
  }
}
// #end

// #example skeleton_delay -> SkeletonDelayExample
class SkeletonDelayExample extends StatefulWidget {
  const SkeletonDelayExample({super.key});

  @override
  State<SkeletonDelayExample> createState() => _SkeletonDelayExampleState();
}

class _SkeletonDelayExampleState extends State<SkeletonDelayExample> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    // The block appears at once; only the pulse waits. Content that arrives
    // quickly should not flash an animation on its way past.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 280,
          child: AstryxVStack(
            key: ValueKey<int>(_run),
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: const <Widget>[
              AstryxSkeleton.text(delay: Duration.zero),
              AstryxSkeleton.text(delay: Duration(milliseconds: 600)),
              AstryxSkeleton.text(delay: Duration(seconds: 1)),
            ],
          ),
        ),
        AstryxButton(
          label: 'Restart',
          size: AstryxButtonSize.sm,
          onPressed: () => setState(() => _run++),
        ),
      ],
    );
  }
}
// #end
