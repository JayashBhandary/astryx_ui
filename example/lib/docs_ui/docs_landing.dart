/// The page the site opens on, laid out after upstream's front page
/// (astryx.atmeta.com): a themed hero with the wordmark, a bento of what the
/// package is, why it exists, what shipped lately, and one last call to act.
///
/// Like everything else here it is built from `astryx_ui` and nothing else,
/// which makes it the largest single specimen on the site. Every number on it
/// is counted from the page registry, the release notes come from
/// `CHANGELOG.md` through `changelog.g.dart`, and the install command is built
/// from the generated version — a landing page that types any of those is
/// wrong by the next release.
library;

import 'dart:async';

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/changelog.g.dart';
import 'package:example/docs/issue_links.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs/previews.g.dart';
import 'package:example/docs/version.g.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/studio_showcase.dart';
import 'package:example/docs_ui/svg_mark.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Where the package lives, for the hero and the footer.
const String pubUrl = 'https://pub.dev/packages/astryx_ui';

/// The repository. From `docs/issue_links.dart`, which builds the per-page
/// issue links off the same value.
const String repoUrl = astryxRepoUrl;

/// The design system this one tracks.
const String upstreamUrl = astryxUpstreamUrl;

/// The agent skill that ships in the repository.
const String agentSkillUrl = '$repoUrl/tree/main/.claude/skills/astryx-ui';

/// The one line that installs it, built from the generated version.
const String installCommand = 'flutter pub add astryx_ui:^$astryxVersion';

/// The groups whose written pages are components rather than guides,
/// templates or controllers.
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
final ({int components, int templates, int hooks, int themes}) landingCounts = (
  components: _written((page) => _componentGroups.contains(page.group)),
  templates: _written((page) => page.group == DocGroup.templates),
  hooks: _written((page) => page.group == DocGroup.hooks),
  // The themes the *package* ships; `acme` is the site's own engine demo.
  themes: DocsTheme.values.where((theme) => theme != DocsTheme.acme).length,
);

/// The themes the hero cycles through, with the product each slide shows.
const List<(DocsTheme, int)> landingHeroSlides = <(DocsTheme, int)>[
  (DocsTheme.matcha, 0),
  (DocsTheme.butter, 1),
  (DocsTheme.y2k, 2),
  (DocsTheme.gothic, 3),
  (DocsTheme.neutral, 4),
];

/// Template pages shown as thumbnails, in order of how well they read small.
const List<String> landingTemplateIds = <String>[
  'gallery_hero',
  'table_page',
  'login_split',
  'settings_sidebar',
  'ai_chat',
  'product_detail',
];

/// The widest the page's sections grow.
const double _pageWidth = 1200;

/// The site's front page.
class DocsLanding extends StatelessWidget {
  /// Creates the landing page.
  const DocsLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final side = theme.spacing(AstryxSpacingToken.spacing6);

    Widget section(Widget child) => Padding(
      padding: EdgeInsets.symmetric(horizontal: side),
      child: _Measure(maxWidth: _pageWidth, child: child),
    );

    return AstryxVStack(
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const LandingHero(),
        SizedBox(height: theme.spacing(AstryxSpacingToken.spacing12)),
        section(const _Bento()),
        const _Gap(),
        section(const _Pillars()),
        const _Gap(),
        section(const _WhatsNew()),
        const _Gap(),
        section(const _ClosingCall()),
        const _Gap(),
        section(const _Footer()),
        SizedBox(height: theme.spacing(AstryxSpacingToken.spacing6)),
      ],
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: AstryxTheme.of(context).spacing(AstryxSpacingToken.spacing12) * 2,
  );
}

// ---------------------------------------------------------------------------
// Hero
// ---------------------------------------------------------------------------

/// The wordmark, the promise, two actions — painted in a theme that changes
/// every few seconds, with product cards floating either side.
class LandingHero extends StatefulWidget {
  /// Creates the hero.
  const LandingHero({super.key});

  /// How long each theme stays up.
  static const Duration slideDuration = Duration(seconds: 6);

  /// At and above this width the floating cards show.
  static const double floatingWidth = 1180;

  /// At and above this width the corner cards show as well.
  static const double cornersWidth = 1480;

  /// The site's top nav, which the full-screen hero sits under.
  static const double navHeight = 56;

  /// The shortest the hero gets once the cards float.
  static const double minFloatingHeight = 820;

  @override
  State<LandingHero> createState() => _LandingHeroState();
}

class _LandingHeroState extends State<LandingHero> {
  int _slide = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  void _restart() {
    _timer?.cancel();
    _timer = Timer.periodic(LandingHero.slideDuration, (_) {
      if (mounted) {
        setState(() => _slide = (_slide + 1) % landingHeroSlides.length);
      }
    });
  }

  void _go(int index) {
    setState(() => _slide = index);
    _restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final site = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final dark = site.mode == AstryxThemeMode.dark;
    final (docsTheme, product) = landingHeroSlides[_slide];

    return AstryxThemeProvider(
      theme: docsTheme.theme,
      mode: dark ? AstryxColorMode.dark : AstryxColorMode.light,
      density: controller.density,
      child: Builder(
        builder: (context) {
          final theme = AstryxTheme.of(context);
          final accent = theme.color(AstryxColorToken.accent);
          final body = theme.color(AstryxColorToken.backgroundBody);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: body,
              gradient: RadialGradient(
                center: const Alignment(0.55, 1.1),
                radius: 1.1,
                colors: <Color>[
                  accent.withValues(alpha: dark ? 0.28 : 0.22),
                  body.withValues(alpha: 0),
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final floating = width >= LandingHero.floatingWidth;
                final centre = Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing(AstryxSpacingToken.spacing6),
                    // A full-screen hero centres the copy itself.
                    vertical: floating
                        ? theme.spacing(AstryxSpacingToken.spacing6)
                        : theme.spacing(AstryxSpacingToken.spacing12) * 2,
                  ),
                  child: _HeroCopy(
                    slide: _slide,
                    onSlide: _go,
                    wordmarkHeight: width < 600 ? 52 : 96,
                  ),
                );
                if (!floating) return centre;

                // Fill the window below the top nav, never less than the
                // floating cards need.
                final height = (MediaQuery.sizeOf(context).height -
                        LandingHero.navHeight)
                    .clamp(LandingHero.minFloatingHeight, double.infinity);
                // The corner cards only fit once the copy has room beside them.
                final corners = width >= LandingHero.cornersWidth;
                // The low cards sit under the copy, between the side columns.
                final low = corners && height >= 860;

                final item = studioProducts[product % studioProducts.length];
                final next =
                    studioProducts[(product + 1) % studioProducts.length];
                Widget swap(Widget child) =>
                    _FadeSwap(id: _slide, child: child);

                return SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Align(
                        alignment: Alignment(0, low ? -0.45 : -0.3),
                        child: centre,
                      ),
                      if (corners) ...<Widget>[
                        Positioned(
                          left: 32,
                          top: 40,
                          child: swap(const _HeroSettingsCard()),
                        ),
                        Positioned(
                          right: 32,
                          top: 40,
                          child: swap(const _HeroTeamCard()),
                        ),
                      ],
                      Positioned(
                        left: 24,
                        bottom: 24,
                        child: swap(_HeroLeftCards(product: item)),
                      ),
                      Positioned(
                        right: 24,
                        bottom: 24,
                        child: swap(_HeroRightCards(product: next)),
                      ),
                      if (low) ...<Widget>[
                        Positioned(
                          left: width * 0.5 - 340,
                          bottom: 48,
                          child: swap(const _HeroControlsCard()),
                        ),
                        Positioned(
                          right: width * 0.5 - 340,
                          bottom: 72,
                          child: swap(_HeroToastCard(product: item)),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Cross-fades a slide's cards when the theme changes.
class _FadeSwap extends StatelessWidget {
  const _FadeSwap({required this.id, required this.child});

  final int id;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    child: KeyedSubtree(key: ValueKey<int>(id), child: child),
  );
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.slide,
    required this.onSlide,
    required this.wordmarkHeight,
  });

  final int slide;
  final ValueChanged<int> onSlide;
  final double wordmarkHeight;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final delegate = AstryxLinkDelegate.of(context);
    final narrow = wordmarkHeight < 60;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.center,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: FittedBox(
            key: ValueKey<int>(slide),
            fit: BoxFit.scaleDown,
            child: DocsSvgWordmark(
              color: theme.color(AstryxColorToken.accent),
              height: wordmarkHeight,
              semanticsLabel: 'Astryx',
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: AstryxVStack(
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxText(
                "A Flutter design system that's",
                type: narrow
                    ? AstryxTextType.display3
                    : AstryxTextType.display2,
                weight: AstryxTextWeight.normal,
                justify: AstryxTextJustify.center,
              ),
              AstryxHeading(
                'fully customizable and agent ready',
                level: 1,
                type: narrow
                    ? AstryxHeadingType.display3
                    : AstryxHeadingType.display2,
                justify: AstryxTextJustify.center,
              ),
            ],
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: AstryxButton(
                label: 'Get started',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.lg,
                onPressed: () => controller.pageId = 'installation',
              ),
            ),
            SizedBox(
              width: 200,
              child: AstryxButton(
                label: 'Browse components',
                size: AstryxButtonSize.lg,
                onPressed: controller.goComponents,
              ),
            ),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing1,
          wrap: true,
          runGap: AstryxSpacingToken.spacing1,
          justify: AstryxStackJustify.center,
          children: <Widget>[
            const AstryxText(
              'Pre-alpha · $astryxVersion · Built on',
              type: AstryxTextType.supporting,
            ),
            AstryxLink(
              'Flutter 3.35+',
              type: AstryxTextType.supporting,
              onPressed: () =>
                  delegate.followLink(Uri.parse('https://flutter.dev')),
            ),
            const AstryxText('and', type: AstryxTextType.supporting),
            AstryxLink(
              'Dart 3.9',
              type: AstryxTextType.supporting,
              onPressed: () =>
                  delegate.followLink(Uri.parse('https://dart.dev')),
            ),
          ],
        ),
        _Dots(count: landingHeroSlides.length, index: slide, onTap: onSlide),
      ],
    );
  }
}

/// The slide indicator: the current one a pill, the rest rings.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, required this.onTap});

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final ink = theme.color(AstryxColorToken.textPrimary);

    return Semantics(
      container: true,
      label: 'Hero themes',
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing1,
        children: <Widget>[
          for (var i = 0; i < count; i++)
            Semantics(
              button: true,
              selected: i == index,
              label: 'Show ${landingHeroSlides[i].$1.label}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: i == index ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == index ? ink : null,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ink.withValues(alpha: 0.7)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A floating panel, painted from the slide's theme.
class _Float extends StatelessWidget {
  const _Float({required this.child, this.width, this.padding = 20});

  final Widget child;
  final double? width;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return Container(
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundCard),
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        border: Border.all(color: theme.color(AstryxColorToken.border)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HeroLeftCards extends StatelessWidget {
  const _HeroLeftCards({required this.product});

  final StudioProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox(
          width: 380,
          height: 400,
          child: Stack(
            children: <Widget>[
              const Positioned(
                left: 0,
                top: 0,
                child: AstryxBadge(
                  'Limited time',
                  variant: AstryxBadgeVariant.success,
                ),
              ),
              Positioned(
                left: 0,
                top: 36,
                child: _Float(
                  width: 264,
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxHeading(product.name, level: 3),
                      AstryxText(
                        product.blurb,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: theme.borderRadius(
                          AstryxRadiusToken.element,
                        ),
                        child: StudioProductArt(
                          icon: product.icon,
                          size: 72,
                          height: 190,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 92,
                top: 262,
                child: _Float(
                  width: 280,
                  padding: 16,
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      const AstryxText(
                        'How can I help?',
                        color: AstryxTextColor.secondary,
                      ),
                      AstryxHStack(
                        justify: AstryxStackJustify.between,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          AstryxIconButton.custom(
                            label: 'Add attachment',
                            size: AstryxButtonSize.sm,
                            onPressed: () {},
                            child: const Icon(LucideIcons.plus, size: 16),
                          ),
                          AstryxIconButton.custom(
                            label: 'Send',
                            variant: AstryxButtonVariant.primary,
                            size: AstryxButtonSize.sm,
                            onPressed: () {},
                            child: const Icon(LucideIcons.arrowUp, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroRightCards extends StatelessWidget {
  const _HeroRightCards({required this.product});

  final StudioProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final radius = theme.borderRadius(AstryxRadiusToken.container);

    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox(
          width: 380,
          height: 460,
          child: Stack(
            children: <Widget>[
              const Positioned(
                right: 16,
                top: 0,
                child: AstryxBadge(
                  'Free shipping',
                  variant: AstryxBadgeVariant.info,
                ),
              ),
              Positioned(
                right: 0,
                top: 40,
                child: Container(
                  width: 256,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.color(AstryxColorToken.backgroundCard),
                    borderRadius: radius,
                    border: Border.all(
                      color: theme.color(AstryxColorToken.border),
                    ),
                  ),
                  child: AstryxVStack(
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      StudioProductArt(
                        icon: product.icon,
                        size: 96,
                        height: 250,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: AstryxVStack(
                          gap: AstryxSpacingToken.spacing3,
                          align: AstryxStackAlign.stretch,
                          children: <Widget>[
                            AstryxHStack(
                              justify: AstryxStackJustify.between,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                AstryxText(
                                  'Points',
                                  weight: AstryxTextWeight.semibold,
                                ),
                                AstryxText(
                                  '6/8',
                                  type: AstryxTextType.supporting,
                                  color: AstryxTextColor.accent,
                                ),
                              ],
                            ),
                            AstryxProgressBar(
                              label: 'Points',
                              showLabel: false,
                              value: 0.75,
                            ),
                            AstryxHStack(
                              gap: AstryxSpacingToken.spacing2,
                              children: <Widget>[
                                AstryxAvatar(
                                  name: 'Ami Pena',
                                  size: AstryxAvatarSize.xs,
                                ),
                                AstryxText(
                                  'Ami Pena',
                                  type: AstryxTextType.supporting,
                                  color: AstryxTextColor.secondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 140,
                child: _Float(
                  width: 210,
                  padding: 14,
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxHStack(
                        gap: AstryxSpacingToken.spacing3,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: theme.borderRadius(
                              AstryxRadiusToken.element,
                            ),
                            child: SizedBox(
                              width: 56,
                              child: StudioProductArt(
                                icon: product.icon,
                                size: 24,
                                height: 56,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AstryxVStack(
                              children: <Widget>[
                                AstryxText(
                                  product.name,
                                  weight: AstryxTextWeight.semibold,
                                  maxLines: 2,
                                ),
                                AstryxText(
                                  product.detail,
                                  type: AstryxTextType.supporting,
                                  color: AstryxTextColor.secondary,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AstryxButton(
                        label: 'Add to cart',
                        variant: AstryxButtonVariant.primary,
                        size: AstryxButtonSize.sm,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative hero specimens: shown, never focused or announced.
class _Specimen extends StatelessWidget {
  const _Specimen({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: ExcludeSemantics(child: child));
}

/// Top left: a settings panel of switches.
class _HeroSettingsCard extends StatelessWidget {
  const _HeroSettingsCard();

  @override
  Widget build(BuildContext context) {
    return _Specimen(
      child: _Float(
        width: 320,
        padding: 18,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: AstryxText(
                    'Notifications',
                    weight: AstryxTextWeight.semibold,
                    maxLines: 1,
                  ),
                ),
                AstryxBadge('New', variant: AstryxBadgeVariant.info),
              ],
            ),
            AstryxSwitch(
              label: 'Order updates',
              value: true,
              onChanged: (_) {},
              labelPosition: AstryxToggleLabelPosition.start,
              labelSpacing: AstryxToggleLabelSpacing.spread,
            ),
            AstryxSwitch(
              label: 'Price drops',
              value: false,
              onChanged: (_) {},
              labelPosition: AstryxToggleLabelPosition.start,
              labelSpacing: AstryxToggleLabelSpacing.spread,
            ),
            AstryxSwitch(
              label: 'Weekly digest',
              value: true,
              onChanged: (_) {},
              labelPosition: AstryxToggleLabelPosition.start,
              labelSpacing: AstryxToggleLabelSpacing.spread,
            ),
          ],
        ),
      ),
    );
  }
}

/// Top right: who is around, with a range picker.
class _HeroTeamCard extends StatelessWidget {
  const _HeroTeamCard();

  @override
  Widget build(BuildContext context) {
    return _Specimen(
      child: _Float(
        width: 320,
        padding: 18,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: AstryxText(
                    'Design team',
                    weight: AstryxTextWeight.semibold,
                    maxLines: 1,
                  ),
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxStatusDot(
                      AstryxStatusDotVariant.success,
                      label: 'Online',
                    ),
                    AstryxText(
                      '4 online',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ],
            ),
            const AstryxAvatarGroup(
              label: 'Design team',
              max: 4,
              size: AstryxAvatarSize.sm,
              avatars: <AstryxAvatar>[
                AstryxAvatar(name: 'Ami Pena'),
                AstryxAvatar(name: 'Jun Park'),
                AstryxAvatar(name: 'Lena Ortiz'),
                AstryxAvatar(name: 'Sam Rivers'),
                AstryxAvatar(name: 'Noor Haddad'),
                AstryxAvatar(name: 'Theo Grant'),
              ],
            ),
            AstryxSegmentedControl<int>(
              label: 'Range',
              value: 1,
              size: AstryxButtonSize.sm,
              expand: true,
              onChanged: (_) {},
              segments: const <AstryxSegment<int>>[
                AstryxSegment(value: 0, label: 'Day'),
                AstryxSegment(value: 1, label: 'Week'),
                AstryxSegment(value: 2, label: 'Month'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom, left of centre: a slider and a sync status.
class _HeroControlsCard extends StatelessWidget {
  const _HeroControlsCard();

  @override
  Widget build(BuildContext context) {
    return _Specimen(
      child: _Float(
        width: 280,
        padding: 18,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxSlider(
              label: 'Volume',
              value: 64,
              length: 244,
              valueDisplay: AstryxSliderValueDisplay.text,
              onChanged: (_) {},
            ),
            const AstryxDivider(),
            const AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxSpinner(label: 'Syncing', size: AstryxSpinnerSize.sm),
                AstryxText(
                  'Syncing library…',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom, right of centre: a toast confirming an order.
class _HeroToastCard extends StatelessWidget {
  const _HeroToastCard({required this.product});

  final StudioProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    return _Specimen(
      child: _Float(
        width: 300,
        padding: 14,
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            Icon(
              LucideIcons.circleCheck,
              size: 20,
              color: theme.color(AstryxColorToken.success),
            ),
            Expanded(
              child: AstryxVStack(
                children: <Widget>[
                  const AstryxText(
                    'Added to cart',
                    weight: AstryxTextWeight.semibold,
                  ),
                  AstryxText(
                    product.name,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            AstryxButton(
              label: 'Undo',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento: what it is
// ---------------------------------------------------------------------------

class _Bento extends StatelessWidget {
  const _Bento();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final gap = theme.spacing(AstryxSpacingToken.spacing6);

    return LayoutBuilder(
      builder: (context, constraints) {
        const intro = _BentoIntro();
        const themes = _ThemesCard();
        const components = _ComponentsCard();
        const agent = _AgentCard();
        const templates = _TemplatesCard();

        if (constraints.maxWidth >= 1080) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[intro, SizedBox(height: 40), themes],
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    components,
                    SizedBox(height: gap),
                    agent,
                  ],
                ),
              ),
              SizedBox(width: gap),
              const Expanded(child: templates),
            ],
          );
        }
        if (constraints.maxWidth >= 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              intro,
              SizedBox(height: gap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(child: themes),
                  SizedBox(width: gap),
                  const Expanded(child: components),
                ],
              ),
              SizedBox(height: gap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(child: agent),
                  SizedBox(width: gap),
                  const Expanded(child: templates),
                ],
              ),
            ],
          );
        }
        return const AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[intro, themes, components, agent, templates],
        );
      },
    );
  }
}

class _BentoIntro extends StatelessWidget {
  const _BentoIntro();

  @override
  Widget build(BuildContext context) => const AstryxVStack(
    gap: AstryxSpacingToken.spacing5,
    align: AstryxStackAlign.stretch,
    children: <Widget>[
      AstryxHeading(
        'Start anywhere.\nChange anything.\nShip faster.',
        type: AstryxHeadingType.display2,
      ),
      AstryxText(
        'A design system that adapts to your app, not the other way around. '
        'Adopt it one subtree at a time — no Material underneath, no code '
        'generation, no theme file to keep in step.',
        type: AstryxTextType.large,
        color: AstryxTextColor.secondary,
      ),
    ],
  );
}

/// The bento's panel: the page colour pulled toward the accent, so the tiles
/// read as one family in every theme.
Color landingPanelColor(AstryxThemeData theme) => Color.lerp(
  theme.color(AstryxColorToken.backgroundBody),
  theme.color(AstryxColorToken.accent),
  theme.mode == AstryxThemeMode.dark ? 0.12 : 0.07,
)!;

/// A bento tile: a tinted panel, a title, a line, an "Explore" link, then a
/// specimen.
class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.title,
    required this.body,
    required this.onExplore,
    required this.specimen,
    this.bleed = false,
  });

  final String title;
  final String body;
  final VoidCallback onExplore;
  final Widget specimen;

  /// Whether the specimen runs to the card's end edge.
  final bool bleed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    const pad = 36.0;

    final copy = Padding(
      padding: const EdgeInsets.fromLTRB(pad, pad, pad, 0),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHeading(title, level: 3, type: AstryxHeadingType.display3),
          AstryxText(body, color: AstryxTextColor.secondary),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _ArrowLink(label: 'Explore', onPressed: onExplore),
          ),
        ],
      ),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: landingPanelColor(theme),
        borderRadius: BorderRadius.circular(24),
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing8,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          copy,
          Padding(
            padding: bleed
                ? const EdgeInsetsDirectional.only(start: pad, bottom: pad)
                : const EdgeInsets.fromLTRB(pad, 0, pad, pad),
            child: specimen,
          ),
        ],
      ),
    );
  }
}

/// "Label →", the way upstream ends every tile.
class _ArrowLink extends StatelessWidget {
  const _ArrowLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AstryxButton(
    label: label,
    variant: AstryxButtonVariant.ghost,
    size: AstryxButtonSize.sm,
    trailing: const Icon(LucideIcons.arrowRight),
    onPressed: onPressed,
  );
}

class _ThemesCard extends StatelessWidget {
  const _ThemesCard();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    return _BentoCard(
      title: 'Themes that fit your brand',
      body:
          '${landingCounts.themes} themes ready to use, and defineTheme for '
          'yours. Make it yours without starting from scratch.',
      onExplore: () => controller.pageId = 'themes',
      bleed: true,
      specimen: const _MiniStore(),
    );
  }
}

/// A storefront in Butter, shrunk: the theme tile's specimen.
class _MiniStore extends StatelessWidget {
  const _MiniStore();

  @override
  Widget build(BuildContext context) {
    final site = AstryxTheme.of(context);
    final dark = site.mode == AstryxThemeMode.dark;

    return IgnorePointer(
      child: ExcludeSemantics(
        child: AstryxThemeProvider(
          theme: DocsTheme.butter.theme,
          mode: dark ? AstryxColorMode.dark : AstryxColorMode.light,
          child: Builder(
            builder: (context) {
              final theme = AstryxTheme.of(context);
              final swatches = <Color>[
                theme.color(AstryxColorToken.accent),
                theme.color(AstryxColorToken.accentMuted),
                theme.color(AstryxColorToken.textPrimary),
              ];
              final store = SizedBox(
                width: 640,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing4,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      const AstryxHeading(
                        'Little joys, everywhere you go',
                        type: AstryxHeadingType.display3,
                        justify: AstryxTextJustify.center,
                      ),
                      Row(
                        children: <Widget>[
                          for (final p in studioProducts.take(3))
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: _MiniProduct(product: p),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: theme.color(AstryxColorToken.backgroundBody),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topLeft,
                        child: store,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 8),
                    child: Column(
                      children: <Widget>[
                        for (final c in swatches)
                          Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        AstryxText(
                          'Aa',
                          type: AstryxTextType.display3,
                          style: TextStyle(color: swatches.first),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MiniProduct extends StatelessWidget {
  const _MiniProduct({required this.product});

  final StudioProduct product;

  @override
  Widget build(BuildContext context) => AstryxCard(
    padding: AstryxSpacingToken.spacing2,
    child: AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        StudioProductArt(icon: product.icon, size: 40),
        AstryxText(
          product.name,
          weight: AstryxTextWeight.semibold,
          maxLines: 1,
        ),
        AstryxButton(
          label: 'Add to cart',
          size: AstryxButtonSize.sm,
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
      ],
    ),
  );
}

class _ComponentsCard extends StatefulWidget {
  const _ComponentsCard();

  @override
  State<_ComponentsCard> createState() => _ComponentsCardState();
}

class _ComponentsCardState extends State<_ComponentsCard> {
  bool _on = true;
  bool _ticked = true;

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    return _BentoCard(
      title: 'Over ${(landingCounts.components ~/ 10) * 10} components',
      body:
          'Accessible, themeable Flutter widgets with built-in spacing, dark '
          'mode and touch density.',
      onExplore: controller.goComponents,
      specimen: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              const AstryxBadge('Badge', variant: AstryxBadgeVariant.warning),
              const AstryxBadge('Badge', variant: AstryxBadgeVariant.info),
              AstryxCheckbox(
                label: 'Checkbox',
                labelHidden: true,
                value: _ticked,
                onChanged: (value) => setState(() => _ticked = value),
              ),
              AstryxSwitch(
                label: 'Switch',
                labelHidden: true,
                value: _on,
                onChanged: (value) => setState(() => _on = value),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: AstryxButton(label: 'Secondary', onPressed: () {}),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AstryxButton(
                  label: 'Primary',
                  variant: AstryxButtonVariant.primary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const AstryxTextInput(
            label: 'Search',
            labelHidden: true,
            placeholder: 'Search…',
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

class _AgentCard extends StatefulWidget {
  const _AgentCard();

  @override
  State<_AgentCard> createState() => _AgentCardState();
}

class _AgentCardState extends State<_AgentCard> {
  final TextEditingController _draft = TextEditingController(
    text: 'Can you create me a table page',
  );

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delegate = AstryxLinkDelegate.of(context);
    return _BentoCard(
      title: 'A design system that your agent can use',
      body:
          'A Claude Code skill ships in the repository: every component, '
          'every enum, and the mistakes a generator makes without them.',
      onExplore: () => delegate.followLink(Uri.parse(agentSkillUrl)),
      specimen: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 12),
            child: AstryxText(
              'How can I help you today?',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ),
          AstryxChatComposer(
            controller: _draft,
            label: 'Message',
            placeholder: 'Ask for a screen…',
            onSubmit: (_) {},
          ),
        ],
      ),
    );
  }
}

class _TemplatesCard extends StatelessWidget {
  const _TemplatesCard();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    return _BentoCard(
      title: 'Ready to ship templates',
      body:
          '${landingCounts.templates} production-ready screens for common '
          'pages, just plug in your content.',
      onExplore: () => controller.goSection(DocsSection.templates),
      bleed: true,
      specimen: const _TemplateGrid(),
    );
  }
}

/// Two columns of template thumbnails.
class _TemplateGrid extends StatelessWidget {
  const _TemplateGrid();

  @override
  Widget build(BuildContext context) {
    final ids = landingTemplateIds
        .where((id) => landingTemplateSnippet(id) != null)
        .toList();
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (var i = 0; i < ids.length; i += 2)
            Row(
              children: <Widget>[
                Expanded(child: LandingTemplateThumb(pageId: ids[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < ids.length
                      ? LandingTemplateThumb(pageId: ids[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The first example on a template page, if it has a preview.
String? landingTemplateSnippet(String pageId) {
  final page = docPageOrNull(pageId);
  if (page == null) return null;
  for (final block in page.blocks.whereType<DocExample>()) {
    if (docPreviews.containsKey(block.snippetId)) return block.snippetId;
  }
  return null;
}

/// A template, rendered at desktop size and scaled to a thumbnail. Inert,
/// apart from the tap that opens its page.
class LandingTemplateThumb extends StatelessWidget {
  /// Creates a thumbnail of [pageId]'s first example.
  const LandingTemplateThumb({
    required this.pageId,
    super.key,
    this.canvas = const Size(1200, 800),
  });

  final String pageId;
  final Size canvas;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final id = landingTemplateSnippet(pageId);
    final builder = id == null ? null : docPreviews[id];

    final thumb = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundBody),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.color(AstryxColorToken.border)),
      ),
      child: AspectRatio(
        aspectRatio: canvas.aspectRatio,
        child: builder == null
            ? const SizedBox.shrink()
            : IgnorePointer(
                child: ExcludeFocus(
                  child: ExcludeSemantics(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      child: SizedBox.fromSize(
                        size: canvas,
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.topCenter,
                            minHeight: 0,
                            maxHeight: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Builder(builder: builder),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );

    final page = docPageOrNull(pageId);
    return Semantics(
      button: true,
      label: 'Open the ${page?.title ?? pageId} template',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.pageId = pageId,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: thumb),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pillars: why it exists
// ---------------------------------------------------------------------------

class _Pillars extends StatelessWidget {
  const _Pillars();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final delegate = AstryxLinkDelegate.of(context);

    const lead = AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHeading(
          'Astryx, rebuilt for Flutter',
          type: AstryxHeadingType.display2,
        ),
        AstryxText(
          'The tokens, themes and component names of Meta’s Astryx, written '
          'in Dart from the ground up. Nothing from Material underneath, and '
          'nothing to keep in step by hand.',
          type: AstryxTextType.large,
          color: AstryxTextColor.secondary,
        ),
      ],
    );

    final pillars = <Widget>[
      _Pillar(
        shape: _Shape.flower,
        title: 'Design for speed',
        body:
            'One dependency and one wrapper widget. Toasts, tooltips, dialogs '
            'and the theme arrive with it, so the first screen is minutes '
            'away.',
        link: 'Get started in minutes',
        onPressed: () => controller.pageId = 'installation',
      ),
      _Pillar(
        shape: _Shape.stack,
        title: 'Built in the open',
        body:
            'MIT licensed. Every widget, the theme engine and the tests it is '
            'held to are on GitHub, and the issue tracker decides what is '
            'built next.',
        link: 'Learn how to contribute',
        semanticsLabel:
            'Learn how to contribute. Opens '
            'github.com/JayashBhandary/astryx_ui in a new tab.',
        onPressed: () => delegate.followLink(Uri.parse(repoUrl)),
      ),
      _Pillar(
        shape: _Shape.diamond,
        title: 'Ready for what’s next',
        body:
            '${landingCounts.components} components, '
            '${landingCounts.templates} templates, ${landingCounts.hooks} '
            'controllers and ${landingCounts.themes} themes — counted from '
            'this site, not claimed.',
        link: 'See what’s new',
        onPressed: () => controller.pageId = 'changelog',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(flex: 4, child: lead),
              const SizedBox(width: 48),
              for (final (i, p) in pillars.indexed) ...<Widget>[
                if (i > 0) const SizedBox(width: 32),
                Expanded(flex: 3, child: p),
              ],
            ],
          );
        }
        return AstryxVStack(
          gap: AstryxSpacingToken.spacing8,
          align: AstryxStackAlign.stretch,
          children: <Widget>[lead, ...pillars],
        );
      },
    );
  }
}

enum _Shape { flower, stack, diamond }

class _Pillar extends StatelessWidget {
  const _Pillar({
    required this.shape,
    required this.title,
    required this.body,
    required this.link,
    required this.onPressed,
    this.semanticsLabel,
  });

  final _Shape shape;
  final String title;
  final String body;
  final String link;
  final VoidCallback onPressed;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final linkButton = _ArrowLink(label: link, onPressed: onPressed);
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        _ShapeMark(shape: shape),
        AstryxHeading(title, level: 3),
        AstryxText(body, color: AstryxTextColor.secondary),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: semanticsLabel == null
              ? linkButton
              : Semantics(
                  label: semanticsLabel,
                  excludeSemantics: true,
                  button: true,
                  child: linkButton,
                ),
        ),
      ],
    );
  }
}

/// The small abstract marks over each pillar.
class _ShapeMark extends StatelessWidget {
  const _ShapeMark({required this.shape});

  final _Shape shape;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final accent = theme.color(AstryxColorToken.accent);
    final colour = switch (shape) {
      _Shape.flower => Color.lerp(accent, const Color(0xFFE0457B), 0.6)!,
      _Shape.stack => Color.lerp(accent, const Color(0xFF6C4CF1), 0.6)!,
      _Shape.diamond => Color.lerp(accent, const Color(0xFFD9A21B), 0.6)!,
    };
    final fill = colour.withValues(alpha: 0.55);

    return SizedBox(
      width: 40,
      height: 40,
      child: switch (shape) {
        _Shape.flower => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            for (var i = 0; i < 4; i++)
              Transform.rotate(
                angle: i * 0.3927,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: fill.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
        _Shape.stack => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < 3; i++)
              Container(
                width: 40,
                height: 12,
                margin: const EdgeInsets.only(bottom: 1),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
          ],
        ),
        _Shape.diamond => Center(
          child: Transform.rotate(
            angle: 0.7854,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// What's new
// ---------------------------------------------------------------------------

/// One release note, cut down to what fits a card.
typedef LandingNote = ({String title, String body});

/// The newest release's name and its first few entries, from the changelog.
({String release, List<LandingNote> notes}) get landingLatest {
  String? release;
  final notes = <LandingNote>[];
  for (final block in changelogBlocks) {
    switch (block) {
      case DocHeading(:final text, level: 2) when release == null:
        release = text;
      case DocHeading(level: 2):
        return (release: release!, notes: notes);
      case DocList(items: final entries) when notes.length < 3:
        for (final entry in entries) {
          if (notes.length == 3) break;
          notes.add(landingNote(entry));
        }
      case _:
        break;
    }
  }
  return (release: release ?? 'Unreleased', notes: notes);
}

/// `**Title.** Body…` → (title, body), with the inline markup stripped.
LandingNote landingNote(String entry) {
  String plain(String s) => s
      .replaceAll(RegExp(r'\*\*|`|\[|\]\([^)]*\)'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final bold = RegExp(
    r'^\*\*(.+?)\*\*\s*(.*)$',
    dotAll: true,
  ).firstMatch(entry);
  if (bold != null) {
    final title = plain(bold.group(1)!).replaceAll(RegExp(r'[.:]$'), '');
    return (title: title, body: plain(bold.group(2)!));
  }
  final text = plain(entry);
  final cut = text.indexOf('. ');
  return cut > 0 && cut < 120
      ? (title: text.substring(0, cut), body: text.substring(cut + 2))
      : (title: text, body: '');
}

class _WhatsNew extends StatelessWidget {
  const _WhatsNew();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final latest = landingLatest;
    if (latest.notes.isEmpty) return const SizedBox.shrink();

    void open() => controller.pageId = 'changelog';
    final notes = latest.notes;

    final header = AstryxHStack(
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      wrap: true,
      runGap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        const AstryxHeading(
          'Stay in the know',
          type: AstryxHeadingType.display2,
        ),
        _ArrowLink(label: 'Read the changelog', onPressed: open),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final lead = _NoteCard(
          note: notes.first,
          release: latest.release,
          large: true,
          onPressed: open,
        );
        final rest = <Widget>[
          for (final note in notes.skip(1))
            _NoteCard(note: note, release: latest.release, onPressed: open),
        ];

        return AstryxVStack(
          gap: AstryxSpacingToken.spacing8,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            header,
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 7, child: lead),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: AstryxVStack(
                      gap: AstryxSpacingToken.spacing8,
                      align: AstryxStackAlign.stretch,
                      children: rest,
                    ),
                  ),
                ],
              )
            else ...<Widget>[lead, ...rest],
          ],
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.release,
    required this.onPressed,
    this.large = false,
  });

  final LandingNote note;
  final String release;
  final VoidCallback onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final accent = theme.color(AstryxColorToken.accent);
    final onAccent = theme.color(AstryxColorToken.onAccent);
    const white = Color(0xFFFFFFFF);

    final art = Container(
      height: large ? 400 : 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: large ? const Color(0xFF000000) : accent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: large
          ? const Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DocsSvgWordmark(color: white, height: 54),
                    SizedBox(width: 28),
                    Icon(LucideIcons.plus, color: white, size: 40),
                    SizedBox(width: 28),
                    DocsSvgMark(
                      path: astryxLogoPath,
                      viewBox: 96,
                      color: astryxLogoColor,
                      size: 84,
                    ),
                  ],
                ),
              ),
            )
          : Align(
              alignment: AlignmentDirectional.topStart,
              child: AstryxText(
                'New in\n$release',
                type: AstryxTextType.display2,
                maxLines: 2,
                style: TextStyle(color: onAccent),
              ),
            ),
    );

    return Semantics(
      button: true,
      label: '${note.title}. Read the changelog.',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              art,
              AstryxHeading(
                note.title,
                level: 3,
                type: large ? AstryxHeadingType.display3 : null,
                maxLines: 3,
              ),
              if (note.body.isNotEmpty)
                AstryxText(
                  note.body,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: large ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  const DocsSvgMark(
                    path: astryxLogoPath,
                    viewBox: 96,
                    color: astryxLogoColor,
                    size: 18,
                  ),
                  const AstryxText(
                    'astryx_ui',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                  const AstryxText(
                    '·',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                  Flexible(
                    child: AstryxText(
                      release,
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Closing call and footer
// ---------------------------------------------------------------------------

/// A dark panel with tilted template thumbnails in the corners.
class _ClosingCall extends StatelessWidget {
  const _ClosingCall();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    return AstryxThemeProvider(
      theme: DocsTheme.neutral.theme,
      mode: AstryxColorMode.dark,
      density: controller.density,
      child: Builder(
        builder: (context) {
          final theme = AstryxTheme.of(context);
          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final copy = Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 220 : 24,
                  vertical: wide ? 110 : 48,
                ),
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing5,
                  align: AstryxStackAlign.center,
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: <Widget>[
                        const AstryxHeading(
                          'Discover the full',
                          type: AstryxHeadingType.display2,
                        ),
                        DocsSvgWordmark(
                          color: astryxLogoColor,
                          height: wide ? 34 : 26,
                          semanticsLabel: 'Astryx',
                        ),
                        const AstryxHeading(
                          'design system',
                          type: AstryxHeadingType.display2,
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: AstryxText(
                        'Browse ${landingCounts.components} components, '
                        'explore production-ready templates, and tune themes '
                        'to match your brand; pick a starting point and go.',
                        color: AstryxTextColor.secondary,
                        justify: AstryxTextJustify.center,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: const DocsCodeBlock(
                        source: installCommand,
                        language: 'sh',
                      ),
                    ),
                    AstryxHStack(
                      gap: AstryxSpacingToken.spacing3,
                      wrap: true,
                      runGap: AstryxSpacingToken.spacing2,
                      justify: AstryxStackJustify.center,
                      children: <Widget>[
                        SizedBox(
                          width: 174,
                          child: AstryxButton(
                            label: 'Get started',
                            variant: AstryxButtonVariant.primary,
                            onPressed: () => controller.pageId = 'installation',
                          ),
                        ),
                        SizedBox(
                          width: 174,
                          child: AstryxButton(
                            label: 'Browse components',
                            onPressed: controller.goComponents,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              Widget tilt(String id, double angle) => SizedBox(
                width: 240,
                child: Transform.rotate(
                  angle: angle,
                  child: AstryxThemeProvider(
                    theme: DocsTheme.neutral.theme,
                    mode: AstryxColorMode.light,
                    child: LandingTemplateThumb(
                      pageId: id,
                      canvas: const Size(1200, 760),
                    ),
                  ),
                ),
              );

              return Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  // Darker than any page body, so the panel reads as one in
                  // both site modes.
                  color: Color.lerp(
                    theme.color(AstryxColorToken.backgroundBody),
                    const Color(0xFF000000),
                    0.55,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: wide
                    ? Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            left: -14,
                            top: -30,
                            child: tilt('settings', -0.09),
                          ),
                          Positioned(
                            right: -10,
                            top: -50,
                            child: tilt('login_split', 0.07),
                          ),
                          Positioned(
                            left: -10,
                            bottom: -50,
                            child: tilt('contact_form', 0.06),
                          ),
                          Positioned(
                            right: -24,
                            bottom: -40,
                            child: tilt('gallery_hero', -0.11),
                          ),
                          copy,
                        ],
                      )
                    : copy,
              );
            },
          );
        },
      ),
    );
  }
}

/// The way out: the wordmark, every section, and where the package lives.
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);
    final delegate = AstryxLinkDelegate.of(context);
    final ink = theme.color(AstryxColorToken.textPrimary);

    Widget link(String label, VoidCallback onPressed) => AstryxButton(
      label: label,
      variant: AstryxButtonVariant.ghost,
      size: AstryxButtonSize.sm,
      onPressed: onPressed,
    );

    Widget out(String label, String host, String url, Widget glyph) =>
        Semantics(
          button: true,
          excludeSemantics: true,
          label: '$label. Opens $host in a new tab.',
          child: AstryxIconButton.custom(
            label: label,
            tooltip: host,
            onPressed: () => delegate.followLink(Uri.parse(url)),
            child: glyph,
          ),
        );

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            DocsSvgWordmark(color: ink, height: 20, semanticsLabel: 'Astryx'),
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: <Widget>[
                link('Docs', () => controller.goSection(DocsSection.docs)),
                link('Components', controller.goComponents),
                link(
                  'Templates',
                  () => controller.goSection(DocsSection.templates),
                ),
                link('Themes', () => controller.pageId = 'themes'),
                link('Playground', controller.goPlayground),
                link('Changelog', () => controller.pageId = 'changelog'),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                out(
                  'GitHub',
                  'github.com/JayashBhandary/astryx_ui',
                  repoUrl,
                  DocsSvgMark(
                    path: githubMarkPath,
                    viewBox: 24,
                    color: ink,
                    size: 18,
                  ),
                ),
                out(
                  'pub.dev',
                  'pub.dev/packages/astryx_ui',
                  pubUrl,
                  const Icon(LucideIcons.package, size: 18),
                ),
                out(
                  'Upstream Astryx',
                  'astryx.atmeta.com',
                  upstreamUrl,
                  DocsSvgMark(
                    path: astryxLogoPath,
                    viewBox: 96,
                    color: ink,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        const AstryxDivider(),
        const AstryxHStack(
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxText(
              'astryx_ui · $astryxVersion',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            AstryxText(
              'An independent Flutter implementation of Astryx. MIT licensed.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

/// Centres [child] and holds it to [maxWidth].
///
/// The `Align` comes first so that what it hands the box below is loose: a
/// `ConstrainedBox` under a scroll view's tight cross axis is otherwise
/// enforced away to the full width.
class _Measure extends StatelessWidget {
  const _Measure({required this.child, this.maxWidth = 760});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
