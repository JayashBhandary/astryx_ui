/// The examples for the form layout, the input group, the slider and the two
/// further selectors.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example form_layout_directions -> FormLayoutDirectionsExample
class FormLayoutDirectionsExample extends StatelessWidget {
  const FormLayoutDirectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three arrangements of the same two fields. Nesting works: the horizontal
    // pair below is a row of fields inside a column of them.
    return AstryxFormLayout(
      children: <Widget>[
        AstryxTextInput(label: 'Project name', onChanged: (_) {}),
        AstryxFormLayout(
          direction: AstryxFormLayoutDirection.horizontal,
          children: <Widget>[
            AstryxTextInput(label: 'Region', onChanged: (_) {}),
            AstryxTextInput(label: 'Owner', onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}
// #end

// #example form_layout_labels -> FormLayoutLabelsExample
class FormLayoutLabelsExample extends StatelessWidget {
  const FormLayoutLabelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every field below moves its label beside its control, and puts it back
    // above when the form is narrower than 480 logical pixels. Switch the
    // preview to a phone and watch it collapse.
    return AstryxFormLayout(
      direction: AstryxFormLayoutDirection.horizontalLabels,
      labelWidth: 140,
      children: <Widget>[
        AstryxTextInput(label: 'Display name', onChanged: (_) {}),
        AstryxTextInput(
          label: 'Contact email',
          description: 'Only used for alerts.',
          onChanged: (_) {},
        ),
        AstryxSwitch(label: 'Public profile', value: true, onChanged: (_) {}),
      ],
    );
  }
}
// #end

// #example input_group_demo -> InputGroupDemoExample
class InputGroupDemoExample extends StatelessWidget {
  const InputGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three children, one border. The affixes size to their text; the field in
    // the middle takes what is left.
    return AstryxInputGroup(
      label: 'Project URL',
      description: 'Lower case, no spaces.',
      children: <Widget>[
        const AstryxInputGroupText('https://'),
        Expanded(
          child: AstryxTextInput(
            label: 'Project URL',
            labelHidden: true,
            placeholder: 'my-project',
            onChanged: (_) {},
          ),
        ),
        const AstryxInputGroupText('.example.com'),
      ],
    );
  }
}
// #end

// #example input_group_status -> InputGroupStatusExample
class InputGroupStatusExample extends StatelessWidget {
  const InputGroupStatusExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The status belongs to the group, so the whole joined border carries it
    // rather than one child of it turning red on its own.
    return AstryxInputGroup(
      label: 'Amount',
      status: const AstryxFieldStatus.error('Enter an amount above zero.'),
      children: <Widget>[
        const AstryxInputGroupText(r'$'),
        Expanded(
          child: AstryxTextInput(
            label: 'Amount',
            labelHidden: true,
            placeholder: '0.00',
            onChanged: (_) {},
          ),
        ),
        const AstryxInputGroupText('USD'),
      ],
    );
  }
}
// #end

// #example slider_demo -> SliderDemoExample
class SliderDemoExample extends StatefulWidget {
  const SliderDemoExample({super.key});

  @override
  State<SliderDemoExample> createState() => _SliderDemoExampleState();
}

class _SliderDemoExampleState extends State<SliderDemoExample> {
  num _threshold = 40;

  @override
  Widget build(BuildContext context) {
    return AstryxSlider(
      label: 'Alert threshold',
      description: 'Warn when usage passes this share of the quota.',
      value: _threshold,
      step: 5,
      marks: const <AstryxSliderMark>[
        AstryxSliderMark(0),
        AstryxSliderMark(50),
        AstryxSliderMark(100),
      ],
      formatValue: (value) => '$value%',
      valueDisplay: AstryxSliderValueDisplay.text,
      onChanged: (value) => setState(() => _threshold = value),
    );
  }
}
// #end

// #example slider_range -> SliderRangeExample
class SliderRangeExample extends StatefulWidget {
  const SliderRangeExample({super.key});

  @override
  State<SliderRangeExample> createState() => _SliderRangeExampleState();
}

class _SliderRangeExampleState extends State<SliderRangeExample> {
  (num, num) _band = (20, 60);

  @override
  Widget build(BuildContext context) {
    // Two thumbs that cannot cross, and cannot come closer than two steps.
    // Each is its own tab stop and its own announced control.
    return AstryxSlider.range(
      label: 'Acceptable latency',
      values: _band,
      max: 200,
      step: 10,
      minStepsBetweenThumbs: 2,
      formatValue: (value) => '${value}ms',
      valueDisplay: AstryxSliderValueDisplay.text,
      onChanged: (values) => setState(() => _band = values),
    );
  }
}
// #end

// #example multi_selector_demo -> MultiSelectorDemoExample
class MultiSelectorDemoExample extends StatefulWidget {
  const MultiSelectorDemoExample({super.key});

  @override
  State<MultiSelectorDemoExample> createState() =>
      _MultiSelectorDemoExampleState();
}

class _MultiSelectorDemoExampleState extends State<MultiSelectorDemoExample> {
  Set<String> _reviewers = <String>{'ada'};

  @override
  Widget build(BuildContext context) {
    // The list stays open as options are ticked — the difference from a single
    // selector — and the trigger shows a token per choice.
    return AstryxMultiSelector<String>(
      label: 'Reviewers',
      description: 'They are notified when the branch is pushed.',
      values: _reviewers,
      showSearch: true,
      showSelectAll: true,
      maxBadges: 2,
      onChanged: (values) => setState(() => _reviewers = values),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorSection<String>('Maintainers'),
        AstryxSelectorOption<String>(value: 'ada', label: 'Ada Lovelace'),
        AstryxSelectorOption<String>(value: 'alan', label: 'Alan Turing'),
        AstryxSelectorDivider<String>(),
        AstryxSelectorSection<String>('Reviewers'),
        AstryxSelectorOption<String>(
          value: 'grace',
          label: 'Grace Hopper',
          description: 'Away until Friday',
        ),
        AstryxSelectorOption<String>(
          value: 'katherine',
          label: 'Katherine Johnson',
        ),
      ],
    );
  }
}
// #end

// #example multi_selector_count -> MultiSelectorCountExample
class MultiSelectorCountExample extends StatefulWidget {
  const MultiSelectorCountExample({super.key});

  @override
  State<MultiSelectorCountExample> createState() =>
      _MultiSelectorCountExampleState();
}

class _MultiSelectorCountExampleState extends State<MultiSelectorCountExample> {
  Set<String> _regions = <String>{'us-east-1', 'eu-west-2', 'ap-south-1'};

  @override
  Widget build(BuildContext context) {
    // A count instead of tokens, for a field that is usually full.
    return AstryxMultiSelector<String>(
      label: 'Regions',
      values: _regions,
      triggerDisplay: AstryxMultiSelectorTriggerDisplay.count,
      onChanged: (values) => setState(() => _regions = values),
      options: const <AstryxSelectorEntry<String>>[
        AstryxSelectorOption<String>(value: 'us-east-1', label: 'us-east-1'),
        AstryxSelectorOption<String>(value: 'eu-west-2', label: 'eu-west-2'),
        AstryxSelectorOption<String>(value: 'ap-south-1', label: 'ap-south-1'),
        AstryxSelectorOption<String>(
          value: 'sa-east-1',
          label: 'sa-east-1',
          enabled: false,
          description: 'Not enabled for this account',
        ),
      ],
    );
  }
}
// #end

// #example complex_selector_demo -> ComplexSelectorDemoExample
class ComplexSelectorDemoExample extends StatefulWidget {
  const ComplexSelectorDemoExample({super.key});

  @override
  State<ComplexSelectorDemoExample> createState() =>
      _ComplexSelectorDemoExampleState();
}

class _ComplexSelectorDemoExampleState
    extends State<ComplexSelectorDemoExample> {
  AstryxPalette? _palette;

  @override
  Widget build(BuildContext context) {
    // A surface a list of options cannot express: a grid of swatches. The
    // package supplies the field, the trigger and the overlay; the contents are
    // entirely the caller's.
    return AstryxComplexSelector<AstryxPalette?>(
      label: 'Label colour',
      value: _palette,
      placeholder: 'No colour',
      triggerLabel: _palette == null
          ? null
          : AstryxBadge(
              _palette!.name,
              variant: AstryxBadgeVariant.palette(_palette!),
            ),
      onChanged: (value) => setState(() => _palette = value),
      surfaceBuilder: (context, state) => Padding(
        padding: const EdgeInsets.all(8),
        child: AstryxGrid(
          minWidth: 96,
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (final palette in AstryxPalette.values)
              AstryxButton(
                label: palette.name,
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: AstryxBadge(
                  '  ',
                  variant: AstryxBadgeVariant.palette(palette),
                ),
                onPressed: () {
                  state.onChanged(palette);
                  state.close();
                },
              ),
          ],
        ),
      ),
    );
  }
}
// #end
