import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example collapsible_group_demo -> CollapsibleGroupDemoExample
class CollapsibleGroupDemoExample extends StatelessWidget {
  const CollapsibleGroupDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The default: sections divided into one block, each owning its own state.
    // Two can be open at once, which is what makes them comparable.
    return const SizedBox(
      width: 380,
      child: AstryxCollapsibleGroup(
        children: <AstryxCollapsible>[
          AstryxCollapsible(
            title: 'Billing',
            description: 'Plan, invoices and payment method',
            child: AstryxText('Team plan · renews 4 April · Visa ···· 4242'),
          ),
          AstryxCollapsible(
            title: 'Members',
            description: '12 people, 3 pending invitations',
            child: AstryxText('Owners: Ada, Priya. Everyone else can deploy.'),
          ),
          AstryxCollapsible(
            title: 'Audit log',
            description: 'Everything anyone changed',
            child: AstryxText('Retained for 90 days on this plan.'),
          ),
        ],
      ),
    );
  }
}
// #end

// #example collapsible_group_exclusive -> CollapsibleGroupExclusiveExample
class CollapsibleGroupExclusiveExample extends StatefulWidget {
  const CollapsibleGroupExclusiveExample({super.key});

  @override
  State<CollapsibleGroupExclusiveExample> createState() =>
      _CollapsibleGroupExclusiveExampleState();
}

class _CollapsibleGroupExclusiveExampleState
    extends State<CollapsibleGroupExclusiveExample> {
  int? _open = 0;

  @override
  Widget build(BuildContext context) {
    // An accordion: the group owns which section is open, so opening one closes
    // the last. `onChanged` reports the index, or null when they are all shut.
    return SizedBox(
      width: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxCollapsibleGroup(
            exclusive: true,
            initialIndex: 0,
            onChanged: (index) => setState(() => _open = index),
            children: const <AstryxCollapsible>[
              AstryxCollapsible(
                title: 'Shipping address',
                child: AstryxText('12 Hanover Square, London'),
              ),
              AstryxCollapsible(
                title: 'Delivery window',
                child: AstryxText('Tuesday, between 09:00 and 13:00'),
              ),
              AstryxCollapsible(
                title: 'Payment',
                child: AstryxText('Visa ···· 4242, expires 11/28'),
              ),
            ],
          ),
          AstryxText(
            'Open section: ${_open ?? 'none'}',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
// #end
