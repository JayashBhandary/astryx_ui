import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example list_demo -> ListDemoExample
class ListDemoExample extends StatefulWidget {
  const ListDemoExample({super.key});

  @override
  State<ListDemoExample> createState() => _ListDemoExampleState();
}

class _ListDemoExampleState extends State<ListDemoExample> {
  String? _open;

  @override
  Widget build(BuildContext context) {
    return AstryxList(
      label: 'Recent deploys',
      showDividers: true,
      children: <Widget>[
        for (final deploy in const <List<String>>[
          <String>['api', '2 minutes ago', 'Live'],
          <String>['web', '1 hour ago', 'Live'],
          <String>['worker', 'yesterday', 'Rolled back'],
        ])
          AstryxItem(
            label: deploy[0],
            description: deploy[1],
            selected: _open == deploy[0],
            trailing: AstryxBadge(
              deploy[2],
              variant: deploy[2] == 'Live'
                  ? AstryxBadgeVariant.success
                  : AstryxBadgeVariant.neutral,
            ),
            onPressed: () => setState(() => _open = deploy[0]),
          ),
      ],
    );
  }
}
// #end

// #example list_density -> ListDensityExample
class ListDensityExample extends StatelessWidget {
  const ListDensityExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The list sets the rhythm once; no row repeats it, and no row can
    // disagree with its neighbours by accident.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (final density in AstryxItemDensity.values)
          Flexible(
            child: AstryxList(
              label: density.name,
              density: density,
              children: <Widget>[
                for (final name in const <String>['Ada', 'Alan', 'Grace'])
                  AstryxItem(label: name),
              ],
            ),
          ),
      ],
    );
  }
}
// #end

// #example list_empty -> ListEmptyExample
class ListEmptyExample extends StatefulWidget {
  const ListEmptyExample({super.key});

  @override
  State<ListEmptyExample> createState() => _ListEmptyExampleState();
}

class _ListEmptyExampleState extends State<ListEmptyExample> {
  final List<String> _keys = <String>[];

  @override
  Widget build(BuildContext context) {
    // `empty` is the list's answer to having nothing to show. Without it a
    // list with no rows renders nothing at all, which reads as a bug.
    return AstryxList(
      label: 'API keys',
      showDividers: true,
      empty: AstryxEmptyState(
        size: AstryxEmptyStateSize.compact,
        icon: const AstryxIcon(AstryxIconName.search),
        title: 'No API keys',
        description: 'Keys you create will be listed here.',
        actions: <Widget>[
          AstryxButton(
            label: 'Create a key',
            variant: AstryxButtonVariant.primary,
            onPressed: () => setState(() => _keys.add('key_live_1')),
          ),
        ],
      ),
      children: <Widget>[
        for (final key in _keys)
          AstryxItem(
            label: key,
            description: 'Created just now',
            trailing: AstryxButton(
              label: 'Revoke',
              size: AstryxButtonSize.sm,
              variant: AstryxButtonVariant.ghost,
              onPressed: () => setState(() => _keys.remove(key)),
            ),
          ),
      ],
    );
  }
}
// #end
