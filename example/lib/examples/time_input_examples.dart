import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example time_input_demo -> TimeInputDemoExample
class TimeInputDemoExample extends StatefulWidget {
  const TimeInputDemoExample({super.key});

  @override
  State<TimeInputDemoExample> createState() => _TimeInputDemoExampleState();
}

class _TimeInputDemoExampleState extends State<TimeInputDemoExample> {
  AstryxTime? _at = const AstryxTime(hour: 9, minute: 30);

  @override
  Widget build(BuildContext context) {
    // `0930`, `9:30`, `9.30` and `9:30 am` all commit half past nine. The arrow
    // keys move the value; both clocks are accepted whichever one is shown.
    return SizedBox(
      width: 220,
      child: AstryxTimeInput(
        label: 'Starts at',
        description: 'Arrow keys step by 15 minutes.',
        value: _at,
        stepMinutes: 15,
        onChanged: (time) => setState(() => _at = time),
      ),
    );
  }
}
// #end

// #example time_input_bounds -> TimeInputBoundsExample
class TimeInputBoundsExample extends StatefulWidget {
  const TimeInputBoundsExample({super.key});

  @override
  State<TimeInputBoundsExample> createState() => _TimeInputBoundsExampleState();
}

class _TimeInputBoundsExampleState extends State<TimeInputBoundsExample> {
  AstryxTime? _open = const AstryxTime(hour: 9, minute: 0);
  AstryxTime? _close = const AstryxTime(hour: 17, minute: 30);

  @override
  Widget build(BuildContext context) {
    // On a twelve-hour clock, and bounded: a step that would leave the window
    // is refused rather than wrapped round midnight.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        SizedBox(
          width: 180,
          child: AstryxTimeInput(
            label: 'Opens',
            value: _open,
            format: AstryxTimeFormat.h12,
            earliest: const AstryxTime(hour: 6, minute: 0),
            latest: AstryxTime.noon,
            stepMinutes: 30,
            onChanged: (time) => setState(() => _open = time),
          ),
        ),
        SizedBox(
          width: 180,
          child: AstryxTimeInput(
            label: 'Closes',
            value: _close,
            format: AstryxTimeFormat.h12,
            earliest: AstryxTime.noon,
            latest: const AstryxTime(hour: 23, minute: 30),
            stepMinutes: 30,
            onChanged: (time) => setState(() => _close = time),
          ),
        ),
      ],
    );
  }
}
// #end
