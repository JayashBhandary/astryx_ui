# Templates

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## Login

`example/lib/examples/template_login_examples.dart`

A centred sign-in form, with the validation, error and loading states a real one has.

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

**Rules**

- **Note:** **Keep me signed in is a checkbox, not a switch.** It applies when the form is submitted, and that is exactly the line between the two controls. A switch there would claim to have already done something.
- **Accessibility:** Set `autofillHints` — `AutofillHints.email` and `AutofillHints.password`. Without them the platform cannot offer the saved credential, and a password manager is assistive technology for anybody who cannot type a 30-character secret twice.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| State | Shown by | Why not something else |
| --- | --- | --- |
| A field the user left empty | `AstryxFieldStatus.error` on that field | It is announced assertively and it names the field. A red border says only "somewhere here". |
| Credentials the server rejected | AstryxBanner (references/surfaces.md) above the form | It belongs to the form as a whole, not to either field — and a toast (references/overlays.md) would be gone before the second attempt. |
| The request in flight | `loading: true` on the submit button | The button keeps its width, stops accepting presses and is announced as busy. A separate spinner leaves the button live. |

---

## Login card

`example/lib/examples/template_login_examples.dart`

Sign-in inside a bordered card, using all three card slots.

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

**Rules**

- **Note:** One elevation step, not three. `AstryxElevation.low` lifts the card off the body; anything higher belongs to things that float *above* the page — popovers (references/overlays.md), dialogs (references/overlays.md) — and a login card is the page.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## SSO login

`example/lib/examples/template_login_examples.dart`

Sign-in through identity providers, with an email link as the fallback.

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

**Rules**

- **Note:** The trailing `externalLink` icon is the one promise an SSO button has to keep: this leaves the page. The icon registry ships no provider logos — swap in your own registry, or an `AstryxIconButton.custom`, if you want the Okta mark.
- **Accessibility:** The email fallback’s submit button is disabled until the address is plausible, and the field carries a `description` saying what pressing it does. A disabled button with no stated reason is a dead end for everyone and an unexplained one for a screen-reader user.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Split login

`example/lib/examples/template_login_examples.dart`

Sign-in beside a full-height panel.

```dart
class LoginSplitTemplate extends StatelessWidget {
  const LoginSplitTemplate({super.key});

  /// Below this the split cannot hold: 340 for the form leaves the panel less
  /// room than one line of its heading needs.
  static const double _splitMinWidth = 560;

  @override
  Widget build(BuildContext context) {
    final form = AstryxCenter(
      paddingInline: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing4,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          const AstryxHeading('Sign in', level: 1),
          const AstryxTextInput(
            label: 'Email',
            required: true,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const AstryxTextInput(
            label: 'Password',
            required: true,
            obscureText: true,
          ),
          AstryxButton(
            label: 'Sign in',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );

    // Two columns of one height: the form keeps its measure and the panel takes
    // the rest, so the split holds at every width down to `_splitMinWidth`.
    // Below that there is no split — the panel goes above the form, because a
    // 120-wide column of prose is not a panel, it is a stripe.
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth < _splitMinWidth
          ? AstryxVStack(
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                const _SplitPanel(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AstryxTheme.of(
                      context,
                    ).spacing(AstryxSpacingToken.spacing6),
                  ),
                  child: form,
                ),
              ],
            )
          : SizedBox(
              height: 460,
              child: AstryxHStack(
                align: AstryxStackAlign.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Expanded(child: _SplitPanel()),
                  SizedBox(width: 340, child: form),
                ],
              ),
            ),
    );
  }
}
```

**Rules**

- **Careful:** **Upstream puts a photograph in that panel; this one is a muted surface.** `Thumbnail`, `AspectRatio` and the image components are not ported, so rather than draw a grey rectangle and call it an image, the panel carries the one sentence the picture was carrying. The layout is the same; the content is honest about what the package can do today.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Contact form

`example/lib/examples/template_form_examples.dart`

A single-column form with validation, an in-flight state and a success state that replaces it.

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

**Rules**

- **Accessibility:** Every validation message says what to do, not what went wrong: "Tell us who you are", not "Invalid". The status is announced assertively, so it is the entire instruction a screen-reader user receives.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Field | Control | Because |
| --- | --- | --- |
| Name, email | AstryxTextInput (references/forms.md) | Free text, one line, with `autofillHints` so the platform can fill them. |
| Topic | AstryxSelector (references/forms.md) | One value out of four, and it needs `description`s to be unambiguous. A menu (references/overlays.md) performs actions and reports nothing. |
| Message | AstryxTextArea (references/forms.md) | Multi-line, grows with the content, and takes a `maxLength` the user can see. |

---

## Two-column form

`example/lib/examples/template_form_examples.dart`

A long form split into labelled sections, with the section heading beside its fields.

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

**Rules**

- **Accessibility:** The badge carries an icon as well as a colour — `warning` for unsaved, `success` for saved. Colour is never the only signal; in greyscale, or to a colour-blind reader, the icon and the words are what remain.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Payment form

`example/lib/examples/template_form_examples.dart`

Card details, a billing address, and the summary beside them.

```dart
class PaymentFormTemplate extends StatefulWidget {
  const PaymentFormTemplate({super.key});

  @override
  State<PaymentFormTemplate> createState() => _PaymentFormTemplateState();
}

class _PaymentFormTemplateState extends State<PaymentFormTemplate> {
  final TextEditingController _card = TextEditingController();
  final TextEditingController _expiry = TextEditingController();
  final TextEditingController _cvc = TextEditingController();
  final TextEditingController _postcode = TextEditingController();

  String? _country = 'gb';
  bool _sameAddress = true;
  bool _paying = false;

  @override
  void dispose() {
    _card.dispose();
    _expiry.dispose();
    _cvc.dispose();
    _postcode.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _paying = false);
    // The receipt is the real confirmation; the toast only says the request
    // landed. Anything the user must keep belongs in the email, not here.
    AstryxToastScope.of(
      context,
    ).show(const AstryxToast(message: 'Payment taken — receipt emailed'));
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
            AstryxHeading('Checkout', level: 1),
            AstryxText(
              'Annual plan, 24 seats. Cancel any time.',
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // Card details on the reading side, what is being bought on the other.
        // Narrow, the summary goes first: agreeing to a figure you have not
        // seen yet is not consent.
        LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth < formTwoColumnMinWidth
              ? AstryxVStack(
                  gap: AstryxSpacingToken.spacing6,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[_summary(), _fields()],
                )
              : AstryxHStack(
                  gap: AstryxSpacingToken.spacing6,
                  align: AstryxStackAlign.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(child: _fields()),
                    SizedBox(width: 260, child: _summary()),
                  ],
                ),
        ),
        const AstryxDivider(),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(
              child: AstryxText(
                'Charged today, then every 12 months.',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
            AstryxButton(
              label: r'Pay $4,608.00',
              variant: AstryxButtonVariant.primary,
              loading: _paying,
              onPressed: _pay,
            ),
          ],
        ),
      ],
    );
  }

  /// The card and billing fields.
  Widget _fields() {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTextInput(
          label: 'Card number',
          controller: _card,
          required: true,
          enabled: !_paying,
          placeholder: '4242 4242 4242 4242',
          keyboardType: TextInputType.number,
          autofillHints: const <String>[AutofillHints.creditCardNumber],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: AstryxTextInput(
                label: 'Expiry',
                controller: _expiry,
                required: true,
                enabled: !_paying,
                placeholder: 'MM/YY',
                keyboardType: TextInputType.datetime,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
            ),
            Expanded(
              child: AstryxTextInput(
                label: 'CVC',
                controller: _cvc,
                required: true,
                enabled: !_paying,
                placeholder: '123',
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ],
        ),
        const AstryxDivider(label: 'Billing address'),
        // A checkbox, not a switch: it changes what gets submitted, not what
        // happens now.
        AstryxCheckbox(
          label: 'Same as the workspace address',
          description: 'Frankfurt, Germany',
          value: _sameAddress,
          onChanged: _paying
              ? null
              : (value) => setState(() => _sameAddress = value),
        ),
        if (!_sameAddress)
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: AstryxSelector<String>(
                  label: 'Country',
                  value: _country,
                  enabled: !_paying,
                  showSearch: true,
                  searchPlaceholder: 'Search countries',
                  onChanged: (value) => setState(() => _country = value),
                  options: const <AstryxSelectorEntry<String>>[
                    AstryxSelectorOption(value: 'gb', label: 'United Kingdom'),
                    AstryxSelectorOption(value: 'de', label: 'Germany'),
                    AstryxSelectorOption(value: 'us', label: 'United States'),
                    AstryxSelectorOption(value: 'jp', label: 'Japan'),
                  ],
                ),
              ),
              Expanded(
                child: AstryxTextInput(
                  label: 'Postcode',
                  controller: _postcode,
                  required: true,
                  enabled: !_paying,
                  autofillHints: const <String>[AutofillHints.postalCode],
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// What is being bought, beside the fields that pay for it.
  Widget _summary() {
    return const AstryxCard(
      variant: AstryxCardVariant.muted,
      header: AstryxHeading('Order summary', level: 3),
      footer: _SummaryRow(
        label: 'Total due today',
        value: r'$4,608.00',
        emphasised: true,
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          _SummaryRow(label: 'Atlas Pro, annual', value: r'$4,800.00'),
          _SummaryRow(label: '24 seats', value: 'included'),
          _SummaryRow(label: 'Volume discount', value: r'-$192.00'),
        ],
      ),
    );
  }
}
```

**Rules**

- **Careful:** The country field uses AstryxSelector (references/forms.md) with `showSearch: true`. A list of two hundred countries without a search box is a scroll, and upstream’s `ComplexSelector` — which would group them by continent — is not ported.
- **Accessibility:** Card, expiry, CVC and postcode all carry `autofillHints`, so the platform’s own card store can fill them. Typing a 16-digit number by hand is the part of a checkout that goes wrong.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Settings

`example/lib/examples/template_settings_examples.dart`

Grouped preference rows with inline controls, each applying the moment it changes.

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

**Rules**

- **Careful:** The red card is `AstryxCardVariant.palette(AstryxPalette.red)`, and the palettes are **categorical, not semantic**. It is used here for the boundary of the section, with the destructive `variant` on the button and the dialog carrying the actual severity.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Settings dialog

`example/lib/examples/template_settings_examples.dart`

Settings inside a modal, with its own navigation.

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

**Rules**

- **Note:** A dialog is a widget in the tree driven by an `AstryxDialogController`, not a `showDialog` call. It renders nothing until the controller opens it, so it sits next to the button that opens it and the state stays yours — including which tab was last open.
- **Accessibility:** `title` is the dialog’s accessible name, focus is trapped inside while it is open, and it returns to the trigger on close. The tab strip has its own `label`, because "Profile Notifications Advanced" with no context is not a name.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Settings with sidebar

`example/lib/examples/template_settings_examples.dart`

Settings sections reached from a sidebar.

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

**Rules**

- **Careful:** **The rail sits beside the layout, not in its `panel`.** AstryxLayout (references/app_shell.md) wraps a panel in a scroll view, so a panel is handed an *unbounded* height — and AstryxSideNav (references/navigation.md) pins its own footer with an `Expanded`, which cannot be laid out against one. Beside the layout, in a `Row` with `crossAxisAlignment: stretch`, the rail gets the height of the frame, which is what it wants. A panel is the right slot for content that sizes itself — the filter list on library (references/templates.md), the outline on documentation (references/templates.md).
- **Careful:** The row is still not the confirmation. It leads to a screen that states what is lost — eleven members immediately, everything after thirty days — and an AstryxAlertDialog (references/overlays.md) states it again before anything happens. "Are you sure?" is a question nobody has ever answered no to on the strength of the question alone.
- **Accessibility:** The rail carries `label: 'Settings sections'`, and the section heading in the layout header is `level: 1`. Without both, a screen-reader user moving between sections is told the name of the application and nothing about where they have just arrived.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Sections | Shape | Reached by |
| --- | --- | --- |
| Two or three | Settings (references/templates.md) | Scrolling. Every section is on screen, or one flick away. |
| Three or four, in a modal | Settings dialog (references/templates.md) | An AstryxTabList (references/data.md) inside the dialog. |
| Five or more | This one | An AstryxSideNav (references/navigation.md) beside the content. Past about four, a long page stops being scannable and the reader is scrolling to find out what exists. |

---

## Centred hero

`example/lib/examples/template_screen_examples.dart`

A headline, a supporting line, and one action.

```dart
class CenteredHeroTemplate extends StatelessWidget {
  const CenteredHeroTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    // One measure, one heading, one action. `maxWidth` is what keeps the
    // supporting line readable — a hero that runs the full width of a desktop
    // window is a paragraph nobody finishes.
    return AstryxCenter(
      maxWidth: 620,
      minHeight: 360,
      padding: AstryxSpacingToken.spacing8,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxBadge(
            'Now in every region',
            variant: AstryxBadgeVariant.info,
            icon: AstryxIcon(AstryxIconName.info),
          ),
          const AstryxHeading(
            'Every deploy, every incident, one timeline',
            level: 1,
            type: AstryxHeadingType.display2,
            justify: AstryxTextJustify.center,
          ),
          const AstryxText(
            'Atlas watches the services you already run and tells you which '
            'change caused the graph to bend.',
            type: AstryxTextType.large,
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          // One `primary` in the view. The second action is secondary, not a
          // second primary: two of them side by side is a question.
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              AstryxButton(
                label: 'Start free',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.lg,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Read the docs',
                size: AstryxButtonSize.lg,
                trailing: const AstryxIcon(
                  AstryxIconName.externalLink,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const AstryxText(
            'No card. Two minutes to the first graph.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Gallery hero

`example/lib/examples/template_media_examples.dart`

A hero whose supporting content is a media grid.

```dart
class GalleryHeroTemplate extends StatefulWidget {
  const GalleryHeroTemplate({super.key});

  @override
  State<GalleryHeroTemplate> createState() => _GalleryHeroTemplateState();
}

class _GalleryHeroTemplateState extends State<GalleryHeroTemplate> {
  static const List<Shot> _shots = <Shot>[
    (
      name: 'The rack view',
      caption: 'Every machine in a region, and what it is doing right now.',
      ratio: 16 / 9,
    ),
    (
      name: 'The deploy timeline',
      caption: 'One row per service, one column per minute.',
      ratio: 16 / 9,
    ),
    (
      name: 'The incident console',
      caption: 'Severity, the people on it, and the last thing that changed.',
      ratio: 16 / 9,
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // A hero is a claim and one action. The media underneath it is *evidence*
    // for the claim, which is why it is a strip the reader can page rather
    // than a wall they have to scan.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing8,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCenter(
          maxWidth: 620,
          padding: AstryxSpacingToken.spacing0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.center,
            children: <Widget>[
              const AstryxBadge(
                'Atlas 4',
                variant: AstryxBadgeVariant.info,
                icon: AstryxIcon(AstryxIconName.info),
              ),
              const AstryxHeading(
                'See the whole fleet at once',
                level: 1,
                type: AstryxHeadingType.display2,
                justify: AstryxTextJustify.center,
              ),
              const AstryxText(
                'Every deploy, every incident and every machine on one screen '
                '— and the same screen on a phone at three in the morning.',
                type: AstryxTextType.large,
                color: AstryxTextColor.secondary,
                justify: AstryxTextJustify.center,
              ),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                wrap: true,
                runGap: AstryxSpacingToken.spacing2,
                justify: AstryxStackJustify.center,
                children: <Widget>[
                  AstryxButton(
                    label: 'Start free',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.lg,
                    onPressed: () {},
                  ),
                  AstryxButton(
                    label: 'Watch the tour',
                    size: AstryxButtonSize.lg,
                    trailing: const AstryxIcon(
                      AstryxIconName.externalLink,
                      size: AstryxIconSize.sm,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        // The strip is one tab stop with its own arrow keys and its own "2 of
        // 3" readout, so the position is never something the reader has to
        // infer from how far a scrollbar has moved.
        AstryxCarousel(
          label: 'Product screens',
          height: 260,
          viewportFraction: 0.86,
          onIndexChanged: (index) => setState(() => _index = index),
          items: <Widget>[
            for (final shot in _shots) _HeroPanel(shot: shot),
          ],
        ),
        // The caption is on the page, not over the picture. A hero's
        // supporting line is content, and content behind a scrim is content
        // somebody decided was decoration.
        AstryxCenter(
          maxWidth: 620,
          padding: AstryxSpacingToken.spacing0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxText(
                _shots[_index].name,
                type: AstryxTextType.label,
                justify: AstryxTextJustify.center,
              ),
              AstryxText(
                _shots[_index].caption,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                justify: AstryxTextJustify.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One panel of the hero strip: a picture, and its name over it.
class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.shot});

  final Shot shot;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AstryxAspectRatio(
              ratio: shot.ratio,
              background: AstryxColorToken.backgroundInverted,
              semanticsLabel: shot.name,
              child: const Center(
                child: AstryxMediaTheme(
                  scrim: AstryxMediaScrim.none,
                  padding: AstryxSpacingToken.spacing0,
                  child: AstryxIcon(
                    AstryxIconName.viewColumns,
                    size: AstryxIconSize.lg,
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 0,
              end: 0,
              bottom: 0,
              child: AstryxMediaTheme(
                child: AstryxText(
                  shot.name,
                  color: AstryxTextColor.inherit,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Note:** The heading is `type: display2` with `level: 1`. Those are two different jobs — the display types are the size, the level is the outline a screen reader navigates — and reaching for a bigger level to get a bigger size is how a page ends up with three h1s.
- **Accessibility:** Every panel carries a `semanticsLabel` on its AstryxAspectRatio (references/media.md). A hero whose pictures announce nothing is a hero that reads, to a screen reader, as a headline and two buttons — which is the centred hero (references/templates.md), not this.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Detail page

`example/lib/examples/template_screen_examples.dart`

One record: header, status, tabs, metadata and actions.

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

**Rules**

- **Careful:** **The metadata list and the timeline are compositions, not components.** Upstream ships `MetadataList` and `List`; neither is ported. The label-and-value pairs are an AstryxGrid (references/layout.md) of two-line stacks, and the timeline is an `AstryxVStack` with dividers (references/layout.md) between rows. Both are what those components would replace, and both are exactly the code you would delete when they land.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Dashboard

`example/lib/examples/template_screen_examples.dart`

Summary tiles above a table of what needs attention.

```dart
class DashboardTemplate extends StatefulWidget {
  const DashboardTemplate({super.key});

  @override
  State<DashboardTemplate> createState() => _DashboardTemplateState();
}

class _DashboardTemplateState extends State<DashboardTemplate> {
  String _range = '7d';

  @override
  Widget build(BuildContext context) {
    final open = incidents.where((row) => !row.resolved).toList();

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // Title and range picker on one line at width, stacked below it when
        // there is no room. Not `wrap: true`: a wrapped row hands its children
        // unbounded width, so the supporting line would refuse to break and
        // overflow instead of moving.
        LayoutBuilder(
          builder: (context, constraints) {
            // A range picker as an attached button group, the selected segment
            // taking the louder variant. That is the segmented control until
            // `SegmentedControl` is ported.
            final picker = AstryxButtonGroup(
              size: AstryxButtonSize.sm,
              children: <Widget>[
                for (final range in const <String>['24h', '7d', '30d'])
                  AstryxButton(
                    label: range,
                    variant: _range == range
                        ? AstryxButtonVariant.primary
                        : AstryxButtonVariant.secondary,
                    onPressed: () => setState(() => _range = range),
                  ),
              ],
            );

            return constraints.maxWidth < 520
                ? AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    children: <Widget>[const _DashboardTitle(), picker],
                  )
                : AstryxHStack(
                    gap: AstryxSpacingToken.spacing4,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Flexible(child: _DashboardTitle()),
                      picker,
                    ],
                  );
          },
        ),
        // Tiles first, and the column count falls out of the width rather than
        // out of a breakpoint table.
        const AstryxGrid(
          minWidth: 190,
          maxColumns: 4,
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            _Tile(
              label: 'Availability',
              value: '99.94%',
              detail: 'Objective 99.90%',
              progress: 0.9994,
              variant: AstryxProgressVariant.success,
            ),
            _Tile(
              label: 'p95 latency',
              value: '318 ms',
              detail: 'Objective 400 ms',
              progress: 0.79,
            ),
            _Tile(
              label: 'Error budget',
              value: '38% left',
              detail: 'Resets in 12 days',
              progress: 0.38,
              variant: AstryxProgressVariant.warning,
            ),
            _Tile(
              label: 'Open incidents',
              value: '2',
              detail: 'One at Sev-1',
              progress: null,
            ),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // `Flexible`, so the heading wraps on a narrow screen instead
                // of pushing the link past the edge.
                const Flexible(child: AstryxHeading('Open incidents')),
                AstryxButton(
                  label: 'All incidents',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  trailing: const AstryxIcon(
                    AstryxIconName.chevronRight,
                    size: AstryxIconSize.sm,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            AstryxTable<Incident>(
              label: 'Open incidents',
              rows: open,
              keyOf: (row) => row.id,
              rowLabelOf: (row) => row.title,
              emptyState: const AstryxCenter(
                minHeight: 160,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: AstryxStackAlign.center,
                  children: <Widget>[
                    AstryxIcon(
                      AstryxIconName.success,
                      size: AstryxIconSize.lg,
                      color: AstryxIconColor.success,
                    ),
                    AstryxHeading('Nothing on fire', level: 4),
                    AstryxText(
                      'Every service is inside its objective.',
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ),
              columns: <AstryxTableColumn<Incident>>[
                AstryxTableColumn<Incident>(
                  id: 'title',
                  header: 'Incident',
                  width: const AstryxTableColumnWidth.flex(1.6),
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
                AstryxTableColumn<Incident>(
                  id: 'owner',
                  header: 'On call',
                  cellBuilder: (context, row) => AstryxText(row.owner),
                ),
                AstryxTableColumn<Incident>(
                  id: 'age',
                  header: 'Age',
                  width: const AstryxTableColumnWidth.fixed(80),
                  alignment: AstryxTableAlignment.end,
                  cellBuilder: (context, row) => AstryxText(
                    formatMinutes(row.minutes),
                    tabularNumbers: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **The range picker is an `AstryxButtonGroup`, not a segmented control.** `SegmentedControl` is not ported, so the selected segment takes the louder `variant` inside an attached group. It behaves correctly and it is three buttons — it is not one tab stop with arrow-key traversal, which is what the real component will bring.
- **Note:** There is no chart here. Upstream’s dashboard templates lean on one, and this port ships no charting widget — the tiles carry the numbers instead. Reach a token with `AstryxTheme.of(context).color(…)` if you are wiring up your own chart library.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Tile | Variant | Because |
| --- | --- | --- |
| Availability | `success` | Above its objective. |
| p95 latency | `accent` | Inside its objective, neutrally. |
| Error budget | `warning` | Being consumed faster than the window refills it. |
| Open incidents | no bar | A count, not a proportion. |

---

## Portfolio dashboard

`example/lib/examples/template_chart_examples.dart`

A dashboard built around a chart and a holdings table.

```dart
/// One holding in the portfolio.
typedef Holding = ({
  String ticker,
  String name,
  String sector,
  int price,
  int value,
  double change,
});

class PortfolioDashboardTemplate extends StatefulWidget {
  const PortfolioDashboardTemplate({super.key});

  @override
  State<PortfolioDashboardTemplate> createState() =>
      _PortfolioDashboardTemplateState();
}

class _PortfolioDashboardTemplateState
    extends State<PortfolioDashboardTemplate> {
  static const List<Holding> _holdings = <Holding>[
    (
      ticker: 'ACME',
      name: 'Acme Corporation',
      sector: 'Industrials',
      price: 42150,
      value: 1264500,
      change: 2.41,
    ),
    (
      ticker: 'GLBX',
      name: 'Globex',
      sector: 'Technology',
      price: 18820,
      value: 941000,
      change: -1.08,
    ),
    (
      ticker: 'INIT',
      name: 'Initech',
      sector: 'Technology',
      price: 9640,
      value: 578400,
      change: 5.62,
    ),
    (
      ticker: 'UMBR',
      name: 'Umbrella Health',
      sector: 'Healthcare',
      price: 27310,
      value: 546200,
      change: 0.34,
    ),
    (
      ticker: 'NRTH',
      name: 'Northwind Energy',
      sector: 'Energy',
      price: 6125,
      value: 306250,
      change: -3.87,
    ),
    (
      ticker: 'CONT',
      name: 'Contoso Retail',
      sector: 'Consumer',
      price: 3480,
      value: 174000,
      change: 1.19,
    ),
  ];

  /// The series behind each range. Real data arrives from somewhere; the
  /// screen's job is the same either way.
  static const Map<String, List<double>> _series = <String, List<double>>{
    '1m': <double>[
      37.4, 37.9, 37.1, 38.2, 38.05, 38.6, 39.1, 38.8, 39.4, 39.2, 39.9, 40.1,
    ],
    '6m': <double>[
      31.2, 32.8, 32.1, 34.6, 33.9, 35.8, 36.4, 35.1, 37.2, 38.4, 39.05, 40.1,
    ],
    '1y': <double>[
      28.4, 27.1, 29.6, 31.2, 30.4, 33.1, 32.2, 34.9, 36.1, 35.4, 38.2, 40.1,
    ],
  };

  static const Map<String, String> _rangeLabels = <String, String>{
    '1m': 'the last month',
    '6m': 'the last six months',
    '1y': 'the last year',
  };

  String _range = '6m';
  AstryxTableSort? _sort = const AstryxTableSort(
    'value',
    AstryxSortDirection.descending,
  );

  int get _total =>
      _holdings.fold<int>(0, (sum, holding) => sum + holding.value);

  List<double> get _values => _series[_range]!;

  double get _rangeChange {
    final series = _values;
    return (series.last - series.first) / series.first * 100;
  }

  /// Sorted in the caller. `AstryxTable.rows` is documented as already sorted
  /// and already paginated, and a table that sorted itself could not be handed
  /// a page.
  List<Holding> get _rows {
    final rows = List<Holding>.of(_holdings);
    final sort = _sort;
    if (sort == null) return rows;

    int by(Holding a, Holding b) => switch (sort.columnId) {
      'name' => a.name.compareTo(b.name),
      'price' => a.price.compareTo(b.price),
      'change' => a.change.compareTo(b.change),
      _ => a.value.compareTo(b.value),
    };
    rows.sort(
      (a, b) =>
          sort.direction == AstryxSortDirection.ascending ? by(a, b) : by(b, a),
    );
    return rows;
  }

  /// What each sector is worth, largest first.
  List<({String sector, int value})> get _allocation {
    final totals = <String, int>{};
    for (final holding in _holdings) {
      totals[holding.sector] = (totals[holding.sector] ?? 0) + holding.value;
    }
    final rows = <({String sector, int value})>[
      for (final entry in totals.entries)
        (sector: entry.key, value: entry.value),
    ];
    return rows..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    final change = _rangeChange;
    final up = change >= 0;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Portfolio', level: 1),
                // The figure is text, at display size, and the chart is
                // underneath it. A dashboard whose headline number can only be
                // read off a curve is a dashboard nobody can quote.
                AstryxText(
                  pence(_total),
                  type: AstryxTextType.display3,
                  tabularNumbers: true,
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxBadge(
                      signed(change),
                      variant: up
                          ? AstryxBadgeVariant.success
                          : AstryxBadgeVariant.error,
                      icon: AstryxIcon(
                        up ? AstryxIconName.arrowUp : AstryxIconName.arrowDown,
                      ),
                    ),
                    AstryxText(
                      'over ${_rangeLabels[_range]}',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Range',
              value: _range,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() => _range = value),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: '1m', label: '1M'),
                AstryxSegment(value: '6m', label: '6M'),
                AstryxSegment(value: '1y', label: '1Y'),
              ],
            ),
          ],
        ),
        AstryxCard(
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxText(
                '£${_values.first.toStringAsFixed(1)}k',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                tabularNumbers: true,
              ),
              AstryxText(
                '£${_values.last.toStringAsFixed(1)}k',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                tabularNumbers: true,
              ),
            ],
          ),
          child: TrendChart(
            values: _values,
            height: 180,
            color: up ? AstryxColorToken.success : AstryxColorToken.error,
            label: 'Portfolio value over ${_rangeLabels[_range]}',
            // The chart's whole content, in a sentence. Everything a sighted
            // reader takes from the shape is stated here instead.
            semanticsValue:
                'From £${_values.first.toStringAsFixed(1)}k to '
                '£${_values.last.toStringAsFixed(1)}k, '
                '${signed(change)}',
          ),
        ),
        AstryxSection(
          title: 'Allocation',
          description: 'What each sector is worth, as a share of the whole.',
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              // Bars, not a pie. A proportion each reader can compare against
              // its neighbour beats a wedge nobody can measure — and
              // `AstryxProgressBar` is already a proportion with an announced
              // label, so there is nothing to draw.
              for (final row in _allocation)
                AstryxProgressBar(
                  label: row.sector,
                  value: row.value / _total,
                  showValueLabel: true,
                  formatValue: (value) =>
                      '${(value * 100).round()}% · ${pence(row.value)}',
                ),
            ],
          ),
        ),
        AstryxSection(
          title: 'Holdings',
          description: 'Six positions. Press a column header to sort.',
          child: AstryxTable<Holding>(
            label: 'Holdings',
            keyOf: (row) => row.ticker,
            rowLabelOf: (row) => row.name,
            sort: _sort,
            onSortChanged: (sort) => setState(() => _sort = sort),
            minWidth: 640,
            columns: <AstryxTableColumn<Holding>>[
              AstryxTableColumn<Holding>(
                id: 'name',
                header: 'Holding',
                compare: (a, b) => a.name.compareTo(b.name),
                cellBuilder: (context, row) => AstryxVStack(
                  gap: AstryxSpacingToken.spacing0_5,
                  children: <Widget>[
                    AstryxText(row.ticker, type: AstryxTextType.code),
                    AstryxText(
                      row.name,
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              AstryxTableColumn<Holding>(
                id: 'sector',
                header: 'Sector',
                width: const AstryxTableColumnWidth.fixed(130),
                cellBuilder: (context, row) => AstryxBadge(row.sector),
              ),
              AstryxTableColumn<Holding>(
                id: 'price',
                header: 'Price',
                width: const AstryxTableColumnWidth.fixed(120),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.price.compareTo(b.price),
                cellBuilder: (context, row) =>
                    AstryxText(pence(row.price), tabularNumbers: true),
              ),
              AstryxTableColumn<Holding>(
                id: 'change',
                header: 'Change',
                width: const AstryxTableColumnWidth.fixed(136),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.change.compareTo(b.change),
                // A sign and a glyph, not only a colour. Red and green are the
                // two hues most readers cannot tell apart, and this is the
                // column where that matters most.
                cellBuilder: (context, row) => AstryxHStack(
                  gap: AstryxSpacingToken.spacing1,
                  justify: AstryxStackJustify.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AstryxIcon(
                      row.change >= 0
                          ? AstryxIconName.arrowUp
                          : AstryxIconName.arrowDown,
                      size: AstryxIconSize.sm,
                      color: row.change >= 0
                          ? AstryxIconColor.success
                          : AstryxIconColor.error,
                    ),
                    AstryxText(signed(row.change), tabularNumbers: true),
                  ],
                ),
              ),
              AstryxTableColumn<Holding>(
                id: 'value',
                header: 'Value',
                width: const AstryxTableColumnWidth.fixed(140),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.value.compareTo(b.value),
                cellBuilder: (context, row) =>
                    AstryxText(pence(row.value), tabularNumbers: true),
              ),
            ],
            rows: _rows,
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **`astryx_ui` ships no charting widget, and does not intend to.** A chart is a domain of its own — scales, axes, ticks, legends, tooltips, and an accessibility story for all of them — and a design system that shipped half of one would be shipping something nobody could finish. So this screen draws its own, in about forty lines of `CustomPainter`, and the point of that painter is not that it is good. It is that the seam is visible: swap it for your charting package and nothing around it changes.
- **Accessibility:** `TrendChart` takes a required `label` **and** a required `semanticsValue`, and the value is the chart in a sentence: "From £31.2k to £40.1k, +28.53%". Everything a sighted reader takes from the shape is stated there instead. The painter itself sits inside an `ExcludeSemantics`, because a canvas has nothing to announce.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Table

`example/lib/examples/template_screen_examples.dart`

A data table as a screen: a toolbar, filtering, sorting, selection and row actions.

```dart
class TableTemplate extends StatefulWidget {
  const TableTemplate({super.key});

  @override
  State<TableTemplate> createState() => _TableTemplateState();
}

class _TableTemplateState extends State<TableTemplate> {
  final TextEditingController _query = TextEditingController();

  AstryxTableSort? _sort = const AstryxTableSort(
    'severity',
    AstryxSortDirection.ascending,
  );
  Set<Object> _selected = <Object>{};
  String _status = 'all';

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Filtering happens here, not in the table: `rows` is documented as already
  /// filtered, and a table that filtered its own rows could not tell the
  /// difference between "no matches" and "no data".
  List<Incident> get _rows {
    final query = _query.text.trim().toLowerCase();
    return incidents.where((row) {
      final matchesStatus = switch (_status) {
        'open' => !row.resolved,
        'resolved' => row.resolved,
        _ => true,
      };
      final matchesQuery =
          query.isEmpty ||
          row.title.toLowerCase().contains(query) ||
          row.service.toLowerCase().contains(query) ||
          row.owner.toLowerCase().contains(query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Incidents', level: 1)),
            AstryxButton(
              label: 'Declare incident',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        // The toolbar: search, a filter in a popover, and a column menu. All
        // three are always visible — none of them is behind hover.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: 260,
              child: AstryxTextInput(
                label: 'Search incidents',
                labelHidden: true,
                controller: _query,
                placeholder: 'Search title, service or owner',
                leading: const AstryxIcon(AstryxIconName.search),
                showClear: true,
                size: AstryxInputSize.sm,
                onChanged: (_) => setState(() {}),
              ),
            ),
            AstryxPopover(
              label: 'Filter incidents',
              width: 240,
              content: AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxRadioList<String>(
                    label: 'Status',
                    value: _status,
                    size: AstryxToggleSize.sm,
                    onChanged: (value) => setState(() => _status = value),
                    options: const <AstryxRadioOption<String>>[
                      AstryxRadioOption(value: 'all', label: 'Everything'),
                      AstryxRadioOption(value: 'open', label: 'Open only'),
                      AstryxRadioOption(
                        value: 'resolved',
                        label: 'Resolved only',
                      ),
                    ],
                  ),
                ],
              ),
              triggerBuilder: (context, controller) => AstryxButton(
                label: _status == 'all' ? 'Filter' : 'Filter: $_status',
                size: AstryxButtonSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.sm,
                ),
                onPressed: controller.toggle,
              ),
            ),
            AstryxDropdownMenu(
              label: 'Table options',
              width: 200,
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('Rows'),
                AstryxMenuItem(
                  label: 'Export as CSV',
                  icon: const AstryxIcon(AstryxIconName.copy),
                  onSelected: () {},
                ),
                AstryxMenuItem(
                  label: 'Subscribe to this view',
                  onSelected: () {},
                ),
              ],
              triggerBuilder: (context, controller) => AstryxIconButton(
                icon: AstryxIconName.viewColumns,
                label: 'Table options',
                tooltip: 'Table options',
                size: AstryxButtonSize.sm,
                onPressed: controller.toggle,
              ),
            ),
          ],
        ),
        // The selection bar appears once something is selected and says how
        // many, because "Delete" with no count is a question the user cannot
        // answer.
        if (_selected.isNotEmpty)
          AstryxBanner(
            title: '${_selected.length} selected',
            announce: false,
            actions: <Widget>[
              AstryxButton(
                label: 'Resolve',
                size: AstryxButtonSize.sm,
                onPressed: () => setState(_selected.clear),
              ),
              AstryxButton(
                label: 'Clear',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () => setState(_selected.clear),
              ),
            ],
          ),
        AstryxTable<Incident>(
          label: 'Incidents',
          rows: rows,
          keyOf: (row) => row.id,
          rowLabelOf: (row) => row.title,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          striped: true,
          maxHeight: 320,
          emptyState: AstryxCenter(
            minHeight: 180,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxIcon(
                  AstryxIconName.search,
                  size: AstryxIconSize.lg,
                  color: AstryxIconColor.secondary,
                ),
                const AstryxHeading('No incidents match', level: 4),
                const AstryxText(
                  'Every filter is still applied.',
                  color: AstryxTextColor.secondary,
                ),
                AstryxButton(
                  label: 'Clear filters',
                  onPressed: () => setState(() {
                    _query.clear();
                    _status = 'all';
                  }),
                ),
              ],
            ),
          ),
          rowActionsBuilder: (context, row) => AstryxDropdownMenu(
            width: 200,
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Open ${row.id}', onSelected: () {}),
              AstryxMenuItem(label: 'Reassign', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Delete',
                destructive: true,
                onSelected: () {},
              ),
            ],
            triggerBuilder: (context, controller) => AstryxIconButton(
              icon: AstryxIconName.moreHorizontal,
              label: 'Actions for ${row.title}',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: controller.toggle,
            ),
          ),
          columns: <AstryxTableColumn<Incident>>[
            AstryxTableColumn<Incident>(
              id: 'title',
              header: 'Incident',
              width: const AstryxTableColumnWidth.flex(1.8),
              compare: (a, b) => a.title.compareTo(b.title),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.title, maxLines: 1),
                  AstryxText(
                    row.service,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'severity',
              header: 'Severity',
              width: const AstryxTableColumnWidth.intrinsic(min: 100),
              // Sorting on the number, showing the label: "Sev-10" would sort
              // between "Sev-1" and "Sev-2" as a string.
              compare: (a, b) => a.severity.compareTo(b.severity),
              cellBuilder: (context, row) => AstryxBadge(
                row.severityLabel,
                variant: severityVariant(row.severity),
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'status',
              header: 'Status',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              cellBuilder: (context, row) => AstryxBadge(
                row.resolved ? 'Resolved' : 'Open',
                variant: row.resolved
                    ? AstryxBadgeVariant.success
                    : AstryxBadgeVariant.warning,
                icon: AstryxIcon(
                  row.resolved
                      ? AstryxIconName.success
                      : AstryxIconName.warning,
                ),
              ),
            ),
            AstryxTableColumn<Incident>(
              id: 'age',
              header: 'Age',
              width: const AstryxTableColumnWidth.fixed(80),
              alignment: AstryxTableAlignment.end,
              headerTooltip: 'Time since the alert fired',
              compare: (a, b) => a.minutes.compareTo(b.minutes),
              cellBuilder: (context, row) =>
                  AstryxText(formatMinutes(row.minutes), tabularNumbers: true),
            ),
          ],
        ),
        AstryxText(
          '${rows.length} of ${incidents.length} incidents'
          '${_sort == null ? '' : ' · sorted by ${_sort!.columnId}'}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Row actions are **always visible**. Hover does not exist on touch, and the density system actively suppresses hover styling there — an action that only appears under a pointer is an action half your users do not have.
- **Careful:** **Do not put `truncateTooltip: true` in a table cell.** Deciding whether text is cut off needs the cell’s final width, and a table row is measured before it is laid out — the layout asserts in touch density. `maxLines: 1` on its own is what these cells use; the ellipsis is the signal, and a screen reader gets the whole string either way.
- **Careful:** **No pagination here, and no virtualisation anywhere.** `AstryxTable` does not virtualise rows: a `maxHeight` scrolls the body, and a few hundred rows is fine. Past that, page in your own data layer — the table page (references/templates.md) template is that screen, with AstryxPagination (references/navigation.md) in the footer.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Grouped table

`example/lib/examples/template_grouped_table_examples.dart`

A table whose rows are grouped under collapsible headers.

```dart
/// One line of spend.
typedef Expense = ({
  String id,
  String vendor,
  String team,
  String status,
  int amount,
  String submitted,
});

class GroupedTableTemplate extends StatefulWidget {
  const GroupedTableTemplate({super.key});

  @override
  State<GroupedTableTemplate> createState() => _GroupedTableTemplateState();
}

class _GroupedTableTemplateState extends State<GroupedTableTemplate> {
  static const List<Expense> _all = <Expense>[
    (
      id: 'EXP-2201',
      vendor: 'Cloud hosting',
      team: 'Platform',
      status: 'Approved',
      amount: 482000,
      submitted: '2 Aug',
    ),
    (
      id: 'EXP-2198',
      vendor: 'Log storage',
      team: 'Platform',
      status: 'Pending',
      amount: 118400,
      submitted: '3 Aug',
    ),
    (
      id: 'EXP-2194',
      vendor: 'On-call paging',
      team: 'Platform',
      status: 'Approved',
      amount: 64200,
      submitted: '5 Aug',
    ),
    (
      id: 'EXP-2190',
      vendor: 'Conference tickets',
      team: 'Design',
      status: 'Rejected',
      amount: 240000,
      submitted: '1 Aug',
    ),
    (
      id: 'EXP-2187',
      vendor: 'Prototyping tool',
      team: 'Design',
      status: 'Approved',
      amount: 39600,
      submitted: '6 Aug',
    ),
    (
      id: 'EXP-2183',
      vendor: 'Usability panel',
      team: 'Design',
      status: 'Pending',
      amount: 156000,
      submitted: '7 Aug',
    ),
    (
      id: 'EXP-2179',
      vendor: 'CRM seats',
      team: 'Sales',
      status: 'Approved',
      amount: 372000,
      submitted: '2 Aug',
    ),
    (
      id: 'EXP-2176',
      vendor: 'Travel, Berlin',
      team: 'Sales',
      status: 'Pending',
      amount: 87300,
      submitted: '8 Aug',
    ),
  ];

  /// The sort applies to every group, not to one of them.
  AstryxTableSort? _sort = const AstryxTableSort(
    'amount',
    AstryxSortDirection.descending,
  );

  /// One selection across the whole screen, however many tables draw it.
  Set<Object> _selected = <Object>{};

  /// Which field the rows are bucketed by. Grouping is a decision the caller
  /// makes about the data, not something a table can be asked to work out.
  String _groupBy = 'team';

  String _keyOf(Expense row) => _groupBy == 'team' ? row.team : row.status;

  /// The groups, in a stable order, each with its rows already sorted.
  List<({String title, List<Expense> rows, int subtotal})> get _groups {
    final buckets = <String, List<Expense>>{};
    for (final row in _all) {
      buckets.putIfAbsent(_keyOf(row), () => <Expense>[]).add(row);
    }

    final groups = <({String title, List<Expense> rows, int subtotal})>[];
    for (final entry in buckets.entries) {
      final rows = List<Expense>.of(entry.value);
      final sort = _sort;
      if (sort != null) {
        int by(Expense a, Expense b) => switch (sort.columnId) {
          'vendor' => a.vendor.compareTo(b.vendor),
          'status' => a.status.compareTo(b.status),
          _ => a.amount.compareTo(b.amount),
        };
        rows.sort(
          (a, b) => sort.direction == AstryxSortDirection.ascending
              ? by(a, b)
              : by(b, a),
        );
      }
      groups.add((
        title: entry.key,
        rows: rows,
        subtotal: rows.fold<int>(0, (sum, row) => sum + row.amount),
      ));
    }

    return groups..sort((a, b) => b.subtotal.compareTo(a.subtotal));
  }

  int get _total => _all.fold<int>(0, (sum, row) => sum + row.amount);

  /// The columns, declared once and reused by every group.
  ///
  /// This is what keeps the groups lined up. Each table works out its own
  /// widths from its own rows, so a column left to size itself would be one
  /// width under Platform and another under Design — and a grouped table whose
  /// columns do not line up is a set of unrelated tables in a stack.
  List<AstryxTableColumn<Expense>> get _columns => <AstryxTableColumn<Expense>>[
    AstryxTableColumn<Expense>(
      id: 'vendor',
      header: 'Vendor',
      compare: (a, b) => a.vendor.compareTo(b.vendor),
      cellBuilder: (context, row) => AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(row.vendor, maxLines: 1),
          AstryxText(
            row.id,
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    ),
    AstryxTableColumn<Expense>(
      id: 'status',
      header: 'Status',
      width: const AstryxTableColumnWidth.fixed(140),
      compare: (a, b) => a.status.compareTo(b.status),
      cellBuilder: (context, row) => switch (row.status) {
        'Approved' => const AstryxBadge(
          'Approved',
          variant: AstryxBadgeVariant.success,
          icon: AstryxIcon(AstryxIconName.success),
        ),
        'Rejected' => const AstryxBadge(
          'Rejected',
          variant: AstryxBadgeVariant.error,
          icon: AstryxIcon(AstryxIconName.error),
        ),
        _ => const AstryxBadge(
          'Pending',
          variant: AstryxBadgeVariant.warning,
          icon: AstryxIcon(AstryxIconName.clock),
        ),
      },
    ),
    AstryxTableColumn<Expense>(
      id: 'submitted',
      header: 'Submitted',
      width: const AstryxTableColumnWidth.fixed(110),
      cellBuilder: (context, row) => AstryxText(
        row.submitted,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
        maxLines: 1,
      ),
    ),
    AstryxTableColumn<Expense>(
      id: 'amount',
      header: 'Amount',
      width: const AstryxTableColumnWidth.fixed(120),
      alignment: AstryxTableAlignment.end,
      compare: (a, b) => a.amount.compareTo(b.amount),
      cellBuilder: (context, row) =>
          AstryxText(_money(row.amount), tabularNumbers: true),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final groups = _groups;

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Expenses, August', level: 1),
                AstryxText(
                  '${_all.length} lines · ${_money(_total)}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Group by',
              value: _groupBy,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() => _groupBy = value),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: 'team', label: 'Team'),
                AstryxSegment(value: 'status', label: 'Status'),
              ],
            ),
          ],
        ),
        if (_selected.isNotEmpty)
          AstryxBanner(
            title: '${_selected.length} selected',
            announce: false,
            actions: <Widget>[
              AstryxButton(
                label: 'Approve',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                onPressed: () => setState(() => _selected = <Object>{}),
              ),
              AstryxButton(
                label: 'Clear',
                size: AstryxButtonSize.sm,
                onPressed: () => setState(() => _selected = <Object>{}),
              ),
            ],
          ),
        // One collapsible per group, and one table inside each. The group is a
        // *disclosure* rather than a row, which is why it can hold a subtotal
        // and a count without either of them pretending to be data.
        AstryxCollapsibleGroup(
          children: <AstryxCollapsible>[
            for (final group in groups)
              AstryxCollapsible(
                title: group.title,
                initiallyExpanded: true,
                description:
                    '${group.rows.length} lines · ${_money(group.subtotal)}',
                trailing: AstryxBadge(
                  '${(group.subtotal / _total * 100).round()}%',
                  semanticsLabel:
                      '${(group.subtotal / _total * 100).round()} per cent of '
                      'the total',
                ),
                child: AstryxTable<Expense>(
                  // Each table is named for its group. Four tables all called
                  // "Expenses" is four identical announcements, and a reader
                  // who tabs into the third one has no idea which it is.
                  label: '${group.title} expenses',
                  keyOf: (row) => row.id,
                  rowLabelOf: (row) => '${row.vendor}, ${_money(row.amount)}',
                  columns: _columns,
                  rows: group.rows,
                  density: AstryxTableDensity.compact,
                  // Shared, so a sort press in one group reorders all of them
                  // — which is the behaviour a single grouped table would have.
                  sort: _sort,
                  onSortChanged: (sort) => setState(() => _sort = sort),
                  selectionMode: AstryxTableSelectionMode.multiple,
                  selected: _selected,
                  onSelectionChanged: (value) => setState(() {
                    // The set is the whole screen's, so a group's "select all"
                    // has to add its own keys without dropping anyone else's.
                    final keys = group.rows.map((row) => row.id).toSet();
                    _selected = <Object>{
                      ..._selected.where((key) => !keys.contains(key)),
                      ...value.where(keys.contains),
                    };
                  }),
                ),
              ),
          ],
        ),
        AstryxCard(
          variant: AstryxCardVariant.muted,
          padding: AstryxSpacingToken.spacing3,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const AstryxText('Total', type: AstryxTextType.label),
              AstryxText(
                _money(_total),
                type: AstryxTextType.label,
                tabularNumbers: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pence to pounds, grouped in threes.
String _money(int value) {
  final units = (value / 100).floor().toString();
  final grouped = StringBuffer();
  for (var i = 0; i < units.length; i++) {
    if (i > 0 && (units.length - i) % 3 == 0) grouped.write(',');
    grouped.write(units[i]);
  }
  return '£$grouped.${(value % 100).toString().padLeft(2, '0')}';
}
```

**Rules**

- **Careful:** **Declare the columns once and give them widths.** Each table works out its own layout from its own rows, so a column left to size itself is one width under Platform and another under Design — and a grouped table whose columns do not line up is a stack of unrelated tables. Every column here except the first takes an `AstryxTableColumnWidth.fixed`, and all four groups share one `List<AstryxTableColumn>`.
- **Accessibility:** Each table is named for its group — "Platform expenses", not "Expenses". Four tables sharing one name is four identical announcements, and a reader who tabs into the third has no way to tell which they are in.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Table page

`example/lib/examples/template_table_page_examples.dart`

A table as a whole screen: filters in a pinned header, pagination in a pinned footer.

```dart
/// One row of the table.
class Run {
  const Run({
    required this.id,
    required this.pipeline,
    required this.branch,
    required this.owner,
    required this.seconds,
    required this.state,
  });

  final String id;
  final String pipeline;
  final String branch;
  final String owner;
  final int seconds;

  /// `passed`, `failed` or `running`.
  final String state;
}

/// Forty-two rows, which is the whole point: three pages of fourteen.
///
/// Generated rather than typed out, and deterministic — an example that
/// shuffles itself is an example whose screenshot cannot be trusted.
final List<Run> runs = <Run>[
  for (var i = 0; i < 42; i++)
    Run(
      id: 'r-${4200 - i}',
      pipeline: const <String>[
        'payments-api',
        'events',
        'edge',
        'reports',
      ][i % 4],
      branch: i.isEven ? 'main' : 'release/4.2',
      owner: const <String>[
        'Ada Lovelace',
        'Alan Turing',
        'Grace Hopper',
        'Katherine Johnson',
      ][i % 4],
      seconds: 40 + (i * 37) % 900,
      state: switch (i % 7) {
        0 => 'failed',
        1 => 'running',
        _ => 'passed',
      },
    ),
];

class TablePageTemplate extends StatefulWidget {
  const TablePageTemplate({super.key});

  @override
  State<TablePageTemplate> createState() => _TablePageTemplateState();
}

class _TablePageTemplateState extends State<TablePageTemplate> {
  static const List<int> _pageSizes = <int>[7, 14, 28];

  final TextEditingController _query = TextEditingController();

  AstryxTableSort? _sort;
  String _state = 'all';
  int _pageSize = 14;
  int _page = 1;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Every row that survives the filters, in whatever order sorting asked for.
  ///
  /// Filtering *and* sorting happen here, not in the table. That is not a
  /// preference: a page is a window onto the sorted set, so the sort has to be
  /// applied before the window is cut — a table sorting the fourteen rows it
  /// was handed would sort one page at a time.
  List<Run> get _matches {
    final query = _query.text.trim().toLowerCase();
    final rows =
        runs.where((row) {
          final matchesState = _state == 'all' || row.state == _state;
          final matchesQuery =
              query.isEmpty ||
              row.id.contains(query) ||
              row.pipeline.contains(query) ||
              row.branch.contains(query) ||
              row.owner.toLowerCase().contains(query);
          return matchesState && matchesQuery;
        }).toList();

    final sort = _sort;
    if (sort != null) {
      final compare = switch (sort.columnId) {
        'run' => (Run a, Run b) => a.id.compareTo(b.id),
        'duration' => (Run a, Run b) => a.seconds.compareTo(b.seconds),
        'owner' => (Run a, Run b) => a.owner.compareTo(b.owner),
        _ => null,
      };
      if (compare != null) {
        rows.sort(
          sort.direction == AstryxSortDirection.ascending
              ? compare
              : (a, b) => compare(b, a),
        );
      }
    }

    return rows;
  }

  int get _pageCount => (_matches.length / _pageSize).ceil().clamp(1, 999);

  /// The rows this page shows.
  List<Run> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Run>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// Any change to the filters puts the reader back on page one.
  ///
  /// Leaving them on page three of a set that now has two is how a filter
  /// produces an empty screen that looks like a bug.
  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final first = matches.isEmpty ? 0 : (_page - 1) * _pageSize + 1;
    final last = first + rows.length - (rows.isEmpty ? 0 : 1);

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        // The table scrolls its own body under a pinned header row, so the page
        // must not scroll as well — two scroll views inside one another is one
        // too many.
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Flexible(child: AstryxHeading('Pipeline runs', level: 1)),
                AstryxButton(
                  label: 'Run pipeline',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 240,
                  child: AstryxTextInput(
                    label: 'Search runs',
                    labelHidden: true,
                    controller: _query,
                    placeholder: 'Run, pipeline, branch or owner',
                    leading: const AstryxIcon(AstryxIconName.search),
                    showClear: true,
                    size: AstryxInputSize.sm,
                    onChanged: (_) => _refilter(() {}),
                  ),
                ),
                // A segmented control rather than a menu: three states, all
                // worth seeing at once, and the applied one is visible without
                // opening anything.
                AstryxSegmentedControl<String>(
                  label: 'State',
                  value: _state,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _state = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'all', label: 'All'),
                    AstryxSegment(value: 'passed', label: 'Passed'),
                    AstryxSegment(value: 'failed', label: 'Failed'),
                  ],
                ),
                // No `Spacer` in a wrapping row: `wrap: true` lays the children
                // out as a `Wrap`, and a `Spacer` is a `Flex` child.
                AstryxText(
                  '${matches.length} of ${runs.length} runs',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing4,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // The range, not just the page number: "1–14 of 38" is the sentence
            // that tells a reader how much they have not seen.
            AstryxText(
              matches.isEmpty ? 'Nothing to show' : '$first–$last of '
                  '${matches.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              children: <Widget>[
                AstryxSelector<int>(
                  label: 'Rows per page',
                  labelHidden: true,
                  value: _pageSize,
                  width: 132,
                  size: AstryxInputSize.sm,
                  onChanged: (value) => _refilter(
                    () => _pageSize = value ?? _pageSize,
                  ),
                  options: <AstryxSelectorOption<int>>[
                    for (final size in _pageSizes)
                      AstryxSelectorOption<int>(
                        value: size,
                        label: '$size per page',
                      ),
                  ],
                ),
                AstryxPagination(
                  label: 'Runs',
                  page: _page,
                  pageCount: _pageCount,
                  onPageChanged: (page) => setState(() => _page = page),
                ),
              ],
            ),
          ],
        ),
        child: AstryxTable<Run>(
          label: 'Pipeline runs',
          rows: rows,
          keyOf: (row) => row.id,
          rowLabelOf: (row) => '${row.id} — ${row.pipeline}',
          sort: _sort,
          // Sorting is a change to the whole set, so it resets the page too.
          onSortChanged: (sort) => _refilter(() => _sort = sort),
          striped: true,
          emptyState: AstryxCenter(
            minHeight: 220,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxIcon(
                  AstryxIconName.search,
                  size: AstryxIconSize.lg,
                  color: AstryxIconColor.secondary,
                ),
                const AstryxHeading('No runs match', level: 4),
                const AstryxText(
                  'Every filter is still applied.',
                  color: AstryxTextColor.secondary,
                ),
                AstryxButton(
                  label: 'Clear filters',
                  onPressed: () => _refilter(() {
                    _query.clear();
                    _state = 'all';
                  }),
                ),
              ],
            ),
          ),
          rowActionsBuilder: (context, row) => AstryxIconButton(
            icon: AstryxIconName.externalLink,
            label: 'Open ${row.id}',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
          columns: <AstryxTableColumn<Run>>[
            AstryxTableColumn<Run>(
              id: 'run',
              header: 'Run',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              compare: (a, b) => a.id.compareTo(b.id),
              cellBuilder: (context, row) =>
                  AstryxCode(row.id, semanticsLabel: 'Run ${row.id}'),
            ),
            AstryxTableColumn<Run>(
              id: 'pipeline',
              header: 'Pipeline',
              width: const AstryxTableColumnWidth.flex(1.4),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.pipeline, maxLines: 1),
                  AstryxText(
                    row.branch,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            AstryxTableColumn<Run>(
              id: 'state',
              header: 'State',
              width: const AstryxTableColumnWidth.intrinsic(min: 104),
              cellBuilder: (context, row) => switch (row.state) {
                'failed' => const AstryxBadge(
                  'Failed',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                'running' => const AstryxBadge(
                  'Running',
                  variant: AstryxBadgeVariant.info,
                  icon: AstryxIcon(AstryxIconName.clock),
                ),
                _ => const AstryxBadge(
                  'Passed',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
                ),
              },
            ),
            AstryxTableColumn<Run>(
              id: 'owner',
              header: 'Owner',
              compare: (a, b) => a.owner.compareTo(b.owner),
              cellBuilder: (context, row) => AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxAvatar(name: row.owner, size: AstryxAvatarSize.xs),
                  Flexible(child: AstryxText(row.owner, maxLines: 1)),
                ],
              ),
            ),
            AstryxTableColumn<Run>(
              id: 'duration',
              header: 'Duration',
              width: const AstryxTableColumnWidth.fixed(96),
              alignment: AstryxTableAlignment.end,
              compare: (a, b) => a.seconds.compareTo(b.seconds),
              cellBuilder: (context, row) => AstryxText(
                '${(row.seconds / 60).floor()}m ${row.seconds % 60}s',
                tabularNumbers: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **`scrollable: false`.** `AstryxTable` scrolls its own body under its header row. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded — which is a layout assertion rather than a subtle bug.
- **Accessibility:** Row actions are always visible, never on hover — touch has no hover, and the density system suppresses hover styling there. `rowLabelOf` is what names each row for the action beside it: "Actions" repeated fourteen times is fourteen identical announcements.
- **Note:** **Rows per page is a selector, not a switch or a segmented control.** It picks a value out of several and shows the current one, which is the line between AstryxSelector (references/forms.md) and the other two.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Table page with chart

`example/lib/examples/template_chart_examples.dart`

A table screen with a summary chart above it.

```dart
/// One day of trading for the whole book.
typedef Session = ({
  String date,
  String desk,
  int volume,
  int pnl,
  bool breached,
});

class TablePageChartTemplate extends StatefulWidget {
  const TablePageChartTemplate({super.key});

  @override
  State<TablePageChartTemplate> createState() => _TablePageChartTemplateState();
}

class _TablePageChartTemplateState extends State<TablePageChartTemplate> {
  static const List<Session> _all = <Session>[
    (date: '12 Aug', desk: 'Rates', volume: 4120, pnl: 184200, breached: false),
    (date: '12 Aug', desk: 'Credit', volume: 2980, pnl: -41100, breached: true),
    (date: '11 Aug', desk: 'Rates', volume: 3860, pnl: 96400, breached: false),
    (
      date: '11 Aug',
      desk: 'Equity',
      volume: 5210,
      pnl: 210500,
      breached: false,
    ),
    (date: '11 Aug', desk: 'Credit', volume: 3140, pnl: 28800, breached: false),
    (date: '10 Aug', desk: 'Rates', volume: 2740, pnl: -18600, breached: false),
    (
      date: '10 Aug',
      desk: 'Equity',
      volume: 4890,
      pnl: 152300,
      breached: false,
    ),
    (date: '9 Aug', desk: 'Credit', volume: 2210, pnl: -92400, breached: true),
    (date: '9 Aug', desk: 'Rates', volume: 3320, pnl: 64100, breached: false),
    (date: '8 Aug', desk: 'Equity', volume: 4460, pnl: 118900, breached: false),
    (date: '8 Aug', desk: 'Credit', volume: 2650, pnl: 36200, breached: false),
    (date: '7 Aug', desk: 'Rates', volume: 3980, pnl: 142700, breached: false),
  ];

  /// The series the chart draws, in the same order as the rows below it.
  static const List<double> _cumulative = <double>[
    0.14, 0.28, 0.19, 0.34, 0.41, 0.36, 0.52, 0.44, 0.58, 0.71, 0.66, 0.82,
  ];

  String _desk = 'All';
  int _page = 1;
  static const int _pageSize = 5;

  List<Session> get _matches =>
      _desk == 'All' ? _all : _all.where((row) => row.desk == _desk).toList();

  List<Session> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Session>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// Every filter goes through here, because narrowing the set while on page
  /// three shows an empty table — which reads as "no data" rather than "you
  /// are past the end".
  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final pages = (matches.length / _pageSize).ceil().clamp(1, 999);
    final start = matches.isEmpty ? 0 : (_page - 1) * _pageSize + 1;
    final end = start + rows.length - 1;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        // The table scrolls its own body under its own header row. Leaving the
        // layout scrollable puts one scroll view inside another.
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('Trading sessions', level: 1),
                    AstryxText(
                      '${matches.length} of ${_all.length} sessions',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Desk',
                  value: _desk,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _desk = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Rates', label: 'Rates'),
                    AstryxSegment(value: 'Credit', label: 'Credit'),
                    AstryxSegment(value: 'Equity', label: 'Equity'),
                  ],
                ),
              ],
            ),
            // The chart summarises the *whole* set, not the page. A summary
            // that moved every time the reader turned a page would be a
            // summary of the page, which the page already is.
            const AstryxCard(
              variant: AstryxCardVariant.muted,
              padding: AstryxSpacingToken.spacing3,
              header: AstryxText(
                'Cumulative P&L, all desks',
                type: AstryxTextType.label,
              ),
              child: TrendChart(
                values: _cumulative,
                height: 88,
                showBaseline: false,
                label: 'Cumulative profit and loss over twelve sessions',
                semanticsValue:
                    'Rising from 0.14 to 0.82 million, with drawdowns on the '
                    '9th and the 11th',
              ),
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxText(
              matches.isEmpty ? 'Nothing to show' : '$start–$end of '
                  '${matches.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
            AstryxPagination(
              page: _page,
              pageCount: pages,
              onPageChanged: (page) => setState(() => _page = page),
            ),
          ],
        ),
        child: AstryxTable<Session>(
          label: 'Trading sessions',
          keyOf: (row) => '${row.date}/${row.desk}',
          rowLabelOf: (row) => '${row.desk} on ${row.date}',
          density: AstryxTableDensity.compact,
          minWidth: 560,
          emptyState: AstryxEmptyState(
            title: 'No sessions for that desk',
            size: AstryxEmptyStateSize.compact,
            actions: <Widget>[
              AstryxButton(
                label: 'Show all desks',
                onPressed: () => _refilter(() => _desk = 'All'),
              ),
            ],
          ),
          columns: <AstryxTableColumn<Session>>[
            AstryxTableColumn<Session>(
              id: 'date',
              header: 'Date',
              width: const AstryxTableColumnWidth.fixed(90),
              cellBuilder: (context, row) => AstryxText(row.date, maxLines: 1),
            ),
            AstryxTableColumn<Session>(
              id: 'desk',
              header: 'Desk',
              cellBuilder: (context, row) => AstryxBadge(row.desk),
            ),
            AstryxTableColumn<Session>(
              id: 'volume',
              header: 'Volume',
              width: const AstryxTableColumnWidth.fixed(100),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) =>
                  AstryxText('${row.volume}', tabularNumbers: true),
            ),
            AstryxTableColumn<Session>(
              id: 'pnl',
              header: 'P&L',
              width: const AstryxTableColumnWidth.fixed(120),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) => AstryxText(
                '${row.pnl < 0 ? '−' : ''}${pence(row.pnl.abs())}',
                tabularNumbers: true,
              ),
            ),
            AstryxTableColumn<Session>(
              id: 'limit',
              header: 'Limit',
              width: const AstryxTableColumnWidth.fixed(120),
              cellBuilder: (context, row) => row.breached
                  ? const AstryxBadge(
                      'Breached',
                      variant: AstryxBadgeVariant.error,
                      icon: AstryxIcon(AstryxIconName.error),
                    )
                  : const AstryxBadge(
                      'Within',
                      variant: AstryxBadgeVariant.success,
                      icon: AstryxIcon(AstryxIconName.success),
                    ),
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **`scrollable: false`.** AstryxTable (references/data.md) scrolls its own body under its header row. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded — a layout assertion rather than a subtle bug.
- **Accessibility:** The chart is a `TrendChart` with a `semanticsValue` that states the shape in words — where it starts, where it ends, and where the drawdowns are. The same painter, and the same rule, as the portfolio dashboard (references/templates.md): the picture is never the only copy of the fact.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Table page with heatmap

`example/lib/examples/template_heatmap_examples.dart`

A table screen whose cells carry heatmap and status colouring.

```dart
/// One service, and its p95 latency in each region.
typedef ServiceLatency = ({
  String service,
  String owner,
  Map<String, int> byRegion,
  String status,
});

class HeatmapStatusTablePageTemplate extends StatefulWidget {
  const HeatmapStatusTablePageTemplate({super.key});

  @override
  State<HeatmapStatusTablePageTemplate> createState() =>
      _HeatmapStatusTablePageTemplateState();
}

class _HeatmapStatusTablePageTemplateState
    extends State<HeatmapStatusTablePageTemplate> {
  static const List<String> _regions = <String>[
    'eu-west',
    'eu-north',
    'us-east',
    'us-west',
    'ap-south',
  ];

  static const List<ServiceLatency> _all = <ServiceLatency>[
    (
      service: 'scheduler',
      owner: 'Platform',
      status: 'Breaching',
      byRegion: <String, int>{
        'eu-west': 412,
        'eu-north': 388,
        'us-east': 902,
        'us-west': 741,
        'ap-south': 1180,
      },
    ),
    (
      service: 'edge',
      owner: 'Platform',
      status: 'At risk',
      byRegion: <String, int>{
        'eu-west': 88,
        'eu-north': 94,
        'us-east': 121,
        'us-west': 486,
        'ap-south': 512,
      },
    ),
    (
      service: 'artifacts',
      owner: 'Delivery',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 142,
        'eu-north': 138,
        'us-east': 166,
        'us-west': 174,
        'ap-south': 231,
      },
    ),
    (
      service: 'metrics',
      owner: 'Observability',
      status: 'At risk',
      byRegion: <String, int>{
        'eu-west': 264,
        'eu-north': 271,
        'us-east': 298,
        'us-west': 312,
        'ap-south': 640,
      },
    ),
    (
      service: 'registry',
      owner: 'Delivery',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 61,
        'eu-north': 58,
        'us-east': 74,
        'us-west': 79,
        'ap-south': 96,
      },
    ),
    (
      service: 'billing',
      owner: 'Commerce',
      status: 'Healthy',
      byRegion: <String, int>{
        'eu-west': 104,
        'eu-north': 111,
        'us-east': 98,
        'us-west': 122,
        'ap-south': 148,
      },
    ),
    (
      service: 'search',
      owner: 'Discovery',
      status: 'Breaching',
      byRegion: <String, int>{
        'eu-west': 520,
        'eu-north': 498,
        'us-east': 610,
        'us-west': 588,
        'ap-south': 860,
      },
    ),
  ];

  String _owner = 'All';
  int _page = 1;
  static const int _pageSize = 4;

  List<ServiceLatency> get _matches => _owner == 'All'
      ? _all
      : _all.where((row) => row.owner == _owner).toList();

  List<ServiceLatency> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <ServiceLatency>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// The scale spans the **whole grid**, not the page and not the row.
  ///
  /// A ramp recomputed per page would recolour every cell when the reader
  /// turned it — the same 412 ms would be pale on one page and saturated on
  /// the next, which makes the colour a fact about the page rather than about
  /// the number.
  static final int _worst = _all
      .expand((row) => row.byRegion.values)
      .reduce((a, b) => a > b ? a : b);

  double _intensity(int value) => value / _worst;

  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final pages = (matches.length / _pageSize).ceil().clamp(1, 999);

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('p95 latency by region', level: 1),
                    AstryxText(
                      '${matches.length} services · milliseconds',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Owner',
                  value: _owner,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _owner = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Platform', label: 'Platform'),
                    AstryxSegment(value: 'Delivery', label: 'Delivery'),
                  ],
                ),
              ],
            ),
            // The legend is not optional decoration. Without it the ramp is a
            // set of colours with no stated direction, and a reader has to
            // infer from the numbers what the colours were supposed to add.
            HeatLegend(
              low: 'fastest',
              high: 'slowest ($_worst ms)',
              tint: AstryxColorToken.error,
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxText(
              '${rows.length} of ${matches.length} services',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
            AstryxPagination(
              page: _page,
              pageCount: pages,
              onPageChanged: (page) => setState(() => _page = page),
            ),
          ],
        ),
        child: AstryxTable<ServiceLatency>(
          label: 'p95 latency by service and region',
          keyOf: (row) => row.service,
          rowLabelOf: (row) => row.service,
          density: AstryxTableDensity.compact,
          minWidth: 720,
          columns: <AstryxTableColumn<ServiceLatency>>[
            AstryxTableColumn<ServiceLatency>(
              id: 'service',
              header: 'Service',
              width: const AstryxTableColumnWidth.fixed(150),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.service, type: AstryxTextType.code),
                  AstryxText(
                    row.owner,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            for (final region in _regions)
              AstryxTableColumn<ServiceLatency>(
                id: region,
                header: region,
                width: const AstryxTableColumnWidth.fixed(96),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) =>
                    a.byRegion[region]!.compareTo(b.byRegion[region]!),
                cellBuilder: (context, row) => HeatCell(
                  text: '${row.byRegion[region]}',
                  intensity: _intensity(row.byRegion[region]!),
                  tint: AstryxColorToken.error,
                  onTint: AstryxColorToken.onError,
                  semanticsLabel:
                      '${row.byRegion[region]} milliseconds in $region',
                ),
              ),
            AstryxTableColumn<ServiceLatency>(
              id: 'status',
              header: 'Objective',
              width: const AstryxTableColumnWidth.fixed(130),
              cellBuilder: (context, row) => switch (row.status) {
                // The status column is *semantic*, and it is a badge rather
                // than a heat cell: "breaching" is a threshold somebody
                // agreed, not a position on a ramp. Two different kinds of
                // colour on one screen have to look like two different kinds.
                'Breaching' => const AstryxBadge(
                  'Breaching',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                'At risk' => const AstryxBadge(
                  'At risk',
                  variant: AstryxBadgeVariant.warning,
                  icon: AstryxIcon(AstryxIconName.warning),
                ),
                _ => const AstryxBadge(
                  'Healthy',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
                ),
              },
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **There is no heatmap component, and no colour scale in the token system either.** The ten palette (references/guides.md) families are *categorical* — "the Red team" — so none of them is a ramp, and picking one would be asserting a severity the data has not got. What a heatmap needs is a continuous scale between two tokens, and that is one `Color.lerp`.
- **Accessibility:** **Every cell prints its own number, and the screen carries a legend.** The figure is the half of the cell that survives greyscale, a screenshot and a colour-blind reader; the legend is what says which end of the ramp is which, because a hue does not imply a direction. Each cell also announces itself in full — "902 milliseconds in us-east" — rather than reading out a bare number in a grid whose column headers are somewhere above.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Column | Colour means | Drawn as |
| --- | --- | --- |
| The five regions | Where this value sits on a continuous scale | A `HeatCell` — a ground lerped toward `error`, with the figure on top. |
| Objective | A threshold somebody agreed | An AstryxBadge (references/surfaces.md) with an icon and a word. *Breaching* is not a position on a ramp. |

---

## Retail heatmap table

`example/lib/examples/template_heatmap_examples.dart`

The heatmap table screen with a retail data set.

```dart
/// One shoe, and how many pairs went in each size.
typedef Style = ({
  String name,
  String range,
  Map<String, int> bySize,
  int stock,
});

class ShoeStoreHeatmapTemplate extends StatefulWidget {
  const ShoeStoreHeatmapTemplate({super.key});

  @override
  State<ShoeStoreHeatmapTemplate> createState() =>
      _ShoeStoreHeatmapTemplateState();
}

class _ShoeStoreHeatmapTemplateState extends State<ShoeStoreHeatmapTemplate> {
  static const List<String> _sizes = <String>['6', '7', '8', '9', '10', '11'];

  static const List<Style> _all = <Style>[
    (
      name: 'Trail Runner GTX',
      range: 'Trail',
      stock: 412,
      bySize: <String, int>{
        '6': 18,
        '7': 46,
        '8': 92,
        '9': 141,
        '10': 118,
        '11': 54,
      },
    ),
    (
      name: 'Fell Shoe 3',
      range: 'Trail',
      stock: 96,
      bySize: <String, int>{
        '6': 11,
        '7': 28,
        '8': 61,
        '9': 88,
        '10': 74,
        '11': 31,
      },
    ),
    (
      name: 'Approach Mid',
      range: 'Hiking',
      stock: 12,
      bySize: <String, int>{
        '6': 6,
        '7': 19,
        '8': 44,
        '9': 52,
        '10': 48,
        '11': 22,
      },
    ),
    (
      name: 'Road Tempo',
      range: 'Road',
      stock: 288,
      bySize: <String, int>{
        '6': 24,
        '7': 58,
        '8': 104,
        '9': 162,
        '10': 131,
        '11': 47,
      },
    ),
    (
      name: 'City Knit',
      range: 'Road',
      stock: 0,
      bySize: <String, int>{
        '6': 31,
        '7': 64,
        '8': 88,
        '9': 96,
        '10': 71,
        '11': 26,
      },
    ),
    (
      name: 'Summit Boot',
      range: 'Hiking',
      stock: 54,
      bySize: <String, int>{
        '6': 4,
        '7': 12,
        '8': 33,
        '9': 41,
        '10': 39,
        '11': 26,
      },
    ),
  ];

  String _range = 'All';
  int _page = 1;
  static const int _pageSize = 4;

  List<Style> get _matches => _range == 'All'
      ? _all
      : _all.where((row) => row.range == _range).toList();

  List<Style> get _rows {
    final matches = _matches;
    final start = (_page - 1) * _pageSize;
    if (start >= matches.length) return const <Style>[];
    final end = start + _pageSize;
    return matches.sublist(start, end > matches.length ? matches.length : end);
  }

  /// The busiest cell in the whole grid, so the ramp means the same thing on
  /// every page and under every filter.
  static final int _best = _all
      .expand((row) => row.bySize.values)
      .reduce((a, b) => a > b ? a : b);

  /// Which size sold most, across everything shown. The point of the screen.
  String get _peakSize {
    final totals = <String, int>{};
    for (final row in _matches) {
      for (final entry in row.bySize.entries) {
        totals[entry.key] = (totals[entry.key] ?? 0) + entry.value;
      }
    }
    if (totals.isEmpty) return '—';
    final ranked = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return 'UK ${ranked.first.key}';
  }

  void _refilter(VoidCallback change) => setState(() {
    change();
    _page = 1;
  });

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final rows = _rows;
    final pages = (matches.length / _pageSize).ceil().clamp(1, 999);

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        scrollable: false,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('Pairs sold by size', level: 1),
                    // The conclusion, in words, above the grid. A heatmap is
                    // how a reader checks an answer; it is a poor way to be
                    // told one.
                    AstryxText(
                      'Busiest size: $_peakSize · ${matches.length} styles',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Range',
                  value: _range,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => _refilter(() => _range = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'All', label: 'All'),
                    AstryxSegment(value: 'Road', label: 'Road'),
                    AstryxSegment(value: 'Trail', label: 'Trail'),
                    AstryxSegment(value: 'Hiking', label: 'Hiking'),
                  ],
                ),
              ],
            ),
            // Sales rise toward `success`, and latency rose toward `error` on
            // the [HeatmapStatusTablePageTemplate]. Same ramp, opposite
            // meaning — which is exactly why the legend has to say which end
            // is which rather than leaving the hue to imply it.
            HeatLegend(
              low: 'fewest',
              high: 'most ($_best pairs)',
              tint: AstryxColorToken.success,
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxText(
              '${rows.length} of ${matches.length} styles',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
            AstryxPagination(
              page: _page,
              pageCount: pages,
              onPageChanged: (page) => setState(() => _page = page),
            ),
          ],
        ),
        child: AstryxTable<Style>(
          label: 'Pairs sold by style and size',
          keyOf: (row) => row.name,
          rowLabelOf: (row) => row.name,
          density: AstryxTableDensity.compact,
          minWidth: 760,
          columns: <AstryxTableColumn<Style>>[
            AstryxTableColumn<Style>(
              id: 'style',
              header: 'Style',
              width: const AstryxTableColumnWidth.fixed(170),
              cellBuilder: (context, row) => AstryxVStack(
                gap: AstryxSpacingToken.spacing0_5,
                children: <Widget>[
                  AstryxText(row.name, maxLines: 1),
                  AstryxText(
                    row.range,
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            for (final size in _sizes)
              AstryxTableColumn<Style>(
                id: 'size_$size',
                header: 'UK $size',
                width: const AstryxTableColumnWidth.fixed(78),
                alignment: AstryxTableAlignment.end,
                compare: (a, b) => a.bySize[size]!.compareTo(b.bySize[size]!),
                cellBuilder: (context, row) => HeatCell(
                  text: '${row.bySize[size]}',
                  intensity: row.bySize[size]! / _best,
                  tint: AstryxColorToken.success,
                  onTint: AstryxColorToken.onSuccess,
                  semanticsLabel: '${row.bySize[size]} pairs in UK $size',
                ),
              ),
            AstryxTableColumn<Style>(
              id: 'stock',
              header: 'Stock',
              width: const AstryxTableColumnWidth.fixed(130),
              compare: (a, b) => a.stock.compareTo(b.stock),
              cellBuilder: (context, row) => switch (row.stock) {
                0 => const AstryxBadge(
                  'Out of stock',
                  variant: AstryxBadgeVariant.error,
                  icon: AstryxIcon(AstryxIconName.error),
                ),
                < 50 => AstryxBadge(
                  '${row.stock} left',
                  variant: AstryxBadgeVariant.warning,
                  icon: const AstryxIcon(AstryxIconName.warning),
                ),
                _ => AstryxBadge(
                  '${row.stock} in stock',
                  variant: AstryxBadgeVariant.success,
                  icon: const AstryxIcon(AstryxIconName.success),
                ),
              },
            ),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **Which is why the legend is not decoration.** A hue does not imply a direction — a reader arriving at a saturated grid has no way to know whether they are looking at a triumph or a fire. The legend states both ends in words, and the header states the conclusion outright.
- **Accessibility:** Each cell announces "141 pairs in UK 9". A screen-reader user moving across a row of six figures has no column header in earshot, so a cell that announces only its number has told them a number about nothing.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Kanban board

`example/lib/examples/template_board_examples.dart`

Columns of draggable cards.

```dart
/// One card on the board.
typedef Ticket = ({
  String id,
  String title,
  String assignee,
  String tag,
  int points,
  bool blocked,
});

/// One column, and the work-in-progress limit it is judged against.
typedef Lane = ({String id, String title, int? limit});

class KanbanBoardTemplate extends StatefulWidget {
  const KanbanBoardTemplate({super.key});

  @override
  State<KanbanBoardTemplate> createState() => _KanbanBoardTemplateState();
}

class _KanbanBoardTemplateState extends State<KanbanBoardTemplate> {
  static const List<Lane> _lanes = <Lane>[
    (id: 'triage', title: 'Triage', limit: null),
    (id: 'doing', title: 'In progress', limit: 3),
    (id: 'review', title: 'In review', limit: 2),
    (id: 'done', title: 'Done', limit: null),
  ];

  static const List<Ticket> _tickets = <Ticket>[
    (
      id: 'ATL-412',
      title: 'Health check gives up before the port binds',
      assignee: 'Ada Lovelace',
      tag: 'scheduler',
      points: 5,
      blocked: false,
    ),
    (
      id: 'ATL-408',
      title: 'Artifact upload retries without backing off',
      assignee: 'Grace Hopper',
      tag: 'artifacts',
      points: 3,
      blocked: true,
    ),
    (
      id: 'ATL-401',
      title: 'Rollback leaves the old revision in the routing table',
      assignee: 'Alan Turing',
      tag: 'edge',
      points: 8,
      blocked: false,
    ),
    (
      id: 'ATL-397',
      title: 'Deploy log truncates at 400 lines',
      assignee: 'Ada Lovelace',
      tag: 'logs',
      points: 2,
      blocked: false,
    ),
    (
      id: 'ATL-392',
      title: 'Metrics shard 4 lags behind by ninety seconds',
      assignee: 'Katherine Johnson',
      tag: 'metrics',
      points: 5,
      blocked: false,
    ),
    (
      id: 'ATL-388',
      title: 'On-call rota export drops the last row',
      assignee: 'Grace Hopper',
      tag: 'oncall',
      points: 1,
      blocked: false,
    ),
    (
      id: 'ATL-380',
      title: 'Pipeline variables are not masked in the log',
      assignee: 'Alan Turing',
      tag: 'security',
      points: 3,
      blocked: false,
    ),
  ];

  /// Where each ticket is. The board is this map, and everything on screen is
  /// derived from it — which is what makes a drag and a menu the same edit.
  final Map<String, String> _lane = <String, String>{
    'ATL-412': 'doing',
    'ATL-408': 'doing',
    'ATL-401': 'review',
    'ATL-397': 'triage',
    'ATL-392': 'triage',
    'ATL-388': 'done',
    'ATL-380': 'triage',
  };

  /// The card a pointer is currently carrying, so its origin can dim.
  String? _dragging;

  List<Ticket> _inLane(String lane) =>
      _tickets.where((ticket) => _lane[ticket.id] == lane).toList();

  /// The one edit this screen makes. A drag calls it; so does a menu row.
  void _move(String ticket, String lane) {
    if (_lane[ticket] == lane) return;
    final title = _lanes.firstWhere((entry) => entry.id == lane).title;
    setState(() => _lane[ticket] = lane);
    AstryxToastScope.of(context).show(
      AstryxToast(message: '$ticket moved to $title'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 620,
      child: AstryxLayout(
        scrollable: false,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Sprint 42', level: 1),
                AstryxText(
                  '${_tickets.length} tickets · '
                  '${_tickets.fold<int>(0, (sum, t) => sum + t.points)} points',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxButton(
              label: 'New ticket',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (final lane in _lanes)
                SizedBox(
                  width: 268,
                  child: _Lane(
                    lane: lane,
                    tickets: _inLane(lane.id),
                    lanes: _lanes,
                    dragging: _dragging,
                    onMove: _move,
                    onDragStart: (id) => setState(() => _dragging = id),
                    onDragEnd: () => setState(() => _dragging = null),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One column: a header, a drop target, and the cards in it.
class _Lane extends StatelessWidget {
  const _Lane({
    required this.lane,
    required this.tickets,
    required this.lanes,
    required this.dragging,
    required this.onMove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final Lane lane;
  final List<Ticket> tickets;
  final List<Lane> lanes;
  final String? dragging;
  final void Function(String ticket, String lane) onMove;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;

  bool get _overLimit => lane.limit != null && tickets.length > lane.limit!;

  @override
  Widget build(BuildContext context) {
    // `DragTarget` is the framework's, not the package's. What `astryx_ui`
    // contributes is everything the column *looks* like — and the card
    // variant is what says "let go here", because a border that only appears
    // under a pointer is the one signal a drag is allowed to use.
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) => onMove(details.data, lane.id),
      builder: (context, candidate, rejected) {
        final active = candidate.isNotEmpty;

        return AstryxCard(
          variant: active
              ? AstryxCardVariant.standard
              : AstryxCardVariant.muted,
          elevation: active ? AstryxElevation.low : AstryxElevation.none,
          padding: AstryxSpacingToken.spacing3,
          // The lane is stretched to the height of the board, and a busy
          // column holds more cards than that. `scrollable` is what keeps the
          // header pinned while the cards under it move.
          scrollable: true,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: AstryxText(
                  lane.title,
                  type: AstryxTextType.label,
                  maxLines: 1,
                ),
              ),
              // The limit is a number *and* a word when it is breached. A
              // column that turned red and said nothing is a rule nobody can
              // look up.
              if (lane.limit == null)
                AstryxBadge('${tickets.length}')
              else
                AstryxBadge(
                  '${tickets.length}/${lane.limit}',
                  variant: _overLimit
                      ? AstryxBadgeVariant.warning
                      : AstryxBadgeVariant.neutral,
                  icon: _overLimit
                      ? const AstryxIcon(AstryxIconName.warning)
                      : null,
                  semanticsLabel: _overLimit
                      ? '${tickets.length} of ${lane.limit}, over the limit'
                      : '${tickets.length} of ${lane.limit}',
                ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              if (tickets.isEmpty)
                AstryxEmptyState(
                  title: active ? 'Drop it here' : 'Nothing here',
                  size: AstryxEmptyStateSize.compact,
                  minHeight: 120,
                )
              else
                for (final ticket in tickets)
                  _TicketCard(
                    ticket: ticket,
                    lanes: lanes,
                    lane: lane,
                    dimmed: dragging == ticket.id,
                    onMove: onMove,
                    onDragStart: onDragStart,
                    onDragEnd: onDragEnd,
                  ),
            ],
          ),
        );
      },
    );
  }
}

/// One ticket: draggable for a pointer, and movable by menu for everyone else.
class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.lanes,
    required this.lane,
    required this.dimmed,
    required this.onMove,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final Ticket ticket;
  final List<Lane> lanes;
  final Lane lane;
  final bool dimmed;
  final void Function(String ticket, String lane) onMove;
  final ValueChanged<String> onDragStart;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final card = _body(context);

    // `Draggable` for a mouse, `LongPressDraggable` for a thumb. Neither is
    // reachable from a keyboard, which is exactly why the menu inside `card`
    // is not an extra: it is the path that always works.
    return Draggable<String>(
      data: ticket.id,
      onDragStarted: () => onDragStart(ticket.id),
      onDragEnd: (_) => onDragEnd(),
      onDraggableCanceled: (_, _) => onDragEnd(),
      feedback: SizedBox(width: 244, child: _body(context, lifted: true)),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }

  Widget _body(BuildContext context, {bool lifted = false}) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      elevation: lifted ? AstryxElevation.high : AstryxElevation.none,
      header: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxText(ticket.id, type: AstryxTextType.code),
          // The move menu. Named for the ticket, not "More" — a board of seven
          // identical "More" buttons is seven identical announcements.
          if (!lifted)
            AstryxMoreMenu(
              label: 'Move ${ticket.id}',
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('Move to'),
                for (final target in lanes)
                  AstryxMenuItem(
                    label: target.title,
                    enabled: target.id != lane.id,
                    onSelected: () => onMove(ticket.id, target.id),
                  ),
              ],
            ),
        ],
      ),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxAvatar(name: ticket.assignee, size: AstryxAvatarSize.xs),
          AstryxHStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxBadge(ticket.tag),
              AstryxBadge(
                '${ticket.points}',
                semanticsLabel: '${ticket.points} points',
              ),
            ],
          ),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText(ticket.title, maxLines: 3),
          if (ticket.blocked)
            const AstryxBadge(
              'Blocked',
              variant: AstryxBadgeVariant.error,
              icon: AstryxIcon(AstryxIconName.error),
            ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Careful:** **Nothing in `astryx_ui` moves under a pointer, and nothing needs to.** Dragging is a gesture, not a surface: `Draggable` and `DragTarget` already live in `flutter/widgets`, and a design system that wrapped them would be adding a name rather than a capability. This template uses the framework’s own, with `astryx_ui` cards riding on top.
- **Accessibility:** The move menu is named for its ticket — "Move ATL-412", not "More". Seven identical **More** buttons on one board is seven identical announcements, and the reader has no way to tell which card they are about to move.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Incident console

`example/lib/examples/template_console_examples.dart`

A live operations view: severity, timeline, and the current on-call.

```dart
/// One live incident.
typedef Incident = ({
  String id,
  int severity,
  String title,
  String service,
  String owner,
  bool acknowledged,
  Duration age,
});

/// One entry in an incident's timeline.
typedef Event = ({String who, String what, Duration ago});

class IncidentConsoleTemplate extends StatefulWidget {
  const IncidentConsoleTemplate({super.key});

  @override
  State<IncidentConsoleTemplate> createState() =>
      _IncidentConsoleTemplateState();
}

class _IncidentConsoleTemplateState extends State<IncidentConsoleTemplate> {
  static const List<Incident> _all = <Incident>[
    (
      id: 'INC-4102',
      severity: 1,
      title: 'Scheduler health check timing out',
      service: 'scheduler',
      owner: 'Ada Lovelace',
      acknowledged: true,
      age: Duration(minutes: 41),
    ),
    (
      id: 'INC-4101',
      severity: 2,
      title: 'Elevated 5xx from the edge in eu-west',
      service: 'edge',
      owner: 'Grace Hopper',
      acknowledged: true,
      age: Duration(hours: 2, minutes: 12),
    ),
    (
      id: 'INC-4100',
      severity: 3,
      title: 'Artifact upload retries above baseline',
      service: 'artifacts',
      owner: 'Unassigned',
      acknowledged: false,
      age: Duration(minutes: 6),
    ),
    (
      id: 'INC-4098',
      severity: 3,
      title: 'Metrics ingestion lag on shard 4',
      service: 'metrics',
      owner: 'Alan Turing',
      acknowledged: true,
      age: Duration(hours: 5, minutes: 3),
    ),
  ];

  static const Map<String, List<Event>> _timeline = <String, List<Event>>{
    'INC-4102': <Event>[
      (
        who: 'Ada Lovelace',
        what: 'Raised the health-check timeout to 60 seconds',
        ago: Duration(minutes: 4),
      ),
      (
        who: 'Ada Lovelace',
        what: 'Acknowledged and took ownership',
        ago: Duration(minutes: 33),
      ),
      (
        who: 'Atlas',
        what: 'Paged the Europe rotation',
        ago: Duration(minutes: 40),
      ),
      (
        who: 'Atlas',
        what: 'Opened after three failed deploys in a row',
        ago: Duration(minutes: 41),
      ),
    ],
  };

  /// A single instant that every relative stamp on this screen is measured
  /// from, so two rows the same age never disagree by a second.
  late final DateTime _opened = DateTime.now();

  int? _severity;
  String _selected = 'INC-4102';

  List<Incident> get _shown => _severity == null
      ? _all
      : _all.where((incident) => incident.severity == _severity).toList();

  Incident get _open => _all.firstWhere((incident) => incident.id == _selected);

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelWidth: 280,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxHeading('Incidents', level: 1),
                    // Pulsing says *live*, and the label says what live
                    // means. The pulse honours reduced motion; the words do
                    // not need to.
                    AstryxStatusDot(
                      AstryxStatusDotVariant.error,
                      label: 'Live — updating as events arrive',
                      pulsing: true,
                    ),
                  ],
                ),
                AstryxText(
                  '${shown.length} open · '
                  '${_all.where((i) => !i.acknowledged).length} '
                  'unacknowledged',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxSegmentedControl<int?>(
                  label: 'Severity',
                  value: _severity,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => setState(() => _severity = value),
                  segments: const <AstryxSegment<int?>>[
                    AstryxSegment<int?>(value: null, label: 'All'),
                    AstryxSegment<int?>(value: 1, label: 'Sev-1'),
                    AstryxSegment<int?>(value: 2, label: 'Sev-2'),
                    AstryxSegment<int?>(value: 3, label: 'Sev-3'),
                  ],
                ),
                AstryxButton(
                  label: 'Declare an incident',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        panel: _OnCallPanel(incident: _open, opened: _opened),
        child: shown.isEmpty
            ? const AstryxEmptyState(
                title: 'Nothing at that severity',
                description: 'Four incidents are open at other severities.',
                icon: AstryxIcon(
                  AstryxIconName.success,
                  size: AstryxIconSize.lg,
                ),
              )
            : AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final incident in shown)
                    _IncidentCard(
                      incident: incident,
                      opened: _opened,
                      selected: incident.id == _selected,
                      onPressed: () => setState(() => _selected = incident.id),
                    ),
                  AstryxSection(
                    title: 'Timeline · $_selected',
                    description:
                        'Newest first. Every entry names who did it, because '
                        '"acknowledged" with no name is the thing nobody can '
                        'follow up.',
                    child: AstryxList(
                      label: 'Timeline for $_selected',
                      showDividers: true,
                      children: <Widget>[
                        for (final event
                            in _timeline[_selected] ?? const <Event>[])
                          AstryxItem(
                            label: event.what,
                            description: event.who,
                            maxLines: 2,
                            trailing: AstryxTimestamp(
                              _opened.subtract(event.ago),
                              type: AstryxTextType.supporting,
                            ),
                          ),
                        if ((_timeline[_selected] ?? const <Event>[]).isEmpty)
                          const AstryxItem(
                            label: 'Nothing has happened yet',
                            description:
                                'This incident was opened automatically and '
                                'has not been touched.',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// One incident, as a card that is also the way into it.
class _IncidentCard extends StatelessWidget {
  const _IncidentCard({
    required this.incident,
    required this.opened,
    required this.selected,
    required this.onPressed,
  });

  final Incident incident;
  final DateTime opened;
  final bool selected;
  final VoidCallback onPressed;

  /// The badge for a severity.
  ///
  /// The number is in the text, not only in the colour — the palettes are
  /// *categorical*, and a reader who cannot tell red from orange still has to
  /// know which of these to look at first.
  AstryxBadgeVariant get _severityVariant => switch (incident.severity) {
    1 => AstryxBadgeVariant.error,
    2 => AstryxBadgeVariant.warning,
    _ => AstryxBadgeVariant.neutral,
  };

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      variant: selected
          ? AstryxCardVariant.standard
          : AstryxCardVariant.transparent,
      elevation: selected ? AstryxElevation.low : AstryxElevation.none,
      semanticsLabel:
          '${incident.id}, severity ${incident.severity}, '
          '${incident.title}, owned by ${incident.owner}',
      onPressed: onPressed,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxBadge(
                      'Sev-${incident.severity}',
                      variant: _severityVariant,
                      icon: AstryxIcon(
                        incident.severity == 1
                            ? AstryxIconName.error
                            : AstryxIconName.warning,
                      ),
                    ),
                    AstryxText(incident.id, type: AstryxTextType.code),
                    if (!incident.acknowledged)
                      const AstryxBadge(
                        'Unacknowledged',
                        variant: AstryxBadgeVariant.warning,
                        icon: AstryxIcon(AstryxIconName.clock),
                      ),
                  ],
                ),
                AstryxText(
                  incident.title,
                  type: AstryxTextType.label,
                  maxLines: 1,
                ),
                AstryxText(
                  '${incident.service} · ${incident.owner}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // A relative stamp that keeps ticking. On a wall display, "41
          // minutes" that froze at load is worse than no clock at all.
          AstryxTimestamp(
            opened.subtract(incident.age),
            type: AstryxTextType.supporting,
          ),
        ],
      ),
    );
  }
}

/// Who has the incident, and who to reach if they do not answer.
class _OnCallPanel extends StatelessWidget {
  const _OnCallPanel({required this.incident, required this.opened});

  final Incident incident;
  final DateTime opened;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxSection(
          title: 'On call',
          level: 2,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxItem(
                label: incident.owner,
                description: 'Europe, until 18:00',
                leading: AstryxAvatar(
                  name: incident.owner,
                  status: AstryxStatusDotVariant.success,
                  statusLabel: 'Available',
                ),
              ),
              const AstryxAvatarGroup(
                label: 'Also on this incident',
                size: AstryxAvatarSize.sm,
                avatars: <AstryxAvatar>[
                  AstryxAvatar(name: 'Grace Hopper'),
                  AstryxAvatar(name: 'Alan Turing'),
                  AstryxAvatar(name: 'Katherine Johnson'),
                  AstryxAvatar(name: 'Edsger Dijkstra'),
                ],
              ),
              AstryxButton(
                label: 'Page the escalation',
                variant: AstryxButtonVariant.destructive,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        AstryxSection(
          title: 'This incident',
          level: 2,
          child: AstryxMetadataList(
            items: <AstryxMetadataItem>[
              AstryxMetadataItem.text(label: 'Id', value: incident.id),
              AstryxMetadataItem.text(
                label: 'Service',
                value: incident.service,
              ),
              AstryxMetadataItem(
                label: 'Opened',
                semanticsValue: '${incident.age.inMinutes} minutes ago',
                value: AstryxTimestamp(opened.subtract(incident.age)),
              ),
              AstryxMetadataItem.text(
                label: 'Severity',
                value: 'Sev-${incident.severity}',
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        const AstryxSection(
          title: 'Error budget',
          level: 2,
          child: AstryxProgressBar(
            label: 'Error budget consumed this window',
            value: 0.68,
            variant: AstryxProgressVariant.warning,
            showValueLabel: true,
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **Every timeline entry names who did it.** "Acknowledged" with no name is the entry nobody can follow up, and it is the one an operations screen most often gets wrong — the actor is obvious to the system and invisible to the reader.
- **Accessibility:** The pressable incident card carries a `semanticsLabel` that assembles the whole row into one sentence — id, severity, title, owner. A screen-reader user moving down the list hears four rows, not sixteen nodes, which is the difference between a triage list and a wall of text.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Because it is live | It uses | Rather than |
| --- | --- | --- |
| Ages must be current | AstryxTimestamp (references/date_time.md) with `live: true` — the default | A formatted string, which freezes at load. "41 minutes" that stopped being true an hour ago is worse than no clock. |
| The screen must look alive | `AstryxStatusDot(pulsing: true)` with a real label | An animation with no name. The pulse honours reduced motion; the words carry the meaning either way. |
| Severity must be readable at a glance | A badge reading **Sev-1**, with an icon | A red row. Colour is never the only signal, and the palettes are categorical rather than severities. |

---

## Classic gallery

`example/lib/examples/template_gallery_examples.dart`

A uniform wall of media tiles, each opening the same viewer on the item that was pressed.

```dart
/// One item in the gallery.
///
/// `name` is not decoration. A tile whose picture has not loaded, or whose
/// reader cannot see it, has nothing else — which is why every media widget in
/// this package makes the name required rather than optional.
typedef GalleryItem = ({String name, String meta, String album});

class ClassicGalleryTemplate extends StatefulWidget {
  const ClassicGalleryTemplate({super.key});

  @override
  State<ClassicGalleryTemplate> createState() => _ClassicGalleryTemplateState();
}

class _ClassicGalleryTemplateState extends State<ClassicGalleryTemplate> {
  static const List<GalleryItem> _items = <GalleryItem>[
    (name: 'Cold aisle, rack 14', meta: '4032 × 3024', album: 'Site visit'),
    (name: 'Patch panel B', meta: '4032 × 3024', album: 'Site visit'),
    (name: 'Generator test', meta: '1920 × 1080', album: 'Site visit'),
    (name: 'Latency dashboard', meta: '2560 × 1440', album: 'Incident 4102'),
    (name: 'Scheduler timeline', meta: '2560 × 1440', album: 'Incident 4102'),
    (name: 'Health check log', meta: '1440 × 900', album: 'Incident 4102'),
    (name: 'Rollback approval', meta: '1440 × 900', album: 'Incident 4102'),
    (name: 'Post-mortem board', meta: '3024 × 4032', album: 'Incident 4102'),
  ];

  final AstryxOverlayController _viewer = AstryxOverlayController();

  /// Which item the viewer opens on, and which tile reads as selected.
  int _index = 0;
  String _album = 'All';

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  List<GalleryItem> get _shown => _album == 'All'
      ? _items
      : _items.where((item) => item.album == _album).toList();

  void _open(int index) {
    setState(() => _index = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing0_5,
              children: <Widget>[
                const AstryxHeading('Photos', level: 1),
                AstryxText(
                  '${shown.length} of ${_items.length} items',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSegmentedControl<String>(
              label: 'Album',
              value: _album,
              size: AstryxButtonSize.sm,
              onChanged: (value) => setState(() {
                _album = value;
                _index = 0;
              }),
              segments: const <AstryxSegment<String>>[
                AstryxSegment(value: 'All', label: 'All'),
                AstryxSegment(value: 'Site visit', label: 'Site visit'),
                AstryxSegment(value: 'Incident 4102', label: 'Incident'),
              ],
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing4,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            // A wrapping row of fixed-width tiles rather than an `AstryxGrid`:
            // a grid gives every cell in a row the height of the tallest, which
            // means measuring each cell intrinsically — and a pressable tile
            // sits inside the touch-target wrapper, which cannot answer that
            // measurement in touch density. Uniform tiles get the same wall
            // either way.
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              wrap: true,
              runGap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              children: <Widget>[
                for (var i = 0; i < shown.length; i++)
                  _GalleryTile(item: shown[i], onPressed: () => _open(i)),
              ],
            ),
            // The viewer lives beside the wall, not inside a tile: one overlay
            // for the whole gallery, opened on whichever item was pressed.
            AstryxLightbox(
              controller: _viewer,
              initialIndex: _index,
              label: 'Photos',
              items: <AstryxLightboxItem>[
                for (final item in shown)
                  AstryxLightboxItem(
                    label: item.name,
                    caption: '${item.name} · ${item.meta} · ${item.album}',
                    child: SizedBox(
                      width: 640,
                      child: AstryxAspectRatio(
                        ratio: 3 / 2,
                        background: AstryxColorToken.backgroundCard,
                        child: Center(
                          child: AstryxText(
                            item.name,
                            color: AstryxTextColor.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              actions: <Widget>[
                AstryxIconButton(
                  icon: AstryxIconName.copy,
                  label: 'Copy a link to this photo',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One tile: a picture, its name over the picture, and the whole thing
/// pressable.
class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.item, required this.onPressed});

  final GalleryItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return SizedBox(
      width: 200,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing0,
        // The name is announced here, once. The caption over the picture is
        // decoration by the time a screen reader gets this far.
        semanticsLabel: '${item.name}, ${item.album}',
        onPressed: onPressed,
        child: ClipRRect(
          borderRadius: theme.borderRadius(AstryxRadiusToken.container),
          child: Stack(
            children: <Widget>[
              const AstryxAspectRatio(
                ratio: 3 / 2,
                background: AstryxColorToken.backgroundInverted,
                child: Center(
                  // Over a dark ground, `inherit` is the only correct answer —
                  // and inside a media scope it is the colour that scope set.
                  child: AstryxMediaTheme(
                    scrim: AstryxMediaScrim.none,
                    padding: AstryxSpacingToken.spacing0,
                    child: AstryxIcon(
                      AstryxIconName.viewColumns,
                      size: AstryxIconSize.lg,
                    ),
                  ),
                ),
              ),
              // Anything drawn over media goes through `AstryxMediaTheme`: the
              // page's text colour is a guess about a photograph nobody has
              // seen, and the scrim is what makes the guess unnecessary.
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 0,
                end: 0,
                bottom: 0,
                child: AstryxMediaTheme(
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing0_5,
                    children: <Widget>[
                      AstryxText(
                        item.name,
                        color: AstryxTextColor.inherit,
                        maxLines: 1,
                      ),
                      AstryxText(
                        item.meta,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.inherit,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **The wall is a wrapping row of fixed-width tiles, not an AstryxGrid (references/layout.md).** A grid gives every cell in a row the height of the tallest, which means measuring each cell intrinsically — and a pressable tile sits inside the touch-target wrapper, which cannot answer that measurement in touch density. Uniform tiles look identical either way; a grid is right for cells of text and figures, like the dashboard (references/templates.md) tiles.
- **Accessibility:** The tile is one tab stop and announces its name once. The caption over the picture is inside the same card, so a second announcement of the same words would be noise — the card’s `semanticsLabel` is the sentence, and the visible caption is what a sighted reader gets instead.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Mixed gallery

`example/lib/examples/template_media_examples.dart`

A gallery of items at mixed sizes.

```dart
class MixedGalleryTemplate extends StatefulWidget {
  const MixedGalleryTemplate({super.key});

  @override
  State<MixedGalleryTemplate> createState() => _MixedGalleryTemplateState();
}

class _MixedGalleryTemplateState extends State<MixedGalleryTemplate> {
  /// The sizes differ because the pictures do.
  ///
  /// A panorama cropped to a square is a panorama nobody can read, and a
  /// portrait letterboxed into a 16:9 tile is mostly ground. Each item carries
  /// its own ratio and its own width, and the row wraps around them.
  static const List<({Shot shot, double width})> _items =
      <({Shot shot, double width})>[
        (
          shot: (
            name: 'Cold aisle, full length',
            caption: 'Panorama · 8064 × 2268',
            ratio: 32 / 9,
          ),
          width: 420,
        ),
        (
          shot: (
            name: 'Rack 14, door open',
            caption: 'Portrait · 3024 × 4032',
            ratio: 3 / 4,
          ),
          width: 170,
        ),
        (
          shot: (
            name: 'Patch panel B',
            caption: 'Square · 3024 × 3024',
            ratio: 1,
          ),
          width: 200,
        ),
        (
          shot: (
            name: 'Generator test',
            caption: 'Video · 1920 × 1080',
            ratio: 16 / 9,
          ),
          width: 300,
        ),
        (
          shot: (
            name: 'Health check log',
            caption: 'Screenshot · 1440 × 900',
            ratio: 8 / 5,
          ),
          width: 260,
        ),
      ];

  final AstryxOverlayController _viewer = AstryxOverlayController();

  int _index = 0;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  void _open(int index) {
    setState(() => _index = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Site visit', level: 1)),
            AstryxText(
              '${_items.length} items',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // A wrapping row, not an `AstryxGrid`. A grid gives every cell in a row
        // the height of the tallest — which is the whole thing this screen is
        // trying not to do, quite apart from the intrinsic measurement a
        // pressable tile cannot answer in touch density.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.start,
          children: <Widget>[
            for (var i = 0; i < _items.length; i++)
              _MixedTile(
                shot: _items[i].shot,
                width: _items[i].width,
                onPressed: () => _open(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: _viewer,
          initialIndex: _index,
          label: 'Site visit',
          items: <AstryxLightboxItem>[
            for (final item in _items)
              AstryxLightboxItem(
                label: item.shot.name,
                caption: '${item.shot.name} · ${item.shot.caption}',
                // The viewer shows each item at its own ratio too. A gallery
                // that mixes shapes on the wall and squares them in the viewer
                // has lied about one of the two.
                child: SizedBox(
                  width: 640,
                  child: AstryxAspectRatio(
                    ratio: item.shot.ratio,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        item.shot.name,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// One tile, at whatever size and shape its picture asks for.
class _MixedTile extends StatelessWidget {
  const _MixedTile({
    required this.shot,
    required this.width,
    required this.onPressed,
  });

  final Shot shot;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing2,
        semanticsLabel: '${shot.name}, ${shot.caption}',
        onPressed: onPressed,
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing0_5,
          children: <Widget>[
            AstryxText(shot.name, type: AstryxTextType.label, maxLines: 1),
            AstryxText(
              shot.caption,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ],
        ),
        child: AstryxAspectRatio(
          ratio: shot.ratio,
          child: const Center(
            child: AstryxIcon(AstryxIconName.viewColumns),
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **Not an AstryxGrid (references/layout.md).** A grid gives every cell in a row the height of the tallest — which is precisely what this screen exists not to do. (It also measures each cell intrinsically, and a pressable tile sits inside the touch-target wrapper, which cannot answer that measurement in touch density.) A wrapping `AstryxHStack` of fixed-width tiles is the shape.
- **Accessibility:** The tile’s `semanticsLabel` is the name *and* the caption as one sentence: "Cold aisle, full length, Panorama · 8064 × 2268". The size and shape of a picture are facts about it, and on this screen they are the facts the layout is conveying visually — so they have to be conveyed some other way as well.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Side gallery

`example/lib/examples/template_media_examples.dart`

A gallery with the selected item beside the strip.

```dart
class SideGalleryTemplate extends StatefulWidget {
  const SideGalleryTemplate({super.key});

  @override
  State<SideGalleryTemplate> createState() => _SideGalleryTemplateState();
}

class _SideGalleryTemplateState extends State<SideGalleryTemplate> {
  static const List<Shot> _shots = <Shot>[
    (
      name: 'Latency, p95',
      caption: 'Captured 14:02 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Queue depth',
      caption: 'Captured 14:03 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Retries per minute',
      caption: 'Captured 14:06 · scheduler-b',
      ratio: 16 / 9,
    ),
    (
      name: 'Error budget burn',
      caption: 'Captured 14:11 · platform',
      ratio: 16 / 9,
    ),
  ];

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final shot = _shots[_index];

    // One item at a time, with the rest reachable without leaving the screen.
    // This is the shape to reach for when the pictures are *evidence* — the
    // reader is comparing them against each other rather than browsing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(
              child: AstryxHeading('Incident 4102 · evidence', level: 1),
            ),
            AstryxText(
              '${_index + 1} of ${_shots.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final strip = _Strip(
              shots: _shots,
              index: _index,
              vertical: wide,
              onSelected: (index) => setState(() => _index = index),
            );

            final viewer = _Viewer(shot: shot);

            // The strip runs down the trailing edge when there is room for it
            // and across the bottom when there is not. Same widget, same
            // selection — only the axis moves.
            if (!wide) {
              return AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[viewer, strip],
              );
            }

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: viewer),
                SizedBox(width: 132, child: strip),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// The item being looked at, and what is known about it.
class _Viewer extends StatelessWidget {
  const _Viewer({required this.shot});

  final Shot shot;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(shot.name, type: AstryxTextType.label),
          AstryxText(
            shot.caption,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
      child: AstryxAspectRatio(
        ratio: shot.ratio,
        semanticsLabel: shot.name,
        child: Center(
          child: AstryxText(shot.name, color: AstryxTextColor.secondary),
        ),
      ),
    );
  }
}

/// The strip of everything else, in whichever axis fits.
class _Strip extends StatelessWidget {
  const _Strip({
    required this.shots,
    required this.index,
    required this.vertical,
    required this.onSelected,
  });

  final List<Shot> shots;
  final int index;
  final bool vertical;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (var i = 0; i < shots.length; i++)
        // `selected` is what marks the current one, and the thumbnail draws it
        // as a ring rather than a tint — a tint over a picture is a change to
        // the picture.
        AstryxThumbnail(
          label: shots[i].name,
          icon: AstryxIconName.viewColumns,
          ratio: 16 / 9,
          width: vertical ? 116 : 104,
          selected: i == index,
          onPressed: () => onSelected(i),
        ),
    ];

    if (vertical) {
      return AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: tiles,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: tiles,
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** The count — "2 of 4" — is on the page in text, beside the heading. A reader who cannot see which thumbnail has the ring still needs to know where they are in the set, and a selected state alone does not say how many there are.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Product gallery

`example/lib/examples/template_commerce_examples.dart`

A filterable grid of products.

```dart
/// One product on the wall.
typedef Product = ({
  String name,
  String category,
  int price,
  double rating,
  bool inStock,
});

class ProductGalleryTemplate extends StatefulWidget {
  const ProductGalleryTemplate({super.key});

  @override
  State<ProductGalleryTemplate> createState() => _ProductGalleryTemplateState();
}

class _ProductGalleryTemplateState extends State<ProductGalleryTemplate> {
  static const List<Product> _catalogue = <Product>[
    (
      name: 'Trail Runner GTX',
      category: 'Footwear',
      price: 12500,
      rating: 4.6,
      inStock: true,
    ),
    (
      name: 'Fell Shoe 3',
      category: 'Footwear',
      price: 9800,
      rating: 4.2,
      inStock: true,
    ),
    (
      name: 'Approach Mid',
      category: 'Footwear',
      price: 15900,
      rating: 4.8,
      inStock: false,
    ),
    (
      name: 'Windshell 40',
      category: 'Outerwear',
      price: 8400,
      rating: 4.1,
      inStock: true,
    ),
    (
      name: 'Hardshell Pro',
      category: 'Outerwear',
      price: 24000,
      rating: 4.9,
      inStock: true,
    ),
    (
      name: 'Merino Base',
      category: 'Layers',
      price: 5200,
      rating: 4.4,
      inStock: true,
    ),
    (
      name: 'Grid Fleece',
      category: 'Layers',
      price: 6900,
      rating: 4.0,
      inStock: false,
    ),
    (
      name: 'Summit Pack 32',
      category: 'Packs',
      price: 11000,
      rating: 4.5,
      inStock: true,
    ),
  ];

  final TextEditingController _query = TextEditingController();

  Set<String> _categories = <String>{};
  bool _inStockOnly = false;
  (num, num) _priceRange = (0, 250);
  String _sort = 'popular';

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// The wall does not filter itself.
  ///
  /// Filtering here, in the caller, is what lets the empty state tell "nothing
  /// matched" from "nothing to sell" — and those two need different words and
  /// a different way out.
  List<Product> get _results {
    final text = _query.text.trim().toLowerCase();
    final matches = _catalogue.where((product) {
      final inCategory =
          _categories.isEmpty || _categories.contains(product.category);
      final inPrice =
          product.price >= _priceRange.$1 * 100 &&
          product.price <= _priceRange.$2 * 100;
      final matchesText =
          text.isEmpty || product.name.toLowerCase().contains(text);
      return inCategory &&
          inPrice &&
          matchesText &&
          (!_inStockOnly || product.inStock);
    }).toList();

    return matches..sort(switch (_sort) {
      'price_low' => (a, b) => a.price.compareTo(b.price),
      'price_high' => (a, b) => b.price.compareTo(a.price),
      _ => (a, b) => b.rating.compareTo(a.rating),
    });
  }

  void _clear() => setState(() {
    _categories = <String>{};
    _inStockOnly = false;
    _priceRange = (0, 250);
    _query.clear();
  });

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 230,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                const AstryxHeading('Shop', level: 1),
                AstryxText(
                  '${results.length} of ${_catalogue.length} products',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                SizedBox(
                  width: 220,
                  child: AstryxTextInput(
                    controller: _query,
                    label: 'Search products',
                    labelHidden: true,
                    placeholder: 'Search products',
                    showClear: true,
                    size: AstryxInputSize.sm,
                    leading: const AstryxIcon(
                      AstryxIconName.search,
                      size: AstryxIconSize.sm,
                    ),
                  ),
                ),
                // A selector, because it picks a value and shows the current
                // one. A menu would perform an action and report nothing.
                SizedBox(
                  width: 180,
                  child: AstryxSelector<String>(
                    label: 'Sort by',
                    labelHidden: true,
                    value: _sort,
                    size: AstryxInputSize.sm,
                    onChanged: (value) =>
                        setState(() => _sort = value ?? _sort),
                    options: const <AstryxSelectorOption<String>>[
                      AstryxSelectorOption(
                        value: 'popular',
                        label: 'Best rated',
                      ),
                      AstryxSelectorOption(
                        value: 'price_low',
                        label: 'Price: low to high',
                      ),
                      AstryxSelectorOption(
                        value: 'price_high',
                        label: 'Price: high to low',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        panel: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Flexible(child: AstryxHeading('Filters')),
                AstryxButton(
                  label: 'Clear',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: _clear,
                ),
              ],
            ),
            AstryxCheckboxList<String>(
              label: 'Category',
              values: _categories,
              onChanged: (values) => setState(() => _categories = values),
              options: const <AstryxCheckboxOption<String>>[
                AstryxCheckboxOption(value: 'Footwear', label: 'Footwear'),
                AstryxCheckboxOption(value: 'Outerwear', label: 'Outerwear'),
                AstryxCheckboxOption(value: 'Layers', label: 'Layers'),
                AstryxCheckboxOption(value: 'Packs', label: 'Packs'),
              ],
            ),
            AstryxSlider.range(
              label: 'Price',
              values: _priceRange,
              max: 250,
              step: 10,
              formatValue: (value) => '£${value.round()}',
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            // A checkbox, not a switch — but there is no Save button here, so
            // the rule needs saying out loud: this filter *is* applied
            // immediately, and it is a checkbox because it is one of a set of
            // filters rather than a setting of its own.
            AstryxCheckbox(
              label: 'In stock only',
              value: _inStockOnly,
              onChanged: (value) => setState(() => _inStockOnly = value),
            ),
          ],
        ),
        child: results.isEmpty
            ? AstryxEmptyState(
                title: 'Nothing matches those filters',
                description:
                    'Every product is still here — the filters are what is '
                    'hiding them.',
                icon: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.lg,
                ),
                actions: <Widget>[
                  AstryxButton(
                    label: 'Clear filters',
                    variant: AstryxButtonVariant.primary,
                    onPressed: _clear,
                  ),
                ],
              )
            : AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                wrap: true,
                runGap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.start,
                children: <Widget>[
                  for (final product in results) _ProductTile(product: product),
                ],
              ),
      ),
    );
  }
}

/// One product: a picture, a name, a price, and whether it can be bought.
class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing3,
        // One sentence, once. The three lines below are what a sighted reader
        // assembles for themselves; a screen reader is handed the assembled
        // version instead of hearing four separate nodes.
        semanticsLabel:
            '${product.name}, ${money(product.price)}, rated '
            '${product.rating} out of 5'
            '${product.inStock ? '' : ', out of stock'}',
        onPressed: () {},
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxText(product.name, type: AstryxTextType.label, maxLines: 1),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: AstryxText(
                    money(product.price),
                    tabularNumbers: true,
                    maxLines: 1,
                  ),
                ),
                AstryxText(
                  '★ ${product.rating}',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  tabularNumbers: true,
                ),
              ],
            ),
            if (!product.inStock)
              const AstryxBadge(
                'Out of stock',
                variant: AstryxBadgeVariant.warning,
                icon: AstryxIcon(AstryxIconName.warning),
              ),
          ],
        ),
        child: AstryxAspectRatio(
          ratio: 1,
          semanticsLabel: product.name,
          child: const Center(
            child: AstryxIcon(AstryxIconName.viewColumns),
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** A tile carries one `semanticsLabel` — name, price, rating, and "out of stock" when it applies — instead of four separate nodes. Somebody moving through a wall of eight products hears eight sentences rather than thirty-two fragments they have to reassemble.
- **Careful:** **The wall is a wrapping row, not an AstryxGrid (references/layout.md).** Each tile is pressable, and a pressable widget sits inside the touch-target wrapper, which cannot answer the intrinsic measurement a grid row needs in touch density. Uniform tiles look identical either way.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Filter | Control | Because |
| --- | --- | --- |
| Category | AstryxCheckboxList (references/forms.md) | Several at once, all worth seeing. One label and one validation state over the group. |
| Price | `AstryxSlider.range` | Two values that constrain each other. `formatValue` gives both the label and the announcement — a thumb that announces "84" is a thumb about nothing. |
| In stock | AstryxCheckbox (references/forms.md) | One of a set of filters rather than a setting of its own — which is why it is not a switch (references/forms.md), even though it applies immediately. |
| Sort | AstryxSelector (references/forms.md) | Picks a value and shows the current one. A menu (references/overlays.md) performs actions and reports nothing. |

---

## Product detail

`example/lib/examples/template_commerce_examples.dart`

Gallery, price, options, and the add-to-cart action.

```dart
class ProductDetailTemplate extends StatefulWidget {
  const ProductDetailTemplate({super.key});

  @override
  State<ProductDetailTemplate> createState() => _ProductDetailTemplateState();
}

class _ProductDetailTemplateState extends State<ProductDetailTemplate> {
  static const List<String> _shots = <String>[
    'Three-quarter view',
    'Sole detail',
    'Heel counter',
    'In the box',
  ];

  /// Sizes, and the ones nobody can buy today.
  ///
  /// Out of stock is `enabled: false` on the option rather than a missing
  /// option: a size that vanishes leaves the reader wondering whether it ever
  /// existed, and it is the answer to "do you make my size at all".
  static const List<AstryxRadioOption<String>> _sizes =
      <AstryxRadioOption<String>>[
        AstryxRadioOption(value: '8', label: 'UK 8'),
        AstryxRadioOption(value: '9', label: 'UK 9'),
        AstryxRadioOption(
          value: '10',
          label: 'UK 10',
          description: 'Back in stock on 3 September',
          enabled: false,
        ),
        AstryxRadioOption(value: '11', label: 'UK 11'),
      ];

  static const int _price = 12500;

  int _shot = 0;
  String? _size;
  num? _quantity = 1;
  bool _submitted = false;

  final AstryxOverlayController _viewer = AstryxOverlayController();

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  /// Nothing is red until the reader has tried to add to the basket.
  AstryxFieldStatus? get _sizeStatus {
    if (!_submitted || _size != null) return null;
    return const AstryxFieldStatus.error('Choose a size');
  }

  void _add(BuildContext context) {
    setState(() => _submitted = true);
    if (_size == null) return;

    AstryxToastScope.of(context).show(
      AstryxToast(
        message: 'Added $_quantity × Trail Runner GTX, UK $_size to the basket',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing5,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxBreadcrumbs(
          label: 'You are here',
          items: <AstryxBreadcrumb>[
            AstryxBreadcrumb(label: 'Shop', onPressed: () {}),
            AstryxBreadcrumb(label: 'Footwear', onPressed: () {}),
            AstryxBreadcrumb(label: 'Trail', onPressed: () {}),
            const AstryxBreadcrumb(label: 'Trail Runner GTX'),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final media = _Media(
              shots: _shots,
              index: _shot,
              onSelected: (index) => setState(() => _shot = index),
              viewer: _viewer,
            );
            final details = _details(context);

            // One column below 720, because a picture and a form side by side
            // at 300 apiece is two things neither of which can be used.
            if (!wide) {
              return AstryxVStack(
                gap: AstryxSpacingToken.spacing5,
                align: AstryxStackAlign.stretch,
                children: <Widget>[media, details],
              );
            }

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing6,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: media),
                SizedBox(width: 340, child: details),
              ],
            );
          },
        ),
      ],
    );
  }

  /// The half of the screen that is words: what it costs, what to choose, and
  /// the one button that spends money.
  Widget _details(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxHeading('Trail Runner GTX', level: 1),
            // Both rows wrap. A details column is narrow by design, and a
            // price beside a was-price is exactly the pair that stops fitting
            // first — a spreading row here would overflow rather than reflow.
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                // Figures are `tabularNumbers`, and the was-price is a
                // separate node rather than a strikethrough on the same one:
                // a screen reader reading "£125.00 £150.00" with no
                // explanation has said the wrong thing twice.
                AstryxText(
                  money(_price),
                  type: AstryxTextType.large,
                  weight: AstryxTextWeight.semibold,
                  tabularNumbers: true,
                ),
                AstryxText(
                  '${money(15000)} before the discount',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                  tabularNumbers: true,
                ),
              ],
            ),
            const AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              wrap: true,
              runGap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxBadge(
                  'In stock',
                  variant: AstryxBadgeVariant.success,
                  icon: AstryxIcon(AstryxIconName.success),
                ),
                AstryxText(
                  'Free delivery over £50',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ],
        ),
        const AstryxDivider(),
        // Seven options or fewer, and all of them worth seeing at once, so a
        // radio list rather than a selector. A size hidden behind a dropdown
        // is a size the reader has to go looking for.
        AstryxRadioList<String>(
          label: 'Size',
          value: _size,
          status: _sizeStatus,
          required: true,
          orientation: AstryxRadioListOrientation.horizontal,
          onChanged: (value) => setState(() => _size = value),
          options: _sizes,
        ),
        AstryxNumberInput(
          label: 'Quantity',
          value: _quantity,
          min: 1,
          max: 6,
          integerOnly: true,
          width: 140,
          onChanged: (value) => setState(() => _quantity = value),
        ),
        AstryxButton(
          label: 'Add to basket · ${money(_price * (_quantity ?? 1).toInt())}',
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.lg,
          onPressed: () => _add(context),
        ),
        // Everything a reader might want and most will not: collapsed, in one
        // group, so the page below the button stays short enough to end.
        const AstryxCollapsibleGroup(
          children: <AstryxCollapsible>[
            AstryxCollapsible(
              title: 'Details',
              initiallyExpanded: true,
              child: AstryxText(
                'A waterproof trail shoe with a 6 mm drop and a rock plate. '
                'Weighs 284 g in a UK 9.',
              ),
            ),
            AstryxCollapsible(
              title: 'Delivery',
              child: AstryxText(
                'Next working day to the UK if ordered before 3pm. Two to '
                'four days to the EU.',
              ),
            ),
            AstryxCollapsible(
              title: 'Returns',
              child: AstryxText(
                'Sixty days, worn outdoors or not. Return postage is on us.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The half of the screen that is pictures: one large, the rest as a strip.
class _Media extends StatelessWidget {
  const _Media({
    required this.shots,
    required this.index,
    required this.onSelected,
    required this.viewer,
  });

  final List<String> shots;
  final int index;
  final ValueChanged<int> onSelected;
  final AstryxOverlayController viewer;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCard(
          padding: AstryxSpacingToken.spacing0,
          semanticsLabel: '${shots[index]} — open the full-size viewer',
          onPressed: viewer.show,
          child: AstryxAspectRatio(
            ratio: 4 / 3,
            semanticsLabel: shots[index],
            child: Center(
              child: AstryxText(
                shots[index],
                color: AstryxTextColor.secondary,
              ),
            ),
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            for (var i = 0; i < shots.length; i++)
              AstryxThumbnail(
                label: shots[i],
                icon: AstryxIconName.viewColumns,
                width: 76,
                selected: i == index,
                onPressed: () => onSelected(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: viewer,
          initialIndex: index,
          label: 'Trail Runner GTX',
          items: <AstryxLightboxItem>[
            for (final shot in shots)
              AstryxLightboxItem(
                label: shot,
                caption: 'Trail Runner GTX · $shot',
                child: SizedBox(
                  width: 620,
                  child: AstryxAspectRatio(
                    ratio: 4 / 3,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        shot,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** The details below the button are an AstryxCollapsibleGroup (references/overlays.md) rather than three headings and three paragraphs. Everything a reader might want and most will not, collapsed, keeps the page below the primary action short enough to end.
- **Accessibility:** The confirmation is a toast (references/overlays.md) that names what was added and how many — "Added 2 × Trail Runner GTX, UK 9 to the basket". A basket count that silently increments in a corner is a change half the readers of the page will not notice at all.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## AI chat

`example/lib/examples/template_chat_examples.dart`

A full conversation screen: transcript, composer, tool calls, and the empty state before the first turn.

```dart
/// One turn of the conversation this template pretends to have had.
///
/// A record rather than a widget list: the transcript is data, and the widgets
/// are how it is drawn. Swapping the drawing is then a local change.
typedef _Turn = ({
  AstryxChatRole role,
  String text,
  List<AstryxToolCall> calls,
  bool cited,
});

class AiChatTemplate extends StatefulWidget {
  const AiChatTemplate({super.key});

  @override
  State<AiChatTemplate> createState() => _AiChatTemplateState();
}

class _AiChatTemplateState extends State<AiChatTemplate> {
  static const List<_Turn> _conversation = <_Turn>[
    (
      role: AstryxChatRole.user,
      text: 'Why did the 14:02 deploy fail?',
      calls: <AstryxToolCall>[],
      cited: false,
    ),
    (
      role: AstryxChatRole.assistant,
      text: '''
The health check **timed out**. The scheduler took 41 seconds to bind its port
and the check gives up at `30`.

- Three services restarted before the rollback
- The bind is the *real* problem — it used to take four seconds

1. Raise the timeout to 60 seconds to stop the bleeding
2. Look at the migration that ships with this release
''',
      calls: <AstryxToolCall>[
        AstryxToolCall(
          name: 'search_logs',
          summary: 'Searched 412 lines in deploy-log.txt',
          arguments: '{"query": "bind", "limit": 500}',
          result: '{"matches": 3, "first": "14:02:41"}',
        ),
        AstryxToolCall(
          name: 'read_file',
          summary: 'scheduler/health.md',
          result: 'timeout: 30s',
          language: 'yaml',
        ),
      ],
      cited: true,
    ),
  ];

  final TextEditingController _draft = TextEditingController();
  final List<_Turn> _turns = List<_Turn>.of(_conversation);

  bool _generating = false;
  bool _listening = false;
  String _model = 'long';

  /// The prompts the empty state offers, and what a fresh screen starts from.
  static const List<String> _suggestions = <String>[
    'Why did the 14:02 deploy fail?',
    'Which service restarted most this week?',
    'Summarise last night’s on-call',
  ];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _turns.add((
        role: AstryxChatRole.user,
        text: text.trim(),
        calls: <AstryxToolCall>[],
        cited: false,
      ));
      _draft.clear();
      _generating = true;
    });
  }

  /// Stands in for the answer arriving. A real screen appends tokens here.
  void _finish() {
    setState(() {
      _generating = false;
      _turns.add((
        role: AstryxChatRole.assistant,
        text:
            'This example does not actually answer — but this is where the '
            'streamed reply lands.',
        calls: <AstryxToolCall>[],
        cited: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bounded height: the chat layout divides what it is given between the
    // transcript and the composer, and a column hands its child an unbounded
    // height it cannot divide.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        padding: AstryxSpacingToken.spacing0,
        // The transcript owns its own scrolling — it opens at the newest turn
        // and stays there as turns arrive. Two scroll views is one too many.
        scrollable: false,
        header: _ChatHeader(
          turns: _turns.length,
          model: _model,
          onModelChanged: (value) => setState(() => _model = value ?? _model),
          onNew: () => setState(() {
            _turns.clear();
            _generating = false;
          }),
        ),
        child: AstryxChatLayout(
          messages: <Widget>[
            for (final turn in _turns) _turnMessage(turn),
            if (_generating)
              AstryxChatMessage(
                author: 'Assistant',
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    const AstryxSpinner(
                      size: AstryxSpinnerSize.sm,
                      label: 'Thinking',
                    ),
                    AstryxButton(
                      label: 'Skip the wait',
                      variant: AstryxButtonVariant.ghost,
                      size: AstryxButtonSize.sm,
                      onPressed: _finish,
                    ),
                  ],
                ),
              ),
          ],
          empty: AstryxCenter(
            maxWidth: 460,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing4,
              align: AstryxStackAlign.center,
              children: <Widget>[
                const AstryxHeading(
                  'Ask about a deploy',
                  justify: AstryxTextJustify.center,
                ),
                const AstryxText(
                  'Logs, timings and health checks for the last 30 days.',
                  color: AstryxTextColor.secondary,
                  justify: AstryxTextJustify.center,
                ),
                // Suggestions are buttons, not placeholder text: a prompt you
                // have to retype is a prompt nobody uses.
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing2,
                  justify: AstryxStackJustify.center,
                  children: <Widget>[
                    for (final prompt in _suggestions)
                      AstryxButton(
                        label: prompt,
                        size: AstryxButtonSize.sm,
                        onPressed: () => _send(prompt),
                      ),
                  ],
                ),
              ],
            ),
          ),
          composer: AstryxChatComposer(
            controller: _draft,
            generating: _generating,
            placeholder: 'Ask about a deploy, a service or an incident',
            onSubmit: _send,
            onStop: () => setState(() => _generating = false),
            leading: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'Attach a file',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
            trailing: <Widget>[
              AstryxChatDictationButton(
                listening: _listening,
                onStart: () => setState(() => _listening = true),
                onStop: () => setState(() => _listening = false),
              ),
            ],
            footer: const AstryxText(
              'Answers cite the logs they came from. Check anything you are '
              'about to act on.',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ),
        ),
      ),
    );
  }

  /// One turn, drawn according to who said it.
  ///
  /// The user's words are their own — plain text, never markdown, because
  /// rendering what somebody typed changes what they said. The assistant's
  /// answer is markdown, which is the format it arrives in.
  Widget _turnMessage(_Turn turn) {
    if (turn.role == AstryxChatRole.user) {
      return AstryxChatMessage(
        role: AstryxChatRole.user,
        author: 'You',
        child: AstryxText(turn.text),
      );
    }

    return AstryxChatMessage(
      author: 'Assistant',
      timestamp: AstryxTimestamp(
        DateTime.utc(2026, 8, 12, 14, 4),
        format: AstryxTimestampFormat.time,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      actions: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.copy,
          label: 'Copy this answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowUp,
          label: 'Good answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        AstryxIconButton(
          icon: AstryxIconName.arrowDown,
          label: 'Bad answer',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
      footer: turn.calls.isEmpty
          ? null
          : AstryxChatToolCalls(calls: turn.calls),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxMarkdown(turn.text, onLinkPressed: (_) {}),
          if (turn.cited)
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: 'From '),
                  AstryxCitation.span(
                    1,
                    source: 'scheduler/health.md',
                    onPressed: () {},
                  ),
                  const TextSpan(text: ' and '),
                  AstryxCitation.span(
                    2,
                    source: 'deploy-log.txt#L412',
                    onPressed: () {},
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The band above the transcript: which model, and a way out of this thread.
class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.turns,
    required this.model,
    required this.onModelChanged,
    required this.onNew,
  });

  final int turns;
  final String model;
  final ValueChanged<String?> onModelChanged;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              const Flexible(
                child: AstryxHeading('Why did 14:02 fail?', level: 1),
              ),
              AstryxBadge('$turns turns'),
            ],
          ),
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSelector<String>(
              label: 'Model',
              labelHidden: true,
              value: model,
              // A field stretches to whatever it is given, and a hugging row
              // gives it nothing to stretch to — so the width is stated here.
              width: 168,
              size: AstryxInputSize.sm,
              onChanged: onModelChanged,
              options: const <AstryxSelectorOption<String>>[
                AstryxSelectorOption(value: 'fast', label: 'Fast'),
                AstryxSelectorOption(value: 'long', label: 'Long context'),
              ],
            ),
            AstryxButton(
              label: 'New chat',
              size: AstryxButtonSize.sm,
              onPressed: onNew,
            ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** **Bound the height and turn the layout’s scrolling off.** `AstryxChatLayout` divides what it is given between the transcript and the composer, so it needs a bounded height and it owns the scrolling itself. Inside a scrollable AstryxLayout (references/app_shell.md) it would be a scroll view inside a scroll view, and inside a bare column it would be handed an unbounded height it cannot divide.
- **Accessibility:** The per-message actions — copy, good answer, bad answer — are visible at all times and each names *which* answer it acts on. Feedback buttons that appear on hover are feedback no touch user can give.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| State | Shown by | Why |
| --- | --- | --- |
| Nothing said yet | `empty:` on AstryxChatLayout (references/chat.md) | It is the first thing most people see, so it is a slot rather than a blank — and centred, which a transcript could not manage on its own. |
| Waiting for the answer | `generating: true` on the composer | The send button becomes stop. A spinner beside a live send button invites a second request nobody wanted. |
| Answered | AstryxMarkdown (references/chat.md) plus AstryxChatToolCalls (references/chat.md) | The reply arrives as markdown and the work behind it is summarised, collapsed, underneath it. |
| Answered from sources | AstryxCitation (references/chat.md) spans | The marker is a number, but its **name** is the source — a row of bare numerals is a puzzle, not a bibliography. |

---

## AI chat landing

`example/lib/examples/template_chat_examples.dart`

The pre-conversation screen: prompt suggestions and a centred composer.

```dart
/// One offered prompt, and what it is for.
typedef Prompt = ({String group, String label, String text});

class AiChatLandingTemplate extends StatefulWidget {
  const AiChatLandingTemplate({super.key});

  @override
  State<AiChatLandingTemplate> createState() => _AiChatLandingTemplateState();
}

class _AiChatLandingTemplateState extends State<AiChatLandingTemplate> {
  static const List<Prompt> _prompts = <Prompt>[
    (
      group: 'Diagnose',
      label: 'Why did the last deploy fail?',
      text: 'Why did the 14:02 deploy fail?',
    ),
    (
      group: 'Diagnose',
      label: 'What changed before the latency spike?',
      text: 'What changed in the hour before the 13:40 latency spike?',
    ),
    (
      group: 'Summarise',
      label: 'Last night’s on-call',
      text: 'Summarise last night’s on-call in five bullets.',
    ),
    (
      group: 'Summarise',
      label: 'This week’s incidents',
      text: 'Summarise every incident opened this week, worst first.',
    ),
    (
      group: 'Write',
      label: 'Draft a post-mortem',
      text: 'Draft a post-mortem for INC-4102 from the timeline.',
    ),
  ];

  static const List<String> _recent = <String>[
    'Why did 14:02 fail?',
    'Scheduler bind times, last 30 days',
    'Who owns the artifacts service?',
  ];

  final TextEditingController _draft = TextEditingController();

  /// The one turn the conversation has, once it has one.
  String? _asked;

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _asked = text.trim();
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560,
      child: _asked == null ? _landing(context) : _conversation(context),
    );
  }

  /// Before the first turn: the composer is the middle of the page.
  ///
  /// That is the whole difference between this and the `empty:` slot of
  /// [AiChatTemplate]. A slot sits above a composer pinned to the bottom; a
  /// landing puts the composer where the reader is already looking, because
  /// there is no transcript for it to be beneath.
  Widget _landing(BuildContext context) {
    final groups = <String>{for (final prompt in _prompts) prompt.group};

    return SingleChildScrollView(
      child: AstryxCenter(
        maxWidth: 680,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.center,
              children: <Widget>[
                AstryxHeading(
                  'What do you want to know?',
                  level: 1,
                  type: AstryxHeadingType.display3,
                  justify: AstryxTextJustify.center,
                ),
                AstryxText(
                  'Logs, timings and health checks for the last 30 days.',
                  type: AstryxTextType.large,
                  color: AstryxTextColor.secondary,
                  justify: AstryxTextJustify.center,
                ),
              ],
            ),
            // The same widget the conversation ends up using. A landing that
            // drew its own input would be a second field with its own
            // shortcuts, its own send button and its own bugs.
            AstryxChatComposer(
              controller: _draft,
              placeholder: 'Ask about a deploy, a service or an incident',
              label: 'Ask a question',
              onSubmit: _send,
              leading: <Widget>[
                AstryxIconButton(
                  icon: AstryxIconName.copy,
                  label: 'Attach a file',
                  variant: AstryxButtonVariant.ghost,
                  onPressed: () {},
                ),
              ],
              footer: const AstryxText(
                'Answers cite the logs they came from. Check anything you are '
                'about to act on.',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ),
            // Suggestions are grouped, and every one of them is a button that
            // sends itself. A prompt the reader has to retype is a prompt
            // nobody uses; a wall of twelve ungrouped ones is a menu nobody
            // reads.
            for (final group in groups)
              AstryxSection(
                title: group,
                level: 2,
                gap: AstryxSpacingToken.spacing2,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  wrap: true,
                  runGap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    for (final prompt in _prompts.where(
                      (prompt) => prompt.group == group,
                    ))
                      AstryxButton(
                        label: prompt.label,
                        size: AstryxButtonSize.sm,
                        onPressed: () => _send(prompt.text),
                      ),
                  ],
                ),
              ),
            const AstryxDivider(),
            AstryxSection(
              title: 'Recent',
              level: 2,
              gap: AstryxSpacingToken.spacing2,
              child: AstryxList(
                label: 'Recent conversations',
                density: AstryxItemDensity.compact,
                showDividers: true,
                children: <Widget>[
                  for (final thread in _recent)
                    AstryxItem(
                      label: thread,
                      leading: const AstryxIcon(AstryxIconName.clock),
                      trailing: const AstryxIcon(AstryxIconName.chevronRight),
                      onPressed: () => _send(thread),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// After the first turn: the same composer, now pinned under a transcript.
  Widget _conversation(BuildContext context) {
    return AstryxLayout(
      padding: AstryxSpacingToken.spacing0,
      scrollable: false,
      header: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Flexible(child: AstryxHeading('Atlas assistant', level: 1)),
          AstryxButton(
            label: 'New chat',
            size: AstryxButtonSize.sm,
            onPressed: () => setState(() => _asked = null),
          ),
        ],
      ),
      child: AstryxChatLayout(
        messages: <Widget>[
          AstryxChatMessage(
            role: AstryxChatRole.user,
            author: 'You',
            child: AstryxText(_asked!),
          ),
          const AstryxChatMessage(
            author: 'Assistant',
            child: AstryxText(
              'The landing has handed over. From here the screen is the '
              'ai_chat template — same composer, now at the bottom of a '
              'transcript that owns its own scrolling.',
            ),
          ),
        ],
        composer: AstryxChatComposer(
          controller: _draft,
          placeholder: 'Ask a follow-up',
          onSubmit: _send,
        ),
      ),
    );
  }
}
```

**Rules**

- **Note:** **It is the same AstryxChatComposer (references/chat.md) in both states.** A landing that drew its own input would be a second field with its own Enter handling, its own send button, its own disclaimer and its own bugs — and the reader would notice the swap at exactly the moment they pressed Enter.
- **Accessibility:** The composer takes an explicit `label` — "Ask a question" — because its placeholder disappears the moment anything is typed. A field whose only name is its placeholder is a field with no name for exactly the reader who most needs one.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Shell navigation

`example/lib/examples/template_shell_examples.dart`

The application frame with both bars in place: a full-width header and a collapsible rail beside the content.

```dart
class ShellNavTemplate extends StatefulWidget {
  const ShellNavTemplate({super.key});

  @override
  State<ShellNavTemplate> createState() => _ShellNavTemplateState();
}

class _ShellNavTemplateState extends State<ShellNavTemplate> {
  /// One list of destinations. The rail and the bar are containers for it.
  static const List<AstryxNavEntry> _sections = <AstryxNavEntry>[
    AstryxNavItem(
      id: 'deploys',
      label: 'Deploys',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
      trailing: AstryxBadge('3'),
    ),
    AstryxNavItem(
      id: 'incidents',
      label: 'Incidents',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.warning)),
    ),
    AstryxNavItem(
      id: 'services',
      label: 'Services',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
    ),
    AstryxNavDivider(),
    AstryxNavSection(
      label: 'Workspace',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'members',
          label: 'Members',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.check)),
        ),
        AstryxNavItem(
          id: 'billing',
          label: 'Billing',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.clock)),
        ),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'deploys': 'Deploys',
    'incidents': 'Incidents',
    'services': 'Services',
    'members': 'Members',
    'billing': 'Billing',
  };

  String _section = 'deploys';
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    // Two bars and one content column. The shell decides whether the rail sits
    // beside the content or behind a drawer; nothing inside has to know, and
    // the header asks when it needs to.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 720,
        navLabel: 'Sections',
        sidebarWidth: _collapsed ? 72 : 248,
        header: _ShellBar(section: _titles[_section]!),
        sidebar: AstryxSideNav(
          label: 'Sections',
          entries: _sections,
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          collapsed: _collapsed,
          onCollapsedChanged: (value) => setState(() => _collapsed = value),
          header: AstryxNavHeadingMenu(
            label: 'Acme Corp',
            description: 'Production',
            collapsed: _collapsed,
            leading: const AstryxNavIcon(
              AstryxIcon(AstryxIconName.viewColumns),
            ),
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Acme Corp', onSelected: () {}),
              AstryxMenuItem(label: 'Globex', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(label: 'New workspace', onSelected: () {}),
            ],
          ),
          footer: AstryxItem(
            label: 'Ada Lovelace',
            description: _collapsed ? null : 'ada@acme.example',
            leading: const AstryxAvatar(
              name: 'Ada Lovelace',
              size: AstryxAvatarSize.sm,
            ),
            onPressed: () {},
          ),
        ),
        child: AstryxLayout(
          header: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxBreadcrumbs(
                label: 'You are here',
                items: <AstryxBreadcrumb>[
                  AstryxBreadcrumb(label: 'Acme Corp', onPressed: () {}),
                  AstryxBreadcrumb(label: 'Production', onPressed: () {}),
                  AstryxBreadcrumb(label: _titles[_section]!),
                ],
              ),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing3,
                justify: AstryxStackJustify.between,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(child: AstryxHeading(_titles[_section]!, level: 1)),
                  AstryxButton(
                    label: 'New deploy',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'Narrow the window past 720 logical pixels and the rail moves '
                'behind the drawer the menu button opens. Widen it and it '
                'comes back — the content column is the only thing that '
                'changes width.',
              ),
              for (var i = 0; i < 6; i++)
                AstryxCard(
                  child: AstryxHStack(
                    gap: AstryxSpacingToken.spacing3,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: AstryxVStack(
                          gap: AstryxSpacingToken.spacing0_5,
                          children: <Widget>[
                            AstryxText(
                              '${_titles[_section]} #${412 - i}',
                              type: AstryxTextType.label,
                            ),
                            const AstryxText(
                              'main · 11 minutes',
                              type: AstryxTextType.supporting,
                              color: AstryxTextColor.secondary,
                            ),
                          ],
                        ),
                      ),
                      AstryxBadge(
                        i == 0 ? 'Live' : 'Superseded',
                        variant: i == 0
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.neutral,
                        icon: AstryxIcon(
                          i == 0
                              ? AstryxIconName.success
                              : AstryxIconName.clock,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bar across the whole window: identity, global actions, account.
///
/// It is an `AstryxTopNav` rather than a hand-built row because the tabs in it
/// are destinations — and a bar of destinations owns arrow-key traversal, a
/// selected state and the overflow behaviour that comes with it.
class _ShellBar extends StatelessWidget {
  const _ShellBar({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) {
    // The shell knows where the navigation went. A header cannot decide whether
    // to draw a menu button without that, which is why it asks rather than
    // measuring the window a second time.
    final shell = AstryxAppShell.of(context);

    return AstryxTopNav(
      leading: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Atlas', type: AstryxTextType.label),
        ],
      ),
      entries: <AstryxNavEntry>[
        const AstryxNavItem(id: 'app', label: 'Application'),
        AstryxNavItem(
          id: 'docs',
          label: 'Docs',
          panel: AstryxCard(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing2,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                const AstryxHeading('Guides', level: 3),
                AstryxItem(label: 'Getting started', onPressed: () {}),
                AstryxItem(label: 'Deploy pipelines', onPressed: () {}),
                AstryxItem(label: 'On-call rotations', onPressed: () {}),
              ],
            ),
          ),
        ),
        const AstryxNavItem(id: 'status', label: 'Status'),
      ],
      selectedId: 'app',
      onSelected: (_) {},
      actions: <Widget>[
        AstryxIconButton(
          icon: AstryxIconName.search,
          label: 'Search',
          tooltip: 'Search',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
        AstryxDropdownMenu(
          label: 'Account',
          width: 200,
          entries: <AstryxMenuEntry>[
            const AstryxMenuSection('ada@acme.example'),
            AstryxMenuItem(label: 'Preferences', onSelected: () {}),
            AstryxMenuItem(label: 'Sign out', onSelected: () {}),
          ],
          triggerBuilder: (context, controller) => AstryxAvatar(
            name: 'Ada Lovelace',
            size: AstryxAvatarSize.sm,
            semanticsLabel: 'Account — Ada Lovelace',
            onPressed: controller.toggle,
          ),
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** **`compactBelow` is a number, not a breakpoint.** The width at which *your* navigation stops fitting is a fact about your navigation. A global breakpoint table means every screen has to agree about a number none of them chose.
- **Accessibility:** The drawer is a real AstryxOverlay (references/overlays.md): it traps focus, closes on Escape or a press on the scrim, and hands focus back to the button that opened it. A shell that hides navigation without any of that loses keyboard users at the first tap.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

| Layer | Widget | Answers |
| --- | --- | --- |
| Which product area | AstryxTopNav (references/navigation.md) selection | Application, docs, status. |
| Which section of it | AstryxSideNav (references/navigation.md) selection | Deploys, incidents, services. |
| Where in the hierarchy | AstryxBreadcrumbs (references/navigation.md) | Acme Corp › Production › Deploys. The last crumb has no link: a link to the page you are on is how a trail stops telling you where you are. |

---

## Shell with side nav

`example/lib/examples/template_shell_variant_examples.dart`

The shell with a vertical rail only.

```dart
class ShellSideNavTemplate extends StatefulWidget {
  const ShellSideNavTemplate({super.key});

  @override
  State<ShellSideNavTemplate> createState() => _ShellSideNavTemplateState();
}

class _ShellSideNavTemplateState extends State<ShellSideNavTemplate> {
  /// Every destination in the product, down one column.
  ///
  /// A rail is the right container when the list is long enough to need
  /// headings, or deep enough to need indenting — both of which a bar has no
  /// room for. `children` here are indented rows; on an `AstryxTopNav` the same
  /// list would be a menu.
  static const List<AstryxNavEntry> _entries = <AstryxNavEntry>[
    AstryxNavItem(
      id: 'overview',
      label: 'Overview',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
    ),
    AstryxNavItem(
      id: 'runs',
      label: 'Runs',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.arrowUp)),
      trailing: AstryxBadge('12'),
      children: <AstryxNavItem>[
        AstryxNavItem(id: 'runs_queued', label: 'Queued'),
        AstryxNavItem(id: 'runs_failed', label: 'Failed'),
      ],
    ),
    AstryxNavItem(
      id: 'artifacts',
      label: 'Artifacts',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.copy)),
    ),
    AstryxNavDivider(),
    AstryxNavSection(
      label: 'Configuration',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'triggers',
          label: 'Triggers',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.clock)),
        ),
        AstryxNavItem(
          id: 'secrets',
          label: 'Secrets',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.eyeSlash)),
        ),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'overview': 'Overview',
    'runs': 'Runs',
    'runs_queued': 'Queued runs',
    'runs_failed': 'Failed runs',
    'artifacts': 'Artifacts',
    'triggers': 'Triggers',
    'secrets': 'Secrets',
  };

  String _section = 'runs';
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final title = _titles[_section]!;

    // No `header:` on the shell at all. Everything a bar would have carried is
    // in the rail — identity at the top, the account at the bottom — because a
    // full-width band holding only a logo is a band spent on nothing.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 680,
        navLabel: 'Sections',
        sidebarWidth: _collapsed ? 72 : 244,
        sidebar: AstryxSideNav(
          label: 'Sections',
          entries: _entries,
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          collapsed: _collapsed,
          onCollapsedChanged: (value) => setState(() => _collapsed = value),
          header: AstryxNavHeadingMenu(
            label: 'Foundry',
            description: 'acme/platform',
            collapsed: _collapsed,
            leading: const AstryxNavIcon(AstryxIcon(AstryxIconName.wrench)),
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'acme/platform', onSelected: () {}),
              AstryxMenuItem(label: 'acme/website', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(label: 'New project', onSelected: () {}),
            ],
          ),
          footer: AstryxItem(
            label: 'Grace Hopper',
            description: _collapsed ? null : 'grace@acme.example',
            leading: const AstryxAvatar(
              name: 'Grace Hopper',
              size: AstryxAvatarSize.sm,
            ),
            onPressed: () {},
          ),
        ),
        child: AstryxLayout(
          header: _PageHeader(title: title),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'One bar, and it is vertical. Collapse the rail with the '
                'control below the account row, or narrow the window past 680 '
                'logical pixels to send it behind the drawer the menu button '
                'in this page header opens.',
              ),
              for (var i = 0; i < 7; i++)
                AstryxCard(
                  padding: AstryxSpacingToken.spacing3,
                  child: AstryxHStack(
                    gap: AstryxSpacingToken.spacing3,
                    justify: AstryxStackJustify.between,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: AstryxText(
                          '$title · job ${920 - i}',
                          maxLines: 1,
                        ),
                      ),
                      AstryxBadge(
                        i.isEven ? 'Passed' : 'Queued',
                        variant: i.isEven
                            ? AstryxBadgeVariant.success
                            : AstryxBadgeVariant.neutral,
                        icon: AstryxIcon(
                          i.isEven
                              ? AstryxIconName.success
                              : AstryxIconName.clock,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The page's own header — which is where the drawer toggle has to live when
/// the shell has no header of its own.
class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // `AstryxMobileNavToggle` with no `controller` reaches for the enclosing
    // shell's, so this row does not have to know that a drawer exists — only
    // that the shell is compact, which is the shell's answer to give.
    final shell = AstryxAppShell.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              if (shell.compact)
                const AstryxMobileNavToggle(
                  label: 'Open navigation',
                  size: AstryxButtonSize.sm,
                ),
              Flexible(child: AstryxHeading(title, level: 1)),
            ],
          ),
        ),
        AstryxButton(
          label: 'Run pipeline',
          variant: AstryxButtonVariant.primary,
          size: AstryxButtonSize.sm,
          onPressed: () {},
        ),
      ],
    );
  }
}
```

**Rules**

- **Note:** `sidebarWidth` moves with the collapsed state — `_collapsed ? 72 : 244` — because the rail does not decide its own width. The content column is the other half of that decision, and only the shell knows about both.
- **Accessibility:** Collapsing takes the labels off the screen and leaves them in the semantics tree, with a tooltip that shows on **focus as well as hover**. That is the one place this widget set puts anything near a tooltip, and it is allowed only because the name is still announced and still reachable without a pointer.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Shell with top nav

`example/lib/examples/template_shell_variant_examples.dart`

The shell with a horizontal bar only.

```dart
class ShellTopNavTemplate extends StatefulWidget {
  const ShellTopNavTemplate({super.key});

  @override
  State<ShellTopNavTemplate> createState() => _ShellTopNavTemplateState();
}

class _ShellTopNavTemplateState extends State<ShellTopNavTemplate> {
  /// The same entry type as the rail, laid along a row.
  ///
  /// A section becomes a *menu* here rather than a heading: a bar has no room
  /// for a label over a group, and a menu is exactly what holds one.
  static const List<AstryxNavEntry> _entries = <AstryxNavEntry>[
    AstryxNavItem(id: 'inbox', label: 'Inbox', trailing: AstryxBadge('4')),
    AstryxNavItem(id: 'reports', label: 'Reports'),
    AstryxNavSection(
      label: 'Admin',
      items: <AstryxNavItem>[
        AstryxNavItem(id: 'members', label: 'Members'),
        AstryxNavItem(id: 'audit', label: 'Audit log'),
        AstryxNavItem(id: 'billing', label: 'Billing'),
      ],
    ),
  ];

  static const Map<String, String> _titles = <String, String>{
    'inbox': 'Inbox',
    'reports': 'Reports',
    'members': 'Members',
    'audit': 'Audit log',
    'billing': 'Billing',
  };

  String _section = 'inbox';

  @override
  Widget build(BuildContext context) {
    final title = _titles[_section] ?? 'Inbox';

    // No `sidebar:`, so there is no drawer and `compactBelow` has nothing to
    // do — the bar scrolls its own destinations sideways when the window is
    // too narrow for them, and the actions stay pinned at the trailing edge.
    return SizedBox(
      height: 480,
      child: AstryxAppShell(
        header: AstryxTopNav(
          label: 'Areas',
          leading: const AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              AstryxNavIcon(AstryxIcon(AstryxIconName.checkDouble)),
              AstryxText('Ledger', type: AstryxTextType.label),
            ],
          ),
          entries: _entries,
          selectedId: _section,
          onSelected: (id) => setState(() => _section = id),
          actions: <Widget>[
            AstryxIconButton(
              icon: AstryxIconName.search,
              label: 'Search',
              tooltip: 'Search',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
            AstryxDropdownMenu(
              label: 'Account',
              width: 220,
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('grace@acme.example'),
                AstryxMenuItem(label: 'Preferences', onSelected: () {}),
                AstryxMenuItem(label: 'Sign out', onSelected: () {}),
              ],
              triggerBuilder: (context, controller) => AstryxAvatar(
                name: 'Grace Hopper',
                size: AstryxAvatarSize.sm,
                semanticsLabel: 'Account — Grace Hopper',
                onPressed: controller.toggle,
              ),
            ),
          ],
        ),
        child: AstryxLayout(
          maxContentWidth: 900,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(child: AstryxHeading(title, level: 1)),
              AstryxButton(
                label: 'New entry',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxText(
                'Five destinations and no rail. Narrow the window and the bar '
                'scrolls its destinations rather than dropping them: nothing '
                'moves behind a drawer, because there is no drawer to move it '
                'into.',
              ),
              // A second level of navigation, inside the page rather than
              // beside it. This is the affordance a rail would have carried,
              // and it is a tab strip because these are views of one thing
              // rather than places in the product.
              AstryxTabList<String>(
                label: '$title views',
                value: 'open',
                onChanged: (_) {},
                tabs: const <AstryxTab<String>>[
                  AstryxTab(value: 'open', label: 'Open'),
                  AstryxTab(
                    value: 'waiting',
                    label: 'Waiting',
                    badge: AstryxBadge('2'),
                  ),
                  AstryxTab(value: 'done', label: 'Done'),
                ],
              ),
              AstryxList(
                label: title,
                showDividers: true,
                children: <Widget>[
                  for (final entry in const <List<String>>[
                    <String>['Invoice 8841', 'Northwind · £4,800.00'],
                    <String>['Invoice 8840', 'Contoso · £192.00'],
                    <String>['Invoice 8839', 'Initech · £1,250.00'],
                    <String>['Invoice 8838', 'Umbrella · £640.00'],
                  ])
                    AstryxItem(
                      label: entry[0],
                      description: entry[1],
                      leading: const AstryxIcon(AstryxIconName.copy),
                      trailing: const AstryxIcon(AstryxIconName.chevronRight),
                      onPressed: () {},
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Note:** **That is the trade.** A rail can hold twenty destinations and a bar cannot. If the second level of navigation keeps growing, the answer is not a wider bar — it is the rail (references/templates.md), or both (references/templates.md).
- **Accessibility:** The bar carries `label: 'Areas'`, and the account trigger is an AstryxAvatar (references/media.md) with `semanticsLabel: 'Account — Grace Hopper'`. A picture of a person is not a name for the menu behind it, and "Grace Hopper" alone does not say that pressing it opens preferences and sign-out.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Documentation

`example/lib/examples/template_shell_examples.dart`

A docs page: side navigation, a measured content column, and an on-this-page outline that tracks the reader.

```dart
class DocumentationTemplate extends StatefulWidget {
  const DocumentationTemplate({super.key});

  @override
  State<DocumentationTemplate> createState() => _DocumentationTemplateState();
}

class _DocumentationTemplateState extends State<DocumentationTemplate> {
  /// One heading per section, in the order they appear on the page.
  static const List<({String id, String title, String body})> _sections =
      <({String id, String title, String body})>[
        (
          id: 'install',
          title: 'Install',
          body:
              'Add the package, then wrap the application once. Everything '
              'else — the theme, the icons, the localisations, the toast host '
              '— is installed by that one widget.',
        ),
        (
          id: 'configure',
          title: 'Configure',
          body:
              'A pipeline is a file in the repository, not a form in a web '
              'application. The file is the source of truth and the screen is '
              'a view of it, which is why every field here is read-only until '
              'you take the lock.',
        ),
        (
          id: 'deploy',
          title: 'Deploy',
          body:
              'A deploy is a request to make the cluster match a commit. It '
              'is not a script, and nothing about it is ordered by the time '
              'you pressed the button.',
        ),
        (
          id: 'rollback',
          title: 'Roll back',
          body:
              'Rolling back is a deploy of the previous commit, which is why '
              'there is no separate rollback screen: the thing you already '
              'know how to watch is the thing that runs.',
        ),
      ];

  /// The scroll view the anchors live in, and the one the outline tracks.
  final ScrollController _scroll = ScrollController();

  /// A key on each section's heading, so the outline has somewhere to scroll.
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  String _page = 'deploys';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Three columns: the rail says where you are in the site, the outline says
    // where you are on the page, and the body is the only one that scrolls
    // under either of them.
    return SizedBox(
      height: 520,
      child: AstryxAppShell(
        compactBelow: 840,
        navLabel: 'Documentation',
        sidebarWidth: 232,
        header: const _DocsBar(),
        sidebar: AstryxSideNav(
          label: 'Documentation',
          selectedId: _page,
          onSelected: (id) => setState(() => _page = id),
          entries: const <AstryxNavEntry>[
            AstryxNavSection(
              label: 'Getting started',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'install', label: 'Installation'),
                AstryxNavItem(id: 'concepts', label: 'Concepts'),
              ],
            ),
            AstryxNavSection(
              label: 'Guides',
              items: <AstryxNavItem>[
                AstryxNavItem(id: 'deploys', label: 'Deploys'),
                AstryxNavItem(id: 'rollbacks', label: 'Rollbacks'),
                AstryxNavItem(id: 'oncall', label: 'On-call'),
              ],
            ),
          ],
        ),
        child: AstryxLayout(
          // The outline needs the body's scroll position, and the body's
          // scroll view belongs to the layout — so the controller is handed in
          // rather than invented here.
          scrollController: _scroll,
          maxContentWidth: 720,
          panelWidth: 200,
          header: AstryxBreadcrumbs(
            label: 'You are here',
            items: <AstryxBreadcrumb>[
              AstryxBreadcrumb(label: 'Docs', onPressed: () {}),
              AstryxBreadcrumb(label: 'Guides', onPressed: () {}),
              const AstryxBreadcrumb(label: 'Deploys'),
            ],
          ),
          panel: AstryxOutline(
            label: 'On this page',
            controller: _scroll,
            entries: <AstryxOutlineEntry>[
              for (final section in _sections)
                AstryxOutlineEntry(
                  id: section.id,
                  label: section.title,
                  anchor: _anchors[section.id],
                ),
            ],
          ),
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(
                label: 'Concepts',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                leading: const AstryxIcon(
                  AstryxIconName.chevronLeft,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Rollbacks',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                trailing: const AstryxIcon(
                  AstryxIconName.chevronRight,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing6,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              const AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxHeading('Deploys', level: 1),
                  AstryxText(
                    'What a deploy is, how to start one, and what to do when '
                    'it goes wrong.',
                    type: AstryxTextType.large,
                    color: AstryxTextColor.secondary,
                  ),
                ],
              ),
              const AstryxBanner(
                title: 'This guide covers Atlas 4',
                description: 'Atlas 3 pipelines are configured in the console.',
                announce: false,
              ),
              for (final section in _sections)
                AstryxSection(
                  title: section.title,
                  headerKey: _anchors[section.id],
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing3,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      AstryxText(section.body),
                      if (section.id == 'install')
                        const AstryxCodeBlock(
                          'dart pub add astryx_ui',
                          language: 'bash',
                        )
                      else
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(text: 'Run '),
                              AstryxCode.span('atlas ${section.id}'),
                              const TextSpan(text: ', or see '),
                              AstryxLink.span(
                                'the reference',
                                onPressed: () {},
                              ),
                              const TextSpan(text: ' for every flag.'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bar above a documentation site: identity, search, version.
class _DocsBar extends StatelessWidget {
  const _DocsBar();

  @override
  Widget build(BuildContext context) {
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open documentation navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Atlas docs', type: AstryxTextType.label),
          const Spacer(),
          AstryxButton(
            label: 'Search',
            size: AstryxButtonSize.sm,
            leading: const AstryxIcon(
              AstryxIconName.search,
              size: AstryxIconSize.sm,
            ),
            // `mod` is ⌘ on a Mac and Ctrl everywhere else, and the cap says
            // whichever one this platform actually listens for.
            trailing: const AstryxKbd.hotkey(
              AstryxHotkey.mod(LogicalKeyboardKey.keyK),
              size: AstryxKbdSize.sm,
            ),
            onPressed: () {},
          ),
          const AstryxBadge('v4.2'),
        ],
      ),
    );
  }
}
```

**Rules**

- **Note:** **`maxContentWidth: 720`.** Prose is the content here, and a paragraph that runs the width of a monitor is a paragraph nobody finishes. Leave the measure off for a table, which has its own reasons to be wide.
- **Accessibility:** The search control shows its own shortcut with AstryxKbd.hotkey (references/data.md), which resolves to ⌘K on a Mac and Ctrl+K elsewhere — the same `AstryxHotkey` the handler listens for, so the cap cannot claim a chord the application does not answer.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Design documentation

`example/lib/examples/template_docs_examples.dart`

A docs page for a design topic, heavy on specimens.

```dart
/// One row of the specimen wall: a token, and what it is for.
typedef Swatch = ({String name, AstryxColorToken token, String use});

class DocumentationDesignTemplate extends StatefulWidget {
  const DocumentationDesignTemplate({super.key});

  @override
  State<DocumentationDesignTemplate> createState() =>
      _DocumentationDesignTemplateState();
}

class _DocumentationDesignTemplateState
    extends State<DocumentationDesignTemplate> {
  static const List<({String id, String title})> _sections =
      <({String id, String title})>[
        (id: 'roles', title: 'Semantic roles'),
        (id: 'families', title: 'Categorical families'),
        (id: 'pairs', title: 'Text on ground'),
        (id: 'wrong', title: 'What goes wrong'),
      ];

  static const List<Swatch> _roles = <Swatch>[
    (
      name: 'accent',
      token: AstryxColorToken.accent,
      use: 'The one action in a view.',
    ),
    (
      name: 'success',
      token: AstryxColorToken.success,
      use: 'A thing that finished, and finished well.',
    ),
    (
      name: 'warning',
      token: AstryxColorToken.warning,
      use: 'Something the reader should look at before it is a problem.',
    ),
    (
      name: 'error',
      token: AstryxColorToken.error,
      use: 'Something that failed, or will.',
    ),
  ];

  static const List<({String name, AstryxPalette palette})> _families =
      <({String name, AstryxPalette palette})>[
        (name: 'blue', palette: AstryxPalette.blue),
        (name: 'green', palette: AstryxPalette.green),
        (name: 'orange', palette: AstryxPalette.orange),
        (name: 'purple', palette: AstryxPalette.purple),
        (name: 'teal', palette: AstryxPalette.teal),
        (name: 'pink', palette: AstryxPalette.pink),
      ];

  final ScrollController _scroll = ScrollController();

  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A design page is read by looking, so the specimens are the content and
    // the prose is the caption. The measure still applies to the prose — but
    // the specimen wall is allowed to be wider than it, which is why
    // `maxContentWidth` is generous rather than 720.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollController: _scroll,
        maxContentWidth: 840,
        panelWidth: 190,
        header: AstryxBreadcrumbs(
          label: 'You are here',
          items: <AstryxBreadcrumb>[
            AstryxBreadcrumb(label: 'Design', onPressed: () {}),
            AstryxBreadcrumb(label: 'Foundations', onPressed: () {}),
            const AstryxBreadcrumb(label: 'Colour'),
          ],
        ),
        panel: AstryxOutline(
          label: 'On this page',
          controller: _scroll,
          entries: <AstryxOutlineEntry>[
            for (final section in _sections)
              AstryxOutlineEntry(
                id: section.id,
                label: section.title,
                anchor: _anchors[section.id],
              ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHeading('Colour', level: 1),
                AstryxText(
                  'Two systems that look like one: four semantic roles that '
                  'mean something, and ten families that mean nothing at all.',
                  type: AstryxTextType.large,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxSection(
              title: 'Semantic roles',
              description: 'These carry meaning, and there are only four.',
              headerKey: _anchors['roles'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final swatch in _roles) _SwatchRow(swatch: swatch),
                ],
              ),
            ),
            AstryxSection(
              title: 'Categorical families',
              description:
                  'These carry no severity whatever. "The Red team" is a '
                  'name, not a warning.',
              headerKey: _anchors['families'],
              child: AstryxGrid(
                minWidth: 150,
                gap: AstryxSpacingToken.spacing3,
                children: <Widget>[
                  for (final family in _families)
                    AstryxCard(
                      variant: AstryxCardVariant.palette(family.palette),
                      padding: AstryxSpacingToken.spacing3,
                      child: AstryxVStack(
                        gap: AstryxSpacingToken.spacing2,
                        children: <Widget>[
                          AstryxText(
                            family.name,
                            type: AstryxTextType.label,
                          ),
                          AstryxBadge(
                            'Badge',
                            variant: AstryxBadgeVariant.palette(family.palette),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            AstryxSection(
              title: 'Text on ground',
              description:
                  'Every filled surface has a paired foreground. Reaching for '
                  'one without the other is where contrast is lost.',
              headerKey: _anchors['pairs'],
              child: const AstryxCodeBlock('''
final theme = AstryxTheme.of(context);

// Right: the pair.
theme.color(AstryxColorToken.accent);      // ground
theme.color(AstryxColorToken.onAccent);    // text on it

// Wrong: a ground with the page's own text colour on top.
theme.color(AstryxColorToken.accent);
theme.color(AstryxColorToken.textPrimary);''', language: 'dart'),
            ),
            AstryxSection(
              title: 'What goes wrong',
              headerKey: _anchors['wrong'],
              child: const AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxBanner(
                    status: AstryxBannerStatus.warning,
                    title: 'Colour is never the only signal',
                    description:
                        'Every status here is a colour and a glyph and a '
                        'word. In greyscale, or to a colour-blind reader, the '
                        'colour is the part that is gone.',
                    announce: false,
                  ),
                  // A do-and-don't pair, side by side rather than one above the
                  // other: the comparison is the point, and a reader who has to
                  // scroll between the two is not comparing anything.
                  AstryxGrid(
                    minWidth: 240,
                    gap: AstryxSpacingToken.spacing3,
                    children: <Widget>[
                      _SpecimenCard(
                        verdict: 'Do',
                        good: true,
                        caption: 'A glyph, a word, and a colour.',
                        child: AstryxBadge(
                          'Failed',
                          variant: AstryxBadgeVariant.error,
                          icon: AstryxIcon(AstryxIconName.error),
                        ),
                      ),
                      // The dot never paints its label — the string is its
                      // accessible name. Which is the whole demonstration: a
                      // sighted reader gets a red circle and nothing else.
                      _SpecimenCard(
                        verdict: "Don't",
                        good: false,
                        caption: 'A dot, and a reader guessing what red means.',
                        child: AstryxStatusDot(
                          AstryxStatusDotVariant.error,
                          label: 'Failed',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A swatch, its token name, and the sentence saying when to use it.
class _SwatchRow extends StatelessWidget {
  const _SwatchRow({required this.swatch});

  final Swatch swatch;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        // The one place a raw `Container` is right: this *is* the colour, so
        // there is no widget between the token and the reader's eye. It still
        // comes from `theme.color`, which is why the page is correct in all
        // eight themes and both brightnesses.
        Container(
          width: 56,
          height: 40,
          decoration: BoxDecoration(
            color: theme.color(swatch.token),
            borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
            border: Border.all(color: theme.color(AstryxColorToken.border)),
          ),
        ),
        Flexible(
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing0_5,
            children: <Widget>[
              AstryxText(swatch.name, type: AstryxTextType.code),
              AstryxText(
                swatch.use,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One half of a do-and-don't pair.
class _SpecimenCard extends StatelessWidget {
  const _SpecimenCard({
    required this.verdict,
    required this.good,
    required this.caption,
    required this.child,
  });

  final String verdict;
  final bool good;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      header: AstryxBadge(
        verdict,
        variant: good ? AstryxBadgeVariant.success : AstryxBadgeVariant.error,
        icon: AstryxIcon(
          good ? AstryxIconName.success : AstryxIconName.error,
        ),
      ),
      footer: AstryxText(
        caption,
        type: AstryxTextType.supporting,
        color: AstryxTextColor.secondary,
      ),
      child: Align(alignment: AlignmentDirectional.centerStart, child: child),
    );
  }
}
```

**Rules**

- **Careful:** **A hard-coded hex in a design document is worse than no document.** It is right on the day it is written and quietly wrong from the first theme change onward — and the readers most likely to trust it are the ones who cannot check.
- **Accessibility:** Each swatch is named in text beside it, as `AstryxTextType.code`. A colour reference whose entries are distinguished only by their colour is a reference that documents nothing for the reader most likely to be consulting it.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Technical documentation

`example/lib/examples/template_docs_examples.dart`

A docs page for an API, heavy on code and property tables.

```dart
/// One row of the property table.
typedef ApiProperty = ({
  String name,
  String type,
  String fallback,
  String notes,
  bool required,
});

class DocumentationTechnicalTemplate extends StatefulWidget {
  const DocumentationTechnicalTemplate({super.key});

  @override
  State<DocumentationTechnicalTemplate> createState() =>
      _DocumentationTechnicalTemplateState();
}

class _DocumentationTechnicalTemplateState
    extends State<DocumentationTechnicalTemplate> {
  static const List<({String id, String title})> _sections =
      <({String id, String title})>[
        (id: 'usage', title: 'Usage'),
        (id: 'auth', title: 'Authentication'),
        (id: 'properties', title: 'Properties'),
        (id: 'errors', title: 'Errors'),
      ];

  static const List<ApiProperty> _properties = <ApiProperty>[
    (
      name: 'project',
      type: 'String',
      fallback: '—',
      notes: 'The project the run belongs to. Slug, not id.',
      required: true,
    ),
    (
      name: 'ref',
      type: 'String',
      fallback: 'HEAD',
      notes: 'A branch, a tag or a commit.',
      required: false,
    ),
    (
      name: 'variables',
      type: 'Map<String, String>',
      fallback: '{}',
      notes: 'Overrides for the pipeline’s own variables.',
      required: false,
    ),
    (
      name: 'dryRun',
      type: 'bool',
      fallback: 'false',
      notes: 'Validates the request and reports what would run.',
      required: false,
    ),
  ];

  final ScrollController _scroll = ScrollController();

  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    for (final section in _sections) section.id: GlobalKey(),
  };

  /// Which language the usage sample is shown in.
  String _language = 'dart';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  static const Map<String, String> _samples = <String, String>{
    'dart': '''
final run = await foundry.runs.create(
  project: 'acme/platform',
  ref: 'main',
  variables: <String, String>{'TARGET': 'production'},
);

print(run.id);   // run_8f21c4''',
    'curl': r'''
curl https://api.foundry.example/v1/runs \
  -H "Authorization: Bearer $FOUNDRY_TOKEN" \
  -d project=acme/platform \
  -d ref=main''',
  };

  @override
  Widget build(BuildContext context) {
    // Prose is not the content here — code and a property table are, and both
    // want width. `maxContentWidth` is still set, because the *sentences*
    // between them are what a reader loses first when a line runs too long.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollController: _scroll,
        maxContentWidth: 780,
        panelWidth: 190,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxBreadcrumbs(
                label: 'You are here',
                items: <AstryxBreadcrumb>[
                  AstryxBreadcrumb(label: 'API', onPressed: () {}),
                  AstryxBreadcrumb(label: 'Runs', onPressed: () {}),
                  const AstryxBreadcrumb(label: 'Create a run'),
                ],
              ),
            ),
            const AstryxBadge('v1', variant: AstryxBadgeVariant.info),
          ],
        ),
        panel: AstryxOutline(
          label: 'On this page',
          controller: _scroll,
          entries: <AstryxOutlineEntry>[
            for (final section in _sections)
              AstryxOutlineEntry(
                id: section.id,
                label: section.title,
                anchor: _anchors[section.id],
              ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxVStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.stretch,
              children: <Widget>[
                AstryxHeading('Create a run', level: 1),
                // The method and path are the first thing anybody looks for on
                // a reference page, so they are on the page rather than in a
                // code block that has to be read for them.
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxBadge('POST', variant: AstryxBadgeVariant.success),
                    AstryxCode('/v1/runs'),
                    AstryxBadge(
                      'Idempotent',
                      icon: AstryxIcon(AstryxIconName.check),
                      semanticsLabel:
                          'Idempotent — repeating this request is safe',
                    ),
                  ],
                ),
              ],
            ),
            AstryxSection(
              title: 'Usage',
              headerKey: _anchors['usage'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  // The strip reports a value and owns no panel, so which
                  // sample is showing is one field and a lookup. That is what
                  // makes the choice linkable from a route.
                  AstryxTabList<String>(
                    label: 'Language',
                    value: _language,
                    size: AstryxTabSize.sm,
                    onChanged: (value) => setState(() => _language = value),
                    tabs: const <AstryxTab<String>>[
                      AstryxTab(value: 'dart', label: 'Dart'),
                      AstryxTab(value: 'curl', label: 'curl'),
                    ],
                  ),
                  AstryxCodeBlock(
                    _samples[_language]!,
                    language: _language,
                    showLineNumbers: true,
                  ),
                ],
              ),
            ),
            AstryxSection(
              title: 'Authentication',
              headerKey: _anchors['auth'],
              child: Text.rich(
                TextSpan(
                  style: AstryxTheme.of(
                    context,
                  ).textStyle(AstryxTypeRole.body),
                  children: <InlineSpan>[
                    const TextSpan(text: 'Send a project token in '),
                    AstryxCode.span('Authorization'),
                    const TextSpan(text: '. Tokens are issued from '),
                    AstryxLink.span('Settings › Secrets', onPressed: () {}),
                    const TextSpan(
                      text:
                          ' and are scoped to one project — a token for '
                          'another project fails closed rather than falling '
                          'back to read-only.',
                    ),
                  ],
                ),
              ),
            ),
            AstryxSection(
              title: 'Properties',
              headerKey: _anchors['properties'],
              child: AstryxTable<ApiProperty>(
                label: 'Request properties',
                keyOf: (row) => row.name,
                rowLabelOf: (row) => row.name,
                columns: <AstryxTableColumn<ApiProperty>>[
                  AstryxTableColumn<ApiProperty>(
                    id: 'name',
                    header: 'Property',
                    width: const AstryxTableColumnWidth.fixed(150),
                    cellBuilder: (context, row) => AstryxHStack(
                      gap: AstryxSpacingToken.spacing1,
                      children: <Widget>[
                        Flexible(child: AstryxCode(row.name)),
                        if (row.required)
                          const AstryxBadge(
                            'req',
                            variant: AstryxBadgeVariant.warning,
                            semanticsLabel: 'Required',
                          ),
                      ],
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'type',
                    header: 'Type',
                    width: const AstryxTableColumnWidth.fixed(160),
                    cellBuilder: (context, row) => AstryxText(
                      row.type,
                      type: AstryxTextType.code,
                      maxLines: 1,
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'default',
                    header: 'Default',
                    width: const AstryxTableColumnWidth.fixed(90),
                    cellBuilder: (context, row) => AstryxText(
                      row.fallback,
                      type: AstryxTextType.code,
                      maxLines: 1,
                    ),
                  ),
                  AstryxTableColumn<ApiProperty>(
                    id: 'notes',
                    header: 'Notes',
                    cellBuilder: (context, row) =>
                        AstryxText(row.notes, maxLines: 2),
                  ),
                ],
                rows: _properties,
              ),
            ),
            AstryxSection(
              title: 'Errors',
              headerKey: _anchors['errors'],
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  const AstryxBanner(
                    title: 'Every error carries a machine-readable code',
                    description:
                        'Match on the code, never on the message: the message '
                        'is translated and the code is not.',
                    announce: false,
                  ),
                  AstryxList(
                    label: 'Errors',
                    showDividers: true,
                    density: AstryxItemDensity.compact,
                    children: <Widget>[
                      for (final error in const <List<String>>[
                        <String>[
                          '400',
                          'invalid_ref',
                          'The ref does not exist on the project.',
                        ],
                        <String>[
                          '403',
                          'token_scope',
                          'The token belongs to a different project.',
                        ],
                        <String>[
                          '409',
                          'run_in_flight',
                          'A run for this ref is already queued.',
                        ],
                      ])
                        AstryxItem(
                          label: error[1],
                          description: error[2],
                          leading: AstryxBadge(error[0]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **No `truncateTooltip: true` in a table cell.** Deciding whether text is cut off needs the cell’s final width, and a table row is measured before it is laid out — the layout asserts in touch density. `maxLines` on its own is what these cells use; the ellipsis is the signal, and a screen reader gets the whole string either way.
- **Accessibility:** The inline links in the Authentication section are `AstryxLink.span` inside a `Text.rich`, not a button after the paragraph. Flutter has no inline element, and the alternative — a link lifted out of the sentence it belongs to — takes the context with it.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Editor

`example/lib/examples/template_workspace_examples.dart`

A document editor: toolbar, canvas, and an inspector panel.

```dart
class EditorTemplate extends StatefulWidget {
  const EditorTemplate({super.key});

  @override
  State<EditorTemplate> createState() => _EditorTemplateState();
}

class _EditorTemplateState extends State<EditorTemplate> {
  final TextEditingController _title = TextEditingController(
    text: 'Rolling back a deploy',
  );

  final TextEditingController _body = TextEditingController(
    text:
        '# Rolling back\n\n'
        'A rollback is a deploy of the previous commit. There is no separate '
        'rollback screen, because the thing you already know how to watch is '
        'the thing that runs.\n\n'
        'Select a phrase and press **Bold** in the toolbar above.',
  );

  /// Whether the canvas shows the source or the rendered result.
  String _mode = 'write';

  bool _dirty = false;
  String _status = 'draft';
  final Set<String> _tags = <String>{'deploys'};

  @override
  void initState() {
    super.initState();
    _title.addListener(_touch);
    _body.addListener(_touch);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _touch() {
    if (!_dirty) setState(() => _dirty = true);
  }

  /// Wraps the selection in [marker], leaving the caret after it.
  ///
  /// This is the whole of what a toolbar can honestly do over a plain text
  /// field: the package ships no rich-text editing controller, so the document
  /// is its own markup and the buttons are edits to it rather than styling
  /// applied to a hidden model.
  void _wrap(String marker) {
    final value = _body.value;
    final selection = value.selection;
    if (!selection.isValid) return;

    final replaced = '$marker${selection.textInside(value.text)}$marker';
    _body.value = value.copyWith(
      text:
          selection.textBefore(value.text) +
          replaced +
          selection.textAfter(value.text),
      selection: TextSelection.collapsed(
        offset: selection.start + replaced.length,
      ),
      composing: TextRange.empty,
    );
  }

  /// How many words the draft has, for the footer.
  int get _words =>
      _body.text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    // `scrollable: false`: the canvas scrolls itself, and a scroll view inside
    // a scroll view measures unbounded — which is a layout assertion rather
    // than a subtle bug.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollable: false,
        panelWidth: 260,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: AstryxTextInput(
                    controller: _title,
                    label: 'Title',
                    labelHidden: true,
                    size: AstryxInputSize.lg,
                    placeholder: 'Untitled',
                  ),
                ),
                AstryxBadge(
                  _dirty ? 'Unsaved changes' : 'Saved',
                  variant: _dirty
                      ? AstryxBadgeVariant.warning
                      : AstryxBadgeVariant.success,
                  icon: AstryxIcon(
                    _dirty ? AstryxIconName.warning : AstryxIconName.success,
                  ),
                ),
              ],
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                // One tab stop for the whole band, however many controls sit
                // in it. Tab reaches the toolbar and leaves it; the arrows
                // move inside.
                AstryxToolbar(
                  label: 'Formatting',
                  children: <Widget>[
                    for (final mark in const <List<String>>[
                      <String>['Bold', '**'],
                      <String>['Italic', '_'],
                      <String>['Code', '`'],
                    ])
                      AstryxButton(
                        label: mark[0],
                        size: AstryxButtonSize.sm,
                        variant: AstryxButtonVariant.ghost,
                        enabled: _mode == 'write',
                        onPressed: () => _wrap(mark[1]),
                      ),
                    const AstryxToolbarDivider(),
                    AstryxMoreMenu(
                      label: 'More formatting',
                      enabled: _mode == 'write',
                      entries: <AstryxMenuEntry>[
                        AstryxMenuItem(
                          label: 'Strikethrough',
                          onSelected: () => _wrap('~~'),
                        ),
                        AstryxMenuItem(
                          label: 'Quote',
                          onSelected: () => _wrap('\n> '),
                        ),
                      ],
                    ),
                  ],
                ),
                AstryxSegmentedControl<String>(
                  label: 'Canvas',
                  value: _mode,
                  size: AstryxButtonSize.sm,
                  onChanged: (value) => setState(() => _mode = value),
                  segments: const <AstryxSegment<String>>[
                    AstryxSegment(value: 'write', label: 'Write'),
                    AstryxSegment(value: 'preview', label: 'Preview'),
                  ],
                ),
              ],
            ),
          ],
        ),
        panel: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxSection(
              title: 'Document',
              level: 2,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxSelector<String>(
                    label: 'Status',
                    value: _status,
                    onChanged: (value) => setState(() {
                      _status = value ?? _status;
                      _dirty = true;
                    }),
                    options: const <AstryxSelectorOption<String>>[
                      AstryxSelectorOption(value: 'draft', label: 'Draft'),
                      AstryxSelectorOption(value: 'review', label: 'In review'),
                      AstryxSelectorOption(
                        value: 'published',
                        label: 'Published',
                      ),
                    ],
                  ),
                  AstryxCheckboxList(
                    label: 'Tags',
                    values: _tags,
                    onChanged: (values) => setState(() {
                      _tags
                        ..clear()
                        ..addAll(values);
                      _dirty = true;
                    }),
                    options: const <AstryxCheckboxOption<String>>[
                      AstryxCheckboxOption(value: 'deploys', label: 'Deploys'),
                      AstryxCheckboxOption(value: 'oncall', label: 'On-call'),
                      AstryxCheckboxOption(
                        value: 'runbook',
                        label: 'Runbook',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const AstryxDivider(),
            AstryxSection(
              title: 'History',
              level: 2,
              child: AstryxMetadataList(
                items: <AstryxMetadataItem>[
                  AstryxMetadataItem.text(
                    label: 'Created',
                    value: '12 March, by Grace Hopper',
                  ),
                  AstryxMetadataItem.text(
                    label: 'Last edited',
                    value: '4 minutes ago, by you',
                  ),
                  AstryxMetadataItem.text(label: 'Revisions', value: '31'),
                ],
              ),
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxText(
              '$_words words',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            AstryxHStack(
              gap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxButton(
                  label: 'Discard',
                  size: AstryxButtonSize.sm,
                  enabled: _dirty,
                  onPressed: () => setState(() => _dirty = false),
                ),
                AstryxButton(
                  label: 'Save',
                  variant: AstryxButtonVariant.primary,
                  size: AstryxButtonSize.sm,
                  enabled: _dirty,
                  onPressed: () => setState(() => _dirty = false),
                ),
              ],
            ),
          ],
        ),
        // The canvas, and the only thing on the screen that scrolls.
        child: _mode == 'write'
            ? AstryxTextArea(
                controller: _body,
                label: 'Document body',
                labelHidden: true,
                minLines: 12,
                maxLines: 40,
              )
            : SingleChildScrollView(
                child: AstryxMarkdown(_body.text),
              ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **`scrollable: false` on the layout.** The canvas is an AstryxTextArea (references/forms.md) — or, in preview, a scroller of its own. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded, which is a layout assertion rather than a subtle bug.
- **Note:** **Checkboxes and a selector here, because there is a Save button.** Nothing on this screen takes effect until it is pressed, so nothing on it may be an AstryxSwitch (references/forms.md) — a switch would promise it already had. The settings (references/templates.md) template is the other half of that rule.
- **Accessibility:** The dirty state is a badge with an icon and words — *Unsaved changes* or *Saved* — and both footer buttons are `enabled: _dirty`. A disabled Save with no stated reason reads as broken; the badge is what turns it into a state the reader can see and act on.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## File explorer

`example/lib/examples/template_workspace_examples.dart`

A tree of folders beside a list of files.

```dart
/// One file in the listing.
typedef ExplorerFile = ({String name, String kind, String size, String edited});

class FileExplorerTemplate extends StatefulWidget {
  const FileExplorerTemplate({super.key});

  @override
  State<FileExplorerTemplate> createState() => _FileExplorerTemplateState();
}

class _FileExplorerTemplateState extends State<FileExplorerTemplate> {
  static const List<AstryxTreeNode> _folders = <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'workspace',
      label: 'Workspace',
      leading: AstryxIcon(AstryxIconName.viewColumns),
      children: <AstryxTreeNode>[
        AstryxTreeNode(
          id: 'runbooks',
          label: 'Runbooks',
          children: <AstryxTreeNode>[
            AstryxTreeNode(id: 'runbooks_deploys', label: 'Deploys'),
            AstryxTreeNode(id: 'runbooks_oncall', label: 'On-call'),
          ],
        ),
        AstryxTreeNode(
          id: 'postmortems',
          label: 'Post-mortems',
          trailing: AstryxBadge('4'),
        ),
        AstryxTreeNode(id: 'archive', label: 'Archive', enabled: false),
      ],
    ),
    AstryxTreeNode(
      id: 'shared',
      label: 'Shared with me',
      leading: AstryxIcon(AstryxIconName.checkDouble),
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'shared_sre', label: 'SRE'),
        AstryxTreeNode(id: 'shared_security', label: 'Security'),
      ],
    ),
  ];

  static const Map<String, List<ExplorerFile>> _contents =
      <String, List<ExplorerFile>>{
        'runbooks_deploys': <ExplorerFile>[
          (
            name: 'rollback.md',
            kind: 'Markdown',
            size: '4.2 kB',
            edited: '11 minutes ago',
          ),
          (
            name: 'canary.md',
            kind: 'Markdown',
            size: '8.9 kB',
            edited: 'Yesterday',
          ),
          (
            name: 'pipeline.yaml',
            kind: 'YAML',
            size: '1.1 kB',
            edited: '3 days ago',
          ),
        ],
        'runbooks_oncall': <ExplorerFile>[
          (
            name: 'escalation.md',
            kind: 'Markdown',
            size: '2.4 kB',
            edited: 'Last week',
          ),
          (
            name: 'rota-2026.csv',
            kind: 'CSV',
            size: '19 kB',
            edited: 'Last week',
          ),
        ],
        'postmortems': <ExplorerFile>[
          (
            name: '4102-latency.md',
            kind: 'Markdown',
            size: '22 kB',
            edited: '2 hours ago',
          ),
        ],
      };

  static const Map<String, String> _names = <String, String>{
    'workspace': 'Workspace',
    'runbooks': 'Runbooks',
    'runbooks_deploys': 'Deploys',
    'runbooks_oncall': 'On-call',
    'postmortems': 'Post-mortems',
    'shared': 'Shared with me',
    'shared_sre': 'SRE',
    'shared_security': 'Security',
  };

  String _folder = 'runbooks_deploys';
  Set<Object> _selected = <Object>{};

  List<ExplorerFile> get _files => _contents[_folder] ?? const <ExplorerFile>[];

  @override
  Widget build(BuildContext context) {
    final files = _files;

    return SizedBox(
      height: 520,
      child: AstryxLayout(
        scrollable: false,
        // The tree is at the reading-start edge, because it is where the
        // reader came *from* rather than what they are looking at.
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 240,
        header: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          wrap: true,
          runGap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading(_names[_folder] ?? 'Files', level: 1),
                AstryxText(
                  '${files.length} items',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
            AstryxButton(
              label: 'Upload',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        // The tree is one tab stop and the arrows do the rest: Right opens a
        // branch and steps into it, Left closes it and steps out.
        panel: AstryxTreeList(
          label: 'Folders',
          nodes: _folders,
          initiallyExpanded: const <String>{'workspace', 'runbooks'},
          density: AstryxItemDensity.compact,
          selected: _folder,
          onSelectedChanged: (id) => setState(() {
            _folder = id;
            _selected = <Object>{};
          }),
        ),
        child: AstryxTable<ExplorerFile>(
          label: 'Files in ${_names[_folder]}',
          keyOf: (row) => row.name,
          rowLabelOf: (row) => row.name,
          density: AstryxTableDensity.compact,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          onRowPressed: (_) {},
          maxHeight: 340,
          emptyState: AstryxEmptyState(
            title: 'Nothing in this folder',
            description: 'Drop a file here, or pick another folder.',
            size: AstryxEmptyStateSize.compact,
            actions: <Widget>[
              AstryxButton(
                label: 'Upload',
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
          columns: <AstryxTableColumn<ExplorerFile>>[
            AstryxTableColumn<ExplorerFile>(
              id: 'name',
              header: 'Name',
              compare: (a, b) => a.name.compareTo(b.name),
              cellBuilder: (context, row) => AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  const AstryxIcon(AstryxIconName.copy),
                  Flexible(child: AstryxText(row.name, maxLines: 1)),
                ],
              ),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'kind',
              header: 'Kind',
              width: const AstryxTableColumnWidth.fixed(110),
              cellBuilder: (context, row) => AstryxBadge(row.kind),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'size',
              header: 'Size',
              width: const AstryxTableColumnWidth.fixed(90),
              alignment: AstryxTableAlignment.end,
              cellBuilder: (context, row) =>
                  AstryxText(row.size, tabularNumbers: true, maxLines: 1),
            ),
            AstryxTableColumn<ExplorerFile>(
              id: 'edited',
              header: 'Edited',
              width: const AstryxTableColumnWidth.fixed(130),
              cellBuilder: (context, row) => AstryxText(
                row.edited,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ),
          ],
          rows: files,
          // Always visible, never on hover: touch has no hover, and the
          // density system suppresses hover styling there.
          rowActionsBuilder: (context, row) => AstryxMoreMenu(
            label: 'Actions for ${row.name}',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Rename', onSelected: () {}),
              AstryxMenuItem(label: 'Download', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Delete',
                destructive: true,
                onSelected: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Rules**

- **Careful:** **Row actions are always visible.** The overflow menu on each file is an AstryxMoreMenu (references/navigation.md) named for *that* file — "Actions for rollback.md". Hover does not exist on touch, and the density system actively suppresses hover styling there, so a menu that appears under a pointer is a menu half the readers do not have.
- **Accessibility:** `rowLabelOf` names each row’s checkbox with the file’s own name. Without it every checkbox in the table announces "Select row", which is true of all of them and therefore tells a screen-reader user nothing about which one they are ticking.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## IDE

`example/lib/examples/template_workspace_examples.dart`

A code workspace: file tree, tabbed editors, and a panel.

```dart
class IdeTemplate extends StatefulWidget {
  const IdeTemplate({super.key});

  @override
  State<IdeTemplate> createState() => _IdeTemplateState();
}

class _IdeTemplateState extends State<IdeTemplate> {
  static const List<AstryxTreeNode> _tree = <AstryxTreeNode>[
    AstryxTreeNode(
      id: 'lib',
      label: 'lib',
      children: <AstryxTreeNode>[
        AstryxTreeNode(
          id: 'components',
          label: 'components',
          children: <AstryxTreeNode>[
            AstryxTreeNode(id: 'card.dart', label: 'card.dart'),
            AstryxTreeNode(
              id: 'table.dart',
              label: 'table.dart',
              trailing: AstryxStatusDot(
                AstryxStatusDotVariant.warning,
                label: '2 problems',
              ),
            ),
          ],
        ),
        AstryxTreeNode(id: 'astryx_ui.dart', label: 'astryx_ui.dart'),
      ],
    ),
    AstryxTreeNode(
      id: 'test',
      label: 'test',
      children: <AstryxTreeNode>[
        AstryxTreeNode(id: 'table_test.dart', label: 'table_test.dart'),
      ],
    ),
  ];

  static const Map<String, String> _sources = <String, String>{
    'card.dart': '''
class AstryxCard extends StatelessWidget {
  const AstryxCard({
    required this.child,
    this.header,
    this.footer,
    this.onPressed,
  });

  /// A non-null [onPressed] makes the whole card a button.
  final VoidCallback? onPressed;
}''',
    'table.dart': '''
/// A column is sortable when — and only when — it has a [compare].
class AstryxTableColumn<T> {
  const AstryxTableColumn({
    required this.id,
    required this.header,
    required this.cellBuilder,
    this.compare,
  });

  final int Function(T a, T b)? compare;
}''',
    'table_test.dart': '''
void main() {
  testWidgets('a column without compare is not sortable', (tester) async {
    await tester.pumpWidget(const _Harness());
    expect(find.byIcon(AstryxIconName.arrowsUpDown), findsNothing);
  });
}''',
  };

  /// The files with an editor open, in the order they were opened.
  final List<String> _open = <String>['card.dart', 'table.dart'];

  String _file = 'table.dart';
  String _drawer = 'problems';

  /// The two regions the reader may resize.
  ///
  /// A handle reports a size; the caller is what remembers it.
  double _treeWidth = 200;
  double _drawerHeight = 132;

  @override
  Widget build(BuildContext context) {
    // A bare `Column`, not an `AstryxCard`. A card sizes itself to its body,
    // so it hands that body an unbounded height — and every region here is an
    // `Expanded` or a fixed band measured against the frame. The bounded
    // `SizedBox` is what the whole layout is built against.
    return SizedBox(
      height: 520,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: _treeWidth,
                  child: AstryxVStack(
                    gap: AstryxSpacingToken.spacing0,
                    align: AstryxStackAlign.stretch,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: AstryxText(
                          'Explorer',
                          type: AstryxTextType.supporting,
                          color: AstryxTextColor.secondary,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: AstryxTreeList(
                            label: 'Files',
                            nodes: _tree,
                            initiallyExpanded: const <String>{
                              'lib',
                              'components',
                            },
                            density: AstryxItemDensity.compact,
                            selected: _file,
                            onSelectedChanged: _openFile,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab reaches the handle and the arrows move it. A divider
                // only a pointer can drag is a layout only some people can
                // use, which is the part hand-rolled splitters always miss.
                AstryxResizeHandle(
                  label: 'Resize the file tree',
                  size: _treeWidth,
                  min: 140,
                  max: 320,
                  onResize: (width) => setState(() => _treeWidth = width),
                ),
                Expanded(child: _editor(context)),
              ],
            ),
          ),
          AstryxResizeHandle(
            label: 'Resize the panel',
            edge: AstryxResizeEdge.bottom,
            size: _drawerHeight,
            min: 80,
            max: 260,
            onResize: (height) => setState(() => _drawerHeight = height),
          ),
          SizedBox(height: _drawerHeight, child: _panel(context)),
          const AstryxDivider(),
          _statusBar(context),
        ],
      ),
    );
  }

  /// Opens [id] in a tab, if it is a file rather than a folder.
  void _openFile(String id) {
    if (!_sources.containsKey(id)) return;
    setState(() {
      if (!_open.contains(id)) _open.add(id);
      _file = id;
    });
  }

  /// The tab strip and the surface under it.
  Widget _editor(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        // The strip reports a value and owns no panel, so which file is showing
        // is one field of state — and closing a tab is a list edit, not a
        // panel-stack surgery.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing1,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: AstryxTabList<String>(
                label: 'Open files',
                value: _file,
                size: AstryxTabSize.sm,
                onChanged: (value) => setState(() => _file = value),
                tabs: <AstryxTab<String>>[
                  for (final file in _open) AstryxTab(value: file, label: file),
                ],
              ),
            ),
            AstryxMoreMenu(
              label: 'Editor actions',
              entries: <AstryxMenuEntry>[
                AstryxMenuItem(
                  label: 'Close $_file',
                  onSelected: () => setState(() {
                    _open.remove(_file);
                    _file = _open.isEmpty ? '' : _open.last;
                  }),
                ),
                AstryxMenuItem(
                  label: 'Close all',
                  onSelected: () => setState(() {
                    _open.clear();
                    _file = '';
                  }),
                ),
              ],
            ),
          ],
        ),
        // The surface scrolls rather than being squeezed: a code block handed a
        // tight height has nowhere to put the lines that do not fit.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: _open.isEmpty
                ? const AstryxEmptyState(
                    title: 'No file open',
                    description: 'Choose one from the tree on the left.',
                    size: AstryxEmptyStateSize.compact,
                  )
                : AstryxCodeBlock(
                    _sources[_file] ?? '',
                    language: 'dart',
                    showLineNumbers: true,
                  ),
          ),
        ),
      ],
    );
  }

  /// The drawer under the editor: problems, or the run log.
  Widget _panel(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Panel',
          value: _drawer,
          size: AstryxTabSize.sm,
          onChanged: (value) => setState(() => _drawer = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(
              value: 'problems',
              label: 'Problems',
              badge: AstryxBadge('2'),
            ),
            AstryxTab(value: 'output', label: 'Output'),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: _drawer == 'problems'
                ? AstryxList(
                    label: 'Problems',
                    density: AstryxItemDensity.compact,
                    children: <Widget>[
                      for (final problem in const <List<String>>[
                        <String>[
                          'table.dart:41',
                          'Unused import: dart:math',
                        ],
                        <String>[
                          'table.dart:88',
                          'compare is null, so this column is not sortable',
                        ],
                      ])
                        AstryxItem(
                          label: problem[1],
                          description: problem[0],
                          leading: const AstryxIcon(
                            AstryxIconName.warning,
                            color: AstryxIconColor.warning,
                          ),
                          onPressed: () {},
                        ),
                    ],
                  )
                : const AstryxCodeBlock(
                    '\$ dart test\n'
                    '00:02 +14: All tests passed!',
                    showCopy: false,
                  ),
          ),
        ),
      ],
    );
  }

  /// The band along the bottom: branch, problems, and where the caret is.
  Widget _statusBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const AstryxStatusDot(
            AstryxStatusDotVariant.success,
            label: 'Analyser is clean',
          ),
          const AstryxText(
            'main',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
          const Spacer(),
          const AstryxText(
            'Ln 41, Col 12',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            tabularNumbers: true,
          ),
          AstryxText(
            _file.isEmpty ? '—' : 'Dart',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```

**Rules**

- **Accessibility:** **Tab reaches a handle and the arrow keys move it**, with Home and End at `min` and `max`. It announces itself as a slider carrying the current size, and `label` is required because nothing is painted on a handle. A divider only a pointer can drag is a layout only some people can use — the part hand-rolled splitters almost always miss.
- **Careful:** **A bare `Column`, not an AstryxCard (references/surfaces.md).** A card sizes itself to its body, so it hands that body an unbounded height — and every region here is either an `Expanded` or a band measured against the frame. The bounded `SizedBox` is what the whole layout is built against; put a card around it and nothing inside can be laid out at all.
- **Careful:** **The editor surface is an AstryxCodeBlock (references/data.md), which is read-only and does no highlighting.** A code editor is a text control with a language server behind it, and this package does not ship one. Everything around it — the tree, the tabs, the drawer, the handles, the status bar — is real; the box in the middle is where your editor goes.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Library

`example/lib/examples/template_split_examples.dart`

A browsable collection with filters beside the results.

```dart
/// One asset in the library.
typedef Asset = ({
  String id,
  String name,
  String collection,
  String kind,
  String size,
  String added,
});

class LibraryTemplate extends StatefulWidget {
  const LibraryTemplate({super.key});

  @override
  State<LibraryTemplate> createState() => _LibraryTemplateState();
}

class _LibraryTemplateState extends State<LibraryTemplate> {
  static const List<Asset> _assets = <Asset>[
    (
      id: 'a1',
      name: 'Runbook cover',
      collection: 'Brand',
      kind: 'Image',
      size: '2.4 MB',
      added: '11 minutes ago',
    ),
    (
      id: 'a2',
      name: 'Wordmark, dark',
      collection: 'Brand',
      kind: 'Vector',
      size: '18 kB',
      added: 'Yesterday',
    ),
    (
      id: 'a3',
      name: 'Incident 4102 timeline',
      collection: 'Incidents',
      kind: 'Image',
      size: '5.1 MB',
      added: '2 days ago',
    ),
    (
      id: 'a4',
      name: 'Scheduler diagram',
      collection: 'Architecture',
      kind: 'Vector',
      size: '96 kB',
      added: '2 days ago',
    ),
    (
      id: 'a5',
      name: 'Fleet map',
      collection: 'Architecture',
      kind: 'Image',
      size: '3.8 MB',
      added: 'Last week',
    ),
    (
      id: 'a6',
      name: 'On-call rota, Q3',
      collection: 'Operations',
      kind: 'Document',
      size: '212 kB',
      added: 'Last week',
    ),
    (
      id: 'a7',
      name: 'Post-mortem template',
      collection: 'Operations',
      kind: 'Document',
      size: '44 kB',
      added: 'Last month',
    ),
  ];

  final TextEditingController _query = TextEditingController();

  Set<String> _kinds = <String>{};
  String _collection = 'All';
  String _view = 'grid';
  final Set<Object> _selected = <Object>{};

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Narrowed in the caller, so an empty result can say which of the two
  /// nothings it is: nothing matched, or nothing here yet.
  List<Asset> get _shown {
    final text = _query.text.trim().toLowerCase();
    return _assets
        .where(
          (asset) =>
              (_collection == 'All' || asset.collection == _collection) &&
              (_kinds.isEmpty || _kinds.contains(asset.kind)) &&
              (text.isEmpty || asset.name.toLowerCase().contains(text)),
        )
        .toList();
  }

  /// How many assets a collection holds, for the count beside its row.
  int _countIn(String collection) => collection == 'All'
      ? _assets.length
      : _assets.where((asset) => asset.collection == collection).length;

  void _toggle(String id, {required bool selected}) => setState(() {
    if (selected) {
      _selected.add(id);
    } else {
      _selected.remove(id);
    }
  });

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return SizedBox(
      height: 620,
      child: AstryxLayout(
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 210,
        header: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              justify: AstryxStackJustify.between,
              mainAxisSize: MainAxisSize.max,
              wrap: true,
              runGap: AstryxSpacingToken.spacing2,
              children: <Widget>[
                AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    const AstryxHeading('Library', level: 1),
                    AstryxText(
                      '${shown.length} of ${_assets.length} assets',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
                AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    SizedBox(
                      width: 200,
                      child: AstryxTextInput(
                        controller: _query,
                        label: 'Search the library',
                        labelHidden: true,
                        placeholder: 'Search',
                        showClear: true,
                        size: AstryxInputSize.sm,
                        leading: const AstryxIcon(
                          AstryxIconName.search,
                          size: AstryxIconSize.sm,
                        ),
                      ),
                    ),
                    // Two ways of looking at one set, so a segmented control:
                    // it announces itself as a radio group, and the arrows
                    // both move and choose.
                    AstryxSegmentedControl<String>(
                      label: 'View',
                      value: _view,
                      size: AstryxButtonSize.sm,
                      onChanged: (value) => setState(() => _view = value),
                      segments: const <AstryxSegment<String>>[
                        AstryxSegment(
                          value: 'grid',
                          label: 'Grid',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.viewColumns),
                        ),
                        AstryxSegment(
                          value: 'list',
                          label: 'List',
                          labelHidden: true,
                          icon: AstryxIcon(AstryxIconName.menu),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // The selection bar appears only once something is ticked, and it
            // says how many. "Delete" with no count is a question nobody can
            // answer.
            if (_selected.isNotEmpty)
              AstryxBanner(
                title: '${_selected.length} selected',
                announce: false,
                actions: <Widget>[
                  AstryxButton(
                    label: 'Download',
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  AstryxButton(
                    label: 'Remove',
                    variant: AstryxButtonVariant.destructive,
                    size: AstryxButtonSize.sm,
                    onPressed: () => setState(_selected.clear),
                  ),
                ],
              ),
          ],
        ),
        panel: AstryxVStack(
          gap: AstryxSpacingToken.spacing5,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            AstryxSection(
              title: 'Collections',
              level: 2,
              child: AstryxList(
                label: 'Collections',
                density: AstryxItemDensity.compact,
                children: <Widget>[
                  for (final collection in const <String>[
                    'All',
                    'Brand',
                    'Incidents',
                    'Architecture',
                    'Operations',
                  ])
                    AstryxItem(
                      label: collection,
                      selected: _collection == collection,
                      trailing: AstryxText(
                        '${_countIn(collection)}',
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.secondary,
                      ),
                      onPressed: () => setState(() => _collection = collection),
                    ),
                ],
              ),
            ),
            const AstryxDivider(),
            AstryxCheckboxList<String>(
              label: 'Kind',
              values: _kinds,
              onChanged: (values) => setState(() => _kinds = values),
              options: const <AstryxCheckboxOption<String>>[
                AstryxCheckboxOption(value: 'Image', label: 'Image'),
                AstryxCheckboxOption(value: 'Vector', label: 'Vector'),
                AstryxCheckboxOption(value: 'Document', label: 'Document'),
              ],
            ),
          ],
        ),
        child: shown.isEmpty
            ? AstryxEmptyState(
                title: 'Nothing matches',
                description:
                    'Seven assets are still here; the filters are what is '
                    'hiding them.',
                icon: const AstryxIcon(
                  AstryxIconName.funnel,
                  size: AstryxIconSize.lg,
                ),
                actions: <Widget>[
                  AstryxButton(
                    label: 'Clear filters',
                    variant: AstryxButtonVariant.primary,
                    onPressed: () => setState(() {
                      _kinds = <String>{};
                      _collection = 'All';
                      _query.clear();
                    }),
                  ),
                ],
              )
            : _view == 'grid'
            ? _grid(shown)
            : _list(shown),
      ),
    );
  }

  /// The wall: a selectable card per asset.
  ///
  /// `AstryxSelectableCard` rather than a pressable card with a checkbox on
  /// it: this is a *control* that reports a selection, and it announces itself
  /// as a checkbox rather than as a button that happens to tick something.
  Widget _grid(List<Asset> shown) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (final asset in shown)
          SizedBox(
            width: 200,
            child: AstryxSelectableCard(
              label: asset.name,
              semanticsHint: '${asset.kind}, ${asset.size}',
              selected: _selected.contains(asset.id),
              padding: AstryxSpacingToken.spacing3,
              onSelectedChanged: (value) => _toggle(asset.id, selected: value),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxAspectRatio(
                    ratio: 4 / 3,
                    semanticsLabel: asset.name,
                    child: const Center(
                      child: AstryxIcon(AstryxIconName.viewColumns),
                    ),
                  ),
                  AstryxText(
                    asset.name,
                    type: AstryxTextType.label,
                    maxLines: 1,
                  ),
                  AstryxText(
                    '${asset.kind} · ${asset.size}',
                    type: AstryxTextType.supporting,
                    color: AstryxTextColor.secondary,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// The same set, and the same selection, as rows.
  Widget _list(List<Asset> shown) {
    return AstryxTable<Asset>(
      label: 'Assets',
      keyOf: (row) => row.id,
      rowLabelOf: (row) => row.name,
      density: AstryxTableDensity.compact,
      selectionMode: AstryxTableSelectionMode.multiple,
      selected: _selected,
      onSelectionChanged: (value) => setState(() {
        _selected
          ..clear()
          ..addAll(value);
      }),
      columns: <AstryxTableColumn<Asset>>[
        AstryxTableColumn<Asset>(
          id: 'name',
          header: 'Name',
          compare: (a, b) => a.name.compareTo(b.name),
          cellBuilder: (context, row) => AstryxText(row.name, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'collection',
          header: 'Collection',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxBadge(row.collection),
        ),
        AstryxTableColumn<Asset>(
          id: 'kind',
          header: 'Kind',
          width: const AstryxTableColumnWidth.fixed(100),
          cellBuilder: (context, row) => AstryxText(row.kind, maxLines: 1),
        ),
        AstryxTableColumn<Asset>(
          id: 'added',
          header: 'Added',
          width: const AstryxTableColumnWidth.fixed(130),
          cellBuilder: (context, row) => AstryxText(
            row.added,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
            maxLines: 1,
          ),
        ),
      ],
      rows: shown,
    );
  }
}
```

**Rules**

- **Note:** **The selection bar appears only once something is ticked, and it says how many.** "Remove" with no count is a question the reader cannot answer, and it is the one destructive control on the screen.
- **Accessibility:** Every asset is announced as its name plus a `semanticsHint` carrying the kind and the size. In the grid those two facts are a line of small grey text; in the list they are columns. The announcement is the same either way, which is what "two views of one set" has to mean.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Messaging shell

`example/lib/examples/template_split_examples.dart`

A conversation list beside the open conversation.

```dart
/// One conversation in the list.
typedef Thread = ({
  String id,
  String name,
  String preview,
  int unread,
  bool online,
});

/// One message in a thread.
typedef Line = ({bool mine, String text, String at});

class MessagingShellTemplate extends StatefulWidget {
  const MessagingShellTemplate({super.key});

  @override
  State<MessagingShellTemplate> createState() => _MessagingShellTemplateState();
}

class _MessagingShellTemplateState extends State<MessagingShellTemplate> {
  static const List<Thread> _threads = <Thread>[
    (
      id: 'sre',
      name: 'Ada Lovelace',
      preview: 'The bind is still taking 40 seconds.',
      unread: 2,
      online: true,
    ),
    (
      id: 'grace',
      name: 'Grace Hopper',
      preview: 'Merged — thanks for the review.',
      unread: 0,
      online: true,
    ),
    (
      id: 'oncall',
      name: 'On-call, Europe',
      preview: 'Rota swapped for Thursday.',
      unread: 5,
      online: false,
    ),
    (
      id: 'alan',
      name: 'Alan Turing',
      preview: 'Can you look at 4102 when you get a minute?',
      unread: 0,
      online: false,
    ),
  ];

  static const Map<String, List<Line>> _messages = <String, List<Line>>{
    'sre': <Line>[
      (
        mine: false,
        text: 'The 14:02 deploy rolled back again.',
        at: '13:58',
      ),
      (
        mine: true,
        text: 'Health check or the migration?',
        at: '14:01',
      ),
      (
        mine: false,
        text:
            'Health check. The bind is still taking 40 seconds and the check '
            'gives up at 30.',
        at: '14:03',
      ),
    ],
    'grace': <Line>[
      (mine: false, text: 'Merged — thanks for the review.', at: '09:12'),
    ],
    'oncall': <Line>[
      (mine: false, text: 'Rota swapped for Thursday.', at: 'Yesterday'),
    ],
    'alan': <Line>[
      (
        mine: false,
        text: 'Can you look at 4102 when you get a minute?',
        at: 'Monday',
      ),
    ],
  };

  final TextEditingController _draft = TextEditingController();
  final List<Line> _extra = <Line>[];

  String _thread = 'sre';

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Thread get _open => _threads.firstWhere((t) => t.id == _thread);

  List<Line> get _lines => <Line>[
    ..._messages[_thread] ?? const <Line>[],
    if (_thread == 'sre') ..._extra,
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _extra.add((mine: true, text: text.trim(), at: 'now'));
      _thread = 'sre';
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final open = _open;

    // `scrollable: false`, because the transcript scrolls itself and the list
    // in the panel scrolls itself. The layout is a frame here, not a scroller.
    return SizedBox(
      height: 560,
      child: AstryxLayout(
        scrollable: false,
        padding: AstryxSpacingToken.spacing0,
        panelSide: AstryxLayoutPanelSide.start,
        panelWidth: 260,
        panel: _ThreadList(
          threads: _threads,
          selected: _thread,
          onSelected: (id) => setState(() => _thread = id),
        ),
        child: AstryxChatLayout(
          maxWidth: 640,
          header: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxAvatar(
                      name: open.name,
                      size: AstryxAvatarSize.sm,
                      status: open.online
                          ? AstryxStatusDotVariant.success
                          : AstryxStatusDotVariant.neutral,
                      statusLabel: open.online ? 'Online' : 'Away',
                    ),
                    Flexible(child: AstryxHeading(open.name, level: 1)),
                  ],
                ),
              ),
              AstryxMoreMenu(
                label: 'Conversation actions',
                entries: <AstryxMenuEntry>[
                  AstryxMenuItem(
                    label: 'Search this thread',
                    onSelected: () {},
                  ),
                  AstryxMenuItem(label: 'Mute', onSelected: () {}),
                  const AstryxMenuDivider(),
                  AstryxMenuItem(
                    label: 'Leave conversation',
                    destructive: true,
                    onSelected: () {},
                  ),
                ],
              ),
            ],
          ),
          messages: <Widget>[
            for (final line in _lines)
              // `AstryxChatRole` is about which side of the transcript a turn
              // sits on, not about who is a machine: `user` is whoever is
              // composing, and everything else is the other side.
              AstryxChatMessage(
                role: line.mine
                    ? AstryxChatRole.user
                    : AstryxChatRole.assistant,
                author: line.mine ? 'You' : open.name,
                leading: line.mine
                    ? null
                    : AstryxAvatar(name: open.name, size: AstryxAvatarSize.sm),
                timestamp: AstryxText(
                  line.at,
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
                // Plain text, always. Rendering what somebody typed changes
                // what they said — and in a person-to-person thread there is
                // no markdown to render in the first place.
                child: AstryxText(line.text),
              ),
          ],
          composer: AstryxChatComposer(
            controller: _draft,
            placeholder: 'Message ${open.name}',
            label: 'Message ${open.name}',
            onSubmit: _send,
            leading: <Widget>[
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'Attach a file',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The conversations, newest first, with what is unread on each.
class _ThreadList extends StatelessWidget {
  const _ThreadList({
    required this.threads,
    required this.selected,
    required this.onSelected,
  });

  final List<Thread> threads;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    // No `Expanded` and no scroller of its own: `AstryxLayout` wraps a panel
    // in a `SingleChildScrollView`, so the panel is handed an unbounded
    // height and anything that wants to fill it cannot be laid out.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing0,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const AstryxHeading('Messages'),
              AstryxIconButton(
                icon: AstryxIconName.copy,
                label: 'New conversation',
                tooltip: 'New conversation',
                variant: AstryxButtonVariant.ghost,
                size: AstryxButtonSize.sm,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const AstryxDivider(),
        AstryxList(
          label: 'Conversations',
          children: <Widget>[
            for (final thread in threads)
              AstryxItem(
                label: thread.name,
                description: thread.preview,
                selected: thread.id == selected,
                leading: AstryxAvatar(
                  name: thread.name,
                  size: AstryxAvatarSize.sm,
                  status: thread.online ? AstryxStatusDotVariant.success : null,
                  statusLabel: thread.online ? 'Online' : null,
                ),
                // The count is the badge *and* the announcement: "2" on
                // its own beside a name is a number about nothing.
                trailing: thread.unread == 0
                    ? null
                    : AstryxBadge(
                        '${thread.unread}',
                        variant: AstryxBadgeVariant.info,
                        semanticsLabel: '${thread.unread} unread messages',
                      ),
                onPressed: () => onSelected(thread.id),
              ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** `AstryxChatRole.user` is whoever is composing, and `AstryxChatRole.assistant` is the other side of the transcript. In a conversation between two people that mapping reads oddly in the source and correctly on the screen — `user` is the bubble at the trailing edge, which is where the reader’s own words belong.
- **Accessibility:** The unread badge carries a `semanticsLabel` — "2 unread messages" — because "2" beside a name is a number about nothing. The presence dot on the avatar takes a `statusLabel` for the same reason: a green ring is not the word "online".
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

## Theme showcase

`example/lib/examples/template_screen_examples.dart`

One of everything on one screen, for judging a theme rather than imagining it.

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

**Rules**

- **Careful:** **An `AstryxGrid` cell cannot hold a wrapped row of controls, or an AstryxTable (references/data.md), in touch density.** A grid gives every cell in a row the height of the tallest, which means measuring each cell intrinsically; the touch-target wrapper every interactive widget sits in cannot answer that measurement, and the layout asserts. Cells of text, badges and figures — the dashboard (references/templates.md) tiles — are fine. For anything interactive that wraps, use columns of stacks, which is what this screen does.
- **Note:** Nesting an `AstryxThemeProvider` re-themes a subtree, which is how the theming (references/guides.md) page shows all eight themes at once. Here the theme comes from the chrome instead, so the whole screen changes together — which is the point.
- **Note:** None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

