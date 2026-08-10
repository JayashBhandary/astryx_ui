import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example spinner_demo -> SpinnerDemoExample
class SpinnerDemoExample extends StatelessWidget {
  const SpinnerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxSpinner(label: 'Loading projects'),
        AstryxText('Loading projects…', color: AstryxTextColor.secondary),
      ],
    );
  }
}
// #end

// #example spinner_sizes -> SpinnerSizesExample
class SpinnerSizesExample extends StatelessWidget {
  const SpinnerSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final size in AstryxSpinnerSize.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxSpinner(size: size, label: 'Loading'),
              AstryxText(
                '${size.name} · ${size.diameter.toInt()}px',
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

// #example spinner_shades -> SpinnerShadesExample
class SpinnerShadesExample extends StatelessWidget {
  const SpinnerShadesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final shade in AstryxSpinnerShade.values)
          // `onMedia` only reads on an inverted surface, so it gets one.
          ColoredBox(
            color: shade == AstryxSpinnerShade.onMedia
                ? theme.color(AstryxColorToken.backgroundInverted)
                : const Color(0x00000000),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing2),
              ),
              child: AstryxSpinner(shade: shade, label: 'Loading'),
            ),
          ),
      ],
    );
  }
}
// #end

// #example spinner_in_button -> SpinnerInButtonExample
class SpinnerInButtonExample extends StatelessWidget {
  const SpinnerInButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A button's `loading` flag installs the spinner for you, at the size and
    // colour of the icon it replaces. This is the shape to reach for first.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Deploying',
          variant: AstryxButtonVariant.primary,
          loading: true,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Copying',
          loading: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end
