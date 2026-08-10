import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example button_demo -> ButtonDemoExample
class ButtonDemoExample extends StatelessWidget {
  const ButtonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Save changes',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Cancel', onPressed: () {}),
      ],
    );
  }
}
// #end

// #example button_variants -> ButtonVariantsExample
class ButtonVariantsExample extends StatelessWidget {
  const ButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        for (final variant in AstryxButtonVariant.values)
          AstryxButton(
            label: variant.name,
            variant: variant,
            onPressed: () {},
          ),
      ],
    );
  }
}
// #end

// #example button_sizes -> ButtonSizesExample
class ButtonSizesExample extends StatelessWidget {
  const ButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxButtonSize.values)
          AstryxButton(label: size.name, size: size, onPressed: () {}),
      ],
    );
  }
}
// #end

// #example button_size_scope -> ButtonSizeScopeExample
class ButtonSizeScopeExample extends StatelessWidget {
  const ButtonSizeScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // One scope sizes everything inside it. Neither button names a size.
    return AstryxSizeScope(
      size: AstryxElementSize.sm,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxButton(label: 'Filter', onPressed: () {}),
          AstryxIconButton(
            icon: AstryxIconName.search,
            label: 'Search',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
// #end

// #example button_icons -> ButtonIconsExample
class ButtonIconsExample extends StatelessWidget {
  const ButtonIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxButton(
          label: 'Search',
          leading: const AstryxIcon(AstryxIconName.search),
          onPressed: () {},
        ),
        AstryxButton(
          label: 'Open docs',
          variant: AstryxButtonVariant.ghost,
          trailing: const AstryxIcon(AstryxIconName.externalLink),
          onPressed: () {},
        ),
        AstryxButton(
          label: 'Inbox',
          trailing: const AstryxBadge(
            '12',
            semanticsLabel: '12 unread',
            variant: AstryxBadgeVariant.info,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end

// #example button_states -> ButtonStatesExample
class ButtonStatesExample extends StatefulWidget {
  const ButtonStatesExample({super.key});

  @override
  State<ButtonStatesExample> createState() => _ButtonStatesExampleState();
}

class _ButtonStatesExampleState extends State<ButtonStatesExample> {
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        // `loading` keeps the callback and the width — the layout cannot jump,
        // and the button reports itself as disabled while the work is in
        // flight.
        AstryxButton(
          label: 'Save',
          variant: AstryxButtonVariant.primary,
          loading: _saving,
          onPressed: _save,
        ),
        const AstryxButton(label: 'Inert'),
        AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
      ],
    );
  }
}
// #end

// #example button_elevation -> ButtonElevationExample
class ButtonElevationExample extends StatelessWidget {
  const ButtonElevationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxButton(
            label: elevation.name,
            elevation: elevation,
            onPressed: () {},
          ),
      ],
    );
  }
}
// #end

// #example button_width -> ButtonWidthExample
class ButtonWidthExample extends StatelessWidget {
  const ButtonWidthExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Continue',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          AstryxButton(label: 'Use a different account', onPressed: () {}),
        ],
      ),
    );
  }
}
// #end
