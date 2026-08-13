/// The page the site opens on.
///
/// A documentation site is not only a reference — somebody arriving from a
/// search result, a package page or a link in a pull request has one question
/// first, and it is *what is this and should I use it*. The sidebar cannot
/// answer that: it is two hundred rows of things you would only look up once
/// you had already decided.
///
/// So the front door is its own screen. Like everything else here it is built
/// from `astryx_ui` and nothing else, which makes it the largest single
/// specimen on the site: if the hero, the cards or the footer are awkward to
/// build, that is a fact about the package rather than about this file.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/issue_links.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:flutter/widgets.dart';

/// Where the package lives, for the header, the hero and the footer.
const String pubUrl = 'https://pub.dev/packages/astryx_ui';

/// The repository.
///
/// From `docs/issue_links.dart`, which builds the per-page issue links off the
/// same value: two spellings of the repository is one typo away from a footer
/// that points somewhere else than the pages do.
const String repoUrl = astryxRepoUrl;

/// The design system this one tracks.
const String upstreamUrl = astryxUpstreamUrl;

/// The site's front page.
class DocsLanding extends StatelessWidget {
  /// Creates the landing page.
  const DocsLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing6),
        vertical: theme.spacing(AstryxSpacingToken.spacing8),
      ),
      child: const AstryxCenter(
        axis: AstryxCenterAxis.horizontal,
        maxWidth: 1080,
        padding: AstryxSpacingToken.spacing0,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing12,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            _Hero(),
            _Counts(),
            _Features(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

/// What this is, and the two things to do about it.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    return AstryxCenter(
      maxWidth: 760,
      padding: AstryxSpacingToken.spacing0,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxBadge(
            'Pre-alpha · 0.0.6-dev',
            variant: AstryxBadgeVariant.info,
            icon: AstryxIcon(AstryxIconName.info),
          ),
          // `display1` for the size and `level: 1` for the outline. They are
          // two different jobs, and reaching for a bigger level to get a
          // bigger size is how a page ends up with three h1s.
          const AstryxHeading(
            'astryx_ui',
            level: 1,
            type: AstryxHeadingType.display1,
            justify: AstryxTextJustify.center,
          ),
          const AstryxText(
            'A Flutter design system for internal tools, token-compatible '
            'with Astryx. Built on flutter/widgets, not Material: every '
            'colour, gap, radius and duration comes from one token layer, and '
            'every control brings its own accessible name.',
            type: AstryxTextType.large,
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          // One primary action. Two primaries side by side is a question, not
          // a recommendation.
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              AstryxButton(
                label: 'Get started',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.lg,
                onPressed: () => controller.pageId = 'installation',
              ),
              AstryxButton(
                label: 'Browse components',
                size: AstryxButtonSize.lg,
                onPressed: () => controller.pageId = 'button',
              ),
            ],
          ),
          const _HeroMeta(),
        ],
      ),
    );
  }
}

/// The line under the buttons: where the package is, and what it ports.
class _HeroMeta extends StatelessWidget {
  const _HeroMeta();

  @override
  Widget build(BuildContext context) {
    final delegate = AstryxLinkDelegate.of(context);

    // A wrapping row rather than a `Text.rich`: `AstryxLink.span` builds a
    // body-sized link, and these have to match the supporting-sized text they
    // sit between. A row also wraps on a phone, which a rich paragraph of
    // widget spans does less predictably.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing1,
      justify: AstryxStackJustify.center,
      children: <Widget>[
        for (final link in const <({String label, String url})>[
          (label: 'pub.dev', url: pubUrl),
          (label: 'GitHub', url: repoUrl),
          (label: 'Upstream Astryx', url: upstreamUrl),
        ])
          AstryxLink(
            link.label,
            external: true,
            type: AstryxTextType.supporting,
            onPressed: () => delegate.followLink(Uri.parse(link.url)),
          ),
      ],
    );
  }
}

/// Four numbers, counted from the registry rather than typed here.
///
/// A landing page that claims a component count is a landing page that is
/// wrong by the next release. These come from `docPages`, so the only way for
/// them to be out of date is for the site itself to be.
class _Counts extends StatelessWidget {
  const _Counts();

  static const Set<String> _componentGroups = <String>{
    DocGroup.layout,
    DocGroup.actions,
    DocGroup.forms,
    DocGroup.dateTime,
    DocGroup.status,
    DocGroup.overlays,
    DocGroup.surfaces,
    DocGroup.dataDisplay,
    DocGroup.navigation,
    DocGroup.appShell,
    DocGroup.media,
    DocGroup.commandSearch,
    DocGroup.chat,
    DocGroup.providers,
  };

  static int _written(bool Function(DocPage page) where) =>
      docPages.where((page) => page.isWritten && where(page)).length;

  @override
  Widget build(BuildContext context) {
    final counts = <({String figure, String label})>[
      (
        figure: '${_written((page) => _componentGroups.contains(page.group))}',
        label: 'components',
      ),
      (
        figure: '${_written((page) => page.group == DocGroup.templates)}',
        label: 'whole screens',
      ),
      (figure: '${DocsTheme.values.length}', label: 'themes, two brightnesses'),
      (figure: '0', label: 'Material widgets'),
    ];

    // A grid is right here and wrong for the feature cards below: these cells
    // are text and figures, and a grid gives every cell in a row the height of
    // the tallest — which needs an intrinsic measurement no interactive widget
    // can answer in touch density.
    return AstryxGrid(
      minWidth: 190,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final count in counts)
          AstryxCard(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText(
                  count.figure,
                  type: AstryxTextType.display3,
                  tabularNumbers: true,
                ),
                AstryxText(
                  count.label,
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

/// The claim, and the cards that back it up.
class _Features extends StatelessWidget {
  const _Features();

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxCenter(
          maxWidth: 620,
          padding: AstryxSpacingToken.spacing0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxHeading(
                'Start anywhere. Change anything. Ship faster.',
                type: AstryxHeadingType.display3,
                justify: AstryxTextJustify.center,
              ),
              AstryxText(
                'Adopt it a subtree at a time inside the app you already '
                'have. Nothing here asks you to start again.',
                color: AstryxTextColor.secondary,
                justify: AstryxTextJustify.center,
              ),
            ],
          ),
        ),
        // A wrapping row of fixed-width cards rather than an `AstryxGrid`:
        // every card below holds interactive specimens, and a grid measures
        // its cells intrinsically.
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 940
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            final gap = AstryxTheme.of(
              context,
            ).spacing(AstryxSpacingToken.spacing4);
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing4,
              wrap: true,
              runGap: AstryxSpacingToken.spacing4,
              align: AstryxStackAlign.start,
              children: <Widget>[
                for (final card in _cards)
                  SizedBox(width: width, child: _FeatureCard(card: card)),
              ],
            );
          },
        ),
      ],
    );
  }

  static const List<_Feature> _cards = <_Feature>[
    _Feature(
      title: 'One of everything',
      body:
          'Buttons, fields, tables, menus, overlays, chat surfaces. Each one '
          'ships with its keyboard map, its focus behaviour and a required '
          'accessible name.',
      target: 'button',
      specimen: _ControlsSpecimen(),
    ),
    _Feature(
      title: 'Whole screens, not fragments',
      body:
          'Sign-in, settings, dashboards, boards, editors, galleries — each '
          'extracted from a widget that compiles, so the snippet cannot drift '
          'from the screen beside it.',
      target: 'table_template',
      specimen: _TemplateSpecimen(),
    ),
    _Feature(
      title: 'Themes that fit your brand',
      body:
          'Eight built in and an engine for your own. Change the theme in the '
          'bar above and every page on this site moves with it — including '
          'this one.',
      target: 'theming',
      specimen: _ThemeSpecimen(),
    ),
    _Feature(
      title: 'Never a raw colour or a magic number',
      body:
          'Every value resolves through the token layer, so a theme swap is a '
          'theme swap rather than a search-and-replace across your codebase.',
      target: 'tokens',
      specimen: _TokenSpecimen(),
    ),
    _Feature(
      title: 'Honest on a mouse and on a thumb',
      body:
          'Touch grows every tap target to 48 logical pixels and suppresses '
          'hover styling, because hover does not exist there. Nothing is ever '
          'behind it.',
      target: 'density',
      specimen: _DensitySpecimen(),
    ),
    _Feature(
      title: 'A design system your agent can use',
      body:
          'A generated skill ships in the repository: every component, every '
          'enum, and the rules that are not guessable from the API.',
      target: 'working_with_ai',
      specimen: _AgentSpecimen(),
    ),
  ];
}

/// One feature: what it is, why, a way in, and something to look at.
class _Feature {
  const _Feature({
    required this.title,
    required this.body,
    required this.target,
    required this.specimen,
  });

  final String title;
  final String body;

  /// The page id **Explore** opens.
  final String target;

  /// A live piece of the package, built from the theme in force.
  final Widget specimen;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.card});

  final _Feature card;

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    // Not a pressable card. It holds controls, and a button inside a button is
    // a tap target nobody can predict — so the way in is one explicit link.
    return AstryxCard(
      header: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxHeading(card.title, level: 3),
          AstryxText(
            card.body,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxButton(
            label: 'Explore',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            trailing: const AstryxIcon(
              AstryxIconName.chevronRight,
              size: AstryxIconSize.sm,
            ),
            onPressed: () => controller.pageId = card.target,
          ),
        ],
      ),
      child: card.specimen,
    );
  }
}

/// A specimen sits on the muted ground, so it reads as an exhibit rather than
/// as part of the card's own content.
class _Exhibit extends StatelessWidget {
  const _Exhibit({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      variant: AstryxCardVariant.muted,
      padding: AstryxSpacingToken.spacing3,
      minHeight: 132,
      child: child,
    );
  }
}

class _ControlsSpecimen extends StatefulWidget {
  const _ControlsSpecimen();

  @override
  State<_ControlsSpecimen> createState() => _ControlsSpecimenState();
}

class _ControlsSpecimenState extends State<_ControlsSpecimen> {
  bool _on = true;
  bool _ticked = true;

  @override
  Widget build(BuildContext context) {
    // Real controls, not a picture of them. Every one of these is reachable by
    // keyboard from this page.
    return _Exhibit(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const AstryxBadge(
                'Shipped',
                variant: AstryxBadgeVariant.success,
                icon: AstryxIcon(AstryxIconName.success),
              ),
              const AstryxBadge('Draft'),
              AstryxCheckbox(
                label: 'Checkbox',
                labelHidden: true,
                value: _ticked,
                onChanged: (value) => setState(() => _ticked = value),
              ),
              AstryxSwitch(
                label: 'Switch',
                labelHidden: true,
                size: AstryxToggleSize.sm,
                value: _on,
                onChanged: (value) => setState(() => _on = value),
              ),
            ],
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Secondary',
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Primary',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          const AstryxTextInput(
            label: 'Search',
            labelHidden: true,
            placeholder: 'Search…',
            size: AstryxInputSize.sm,
            leading: AstryxIcon(
              AstryxIconName.search,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateSpecimen extends StatelessWidget {
  const _TemplateSpecimen();

  @override
  Widget build(BuildContext context) {
    return const _Exhibit(
      child: AstryxList(
        label: 'A few of the templates',
        density: AstryxItemDensity.compact,
        showDividers: true,
        children: <Widget>[
          AstryxItem(
            label: 'Table page',
            description: 'Filters pinned above, pagination below',
            trailing: AstryxBadge('42 in all'),
          ),
          AstryxItem(
            label: 'AI chat',
            description: 'Transcript, tool calls, citations',
          ),
          AstryxItem(
            label: 'Kanban board',
            description: 'Drag, and a move menu that works without one',
          ),
        ],
      ),
    );
  }
}

class _ThemeSpecimen extends StatelessWidget {
  const _ThemeSpecimen();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    const swatches = <AstryxColorToken>[
      AstryxColorToken.accent,
      AstryxColorToken.success,
      AstryxColorToken.warning,
      AstryxColorToken.error,
      AstryxColorToken.backgroundCard,
      AstryxColorToken.border,
    ];

    return _Exhibit(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              for (final token in swatches)
                // The colour *is* the content here, so nothing sits between
                // the token and the reader's eye — and it still comes from
                // `theme.color`, which is why this specimen is correct in all
                // eight themes and both brightnesses.
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.color(token),
                    borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
                    border: Border.all(
                      color: theme.color(AstryxColorToken.border),
                    ),
                  ),
                  child: const SizedBox(width: 40, height: 32),
                ),
            ],
          ),
          const AstryxText(
            'Neutral · Matcha · Stone · Gothic · Chocolate · Y2K · Butter, '
            'and defineTheme for yours.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}

class _TokenSpecimen extends StatelessWidget {
  const _TokenSpecimen();

  @override
  Widget build(BuildContext context) {
    return const _Exhibit(
      child: AstryxCodeBlock('''
final theme = AstryxTheme.of(context);

theme.color(AstryxColorToken.accent);
theme.spacing(AstryxSpacingToken.spacing3);
theme.borderRadius(AstryxRadiusToken.container);''', language: 'dart'),
    );
  }
}

class _DensitySpecimen extends StatelessWidget {
  const _DensitySpecimen();

  @override
  Widget build(BuildContext context) {
    final density = AstryxTheme.densityOf(context);

    return _Exhibit(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxBadge(
                density.supportsHover ? 'Pointer' : 'Touch',
                variant: AstryxBadgeVariant.info,
                icon: const AstryxIcon(AstryxIconName.info),
              ),
              const Flexible(
                child: AstryxText(
                  'Right now, on this device',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const AstryxText(
            'Switch the density in the bar above and every tap target on the '
            'site grows or shrinks. Nothing moves that was not meant to.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}

class _AgentSpecimen extends StatelessWidget {
  const _AgentSpecimen();

  @override
  Widget build(BuildContext context) {
    return const _Exhibit(
      child: AstryxCodeBlock('''
.claude/skills/astryx-ui/
├── SKILL.md          # the rules, and which widget to reach for
└── references/       # every component, every enum''', showCopy: false),
    );
  }
}

/// The way out: where the package lives, and what it is not.
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final delegate = AstryxLinkDelegate.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxDivider(),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxLink(
                  'pub.dev',
                  external: true,
                  type: AstryxTextType.supporting,
                  onPressed: () => delegate.followLink(Uri.parse(pubUrl)),
                ),
                AstryxLink(
                  'GitHub',
                  external: true,
                  type: AstryxTextType.supporting,
                  onPressed: () => delegate.followLink(Uri.parse(repoUrl)),
                ),
                AstryxLink(
                  'Upstream Astryx',
                  external: true,
                  type: AstryxTextType.supporting,
                  onPressed: () => delegate.followLink(Uri.parse(upstreamUrl)),
                ),
                AstryxButton(
                  label: 'Changelog',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () => controller.pageId = 'changelog',
                ),
              ],
            ),
            // No `Flexible` here: the row wraps, and a `Wrap` takes different
            // parent data — a flex child inside one is an error rather than a
            // layout.
            const AstryxText(
              'An independent implementation. MIT licensed.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ],
    );
  }
}
