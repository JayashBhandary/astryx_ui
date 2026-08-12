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
                const Spacer(),
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

