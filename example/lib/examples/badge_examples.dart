import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example badge_demo -> BadgeDemoExample
class BadgeDemoExample extends StatelessWidget {
  const BadgeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxText('atlas-api'),
        AstryxBadge('Healthy', variant: AstryxBadgeVariant.success),
      ],
    );
  }
}
// #end

// #example badge_variants -> BadgeVariantsExample
class BadgeVariantsExample extends StatelessWidget {
  const BadgeVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge('neutral'),
        AstryxBadge('info', variant: AstryxBadgeVariant.info),
        AstryxBadge('success', variant: AstryxBadgeVariant.success),
        AstryxBadge('warning', variant: AstryxBadgeVariant.warning),
        AstryxBadge('error', variant: AstryxBadgeVariant.error),
      ],
    );
  }
}
// #end

// #example badge_palettes -> BadgePalettesExample
class BadgePalettesExample extends StatelessWidget {
  const BadgePalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxBadge(
            palette.name,
            variant: AstryxBadgeVariant.palette(palette),
          ),
      ],
    );
  }
}
// #end

// #example badge_icons -> BadgeIconsExample
class BadgeIconsExample extends StatelessWidget {
  const BadgeIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge(
          'Deployed',
          icon: AstryxIcon(AstryxIconName.check),
          variant: AstryxBadgeVariant.success,
        ),
        AstryxBadge(
          'Degraded',
          icon: AstryxIcon(AstryxIconName.warning),
          variant: AstryxBadgeVariant.warning,
        ),
        AstryxBadge(
          'Queued',
          icon: AstryxIcon(AstryxIconName.clock),
        ),
      ],
    );
  }
}
// #end

// #example badge_counts -> BadgeCountsExample
class BadgeCountsExample extends StatelessWidget {
  const BadgeCountsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // "3" spoken aloud means nothing. `semanticsLabel` is what a screen reader
    // hears instead of the bare number.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxBadge('3', semanticsLabel: '3 unread messages'),
        AstryxBadge(
          '12',
          semanticsLabel: '12 failing checks',
          variant: AstryxBadgeVariant.error,
        ),
        AstryxBadge(
          '99+',
          semanticsLabel: 'More than 99 notifications',
          variant: AstryxBadgeVariant.info,
        ),
      ],
    );
  }
}
// #end
