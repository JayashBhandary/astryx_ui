import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example tooltip_demo -> TooltipDemoExample
class TooltipDemoExample extends StatelessWidget {
  const TooltipDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTooltip(
      message: 'Archive this conversation',
      child: AstryxIconButton(
        icon: AstryxIconName.check,
        label: 'Archive',
        onPressed: () {},
      ),
    );
  }
}
// #end

// #example tooltip_sides -> TooltipSidesExample
class TooltipSidesExample extends StatelessWidget {
  const TooltipSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final side in AstryxOverlaySide.values)
          AstryxTooltip(
            message: 'Anchored ${side.name}',
            side: side,
            showArrow: true,
            child: AstryxButton(label: side.name, onPressed: () {}),
          ),
      ],
    );
  }
}
// #end

// #example tooltip_timing -> TooltipTimingExample
class TooltipTimingExample extends StatelessWidget {
  const TooltipTimingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The wait is what stops a tooltip firing at everything the mouse crosses
    // on its way somewhere else.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      children: <Widget>[
        AstryxTooltip(
          message: 'Appears at once',
          waitDuration: Duration.zero,
          child: AstryxButton(label: 'No wait', onPressed: () {}),
        ),
        AstryxTooltip(
          message: 'Appears after 200ms — the default',
          child: AstryxButton(label: 'Default', onPressed: () {}),
        ),
        AstryxTooltip(
          message: 'Appears after a second',
          waitDuration: const Duration(seconds: 1),
          exitDuration: const Duration(milliseconds: 400),
          child: AstryxButton(label: 'Patient', onPressed: () {}),
        ),
      ],
    );
  }
}
// #end

// #example tooltip_semantics -> TooltipSemanticsExample
class TooltipSemanticsExample extends StatelessWidget {
  const TooltipSemanticsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        // The tooltip repeats the button's own name, so it is left out of the
        // semantics tree. Hearing "Archive, Archive" is worse than silence.
        AstryxTooltip(
          message: 'Archive',
          excludeFromSemantics: true,
          child: AstryxIconButton(
            icon: AstryxIconName.check,
            label: 'Archive',
            onPressed: () {},
          ),
        ),
        // This one says something the name does not, so it stays announced.
        AstryxTooltip(
          message: 'Archived items are kept for 30 days',
          child: AstryxIconButton(
            icon: AstryxIconName.info,
            label: 'About archiving',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
// #end

// #example tooltip_wrapping -> TooltipWrappingExample
class TooltipWrappingExample extends StatelessWidget {
  const TooltipWrappingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxTooltip(
      maxWidth: 220,
      message:
          'Long tooltips wrap at maxWidth. Even so: never put anything '
          'essential in a tooltip alone — it is unreachable on touch until '
          'someone thinks to long-press.',
      child: AstryxButton(label: 'Hover for a while', onPressed: () {}),
    );
  }
}
// #end
