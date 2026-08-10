---
title: Settings
description: Grouped preference rows with inline controls, each applying the moment it changes.
component: true
group: Templates
source: example/lib/examples/template_settings_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SettingsTemplate extends StatefulWidget {
  const SettingsTemplate({super.key});

  @override
  State<SettingsTemplate> createState() => _SettingsTemplateState();
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  final Set<String> _on = <String>{'mentions', 'incidents'};
  final AstryxDialogController _leave = AstryxDialogController();

  String? _theme = 'system';
  String? _startPage = 'dashboard';

  @override
  void dispose() {
    _leave.dispose();
    super.dispose();
  }

  /// Applies a switch immediately, and says so. A setting that takes effect
  /// silently and a setting that failed to save look identical.
  void _toggle(String id, String label, bool value) {
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
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxHeading('Settings', level: 1),
            AstryxText(
              'Yours only. Workspace-wide settings live under Admin.',
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // Notifications are switches: each one is in force the moment it moves,
        // and there is no Save button on the screen to suggest otherwise.
        AstryxCard(
          header: const _SectionHeader(
            title: 'Notifications',
            description: 'Applied as you change them.',
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (final row in const <List<String>>[
                <String>['mentions', 'Mentions', 'When someone @s you'],
                <String>['incidents', 'Incidents', 'Sev-1 and Sev-2 only'],
                <String>['digest', 'Weekly digest', 'Mondays, 9am'],
                <String>['marketing', 'Product news', 'About once a month'],
              ]) ...<Widget>[
                if (row.first != 'mentions') const AstryxDivider(),
                AstryxSwitch(
                  label: row[1],
                  description: row[2],
                  value: _on.contains(row.first),
                  labelPosition: AstryxToggleLabelPosition.start,
                  labelSpacing: AstryxToggleLabelSpacing.spread,
                  onChanged: (value) => _toggle(row.first, row[1], value),
                ),
              ],
            ],
          ),
        ),
        AstryxCard(
          header: const _SectionHeader(
            title: 'Appearance',
            description: 'Stored on this device.',
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxSelector<String>(
                label: 'Colour mode',
                value: _theme,
                onChanged: (value) => setState(() => _theme = value),
                options: const <AstryxSelectorEntry<String>>[
                  AstryxSelectorOption(
                    value: 'system',
                    label: 'Match the system',
                    description: 'Follows your OS setting as it changes',
                  ),
                  AstryxSelectorOption(value: 'light', label: 'Light'),
                  AstryxSelectorOption(value: 'dark', label: 'Dark'),
                ],
              ),
              AstryxSelector<String>(
                label: 'Open on',
                value: _startPage,
                onChanged: (value) => setState(() => _startPage = value),
                options: const <AstryxSelectorEntry<String>>[
                  AstryxSelectorOption(
                    value: 'dashboard',
                    label: 'Dashboard',
                  ),
                  AstryxSelectorOption(value: 'incidents', label: 'Incidents'),
                  AstryxSelectorOption(value: 'projects', label: 'Projects'),
                ],
              ),
            ],
          ),
        ),
        // The destructive section is last, is bordered in its own right, and
        // goes through a dialog. The button alone is not the confirmation.
        AstryxCard(
          variant: const AstryxCardVariant.palette(AstryxPalette.red),
          header: const _SectionHeader(
            title: 'Leave workspace',
            description: 'You will lose access to Atlas immediately.',
          ),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxButton(
                label: 'Leave Atlas',
                variant: AstryxButtonVariant.destructive,
                onPressed: _leave.show,
              ),
              AstryxDialog(
                controller: _leave,
                title: 'Leave Atlas?',
                description: 'An admin has to invite you back.',
                footer: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  justify: AstryxStackJustify.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AstryxButton(label: 'Stay', onPressed: _leave.hide),
                    AstryxButton(
                      label: 'Leave',
                      variant: AstryxButtonVariant.destructive,
                      onPressed: _leave.hide,
                    ),
                  ],
                ),
                child: const AstryxText(
                  'Your drafts and saved views are deleted after 30 days. '
                  'Anything you published stays with the workspace.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```


## Switches, and therefore no Save button

This is the rule the whole template is arranged around. An [AstryxSwitch](switch.md) means *in force now*; an [AstryxCheckbox](checkbox.md) means *when you submit*. So there is no Save button anywhere on this screen — adding one would make every switch a lie — and each change shows a [toast](toast.md) confirming it, because a setting that saved silently and a setting that failed to save look identical.

A form with a Save button is the other shape entirely: see the [two-column form](form_two_column.md).

## The settings-row shape

Label at the reading edge, control at the trailing one. Two properties do it, and they are the reason this looks like a settings list rather than a column of switches:

```dart
AstryxSwitch(
  label: 'Mentions',
  description: 'When someone @s you',
  value: on,
  labelPosition: AstryxToggleLabelPosition.start,   // ← label first
  labelSpacing: AstryxToggleLabelSpacing.spread,    // ← control at the far edge
  onChanged: (value) => …,
)
```

Rows are separated by an [AstryxDivider](divider.md) rather than by extra space, which keeps the label and its description associated with each other instead of floating between two rows.

## Sections are cards

```text
AstryxVStack(gap: spacing6)
├── heading + supporting line
├── AstryxCard  ← Notifications: four switch rows, divided
├── AstryxCard  ← Appearance: two selectors
└── AstryxCard(variant: palette(red))  ← the destructive section, last
```

## The destructive section

Last on the page, in a red-palette card, behind an [AstryxDialog](dialog.md). The button is not the confirmation: the dialog is, and it states what is actually lost — drafts and saved views, after thirty days — rather than asking "are you sure?", which nobody has ever answered no to on the strength of the question alone.

> **Careful**
>
> The red card is `AstryxCardVariant.palette(AstryxPalette.red)`, and the palettes are **categorical, not semantic**. It is used here for the boundary of the section, with the destructive `variant` on the button and the dialog carrying the actual severity.

## Related

- [Settings dialog](settings_dialog.md) — the same content in a modal.
- [Two-column form](form_two_column.md) — the version with a Save button.
- [AstryxSwitch](switch.md) — and why it is not a checkbox.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

