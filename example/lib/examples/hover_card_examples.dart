import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example hover_card_demo -> HoverCardDemoExample
class HoverCardDemoExample extends StatelessWidget {
  const HoverCardDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Hover the mention. The card stays open while the pointer is on it, so
    // what is inside can be read, selected and pressed.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        const AstryxText('Assigned to'),
        AstryxHoverCard(
          label: 'Ada Lovelace',
          content: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const AstryxHeading(
                'Ada Lovelace',
                type: AstryxHeadingType.display3,
              ),
              const AstryxText(
                'Platform team · Cambridge',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              const AstryxText('Owns the scheduler and the retry engine.'),
              AstryxButton(label: 'View profile', onPressed: () {}),
            ],
          ),
          child: const AstryxText('@ada', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
// #end

// #example hover_card_timing -> HoverCardTimingExample
class HoverCardTimingExample extends StatelessWidget {
  const HoverCardTimingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The wait filters a mouse on its way somewhere else; the exit duration is
    // the grace period for crossing the gap onto the card. Zero exit makes the
    // card unreachable, which is why it is not the default.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing5,
      children: <Widget>[
        AstryxHoverCard(
          waitDuration: Duration.zero,
          content: AstryxText('No wait at all.'),
          child: AstryxText('Instant', color: AstryxTextColor.accent),
        ),
        AstryxHoverCard(
          waitDuration: Duration(milliseconds: 700),
          content: AstryxText('Opens only for a pointer that settles.'),
          child: AstryxText('Patient', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
// #end

// #example hover_card_sides -> HoverCardSidesExample
class HoverCardSidesExample extends StatelessWidget {
  const HoverCardSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Same positioner as every other anchored overlay: the preferred side is a
    // preference, and it flips near an edge.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing5,
      children: <Widget>[
        AstryxHoverCard(
          side: AstryxOverlaySide.top,
          width: 220,
          showArrow: true,
          content: AstryxText('Above, with an arrow.'),
          child: AstryxText('Top', color: AstryxTextColor.accent),
        ),
        AstryxHoverCard(
          side: AstryxOverlaySide.right,
          width: 220,
          content: AstryxText('Beside the trigger.'),
          child: AstryxText('Right', color: AstryxTextColor.accent),
        ),
      ],
    );
  }
}
// #end
