---
title: Design documentation
description: A docs page for a design topic, heavy on specimens.
component: true
group: Templates
source: example/lib/examples/template_docs_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
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
```

Scroll the column: the outline on the right follows. Switch the brightness in the chrome above and every swatch moves with it.


## A design page is read by looking

Which makes the specimens the content and the prose the caption — the opposite of the [technical page](documentation_technical.md), where the prose has to carry a reader who cannot run the code. It is also why `maxContentWidth` is 840 here rather than 720: the sentences still want a measure, and the specimen wall is allowed to be wider than one.

## A specimen comes from the token, or it is a lie

The swatches are the one place in this site where a raw `Container` is the right answer: the colour *is* the content, so nothing should sit between the token and the reader’s eye. It still comes from `theme.color`, which is why the page is correct in all eight themes and both brightnesses rather than in the one it was drawn in.

```dart
Container(
  width: 56,
  height: 40,
  decoration: BoxDecoration(
    color: theme.color(swatch.token),                      // ← the specimen
    borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
    border: Border.all(color: theme.color(AstryxColorToken.border)),
  ),
)
```

> **Careful**
>
> **A hard-coded hex in a design document is worse than no document.** It is right on the day it is written and quietly wrong from the first theme change onward — and the readers most likely to trust it are the ones who cannot check.

## Do and don’t, side by side

The pair sits in an [AstryxGrid](grid.md) rather than one above the other. The comparison is the whole point, and a reader who has to scroll between the two is not comparing anything.

The "don’t" example is a bare [AstryxStatusDot](status_dot.md) — which never paints its label, because the string is its accessible name. That is the demonstration rather than an accident: a sighted reader gets a red circle and nothing else.

```text
AstryxLayout(maxContentWidth: 840, panelWidth: 190)
├── header ← AstryxBreadcrumbs
├── panel  ← AstryxOutline, tracking the body’s scroll controller
└── child
    ├── AstryxSection("Semantic roles")      ← swatch, token name, when
    ├── AstryxSection("Categorical families")← palette cards and badges
    ├── AstryxSection("Text on ground")      ← the pairing, as code
    └── AstryxSection("What goes wrong")     ← a banner, and the pair
```

> **Accessibility**
>
> Each swatch is named in text beside it, as `AstryxTextType.code`. A colour reference whose entries are distinguished only by their colour is a reference that documents nothing for the reader most likely to be consulting it.

## Related

- [Technical documentation](documentation_technical.md) — the same frame around an API.
- [Documentation](documentation.md) — the site around both, with a rail.
- [Colour](../guides/color.md) — the system this page is a specimen of.
- [AstryxOutline](outline.md) — the tracking, the anchors and `topOffset`.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

