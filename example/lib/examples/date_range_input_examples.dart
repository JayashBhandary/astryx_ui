import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example date_range_input_demo -> DateRangeInputDemoExample
class DateRangeInputDemoExample extends StatefulWidget {
  const DateRangeInputDemoExample({super.key});

  @override
  State<DateRangeInputDemoExample> createState() =>
      _DateRangeInputDemoExampleState();
}

class _DateRangeInputDemoExampleState extends State<DateRangeInputDemoExample> {
  AstryxDateRange? _period;

  @override
  Widget build(BuildContext context) {
    // Two fields, one border, one label. Nothing is reported until both ends
    // are readable and in order — try an end date before the start.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 340,
          child: AstryxDateRangeInput(
            label: 'Reporting period',
            value: _period,
            onChanged: (range) => setState(() => _period = range),
          ),
        ),
        AstryxText(
          _period == null
              ? 'No period yet'
              : '${_period!.days} days selected',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example date_range_input_bounds -> DateRangeInputBoundsExample
class DateRangeInputBoundsExample extends StatefulWidget {
  const DateRangeInputBoundsExample({super.key});

  @override
  State<DateRangeInputBoundsExample> createState() =>
      _DateRangeInputBoundsExampleState();
}

class _DateRangeInputBoundsExampleState
    extends State<DateRangeInputBoundsExample> {
  AstryxDateRange? _period;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // The bounds and the label overrides apply to both halves. The two names
    // are announced rather than shown: the visible label names the pair.
    return SizedBox(
      width: 340,
      child: AstryxDateRangeInput(
        label: 'Booking',
        description: 'Up to ninety days out.',
        value: _period,
        startLabel: 'Arrival',
        endLabel: 'Departure',
        firstDate: today,
        lastDate: DateTime(today.year, today.month, today.day + 90),
        onChanged: (range) => setState(() => _period = range),
      ),
    );
  }
}
// #end
