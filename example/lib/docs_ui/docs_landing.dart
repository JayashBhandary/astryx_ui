/// The page the site opens on.
///
/// A documentation site is not only a reference — somebody arriving from a
/// search result, a package page or a link in a pull request has one question
/// first, and it is *what is this and should I use it*. The sidebar cannot
/// answer that: it is two hundred rows of things you would only look up once
/// you had already decided.
///
/// So the front door is its own screen, and it answers in this order: what it
/// is, where to get it, how much of it there is, what it feels like, how to
/// install it, what shipped lately, and what it will not do.
///
/// **Most of the words are not written here.** The claims, the install
/// commands, the limitations and the agent section come from `README.md`
/// through `readme.g.dart`, and the release summary comes from `CHANGELOG.md`
/// through `changelog.g.dart`. A landing page that paraphrases those files is a
/// third copy of them, and the third copy is the one nobody updates.
///
/// Like everything else here it is built from `astryx_ui` and nothing else,
/// which makes it the largest single specimen on the site: if the hero, the
/// cards or the footer are awkward to build, that is a fact about the package
/// rather than about this file.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/changelog.g.dart';
import 'package:example/docs/issue_links.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs/readme.g.dart';
import 'package:example/docs/version.g.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/doc_blocks.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

/// The one line that installs it.
///
/// Built from the generated version rather than typed, because an install
/// command quoting last release's version is worse than no install command:
/// it resolves, and it resolves to the wrong thing.
const String installCommand = 'flutter pub add astryx_ui:^$astryxVersion';

/// The groups whose written pages are components rather than guides, templates
/// or controllers.
const Set<String> _componentGroups = <String>{
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

int _written(bool Function(DocPage page) where) =>
    docPages.where((page) => page.isWritten && where(page)).length;

/// How much of the package there is, counted rather than claimed.
///
/// Every number the page states comes from here, and every one of them is read
/// out of the registry — a figure typed into a landing page is wrong by the
/// next release, and nobody notices until somebody counts.
final ({int components, int templates, int hooks, int themes}) landingCounts = (
  components: _written((page) => _componentGroups.contains(page.group)),
  templates: _written((page) => page.group == DocGroup.templates),
  hooks: _written((page) => page.group == DocGroup.hooks),
  // The themes the *package* ships. The site's picker carries one more —
  // `acme`, defined in `lib/examples/theming_examples.dart` to prove the engine
  // works — and counting it here would promise an eighth theme on install.
  themes: DocsTheme.values.where((theme) => theme != DocsTheme.acme).length,
);

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
      child: const _Measure(
        maxWidth: 1080,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing12,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            _Hero(),
            _Destinations(),
            _Counts(),
            _WhatYouGet(),
            _Features(),
            _WhyNotMaterial(),
            _Install(),
            _WhatsNew(),
            _Limits(),
            _ForAgents(),
            _ClosingCall(),
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

  /// The README's opening sentence, which is the same promise pub.dev shows.
  ///
  /// The line after it in the file points at this site, so it is dropped here:
  /// the reader is already on it.
  static final DocProse _tagline = readmeIntro.whereType<DocProse>().first;

  /// The pre-alpha note, from the README's own block quote.
  static final List<DocCallout> _status = readmeIntro
      .whereType<DocCallout>()
      .toList();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    return _Measure(
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxBadge(
            'Pre-alpha · $astryxVersion',
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
          DocsInlineText(
            _tagline.text,
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
                label: 'Browse ${landingCounts.components} components',
                size: AstryxButtonSize.lg,
                onPressed: () => controller.pageId = 'button',
              ),
            ],
          ),
          // The command, this high up, because the question under "should I
          // use it" is "how much work is finding out". It is one line, and it
          // copies itself.
          const _InstallLine(),
          for (final status in _status)
            docsBlock(context, status, (target) => docsFollow(context, target)),
        ],
      ),
    );
  }
}

/// The install command, with the copy button the docs' code blocks carry.
class _InstallLine extends StatelessWidget {
  const _InstallLine();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 480,
    child: DocsCodeBlock(source: installCommand, language: 'sh'),
  );
}

/// Where to get it: the three links that leave this site, at the size they are
/// actually worth.
///
/// They used to be a row of supporting-sized links under the hero buttons —
/// the two destinations a first-time reader most often wants, drawn at the size
/// this page uses for footnotes. A card each: the glyph makes them findable
/// while scrolling, the sentence says what is on the other side, and the whole
/// card is the tap target rather than eleven characters of text.
class _Destinations extends StatelessWidget {
  const _Destinations();

  @override
  Widget build(BuildContext context) {
    return const _CardRow(
      children: <Widget>[
        _DestinationCard(
          glyph: LucideIcons.package,
          title: 'Get it from pub.dev',
          body:
              'Version $astryxVersion · MIT · Dart 3.9 and Flutter 3.35 or '
              'newer. One dependency, and no companion plugin.',
          host: 'pub.dev/packages/astryx_ui',
          url: pubUrl,
          emphasis: true,
        ),
        _DestinationCard(
          glyph: LucideIcons.gitBranch,
          title: 'Read the source on GitHub',
          body:
              'Every widget, the theme engine, the tests it is verified '
              'against, and the issue tracker that decides what is built next.',
          host: 'github.com/JayashBhandary/astryx_ui',
          url: repoUrl,
        ),
        _DestinationCard(
          glyph: LucideIcons.blocks,
          title: 'See upstream Astryx',
          body:
              'Meta’s React + StyleX design system, whose token values this '
              'one reproduces in Dart.',
          host: 'astryx.atmeta.com',
          url: upstreamUrl,
        ),
      ],
    );
  }
}

/// One destination: a glyph, what it is, and where it goes.
class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.glyph,
    required this.title,
    required this.body,
    required this.host,
    required this.url,
    this.emphasis = false,
  });

  /// Lucide, reached directly rather than through `AstryxIconName`.
  ///
  /// That enum is a transcription of upstream's `IconName` union; widening it
  /// so this page can draw a parcel and a branch would make the package's icon
  /// set a catalogue of whatever the documentation site needed. The same
  /// decision, and the same reasoning, as the width switch in `example_block`.
  final IconData glyph;

  final String title;
  final String body;

  /// The host, shown so the reader knows where the card goes before pressing.
  final String host;

  final String url;

  /// Whether this is the one the page would rather you pressed.
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final delegate = AstryxLinkDelegate.of(context);

    return AstryxCard(
      variant: emphasis
          ? AstryxCardVariant.standard
          : AstryxCardVariant.transparent,
      elevation: emphasis ? AstryxElevation.low : AstryxElevation.none,
      padding: AstryxSpacingToken.spacing5,
      minHeight: 200,
      // The card is the button, so the name has to carry what a sighted reader
      // gets from the glyph and the host line — including that it leaves.
      semanticsLabel: '$title. Opens $host in a new tab.',
      onPressed: () => delegate.followLink(Uri.parse(url)),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.color(
                emphasis
                    ? AstryxColorToken.accentMuted
                    : AstryxColorToken.backgroundMuted,
              ),
              borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                theme.spacing(AstryxSpacingToken.spacing3),
              ),
              child: Icon(
                glyph,
                size: 24,
                color: theme.color(
                  emphasis
                      ? AstryxColorToken.textAccent
                      : AstryxColorToken.textPrimary,
                ),
              ),
            ),
          ),
          AstryxHeading(title, level: 3),
          DocsInlineText(
            body,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              Flexible(
                child: AstryxText(
                  host,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.accent,
                  maxLines: 1,
                ),
              ),
              const AstryxIcon(
                AstryxIconName.externalLink,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// How much of it there is, counted from the registry rather than typed here.
///
/// A landing page that claims a component count is a landing page that is
/// wrong by the next release. These come from `docPages`, so the only way for
/// them to be out of date is for the site itself to be.
class _Counts extends StatelessWidget {
  const _Counts();

  @override
  Widget build(BuildContext context) {
    final counts = <({String figure, String label})>[
      (figure: '${landingCounts.components}', label: 'components'),
      (figure: '${landingCounts.templates}', label: 'whole screens'),
      (figure: '${landingCounts.hooks}', label: 'controllers and mixins'),
      (figure: '${landingCounts.themes}', label: 'themes, light and dark'),
      (figure: '0', label: 'Material widgets'),
    ];

    // A grid is right here and wrong for the feature cards below: these cells
    // are text and figures, and a grid gives every cell in a row the height of
    // the tallest — which needs an intrinsic measurement no interactive widget
    // can answer in touch density.
    return AstryxGrid(
      minWidth: 180,
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
    return _Section(
      title: 'Start anywhere. Change anything. Ship faster.',
      blurb:
          'Adopt it a subtree at a time inside the app you already have. '
          'Nothing here asks you to start again.',
      centred: true,
      child: _CardRow(
        children: <Widget>[
          for (final card in _cards) _FeatureCard(card: card),
        ],
      ),
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
          'Seven built in and an engine for your own. Change the theme in the '
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

/// What arrives with the dependency, in the README's own words.
class _WhatYouGet extends StatelessWidget {
  const _WhatYouGet();

  @override
  Widget build(BuildContext context) => const _ReadmeSection(
    section: 'What you get',
    title: 'What arrives with the dependency',
    blurb:
        'One package. No companion plugin, no code generation step, no theme '
        'you have to build before the first screen.',
  );
}

/// The objection this package exists to answer.
class _WhyNotMaterial extends StatelessWidget {
  const _WhyNotMaterial();

  @override
  Widget build(BuildContext context) => const _ReadmeSection(
    section: 'Why not Material',
    title: 'Why not just use Material?',
  );
}

/// How to install it, and the whole of the setup.
class _Install extends StatelessWidget {
  const _Install();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Two blocks of code to the first screen',
      blurb:
          'Add the dependency, wrap the app once. Toasts, tooltips, dialogs '
          'and focus rings all work from there with nothing else to wire.',
      child: _Measure(
        centred: false,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            _Blocks(blocks: readmeSections['Install'] ?? const <DocBlock>[]),
            _Blocks(blocks: readmeSections['Setup'] ?? const <DocBlock>[]),
            const _GuideLinks(),
          ],
        ),
      ),
    );
  }
}

/// The three guides somebody who has just installed it reads next.
class _GuideLinks extends StatelessWidget {
  const _GuideLinks();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final guide in const <({String label, String id})>[
          (label: 'Installation', id: 'installation'),
          (label: 'Theming', id: 'theming'),
          (label: 'Tokens', id: 'tokens'),
          (label: 'Density', id: 'density'),
          (label: 'Accessibility', id: 'accessibility'),
        ])
          if (docPageOrNull(guide.id) != null)
            AstryxButton(
              label: guide.label,
              size: AstryxButtonSize.sm,
              trailing: const AstryxIcon(
                AstryxIconName.chevronRight,
                size: AstryxIconSize.sm,
              ),
              onPressed: () => controller.pageId = guide.id,
            ),
      ],
    );
  }
}

/// What shipped lately, read out of the changelog rather than announced here.
class _WhatsNew extends StatelessWidget {
  const _WhatsNew();

  /// The newest release's name, its summary, and the first few entries.
  ///
  /// `changelogBlocks` is the parsed `CHANGELOG.md`, newest first, so this is
  /// a walk from the top rather than a search: the first heading is the
  /// release, the prose under it is the summary, and the first list is what
  /// was added.
  static ({String release, String? summary, List<String> items}) get _latest {
    String? release;
    String? summary;
    var items = const <String>[];

    for (final block in changelogBlocks) {
      switch (block) {
        case DocHeading(:final text, level: 2) when release == null:
          release = text;
        case DocHeading(level: 2):
          return (release: release!, summary: summary, items: items);
        case DocProse(:final text) when summary == null:
          summary = text;
        case DocList(items: final entries) when items.isEmpty:
          items = entries.take(3).toList();
        case _:
          break;
      }
    }

    return (release: release ?? 'Unreleased', summary: summary, items: items);
  }

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final latest = _latest;

    return _Section(
      title: 'What shipped lately',
      blurb:
          'Read out of `CHANGELOG.md`, so the front page cannot be a release '
          'behind the package.',
      child: AstryxCard(
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxBadge(
              latest.release,
              // A version number is something that shipped; `Unreleased` is
              // what is on `main` and not on pub yet, and a green tick over it
              // would say otherwise.
              variant: latest.release.toLowerCase() == 'unreleased'
                  ? AstryxBadgeVariant.info
                  : AstryxBadgeVariant.success,
              icon: AstryxIcon(
                latest.release.toLowerCase() == 'unreleased'
                    ? AstryxIconName.info
                    : AstryxIconName.success,
              ),
            ),
            AstryxButton(
              label: 'Read the changelog',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              trailing: const AstryxIcon(
                AstryxIconName.chevronRight,
                size: AstryxIconSize.sm,
              ),
              onPressed: () => controller.pageId = 'changelog',
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            if (latest.summary case final String summary)
              DocsInlineText(summary, color: AstryxTextColor.secondary),
            if (latest.items.isNotEmpty)
              _Blocks(
                blocks: <DocBlock>[DocList(latest.items)],
                gap: AstryxSpacingToken.spacing3,
              ),
          ],
        ),
      ),
    );
  }
}

/// The limitations, stated where somebody deciding can still act on them.
class _Limits extends StatelessWidget {
  const _Limits();

  @override
  Widget build(BuildContext context) => const _ReadmeSection(
    section: 'What is not in 1.0',
    title: 'What it will not do',
    blurb:
        'The list worth reading before you adopt anything. It is the same '
        'list the README carries, and every widget repeats its own in its doc '
        'comment.',
  );
}

/// The agent skill, which is a reason to install this one over another.
class _ForAgents extends StatelessWidget {
  const _ForAgents();

  @override
  Widget build(BuildContext context) => const _ReadmeSection(
    section: 'For AI coding agents',
    title: 'Your coding agent gets the manual too',
    blurb:
        'A design system an agent guesses at is a design system that produces '
        'plausible code which does not compile.',
  );
}

/// The last thing on the page, and the one thing to do about it.
class _ClosingCall extends StatelessWidget {
  const _ClosingCall();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final delegate = AstryxLinkDelegate.of(context);

    // The page's second `primary`, and the only other one. It is a screen and
    // a half below the hero's, which is the case the one-primary rule is not
    // about: a reader who has scrolled this far has left the first one behind.
    return AstryxCard(
      variant: AstryxCardVariant.muted,
      padding: AstryxSpacingToken.spacing8,
      child: _Measure(
        maxWidth: 640,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.center,
          children: <Widget>[
            const AstryxHeading(
              'Install it and see',
              type: AstryxHeadingType.display3,
              justify: AstryxTextJustify.center,
            ),
            const AstryxText(
              'One dependency and one wrapper widget, and the screen you were '
              'going to spend a week styling is already designed — in seven '
              'themes, light and dark, on a mouse and on a thumb.',
              color: AstryxTextColor.secondary,
              justify: AstryxTextJustify.center,
            ),
            const _InstallLine(),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.center,
              children: <Widget>[
                AstryxButton(
                  label: 'Get it on pub.dev',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.lg,
                  trailing: const AstryxIcon(AstryxIconName.externalLink),
                  onPressed: () => delegate.followLink(Uri.parse(pubUrl)),
                ),
                AstryxButton(
                  label: 'Star it on GitHub',
                  size: AstryxButtonSize.lg,
                  trailing: const AstryxIcon(AstryxIconName.externalLink),
                  onPressed: () => delegate.followLink(Uri.parse(repoUrl)),
                ),
                AstryxButton(
                  label: 'Read the installation guide',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.lg,
                  onPressed: () => controller.pageId = 'installation',
                ),
              ],
            ),
          ],
        ),
      ),
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

// ---------------------------------------------------------------------------
// The furniture the sections are built from
// ---------------------------------------------------------------------------

/// A titled section of the page.
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.blurb,
    this.centred = false,
  });

  final String title;

  /// A line under the title. Inline markup is understood.
  final String? blurb;

  final Widget child;

  /// Whether the heading and blurb are centred over the content.
  final bool centred;

  @override
  Widget build(BuildContext context) {
    final heading = AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: centred ? AstryxStackAlign.center : AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHeading(
          title,
          type: AstryxHeadingType.display3,
          justify: centred ? AstryxTextJustify.center : null,
        ),
        if (blurb case final String blurb)
          DocsInlineText(
            blurb,
            color: AstryxTextColor.secondary,
            justify: centred ? AstryxTextJustify.center : null,
          ),
      ],
    );

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        _Measure(
          maxWidth: centred ? 620 : 760,
          centred: centred,
          child: heading,
        ),
        child,
      ],
    );
  }
}

/// Centres [child] and holds it to a readable measure.
///
/// Not `AstryxCenter(maxWidth:)`, which cannot do this job here: it puts its
/// `ConstrainedBox` *outside* the `Align`, and a `ConstrainedBox` handed tight
/// constraints — which is exactly what a scroll view's cross axis hands down —
/// is enforced away to the parent's width. The `Align` has to come first, so
/// that what it gives the box below is loose.
class _Measure extends StatelessWidget {
  const _Measure({
    required this.child,
    this.maxWidth = 760,
    this.centred = true,
  });

  final Widget child;
  final double maxWidth;

  /// Whether the measured column sits in the middle of the page.
  ///
  /// False for a section that sits above full-width cards: a column centred
  /// over a wider one below it reads as an indent nobody asked for, and the
  /// eye follows the left edge rather than the middle.
  final bool centred;

  @override
  Widget build(BuildContext context) => Align(
    alignment: centred
        ? AlignmentDirectional.topCenter
        : AlignmentDirectional.topStart,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

/// A section of the page whose body is a section of the README.
class _ReadmeSection extends StatelessWidget {
  const _ReadmeSection({
    required this.section,
    required this.title,
    this.blurb,
  });

  /// The README heading to render under it.
  final String section;

  final String title;
  final String? blurb;

  @override
  Widget build(BuildContext context) {
    final blocks = readmeSections[section] ?? const <DocBlock>[];
    if (blocks.isEmpty) return const SizedBox.shrink();

    return _Section(
      title: title,
      blurb: blurb,
      // The measure prose is comfortable at. Wider than this and a reader
      // loses the start of the next line; the cards above take the full 1080,
      // because a card is not a paragraph.
      child: _Measure(centred: false, child: _Blocks(blocks: blocks)),
    );
  }
}

/// Documentation blocks, wired to this page's navigation.
class _Blocks extends StatelessWidget {
  const _Blocks({
    required this.blocks,
    this.gap = AstryxSpacingToken.spacing4,
  });

  final List<DocBlock> blocks;
  final AstryxSpacingToken gap;

  @override
  Widget build(BuildContext context) => DocsBlocks(
    blocks: blocks,
    gap: gap,
    onNavigate: (target) => docsFollow(context, target),
  );
}

/// A wrapping row of equal-width cards.
///
/// Not an `AstryxGrid`: the feature cards hold interactive specimens, and a
/// grid measures its cells intrinsically — which no interactive widget can
/// answer in touch density.
class _CardRow extends StatelessWidget {
  const _CardRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 940
            ? 3
            : constraints.maxWidth >= 640
            ? 2
            : 1;
        final gap = AstryxTheme.of(
          context,
        ).spacing(AstryxSpacingToken.spacing4);
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          wrap: true,
          runGap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.start,
          children: <Widget>[
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// The specimens
// ---------------------------------------------------------------------------

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
    return _Exhibit(
      child: AstryxList(
        label: 'A few of the templates',
        density: AstryxItemDensity.compact,
        showDividers: true,
        children: <Widget>[
          AstryxItem(
            label: 'Table page',
            description: 'Filters pinned above, pagination below',
            trailing: AstryxBadge('${landingCounts.templates} in all'),
          ),
          const AstryxItem(
            label: 'AI chat',
            description: 'Transcript, tool calls, citations',
          ),
          const AstryxItem(
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
