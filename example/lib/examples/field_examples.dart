import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example field_demo -> FieldDemoExample
class FieldDemoExample extends StatefulWidget {
  const FieldDemoExample({super.key});

  @override
  State<FieldDemoExample> createState() => _FieldDemoExampleState();
}

class _FieldDemoExampleState extends State<FieldDemoExample> {
  double _budget = 40;

  @override
  Widget build(BuildContext context) {
    // `AstryxField` gives a label, description, required marker and status
    // message to a control that has none of its own — here a plain Flutter
    // slider. The field publishes all of that to its child through
    // `AstryxFieldScope`, so the control does not have to take the props.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Monthly budget',
        description: 'Alerts fire at 80% of this.',
        required: true,
        status: _budget > 80
            ? const AstryxFieldStatus.warning('Above your usual spend')
            : null,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: _Slider(
                value: _budget,
                onChanged: (value) => setState(() => _budget = value),
              ),
            ),
            AstryxText(
              '\$${_budget.round()}',
              tabularNumbers: true,
            ),
          ],
        ),
      ),
    );
  }
}
// #end

// #example field_scope -> FieldScopeExample
class FieldScopeExample extends StatelessWidget {
  const FieldScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Controls that *do* have their own label read the scope instead of
    // repeating it: `enabled` and `status` cascade down from the field.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Region',
        description: 'Both controls inherit the field being disabled.',
        enabled: false,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxTextInput(label: 'Region', labelHidden: true),
            AstryxCheckbox(
              label: 'Replicate to a second region',
              value: false,
            ),
          ],
        ),
      ),
    );
  }
}
// #end

// #example field_markers -> FieldMarkersExample
class FieldMarkersExample extends StatelessWidget {
  const FieldMarkersExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `required` and `optional` are mutually exclusive. Mark whichever is the
    // exception in your form — marking every field says nothing.
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxField(
            label: 'Company name',
            required: true,
            child: AstryxTextInput(label: 'Company name', labelHidden: true),
          ),
          AstryxField(
            label: 'VAT number',
            optional: true,
            child: AstryxTextInput(label: 'VAT number', labelHidden: true),
          ),
          AstryxField(
            label: 'Internal reference',
            labelHidden: true,
            description: 'The label is hidden, but still announced.',
            child: AstryxTextInput(
              label: 'Internal reference',
              labelHidden: true,
            ),
          ),
        ],
      ),
    );
  }
}
// #end

// #example field_statuses -> FieldStatusesExample
class FieldStatusesExample extends StatelessWidget {
  const FieldStatusesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxField(
            label: 'Error',
            status: AstryxFieldStatus.error('This field is required'),
            child: AstryxTextInput(label: 'Error', labelHidden: true),
          ),
          AstryxField(
            label: 'Warning',
            status: AstryxFieldStatus.warning('Unusual for this account'),
            child: AstryxTextInput(label: 'Warning', labelHidden: true),
          ),
          AstryxField(
            label: 'Success',
            status: AstryxFieldStatus.success('Available'),
            child: AstryxTextInput(label: 'Success', labelHidden: true),
          ),
        ],
      ),
    );
  }
}
// #end

/// A minimal slider, to stand in for a control the design system has no widget
/// for yet. Anything can go inside an `AstryxField`.
class _Slider extends StatelessWidget {
  const _Slider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onHorizontalDragUpdate: (details) => onChanged(
          (details.localPosition.dx / constraints.maxWidth * 100).clamp(0, 100),
        ),
        child: SizedBox(
          height: 24,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.track),
                borderRadius: theme.borderRadius(AstryxRadiusToken.full),
              ),
              child: SizedBox(
                height: 6,
                width: double.infinity,
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: value / 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.color(AstryxColorToken.accent),
                      borderRadius: theme.borderRadius(
                        AstryxRadiusToken.full,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
