---
title: Library
description: A browsable collection with filters beside the results.
component: true
group: Templates
source: example/lib/examples/template_split_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One asset in the library.
typedef Asset = ({
  String id,
  String name,
  String collection,
  String kind,
  String size,
  String added,
});

class LibraryTemplate extends StatefulWidget {
  const LibraryTemplate({super.key});

  @override
  State<LibraryTemplate> createState() => _LibraryTemplateState();
}

class _LibraryTemplateState extends State<LibraryTemplate> {
  static const List<Asset> _assets = <Asset>[
    (
      id: 'a1',
      name: 'Runbook cover',
      collection: 'Brand',
      kind: 'Image',
      size: '2.4 MB',
      added: '11 minutes ago',
    ),
    (
      id: 'a2',
      name: 'Wordmark, dark',
      collection: 'Brand',
      kind: 'Vector',
      size: '18 kB',
      added: 'Yesterday',
    ),
    (
      id: 'a3',
      name: 'Incident 4102 timeline',
      collection: 'Incidents',
      kind: 'Image',
      size: '5.1 MB',
      added: '2 days ago',
    ),
    (
      id: 'a4',
      name: 'Scheduler diagram',
      collection: 'Architecture',
      kind: 'Vector',
      size: '96 kB',
      added: '2 days ago',
    ),
    (
      id: 'a5',
      name: 'Fleet map',
      collection: 'Architecture',
      kind: 'Image',
      size: '3.8 MB',
      added: 'Last week',
    ),
    (
      id: 'a6',
      name: 'On-call rota, Q3',
      collection: 'Operations',
      kind: 'Document',
      size: '212 kB',
      added: 'Last week',
    ),
    (
      id: 'a7',
      name: 'Post-mortem template',
      collection: 'Operations',
      kind: 'Document',
      size: '44 kB',
      added: 'Last month',
    ),
  ];

  final TextEditingController _query = TextEditingController();

  Set<String> _kinds = <String>{};
  String _collection = 'All';
  String _view = 'grid';
  final Set<Object> _selected = <Object>{};

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Narrowed in the caller, so an empty result can say which of the two
  /// nothings it is: nothing matched, or nothing here yet.
  List<Asset> get _shown {
    final text = _query.text.trim().toLowerCase();
    return _assets
        .where(
          (asset) =>
              (_collection == 'All' || asset.collection == _collection) &&
              (_kinds.isEmpty || _kinds.contains(asset.kind)) &&
              (text.isEmpty || asset.name.toLowerCase().contains(text)),
        )
        .toList();
  }

  /// How many assets a collection holds, for the count beside its row.
  int _countIn(String collection) => collection == 'All'
      ? _assets.length
      : _assets.where((asset) => asset.collection == collection).length;

  void _toggle(String id, {required bool selected}) => setState(() {
    if (selected) {
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
  });

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 210,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('Library', level: 1),
                    AstryxText(
                      '${shown.length} of ${_assets.length} assets',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: AstryxTextInput(
                        controller: _query,
                        label: 'Search the library',
                        labelHidden: true,
                        placeholder: 'Search',
                        showClear: true,
                        size: AstryxInputSize.sm,
                        leading: const AstryxIcon(
                          AstryxIconName.search,
                          size: AstryxIconSize.sm,
                        ),
                      ),
                    ),
                    // Two ways of looking at one set, so a segmented control:
                    // it announces itself as a radio group, and the arrows
                    // both move and choose.
                    AstryxSegmentedControl<String>(
                      label: 'View',
                      value: _view,
                      size: AstryxButtonSize.sm,
                      onChanged: (value) => setState(() => _view = value),
                      segments: const <AstryxSegment<String>>[
                        AstryxSegment(
                          value: 'grid',
                          label: 'Grid',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.viewColumns),
                        ),
                        AstryxSegment(
                          value: 'list',
                          label: 'List',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.menu),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // The selection bar appears only once something is ticked, and it
            // says how many. "Delete" with no count is a question nobody can
            // answer.
            if (_selected.isNotEmpty)
              AstryxBanner(
                title: '${_selected.length} selected',
                announce: false,
                actions: <Widget>[
                  AstryxButton(
                    label: 'Download',
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  AstryxButton(
                    label: 'Remove',
                    variant: AstryxButtonVariant.destructive,
                    size: AstryxButtonSize.sm,
                    onPressed: () => setState(_selected.clear),
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
              title: 'Collections',
              level: 2,
              child: AstryxList(
                label: 'Collections',
                density: AstryxItemDensity.compact,
                children: <Widget>[
                  for (final collection in const <String>[
                    'All',
                    'Brand',
                    'Incidents',
                    'Architecture',
                    'Operations',
                  ])
                    AstryxItem(
                      label: collection,
                      selected: _collection == collection,
                      trailing: AstryxText(
                        '${_countIn(collection)}',
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                      onPressed: () => setState(() => _collection = collection),
                    ),
                ],
              ),
            ),
            const AstryxDivider(),
            AstryxCheckboxList<String>(
              label: 'Kind',
              values: _kinds,
              onChanged: (values) => setState(() => _kinds = values),
              options: const <AstryxCheckboxOption<String>>[
                AstryxCheckboxOption(value: 'Image', label: 'Image'),
                AstryxCheckboxOption(value: 'Vector', label: 'Vector'),
                AstryxCheckboxOption(value: 'Document', label: 'Document'),
              ],
            ),
          ],
        ),
        child: shown.isEmpty
            ? AstryxEmptyState(
                title: 'Nothing matches',
                description:
                    'Seven assets are still here; the filters are what is '
                    'hiding them.',
                icon: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.lg,
                ),
                actions: <Widget>[
                  AstryxButton(
                    label: 'Clear filters',
                    variant: AstryxButtonVariant.primary,
                    onPressed: () => setState(() {
                      _kinds = <String>{};
                      _collection = 'All';
                      _query.clear();
                    }),
                  ),
                ],
              )
            : _view == 'grid'
            ? _grid(shown)
            : _list(shown),
      ),
    );
  }

  /// The wall: a selectable card per asset.
  ///
  /// `AstryxSelectableCard` rather than a pressable card with a checkbox on
  /// it: this is a *control* that reports a selection, and it announces itself
  /// as a checkbox rather than as a button that happens to tick something.
  Widget _grid(List<Asset> shown) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (final asset in shown)
          SizedBox(
            width: 200,
            child: AstryxSelectableCard(
              label: asset.name,
              semanticsHint: '${asset.kind}, ${asset.size}',
              selected: _selected.contains(asset.id),
              padding: AstryxSpacingToken.spacing3,
              onSelectedChanged: (value) => _toggle(asset.id, selected: value),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxAspectRatio(
                    ratio: 4 / 3,
                    semanticsLabel: asset.name,
                    child: const Center(
                      child: AstryxIcon(AstryxIconName.viewColumns),
                    ),
                  ),
                  AstryxText(
                    asset.name,
                    type: AstryxTextType.label,
                    maxLines: 1,
                  ),
                  AstryxText(
                    '${asset.kind} · ${asset.size}',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// The same set, and the same selection, as rows.
  Widget _list(List<Asset> shown) {
    return AstryxTable<Asset>(
      label: 'Assets',
      keyOf: (row) => row.id,
      rowLabelOf: (row) => row.name,
      density: AstryxTableDensity.compact,
      selectionMode: AstryxTableSelectionMode.multiple,
      selected: _selected,
      onSelectionChanged: (value) => setState(() {
        _selected
          ..clear()
          ..addAll(value);
      }),
      columns: <AstryxTableColumn<Asset>>[
        AstryxTableColumn<Asset>(
          id: 'name',
          header: 'Name',
          compare: (a, b) => a.name.compareTo(b.name),
          cellBuilder: (context, row) => AstryxText(row.name, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'collection',
          header: 'Collection',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxBadge(row.collection),
        ),
        AstryxTableColumn<Asset>(
          id: 'kind',
          header: 'Kind',
          width: const AstryxTableColumnWidth.fixed(100),
          cellBuilder: (context, row) => AstryxText(row.kind, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'added',
          header: 'Added',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxText(
            row.added,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            maxLines: 1,
          ),
        ),
      ],
      rows: shown,
    );
  }
}
```

Tick a few assets, then switch between grid and list: the selection is the same set, because it belongs to the screen rather than to either view.


## One set, one selection, two views

That is the whole design. `_selected` is a `Set<Object>` on the state, and both views read and write it — the grid through [AstryxSelectableCard](selectable_card.md), the list through `AstryxTable`’s `selected` and `onSelectionChanged`. A selection that reset when the reader changed view would make the view control something nobody would press twice.

The view switch is an [AstryxSegmentedControl](segmented_control.md): a small set of mutually exclusive ways of looking at one thing, announced as a radio group, with all its labels present even when they are `labelHidden` behind an icon.

## A selectable card is a control, not a surface

This is the one exception to "there is one card". [AstryxSelectableCard](selectable_card.md) reports a *selection* rather than a press, and announces itself as a checkbox — which is what it is. A pressable [AstryxCard](card.md) with a checkbox drawn on it announces a button that happens to tick something, and a screen-reader user has to work out which.

```dart
AstryxSelectableCard(
  label: asset.name,                        // required, never painted
  semanticsHint: '\${asset.kind}, \${asset.size}',
  selected: _selected.contains(asset.id),
  onSelectedChanged: (value) => _toggle(asset.id, selected: value),
  child: /* the thumbnail, the name, the kind */,
)
```

## The panel is a filter; the header is what it did

```text
AstryxLayout(panelSide: start, panelWidth: 210)
├── header ← title, "5 of 7 assets", search, grid/list, the selection bar
├── panel  ← collections (with counts), then kind checkboxes
└── child  ← the wall, the table, or the empty state
```

Every collection row carries its own count. A filter list that does not say how much is behind each entry makes the reader press them one at a time to find out — and the count is also what makes an empty result legible rather than alarming.

> **Note**
>
> **The selection bar appears only once something is ticked, and it says how many.** "Remove" with no count is a question the reader cannot answer, and it is the one destructive control on the screen.

> **Accessibility**
>
> Every asset is announced as its name plus a `semanticsHint` carrying the kind and the size. In the grid those two facts are a line of small grey text; in the list they are columns. The announcement is the same either way, which is what "two views of one set" has to mean.

## Related

- [File explorer](file_explorer.md) — a hierarchy rather than a flat set.
- [Product gallery](product_gallery.md) — the same shape for things you do not own yet.
- [AstryxSelectableCard](selectable_card.md) — the card that is a control.
- [AstryxTable](table.md) — the other half of the selection.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Library`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Library&component=Library) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Library&area=Library) — both templates arrive with the component filled in.
