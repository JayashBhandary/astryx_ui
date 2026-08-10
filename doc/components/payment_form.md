---
title: Payment form
description: Card details, a billing address, and the summary beside them.
component: true
group: Templates
source: example/lib/examples/template_form_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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

Untick the billing checkbox to reveal the address fields.


## The summary is not decoration

It is the figure the user is about to agree to, so it is on screen beside the fields at width — and it comes **first** when the layout goes to one column. Agreeing to an amount you have not seen is not consent, and "scroll down to check the total" is how that happens.

It is a `muted` card so it reads as context rather than as a second form competing for attention, and the total sits in the card’s footer slot — separated by the card’s own padding, without a hand-placed rule.

## Figures line up or they are unreadable

Every amount is `tabularNumbers: true`. Without fixed-width figures a column of prices is ragged, and comparing 4,800.00 with 192.00 becomes work. The label column is `Flexible` and the figure is not, so a long line item wraps rather than pushing the number off the card.

## Formatters, not validators

The card number takes `FilteringTextInputFormatter.digitsOnly` and a length limit, so the wrong character cannot be typed in the first place. That is better than an error message afterwards — and it is not validation: a real card number is checked by the payment provider, not by the client.

> **Careful**
>
> The country field uses [AstryxSelector](selector.md) with `showSearch: true`. A list of two hundred countries without a search box is a scroll, and upstream’s `ComplexSelector` — which would group them by continent — is not ported.

> **Accessibility**
>
> Card, expiry, CVC and postcode all carry `autofillHints`, so the platform’s own card store can fill them. Typing a 16-digit number by hand is the part of a checkout that goes wrong.

## Related

- [Contact form](contact_form.md) — the single-column form shape.
- [AstryxCard](card.md) — the muted variant and the footer slot.
- [AstryxToast](toast.md) — the confirmation after the request lands.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

