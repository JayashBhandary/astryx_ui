import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example popover_demo -> PopoverDemoExample
class PopoverDemoExample extends StatelessWidget {
  const PopoverDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxPopover(
      label: 'Filters',
      width: 260,
      content: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Filters', level: 5),
          const AstryxTextInput(label: 'Owner', placeholder: 'Anyone'),
          AstryxButton(
            label: 'Apply',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      // A builder, not a child: a button consumes its own taps, so the popover
      // hands you the controller and lets you wire it where it belongs.
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'Filters', onPressed: controller.toggle),
    );
  }
}
// #end

// #example popover_sides -> PopoverSidesExample
class PopoverSidesExample extends StatelessWidget {
  const PopoverSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `side` is a preference, not a promise: with no room the positioner flips
    // to the opposite side and shifts along the edge to stay on screen.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final side in AstryxOverlaySide.values)
          AstryxPopover(
            side: side,
            width: 180,
            showArrow: true,
            label: side.name,
            content: AstryxText('Anchored ${side.name}.'),
            triggerBuilder: (context, controller) =>
                AstryxButton(label: side.name, onPressed: controller.toggle),
          ),
      ],
    );
  }
}
// #end

// #example popover_align -> PopoverAlignExample
class PopoverAlignExample extends StatelessWidget {
  const PopoverAlignExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final align in AstryxOverlayAlign.values)
          AstryxPopover(
            align: align,
            width: 220,
            label: align.name,
            content: AstryxText('align: ${align.name}'),
            triggerBuilder: (context, controller) => AstryxButton(
              label: align.name,
              onPressed: controller.toggle,
            ),
          ),
      ],
    );
  }
}
// #end

// #example popover_controlled -> PopoverControlledExample
class PopoverControlledExample extends StatefulWidget {
  const PopoverControlledExample({super.key});

  @override
  State<PopoverControlledExample> createState() =>
      _PopoverControlledExampleState();
}

class _PopoverControlledExampleState extends State<PopoverControlledExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _open = _controller.isOpen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Passing a controller makes the popover *controlled*: the open state lives
    // wherever the application already keeps state, and anything can drive it.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxPopover(
          controller: _controller,
          label: 'Details',
          width: 220,
          content: const AstryxText('Focus is trapped in here.'),
          triggerBuilder: (context, controller) =>
              AstryxButton(label: 'Details', onPressed: controller.toggle),
        ),
        AstryxButton(
          label: _open ? 'Close from outside' : 'Open from outside',
          variant: AstryxButtonVariant.ghost,
          onPressed: _controller.toggle,
        ),
      ],
    );
  }
}
// #end

// #example popover_match_width -> PopoverMatchWidthExample
class PopoverMatchWidthExample extends StatelessWidget {
  const PopoverMatchWidthExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `matchTriggerWidth` is what makes a panel look like it belongs to the
    // control above it — upstream gets the same effect from `anchor-size()`.
    return SizedBox(
      width: 320,
      child: AstryxPopover(
        matchTriggerWidth: true,
        label: 'Recent searches',
        content: const AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxText('invoice overdue'),
            AstryxText('owner:ada'),
            AstryxText('status:blocked'),
          ],
        ),
        triggerBuilder: (context, controller) => AstryxButton(
          label: 'Recent searches',
          width: double.infinity,
          onPressed: controller.toggle,
        ),
      ),
    );
  }
}
// #end
