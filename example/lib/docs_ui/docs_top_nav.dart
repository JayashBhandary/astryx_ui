/// The bar across the top of every page.
///
/// Laid out like upstream's: the mark on the start edge, the sections in the
/// middle, and the tools on the end edge — search, brightness, view settings,
/// the repository and `Get started`. The view settings (theme, colour mode,
/// density, text direction) used to sit in the bar as four controls; they are
/// one popover now, because they are things a reader changes once rather than
/// on every page.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/categories.dart';
import 'package:example/docs/issue_links.dart';
import 'package:example/docs/pages.dart';
import 'package:example/docs_ui/docs_controller.dart';
import 'package:example/docs_ui/segmented.dart';
import 'package:example/docs_ui/svg_mark.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The top bar.
class DocsTopNav extends StatelessWidget {
  const DocsTopNav({required this.wide, super.key});

  /// Whether the section links fit. Below this they move into the page menu.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    final brand = AstryxIconButton.custom(
      label: 'astryx_ui home',
      variant: AstryxButtonVariant.ghost,
      onPressed: controller.goHome,
      child: const DocsSvgMark(
        path: astryxLogoPath,
        viewBox: 96,
        color: astryxLogoColor,
        size: 22,
      ),
    );

    final links = AstryxHStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        for (final section in DocsSection.values)
          _SectionLink(
            label: section.label,
            // The Themes page sits in the Docs section in the registry, but
            // it has its own link: only one of the two lights up.
            selected:
                !controller.onLanding &&
                !controller.onPlayground &&
                controller.section == section &&
                (controller.onComponentsOverview ||
                    controller.pageId != 'themes'),
            onPressed: () => controller.goSection(section),
          ),
        _SectionLink(
          label: 'Themes',
          selected:
              !controller.onLanding &&
              !controller.onComponentsOverview &&
              !controller.onPlayground &&
              controller.pageId == 'themes',
          onPressed: () => controller.pageId = 'themes',
        ),
        _SectionLink(
          label: 'Playground',
          selected: controller.onPlayground,
          onPressed: controller.goPlayground,
        ),
      ],
    );

    final tools = AstryxHStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        const _SearchButton(),
        const _BrightnessButton(),
        const _SettingsButton(),
        AstryxIconButton.custom(
          label: 'GitHub repository',
          tooltip: 'GitHub',
          variant: AstryxButtonVariant.ghost,
          onPressed: () => docsFollow(context, astryxRepoUrl),
          child: DocsSvgMark(
            path: githubMarkPath,
            viewBox: 16,
            size: 18,
            color: theme.color(AstryxColorToken.iconPrimary),
          ),
        ),
        if (wide)
          AstryxButton(
            label: 'Get started',
            variant: AstryxButtonVariant.primary,
            onPressed: () => controller.pageId = 'installation',
          ),
      ],
    );

    return SizedBox(
      height: 56,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing(AstryxSpacingToken.spacing4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    if (!wide) const _PageMenu(),
                    brand,
                  ],
                ),
                tools,
              ],
            ),
            // Centred on the bar, not on the space between the two ends: the
            // ends are different widths, and links that drift with them read
            // as misaligned.
            if (wide) links,
          ],
        ),
      ),
    );
  }
}

/// A section link: plain text, emphasised when it is the current section.
class _SectionLink extends StatelessWidget {
  const _SectionLink({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: AstryxCard(
        variant: AstryxCardVariant.transparent,
        showBorder: false,
        padding: AstryxSpacingToken.spacing2,
        semanticsLabel: label,
        onPressed: onPressed,
        child: AstryxText(
          label,
          type: AstryxTextType.label,
          color: selected ? AstryxTextColor.primary : AstryxTextColor.secondary,
        ),
      ),
    );
  }
}

/// Opens a command palette over every page: the site search.
class _SearchButton extends StatefulWidget {
  const _SearchButton();

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  final AstryxOverlayController _palette = AstryxOverlayController();

  static const AstryxHotkey _hotkey = AstryxHotkey.mod(LogicalKeyboardKey.keyK);

  @override
  void dispose() {
    _palette.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    List<AstryxCommandItem> itemsFor(Iterable<DocPage> pages) =>
        <AstryxCommandItem>[
          for (final page in pages)
            AstryxCommandItem(
              label: docDisplayName(page),
              description: page.description,
              keywords: <String>[page.title, page.id],
              onSelected: () => controller.pageId = page.id,
            ),
        ];

    final written = writtenDocPages.toList();
    final components =
        written
            .where((page) => docsSectionOf(page) == DocsSection.components)
            .toList()
          ..sort((a, b) => docDisplayName(a).compareTo(docDisplayName(b)));

    return AstryxHotkeys(
      bindings: <AstryxHotkey, VoidCallback>{_hotkey: _palette.show},
      child: AstryxHStack(
        children: <Widget>[
          AstryxIconButton(
            icon: AstryxIconName.search,
            label: 'Search the docs',
            tooltip: 'Search',
            variant: AstryxButtonVariant.ghost,
            onPressed: _palette.show,
          ),
          AstryxCommandPalette(
            controller: _palette,
            placeholder: 'Search components, guides and templates…',
            label: 'Search the docs',
            groups: <AstryxCommandGroup>[
              AstryxCommandGroup(
                label: 'Components',
                items: itemsFor(components),
              ),
              AstryxCommandGroup(
                label: 'Docs',
                items: itemsFor(
                  written.where((p) => docsSectionOf(p) == DocsSection.docs),
                ),
              ),
              AstryxCommandGroup(
                label: 'Templates',
                items: itemsFor(
                  written.where(
                    (p) => docsSectionOf(p) == DocsSection.templates,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Flips between light and dark.
///
/// From `system` it flips to the opposite of whatever the system resolved to,
/// so the first press always changes what is on screen.
class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);
    final dark = AstryxTheme.of(context).mode == AstryxThemeMode.dark;

    return AstryxIconButton.custom(
      label: dark ? 'Switch to light mode' : 'Switch to dark mode',
      tooltip: dark ? 'Light mode' : 'Dark mode',
      variant: AstryxButtonVariant.ghost,
      onPressed: () =>
          controller.mode = dark ? AstryxColorMode.light : AstryxColorMode.dark,
      child: Icon(dark ? LucideIcons.sun : LucideIcons.moon, size: 18),
    );
  }
}

/// The view settings: theme, colour mode, density and text direction.
class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return AstryxPopover(
      label: 'View settings',
      align: AstryxOverlayAlign.end,
      width: 300,
      triggerBuilder: (context, overlay) => AstryxIconButton.custom(
        label: 'View settings',
        tooltip: 'Theme, density and direction',
        variant: AstryxButtonVariant.ghost,
        onPressed: overlay.toggle,
        child: const Icon(LucideIcons.slidersHorizontal, size: 18),
      ),
      content: const DocsViewSettings(),
    );
  }
}

/// The controls inside the settings popover.
///
/// Public so the narrow layout's page menu and a test can reach the same
/// controls.
class DocsViewSettings extends StatelessWidget {
  const DocsViewSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final controller = DocsScope.of(context);

    Widget row(String label, Widget control) => AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText(
          label,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
        control,
      ],
    );

    return Padding(
      padding: EdgeInsets.all(theme.spacing(AstryxSpacingToken.spacing3)),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          row(
            'Theme',
            AstryxSelector<DocsTheme>(
              label: 'Theme',
              labelHidden: true,
              value: controller.theme,
              size: AstryxInputSize.sm,
              leading: const AstryxIcon(
                AstryxIconName.viewColumns,
                size: AstryxIconSize.sm,
                color: AstryxIconColor.secondary,
              ),
              onChanged: (value) =>
                  controller.theme = value ?? controller.theme,
              options: <AstryxSelectorEntry<DocsTheme>>[
                for (final value in DocsTheme.values)
                  AstryxSelectorOption<DocsTheme>(
                    value: value,
                    label: value.label,
                  ),
              ],
            ),
          ),
          row(
            'Colour mode',
            DocsSegmented<AstryxColorMode>(
              label: 'Brightness',
              values: AstryxColorMode.values,
              selected: controller.mode,
              labelOf: (value) => value.name,
              onSelected: (value) => controller.mode = value,
            ),
          ),
          row(
            'Density',
            DocsSegmented<AstryxDensity?>(
              label: 'Density',
              values: const <AstryxDensity?>[
                null,
                AstryxDensity.pointer,
                AstryxDensity.touch,
              ],
              selected: controller.density,
              labelOf: (value) => value?.name ?? 'auto',
              onSelected: (value) => controller.density = value,
            ),
          ),
          row(
            'Text direction',
            DocsSegmented<TextDirection>(
              label: 'Text direction',
              values: TextDirection.values,
              selected: controller.textDirection,
              labelOf: (value) => value.name.toUpperCase(),
              onSelected: (value) => controller.textDirection = value,
            ),
          ),
        ],
      ),
    );
  }
}

/// The narrow layout's way to every section and page.
class _PageMenu extends StatelessWidget {
  const _PageMenu();

  @override
  Widget build(BuildContext context) {
    final controller = DocsScope.of(context);

    final sections = <DocsSection, List<DocPage>>{};
    for (final page in writtenDocPages) {
      sections.putIfAbsent(docsSectionOf(page), () => <DocPage>[]).add(page);
    }
    sections[DocsSection.components]?.sort(
      (a, b) => docDisplayName(a).compareTo(docDisplayName(b)),
    );

    return AstryxDropdownMenu(
      label: 'All pages',
      width: 280,
      maxHeight: 460,
      entries: <AstryxMenuEntry>[
        AstryxMenuItem(
          label: 'Components overview',
          onSelected: controller.goComponents,
        ),
        for (final entry in sections.entries) ...<AstryxMenuEntry>[
          AstryxMenuSection(entry.key.label),
          for (final page in entry.value)
            AstryxMenuItem(
              label: docDisplayName(page),
              onSelected: () => controller.pageId = page.id,
            ),
        ],
      ],
      triggerBuilder: (context, overlay) => AstryxIconButton(
        icon: AstryxIconName.menu,
        label: 'All pages',
        variant: AstryxButtonVariant.ghost,
        onPressed: overlay.toggle,
      ),
    );
  }
}
