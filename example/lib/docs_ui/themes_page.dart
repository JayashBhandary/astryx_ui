/// The Themes page, after upstream's: a panel of themes on the start edge, and
/// a whole product screen on the other, rendered in whichever one is picked.
///
/// Only the preview changes. The site around it keeps the theme chosen in the
/// view settings, so a reader can compare a theme against the one they are
/// reading in.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/code_block.dart';
import 'package:example/docs_ui/doc_blocks.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/docs_sidebar.dart';
import 'package:example/docs_ui/studio_showcase.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The id of the page this view replaces.
const String docsThemesPageId = 'themes';

/// The Dart identifier of [theme]'s definition — what a reader types.
String docsThemeIdentifier(DocsTheme theme) => '${theme.name}Theme';

/// The snippet that installs [theme] in an application.
String docsUseThemeSnippet(DocsTheme theme) {
  final id = docsThemeIdentifier(theme);
  if (theme == DocsTheme.acme) {
    return '''
import 'package:astryx_ui/astryx_ui.dart';

// Acme is not shipped: the engine generates it from one accent colour.
final acmeTheme = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme',
    color: AstryxColorScaleConfig(accent: '#0F62FE'),
    radius: AstryxRadiusScaleConfig(base: 2, multiplier: 2),
  ),
);

AstryxApp(
  theme: acmeTheme,
  home: const HomePage(),
)''';
  }
  return '''
import 'package:astryx_ui/astryx_ui.dart';

AstryxApp(
  theme: $id,
  home: const HomePage(),
)''';
}

/// The page.
class DocsThemesPage extends StatefulWidget {
  const DocsThemesPage({super.key});

  /// Below this the panel stacks above the preview.
  static const double wideWidth = 1000;

  @override
  State<DocsThemesPage> createState() => _DocsThemesPageState();
}

class _DocsThemesPageState extends State<DocsThemesPage> {
  final ScrollController _panelScroll = ScrollController();
  final ScrollController _previewScroll = ScrollController();

  @override
  void dispose() {
    _panelScroll.dispose();
    _previewScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final gap = theme.spacing(AstryxSpacingToken.spacing4);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < DocsThemesPage.wideWidth) {
          return DocsScroller(
            controller: _previewScroll,
            child: Padding(
              padding: EdgeInsets.all(gap),
              child: const AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  _Panel(horizontalCards: true),
                  _Preview(),
                  _Details(),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(gap),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: 280,
                // A painted panel rather than an AstryxCard: a card sizes to
                // its content, and this one has to hold a scroll view.
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.color(AstryxColorToken.backgroundCard),
                    borderRadius: theme.borderRadius(
                      AstryxRadiusToken.container,
                    ),
                    border: Border.all(
                      color: theme.color(AstryxColorToken.border),
                    ),
                  ),
                  child: DocsScroller(
                    controller: _panelScroll,
                    child: Padding(
                      padding: EdgeInsets.all(gap),
                      child: const _Panel(horizontalCards: false),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DocsScroller(
                  controller: _previewScroll,
                  child: const AstryxVStack(
                    gap: AstryxSpacingToken.spacing6,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[_Preview(), _Details()],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Title, introduction, the two actions, and the theme cards.
class _Panel extends StatelessWidget {
  const _Panel({required this.horizontalCards});

  /// Narrow layouts show the cards as a scrolling row.
  final bool horizontalCards;

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final siteDark = AstryxTheme.of(context).mode == AstryxThemeMode.dark;
    final previewDark = switch (controller.previewMode) {
      AstryxColorMode.dark => true,
      AstryxColorMode.light => false,
      _ => siteDark,
    };

    final cards = <Widget>[
      for (final value in DocsTheme.values)
        DocsThemeCard(
          theme: value,
          selected: controller.previewTheme == value,
          dark: previewDark,
          onPressed: () => controller.previewTheme = value,
        ),
    ];

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const AstryxHeading('Themes', level: 1),
            AstryxIconButton.custom(
              label: previewDark ? 'Preview in light' : 'Preview in dark',
              tooltip: previewDark ? 'Preview in light' : 'Preview in dark',
              variant: AstryxButtonVariant.ghost,
              onPressed: () => controller.previewMode = previewDark
                  ? AstryxColorMode.light
                  : AstryxColorMode.dark,
              child: Icon(
                previewDark ? LucideIcons.sun : LucideIcons.moon,
                size: 18,
              ),
            ),
          ],
        ),
        const AstryxText(
          'astryx_ui ships seven themes, plus Transit and Acme — a theme '
          'generated from a single colour. Pick one to see a whole product '
          'in it, then install it with one line.',
          color: AstryxTextColor.secondary,
        ),
        AstryxLink(
          'Learn how theming works',
          onPressed: () => controller.pageId = 'theming',
        ),
        const _UseThemeButton(),
        AstryxButton(
          label: 'Compare all themes',
          onPressed: () => controller.pageId = 'theme_showcase',
        ),
        const AstryxDivider(),
        if (horizontalCards)
          SizedBox(
            height: DocsThemeCard.height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(width: 220, child: cards[i]),
            ),
          )
        else
          AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: cards,
          ),
      ],
    );
  }
}

/// "Use this theme": the line that installs the picked theme, in a popover.
class _UseThemeButton extends StatelessWidget {
  const _UseThemeButton();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final picked = controller.previewTheme;
    final snippet = docsUseThemeSnippet(picked);

    return AstryxPopover(
      label: 'Use this theme',
      align: AstryxOverlayAlign.start,
      width: 360,
      triggerBuilder: (context, overlay) => AstryxButton(
        label: 'Use this theme',
        variant: AstryxButtonVariant.primary,
        onPressed: overlay.toggle,
      ),
      content: Builder(
        builder: (context) {
          final theme = AstryxTheme.of(context);
          return Padding(
            padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing3)),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxText(
                  'Pass ${picked.label} to your app. Every component below '
                  'it follows.',
                  type: AstryxTextType.supporting,
                ),
                DocsCodeBlock(source: snippet, title: 'main.dart'),
                AstryxButton(
                  label: 'Copy code',
                  size: AstryxButtonSize.sm,
                  leading: const AstryxIcon(AstryxIconName.copy),
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: snippet)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// One theme in the picker, drawn in itself: its page colour, its heading
/// face for the name, and three of its own components.
class DocsThemeCard extends StatelessWidget {
  const DocsThemeCard({
    required this.theme,
    required this.selected,
    required this.dark,
    required this.onPressed,
    super.key,
  });

  /// The card's height.
  static const double height = 148;

  final DocsTheme theme;
  final bool selected;
  final bool dark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final site = AstryxTheme.of(context);
    final ring = selected
        ? site.color(AstryxColorToken.accent)
        : site.color(AstryxColorToken.border);

    return Semantics(
      selected: selected,
      child: AstryxCard(
        variant: AstryxCardVariant.transparent,
        showBorder: false,
        padding: AstryxSpacingToken.spacing0,
        semanticsLabel: '${theme.label} theme',
        onPressed: onPressed,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: site.borderRadius(AstryxRadiusToken.container),
            border: Border.all(color: ring, width: selected ? 2 : 1),
          ),
          child: ClipRRect(
            borderRadius: site.borderRadius(AstryxRadiusToken.container),
            child: SizedBox(
              height: height,
              child: AstryxThemeProvider(
                theme: theme.theme,
                mode: dark ? AstryxColorMode.dark : AstryxColorMode.light,
                child: _ThemeCardFace(
                  label: theme.label.replaceAll(' (custom)', ''),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeCardFace extends StatelessWidget {
  const _ThemeCardFace({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = AstryxTheme.of(context);

    return IgnorePointer(
      child: ExcludeSemantics(
        child: ExcludeFocus(
          child: ColoredBox(
            color: t.color(AstryxColorToken.backgroundBody),
            child: Padding(
              padding: EdgeInsets.all(t.spacing(AstryxSpacingToken.spacing3)),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                justify: AstryxStackJustify.between,
                children: <Widget>[
                  AstryxHeading(
                    label,
                    type: AstryxHeadingType.display3,
                    maxLines: 1,
                  ),
                  // Scaled down rather than wrapped when a narrow card is
                  // short of room: the card has a fixed height.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: AstryxHStack(
                      gap: AstryxSpacingToken.spacing2,
                      children: <Widget>[
                        AstryxButton(
                          label: 'Buy',
                          variant: AstryxButtonVariant.primary,
                          size: AstryxButtonSize.sm,
                          onPressed: () {},
                        ),
                        const AstryxBadge(
                          'New',
                          variant: AstryxBadgeVariant.info,
                        ),
                        AstryxSwitch(
                          label: 'On',
                          labelHidden: true,
                          size: AstryxToggleSize.sm,
                          value: true,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Studio, in the picked theme and mode.
class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    final site = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    return ClipRRect(
      borderRadius: site.borderRadius(AstryxRadiusToken.container),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: site.borderRadius(AstryxRadiusToken.container),
          border: Border.all(color: site.color(AstryxColorToken.border)),
        ),
        child: AstryxThemeProvider(
          key: ValueKey<DocsTheme>(controller.previewTheme),
          theme: controller.previewTheme.theme,
          mode: controller.previewMode ?? controller.mode,
          density: controller.density,
          child: const StudioShowcase(),
        ),
      ),
    );
  }
}

/// Under the preview: the install line for the picked theme, and what
/// differs between the themes.
class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final picked = controller.previewTheme;
    final page = docPageOrNull(docsThemesPageId);

    // The comparison: from "What actually differs" to the next heading, out
    // of the page itself, so the table is written once.
    final blocks = <DocBlock>[];
    if (page != null) {
      var inSection = false;
      for (final block in page.blocks) {
        if (block is DocHeading) {
          if (inSection) break;
          inSection = block.text == 'What actually differs';
        }
        if (inSection) blocks.add(block);
      }
    }

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxHeading('Use this theme'),
        AstryxText(
          'Pass ${picked.label} as the theme of your `AstryxApp`, or of an '
          '`AstryxThemeProvider` to theme part of a screen. Light and dark '
          'are one definition; `mode:` picks the half.',
          color: AstryxTextColor.secondary,
        ),
        DocsCodeBlock(
          source: docsUseThemeSnippet(picked),
          title: 'main.dart',
        ),
        DocsBlocks(
          blocks: blocks,
          onNavigate: (target) => docsFollow(context, target),
        ),
      ],
    );
  }
}
