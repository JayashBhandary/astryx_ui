/// Two documentation pages that are not the same page.
///
/// A design topic and an API reference share a frame and almost nothing else:
/// one is carried by specimens the reader looks at, the other by code and a
/// property table the reader searches. `template_shell_examples.dart` has the
/// frame around a docs site; these are what goes inside it.
///
/// Neither is exported. Both are compositions worth copying, built from nothing
/// but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_documentation_design -> DocumentationDesignTemplate
/// One row of the specimen wall: a token, and what it is for.
typedef Swatch = ({String name, AstryxColorToken token, String use});

class DocumentationDesignTemplate extends StatefulWidget {
  const DocumentationDesignTemplate({super.key});

  @override
  State<DocumentationDesignTemplate> createState() =>
      _DocumentationDesignTemplateState();
}

class _DocumentationDesignTemplateState
    extends State<DocumentationDesignTemplate> {
  static const List<({String id, String title})> _sections =
      <({String id, String title})>[
        (id: 'roles', title: 'Semantic roles'),
        (id: 'families', title: 'Categorical families'),
        (id: 'pairs', title: 'Text on ground'),
        (id: 'wrong', title: 'What goes wrong'),
      ];

  static const List<Swatch> _roles = <Swatch>[
    (
      name: 'accent',
      token: AstryxColorToken.accent,
      use: 'The one action in a view.',
    ),
    (
      name: 'success',
      token: AstryxColorToken.success,
      use: 'A thing that finished, and finished well.',
    ),
    (
      name: 'warning',
      token: AstryxColorToken.warning,
      use: 'Something the reader should look at before it is a problem.',
    ),
    (
      name: 'error',
      token: AstryxColorToken.error,
      use: 'Something that failed, or will.',
    ),
  ];

  static const List<({String name, AstryxPalette palette})> _families =
      <({String name, AstryxPalette palette})>[
        (name: 'blue', palette: AstryxPalette.blue),
        (name: 'green', palette: AstryxPalette.green),
        (name: 'orange', palette: AstryxPalette.orange),
        (name: 'purple', palette: AstryxPalette.purple),
        (name: 'teal', palette: AstryxPalette.teal),
        (name: 'pink', palette: AstryxPalette.pink),
      ];

  final ScrollController _scroll = ScrollController();

  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A design page is read by looking, so the specimens are the content and
    // the prose is the caption. The measure still applies to the prose — but
    // the specimen wall is allowed to be wider than it, which is why
    // `maxContentWidth` is generous rather than 720.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollController: _scroll,
        maxContentWidth: 840,
        panelWidth: 190,
        header: AstryxBreadcrumbs(
          label: 'You are here',
          items: <AstryxBreadcrumb>[
            AstryxBreadcrumb(label: 'Design', onPressed: () {}),
            AstryxBreadcrumb(label: 'Foundations', onPressed: () {}),
            const AstryxBreadcrumb(label: 'Colour'),
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
                AstryxHeading('Colour', level: 1),
                AstryxText(
                  'Two systems that look like one: four semantic roles that '
                  'mean something, and ten families that mean nothing at all.',
                  type: AstryxTextType.large,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSection(
              title: 'Semantic roles',
              description: 'These carry meaning, and there are only four.',
              headerKey: _anchors['roles'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final swatch in _roles) _SwatchRow(swatch: swatch),
                ],
              ),
            ),
            AstryxSection(
              title: 'Categorical families',
              description:
                  'These carry no severity whatever. "The Red team" is a '
                  'name, not a warning.',
              headerKey: _anchors['families'],
              child: AstryxGrid(
                minWidth: 150,
                gap: AstryxSpacingToken.spacing3,
                children: <Widget>[
                  for (final family in _families)
                    AstryxCard(
                      variant: AstryxCardVariant.palette(family.palette),
                      padding: AstryxSpacingToken.spacing3,
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing2,
                        children: <Widget>[
                          AstryxText(
                            family.name,
                            type: AstryxTextType.label,
                          ),
                          AstryxBadge(
                            'Badge',
                            variant: AstryxBadgeVariant.palette(family.palette),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            AstryxSection(
              title: 'Text on ground',
              description:
                  'Every filled surface has a paired foreground. Reaching for '
                  'one without the other is where contrast is lost.',
              headerKey: _anchors['pairs'],
              child: const AstryxCodeBlock('''
final theme = AstryxTheme.of(context);

// Right: the pair.
theme.color(AstryxColorToken.accent);      // ground
theme.color(AstryxColorToken.onAccent);    // text on it

// Wrong: a ground with the page's own text colour on top.
theme.color(AstryxColorToken.accent);
theme.color(AstryxColorToken.textPrimary);''', language: 'dart'),
            ),
            AstryxSection(
              title: 'What goes wrong',
              headerKey: _anchors['wrong'],
              child: const AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxBanner(
                    status: AstryxBannerStatus.warning,
                    title: 'Colour is never the only signal',
                    description:
                        'Every status here is a colour and a glyph and a '
                        'word. In greyscale, or to a colour-blind reader, the '
                        'colour is the part that is gone.',
                    announce: false,
                  ),
                  // A do-and-don't pair, side by side rather than one above the
                  // other: the comparison is the point, and a reader who has to
                  // scroll between the two is not comparing anything.
                  AstryxGrid(
                    minWidth: 240,
                    gap: AstryxSpacingToken.spacing3,
                    children: <Widget>[
                      _SpecimenCard(
                        verdict: 'Do',
                        good: true,
                        caption: 'A glyph, a word, and a colour.',
                        child: AstryxBadge(
                          'Failed',
                          variant: AstryxBadgeVariant.error,
                          icon: AstryxIcon(AstryxIconName.error),
                        ),
                      ),
                      // The dot never paints its label — the string is its
                      // accessible name. Which is the whole demonstration: a
                      // sighted reader gets a red circle and nothing else.
                      _SpecimenCard(
                        verdict: "Don't",
                        good: false,
                        caption: 'A dot, and a reader guessing what red means.',
                        child: AstryxStatusDot(
                          AstryxStatusDotVariant.error,
                          label: 'Failed',
                        ),
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

/// A swatch, its token name, and the sentence saying when to use it.
class _SwatchRow extends StatelessWidget {
  const _SwatchRow({required this.swatch});

  final Swatch swatch;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // The one place a raw `Container` is right: this *is* the colour, so
        // there is no widget between the token and the reader's eye. It still
        // comes from `theme.color`, which is why the page is correct in all
        // eight themes and both brightnesses.
        Container(
          width: 56,
          height: 40,
          decoration: BoxDecoration(
            color: theme.color(swatch.token),
            borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
            border: Border.all(color: theme.color(AstryxColorToken.border)),
          ),
        ),
        Flexible(
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing0_5,
            children: <Widget>[
              AstryxText(swatch.name, type: AstryxTextType.code),
              AstryxText(
                swatch.use,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One half of a do-and-don't pair.
class _SpecimenCard extends StatelessWidget {
  const _SpecimenCard({
    required this.verdict,
    required this.good,
    required this.caption,
    required this.child,
  });

  final String verdict;
  final bool good;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      header: AstryxBadge(
        verdict,
        variant: good ? AstryxBadgeVariant.success : AstryxBadgeVariant.error,
        icon: AstryxIcon(
          good ? AstryxIconName.success : AstryxIconName.error,
        ),
      ),
      footer: AstryxText(
        caption,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      child: Align(alignment: AlignmentDirectional.centerStart, child: child),
    );
  }
}
// #end

// #example template_documentation_technical -> DocumentationTechnicalTemplate
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
// #end
