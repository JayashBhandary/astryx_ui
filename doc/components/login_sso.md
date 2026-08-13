---
title: SSO login
description: Sign-in through identity providers, with an email link as the fallback.
component: true
group: Templates
source: example/lib/examples/template_login_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class LoginSsoTemplate extends StatefulWidget {
  const LoginSsoTemplate({super.key});

  @override
  State<LoginSsoTemplate> createState() => _LoginSsoTemplateState();
}

class _LoginSsoTemplateState extends State<LoginSsoTemplate> {
  final TextEditingController _email = TextEditingController();

  /// Which provider is being redirected to, if any. One at a time: a second
  /// press while a redirect is in flight is a bug, not a feature.
  String? _redirecting;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _redirect(String provider) async {
    setState(() => _redirecting = provider);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() => _redirecting = null);
  }

  @override
  Widget build(BuildContext context) {
    const providers = <String>['Okta', 'Google Workspace', 'Microsoft Entra'];

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
              AstryxHeading('Continue to Atlas', level: 1),
              AstryxText(
                'Single sign-on is how most people get in.',
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
          // Each provider is its own button, stacked and stretched. The
          // trailing icon says "this leaves the page", which is the one thing
          // an SSO button has to promise.
          AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (final provider in providers)
                AstryxButton(
                  label: 'Continue with $provider',
                  loading: _redirecting == provider,
                  enabled: _redirecting == null || _redirecting == provider,
                  trailing: const AstryxIcon(
                    AstryxIconName.externalLink,
                    size: AstryxIconSize.sm,
                  ),
                  onPressed: () => _redirect(provider),
                ),
            ],
          ),
          // A labelled divider is the whole "or" affordance — no extra text
          // widget, no hand-spaced rules either side of it.
          const AstryxDivider(label: 'or use your email'),
          AstryxTextInput(
            label: 'Work email',
            controller: _email,
            required: true,
            enabled: _redirecting == null,
            placeholder: 'you@example.com',
            description: 'We will email you a sign-in link.',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const <String>[AutofillHints.email],
            onChanged: (_) => setState(() {}),
          ),
          AstryxButton(
            label: 'Email me a link',
            variant: AstryxButtonVariant.primary,
            enabled: _redirecting == null && looksLikeEmail(_email.text),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```


## Order is the whole design

In an internal tool almost everybody arrives through the identity provider, so the providers come first, at full width, and the email fallback sits below a labelled rule. Putting the email field first makes the majority scroll past the thing they need.

That rule is one widget: `AstryxDivider(label: 'or use your email')`. Two hand-placed rules either side of a centred word is the usual version of this, and it drifts the moment the text changes length.

## One redirect at a time

While a provider is being redirected to, that button is `loading` and every other one is `enabled: false`. Two SSO handshakes in flight at once is a bug the user cannot see and cannot recover from.

```dart
AstryxButton(
  label: 'Continue with $provider',
  loading: _redirecting == provider,
  enabled: _redirecting == null || _redirecting == provider,
  trailing: const AstryxIcon(AstryxIconName.externalLink,
      size: AstryxIconSize.sm),
  onPressed: () => _redirect(provider),
)
```

> **Note**
>
> The trailing `externalLink` icon is the one promise an SSO button has to keep: this leaves the page. The icon registry ships no provider logos — swap in your own registry, or an `AstryxIconButton.custom`, if you want the Okta mark.

> **Accessibility**
>
> The email fallback’s submit button is disabled until the address is plausible, and the field carries a `description` saying what pressing it does. A disabled button with no stated reason is a dead end for everyone and an unexplained one for a screen-reader user.

## Related

- [Login](login.md) — password sign-in, with the rejected state.
- [AstryxDivider](divider.md) — the labelled rule.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `SSO login`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+SSO+login&component=SSO+login) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+SSO+login&area=SSO+login) — both templates arrive with the component filled in.
