import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example heading_demo -> HeadingDemoExample
class HeadingDemoExample extends StatelessWidget {
  const HeadingDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading('Workspace settings'),
        AstryxText(
          'Who can join, and what they can do once they have.',
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example heading_levels -> HeadingLevelsExample
class HeadingLevelsExample extends StatelessWidget {
  const HeadingLevelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading('level 1', level: 1),
        AstryxHeading('level 2 — the default'),
        AstryxHeading('level 3', level: 3),
        AstryxHeading('level 4', level: 4),
        AstryxHeading('level 5', level: 5),
        AstryxHeading('level 6', level: 6),
      ],
    );
  }
}
// #end

// #example heading_display -> HeadingDisplayExample
class HeadingDisplayExample extends StatelessWidget {
  const HeadingDisplayExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `type` changes the size only. The announced level stays `level`, so a
    // hero heading can look enormous and still be the page's h1.
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading(
          'display1',
          level: 1,
          type: AstryxHeadingType.display1,
        ),
        AstryxHeading('display2', type: AstryxHeadingType.display2),
        AstryxHeading('display3', type: AstryxHeadingType.display3),
      ],
    );
  }
}
// #end

// #example heading_accessibility_level -> HeadingAccessibilityLevelExample
class HeadingAccessibilityLevelExample extends StatelessWidget {
  const HeadingAccessibilityLevelExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Looks like an h4, announced as an h2 — for a card title that sits second
    // in the document outline but should not shout. Prefer fixing the design.
    return const AstryxHeading(
      'Recent activity',
      level: 4,
      accessibilityLevel: 2,
    );
  }
}
// #end
