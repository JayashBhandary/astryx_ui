/// The form templates.
///
/// A single-column form that reports success, a two-column form with labelled
/// sections, and a checkout with a summary beside it. All three validate on
/// submit rather than on every keystroke: a field that goes red while you are
/// still typing in it is telling you off for being unfinished.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Below this width the two-column forms become one column.
///
/// A number, not a breakpoint system: the form knows the width it needs, and
/// `LayoutBuilder` knows the width it has. Nothing else has to agree about it.
const double formTwoColumnMinWidth = 620;

// #example template_contact_form -> ContactFormTemplate
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
// #end

// #example template_form_two_column -> FormTwoColumnTemplate
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
// #end

/// One labelled section of [FormTwoColumnTemplate].
///
/// The label column is 220 wide and the fields take the rest; below
/// [formTwoColumnMinWidth] the two stack instead.
class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final label = AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxHeading(title),
        AstryxText(
          description,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );

    final fields = AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: children,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < formTwoColumnMinWidth) {
          return AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[label, fields],
          );
        }

        return AstryxHStack(
          gap: AstryxSpacingToken.spacing6,
          align: AstryxStackAlign.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(width: 220, child: label),
            Expanded(child: fields),
          ],
        );
      },
    );
  }
}

// #example template_payment_form -> PaymentFormTemplate
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
// #end

/// One label-and-figure row of the order summary.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      justify: AstryxStackJustify.between,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          child: AstryxText(
            label,
            type: emphasised ? AstryxTextType.body : AstryxTextType.supporting,
            weight: emphasised ? AstryxTextWeight.semibold : null,
            color: emphasised
                ? AstryxTextColor.primary
                : AstryxTextColor.secondary,
          ),
        ),
        AstryxText(
          value,
          type: emphasised ? AstryxTextType.body : AstryxTextType.supporting,
          weight: emphasised ? AstryxTextWeight.semibold : null,
          tabularNumbers: true,
        ),
      ],
    );
  }
}
