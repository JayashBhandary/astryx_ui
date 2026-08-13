---
title: Settings with sidebar
description: Settings sections reached from a sidebar.
component: true
group: Templates
source: example/lib/examples/template_settings_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SettingsSidebarTemplate extends StatefulWidget {
  const SettingsSidebarTemplate({super.key});

  @override
  State<SettingsSidebarTemplate> createState() =>
      _SettingsSidebarTemplateState();
}

class _SettingsSidebarTemplateState extends State<SettingsSidebarTemplate> {
  /// The sections, as navigation rather than as headings on one long page.
  ///
  /// Past about four sections a settings page stops being scannable, and the
  /// reader is scrolling to find out what exists. A rail answers that question
  /// without scrolling anything.
  static const List<AstryxNavEntry> _sections = <AstryxNavEntry>[
    AstryxNavSection(
      label: 'You',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'profile',
          label: 'Profile',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.check)),
        ),
        AstryxNavItem(
          id: 'notifications',
          label: 'Notifications',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.info)),
          trailing: AstryxBadge('2'),
        ),
        AstryxNavItem(
          id: 'appearance',
          label: 'Appearance',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
        ),
      ],
    ),
    AstryxNavSection(
      label: 'Workspace',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'members',
          label: 'Members',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.checkDouble)),
        ),
        AstryxNavItem(
          id: 'security',
          label: 'Security',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.eyeSlash)),
        ),
      ],
    ),
    AstryxNavDivider(),
    AstryxNavItem(
      id: 'danger',
      label: 'Delete workspace',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.warning)),
    ),
  ];

  static const Map<String, ({String title, String description})> _headings =
      <String, ({String title, String description})>{
        'profile': (
          title: 'Profile',
          description: 'How you appear to everyone else in the workspace.',
        ),
        'notifications': (
          title: 'Notifications',
          description: 'What reaches you, and how loudly.',
        ),
        'appearance': (
          title: 'Appearance',
          description: 'Yours only. Nobody else sees these.',
        ),
        'members': (
          title: 'Members',
          description: 'Who is in this workspace, and what they may do.',
        ),
        'security': (
          title: 'Security',
          description: 'Sign-in, sessions and tokens.',
        ),
        'danger': (
          title: 'Delete workspace',
          description: 'Everything in it goes, thirty days later.',
        ),
      };

  final Set<String> _on = <String>{'mentions', 'incidents', 'digest'};
  final AstryxDialogController _confirm = AstryxDialogController();

  String _section = 'notifications';
  String? _theme = 'system';

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  /// Every control here applies the moment it moves, so every one of them
  /// confirms. There is no Save button anywhere on this screen — adding one
  /// would make every switch a lie.
  void _toggle(String id, String label, {required bool value}) {
    setState(() {
      if (value) {
        _on.add(id);
      } else {
        _on.remove(id);
      }
    });
    AstryxToastScope.of(context).show(
      AstryxToast(message: '$label ${value ? 'on' : 'off'}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heading = _headings[_section]!;

    // The rail sits *beside* the layout rather than in its `panel`. A panel is
    // wrapped in a scroll view, so it is handed an unbounded height — and an
    // `AstryxSideNav` pins its own footer with an `Expanded`, which cannot be
    // laid out against one. Beside it, the rail gets the height of the frame,
    // which is what it wants.
    return SizedBox(
      height: 560,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 232,
            // A rail of sections, not a tab strip: these are *places* in a
            // settings area rather than views of one thing, and there are
            // more of them than a strip can hold without scrolling sideways.
            child: AstryxSideNav(
              label: 'Settings sections',
              entries: _sections,
              selectedId: _section,
              onSelected: (id) => setState(() => _section = id),
            ),
          ),
          const AstryxDivider(axis: Axis.vertical),
          Expanded(
            child: AstryxLayout(
              maxContentWidth: 620,
              header: AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                children: <Widget>[
                  AstryxHeading(heading.title, level: 1),
                  AstryxText(
                    heading.description,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
              child: switch (_section) {
                'notifications' => _notifications(),
                'appearance' => _appearance(),
                'danger' => _danger(context),
                _ => _placeholder(heading.title),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifications() {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing0,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final row in const <List<String>>[
            <String>['mentions', 'Mentions', 'When someone @s you'],
            <String>[
              'incidents',
              'Incidents',
              'Every Sev-1, however it was raised',
            ],
            <String>['digest', 'Weekly digest', 'Monday morning, once'],
            <String>['marketing', 'Product news', 'Roughly monthly'],
          ])
            Padding(
              padding: const EdgeInsets.all(16),
              child: AstryxSwitch(
                label: row[1],
                description: row[2],
                value: _on.contains(row[0]),
                labelPosition: AstryxToggleLabelPosition.start,
                labelSpacing: AstryxToggleLabelSpacing.spread,
                onChanged: (value) => _toggle(row[0], row[1], value: value),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appearance() {
    return AstryxCard(
      child: AstryxSelector<String>(
        label: 'Theme',
        description: 'Applies as soon as it is chosen.',
        value: _theme,
        onChanged: (value) => setState(() => _theme = value),
        options: const <AstryxSelectorOption<String>>[
          AstryxSelectorOption(value: 'system', label: 'Match the system'),
          AstryxSelectorOption(value: 'light', label: 'Light'),
          AstryxSelectorOption(value: 'dark', label: 'Dark'),
        ],
      ),
    );
  }

  /// The destructive section is a destination of its own here, rather than the
  /// bottom of a long page — which is the one thing a sidebar changes about
  /// the [SettingsTemplate] shape.
  Widget _danger(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxBanner(
          status: AstryxBannerStatus.warning,
          title: 'This cannot be undone after thirty days',
          description:
              'Drafts, saved views and every uploaded asset go with the '
              'workspace.',
          announce: false,
        ),
        AstryxCard(
          variant: const AstryxCardVariant.palette(AstryxPalette.red),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Flexible(
                child: AstryxText(
                  'Deleting removes the workspace for all eleven members.',
                ),
              ),
              AstryxButton(
                label: 'Delete workspace',
                variant: AstryxButtonVariant.destructive,
                onPressed: _confirm.show,
              ),
            ],
          ),
        ),
        // The button is not the confirmation; the dialog is, and it states
        // what is actually lost rather than asking "are you sure?".
        AstryxAlertDialog(
          controller: _confirm,
          title: 'Delete this workspace?',
          description:
              'Eleven members lose access immediately. Everything in the '
              'workspace is deleted permanently after thirty days.',
          confirmLabel: 'Delete workspace',
          destructive: true,
          onConfirm: () => AstryxToastScope.of(context).show(
            const AstryxToast(message: 'Workspace scheduled for deletion'),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(String title) {
    return AstryxCard(
      child: AstryxText(
        'The $title section would go here. It is one field of state and a '
        '`switch` expression away — which is exactly what makes a settings '
        'area with a rail no harder than one without.',
      ),
    );
  }
}
```


## Three shapes, one rule

This is the third framing of the same screen, and the only thing that changes between them is how a section is reached. Which one to reach for is a question about how many sections there are, not about taste:

| Sections | Shape | Reached by |
| --- | --- | --- |
| Two or three | [Settings](settings.md) | Scrolling. Every section is on screen, or one flick away. |
| Three or four, in a modal | [Settings dialog](settings_dialog.md) | An [AstryxTabList](tab_list.md) inside the dialog. |
| Five or more | This one | An [AstryxSideNav](side_nav.md) beside the content. Past about four, a long page stops being scannable and the reader is scrolling to find out what exists. |

The rule underneath all three is the same one: every control here is an [AstryxSwitch](switch.md) or an [AstryxSelector](selector.md) and applies immediately, so there is no Save button anywhere. A form with a Save button is the other shape entirely — see the [two-column form](form_two_column.md).

## A rail, not a tab strip

These are *places* in a settings area rather than views of one thing, which is the line between [AstryxSideNav](side_nav.md) and [AstryxTabList](tab_list.md). A rail also holds headings over groups — **You** and **Workspace** here — and a strip has no room for one.

```text
Row
├── SizedBox(232) → AstryxSideNav: You · Workspace · Delete workspace
├── AstryxDivider(axis: vertical)
└── Expanded → AstryxLayout(maxContentWidth: 620)
    ├── header ← the section’s title and its one-line description
    └── child  ← switch (_section) → the section’s controls
```

> **Careful**
>
> **The rail sits beside the layout, not in its `panel`.** [AstryxLayout](layout.md) wraps a panel in a scroll view, so a panel is handed an *unbounded* height — and [AstryxSideNav](side_nav.md) pins its own footer with an `Expanded`, which cannot be laid out against one. Beside the layout, in a `Row` with `crossAxisAlignment: stretch`, the rail gets the height of the frame, which is what it wants. A panel is the right slot for content that sizes itself — the filter list on [library](library.md), the outline on [documentation](documentation.md).

The section on screen is one field of state and a `switch` expression, exactly as it is in the dialog. That is what makes a settings area with a rail no harder to build than one without — and what makes each section linkable from a route.

## The destructive section becomes a destination

On the [one-page version](settings.md) the red card is the last thing on the page, because that is the only place it can be. Here it is a navigation row of its own — which is better: nobody scrolls past it by accident, and nobody has to scroll to it on purpose.

> **Careful**
>
> The row is still not the confirmation. It leads to a screen that states what is lost — eleven members immediately, everything after thirty days — and an [AstryxAlertDialog](alert_dialog.md) states it again before anything happens. "Are you sure?" is a question nobody has ever answered no to on the strength of the question alone.

> **Accessibility**
>
> The rail carries `label: 'Settings sections'`, and the section heading in the layout header is `level: 1`. Without both, a screen-reader user moving between sections is told the name of the application and nothing about where they have just arrived.

## Related

- [Settings](settings.md) — the same content as one page.
- [Settings dialog](settings_dialog.md) — the same content in a modal.
- [AstryxSideNav](side_nav.md) — the rail, its sections and its rows.
- [AstryxSwitch](switch.md) — and why there is no Save button here.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Settings with sidebar`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Settings+with+sidebar&component=Settings+with+sidebar) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Settings+with+sidebar&area=Settings+with+sidebar) — both templates arrive with the component filled in.
