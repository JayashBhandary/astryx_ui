---
title: Two-column form
description: A long form split into labelled sections, with the section heading beside its fields.
component: true
group: Templates
source: example/lib/examples/template_form_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class FormTwoColumnTemplate extends StatefulWidget {
  const FormTwoColumnTemplate({super.key});

  @override
  State<FormTwoColumnTemplate> createState() => _FormTwoColumnTemplateState();
}

class _FormTwoColumnTemplateState extends State<FormTwoColumnTemplate> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _domain = TextEditingController(
    text: 'atlas.example.com',
  );
  final TextEditingController _bio = TextEditingController();

  String? _region = 'eu';
  String? _visibility = 'members';
  final Set<String> _digests = <String>{'weekly'};
  bool _dirty = false;

  @override
  void dispose() {
    _name.dispose();
    _domain.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _touch() => setState(() => _dirty = true);

  @override
  Widget build(BuildContext context) {
    // Each section is a label column and a field column. Under
    // `formTwoColumnMinWidth` the label column moves above its fields instead
    // of squeezing, which is the whole responsive story — no breakpoint tokens,
    // no second layout to maintain.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // The saved-state badge sits beside the title at width and under it
        // when there is no room. `Flexible` on the title is what lets the
        // supporting line wrap instead of pushing the badge off the edge.
        LayoutBuilder(
          builder: (context, constraints) {
            const title = AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading('Workspace settings', level: 1),
                AstryxText(
                  'Applies to everyone in Atlas.',
                  color: AstryxTextColor.secondary,
                ),
              ],
            );
            final badge = AstryxBadge(
              _dirty ? 'Unsaved changes' : 'Saved',
              variant: _dirty
                  ? AstryxBadgeVariant.warning
                  : AstryxBadgeVariant.success,
              icon: AstryxIcon(
                _dirty ? AstryxIconName.warning : AstryxIconName.success,
              ),
            );

            return constraints.maxWidth < formTwoColumnMinWidth
                ? AstryxVStack(
                    gap: AstryxSpacingToken.spacing2,
                    children: <Widget>[title, badge],
                  )
                : AstryxHStack(
                    gap: AstryxSpacingToken.spacing3,
                    justify: AstryxStackJustify.between,
                    align: AstryxStackAlign.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Flexible(child: title),
                      badge,
                    ],
                  );
          },
        ),
        _FormSection(
          title: 'Identity',
          description: 'How the workspace is named and reached.',
          children: <Widget>[
            AstryxTextInput(
              label: 'Workspace name',
              controller: _name,
              required: true,
              placeholder: 'Atlas',
              onChanged: (_) => _touch(),
            ),
            AstryxTextInput(
              label: 'Primary domain',
              controller: _domain,
              description: 'Members with this email domain join automatically.',
              onChanged: (_) => _touch(),
            ),
            AstryxSelector<String>(
              label: 'Data region',
              value: _region,
              description: 'Cannot be changed after the first write.',
              onChanged: (value) => setState(() {
                _region = value;
                _dirty = true;
              }),
              options: const <AstryxSelectorEntry<String>>[
                AstryxSelectorSection('Europe'),
                AstryxSelectorOption(value: 'eu', label: 'Frankfurt (eu-1)'),
                AstryxSelectorOption(value: 'uk', label: 'London (uk-1)'),
                AstryxSelectorSection('North America'),
                AstryxSelectorOption(value: 'us', label: 'Virginia (us-1)'),
              ],
            ),
          ],
        ),
        const AstryxDivider(),
        _FormSection(
          title: 'Access',
          description:
              'Who can see the workspace, and what they get by '
              'default.',
          children: <Widget>[
            AstryxRadioList<String>(
              label: 'Visibility',
              value: _visibility,
              onChanged: (value) => setState(() {
                _visibility = value;
                _dirty = true;
              }),
              options: const <AstryxRadioOption<String>>[
                AstryxRadioOption(
                  value: 'members',
                  label: 'Members only',
                  description: 'Anyone signed in to the workspace.',
                ),
                AstryxRadioOption(
                  value: 'invite',
                  label: 'Invite only',
                  description: 'Named people, one at a time.',
                ),
                AstryxRadioOption(
                  value: 'public',
                  label: 'Anyone with the link',
                  description: 'Read-only, no sign-in.',
                ),
              ],
            ),
            AstryxTextArea(
              label: 'Joining note',
              controller: _bio,
              optional: true,
              placeholder: 'Shown on the invitation screen.',
              onChanged: (_) => _touch(),
            ),
          ],
        ),
        const AstryxDivider(),
        _FormSection(
          title: 'Digests',
          description:
              'Checkboxes, because none of this applies until you '
              'save.',
          children: <Widget>[
            for (final digest in const <List<String>>[
              <String>['weekly', 'Weekly summary', 'Mondays, 9am local time'],
              <String>['incidents', 'Incident recap', 'After every incident'],
              <String>['billing', 'Billing statement', 'On the 1st'],
            ])
              AstryxCheckbox(
                label: digest[1],
                description: digest[2],
                value: _digests.contains(digest[0]),
                onChanged: (value) => setState(() {
                  _dirty = true;
                  if (value) {
                    _digests.add(digest[0]);
                  } else {
                    _digests.remove(digest[0]);
                  }
                }),
              ),
          ],
        ),
        const AstryxDivider(),
        // `wrap`, so the pair drops onto two lines on a phone rather than
        // overflowing. Buttons size to their labels, so nothing is squeezed.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          runGap: AstryxSpacingToken.spacing2,
          wrap: true,
          justify: AstryxStackJustify.end,
          children: <Widget>[
            AstryxButton(
              label: 'Discard',
              enabled: _dirty,
              onPressed: () => setState(() => _dirty = false),
            ),
            AstryxButton(
              label: 'Save changes',
              variant: AstryxButtonVariant.primary,
              enabled: _dirty,
              onPressed: () => setState(() => _dirty = false),
            ),
          ],
        ),
      ],
    );
  }
}
```

Narrow the window: below 620 each section’s label moves above its fields instead of squeezing.


## What the second column is for

Not two columns of fields — two columns of *purpose*. The reading column explains the section, the other one holds the controls. A long settings form scanned for the right section is much faster to use than one where every heading is a full-width band the eye has to cross.

```text
_FormSection
└── LayoutBuilder
    ├── wide   → AstryxHStack ── SizedBox(width: 220) → heading + description
    │                         └── Expanded            → the fields
    └── narrow → AstryxVStack ── heading + description, then the fields
```

The breakpoint is a `LayoutBuilder` and one constant, not a breakpoint system. The section knows the width it needs; the builder knows the width it has. Nothing else in the application has to agree about it, and the same form works in a panel, a dialog and a page.

## Checkboxes, because there is a Save button

Every toggle in this form is an [AstryxCheckbox](checkbox.md), and the digest section says so out loud. The screen has **Discard** and **Save changes** at the bottom, so nothing may take effect before they are pressed — and a [switch](switch.md) would promise exactly that. The [settings](settings.md) template is the other half of this rule: switches, and no Save button anywhere.

## Saying whether there is anything to save

A badge in the header tracks `_dirty`, and both footer buttons are `enabled: _dirty`. The pairing matters: a disabled Save with no explanation reads as broken, and a badge that says *Unsaved changes* turns it into a state the user can see and act on.

> **Accessibility**
>
> The badge carries an icon as well as a colour — `warning` for unsaved, `success` for saved. Colour is never the only signal; in greyscale, or to a colour-blind reader, the icon and the words are what remain.

## Related

- [Contact form](contact_form.md) — one column, and a success state.
- [Settings](settings.md) — the same content as switches, applying immediately.
- [AstryxRadioList](radio_list.md) — one visible choice out of a few.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

