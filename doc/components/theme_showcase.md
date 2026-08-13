---
title: Theme showcase
description: One of everything on one screen, for judging a theme rather than imagining it.
component: true
group: Templates
source: example/lib/examples/template_screen_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ThemeShowcaseTemplate extends StatefulWidget {
  const ThemeShowcaseTemplate({super.key});

  @override
  State<ThemeShowcaseTemplate> createState() => _ThemeShowcaseTemplateState();
}

class _ThemeShowcaseTemplateState extends State<ThemeShowcaseTemplate> {
  final AstryxDialogController _dialog = AstryxDialogController();

  bool _switched = true;
  bool _checked = true;
  String _tab = 'live';
  String? _selected = 'eu';
  String _radio = 'balanced';

  @override
  void dispose() {
    _dialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // One screen holding one of everything, so a theme can be judged rather
    // than imagined. Change the theme in the picker above and every colour,
    // radius, weight and duration on this page moves with it.
    //
    // Two columns of cards rather than an `AstryxGrid`: a grid gives every cell
    // in a row the height of the tallest, which needs an intrinsic measurement
    // that a wrapped row of buttons cannot supply. Columns of independent cards
    // are also the better shape here — these sections have nothing to line up.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) => constraints.maxWidth < 640
              ? AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    _actions(),
                    _forms(),
                    _status(),
                    _overlays(context),
                  ],
                )
              : AstryxHStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing4,
                        align: AstryxStackAlign.stretch,
                        children: <Widget>[_actions(), _status()],
                      ),
                    ),
                    Expanded(
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing4,
                        align: AstryxStackAlign.stretch,
                        children: <Widget>[_forms(), _overlays(context)],
                      ),
                    ),
                  ],
                ),
        ),
        _panel(),
      ],
    );
  }

  /// Every button variant, and the two sizes of icon button.
  Widget _actions() {
    return AstryxCard(
      header: const AstryxHeading('Actions', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxButton(
                label: 'Primary',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
              AstryxButton(label: 'Secondary', onPressed: () {}),
              AstryxButton(
                label: 'Ghost',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Destructive',
                variant: AstryxButtonVariant.destructive,
                onPressed: () {},
              ),
              AstryxButton(label: 'Disabled', enabled: false, onPressed: () {}),
            ],
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.search,
                label: 'Search',
                tooltip: 'Search',
                onPressed: () {},
              ),
              AstryxIconButton(
                icon: AstryxIconName.funnel,
                label: 'Filter',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
              AstryxButton(label: 'Loading', loading: true, onPressed: () {}),
            ],
          ),
          AstryxButtonGroup(
            size: AstryxButtonSize.sm,
            children: <Widget>[
              AstryxButton(label: 'Day', onPressed: () {}),
              AstryxButton(
                label: 'Week',
                variant: AstryxButtonVariant.primary,
                onPressed: () {},
              ),
              AstryxButton(label: 'Month', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  /// One of every input, including a validated one.
  Widget _forms() {
    return AstryxCard(
      header: const AstryxHeading('Forms', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxTextInput(
            label: 'Workspace',
            placeholder: 'Atlas',
            status: AstryxFieldStatus.success('Available'),
          ),
          AstryxSelector<String>(
            label: 'Region',
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(value: 'eu', label: 'Frankfurt'),
              AstryxSelectorOption(value: 'us', label: 'Virginia'),
            ],
          ),
          AstryxSwitch(
            label: 'Notifications',
            value: _switched,
            labelPosition: AstryxToggleLabelPosition.start,
            labelSpacing: AstryxToggleLabelSpacing.spread,
            onChanged: (value) => setState(() => _switched = value),
          ),
          AstryxCheckbox(
            label: 'Include archived',
            value: _checked,
            onChanged: (value) => setState(() => _checked = value),
          ),
          AstryxRadioList<String>(
            label: 'Density',
            value: _radio,
            orientation: AstryxRadioListOrientation.horizontal,
            onChanged: (value) => setState(() => _radio = value),
            options: const <AstryxRadioOption<String>>[
              AstryxRadioOption(value: 'compact', label: 'Compact'),
              AstryxRadioOption(value: 'balanced', label: 'Balanced'),
            ],
          ),
        ],
      ),
    );
  }

  /// The badges, the bar, the spinner and the skeleton.
  Widget _status() {
    return const AstryxCard(
      header: AstryxHeading('Status', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxBadge('neutral'),
              AstryxBadge('info', variant: AstryxBadgeVariant.info),
              AstryxBadge('success', variant: AstryxBadgeVariant.success),
              AstryxBadge('warning', variant: AstryxBadgeVariant.warning),
              AstryxBadge('error', variant: AstryxBadgeVariant.error),
            ],
          ),
          AstryxBanner(
            title: 'Rebuilding the search index',
            description: 'Results may be incomplete for a few minutes.',
            announce: false,
          ),
          AstryxProgressBar(
            label: 'Rebuilding index',
            value: 0.62,
            showValueLabel: true,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxSpinner(label: 'Loading'),
              AstryxText('Loading…', color: AstryxTextColor.secondary),
            ],
          ),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.6),
        ],
      ),
    );
  }

  /// Every overlay, each behind its own trigger.
  Widget _overlays(BuildContext context) {
    return AstryxCard(
      header: const AstryxHeading('Overlays', level: 3),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxPopover(
                label: 'Details',
                width: 220,
                content: const AstryxText(
                  'A floating panel, with focus trapped inside it until it '
                  'closes.',
                ),
                triggerBuilder: (context, controller) => AstryxButton(
                  label: 'Popover',
                  size: AstryxButtonSize.sm,
                  onPressed: controller.toggle,
                ),
              ),
              AstryxDropdownMenu(
                label: 'Menu',
                width: 180,
                entries: <AstryxMenuEntry>[
                  AstryxMenuItem(label: 'Rename', onSelected: () {}),
                  AstryxMenuItem(
                    label: 'Delete',
                    destructive: true,
                    onSelected: () {},
                  ),
                ],
                triggerBuilder: (context, controller) => AstryxButton(
                  label: 'Menu',
                  size: AstryxButtonSize.sm,
                  onPressed: controller.toggle,
                ),
              ),
              AstryxTooltip(
                message: 'The same information, for a pointer',
                child: AstryxButton(
                  label: 'Tooltip',
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ),
              AstryxButton(
                label: 'Toast',
                size: AstryxButtonSize.sm,
                onPressed: () => AstryxToastScope.of(
                  context,
                ).show(const AstryxToast(message: 'Saved to your views')),
              ),
              AstryxButton(
                label: 'Dialog',
                size: AstryxButtonSize.sm,
                onPressed: _dialog.show,
              ),
            ],
          ),
          AstryxDialog(
            controller: _dialog,
            title: 'A modal',
            description: 'Focus is trapped until it closes.',
            footer: AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AstryxButton(label: 'Close', onPressed: _dialog.hide),
              ],
            ),
            child: const AstryxText(
              'Every radius, shadow and duration here comes from the theme in '
              'scope.',
            ),
          ),
        ],
      ),
    );
  }

  /// A table and a type specimen, behind a tab strip.
  Widget _panel() {
    return AstryxCard(
      header: AstryxTabList<String>(
        label: 'Showcase sections',
        value: _tab,
        onChanged: (value) => setState(() => _tab = value),
        tabs: const <AstryxTab<String>>[
          AstryxTab(value: 'live', label: 'Incidents'),
          AstryxTab(value: 'typography', label: 'Typography'),
        ],
      ),
      child: _tab == 'live'
          ? AstryxTable<Incident>(
              label: 'Incidents',
              rows: incidents,
              keyOf: (row) => row.id,
              striped: true,
              maxHeight: 220,
              columns: <AstryxTableColumn<Incident>>[
                AstryxTableColumn<Incident>(
                  id: 'title',
                  header: 'Incident',
                  cellBuilder: (context, row) =>
                      AstryxText(row.title, maxLines: 1),
                ),
                AstryxTableColumn<Incident>(
                  id: 'severity',
                  header: 'Severity',
                  width: const AstryxTableColumnWidth.intrinsic(min: 96),
                  cellBuilder: (context, row) => AstryxBadge(
                    row.severityLabel,
                    variant: severityVariant(row.severity),
                  ),
                ),
              ],
            )
          : const AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHeading('Heading level 2'),
                AstryxHeading('Heading level 4', level: 4),
                AstryxText(
                  'Body text, which is what most of a tool is made of.',
                ),
                AstryxText(
                  'Supporting text, for the line under the thing.',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
                AstryxText('const AstryxText(…)', type: AstryxTextType.code),
              ],
            ),
    );
  }
}
```

Change the theme, the brightness, the density or the text direction in the bar above: every colour, radius, weight and duration below moves with it.


## What it is for

A palette in isolation tells you very little. A theme is right or wrong in the presence of a disabled button next to a filled one, a warning badge on a muted card, a focus ring over a striped table row — so this screen puts one of everything in one place and lets you look.

It is also the fastest check on a custom theme built with `defineTheme`. If the accent has poor contrast against `--color-on-accent`, the primary button here shows it immediately.

## What to look at

- **The four button variants together** — is `primary` clearly the one action, and is `ghost` still findable?
- **A warning badge and an error badge side by side** — do they differ by more than hue?
- **The focus ring** — tab through the cards; it must be visible on every surface, including inside the table.
- **Dark mode** — switch the brightness. Elevation reads as a lighter surface rather than a heavier shadow, and that is where a custom theme usually breaks.
- **Touch density** — every tap target grows to 48px and hover styling stops. Nothing should move that was not meant to.

## Every component the package exports

Four cards and a tabbed panel cover the set: actions, forms, status, overlays, and a table beside a type specimen. If a widget is missing from this screen, it is missing from the package — which makes this the quickest answer to "what is actually in here?".

## Columns of cards, not a grid

The cards sit in two `Expanded` columns behind a `LayoutBuilder`, not in an [AstryxGrid](grid.md). That is not a style choice — it is a limit worth knowing about:

> **Careful**
>
> **An `AstryxGrid` cell cannot hold a wrapped row of controls, or an [AstryxTable](table.md), in touch density.** A grid gives every cell in a row the height of the tallest, which means measuring each cell intrinsically; the touch-target wrapper every interactive widget sits in cannot answer that measurement, and the layout asserts. Cells of text, badges and figures — the [dashboard](dashboard.md) tiles — are fine. For anything interactive that wraps, use columns of stacks, which is what this screen does.

The same measurement rule is why `AstryxText(truncateTooltip: true)` cannot go inside a table cell: deciding whether the text is cut off needs the final width, and a table row is measured before it is laid out. Use `maxLines` on its own there and let the ellipsis speak.

> **Note**
>
> Nesting an `AstryxThemeProvider` re-themes a subtree, which is how the [theming](../guides/theming.md) page shows all eight themes at once. Here the theme comes from the chrome instead, so the whole screen changes together — which is the point.

## Related

- [Theming](../guides/theming.md) — the seven prebuilt themes and `defineTheme`.
- [Design tokens](../guides/tokens.md) — what every one of these widgets resolves through.
- [Density](../guides/density.md) — the pointer and touch difference this screen makes visible.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Theme showcase`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Theme+showcase&component=Theme+showcase) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Theme+showcase&area=Theme+showcase) — both templates arrive with the component filled in.
