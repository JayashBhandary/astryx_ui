/// The three screens people keep open all day: an editor, a file explorer and
/// an IDE.
///
/// What they have in common is a resizable split and a surface that owns its
/// own scrolling — which is why none of them is an `AstryxLayout` with the body
/// scrolling under a header. What they do *not* have in common is the thing in
/// the middle, and that is where each one earns its own template.
///
/// None of it is exported. Each is a composition worth copying, built from
/// nothing but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_editor -> EditorTemplate
class EditorTemplate extends StatefulWidget {
  const EditorTemplate({super.key});

  @override
  State<EditorTemplate> createState() => _EditorTemplateState();
}

class _EditorTemplateState extends State<EditorTemplate> {
  final TextEditingController _title = TextEditingController(
    text: 'Rolling back a deploy',
  );

  final TextEditingController _body = TextEditingController(
    text:
        '# Rolling back\n\n'
        'A rollback is a deploy of the previous commit. There is no separate '
        'rollback screen, because the thing you already know how to watch is '
        'the thing that runs.\n\n'
        'Select a phrase and press **Bold** in the toolbar above.',
  );

  /// Whether the canvas shows the source or the rendered result.
  String _mode = 'write';

  bool _dirty = false;
  String _status = 'draft';
  final Set<String> _tags = <String>{'deploys'};

  @override
  void initState() {
    super.initState();
    _title.addListener(_touch);
    _body.addListener(_touch);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _touch() {
    if (!_dirty) setState(() => _dirty = true);
  }

  /// Wraps the selection in [marker], leaving the caret after it.
  ///
  /// This is the whole of what a toolbar can honestly do over a plain text
  /// field: the package ships no rich-text editing controller, so the document
  /// is its own markup and the buttons are edits to it rather than styling
  /// applied to a hidden model.
  void _wrap(String marker) {
    final value = _body.value;
    final selection = value.selection;
    if (!selection.isValid) return;

    final replaced = '$marker${selection.textInside(value.text)}$marker';
    _body.value = value.copyWith(
      text:
          selection.textBefore(value.text) +
          replaced +
          selection.textAfter(value.text),
      selection: TextSelection.collapsed(
        offset: selection.start + replaced.length,
      ),
      composing: TextRange.empty,
    );
  }

  /// How many words the draft has, for the footer.
  int get _words =>
      _body.text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    // `scrollable: false`: the canvas scrolls itself, and a scroll view inside
    // a scroll view measures unbounded — which is a layout assertion rather
    // than a subtle bug.
    return LayoutBuilder(
      builder: (context, constraints) {
        // The same width the layout's own panel makes its mind up at, so the
        // frame and the panel change together rather than one at a time.
        final compact = constraints.maxWidth < 640;

        return SizedBox(
          // A header that has wrapped onto three lines and a panel that has
          // become a band above the canvas both cost height the wide frame
          // never had to find. Bands do not shrink, so the frame grows.
          height: compact ? 720 : 560,
          child: _layout(context, compact: compact),
        );
      },
    );
  }

  Widget _layout(BuildContext context, {required bool compact}) {
    return AstryxLayout(
      scrollable: false,
      panelWidth: 260,
      panelLabel: 'Document',
      header: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: AstryxTextInput(
                  controller: _title,
                  label: 'Title',
                  labelHidden: true,
                  size: AstryxInputSize.lg,
                  placeholder: 'Untitled',
                ),
              ),
              AstryxBadge(
                _dirty ? 'Unsaved changes' : 'Saved',
                variant: _dirty
                    ? AstryxBadgeVariant.warning
                    : AstryxBadgeVariant.success,
                icon: AstryxIcon(
                  _dirty ? AstryxIconName.warning : AstryxIconName.success,
                ),
              ),
            ],
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              // One tab stop for the whole band, however many controls sit
              // in it. Tab reaches the toolbar and leaves it; the arrows
              // move inside.
              AstryxToolbar(
                label: 'Formatting',
                children: <Widget>[
                  for (final mark in const <List<String>>[
                    <String>['Bold', '**'],
                    <String>['Italic', '_'],
                    <String>['Code', '`'],
                  ])
                    AstryxButton(
                      label: mark[0],
                      size: AstryxButtonSize.sm,
                      variant: AstryxButtonVariant.ghost,
                      enabled: _mode == 'write',
                      onPressed: () => _wrap(mark[1]),
                    ),
                  const AstryxToolbarDivider(),
                  AstryxMoreMenu(
                    label: 'More formatting',
                    enabled: _mode == 'write',
                    entries: <AstryxMenuEntry>[
                      AstryxMenuItem(
                        label: 'Strikethrough',
                        onSelected: () => _wrap('~~'),
                      ),
                      AstryxMenuItem(
                        label: 'Quote',
                        onSelected: () => _wrap('\n> '),
                      ),
                    ],
                  ),
                ],
              ),
              AstryxSegmentedControl<String>(
                label: 'Canvas',
                value: _mode,
                size: AstryxButtonSize.sm,
                onChanged: (value) => setState(() => _mode = value),
                segments: const <AstryxSegment<String>>[
                  AstryxSegment(value: 'write', label: 'Write'),
                  AstryxSegment(value: 'preview', label: 'Preview'),
                ],
              ),
            ],
          ),
        ],
      ),
      panel: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSection(
            title: 'Document',
            level: 2,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxSelector<String>(
                  label: 'Status',
                  value: _status,
                  onChanged: (value) => setState(() {
                    _status = value ?? _status;
                    _dirty = true;
                  }),
                  options: const <AstryxSelectorOption<String>>[
                    AstryxSelectorOption(value: 'draft', label: 'Draft'),
                    AstryxSelectorOption(value: 'review', label: 'In review'),
                    AstryxSelectorOption(
                      value: 'published',
                      label: 'Published',
                    ),
                  ],
                ),
                AstryxCheckboxList(
                  label: 'Tags',
                  values: _tags,
                  onChanged: (values) => setState(() {
                    _tags
                      ..clear()
                      ..addAll(values);
                    _dirty = true;
                  }),
                  options: const <AstryxCheckboxOption<String>>[
                    AstryxCheckboxOption(value: 'deploys', label: 'Deploys'),
                    AstryxCheckboxOption(value: 'oncall', label: 'On-call'),
                    AstryxCheckboxOption(
                      value: 'runbook',
                      label: 'Runbook',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const AstryxDivider(),
          AstryxSection(
            title: 'History',
            level: 2,
            child: AstryxMetadataList(
              items: <AstryxMetadataItem>[
                AstryxMetadataItem.text(
                  label: 'Created',
                  value: '12 March, by Grace Hopper',
                ),
                AstryxMetadataItem.text(
                  label: 'Last edited',
                  value: '4 minutes ago, by you',
                ),
                AstryxMetadataItem.text(label: 'Revisions', value: '31'),
              ],
            ),
          ),
        ],
      ),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        // The count and the two actions take a line each rather than the
        // count being pushed off the start of the band.
        wrap: true,
        runGap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxText(
            '$_words words',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Discard',
                size: AstryxButtonSize.sm,
                enabled: _dirty,
                onPressed: () => setState(() => _dirty = false),
              ),
              AstryxButton(
                label: 'Save',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                enabled: _dirty,
                onPressed: () => setState(() => _dirty = false),
              ),
            ],
          ),
        ],
      ),
      // The canvas, and the only thing on the screen that scrolls — in both
      // modes, and for the same reason. `minLines` becomes a minimum in
      // *pixels* once it has been measured, and it wins against the frame: a
      // field asking for twelve lines inside a band with room for nine
      // overflows rather than shrinking. Given a scroll view it keeps the
      // height it asked for and the reader gets at the rest by scrolling.
      child: SingleChildScrollView(
        child: _mode == 'write'
            ? AstryxTextArea(
                controller: _body,
                label: 'Document body',
                labelHidden: true,
                // Fewer lines on a phone all the same: a canvas that opens
                // taller than the window it is in has put the Save button
                // behind a scroll nobody was told about.
                minLines: compact ? 6 : 12,
                maxLines: 40,
              )
            : AstryxMarkdown(_body.text),
      ),
    );
  }
}
// #end

// #example template_file_explorer -> FileExplorerTemplate
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
// #end

// #example template_ide -> IdeTemplate
class IdeTemplate extends StatefulWidget {
  const IdeTemplate({super.key});

  @override
  State<IdeTemplate> createState() => _IdeTemplateState();
}

class _IdeTemplateState extends State<IdeTemplate> {
  static const List<AstryxTreeNode> _nodes = <AstryxTreeNode>[
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
    //
    // The `LayoutBuilder` is what decides whether there are three regions or
    // one. A resizable tree needs a window to be resized *within*: at 390
    // logical pixels the handle's own minimum of 140 is more than a third of
    // the screen, and what is left is not a narrow editor but no editor.
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;

        return SizedBox(
          // The bands do not shrink — a tab strip and a status bar cost what
          // they cost — so a narrow frame is a taller one rather than an
          // overflowing one.
          height: compact ? 620 : 520,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Narrow, the tree is a disclosure above the editor rather than a
              // column beside it: the same nodes, the same selection, and the
              // editor keeps the whole width once a file is chosen.
              if (compact) ...<Widget>[
                AstryxCollapsible(
                  title: 'Explorer',
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: SingleChildScrollView(child: _tree(context)),
                  ),
                ),
                const AstryxDivider(),
                Expanded(child: _editor(context)),
              ] else
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
                                child: _tree(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tab reaches the handle and the arrows move it. A
                      // divider only a pointer can drag is a layout only some
                      // people can use, which is the part hand-rolled
                      // splitters always miss.
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
              // Nothing to drag on a touch screen with no pointer to spare, so
              // narrow the drawer is a fixed band and the handle goes away
              // rather than becoming a control that cannot be used.
              if (!compact)
                AstryxResizeHandle(
                  label: 'Resize the panel',
                  edge: AstryxResizeEdge.bottom,
                  size: _drawerHeight,
                  min: 80,
                  max: 260,
                  onResize: (height) => setState(() => _drawerHeight = height),
                )
              else
                const AstryxDivider(),
              SizedBox(
                height: compact ? 132 : _drawerHeight,
                child: _panel(context),
              ),
              const AstryxDivider(),
              _statusBar(context, compact: compact),
            ],
          ),
        );
      },
    );
  }

  /// The file tree, shared by the column and the disclosure.
  Widget _tree(BuildContext context) => AstryxTreeList(
    label: 'Files',
    nodes: _nodes,
    initiallyExpanded: const <String>{'lib', 'components'},
    density: AstryxItemDensity.compact,
    selected: _file,
    onSelectedChanged: _openFile,
  );

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
  ///
  /// Narrow, the caret position goes rather than being squeezed: it is the one
  /// item here a reader can get from the editor itself, and a status bar that
  /// wraps onto two lines has stopped being a band.
  Widget _statusBar(BuildContext context, {required bool compact}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: AstryxHStack(
        gap: compact
            ? AstryxSpacingToken.spacing3
            : AstryxSpacingToken.spacing4,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const AstryxStatusDot(
            AstryxStatusDotVariant.success,
            label: 'Analyser is clean',
          ),
          const Flexible(
            child: AstryxText(
              'main',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ),
          const Spacer(),
          if (!compact)
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

// #end
