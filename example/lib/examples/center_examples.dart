import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example center_demo -> CenterDemoExample
class CenterDemoExample extends StatelessWidget {
  const CenterDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      minHeight: 200,
      padding: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxIcon(
            AstryxIconName.search,
            size: AstryxIconSize.lg,
            color: AstryxIconColor.secondary,
          ),
          const AstryxHeading('No projects yet', level: 4),
          const AstryxText(
            'Create one to start collecting requests.',
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          AstryxButton(
            label: 'New project',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
// #end

// #example center_axis -> CenterAxisExample
class CenterAxisExample extends StatelessWidget {
  const CenterAxisExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final axis in AstryxCenterAxis.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(axis.name, type: AstryxTextType.label),
              SizedBox(
                height: 72,
                child: AstryxCard(
                  variant: AstryxCardVariant.muted,
                  padding: AstryxSpacingToken.spacing2,
                  child: AstryxCenter(
                    axis: axis,
                    child: const AstryxBadge('content'),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example center_measure -> CenterMeasureExample
class CenterMeasureExample extends StatelessWidget {
  const CenterMeasureExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `maxWidth` is what keeps a centred column of prose readable on a wide
    // display: the box centres, the measure stays put.
    return const AstryxCenter(
      maxWidth: 360,
      paddingBlock: AstryxSpacingToken.spacing4,
      child: AstryxText(
        'A line length of roughly sixty to seventy characters is comfortable '
        'to read. A centring box with no ceiling on its width gives you the '
        'window instead, which is not the same thing.',
        justify: AstryxTextJustify.center,
      ),
    );
  }
}
// #end
