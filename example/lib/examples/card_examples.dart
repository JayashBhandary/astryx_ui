import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example card_demo -> CardDemoExample
class CardDemoExample extends StatefulWidget {
  const CardDemoExample({super.key});

  @override
  State<CardDemoExample> createState() => _CardDemoExampleState();
}

class _CardDemoExampleState extends State<CardDemoExample> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 380,
      header: AstryxHStack(
        justify: AstryxStackJustify.between,
        align: AstryxStackAlign.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading('Login to your account', level: 4),
                AstryxText(
                  'Enter your email below to login.',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
          AstryxButton(
            label: 'Sign up',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Login',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          AstryxButton(label: 'Login with SSO', onPressed: () {}),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          AstryxTextInput(
            label: 'Password',
            controller: _password,
            required: true,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
// #end

// #example card_slots -> CardSlotsExample
class CardSlotsExample extends StatelessWidget {
  const CardSlotsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Three slots, one gap. The card's `padding` is both its inset and the
    // space between header, body and footer — so the rhythm cannot drift.
    return AstryxCard(
      maxWidth: 360,
      header: const AstryxHeading('Usage', level: 4),
      footer: AstryxButton(
        label: 'See details',
        size: AstryxButtonSize.sm,
        onPressed: () {},
      ),
      child: const AstryxText('4,201 requests this month.'),
    );
  }
}
// #end

// #example card_variants -> CardVariantsExample
class CardVariantsExample extends StatelessWidget {
  const CardVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxCard(child: AstryxText('standard')),
        AstryxCard(
          variant: AstryxCardVariant.muted,
          child: AstryxText('muted'),
        ),
        AstryxCard(
          variant: AstryxCardVariant.transparent,
          showBorder: false,
          child: AstryxText('transparent'),
        ),
      ],
    );
  }
}
// #end

// #example card_palettes -> CardPalettesExample
class CardPalettesExample extends StatelessWidget {
  const CardPalettesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The nine categorical families. Colour by *category* — a team, a
    // workstream — never by severity, which the semantic tokens carry.
    return AstryxGrid(
      minWidth: 120,
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final palette in AstryxPalette.values)
          AstryxCard(
            variant: AstryxCardVariant.palette(palette),
            padding: AstryxSpacingToken.spacing3,
            child: AstryxText(palette.name),
          ),
      ],
    );
  }
}
// #end

// #example card_elevation -> CardElevationExample
class CardElevationExample extends StatelessWidget {
  const CardElevationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxGrid(
      minWidth: 120,
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final elevation in AstryxElevation.values)
          AstryxCard(
            elevation: elevation,
            padding: AstryxSpacingToken.spacing3,
            child: AstryxText(elevation.name),
          ),
      ],
    );
  }
}
// #end

// #example card_pressable -> CardPressableExample
class CardPressableExample extends StatefulWidget {
  const CardPressableExample({super.key});

  @override
  State<CardPressableExample> createState() => _CardPressableExampleState();
}

class _CardPressableExampleState extends State<CardPressableExample> {
  String? _selected = 'pro';

  @override
  Widget build(BuildContext context) {
    // A nullable `onPressed` is the whole difference between a card and
    // upstream's second `ClickableCard`: set it and the card gains hover,
    // press, a focus ring, `Semantics(button: true)` and a tap target.
    return AstryxGrid(
      minWidth: 160,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final plan in const <List<String>>[
          <String>['free', 'Free', 'One project'],
          <String>['pro', 'Pro', 'Unlimited projects'],
        ])
          AstryxCard(
            semanticsLabel: 'Choose the ${plan[1]} plan',
            variant: _selected == plan[0]
                ? const AstryxCardVariant.palette(AstryxPalette.blue)
                : AstryxCardVariant.standard,
            onPressed: () => setState(() => _selected = plan[0]),
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText(plan[1], type: AstryxTextType.large),
                AstryxText(
                  plan[2],
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
// #end

// #example card_scrollable -> CardScrollableExample
class CardScrollableExample extends StatelessWidget {
  const CardScrollableExample({super.key});

  @override
  Widget build(BuildContext context) {
    // With a fixed `height`, `scrollable` scrolls the body only — the header
    // and footer stay put.
    return AstryxCard(
      maxWidth: 380,
      height: 240,
      scrollable: true,
      header: const AstryxHeading('Terms of service', level: 4),
      footer: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        justify: AstryxStackJustify.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AstryxButton(label: 'Decline', onPressed: () {}),
          AstryxButton(
            label: 'Accept',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (var clause = 1; clause <= 12; clause++)
            AstryxText(
              'Clause $clause. The body scrolls; the footer does not.',
              type: AstryxTextType.supporting,
            ),
        ],
      ),
    );
  }
}
// #end

// #example card_unbounded -> CardUnboundedExample
class CardUnboundedExample extends StatelessWidget {
  const CardUnboundedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A card fills a definite width and shrinks to fit an indefinite one —
    // CSS's own block-box rule. So a card inside a horizontal list sizes to
    // its content instead of asserting.
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (final owner in const <String>['Ada', 'Alan', 'Grace'])
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AstryxCard(
                padding: AstryxSpacingToken.spacing3,
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxText(owner),
                    const AstryxText(
                      'On call',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.secondary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// #end
