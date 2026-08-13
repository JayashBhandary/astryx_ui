---
title: Login card
description: Sign-in inside a bordered card, using all three card slots.
component: true
group: Templates
source: example/lib/examples/template_login_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LoginCardTemplate extends StatefulWidget {
  const LoginCardTemplate({super.key});

  @override
  State<LoginCardTemplate> createState() => _LoginCardTemplateState();
}

class _LoginCardTemplateState extends State<LoginCardTemplate> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    // The card's three slots carry the three parts of the screen: who this is
    // for, what to fill in, what to press. `padding` is both the inset and the
    // gap between them, so the rhythm cannot drift.
    return AstryxCenter(
      paddingBlock: AstryxSpacingToken.spacing8,
      child: AstryxCard(
        width: 380,
        elevation: AstryxElevation.low,
        padding: AstryxSpacingToken.spacing5,
        header: const AstryxHStack(
          justify: AstryxStackJustify.between,
          align: AstryxStackAlign.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing1,
                children: <Widget>[
                  AstryxHeading('Sign in to Atlas'),
                  AstryxText(
                    'Internal tools for the platform team.',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxBadge('Staging', variant: AstryxBadgeVariant.warning),
          ],
        ),
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxButton(
              label: 'Sign in',
              variant: AstryxButtonVariant.primary,
              loading: _submitting,
              onPressed: _submit,
            ),
            const AstryxText(
              'By signing in you accept the acceptable-use policy.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              justify: AstryxTextJustify.center,
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxTextInput(
              label: 'Email',
              controller: _email,
              required: true,
              enabled: !_submitting,
              placeholder: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              autofillHints: const <String>[AutofillHints.email],
            ),
            AstryxTextInput(
              label: 'Password',
              controller: _password,
              required: true,
              enabled: !_submitting,
              obscureText: true,
              autofillHints: const <String>[AutofillHints.password],
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
```


## Why the slots matter

The card is doing real work here, not decoration. Its three slots carry the three questions the screen answers — who is this for, what do I type, what do I press — and `padding` is *both* the card’s inset and the gap between the slots. One number, so the internal rhythm of the card cannot drift the way a hand-spaced column can.

```text
AstryxCard(width: 380, padding: spacing5, elevation: low)
├── header  ← name of the thing, plus an environment badge
├── child   ← the two fields, stretched
└── footer  ← the primary action and the terms line
```

## The badge is a warning, and says so

The `Staging` badge takes `AstryxBadgeVariant.warning` rather than a palette colour. Signing in to the wrong environment is a mistake worth preventing, and the semantic variant is what makes it read as a caution instead of a category.

> **Note**
>
> One elevation step, not three. `AstryxElevation.low` lifts the card off the body; anything higher belongs to things that float *above* the page — [popovers](popover.md), [dialogs](dialog.md) — and a login card is the page.

## Related

- [Login](login.md) — the same form with no card, and the error state.
- [AstryxCard](card.md) — the slots, the variants and the elevation scale.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Login card`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Login+card&component=Login+card) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Login+card&area=Login+card) — both templates arrive with the component filled in.
