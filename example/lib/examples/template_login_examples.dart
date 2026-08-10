/// The sign-in templates.
///
/// Four framings of one screen: bare, in a card, behind identity providers, and
/// beside a panel. Each is self-contained, because a template is something to
/// copy — a shared private form would make the snippet a lie about what you get
/// when you paste it.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether [value] looks like an email address.
///
/// Deliberately crude. Real validation belongs on the server; a client-side
/// check is only there to catch the typo before the round trip.
bool looksLikeEmail(String value) {
  final trimmed = value.trim();
  return trimmed.contains('@') && trimmed.indexOf('@') < trimmed.length - 1;
}

// #example template_login -> LoginTemplate
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
// #end

// #example template_login_card -> LoginCardTemplate
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
// #end

// #example template_login_sso -> LoginSsoTemplate
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
// #end

// #example template_login_split -> LoginSplitTemplate
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
// #end

/// The panel beside the split login.
///
/// Upstream fills this half with a photograph. There is no `Thumbnail` or
/// `AspectRatio` in this port yet, so it is a muted surface carrying the one
/// sentence a marketing image would have carried — which is the honest version
/// of the same layout rather than a placeholder box.
class _SplitPanel extends StatelessWidget {
  const _SplitPanel();

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return ColoredBox(
      color: theme.color(AstryxColorToken.backgroundMuted),
      child: const AstryxCenter(
        maxWidth: 320,
        padding: AstryxSpacingToken.spacing6,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxIcon(
              AstryxIconName.checkDouble,
              size: AstryxIconSize.lg,
              color: AstryxIconColor.accent,
            ),
            AstryxHeading('Every deploy, in one place'),
            AstryxText(
              'Atlas has shipped 4,201 builds this month without a rollback.',
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
