import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example item_demo -> ItemDemoExample
class ItemDemoExample extends StatelessWidget {
  const ItemDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxItem(
      leading: const AstryxIcon(AstryxIconName.check),
      label: 'ada@example.com',
      description: 'Owner · invited 3 days ago',
      trailing: const AstryxBadge(
        'Active',
        variant: AstryxBadgeVariant.success,
      ),
      onPressed: () {},
    );
  }
}
// #end

// #example item_states -> ItemStatesExample
class ItemStatesExample extends StatefulWidget {
  const ItemStatesExample({super.key});

  @override
  State<ItemStatesExample> createState() => _ItemStatesExampleState();
}

class _ItemStatesExampleState extends State<ItemStatesExample> {
  String _selected = 'Alan Turing';

  @override
  Widget build(BuildContext context) {
    // A press and a selection are different things: the press state goes when
    // the pointer leaves, the selection stays until something else is chosen.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final name in const <String>['Ada Lovelace', 'Alan Turing'])
          AstryxItem(
            label: name,
            selected: _selected == name,
            onPressed: () => setState(() => _selected = name),
          ),
        const AstryxItem(
          label: 'Grace Hopper',
          description: 'Shown, but not yours to open',
        ),
        AstryxItem(
          label: 'Katherine Johnson',
          description: 'Unavailable',
          enabled: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
// #end
