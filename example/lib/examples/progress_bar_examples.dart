import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example progress_demo -> ProgressDemoExample
class ProgressDemoExample extends StatelessWidget {
  const ProgressDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxProgressBar(
        label: 'Uploading footage.mov',
        value: 0.62,
        showValueLabel: true,
      ),
    );
  }
}
// #end

// #example progress_variants -> ProgressVariantsExample
class ProgressVariantsExample extends StatelessWidget {
  const ProgressVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final variant in AstryxProgressVariant.values)
            AstryxProgressBar(
              label: variant.name,
              value: 0.5,
              variant: variant,
            ),
        ],
      ),
    );
  }
}
// #end

// #example progress_indeterminate -> ProgressIndeterminateExample
class ProgressIndeterminateExample extends StatelessWidget {
  const ProgressIndeterminateExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A null value means "in progress, extent unknown". Under reduced motion
    // the fill stops travelling — the bar stays, the animation does not.
    return const SizedBox(
      width: 320,
      child: AstryxProgressBar(label: 'Reindexing search'),
    );
  }
}
// #end

// #example progress_labels -> ProgressLabelsExample
class ProgressLabelsExample extends StatelessWidget {
  const ProgressLabelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxProgressBar(
            label: 'Default',
            value: 0.4,
            showValueLabel: true,
          ),
          // `showLabel: false` hides the text without taking the accessible
          // name away — the bar is still announced as "Storage used".
          const AstryxProgressBar(
            label: 'Storage used',
            value: 0.4,
            showLabel: false,
          ),
          AstryxProgressBar(
            label: 'Seats',
            value: 18 / 24,
            showValueLabel: true,
            formatValue: (value) => '${(value * 24).round()} of 24',
          ),
        ],
      ),
    );
  }
}
// #end

// #example progress_live -> ProgressLiveExample
class ProgressLiveExample extends StatefulWidget {
  const ProgressLiveExample({super.key});

  @override
  State<ProgressLiveExample> createState() => _ProgressLiveExampleState();
}

class _ProgressLiveExampleState extends State<ProgressLiveExample> {
  double _value = 0.15;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _run() {
    _ticker?.cancel();
    setState(() => _value = 0);
    _ticker = Timer.periodic(const Duration(milliseconds: 320), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _value = (_value + 0.12).clamp(0.0, 1.0));
      if (_value >= 1) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxProgressBar(
            label: 'Importing 240 rows',
            value: _value,
            showValueLabel: true,
            variant: _value >= 1
                ? AstryxProgressVariant.success
                : AstryxProgressVariant.accent,
          ),
          AstryxButton(
            label: _value >= 1 ? 'Run again' : 'Run',
            size: AstryxButtonSize.sm,
            onPressed: _run,
          ),
        ],
      ),
    );
  }
}
// #end
