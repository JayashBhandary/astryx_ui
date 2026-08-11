import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

const List<AstryxTreeNode> _files = <AstryxTreeNode>[
  AstryxTreeNode(
    id: 'lib',
    label: 'lib',
    children: <AstryxTreeNode>[
      AstryxTreeNode(
        id: 'components',
        label: 'components',
        children: <AstryxTreeNode>[
          AstryxTreeNode(id: 'item', label: 'item.dart'),
          AstryxTreeNode(id: 'list', label: 'list.dart'),
          AstryxTreeNode(id: 'tree', label: 'tree_list.dart'),
        ],
      ),
      AstryxTreeNode(id: 'astryx_ui', label: 'astryx_ui.dart'),
    ],
  ),
  AstryxTreeNode(
    id: 'test',
    label: 'test',
    children: <AstryxTreeNode>[
      AstryxTreeNode(id: 'list_test', label: 'list_test.dart'),
    ],
  ),
  AstryxTreeNode(id: 'readme', label: 'README.md'),
];

// #example tree_list_demo -> TreeListDemoExample
class TreeListDemoExample extends StatefulWidget {
  const TreeListDemoExample({super.key});

  @override
  State<TreeListDemoExample> createState() => _TreeListDemoExampleState();
}

class _TreeListDemoExampleState extends State<TreeListDemoExample> {
  String? _selected = 'list';

  @override
  Widget build(BuildContext context) {
    // Tab lands on the tree once; the arrows do the rest. Right opens a branch
    // and then steps into it, Left closes it and then steps out.
    return AstryxTreeList(
      label: 'Files',
      nodes: _files,
      initiallyExpanded: const <String>{'lib', 'components'},
      selected: _selected,
      onSelectedChanged: (id) => setState(() => _selected = id),
    );
  }
}
// #end

// #example tree_list_controlled -> TreeListControlledExample
class TreeListControlledExample extends StatefulWidget {
  const TreeListControlledExample({super.key});

  @override
  State<TreeListControlledExample> createState() =>
      _TreeListControlledExampleState();
}

class _TreeListControlledExampleState extends State<TreeListControlledExample> {
  Set<String> _expanded = <String>{'lib'};
  String? _selected;

  /// Every branch in the tree, whether it is open or not.
  static const Set<String> _branches = <String>{'lib', 'components', 'test'};

  @override
  Widget build(BuildContext context) {
    // With `expanded` passed in, nothing opens until the caller says so — which
    // is what lets a button outside the tree drive it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: 'Expand all',
              size: AstryxButtonSize.sm,
              onPressed: () => setState(() => _expanded = _branches),
            ),
            AstryxButton(
              label: 'Collapse all',
              size: AstryxButtonSize.sm,
              onPressed: () => setState(() => _expanded = <String>{}),
            ),
          ],
        ),
        AstryxTreeList(
          label: 'Files',
          nodes: _files,
          density: AstryxItemDensity.compact,
          expanded: _expanded,
          onExpandedChanged: (next) => setState(() => _expanded = next),
          selected: _selected,
          onSelectedChanged: (id) => setState(() => _selected = id),
        ),
      ],
    );
  }
}
// #end
