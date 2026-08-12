---
title: IDE
description: 'A code workspace: file tree, tabbed editors, and a panel.'
component: true
group: Templates
source: example/lib/examples/template_workspace_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class IdeTemplate extends StatefulWidget {
  const IdeTemplate({super.key});

  @override
  State<IdeTemplate> createState() => _IdeTemplateState();
}

class _IdeTemplateState extends State<IdeTemplate> {
  static const List<AstryxTreeNode> _tree = <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'lib',
      label: 'lib',
      children: <AstryxTreeNode>[
        AstryxTreeNode(
          id: 'components',
          label: 'components',
          children: <AstryxTreeNode>[
            AstryxTreeNode(id: 'card.dart', label: 'card.dart'),
            AstryxTreeNode(
              id: 'table.dart',
              label: 'table.dart',
              trailing: AstryxStatusDot(
                AstryxStatusDotVariant.warning,
                label: '2 problems',
              ),
            ),
          ],
        ),
        AstryxTreeNode(id: 'astryx_ui.dart', label: 'astryx_ui.dart'),
      ],
    ),
    AstryxTreeNode(
      id: 'test',
      label: 'test',
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'table_test.dart', label: 'table_test.dart'),
      ],
    ),
  ];

  static const Map<String, String> _sources = <String, String>{
    'card.dart': '''
class AstryxCard extends StatelessWidget {
  const AstryxCard({
    required this.child,
    this.header,
    this.footer,
    this.onPressed,
  });

  /// A non-null [onPressed] makes the whole card a button.
  final VoidCallback? onPressed;
}''',
    'table.dart': '''
/// A column is sortable when — and only when — it has a [compare].
class AstryxTableColumn<T> {
  const AstryxTableColumn({
    required this.id,
    required this.header,
    required this.cellBuilder,
    this.compare,
  });

  final int Function(T a, T b)? compare;
}''',
    'table_test.dart': '''
void main() {
  testWidgets('a column without compare is not sortable', (tester) async {
    await tester.pumpWidget(const _Harness());
    expect(find.byIcon(AstryxIconName.arrowsUpDown), findsNothing);
  });
}''',
  };

  /// The files with an editor open, in the order they were opened.
  final List<String> _open = <String>['card.dart', 'table.dart'];

  String _file = 'table.dart';
  String _drawer = 'problems';

  /// The two regions the reader may resize.
  ///
  /// A handle reports a size; the caller is what remembers it.
  double _treeWidth = 200;
  double _drawerHeight = 132;

  @override
  Widget build(BuildContext context) {
    // A bare `Column`, not an `AstryxCard`. A card sizes itself to its body,
    // so it hands that body an unbounded height — and every region here is an
    // `Expanded` or a fixed band measured against the frame. The bounded
    // `SizedBox` is what the whole layout is built against.
    return SizedBox(
      height: 520,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: _treeWidth,
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing0,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: AstryxText(
                          'Explorer',
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: AstryxTreeList(
                            label: 'Files',
                            nodes: _tree,
                            initiallyExpanded: const <String>{
                              'lib',
                              'components',
                            },
                            density: AstryxItemDensity.compact,
                            selected: _file,
                            onSelectedChanged: _openFile,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab reaches the handle and the arrows move it. A divider
                // only a pointer can drag is a layout only some people can
                // use, which is the part hand-rolled splitters always miss.
                AstryxResizeHandle(
                  label: 'Resize the file tree',
                  size: _treeWidth,
                  min: 140,
                  max: 320,
                  onResize: (width) => setState(() => _treeWidth = width),
                ),
                Expanded(child: _editor(context)),
              ],
            ),
          ),
          AstryxResizeHandle(
            label: 'Resize the panel',
            edge: AstryxResizeEdge.bottom,
            size: _drawerHeight,
            min: 80,
            max: 260,
            onResize: (height) => setState(() => _drawerHeight = height),
          ),
          SizedBox(height: _drawerHeight, child: _panel(context)),
          const AstryxDivider(),
          _statusBar(context),
        ],
      ),
    );
  }

  /// Opens [id] in a tab, if it is a file rather than a folder.
  void _openFile(String id) {
    if (!_sources.containsKey(id)) return;
    setState(() {
      if (!_open.contains(id)) _open.add(id);
      _file = id;
    });
  }

  /// The tab strip and the surface under it.
  Widget _editor(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // The strip reports a value and owns no panel, so which file is showing
        // is one field of state — and closing a tab is a list edit, not a
        // panel-stack surgery.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing1,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxTabList<String>(
                label: 'Open files',
                value: _file,
                size: AstryxTabSize.sm,
                onChanged: (value) => setState(() => _file = value),
                tabs: <AstryxTab<String>>[
                  for (final file in _open) AstryxTab(value: file, label: file),
                ],
              ),
            ),
            AstryxMoreMenu(
              label: 'Editor actions',
              entries: <AstryxMenuEntry>[
                AstryxMenuItem(
                  label: 'Close $_file',
                  onSelected: () => setState(() {
                    _open.remove(_file);
                    _file = _open.isEmpty ? '' : _open.last;
                  }),
                ),
                AstryxMenuItem(
                  label: 'Close all',
                  onSelected: () => setState(() {
                    _open.clear();
                    _file = '';
                  }),
                ),
              ],
            ),
          ],
        ),
        // The surface scrolls rather than being squeezed: a code block handed a
        // tight height has nowhere to put the lines that do not fit.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: _open.isEmpty
                ? const AstryxEmptyState(
                    title: 'No file open',
                    description: 'Choose one from the tree on the left.',
                    size: AstryxEmptyStateSize.compact,
                  )
                : AstryxCodeBlock(
                    _sources[_file] ?? '',
                    language: 'dart',
                    showLineNumbers: true,
                  ),
          ),
        ),
      ],
    );
  }

  /// The drawer under the editor: problems, or the run log.
  Widget _panel(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Panel',
          value: _drawer,
          size: AstryxTabSize.sm,
          onChanged: (value) => setState(() => _drawer = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(
              value: 'problems',
              label: 'Problems',
              badge: AstryxBadge('2'),
            ),
            AstryxTab(value: 'output', label: 'Output'),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: _drawer == 'problems'
                ? AstryxList(
                    label: 'Problems',
                    density: AstryxItemDensity.compact,
                    children: <Widget>[
                      for (final problem in const <List<String>>[
                        <String>[
                          'table.dart:41',
                          'Unused import: dart:math',
                        ],
                        <String>[
                          'table.dart:88',
                          'compare is null, so this column is not sortable',
                        ],
                      ])
                        AstryxItem(
                          label: problem[1],
                          description: problem[0],
                          leading: const AstryxIcon(
                            AstryxIconName.warning,
                            color: AstryxIconColor.warning,
                          ),
                          onPressed: () {},
                        ),
                    ],
                  )
                : const AstryxCodeBlock(
                    '\$ dart test\n'
                    '00:02 +14: All tests passed!',
                    showCopy: false,
                  ),
          ),
        ),
      ],
    );
  }

  /// The band along the bottom: branch, problems, and where the caret is.
  Widget _statusBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const AstryxStatusDot(
            AstryxStatusDotVariant.success,
            label: 'Analyser is clean',
          ),
          const AstryxText(
            'main',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          const Spacer(),
          const AstryxText(
            'Ln 41, Col 12',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            tabularNumbers: true,
          ),
          AstryxText(
            _file.isEmpty ? '—' : 'Dart',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```

Tab to either divider and press the arrow keys — both regions resize from the keyboard. Open a file from the tree and close it from the editor menu.


## Two resize handles, and the caller owns both sizes

An [AstryxResizeHandle](resize_handle.md) reports the size the region beside it should take; remembering it is the caller’s job. That is why the widths and heights are fields here, and it is what lets a real application persist them.

```dart
AstryxResizeHandle(
  label: 'Resize the file tree',   // required — nothing is painted on a handle
  size: _treeWidth,
  min: 140,
  max: 320,
  onResize: (width) => setState(() => _treeWidth = width),
),

AstryxResizeHandle(
  label: 'Resize the panel',
  edge: AstryxResizeEdge.bottom,   // ← a band at the bottom grows upward
  size: _drawerHeight,
  min: 80,
  max: 260,
  onResize: (height) => setState(() => _drawerHeight = height),
),
```

> **Accessibility**
>
> **Tab reaches a handle and the arrow keys move it**, with Home and End at `min` and `max`. It announces itself as a slider carrying the current size, and `label` is required because nothing is painted on a handle. A divider only a pointer can drag is a layout only some people can use — the part hand-rolled splitters almost always miss.

## Tabs report a value and own no panel

Which file is showing is one field of state, so closing a tab is a list edit rather than surgery on a panel stack. The same is true of the drawer at the bottom: **Problems** or **Output** is a second field, and each is a lookup.

```text
SizedBox(height: 520)          ← every region is measured against this
└── Column(crossAxisAlignment: stretch)
    ├── Expanded → Row
    │   ├── SizedBox(_treeWidth) → AstryxTreeList
    │   ├── AstryxResizeHandle
    │   └── Expanded → AstryxTabList(open files) + the editor surface
    ├── AstryxResizeHandle(edge: bottom)
    ├── SizedBox(_drawerHeight) → AstryxTabList(Problems · Output)
    └── the status bar
```

> **Careful**
>
> **A bare `Column`, not an [AstryxCard](card.md).** A card sizes itself to its body, so it hands that body an unbounded height — and every region here is either an `Expanded` or a band measured against the frame. The bounded `SizedBox` is what the whole layout is built against; put a card around it and nothing inside can be laid out at all.

> **Careful**
>
> **The editor surface is an [AstryxCodeBlock](code_block.md), which is read-only and does no highlighting.** A code editor is a text control with a language server behind it, and this package does not ship one. Everything around it — the tree, the tabs, the drawer, the handles, the status bar — is real; the box in the middle is where your editor goes.

## The status bar is one line and no interaction

Analyser state as an [AstryxStatusDot](status_dot.md) with a real label, the branch, the caret position in tabular figures, the language. Everything on it is a fact a glance needs — which is the test for what belongs on a status bar and what belongs in a menu.

When every tab is closed the editor shows an [AstryxEmptyState](empty_state.md) pointing back at the tree. A blank panel where a file used to be looks like a file that failed to open.

## Related

- [Editor](editor.md) — the same shape when the document is prose.
- [File explorer](file_explorer.md) — the same tree, beside a table.
- [AstryxResizeHandle](resize_handle.md) — the edges, the step and the keyboard.
- [AstryxTreeList](tree_list.md) — the nodes and the traversal.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

