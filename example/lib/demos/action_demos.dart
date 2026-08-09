import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/widgets.dart';

/// `AstryxButton` — the full variant × size matrix, plus every state.
abstract final class ButtonDemo {
  static Widget build(BuildContext context) => const _ButtonDemo();
}

class _ButtonDemo extends StatefulWidget {
  const _ButtonDemo();

  @override
  State<_ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<_ButtonDemo> {
  int _presses = 0;
  bool _loading = false;

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Variants × sizes',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (final variant in AstryxButtonVariant.values)
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  for (final size in AstryxButtonSize.values)
                    AstryxButton(
                      label: '${variant.name} ${size.name}',
                      variant: variant,
                      size: size,
                      onPressed: () => setState(() => _presses++),
                    ),
                ],
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'States',
        child: AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing2,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: 'Enabled',
              onPressed: () => setState(() => _presses++),
            ),
            AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
            const AstryxButton(label: 'No callback'),
            AstryxButton(
              label: _loading ? 'Loading' : 'Toggle loading',
              loading: _loading,
              onPressed: () => setState(() => _loading = !_loading),
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Leading, trailing and elevation',
        child: AstryxHStack(
          wrap: true,
          gap: AstryxSpacingToken.spacing2,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: 'Confirm',
              leading: const AstryxIcon(AstryxIconName.check),
              onPressed: () {},
            ),
            AstryxButton(
              label: 'Options',
              trailing: const AstryxIcon(AstryxIconName.chevronDown),
              onPressed: () {},
            ),
            for (final elevation in AstryxElevation.values)
              AstryxButton(
                label: elevation.name,
                elevation: elevation,
                onPressed: () {},
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'Keyboard and focus',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            const AstryxText(
              'Tab to a button and the focus ring appears. Click one and it '
              'does not — that is :focus-visible. Enter and Space both '
              'activate.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'First',
                  onPressed: () => setState(() => _presses++),
                ),
                AstryxButton(
                  label: 'Second',
                  onPressed: () => setState(() => _presses++),
                ),
                AstryxButton(
                  label: 'Third',
                  onPressed: () => setState(() => _presses++),
                ),
              ],
            ),
            AstryxText(
              'Presses: $_presses',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxIconButton`.
abstract final class IconButtonDemo {
  static Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Variants × sizes',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (final variant in AstryxButtonVariant.values)
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  for (final size in AstryxButtonSize.values)
                    AstryxIconButton(
                      icon: AstryxIconName.close,
                      label: 'Close',
                      variant: variant,
                      size: size,
                      onPressed: () {},
                    ),
                ],
              ),
          ],
        ),
      ),
      const DemoSection(
        title: 'States',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxIconButton(icon: AstryxIconName.check, label: 'Confirm'),
            AstryxIconButton(
              icon: AstryxIconName.check,
              label: 'Disabled',
              enabled: false,
            ),
            AstryxIconButton(
              icon: AstryxIconName.check,
              label: 'Loading',
              loading: true,
            ),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxButtonGroup`.
abstract final class ButtonGroupDemo {
  static Widget build(BuildContext context) => const _ButtonGroupDemo();
}

class _ButtonGroupDemo extends StatefulWidget {
  const _ButtonGroupDemo();

  @override
  State<_ButtonGroupDemo> createState() => _ButtonGroupDemoState();
}

class _ButtonGroupDemoState extends State<_ButtonGroupDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Joined — set the direction picker to RTL to see it flip',
        child: AstryxHStack(
          children: <Widget>[
            AstryxButtonGroup(
              children: <Widget>[
                for (final (index, label) in <String>[
                  'Day',
                  'Week',
                  'Month',
                ].indexed)
                  AstryxButton(
                    label: label,
                    variant: _selected == index
                        ? AstryxButtonVariant.primary
                        : AstryxButtonVariant.secondary,
                    onPressed: () => setState(() => _selected = index),
                  ),
              ],
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Cascading size and variant',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (final size in AstryxButtonSize.values)
              AstryxButtonGroup(
                size: size,
                variant: AstryxButtonVariant.secondary,
                children: <Widget>[
                  AstryxButton(label: 'One', onPressed: () {}),
                  AstryxButton(label: 'Two', onPressed: () {}),
                  AstryxButton(label: 'Three', onPressed: () {}),
                ],
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'Icon buttons, and a vertical group',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.start,
          children: <Widget>[
            AstryxButtonGroup(
              children: <Widget>[
                AstryxIconButton(
                  icon: AstryxIconName.arrowUp,
                  label: 'Sort ascending',
                  onPressed: () {},
                ),
                AstryxIconButton(
                  icon: AstryxIconName.arrowDown,
                  label: 'Sort descending',
                  onPressed: () {},
                ),
                AstryxIconButton(
                  icon: AstryxIconName.arrowsUpDown,
                  label: 'Clear sort',
                  onPressed: () {},
                ),
              ],
            ),
            AstryxButtonGroup(
              axis: Axis.vertical,
              children: <Widget>[
                AstryxButton(label: 'Top', onPressed: () {}),
                AstryxButton(label: 'Middle', onPressed: () {}),
                AstryxButton(label: 'Bottom', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Detached',
        child: AstryxHStack(
          children: <Widget>[
            AstryxButtonGroup(
              attached: false,
              children: <Widget>[
                AstryxButton(label: 'Cancel', onPressed: () {}),
                AstryxButton(
                  label: 'Save',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
