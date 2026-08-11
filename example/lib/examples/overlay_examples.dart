import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example overlay_demo -> OverlayDemoExample
class OverlayDemoExample extends StatefulWidget {
  const OverlayDemoExample({super.key});

  @override
  State<OverlayDemoExample> createState() => _OverlayDemoExampleState();
}

class _OverlayDemoExampleState extends State<OverlayDemoExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The modal contract with nothing on top of it: scrim, focus trap, Escape,
    // barrier dismissal. What sits on the layer is entirely yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Open preview', onPressed: _controller.show),
        AstryxOverlay(
          controller: _controller,
          label: 'Preview',
          child: AstryxCard(
            width: 320,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'atlas-scheduler.png',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxSkeleton(height: 120),
                AstryxButton(label: 'Close', onPressed: _controller.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// #end

// #example overlay_placement -> OverlayPlacementExample
class OverlayPlacementExample extends StatefulWidget {
  const OverlayPlacementExample({super.key});

  @override
  State<OverlayPlacementExample> createState() =>
      _OverlayPlacementExampleState();
}

class _OverlayPlacementExampleState extends State<OverlayPlacementExample> {
  final AstryxOverlayController _controller = AstryxOverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `alignment` puts the layer anywhere in the viewport: bottom-centre is a
    // sheet, top-centre is a command palette, centre is a dialog.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(label: 'Open sheet', onPressed: _controller.show),
        AstryxOverlay(
          controller: _controller,
          label: 'Filters',
          alignment: Alignment.bottomCenter,
          transition: AstryxOverlayTransition.fade,
          child: AstryxCard(
            width: 360,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                const AstryxHeading(
                  'Filters',
                  type: AstryxHeadingType.display3,
                ),
                const AstryxText(
                  'A sheet is an overlay aligned to the bottom edge — not a '
                  'separate component.',
                ),
                AstryxButton(label: 'Apply', onPressed: _controller.hide),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// #end
