import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example icon_demo -> IconDemoExample
class IconDemoExample extends StatelessWidget {
  const IconDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success),
        AstryxText('Deployment finished'),
      ],
    );
  }
}
// #end

// #example icon_sizes -> IconSizesExample
class IconSizesExample extends StatelessWidget {
  const IconSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxIconSize.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxIcon(AstryxIconName.calendar, size: size),
              AstryxText(
                '${size.name} · ${size.pixels.toInt()}px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example icon_colors -> IconColorsExample
class IconColorsExample extends StatelessWidget {
  const IconColorsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final color in AstryxIconColor.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxIcon(AstryxIconName.info, color: color),
              AstryxText(color.name, type: AstryxTextType.supporting),
            ],
          ),
      ],
    );
  }
}
// #end

// #example icon_registry -> IconRegistryExample
class IconRegistryExample extends StatelessWidget {
  const IconRegistryExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every semantic name the default registry knows. A theme can swap the
    // glyphs behind these names without a single call site changing.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final name in AstryxIconName.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxIcon(name, size: AstryxIconSize.sm),
              Flexible(
                child: AstryxText(
                  name.name,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example icon_labelled -> IconLabelledExample
class IconLabelledExample extends StatelessWidget {
  const IconLabelledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // Decorative: no label, so assistive technology skips it entirely.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxIcon(AstryxIconName.clock),
            AstryxText('Pending review'),
          ],
        ),
        // Meaningful on its own: it needs a name, because nothing else in the
        // row says what it means.
        AstryxIcon(
          AstryxIconName.warning,
          color: AstryxIconColor.warning,
          label: 'Quota nearly reached',
        ),
      ],
    );
  }
}
// #end
