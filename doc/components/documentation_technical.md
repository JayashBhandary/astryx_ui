---
title: Technical documentation
description: A docs page for an API, heavy on code and property tables.
component: true
group: Templates
source: example/lib/examples/template_docs_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
/// One row of the property table.
typedef ApiProperty = ({
  String name,
  String type,
  String fallback,
  String notes,
  bool required,
});

class DocumentationTechnicalTemplate extends StatefulWidget {
  const DocumentationTechnicalTemplate({super.key});

  @override
  State<DocumentationTechnicalTemplate> createState() =>
      _DocumentationTechnicalTemplateState();
}

class _DocumentationTechnicalTemplateState
    extends State<DocumentationTechnicalTemplate> {
  static const List<({String id, String title})> _sections =
      <({String id, String title})>[
        (id: 'usage', title: 'Usage'),
        (id: 'auth', title: 'Authentication'),
        (id: 'properties', title: 'Properties'),
        (id: 'errors', title: 'Errors'),
      ];

  static const List<ApiProperty> _properties = <ApiProperty>[
    (
      name: 'project',
      type: 'String',
      fallback: '—',
      notes: 'The project the run belongs to. Slug, not id.',
      required: true,
    ),
    (
      name: 'ref',
      type: 'String',
      fallback: 'HEAD',
      notes: 'A branch, a tag or a commit.',
      required: false,
    ),
    (
      name: 'variables',
      type: 'Map<String, String>',
      fallback: '{}',
      notes: 'Overrides for the pipeline’s own variables.',
      required: false,
    ),
    (
      name: 'dryRun',
      type: 'bool',
      fallback: 'false',
      notes: 'Validates the request and reports what would run.',
      required: false,
    ),
  ];

  final ScrollController _scroll = ScrollController();

  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  /// Which language the usage sample is shown in.
  String _language = 'dart';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  static const Map<String, String> _samples = <String, String>{
    'dart': '''
final run = await foundry.runs.create(
  project: 'acme/platform',
  ref: 'main',
  variables: <String, String>{'TARGET': 'production'},
);

print(run.id);   // run_8f21c4''',
    'curl': r'''
curl https://api.foundry.example/v1/runs \
  -H "Authorization: Bearer $FOUNDRY_TOKEN" \
  -d project=acme/platform \
  -d ref=main''',
  };

  @override
  Widget build(BuildContext context) {
    // Prose is not the content here — code and a property table are, and both
    // want width. `maxContentWidth` is still set, because the *sentences*
    // between them are what a reader loses first when a line runs too long.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollController: _scroll,
        maxContentWidth: 780,
        panelWidth: 190,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxBreadcrumbs(
                label: 'You are here',
                items: <AstryxBreadcrumb>[
                  AstryxBreadcrumb(label: 'API', onPressed: () {}),
                  AstryxBreadcrumb(label: 'Runs', onPressed: () {}),
                  const AstryxBreadcrumb(label: 'Create a run'),
                ],
              ),
            ),
            const AstryxBadge('v1', variant: AstryxBadgeVariant.info),
          ],
        ),
        panel: AstryxOutline(
          label: 'On this page',
          controller: _scroll,
          entries: <AstryxOutlineEntry>[
            for (final section in _sections)
              AstryxOutlineEntry(
                id: section.id,
                label: section.title,
                anchor: _anchors[section.id],
              ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHeading('Create a run', level: 1),
                // The method and path are the first thing anybody looks for on
                // a reference page, so they are on the page rather than in a
                // code block that has to be read for them.
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  // The method, the path and the guarantee are three separate
                  // facts, so a narrow page takes them on separate lines
                  // rather than choosing which one to cut off.
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxBadge('POST', variant: AstryxBadgeVariant.success),
                    AstryxCode('/v1/runs'),
                    AstryxBadge(
                      'Idempotent',
                      icon: AstryxIcon(AstryxIconName.check),
                      semanticsLabel:
                          'Idempotent — repeating this request is safe',
                    ),
                  ],
                ),
              ],
            ),
            AstryxSection(
              title: 'Usage',
              headerKey: _anchors['usage'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  // The strip reports a value and owns no panel, so which
                  // sample is showing is one field and a lookup. That is what
                  // makes the choice linkable from a route.
                  AstryxTabList<String>(
                    label: 'Language',
                    value: _language,
                    size: AstryxTabSize.sm,
                    onChanged: (value) => setState(() => _language = value),
                    tabs: const <AstryxTab<String>>[
                      AstryxTab(value: 'dart', label: 'Dart'),
                      AstryxTab(value: 'curl', label: 'curl'),
                    ],
                  ),
                  AstryxCodeBlock(
                    _samples[_language]!,
                    language: _language,
                    showLineNumbers: true,
                  ),
                ],
              ),
            ),
            AstryxSection(
              title: 'Authentication',
              headerKey: _anchors['auth'],
              child: Text.rich(
                TextSpan(
                  style: AstryxTheme.of(
                    context,
                  ).textStyle(AstryxTypeRole.body),
                  children: <InlineSpan>[
                    const TextSpan(text: 'Send a project token in '),
                    AstryxCode.span('Authorization'),
                    const TextSpan(text: '. Tokens are issued from '),
                    AstryxLink.span('Settings › Secrets', onPressed: () {}),
                    const TextSpan(
                      text:
                          ' and are scoped to one project — a token for '
                          'another project fails closed rather than falling '
                          'back to read-only.',
                    ),
                  ],
                ),
              ),
            ),
            AstryxSection(
              title: 'Properties',
              headerKey: _anchors['properties'],
              child: AstryxTable<ApiProperty>(
                label: 'Request properties',
                keyOf: (row) => row.name,
                rowLabelOf: (row) => row.name,
                columns: <AstryxTableColumn<ApiProperty>>[
                  AstryxTableColumn<ApiProperty>(
                    id: 'name',
                    header: 'Property',
                    width: const AstryxTableColumnWidth.fixed(150),
                    cellBuilder: (context, row) => AstryxHStack(
                      gap: AstryxSpacingToken.spacing1,
                      children: <Widget>[
                        Flexible(child: AstryxCode(row.name)),
                        if (row.required)
                          const AstryxBadge(
                            'req',
                            variant: AstryxBadgeVariant.warning,
                            semanticsLabel: 'Required',
                          ),
                      ],
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'type',
                    header: 'Type',
                    width: const AstryxTableColumnWidth.fixed(160),
                    cellBuilder: (context, row) => AstryxText(
                      row.type,
                      type: AstryxTextType.code,
                      maxLines: 1,
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'default',
                    header: 'Default',
                    width: const AstryxTableColumnWidth.fixed(90),
                    cellBuilder: (context, row) => AstryxText(
                      row.fallback,
                      type: AstryxTextType.code,
                      maxLines: 1,
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'notes',
                    header: 'Notes',
                    cellBuilder: (context, row) =>
                        AstryxText(row.notes, maxLines: 2),
                  ),
                ],
                rows: _properties,
              ),
            ),
            AstryxSection(
              title: 'Errors',
              headerKey: _anchors['errors'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxBanner(
                    title: 'Every error carries a machine-readable code',
                    description:
                        'Match on the code, never on the message: the message '
                        'is translated and the code is not.',
                    announce: false,
                  ),
                  AstryxList(
                    label: 'Errors',
                    showDividers: true,
                    density: AstryxItemDensity.compact,
                    children: <Widget>[
                      for (final error in const <List<String>>[
                        <String>[
                          '400',
                          'invalid_ref',
                          'The ref does not exist on the project.',
                        ],
                        <String>[
                          '403',
                          'token_scope',
                          'The token belongs to a different project.',
                        ],
                        <String>[
                          '409',
                          'run_in_flight',
                          'A run for this ref is already queued.',
                        ],
                      ])
                        AstryxItem(
                          label: error[1],
                          description: error[2],
                          leading: AstryxBadge(error[0]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Switch the sample between Dart and curl: the tab strip reports a value and the block is a lookup, which is what makes the choice linkable from a route.


## The method and the path are on the page

Not inside the first code block. They are the first thing anybody looks for on a reference page, and a reader who has to parse a curl invocation to find out whether this is a `POST` has been made to work for the one fact the page exists to state.

The **Idempotent** badge carries a `semanticsLabel` that says what the word means — "repeating this request is safe" — because a one-word badge is a term of art, and a term of art with no expansion is a badge for people who already knew.

## The property table is an AstryxTable

Not a hand-built grid of rows. It gets the column widths, the header semantics, the row dividers and — where a `compare` is given — the sorting, for free. The **Property** column mixes an [AstryxCode](code.md) name with a `req` badge, which is what a `cellBuilder` is for.

```dart
AstryxTableColumn<ApiProperty>(
  id: 'name',
  header: 'Property',
  width: const AstryxTableColumnWidth.fixed(150),
  cellBuilder: (context, row) => AstryxHStack(
    children: <Widget>[
      Flexible(child: AstryxCode(row.name)),
      if (row.required)
        const AstryxBadge('req', semanticsLabel: 'Required'),
    ],
  ),
)
```

> **Careful**
>
> **No `truncateTooltip: true` in a table cell.** Deciding whether text is cut off needs the cell’s final width, and a table row is measured before it is laid out — the layout asserts in touch density. `maxLines` on its own is what these cells use; the ellipsis is the signal, and a screen reader gets the whole string either way.

## Two samples, one field of state

The language switch is an [AstryxTabList](tab_list.md), which reports a value and owns no panel — so the sample on screen is `_samples[_lang]` and nothing else. Every sample is written out in full rather than diffed against the one above it: a reader copies one block, and a block that only makes sense beside another is a block that does not survive the clipboard.

The curl sample is a raw string — `r'''…'''` — so the continuation backslashes and the `$TOKEN` are what the reader sees. Escaping them into a normal string is how a documented command ends up shipping a double backslash.

## Errors are a list, and they are matched on the code

The banner above them says it out loud: match on the code, never on the message. The message is translated and the code is not, and the reader who is going to get that wrong is the one skimming for a status number.

> **Accessibility**
>
> The inline links in the Authentication section are `AstryxLink.span` inside a `Text.rich`, not a button after the paragraph. Flutter has no inline element, and the alternative — a link lifted out of the sentence it belongs to — takes the context with it.

## Related

- [Design documentation](documentation_design.md) — the same frame around specimens.
- [Documentation](documentation.md) — the site around both.
- [AstryxTable](table.md) — the three width strategies, and sorting.
- [AstryxCodeBlock](code_block.md) — the language label, copy, and line numbers.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Technical documentation`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Technical+documentation&component=Technical+documentation) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Technical+documentation&area=Technical+documentation) — both templates arrive with the component filled in.
