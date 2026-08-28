import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example indicator_demo -> IndicatorDemoExample
class IndicatorDemoExample extends StatelessWidget {
  const IndicatorDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The three visuals, on their own. Each is decoration: it owns no role, no
    // focus and no gesture, and the control that renders one keeps all of
    // that. Reach for AstryxCheckbox or AstryxRadioList first.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxCheckboxIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Checkbox', type: AstryxTextType.supporting),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxRadioIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Radio', type: AstryxTextType.supporting),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.center,
          children: <Widget>[
            AstryxCheckIndicator(state: AstryxIndicatorState.checked),
            AstryxText('Check', type: AstryxTextType.supporting),
          ],
        ),
      ],
    );
  }
}
// #end

// #example indicator_states -> IndicatorStatesExample
class IndicatorStatesExample extends StatelessWidget {
  const IndicatorStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A checkbox has three states; a radio and a check have two. The partial
    // state is a bar rather than a half-tick, because a tick at any weight
    // says "all of these".
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final state in AstryxIndicatorState.values)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxCheckboxIndicator(state: state),
              if (state != AstryxIndicatorState.indeterminate) ...<Widget>[
                AstryxRadioIndicator(state: state),
                AstryxCheckIndicator(state: state),
              ],
              AstryxText(state.name, type: AstryxTextType.supporting),
            ],
          ),
      ],
    );
  }
}
// #end

// #example indicator_row -> IndicatorRowExample
class IndicatorRowExample extends StatefulWidget {
  const IndicatorRowExample({super.key});

  @override
  State<IndicatorRowExample> createState() => _IndicatorRowExampleState();
}

class _IndicatorRowExampleState extends State<IndicatorRowExample> {
  final Set<String> _visible = <String>{'Roads', 'Labels'};

  @override
  Widget build(BuildContext context) {
    // What an indicator is for: a row this package has no widget for — here a
    // layer list — that has to draw the *same* box as a real checkbox rather
    // than an approximation of one. The row keeps the semantics and the
    // gesture; the indicator only turns state into a picture.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final layer in const <String>['Roads', 'Labels', 'Terrain'])
          AstryxItem(
            label: layer,
            leading: AstryxCheckboxIndicator(
              state: _visible.contains(layer)
                  ? AstryxIndicatorState.checked
                  : AstryxIndicatorState.unchecked,
              size: AstryxIndicatorSize.sm,
            ),
            onPressed: () => setState(() {
              _visible.contains(layer)
                  ? _visible.remove(layer)
                  : _visible.add(layer);
            }),
          ),
      ],
    );
  }
}
// #end
