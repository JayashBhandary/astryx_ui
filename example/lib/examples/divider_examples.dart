import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example divider_demo -> DividerDemoExample
class DividerDemoExample extends StatelessWidget {
  const DividerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('Personal details'),
        AstryxDivider(),
        AstryxText('Billing'),
      ],
    );
  }
}
// #end

// #example divider_variants -> DividerVariantsExample
class DividerVariantsExample extends StatelessWidget {
  const DividerVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('subtle', type: AstryxTextType.label),
        AstryxDivider(),
        AstryxText('strong', type: AstryxTextType.label),
        AstryxDivider(variant: AstryxDividerVariant.strong),
      ],
    );
  }
}
// #end

// #example divider_labelled -> DividerLabelledExample
class DividerLabelledExample extends StatelessWidget {
  const DividerLabelledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Continue with email',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          const AstryxDivider(label: 'or'),
          AstryxButton(label: 'Continue with SSO', onPressed: () {}),
        ],
      ),
    );
  }
}
// #end

// #example divider_vertical -> DividerVerticalExample
class DividerVerticalExample extends StatelessWidget {
  const DividerVerticalExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A vertical rule needs a bounded height. `align: stretch` inside a row of
    // known height gives it one; an `IntrinsicHeight` also works.
    return const SizedBox(
      height: 24,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText('Edited 2h ago', type: AstryxTextType.supporting),
          AstryxDivider(axis: Axis.vertical),
          AstryxText('4 collaborators', type: AstryxTextType.supporting),
          AstryxDivider(axis: Axis.vertical),
          AstryxText('Public', type: AstryxTextType.supporting),
        ],
      ),
    );
  }
}
// #end
