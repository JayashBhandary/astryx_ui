---
title: Contact form
description: A single-column form with validation, an in-flight state and a success state that replaces it.
component: true
group: Templates
source: example/lib/examples/template_form_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class ContactFormTemplate extends StatefulWidget {
  const ContactFormTemplate({super.key});

  @override
  State<ContactFormTemplate> createState() => _ContactFormTemplateState();
}

class _ContactFormTemplateState extends State<ContactFormTemplate> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  String? _topic = 'bug';
  bool _submitted = false;
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  AstryxFieldStatus? _requiredStatus(String value, String message) {
    if (!_submitted || value.trim().isNotEmpty) return null;
    return AstryxFieldStatus.error(message);
  }

  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _email.text.contains('@') &&
      _message.text.trim().length >= 10;

  Future<void> _send() async {
    setState(() => _submitted = true);
    if (!_valid) return;

    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = true;
    });
  }

  void _reset() {
    _name.clear();
    _email.clear();
    _message.clear();
    setState(() {
      _submitted = false;
      _sent = false;
      _topic = 'bug';
    });
  }

  @override
  Widget build(BuildContext context) {
    // The success state replaces the form rather than sitting above it. A form
    // still on screen after it has been sent invites a second submission.
    if (_sent) {
      return AstryxCenter(
        maxWidth: 460,
        minHeight: 280,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.center,
          children: <Widget>[
            const AstryxIcon(
              AstryxIconName.success,
              size: AstryxIconSize.lg,
              color: AstryxIconColor.success,
            ),
            const AstryxHeading('Thanks — that is with us'),
            const AstryxText(
              'We reply to everything within one working day. '
              'A copy is on its way to your inbox.',
              color: AstryxTextColor.secondary,
              justify: AstryxTextJustify.center,
            ),
            AstryxButton(label: 'Send another', onPressed: _reset),
          ],
        ),
      );
    }

    return AstryxCenter(
      maxWidth: 460,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxHeading('Talk to us', level: 1),
              AstryxText(
                'Bugs, access requests, or anything the docs did not answer.',
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
          AstryxTextInput(
            label: 'Name',
            controller: _name,
            required: true,
            enabled: !_sending,
            status: _requiredStatus(_name.text, 'Tell us who you are'),
            autofillHints: const <String>[AutofillHints.name],
            onChanged: (_) => setState(() {}),
          ),
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            enabled: !_sending,
            status: _submitted && !_email.text.contains('@')
                ? const AstryxFieldStatus.error(
                    'We need somewhere to reply to',
                  )
                : null,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const <String>[AutofillHints.email],
            onChanged: (_) => setState(() {}),
          ),
          AstryxSelector<String>(
            label: 'Topic',
            value: _topic,
            enabled: !_sending,
            onChanged: (value) => setState(() => _topic = value),
            options: const <AstryxSelectorEntry<String>>[
              AstryxSelectorOption(
                value: 'bug',
                label: 'Something is broken',
                description: 'A page, an export, an integration',
              ),
              AstryxSelectorOption(
                value: 'access',
                label: 'Access request',
                description: 'A workspace, a role, a seat',
              ),
              AstryxSelectorOption(value: 'billing', label: 'Billing'),
              AstryxSelectorOption(value: 'other', label: 'Something else'),
            ],
          ),
          AstryxTextArea(
            label: 'Message',
            controller: _message,
            required: true,
            enabled: !_sending,
            status: _submitted && _message.text.trim().length < 10
                ? const AstryxFieldStatus.error(
                    'A sentence or two, so we can route it',
                  )
                : null,
            placeholder: 'What happened, and what you expected instead.',
            maxLength: 1000,
            onChanged: (_) => setState(() {}),
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(
                label: 'Clear',
                enabled: !_sending,
                onPressed: _reset,
              ),
              AstryxButton(
                label: 'Send message',
                variant: AstryxButtonVariant.primary,
                loading: _sending,
                onPressed: _send,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


Fill in nothing and press **Send message** to see the validation; fill it in properly to see the success state.

## The success state replaces the form

It does not sit above it. A form still on screen after it has been submitted is an invitation to submit it again, and the second copy of a support request is worse than none — somebody now has to work out whether they are duplicates.

```dart
if (_sent) {
  return AstryxCenter(/* icon, heading, what happens next, "Send another" */);
}
return AstryxCenter(/* the form */);
```

The success state also says what happens next — "we reply within one working day" — because "Thanks!" alone leaves the user wondering whether anything was actually recorded.

## One measure, one column

`AstryxCenter(maxWidth: 460)` is doing the layout. A form field wider than about 460 makes the label and the value hard to associate, and a two-column contact form makes the reader guess the tab order.

## Which control for which question

| Field | Control | Because |
| --- | --- | --- |
| Name, email | [AstryxTextInput](text_input.md) | Free text, one line, with `autofillHints` so the platform can fill them. |
| Topic | [AstryxSelector](selector.md) | One value out of four, and it needs `description`s to be unambiguous. A [menu](dropdown_menu.md) performs actions and reports nothing. |
| Message | [AstryxTextArea](text_area.md) | Multi-line, grows with the content, and takes a `maxLength` the user can see. |

> **Accessibility**
>
> Every validation message says what to do, not what went wrong: "Tell us who you are", not "Invalid". The status is announced assertively, so it is the entire instruction a screen-reader user receives.

## Related

- [Two-column form](form_two_column.md) — for a long form with sections.
- [AstryxField](field.md) — the label, description and status around a control of your own.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

