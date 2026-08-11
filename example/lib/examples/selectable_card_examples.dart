import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example selectable_card_demo -> SelectableCardDemoExample
class SelectableCardDemoExample extends StatefulWidget {
  const SelectableCardDemoExample({super.key});

  @override
  State<SelectableCardDemoExample> createState() =>
      _SelectableCardDemoExampleState();
}

class _SelectableCardDemoExampleState extends State<SelectableCardDemoExample> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    // One choice out of three, where each option carries a price and a line of
    // detail — more than a radio row can hold, which is the whole reason to
    // reach for a card here.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final plan in const <List<String>>[
          <String>['starter', 'Starter', r'$0', 'One project, one seat'],
          <String>['pro', 'Pro', r'$20', 'Unlimited projects, five seats'],
          <String>['scale', 'Scale', r'$80', 'Unlimited seats, SSO, audit log'],
        ])
          AstryxSelectableCard(
            label: '${plan[1]} plan',
            semanticsHint: '${plan[2]} per month. ${plan[3]}',
            control: AstryxSelectableCardControl.radio,
            selected: _plan == plan[0],
            onSelectedChanged: (_) => setState(() => _plan = plan[0]),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHStack(
                  justify: AstryxStackJustify.between,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: AstryxText(plan[1], type: AstryxTextType.large),
                    ),
                    AstryxText('${plan[2]}/mo'),
                  ],
                ),
                AstryxText(
                  plan[3],
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end

// #example selectable_card_controls -> SelectableCardControlsExample
class SelectableCardControlsExample extends StatefulWidget {
  const SelectableCardControlsExample({super.key});

  @override
  State<SelectableCardControlsExample> createState() =>
      _SelectableCardControlsExampleState();
}

class _SelectableCardControlsExampleState
    extends State<SelectableCardControlsExample> {
  final Set<String> _regions = <String>{'iad'};

  @override
  Widget build(BuildContext context) {
    // A checkbox card is an independent choice, so any number of these can be
    // on at once — the same distinction as `AstryxCheckbox` against
    // `AstryxRadioList`, moved onto a card.
    return AstryxGrid(
      minWidth: 200,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final region in const <List<String>>[
          <String>['iad', 'us-east', '12 ms'],
          <String>['fra', 'eu-central', '86 ms'],
          <String>['bom', 'ap-south', '148 ms'],
        ])
          AstryxSelectableCard(
            label: '${region[1]} region',
            selected: _regions.contains(region[0]),
            onSelectedChanged: (selected) => setState(() {
              if (selected) {
                _regions.add(region[0]);
              } else {
                _regions.remove(region[0]);
              }
            }),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(region[1]),
                AstryxText(
                  '${region[2]} from here',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// #end

// #example selectable_card_states -> SelectableCardStatesExample
class SelectableCardStatesExample extends StatelessWidget {
  const SelectableCardStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The three ways a card stops being an ordinary control, side by side. Note
    // that the last two still fill the box: a card the user cannot change is
    // still visibly the selected one, even though the accent border and the
    // tint — which read as an affordance — are gone.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSelectableCard(
          label: 'Selected',
          selected: true,
          onSelectedChanged: (_) {},
          child: const AstryxText('Selected, and yours to change'),
        ),
        const AstryxSelectableCard(
          label: 'Shown elsewhere',
          selected: true,
          child: AstryxText('A null callback: inert, but not dimmed'),
        ),
        AstryxSelectableCard(
          label: 'Unavailable',
          selected: true,
          enabled: false,
          onSelectedChanged: (_) {},
          child: const AstryxText('Disabled: dimmed, and skipped by Tab'),
        ),
      ],
    );
  }
}
// #end

// #example selectable_card_compact -> SelectableCardCompactExample
class SelectableCardCompactExample extends StatefulWidget {
  const SelectableCardCompactExample({super.key});

  @override
  State<SelectableCardCompactExample> createState() =>
      _SelectableCardCompactExampleState();
}

class _SelectableCardCompactExampleState
    extends State<SelectableCardCompactExample> {
  String _speed = 'balanced';

  @override
  Widget build(BuildContext context) {
    // `controlSize` sizes the control, not the card. At `sm`, with the padding
    // one step down, a card holding a single line stops being mostly box.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final speed in const <String>['fast', 'balanced', 'thorough'])
          AstryxSelectableCard(
            label: speed,
            control: AstryxSelectableCardControl.radio,
            controlSize: AstryxToggleSize.sm,
            padding: AstryxSpacingToken.spacing3,
            selected: _speed == speed,
            onSelectedChanged: (_) => setState(() => _speed = speed),
            child: AstryxText(speed),
          ),
      ],
    );
  }
}
// #end
