import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example collapsible_demo -> CollapsibleDemoExample
class CollapsibleDemoExample extends StatelessWidget {
  const CollapsibleDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The whole header is the button, and it carries the expanded state in its
    // semantics — so a screen reader says "collapsed" without seeing a chevron.
    return const SizedBox(
      width: 360,
      child: AstryxCollapsible(
        title: 'Advanced settings',
        description: 'Timeouts, retries and headers',
        child: AstryxText(
          'Requests time out after 30 seconds and are retried twice with an '
          'exponential backoff.',
        ),
      ),
    );
  }
}
// #end

// #example collapsible_rich -> CollapsibleRichExample
class CollapsibleRichExample extends StatelessWidget {
  const CollapsibleRichExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `leading` and `trailing` take any widget. Nothing interactive belongs in
    // either: the header is one button, so a control inside it is unreachable.
    return const SizedBox(
      width: 360,
      child: AstryxCollapsible(
        initiallyExpanded: true,
        leading: AstryxStatusDot(
          AstryxStatusDotVariant.warning,
          label: 'Degraded',
        ),
        title: 'Failed deliveries',
        trailing: AstryxBadge('3'),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxText('POST /hooks/billing — 502 at 14:02'),
            AstryxText('POST /hooks/billing — 502 at 14:07'),
            AstryxText('POST /hooks/audit — timeout at 14:31'),
          ],
        ),
      ),
    );
  }
}
// #end

// #example collapsible_controlled -> CollapsibleControlledExample
class CollapsibleControlledExample extends StatefulWidget {
  const CollapsibleControlledExample({super.key});

  @override
  State<CollapsibleControlledExample> createState() =>
      _CollapsibleControlledExampleState();
}

class _CollapsibleControlledExampleState
    extends State<CollapsibleControlledExample> {
  final AstryxCollapsibleController _controller = AstryxCollapsibleController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // With a controller the state is yours: anything can open the section, and
    // you can watch it. Dispose one you own.
    return SizedBox(
      width: 360,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(label: 'Expand', onPressed: _controller.expand),
              AstryxButton(label: 'Collapse', onPressed: _controller.collapse),
            ],
          ),
          AstryxCollapsible(
            controller: _controller,
            title: 'Request headers',
            child: const AstryxText(
              'Accept: application/json\nX-Request-Id: 9f2c…',
              type: AstryxTextType.code,
            ),
          ),
        ],
      ),
    );
  }
}
// #end
