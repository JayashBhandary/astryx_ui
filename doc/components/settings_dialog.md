---
title: Settings dialog
description: Settings inside a modal, with its own navigation.
component: true
group: Templates
source: example/lib/examples/template_settings_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SettingsDialogTemplate extends StatefulWidget {
  const SettingsDialogTemplate({super.key});

  @override
  State<SettingsDialogTemplate> createState() => _SettingsDialogTemplateState();
}

class _SettingsDialogTemplateState extends State<SettingsDialogTemplate> {
  final AstryxDialogController _controller = AstryxDialogController();
  final TextEditingController _name = TextEditingController(text: 'Ada');

  /// The dialog's own navigation. A tab list reports a value and owns no panel,
  /// so the section on screen is this field and nothing else.
  String _section = 'profile';
  bool _compact = false;
  final Set<String> _on = <String>{'mentions'};

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Open settings',
          leading: const AstryxIcon(AstryxIconName.wrench),
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Settings',
          width: 520,
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Close', onPressed: _controller.hide),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing5,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxTabList<String>(
                label: 'Settings sections',
                value: _section,
                onChanged: (value) => setState(() => _section = value),
                tabs: const <AstryxTab<String>>[
                  AstryxTab(value: 'profile', label: 'Profile'),
                  AstryxTab(value: 'notifications', label: 'Notifications'),
                  AstryxTab(value: 'advanced', label: 'Advanced'),
                ],
              ),
              switch (_section) {
                'profile' => AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxTextInput(
                      label: 'Display name',
                      controller: _name,
                      required: true,
                    ),
                    const AstryxTextInput(
                      label: 'Email',
                      readOnly: true,
                      // Read-only, not disabled: the value matters, it is just
                      // not yours to change here.
                      description: 'Managed by your identity provider.',
                      placeholder: 'ada@example.com',
                    ),
                  ],
                ),
                'notifications' => AstryxVStack(
                  gap: AstryxSpacingToken.spacing3,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    for (final row in const <List<String>>[
                      <String>['mentions', 'Mentions'],
                      <String>['replies', 'Replies to my comments'],
                      <String>['deploys', 'Deploy failures'],
                    ])
                      AstryxSwitch(
                        label: row[1],
                        value: _on.contains(row.first),
                        labelPosition: AstryxToggleLabelPosition.start,
                        labelSpacing: AstryxToggleLabelSpacing.spread,
                        onChanged: (value) => setState(() {
                          if (value) {
                            _on.add(row.first);
                          } else {
                            _on.remove(row.first);
                          }
                        }),
                      ),
                  ],
                ),
                _ => AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxSwitch(
                      label: 'Compact tables',
                      description: 'More rows, less room in each.',
                      value: _compact,
                      labelPosition: AstryxToggleLabelPosition.start,
                      labelSpacing: AstryxToggleLabelSpacing.spread,
                      onChanged: (value) => setState(() => _compact = value),
                    ),
                    const AstryxBanner(
                      title: 'Changes here apply immediately',
                      description: 'There is no Save button, by design.',
                      announce: false,
                    ),
                  ],
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}
```


## Navigation inside a modal

An [AstryxTabList](tab_list.md) reports a value and owns no panel, so the section on screen is one field of state and a `switch` expression. That is what makes tabs usable inside a dialog: there is no hidden panel stack to keep in step with the tab strip, and the dialog’s body scrolls the section that is showing.

```text
AstryxDialog(width: 520)
├── title   ← "Settings", and the dialog’s accessible name
├── child
│   ├── AstryxTabList  ← Profile · Notifications · Advanced
│   └── switch (_section) → the section’s controls
└── footer  ← Close, pinned below the scrolling body
```

## Read-only is not disabled

The email field is `readOnly: true`, not `enabled: false`. The value matters and is worth reading — it is simply not yours to change here, because the identity provider owns it. `enabled: false` dims it to the point where it stops being information.

> **Note**
>
> A dialog is a widget in the tree driven by an `AstryxDialogController`, not a `showDialog` call. It renders nothing until the controller opens it, so it sits next to the button that opens it and the state stays yours — including which tab was last open.

> **Accessibility**
>
> `title` is the dialog’s accessible name, focus is trapped inside while it is open, and it returns to the trigger on close. The tab strip has its own `label`, because "Profile Notifications Advanced" with no context is not a name.

The Advanced section carries a banner with `announce: false`: it is part of the panel’s initial state, not news, and announcing it every time the tab changes is noise.

## Related

- [Settings](settings.md) — the full-page version.
- [AstryxDialog](dialog.md) — the controller, the focus trap and the slots.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

