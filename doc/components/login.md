---
title: Login
description: A centred sign-in form, with the validation, error and loading states a real one has.
component: true
group: Templates
source: example/lib/examples/template_login_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LoginTemplate extends StatefulWidget {
  const LoginTemplate({super.key});

  @override
  State<LoginTemplate> createState() => _LoginTemplateState();
}

class _LoginTemplateState extends State<LoginTemplate> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  /// True once the user has tried to submit. Until then, nothing is red: a form
  /// that scolds you for fields you have not reached yet is hostile.
  bool _submitted = false;
  bool _submitting = false;
  bool _rejected = false;
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  AstryxFieldStatus? get _emailStatus {
    if (!_submitted) return null;
    if (_email.text.trim().isEmpty) {
      return const AstryxFieldStatus.error('Enter your email address');
    }
    if (!looksLikeEmail(_email.text)) {
      return const AstryxFieldStatus.error('That is not an email address');
    }
    return null;
  }

  AstryxFieldStatus? get _passwordStatus {
    if (!_submitted || _password.text.isNotEmpty) return null;
    return const AstryxFieldStatus.error('Enter your password');
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _rejected = false;
    });
    if (_emailStatus != null || _passwordStatus != null) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    // The template's job is the shape of the screen, not authentication: this
    // stands in for the request, and always fails, so the error state is
    // reachable in the preview.
    setState(() {
      _submitting = false;
      _rejected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      maxWidth: 380,
      paddingBlock: AstryxSpacingToken.spacing8,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxHeading('Sign in', level: 1),
              AstryxText(
                'Use the account your workspace was created with.',
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
          // The failure goes in a banner, not a toast: the user has to act on
          // it, and it belongs beside the fields it is about.
          if (_rejected)
            const AstryxBanner(
              status: AstryxBannerStatus.error,
              title: 'That email and password do not match',
              description: 'Check the password, or reset it below.',
            ),
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            enabled: !_submitting,
            status: _emailStatus,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            onChanged: (_) => setState(() {}),
          ),
          AstryxTextInput(
            label: 'Password',
            controller: _password,
            required: true,
            enabled: !_submitting,
            status: _passwordStatus,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.password],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // A checkbox, not a switch: it applies when the form is
              // submitted, not the moment it is ticked. `Flexible`, because
              // the label has to be allowed to wrap on a narrow screen rather
              // than push the link off the edge.
              Flexible(
                child: AstryxCheckbox(
                  label: 'Keep me signed in',
                  size: AstryxToggleSize.sm,
                  value: _remember,
                  onChanged: (value) => setState(() => _remember = value),
                ),
              ),
              AstryxButton(
                label: 'Forgot password?',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          AstryxButton(
            label: 'Sign in',
            variant: AstryxButtonVariant.primary,
            loading: _submitting,
            onPressed: _submit,
          ),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            wrap: true,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              const AstryxText(
                'No account?',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              AstryxButton(
                label: 'Request access',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


## The three states

A sign-in screen is not one screen, it is four: empty, wrong, waiting, and in. Three of them are here, and each has its own widget rather than its own colour.

| State | Shown by | Why not something else |
| --- | --- | --- |
| A field the user left empty | `AstryxFieldStatus.error` on that field | It is announced assertively and it names the field. A red border says only "somewhere here". |
| Credentials the server rejected | [AstryxBanner](banner.md) above the form | It belongs to the form as a whole, not to either field — and a [toast](toast.md) would be gone before the second attempt. |
| The request in flight | `loading: true` on the submit button | The button keeps its width, stops accepting presses and is announced as busy. A separate spinner leaves the button live. |

## Validate on submit, not on keystroke

Nothing is red until `_submitted` is true. A form that marks the email field invalid while the user is still typing the local part is telling them off for being unfinished — and a screen reader announces every one of those intermediate errors.

```dart
AstryxFieldStatus? get _emailStatus {
  if (!_submitted) return null;                    // ← nothing before the first try
  if (_email.text.trim().isEmpty) {
    return const AstryxFieldStatus.error('Enter your email address');
  }
  return looksLikeEmail(_email.text)
      ? null
      : const AstryxFieldStatus.error('That is not an email address');
}
```

## Composition

```text
AstryxCenter(maxWidth: 380)
└── AstryxVStack(gap: spacing5, align: stretch)
    ├── heading + supporting line
    ├── AstryxBanner            ← only when the server said no
    ├── AstryxTextInput × 2      ← email, password
    ├── AstryxHStack(justify: between)
    │   ├── AstryxCheckbox      ← "keep me signed in"
    │   └── AstryxButton(ghost) ← "forgot password?"
    ├── AstryxButton(primary, loading:)
    └── AstryxHStack(justify: center) ← "no account?"
```

> **Note**
>
> **Keep me signed in is a checkbox, not a switch.** It applies when the form is submitted, and that is exactly the line between the two controls. A switch there would claim to have already done something.

> **Accessibility**
>
> Set `autofillHints` — `AutofillHints.email` and `AutofillHints.password`. Without them the platform cannot offer the saved credential, and a password manager is assistive technology for anybody who cannot type a 30-character secret twice.

The `textInputAction` on each field is what makes the keyboard usable: `next` moves to the password, `done` submits. On a phone that is the difference between a form you can fill in without looking down and one you cannot.

## Related

- [Login card](login_card.md) — the same form inside a bordered card.
- [SSO login](login_sso.md) — identity providers first, email second.
- [Split login](login_split.md) — the form beside a panel.
- [AstryxTextInput](text_input.md) — the field, and every property used here.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Login`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Login&component=Login) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Login&area=Login) — both templates arrive with the component filled in.
