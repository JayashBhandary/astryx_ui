import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example empty_state_demo -> EmptyStateDemoExample
class EmptyStateDemoExample extends StatelessWidget {
  const EmptyStateDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxEmptyState(
      icon: const AstryxIcon(AstryxIconName.search),
      title: 'No deploys yet',
      description: 'Push to the main branch and the first one will show here.',
      actions: <Widget>[
        AstryxButton(
          label: 'Read the guide',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Import a project', onPressed: () {}),
      ],
    );
  }
}
// #end

// #example empty_state_sizes -> EmptyStateSizesExample
class EmptyStateSizesExample extends StatelessWidget {
  const EmptyStateSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `compact` is for an empty state inside something — a card, a popover, a
    // table body — where the standard one would push the container open.
    return AstryxGrid(
      minWidth: 240,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxEmptyStateSize.values)
          AstryxCard(
            child: AstryxEmptyState(
              size: size,
              icon: const AstryxIcon(AstryxIconName.funnel),
              title: 'No matches',
              description: size.name,
              actions: <Widget>[
                AstryxButton(
                  label: 'Clear filters',
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end
