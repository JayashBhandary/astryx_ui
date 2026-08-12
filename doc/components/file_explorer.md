---
title: File explorer
description: A tree of folders beside a list of files.
component: true
group: Templates
source: example/lib/examples/template_workspace_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One file in the listing.
typedef ExplorerFile = ({String name, String kind, String size, String edited});

class FileExplorerTemplate extends StatefulWidget {
  const FileExplorerTemplate({super.key});

  @override
  State<FileExplorerTemplate> createState() => _FileExplorerTemplateState();
}

class _FileExplorerTemplateState extends State<FileExplorerTemplate> {
  static const List<AstryxTreeNode> _folders = <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'workspace',
      label: 'Workspace',
      leading: AstryxIcon(AstryxIconName.viewColumns),
      children: <AstryxTreeNode>[
        AstryxTreeNode(
          id: 'runbooks',
          label: 'Runbooks',
          children: <AstryxTreeNode>[
            AstryxTreeNode(id: 'runbooks_deploys', label: 'Deploys'),
            AstryxTreeNode(id: 'runbooks_oncall', label: 'On-call'),
          ],
        ),
        AstryxTreeNode(
          id: 'postmortems',
          label: 'Post-mortems',
          trailing: AstryxBadge('4'),
        ),
        AstryxTreeNode(id: 'archive', label: 'Archive', enabled: false),
      ],
    ),
    AstryxTreeNode(
      id: 'shared',
      label: 'Shared with me',
      leading: AstryxIcon(AstryxIconName.checkDouble),
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'shared_sre', label: 'SRE'),
        AstryxTreeNode(id: 'shared_security', label: 'Security'),
      ],
    ),
  ];

  static const Map<String, List<ExplorerFile>> _contents =
      <String, List<ExplorerFile>>{
        'runbooks_deploys': <ExplorerFile>[
          (
            name: 'rollback.md',
            kind: 'Markdown',
            size: '4.2 kB',
            edited: '11 minutes ago',
          ),
          (
            name: 'canary.md',
            kind: 'Markdown',
            size: '8.9 kB',
            edited: 'Yesterday',
          ),
          (
            name: 'pipeline.yaml',
            kind: 'YAML',
            size: '1.1 kB',
            edited: '3 days ago',
          ),
        ],
        'runbooks_oncall': <ExplorerFile>[
          (
            name: 'escalation.md',
            kind: 'Markdown',
            size: '2.4 kB',
            edited: 'Last week',
          ),
          (
            name: 'rota-2026.csv',
            kind: 'CSV',
            size: '19 kB',
            edited: 'Last week',
          ),
        ],
        'postmortems': <ExplorerFile>[
          (
            name: '4102-latency.md',
            kind: 'Markdown',
            size: '22 kB',
            edited: '2 hours ago',
          ),
        ],
      };

  static const Map<String, String> _names = <String, String>{
    'workspace': 'Workspace',
    'runbooks': 'Runbooks',
    'runbooks_deploys': 'Deploys',
    'runbooks_oncall': 'On-call',
    'postmortems': 'Post-mortems',
    'shared': 'Shared with me',
    'shared_sre': 'SRE',
    'shared_security': 'Security',
  };

  String _folder = 'runbooks_deploys';
  Set<Object> _selected = <Object>{};

  List<ExplorerFile> get _files => _contents[_folder] ?? const <ExplorerFile>[];

  @override
  Widget build(BuildContext context) {
    final files = _files;

    return SizedBox(
      height: 520,
      child: AstryxLayout(
        scrollable: false,
        // The tree is at the reading-start edge, because it is where the
        // reader came *from* rather than what they are looking at.
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 240,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading(_names[_folder] ?? 'Files', level: 1),
                AstryxText(
                  '${files.length} items',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxButton(
              label: 'Upload',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        // The tree is one tab stop and the arrows do the rest: Right opens a
        // branch and steps into it, Left closes it and steps out.
        panel: AstryxTreeList(
          label: 'Folders',
          nodes: _folders,
          initiallyExpanded: const <String>{'workspace', 'runbooks'},
          density: AstryxItemDensity.compact,
          selected: _folder,
          onSelectedChanged: (id) => setState(() {
            _folder = id;
            _selected = <Object>{};
          }),
        ),
        child: AstryxTable<ExplorerFile>(
          label: 'Files in ${_names[_folder]}',
          keyOf: (row) => row.name,
          rowLabelOf: (row) => row.name,
          density: AstryxTableDensity.compact,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          onRowPressed: (_) {},
          maxHeight: 340,
          emptyState: AstryxEmptyState(
            title: 'Nothing in this folder',
            description: 'Drop a file here, or pick another folder.',
            size: AstryxEmptyStateSize.compact,
            actions: <Widget>[
              AstryxButton(
                label: 'Upload',
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          columns: <AstryxTableColumn<ExplorerFile>>[
            AstryxTableColumn<ExplorerFile>(
              id: 'name',
              header: 'Name',
              compare: (a, b) => a.name.compareTo(b.name),
              cellBuilder: (context, row) => AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  const AstryxIcon(AstryxIconName.copy),
                  Flexible(child: AstryxText(row.name, maxLines: 1)),
                ],
              ),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'kind',
              header: 'Kind',
              width: const AstryxTableColumnWidth.fixed(110),
              cellBuilder: (context, row) => AstryxBadge(row.kind),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'size',
              header: 'Size',
              width: const AstryxTableColumnWidth.fixed(90),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) =>
                  AstryxText(row.size, tabularNumbers: true, maxLines: 1),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'edited',
              header: 'Edited',
              width: const AstryxTableColumnWidth.fixed(130),
              cellBuilder: (context, row) => AstryxText(
                row.edited,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ),
          ],
          rows: files,
          // Always visible, never on hover: touch has no hover, and the
          // density system suppresses hover styling there.
          rowActionsBuilder: (context, row) => AstryxMoreMenu(
            label: 'Actions for ${row.name}',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Rename', onSelected: () {}),
              AstryxMenuItem(label: 'Download', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Delete',
                destructive: true,
                onSelected: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Tab to the tree and use the arrows: Right opens a branch and steps into it, Left closes it and steps out. Open **Post-mortems** twice to reach a folder with one file, and **Archive** to find a disabled one.


## The tree is where you came from; the table is what you see

Which is why the tree is at the *reading-start* edge — `panelSide: AstryxLayoutPanelSide.start` — and the table fills the body. A details panel about the selected thing goes at the other edge; a way of getting to it goes at this one.

```text
AstryxLayout(scrollable: false, panelSide: start, panelWidth: 240)
├── header ← the folder’s name, its count, and Upload
├── panel  ← AstryxTreeList: the folders
└── child  ← AstryxTable: the files in the selected one
```

## One tab stop, and the arrows do the rest

[AstryxTreeList](tree_list.md) owns its own traversal, and it is the traversal a file tree has had for thirty years: Down and Up move between visible rows, Right opens and steps in, Left closes and steps out, Home and End go to the ends. Do not wrap the nodes in `Focus` — they are already one control.

A closed branch builds none of its children, so a tree of a thousand nodes costs only what is open. What *is* open is built in full: this is a `Column`, like [AstryxList](list.md), and it does not virtualise.

## Selection lives in the caller

Changing folder clears it. That is a decision, not an oversight — a selection that survives a change of folder is a set of files the reader can no longer see, and the next thing they press acts on it.

```dart
onSelectedChanged: (id) => setState(() {
  _folder = id;
  _selected = <Object>{};    // ← the selection belonged to the old folder
}),
```

> **Careful**
>
> **Row actions are always visible.** The overflow menu on each file is an [AstryxMoreMenu](more_menu.md) named for *that* file — "Actions for rollback.md". Hover does not exist on touch, and the density system actively suppresses hover styling there, so a menu that appears under a pointer is a menu half the readers do not have.

The empty state is per-folder and offers the way out: **Archive** is disabled in the tree, and a folder with nothing in it says so and offers Upload rather than looking like a table that failed to load.

> **Accessibility**
>
> `rowLabelOf` names each row’s checkbox with the file’s own name. Without it every checkbox in the table announces "Select row", which is true of all of them and therefore tells a screen-reader user nothing about which one they are ticking.

## Related

- [IDE](ide.md) — the same tree, beside editors rather than a table.
- [Library](library.md) — a flat collection with filters instead of a hierarchy.
- [AstryxTreeList](tree_list.md) — the nodes, the keyboard map and the expansion state.
- [AstryxTable](table.md) — selection, row actions and the width strategies.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

