import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/widgets.dart';

/// `AstryxSpinner`, `AstryxSkeleton` and `AstryxProgressBar`.
///
/// One page for all three: they are only meaningful together, and the reduced
/// motion behaviour is easiest to judge when every indicator is on screen at
/// once.
abstract final class StatusDemo {
  static Widget build(BuildContext context) => const _StatusDemo();
}

class _StatusDemo extends StatefulWidget {
  const _StatusDemo();

  @override
  State<_StatusDemo> createState() => _StatusDemoState();
}

class _StatusDemoState extends State<_StatusDemo> {
  double _value = 0.35;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _simulate() {
    _ticker?.cancel();
    setState(() => _value = 0);
    _ticker = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _value = (_value + 0.12).clamp(0.0, 1.0));
      if (_value >= 1) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      const DemoSection(
        title: 'Spinner — sizes and shades',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          children: <Widget>[
            AstryxSpinner(size: AstryxSpinnerSize.sm),
            AstryxSpinner(),
            AstryxSpinner(size: AstryxSpinnerSize.lg),
            AstryxSpinner(shade: AstryxSpinnerShade.subtle),
          ],
        ),
      ),
      const DemoSection(
        title: 'Skeleton — a loading card',
        child: SizedBox(
          width: 280,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.start,
            children: <Widget>[
              AstryxSkeleton.circle(size: 40),
              Expanded(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxSkeleton.text(),
                    AstryxSkeleton.text(widthFactor: 0.8),
                    AstryxSkeleton.text(widthFactor: 0.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      DemoSection(
        title: 'Progress — determinate',
        child: SizedBox(
          width: 320,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxProgressBar(
                label: 'Uploading',
                value: _value,
                showValueLabel: true,
              ),
              for (final variant in AstryxProgressVariant.values)
                AstryxProgressBar(
                  label: variant.name,
                  value: 0.6,
                  variant: variant,
                ),
              const AstryxProgressBar(
                label: 'Disabled',
                value: 0.3,
                enabled: false,
              ),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxButton(label: 'Simulate upload', onPressed: _simulate),
                ],
              ),
            ],
          ),
        ),
      ),
      const DemoSection(
        title: 'Progress — indeterminate. Flip the direction picker to RTL',
        child: SizedBox(
          width: 320,
          child: AstryxProgressBar(label: 'Loading'),
        ),
      ),
      const DemoSection(
        title: 'Reduced motion',
        child: AstryxText(
          'Turn on the platform’s reduce-motion setting and every '
          'indicator above stops: the spinner becomes a dimmed ring, the '
          'skeleton stops pulsing at full opacity, and the indeterminate bar '
          'holds still. Each still says what it means.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
    ],
  );
}
