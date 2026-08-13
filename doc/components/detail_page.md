---
title: Detail page
description: 'One record: header, status, tabs, metadata and actions.'
component: true
group: Templates
source: example/lib/examples/template_screen_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DetailPageTemplate extends StatefulWidget {
  const DetailPageTemplate({super.key});

  @override
  State<DetailPageTemplate> createState() => _DetailPageTemplateState();
}

class _DetailPageTemplateState extends State<DetailPageTemplate> {
  static final Incident _incident = incidents.first;

  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // The record's identity and its actions, on one line at width and
        // wrapping at none. The id is `code`, because it is a thing to be
        // copied exactly.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          align: AstryxStackAlign.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxHStack(
                    gap: AstryxSpacingToken.spacing2,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxBadge(
                        _incident.severityLabel,
                        variant: severityVariant(_incident.severity),
                        icon: const AstryxIcon(AstryxIconName.warning),
                      ),
                      const AstryxBadge(
                        'Open',
                        variant: AstryxBadgeVariant.palette(AstryxPalette.red),
                      ),
                      AstryxText(
                        _incident.id,
                        type: AstryxTextType.code,
                        color: AstryxTextColor.secondary,
                      ),
                    ],
                  ),
                  AstryxHeading(_incident.title, level: 1),
                  AstryxText(
                    'Opened ${formatMinutes(_incident.minutes)} ago in '
                    '${_incident.service} · paging ${_incident.owner}',
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Resolve',
                  variant: AstryxButtonVariant.primary,
                  leading: const AstryxIcon(AstryxIconName.check),
                  onPressed: () => AstryxToastScope.of(
                    context,
                  ).show(const AstryxToast(message: 'Incident resolved')),
                ),
                AstryxDropdownMenu(
                  label: 'Incident actions',
                  width: 220,
                  entries: <AstryxMenuEntry>[
                    const AstryxMenuSection('Share'),
                    AstryxMenuItem(
                      label: 'Copy link',
                      icon: const AstryxIcon(AstryxIconName.copy),
                      onSelected: () {},
                    ),
                    AstryxMenuItem(
                      label: 'Open the runbook',
                      icon: const AstryxIcon(AstryxIconName.externalLink),
                      onSelected: () {},
                    ),
                    const AstryxMenuDivider(),
                    AstryxMenuItem(
                      label: 'Delete incident',
                      destructive: true,
                      onSelected: () {},
                    ),
                  ],
                  triggerBuilder: (context, controller) => AstryxIconButton(
                    icon: AstryxIconName.moreHorizontal,
                    label: 'Incident actions',
                    onPressed: controller.toggle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const AstryxBanner(
          status: AstryxBannerStatus.warning,
          title: 'Latency is still above the objective',
          description: 'p95 is 2.4s against a 1.0s target.',
          announce: false,
        ),
        AstryxTabList<String>(
          label: 'Incident sections',
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'overview', label: 'Overview'),
            AstryxTab(
              value: 'timeline',
              label: 'Timeline',
              badge: AstryxBadge('4'),
            ),
            AstryxTab(value: 'notes', label: 'Notes'),
          ],
        ),
        switch (_tab) {
          'overview' => const _IncidentFacts(),
          'timeline' => const _IncidentTimeline(),
          _ => const _IncidentNotes(),
        },
      ],
    );
  }
}
```


## The header answers three questions

What is this, how bad is it, and what can I do about it. The badges and the id come first, then the title, then one line of context — and the actions sit at the trailing edge on the same line, so the primary action is reachable without reading the record.

The id is `AstryxTextType.code`, because it is a thing to be copied exactly rather than read. The identity column is `Flexible`, so a long incident title wraps instead of pushing **Resolve** off the screen.

## Actions: one button, then a menu

One [AstryxButton](button.md) for the action people came to perform, and an [AstryxDropdownMenu](dropdown_menu.md) for the rest — with the destructive item last, behind a divider, and `destructive: true` so it is coloured with the error token. A menu performs actions; it does not report a selection.

## Tabs report a value and own nothing

```dart
AstryxTabList<String>(
  label: 'Incident sections',
  value: _tab,
  onChanged: (value) => setState(() => _tab = value),
  tabs: const <AstryxTab<String>>[
    AstryxTab(value: 'overview', label: 'Overview'),
    AstryxTab(value: 'timeline', label: 'Timeline', badge: AstryxBadge('4')),
    AstryxTab(value: 'notes', label: 'Notes'),
  ],
),
switch (_tab) {
  'overview' => const _IncidentFacts(),
  'timeline' => const _IncidentTimeline(),
  _ => const _IncidentNotes(),
},
```

That is the whole panel mechanism. Because the strip owns no panel, the same field can come from a route — which is what makes a tabbed detail page linkable.

> **Careful**
>
> **The metadata list and the timeline are compositions, not components.** Upstream ships `MetadataList` and `List`; neither is ported. The label-and-value pairs are an [AstryxGrid](grid.md) of two-line stacks, and the timeline is an `AstryxVStack` with [dividers](divider.md) between rows. Both are what those components would replace, and both are exactly the code you would delete when they land.

The status banner takes `announce: false`. It is part of the page’s initial state — announcing "latency is still above the objective" on every visit is noise, and the record’s own heading has already said what this is.

## Related

- [Table](table_template.md) — the list this record is opened from.
- [Dashboard](dashboard.md) — the same data summarised.
- [AstryxTabList](tab_list.md) — the keyboard map and the overflow behaviour.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Detail page`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Detail+page&component=Detail+page) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Detail+page&area=Detail+page) — both templates arrive with the component filled in.
