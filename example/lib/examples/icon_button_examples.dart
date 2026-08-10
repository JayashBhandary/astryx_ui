import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example icon_button_demo -> IconButtonDemoExample
class IconButtonDemoExample extends StatelessWidget {
  const IconButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.search,
          label: 'Search',
          tooltip: 'Search',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.funnel,
          label: 'Filter',
          tooltip: 'Filter',
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.moreHorizontal,
          label: 'More actions',
          variant: AstryxButtonVariant.ghost,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end

// #example icon_button_variants -> IconButtonVariantsExample
class IconButtonVariantsExample extends StatelessWidget {
  const IconButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        for (final variant in AstryxButtonVariant.values)
          AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Approve (${variant.name})',
            variant: variant,
            onPressed: () {},
          ),
      ],
    );
  }
}
// #end

// #example icon_button_sizes -> IconButtonSizesExample
class IconButtonSizesExample extends StatelessWidget {
  const IconButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxButtonSize.values)
          AstryxIconButton(
            icon: AstryxIconName.copy,
            label: 'Copy (${size.name})',
            size: size,
            onPressed: () {},
          ),
      ],
    );
  }
}
// #end

// #example icon_button_custom -> IconButtonCustomExample
class IconButtonCustomExample extends StatelessWidget {
  const IconButtonCustomExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // `.custom` takes any widget — an avatar, a flag, a brand glyph. The
    // registry covers 28 semantic names; an application always needs more.
    return AstryxIconButton.custom(
      label: 'Ada Lovelace — account menu',
      variant: AstryxButtonVariant.ghost,
      onPressed: () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.color(AstryxColorToken.backgroundPurple),
          borderRadius: theme.borderRadius(AstryxRadiusToken.full),
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: AstryxText(
              'AL',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.inherit,
            ),
          ),
        ),
      ),
    );
  }
}
// #end

// #example icon_button_states -> IconButtonStatesExample
class IconButtonStatesExample extends StatelessWidget {
  const IconButtonStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.stop,
          label: 'Stop the run',
          loading: true,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.eyeSlash,
          label: 'Hide column',
          enabled: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end
