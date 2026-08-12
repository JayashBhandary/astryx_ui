/// Templates — whole screens, assembled from the components.
///
/// A template is not a widget the package exports. It is a composition worth
/// copying, and the only thing that makes it worth copying is that it is real:
/// every one of these is extracted from a compiling widget in
/// `lib/examples/template_*.dart`, built from nothing but what `astryx_ui`
/// ships. If a screen needs a component this port does not have, the page says
/// what stands in for it — or the template stays in `planned/templates.dart`
/// until the component lands.
///
/// **Pure Dart** — see the note on `model.dart`.
library;

import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Every written template, grouped by the kind of screen it is.
final List<DocPage> templatePages = <DocPage>[
  _login,
  _loginCard,
  _loginSso,
  _loginSplit,
  _contactForm,
  _formTwoColumn,
  _paymentForm,
  _settings,
  _settingsDialog,
  _centeredHero,
  _detailPage,
  _dashboard,
  _table,
  _tablePage,
  _classicGallery,
  _aiChat,
  _shellNav,
  _documentation,
  _themeShowcase,
];

const String _group = DocGroup.templates;

/// The shared closing note: what a template is, and what it is not.
const DocCallout _notAWidget = DocCallout.note(
  'None of this is exported. `LoginTemplate` and the rest live in the '
  'documentation site, not in the package — copy the composition into your own '
  'widget and rename it. A design system that shipped your login screen would '
  'be shipping your product.',
);

// ---------------------------------------------------------------------------
// Sign in
// ---------------------------------------------------------------------------

const DocPage _login = DocPage(
  id: 'login',
  title: 'Login',
  group: _group,
  description:
      'A centred sign-in form, with the validation, error and loading states '
      'a real one has.',
  source: 'example/lib/examples/template_login_examples.dart',
  upstreamPath: '/templates/login',
  blocks: <DocBlock>[
    DocExample('template_login', align: DocExampleAlign.stretch),
    DocHeading('The three states'),
    DocProse(
      'A sign-in screen is not one screen, it is four: empty, wrong, waiting, '
      'and in. Three of them are here, and each has its own widget rather than '
      'its own colour.',
    ),
    DocTable(
      headers: <String>['State', 'Shown by', 'Why not something else'],
      rows: <List<String>>[
        <String>[
          'A field the user left empty',
          '`AstryxFieldStatus.error` on that field',
          'It is announced assertively and it names the field. A red border '
              'says only "somewhere here".',
        ],
        <String>[
          'Credentials the server rejected',
          '[AstryxBanner](banner) above the form',
          'It belongs to the form as a whole, not to either field — and a '
              '[toast](toast) would be gone before the second attempt.',
        ],
        <String>[
          'The request in flight',
          '`loading: true` on the submit button',
          'The button keeps its width, stops accepting presses and is '
              'announced as busy. A separate spinner leaves the button live.',
        ],
      ],
    ),
    DocHeading('Validate on submit, not on keystroke'),
    DocProse(
      'Nothing is red until `_submitted` is true. A form that marks the email '
      'field invalid while the user is still typing the local part is telling '
      'them off for being unfinished — and a screen reader announces every '
      'one of those intermediate errors.',
    ),
    DocCode('''
AstryxFieldStatus? get _emailStatus {
  if (!_submitted) return null;                    // ← nothing before the first try
  if (_email.text.trim().isEmpty) {
    return const AstryxFieldStatus.error('Enter your email address');
  }
  return looksLikeEmail(_email.text)
      ? null
      : const AstryxFieldStatus.error('That is not an email address');
}'''),
    DocHeading('Composition'),
    DocTree('''
AstryxCenter(maxWidth: 380)
└── AstryxVStack(gap: spacing5, align: stretch)
    ├── heading + supporting line
    ├── AstryxBanner            ← only when the server said no
    ├── AstryxTextInput × 2      ← email, password
    ├── AstryxHStack(justify: between)
    │   ├── AstryxCheckbox      ← "keep me signed in"
    │   └── AstryxButton(ghost) ← "forgot password?"
    ├── AstryxButton(primary, loading:)
    └── AstryxHStack(justify: center) ← "no account?"'''),
    DocCallout.note(
      '**Keep me signed in is a checkbox, not a switch.** It applies when the '
      'form is submitted, and that is exactly the line between the two '
      'controls. A switch there would claim to have already done something.',
    ),
    DocCallout.accessibility(
      'Set `autofillHints` — `AutofillHints.email` and '
      '`AutofillHints.password`. Without them the platform cannot offer the '
      'saved credential, and a password manager is assistive technology for '
      'anybody who cannot type a 30-character secret twice.',
    ),
    DocProse(
      'The `textInputAction` on each field is what makes the keyboard usable: '
      '`next` moves to the password, `done` submits. On a phone that is the '
      'difference between a form you can fill in without looking down and one '
      'you cannot.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Login card](login_card) — the same form inside a bordered card.',
      '[SSO login](login_sso) — identity providers first, email second.',
      '[Split login](login_split) — the form beside a panel.',
      '[AstryxTextInput](text_input) — the field, and every property used '
          'here.',
    ]),
    _notAWidget,
  ],
);

const DocPage _loginCard = DocPage(
  id: 'login_card',
  title: 'Login card',
  group: _group,
  description: 'Sign-in inside a bordered card, using all three card slots.',
  source: 'example/lib/examples/template_login_examples.dart',
  upstreamPath: '/templates/login-card',
  blocks: <DocBlock>[
    DocExample('template_login_card', align: DocExampleAlign.stretch),
    DocHeading('Why the slots matter'),
    DocProse(
      'The card is doing real work here, not decoration. Its three slots carry '
      'the three questions the screen answers — who is this for, what do I '
      'type, what do I press — and `padding` is *both* the card’s inset and '
      'the gap between the slots. One number, so the internal rhythm of the '
      'card cannot drift the way a hand-spaced column can.',
    ),
    DocTree('''
AstryxCard(width: 380, padding: spacing5, elevation: low)
├── header  ← name of the thing, plus an environment badge
├── child   ← the two fields, stretched
└── footer  ← the primary action and the terms line'''),
    DocHeading('The badge is a warning, and says so'),
    DocProse(
      'The `Staging` badge takes `AstryxBadgeVariant.warning` rather than a '
      'palette colour. Signing in to the wrong environment is a mistake worth '
      'preventing, and the semantic variant is what makes it read as a '
      'caution instead of a category.',
    ),
    DocCallout.note(
      'One elevation step, not three. `AstryxElevation.low` lifts the card off '
      'the body; anything higher belongs to things that float *above* the page '
      '— [popovers](popover), [dialogs](dialog) — and a login card is the '
      'page.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Login](login) — the same form with no card, and the error state.',
      '[AstryxCard](card) — the slots, the variants and the elevation scale.',
    ]),
    _notAWidget,
  ],
);

const DocPage _loginSso = DocPage(
  id: 'login_sso',
  title: 'SSO login',
  group: _group,
  description:
      'Sign-in through identity providers, with an email link as the fallback.',
  source: 'example/lib/examples/template_login_examples.dart',
  upstreamPath: '/templates/login-sso',
  blocks: <DocBlock>[
    DocExample('template_login_sso', align: DocExampleAlign.stretch),
    DocHeading('Order is the whole design'),
    DocProse(
      'In an internal tool almost everybody arrives through the identity '
      'provider, so the providers come first, at full width, and the email '
      'fallback sits below a labelled rule. Putting the email field first '
      'makes the majority scroll past the thing they need.',
    ),
    DocProse(
      "That rule is one widget: `AstryxDivider(label: 'or use your email')`. "
      'Two hand-placed rules either side of a centred word is the usual '
      'version of this, and it drifts the moment the text changes length.',
    ),
    DocHeading('One redirect at a time'),
    DocProse(
      'While a provider is being redirected to, that button is `loading` and '
      'every other one is `enabled: false`. Two SSO handshakes in flight at '
      'once is a bug the user cannot see and cannot recover from.',
    ),
    DocCode(r'''
AstryxButton(
  label: 'Continue with $provider',
  loading: _redirecting == provider,
  enabled: _redirecting == null || _redirecting == provider,
  trailing: const AstryxIcon(AstryxIconName.externalLink,
      size: AstryxIconSize.sm),
  onPressed: () => _redirect(provider),
)'''),
    DocCallout.note(
      'The trailing `externalLink` icon is the one promise an SSO button has '
      'to keep: this leaves the page. The icon registry ships no provider '
      'logos — swap in your own registry, or an `AstryxIconButton.custom`, if '
      'you want the Okta mark.',
    ),
    DocCallout.accessibility(
      'The email fallback’s submit button is disabled until the address is '
      'plausible, and the field carries a `description` saying what pressing '
      'it does. A disabled button with no stated reason is a dead end for '
      'everyone and an unexplained one for a screen-reader user.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Login](login) — password sign-in, with the rejected state.',
      '[AstryxDivider](divider) — the labelled rule.',
    ]),
    _notAWidget,
  ],
);

const DocPage _loginSplit = DocPage(
  id: 'login_split',
  title: 'Split login',
  group: _group,
  description: 'Sign-in beside a full-height panel.',
  source: 'example/lib/examples/template_login_examples.dart',
  upstreamPath: '/templates/login-split',
  blocks: <DocBlock>[
    DocExample('template_login_split', align: DocExampleAlign.stretch),
    DocHeading('One height, two columns'),
    DocProse(
      'The form keeps a fixed measure — 340 — and the panel takes whatever is '
      'left through `Expanded`. That way the split holds at any width without '
      'a breakpoint: the form never gets too narrow to fill in, and the panel '
      'never squeezes the fields to make room for a sentence.',
    ),
    DocTree('''
SizedBox(height: 460)
└── AstryxHStack(align: stretch, mainAxisSize: max)
    ├── Expanded → the panel
    └── SizedBox(width: 340) → AstryxCenter → the fields'''),
    DocCallout.warning(
      '**Upstream puts a photograph in that panel; this one is a muted '
      'surface.** `Thumbnail`, `AspectRatio` and the image components are not '
      'ported, so rather than draw a grey rectangle and call it an image, the '
      'panel carries the one sentence the picture was carrying. The layout is '
      'the same; the content is honest about what the package can do today.',
    ),
    DocProse(
      'The panel’s fill comes from `AstryxColorToken.backgroundMuted` through '
      '`AstryxTheme.of(context)`, not from a `Color` literal — which is why it '
      'is still right in all eight themes and both brightnesses.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Login](login) — the single-column version, with every state.',
      '[Design tokens](tokens) — reaching a colour when no widget owns it.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Forms
// ---------------------------------------------------------------------------

const DocPage _contactForm = DocPage(
  id: 'contact_form',
  title: 'Contact form',
  group: _group,
  description:
      'A single-column form with validation, an in-flight state and a success '
      'state that replaces it.',
  source: 'example/lib/examples/template_form_examples.dart',
  upstreamPath: '/templates/contact-form',
  blocks: <DocBlock>[
    DocExample('template_contact_form', align: DocExampleAlign.stretch),
    DocProse(
      'Fill in nothing and press **Send message** to see the validation; fill '
      'it in properly to see the success state.',
    ),
    DocHeading('The success state replaces the form'),
    DocProse(
      'It does not sit above it. A form still on screen after it has been '
      'submitted is an invitation to submit it again, and the second copy of a '
      'support request is worse than none — somebody now has to work out '
      'whether they are duplicates.',
    ),
    DocCode('''
if (_sent) {
  return AstryxCenter(/* icon, heading, what happens next, "Send another" */);
}
return AstryxCenter(/* the form */);'''),
    DocProse(
      'The success state also says what happens next — "we reply within one '
      'working day" — because "Thanks!" alone leaves the user wondering '
      'whether anything was actually recorded.',
    ),
    DocHeading('One measure, one column'),
    DocProse(
      '`AstryxCenter(maxWidth: 460)` is doing the layout. A form field wider '
      'than about 460 makes the label and the value hard to associate, and a '
      'two-column contact form makes the reader guess the tab order.',
    ),
    DocHeading('Which control for which question'),
    DocTable(
      headers: <String>['Field', 'Control', 'Because'],
      rows: <List<String>>[
        <String>[
          'Name, email',
          '[AstryxTextInput](text_input)',
          'Free text, one line, with `autofillHints` so the platform can fill '
              'them.',
        ],
        <String>[
          'Topic',
          '[AstryxSelector](selector)',
          'One value out of four, and it needs `description`s to be '
              'unambiguous. A [menu](dropdown_menu) performs actions and '
              'reports nothing.',
        ],
        <String>[
          'Message',
          '[AstryxTextArea](text_area)',
          'Multi-line, grows with the content, and takes a `maxLength` the '
              'user can see.',
        ],
      ],
    ),
    DocCallout.accessibility(
      'Every validation message says what to do, not what went wrong: "Tell '
      'us who you are", not "Invalid". The status is announced assertively, so '
      'it is the entire instruction a screen-reader user receives.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Two-column form](form_two_column) — for a long form with sections.',
      '[AstryxField](field) — the label, description and status around a '
          'control of your own.',
    ]),
    _notAWidget,
  ],
);

const DocPage _formTwoColumn = DocPage(
  id: 'form_two_column',
  title: 'Two-column form',
  group: _group,
  description:
      'A long form split into labelled sections, with the section heading '
      'beside its fields.',
  source: 'example/lib/examples/template_form_examples.dart',
  upstreamPath: '/templates/form-two-column',
  blocks: <DocBlock>[
    DocExample(
      'template_form_two_column',
      align: DocExampleAlign.stretch,
      note:
          'Narrow the window: below 620 each section’s label moves above its '
          'fields instead of squeezing.',
    ),
    DocHeading('What the second column is for'),
    DocProse(
      'Not two columns of fields — two columns of *purpose*. The reading '
      'column explains the section, the other one holds the controls. A long '
      'settings form scanned for the right section is much faster to use than '
      'one where every heading is a full-width band the eye has to cross.',
    ),
    DocTree('''
_FormSection
└── LayoutBuilder
    ├── wide   → AstryxHStack ── SizedBox(width: 220) → heading + description
    │                         └── Expanded            → the fields
    └── narrow → AstryxVStack ── heading + description, then the fields'''),
    DocProse(
      'The breakpoint is a `LayoutBuilder` and one constant, not a breakpoint '
      'system. The section knows the width it needs; the builder knows the '
      'width it has. Nothing else in the application has to agree about it, '
      'and the same form works in a panel, a dialog and a page.',
    ),
    DocHeading('Checkboxes, because there is a Save button'),
    DocProse(
      'Every toggle in this form is an [AstryxCheckbox](checkbox), and the '
      'digest section says so out loud. The screen has **Discard** and **Save '
      'changes** at the bottom, so nothing may take effect before they are '
      'pressed — and a [switch](switch) would promise exactly that. The '
      '[settings](settings) template is the other half of this rule: switches, '
      'and no Save button anywhere.',
    ),
    DocHeading('Saying whether there is anything to save'),
    DocProse(
      'A badge in the header tracks `_dirty`, and both footer buttons are '
      '`enabled: _dirty`. The pairing matters: a disabled Save with no '
      'explanation reads as broken, and a badge that says *Unsaved changes* '
      'turns it into a state the user can see and act on.',
    ),
    DocCallout.accessibility(
      'The badge carries an icon as well as a colour — `warning` for unsaved, '
      '`success` for saved. Colour is never the only signal; in greyscale, or '
      'to a colour-blind reader, the icon and the words are what remain.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Contact form](contact_form) — one column, and a success state.',
      '[Settings](settings) — the same content as switches, applying '
          'immediately.',
      '[AstryxRadioList](radio_list) — one visible choice out of a few.',
    ]),
    _notAWidget,
  ],
);

const DocPage _paymentForm = DocPage(
  id: 'payment_form',
  title: 'Payment form',
  group: _group,
  description: 'Card details, a billing address, and the summary beside them.',
  source: 'example/lib/examples/template_form_examples.dart',
  upstreamPath: '/templates/payment-form',
  blocks: <DocBlock>[
    DocExample(
      'template_payment_form',
      align: DocExampleAlign.stretch,
      note: 'Untick the billing checkbox to reveal the address fields.',
    ),
    DocHeading('The summary is not decoration'),
    DocProse(
      'It is the figure the user is about to agree to, so it is on screen '
      'beside the fields at width — and it comes **first** when the layout '
      'goes to one column. Agreeing to an amount you have not seen is not '
      'consent, and "scroll down to check the total" is how that happens.',
    ),
    DocProse(
      'It is a `muted` card so it reads as context rather than as a second '
      'form competing for attention, and the total sits in the card’s footer '
      'slot — separated by the card’s own padding, without a hand-placed rule.',
    ),
    DocHeading('Figures line up or they are unreadable'),
    DocProse(
      'Every amount is `tabularNumbers: true`. Without fixed-width figures a '
      'column of prices is ragged, and comparing 4,800.00 with 192.00 becomes '
      'work. The label column is `Flexible` and the figure is not, so a long '
      'line item wraps rather than pushing the number off the card.',
    ),
    DocHeading('Formatters, not validators'),
    DocProse(
      'The card number takes `FilteringTextInputFormatter.digitsOnly` and a '
      'length limit, so the wrong character cannot be typed in the first '
      'place. That is better than an error message afterwards — and it is not '
      'validation: a real card number is checked by the payment provider, not '
      'by the client.',
    ),
    DocCallout.warning(
      'The country field uses [AstryxSelector](selector) with '
      '`showSearch: true`. A list of two hundred countries without a search '
      'box is a scroll, and upstream’s `ComplexSelector` — which would group '
      'them by continent — is not ported.',
    ),
    DocCallout.accessibility(
      'Card, expiry, CVC and postcode all carry `autofillHints`, so the '
      'platform’s own card store can fill them. Typing a 16-digit number by '
      'hand is the part of a checkout that goes wrong.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Contact form](contact_form) — the single-column form shape.',
      '[AstryxCard](card) — the muted variant and the footer slot.',
      '[AstryxToast](toast) — the confirmation after the request lands.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------

const DocPage _settings = DocPage(
  id: 'settings',
  title: 'Settings',
  group: _group,
  description:
      'Grouped preference rows with inline controls, each applying the moment '
      'it changes.',
  source: 'example/lib/examples/template_settings_examples.dart',
  upstreamPath: '/templates/settings',
  blocks: <DocBlock>[
    DocExample('template_settings', align: DocExampleAlign.stretch),
    DocHeading('Switches, and therefore no Save button'),
    DocProse(
      'This is the rule the whole template is arranged around. An '
      '[AstryxSwitch](switch) means *in force now*; an '
      '[AstryxCheckbox](checkbox) means *when you submit*. So there is no Save '
      'button anywhere on this screen — adding one would make every switch a '
      'lie — and each change shows a [toast](toast) confirming it, because a '
      'setting that saved silently and a setting that failed to save look '
      'identical.',
    ),
    DocProse(
      'A form with a Save button is the other shape entirely: see the '
      '[two-column form](form_two_column).',
    ),
    DocHeading('The settings-row shape'),
    DocProse(
      'Label at the reading edge, control at the trailing one. Two properties '
      'do it, and they are the reason this looks like a settings list rather '
      'than a column of switches:',
    ),
    DocCode('''
AstryxSwitch(
  label: 'Mentions',
  description: 'When someone @s you',
  value: on,
  labelPosition: AstryxToggleLabelPosition.start,   // ← label first
  labelSpacing: AstryxToggleLabelSpacing.spread,    // ← control at the far edge
  onChanged: (value) => …,
)'''),
    DocProse(
      'Rows are separated by an [AstryxDivider](divider) rather than by extra '
      'space, which keeps the label and its description associated with each '
      'other instead of floating between two rows.',
    ),
    DocHeading('Sections are cards'),
    DocTree('''
AstryxVStack(gap: spacing6)
├── heading + supporting line
├── AstryxCard  ← Notifications: four switch rows, divided
├── AstryxCard  ← Appearance: two selectors
└── AstryxCard(variant: palette(red))  ← the destructive section, last'''),
    DocHeading('The destructive section'),
    DocProse(
      'Last on the page, in a red-palette card, behind an '
      '[AstryxDialog](dialog). The button is not the confirmation: the dialog '
      'is, and it states what is actually lost — drafts and saved views, after '
      'thirty days — rather than asking "are you sure?", which nobody has ever '
      'answered no to on the strength of the question alone.',
    ),
    DocCallout.warning(
      'The red card is `AstryxCardVariant.palette(AstryxPalette.red)`, and the '
      'palettes are **categorical, not semantic**. It is used here for the '
      'boundary of the section, with the destructive `variant` on the button '
      'and the dialog carrying the actual severity.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Settings dialog](settings_dialog) — the same content in a modal.',
      '[Two-column form](form_two_column) — the version with a Save button.',
      '[AstryxSwitch](switch) — and why it is not a checkbox.',
    ]),
    _notAWidget,
  ],
);

const DocPage _settingsDialog = DocPage(
  id: 'settings_dialog',
  title: 'Settings dialog',
  group: _group,
  description: 'Settings inside a modal, with its own navigation.',
  source: 'example/lib/examples/template_settings_examples.dart',
  upstreamPath: '/templates/settings-dialog',
  blocks: <DocBlock>[
    DocExample('template_settings_dialog', align: DocExampleAlign.stretch),
    DocHeading('Navigation inside a modal'),
    DocProse(
      'An [AstryxTabList](tab_list) reports a value and owns no panel, so the '
      'section on screen is one field of state and a `switch` expression. That '
      'is what makes tabs usable inside a dialog: there is no hidden panel '
      'stack to keep in step with the tab strip, and the dialog’s body scrolls '
      'the section that is showing.',
    ),
    DocTree('''
AstryxDialog(width: 520)
├── title   ← "Settings", and the dialog’s accessible name
├── child
│   ├── AstryxTabList  ← Profile · Notifications · Advanced
│   └── switch (_section) → the section’s controls
└── footer  ← Close, pinned below the scrolling body'''),
    DocHeading('Read-only is not disabled'),
    DocProse(
      'The email field is `readOnly: true`, not `enabled: false`. The value '
      'matters and is worth reading — it is simply not yours to change here, '
      'because the identity provider owns it. `enabled: false` dims it to the '
      'point where it stops being information.',
    ),
    DocCallout.note(
      'A dialog is a widget in the tree driven by an `AstryxDialogController`, '
      'not a `showDialog` call. It renders nothing until the controller opens '
      'it, so it sits next to the button that opens it and the state stays '
      'yours — including which tab was last open.',
    ),
    DocCallout.accessibility(
      '`title` is the dialog’s accessible name, focus is trapped inside while '
      'it is open, and it returns to the trigger on close. The tab strip has '
      'its own `label`, because "Profile Notifications Advanced" with no '
      'context is not a name.',
    ),
    DocProse(
      'The Advanced section carries a banner with `announce: false`: it is '
      'part of the panel’s initial state, not news, and announcing it every '
      'time the tab changes is noise.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Settings](settings) — the full-page version.',
      '[AstryxDialog](dialog) — the controller, the focus trap and the slots.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Pages
// ---------------------------------------------------------------------------

const DocPage _centeredHero = DocPage(
  id: 'centered_hero',
  title: 'Centred hero',
  group: _group,
  description: 'A headline, a supporting line, and one action.',
  source: 'example/lib/examples/template_screen_examples.dart',
  upstreamPath: '/templates/centered-hero',
  blocks: <DocBlock>[
    DocExample('template_centered_hero', align: DocExampleAlign.stretch),
    DocHeading('The measure is the design'),
    DocProse(
      '`AstryxCenter(maxWidth: 620)` is what makes this readable. A supporting '
      'line that runs the full width of a desktop window is a paragraph nobody '
      'finishes, and no amount of type scale fixes it.',
    ),
    DocProse(
      'The heading uses `type: AstryxHeadingType.display2` for the size and '
      'keeps `level: 1` for the outline. Those are two different jobs: the '
      'display types are marketing scale, the level is what a screen reader '
      'navigates by. Reaching for a bigger `level` to get a bigger size is how '
      'a page ends up with three h1s.',
    ),
    DocHeading('One primary action'),
    DocProse(
      '**Start free** is `primary`; **Read the docs** is `secondary` with an '
      '`externalLink` icon. Two primary buttons side by side is a question, '
      'not a recommendation — the whole point of the variant is that exactly '
      'one thing in a view is the thing to do.',
    ),
    DocProse(
      'Both are `AstryxButtonSize.lg`, and the row is `wrap: true` so the two '
      'actions stack on a phone rather than shrinking below a comfortable tap '
      'target.',
    ),
    DocTree('''
AstryxCenter(maxWidth: 620, minHeight: 360)
└── AstryxVStack(gap: spacing5, align: center)
    ├── AstryxBadge      ← the one-line claim
    ├── AstryxHeading(display2, level: 1)
    ├── AstryxText(large, secondary)
    ├── AstryxHStack(wrap: true) ← primary + secondary
    └── AstryxText(supporting)   ← what it costs to try'''),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxHeading](heading) — levels, display types, and why they differ.',
      '[AstryxCenter](center) — the measure, the padding and the minimum '
          'height.',
    ]),
    _notAWidget,
  ],
);

const DocPage _detailPage = DocPage(
  id: 'detail_page',
  title: 'Detail page',
  group: _group,
  description: 'One record: header, status, tabs, metadata and actions.',
  source: 'example/lib/examples/template_screen_examples.dart',
  upstreamPath: '/templates/detail-page',
  blocks: <DocBlock>[
    DocExample('template_detail_page', align: DocExampleAlign.stretch),
    DocHeading('The header answers three questions'),
    DocProse(
      'What is this, how bad is it, and what can I do about it. The badges and '
      'the id come first, then the title, then one line of context — and the '
      'actions sit at the trailing edge on the same line, so the primary '
      'action is reachable without reading the record.',
    ),
    DocProse(
      'The id is `AstryxTextType.code`, because it is a thing to be copied '
      'exactly rather than read. The identity column is `Flexible`, so a long '
      'incident title wraps instead of pushing **Resolve** off the screen.',
    ),
    DocHeading('Actions: one button, then a menu'),
    DocProse(
      'One [AstryxButton](button) for the action people came to perform, and '
      'an [AstryxDropdownMenu](dropdown_menu) for the rest — with the '
      'destructive item last, behind a divider, and `destructive: true` so it '
      'is coloured with the error token. A menu performs actions; it does not '
      'report a selection.',
    ),
    DocHeading('Tabs report a value and own nothing'),
    DocCode('''
AstryxTabList<String>(
  label: 'Incident sections',
  value: _tab,
  onChanged: (value) => setState(() => _tab = value),
  tabs: const <AstryxTab<String>>[
    AstryxTab(value: 'overview', label: 'Overview'),
    AstryxTab(value: 'timeline', label: 'Timeline', badge: AstryxBadge('4')),
    AstryxTab(value: 'notes', label: 'Notes'),
  ],
),
switch (_tab) {
  'overview' => const _IncidentFacts(),
  'timeline' => const _IncidentTimeline(),
  _ => const _IncidentNotes(),
},'''),
    DocProse(
      'That is the whole panel mechanism. Because the strip owns no panel, the '
      'same field can come from a route — which is what makes a tabbed detail '
      'page linkable.',
    ),
    DocCallout.warning(
      '**The metadata list and the timeline are compositions, not '
      'components.** Upstream ships `MetadataList` and `List`; neither is '
      'ported. The label-and-value pairs are an [AstryxGrid](grid) of '
      'two-line stacks, and the timeline is an `AstryxVStack` with '
      '[dividers](divider) between rows. Both are what those components would '
      'replace, and both are exactly the code you would delete when they land.',
    ),
    DocProse(
      'The status banner takes `announce: false`. It is part of the page’s '
      'initial state — announcing "latency is still above the objective" on '
      'every visit is noise, and the record’s own heading has already said '
      'what this is.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Table](table_template) — the list this record is opened from.',
      '[Dashboard](dashboard) — the same data summarised.',
      '[AstryxTabList](tab_list) — the keyboard map and the overflow '
          'behaviour.',
    ]),
    _notAWidget,
  ],
);

const DocPage _dashboard = DocPage(
  id: 'dashboard',
  title: 'Dashboard',
  group: _group,
  description: 'Summary tiles above a table of what needs attention.',
  source: 'example/lib/examples/template_screen_examples.dart',
  upstreamPath: '/templates/dashboard',
  blocks: <DocBlock>[
    DocExample(
      'template_dashboard',
      align: DocExampleAlign.stretch,
      note:
          'Resize the window: the tile row re-flows on width alone, with no '
          'breakpoints involved.',
    ),
    DocHeading('Tiles first, and the count falls out of the width'),
    DocProse(
      '`AstryxGrid(minWidth: 190, maxColumns: 4)` is the whole responsive '
      'story — the same thing `repeat(auto-fit, minmax(190px, 1fr))` does '
      'upstream. Four tiles across on a desktop, two on a tablet, one on a '
      'phone, and no breakpoint table to maintain.',
    ),
    DocProse(
      'Each tile pairs a figure with the objective it is measured against, '
      'because "99.94%" alone is not information. The progress bar is '
      '`showLabel: false` — the tile’s own label is already the accessible '
      'name, and two labels on one control is noise — and the open-incident '
      'tile has no bar at all: a count has no proportion to show.',
    ),
    DocHeading('An objective, or a colour that means nothing'),
    DocTable(
      headers: <String>['Tile', 'Variant', 'Because'],
      rows: <List<String>>[
        <String>['Availability', '`success`', 'Above its objective.'],
        <String>['p95 latency', '`accent`', 'Inside its objective, neutrally.'],
        <String>[
          'Error budget',
          '`warning`',
          'Being consumed faster than the window refills it.',
        ],
        <String>['Open incidents', 'no bar', 'A count, not a proportion.'],
      ],
    ),
    DocHeading('Then the table, filtered to what matters'),
    DocProse(
      'The table shows open incidents only — the dashboard’s job is what needs '
      'attention, not everything that ever happened — with a ghost button '
      'through to the full [table screen](table_template). Filtering happens '
      'in the caller, because `AstryxTable.rows` is documented as already '
      'filtered and paginated.',
    ),
    DocProse(
      'Its `emptyState` is the good news: "Nothing on fire". An empty table '
      'with no empty state looks like a table that failed to load.',
    ),
    DocCallout.warning(
      '**The range picker is an `AstryxButtonGroup`, not a segmented '
      'control.** `SegmentedControl` is not ported, so the selected segment '
      'takes the louder `variant` inside an attached group. It behaves '
      'correctly and it is three buttons — it is not one tab stop with '
      'arrow-key traversal, which is what the real component will bring.',
    ),
    DocCallout.note(
      'There is no chart here. Upstream’s dashboard templates lean on one, and '
      'this port ships no charting widget — the tiles carry the numbers '
      'instead. Reach a token with `AstryxTheme.of(context).color(…)` if you '
      'are wiring up your own chart library.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Table](table_template) — the full list, with filters and selection.',
      '[Detail page](detail_page) — one row of that table, opened.',
      '[AstryxGrid](grid) — responsive tracks without breakpoints.',
    ]),
    _notAWidget,
  ],
);

const DocPage _table = DocPage(
  id: 'table_template',
  title: 'Table',
  group: _group,
  description:
      'A data table as a screen: a toolbar, filtering, sorting, selection and '
      'row actions.',
  source: 'example/lib/examples/template_screen_examples.dart',
  upstreamPath: '/templates/table',
  blocks: <DocBlock>[
    DocExample(
      'template_table',
      align: DocExampleAlign.stretch,
      note:
          'Search for something that does not exist to see the empty state; '
          'tick a row to see the selection bar.',
    ),
    DocHeading('The table does not filter itself'),
    DocProse(
      'Search and the status filter both narrow the list in the caller, and '
      '`rows` gets the result. That is deliberate: a table that filtered its '
      'own rows could not tell "no matches" from "no data", and those need '
      'different empty states — one offers to clear the filters, the other '
      'offers to create the first record.',
    ),
    DocCode('''
List<Incident> get _rows {
  final query = _query.text.trim().toLowerCase();
  return incidents.where((row) {
    final matchesStatus = switch (_status) {
      'open' => !row.resolved,
      'resolved' => row.resolved,
      _ => true,
    };
    return matchesStatus &&
        (query.isEmpty || row.title.toLowerCase().contains(query));
  }).toList();
}'''),
    DocHeading('The toolbar'),
    DocTree('''
AstryxHStack(wrap: true)
├── AstryxTextInput(leading: search, showClear: true, labelHidden: true)
├── AstryxPopover  ← the status filter, and the trigger says what is applied
└── AstryxDropdownMenu ← export, subscribe'''),
    DocProse(
      'The search field is `labelHidden: true`, not label-less: the '
      'placeholder is invisible to a screen reader once text is typed, so the '
      'name has to exist somewhere. The filter trigger changes its own label '
      'to `Filter: open` when a filter is on, because a filter you cannot see '
      'is a table lying about how much data there is.',
    ),
    DocHeading('Sorting: on the number, showing the label'),
    DocProse(
      'A column is sortable when — and only when — it has a `compare`. The '
      'severity column shows a badge reading "Sev-1" but compares the integer '
      'behind it, which is the whole reason the row type keeps both. Sorting '
      'the label as a string puts Sev-10 between Sev-1 and Sev-2.',
    ),
    DocProse(
      'Pressing a header cycles ascending → descending → unsorted. That third '
      'state is not a nicety: without it there is no way back to the order the '
      'rows arrived in.',
    ),
    DocHeading('Selection needs a count and a name'),
    DocProse(
      'The selection bar appears once something is ticked and says how many. '
      '**Resolve** with no count is a question the user cannot answer. And '
      '`rowLabelOf` is what names each row’s checkbox — without it every one '
      'of them is announced as "Select row", which is true of all of them and '
      'therefore useless.',
    ),
    DocCallout.accessibility(
      'Row actions are **always visible**. Hover does not exist on touch, and '
      'the density system actively suppresses hover styling there — an action '
      'that only appears under a pointer is an action half your users do not '
      'have.',
    ),
    DocCallout.warning(
      '**Do not put `truncateTooltip: true` in a table cell.** Deciding '
      'whether text is cut off needs the cell’s final width, and a table row '
      'is measured before it is laid out — the layout asserts in touch '
      'density. `maxLines: 1` on its own is what these cells use; the ellipsis '
      'is the signal, and a screen reader gets the whole string either way.',
    ),
    DocCallout.warning(
      '**No pagination here, and no virtualisation anywhere.** '
      '`AstryxTable` does not virtualise rows: a `maxHeight` scrolls the body, '
      'and a few hundred rows is fine. Past that, page in your own data layer '
      '— the [table page](table_page) template is that screen, with '
      '[AstryxPagination](pagination) in the footer.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxTable](table) — every property, and the three width strategies.',
      '[Table page](table_page) — the same table as a whole screen, paginated.',
      '[Dashboard](dashboard) — the same data, summarised.',
      '[Detail page](detail_page) — where a row leads.',
    ]),
    _notAWidget,
  ],
);

const DocPage _tablePage = DocPage(
  id: 'table_page',
  title: 'Table page',
  group: _group,
  description:
      'A table as a whole screen: filters in a pinned header, pagination in a '
      'pinned footer.',
  source: 'example/lib/examples/template_table_page_examples.dart',
  upstreamPath: '/templates/table-page',
  blocks: <DocBlock>[
    DocExample(
      'template_table_page',
      align: DocExampleAlign.stretch,
      note:
          'Change the page size, sort a column, then filter: the reader lands '
          'back on page one every time, and the range under the table says '
          'what they are looking at.',
    ),
    DocHeading('Why this is not the table template'),
    DocProse(
      'The [table](table_template) template is a composition inside a page. '
      'This is the page: the filters sit in an [AstryxLayout](layout) header '
      'that does not scroll, the pagination sits in a footer that does not '
      'scroll, and the only thing that moves is the rows. On a screen where '
      'the table *is* the work, a filter you have to scroll up to reach is a '
      'filter nobody reverts.',
    ),
    DocTree('''
AstryxLayout(scrollable: false)
├── header  ← title, search, state filter, "n of m"
├── child   ← AstryxTable, scrolling its own body under a pinned header row
└── footer  ← "15–28 of 38", rows-per-page, AstryxPagination'''),
    DocCallout.warning(
      '**`scrollable: false`.** `AstryxTable` scrolls its own body under its '
      'header row. Leaving the layout scrollable puts one scroll view inside '
      'another, and the inner one then measures unbounded — which is a '
      'layout assertion rather than a subtle bug.',
    ),
    DocHeading('Sort the set, then cut the page'),
    DocProse(
      'Both the filtering and the **sorting** happen in the caller, in that '
      'order, before the page is sliced out. This is the one thing a paginated '
      'table gets wrong most often: hand `rows` a single page and let the '
      'table sort it, and you have sorted fourteen rows out of thirty-eight — '
      'a column that reorders within the page and never moves a row between '
      'pages.',
    ),
    DocCode('''
List<Run> get _matches {
  final rows = runs.where(_passesFilters).toList();   // filter the whole set
  if (_sort != null) rows.sort(_comparatorFor(_sort!));  // then sort it
  return rows;
}

List<Run> get _rows {                                // then cut the window
  final start = (_page - 1) * _pageSize;
  if (start >= _matches.length) return const <Run>[];
  return _matches.sublist(start, min(start + _pageSize, _matches.length));
}'''),
    DocHeading('Every filter resets the page'),
    DocProse(
      'Search, the state filter, the page size and the sort all go through one '
      'helper that sets `_page = 1`. Without it, narrowing a 38-row set while '
      'on page three shows an empty table — which reads as "no data" rather '
      'than "you are past the end", and is the single most common bug on a '
      'screen like this.',
    ),
    DocCode('''
void _refilter(VoidCallback change) => setState(() {
  change();
  _page = 1;      // ← the whole point
});'''),
    DocHeading('The footer counts, it does not just number'),
    DocProse(
      '"Page 2 of 3" tells a reader nothing about how much they have not seen. '
      '"15–28 of 38" does, and it is the only line on the screen that '
      'distinguishes a filter that matched nothing from a data set that is '
      'empty. Both states are handled: the range collapses to "Nothing to '
      'show" and the table draws its own `emptyState` offering to clear the '
      'filters.',
    ),
    DocCallout.accessibility(
      'Row actions are always visible, never on hover — touch has no hover, '
      'and the density system suppresses hover styling there. `rowLabelOf` is '
      'what names each row for the action beside it: "Actions" repeated '
      'fourteen times is fourteen identical announcements.',
    ),
    DocCallout.note(
      '**Rows per page is a selector, not a switch or a segmented control.** '
      'It picks a value out of several and shows the current one, which is the '
      'line between [AstryxSelector](selector) and the other two.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxPagination](pagination) — pages are one-based, the ends are '
          'always shown, and the arrows disable rather than disappear.',
      '[AstryxTable](table) — the table itself, and the three width '
          'strategies.',
      '[Table](table_template) — the same data as a composition rather than a '
          'page.',
    ]),
    _notAWidget,
  ],
);

const DocPage _classicGallery = DocPage(
  id: 'classic_gallery',
  title: 'Classic gallery',
  group: _group,
  description:
      'A uniform wall of media tiles, each opening the same viewer on the item '
      'that was pressed.',
  source: 'example/lib/examples/template_gallery_examples.dart',
  upstreamPath: '/templates/classic-gallery',
  blocks: <DocBlock>[
    DocExample(
      'template_classic_gallery',
      align: DocExampleAlign.stretch,
      note:
          'Press a tile: the viewer opens on that one. Page it with the arrow '
          'keys and close it with Escape. Filter by album and the viewer '
          'follows the filtered set.',
    ),
    DocHeading('One viewer, not one per tile'),
    DocProse(
      'The [AstryxLightbox](lightbox) sits beside the wall of tiles and takes '
      'the whole list. A tile does not own an overlay — it sets an index and '
      'shows the shared one. Eight tiles with eight lightboxes is eight '
      'overlay controllers, eight focus traps and eight chances for two of '
      'them to be open at once.',
    ),
    DocCode('''
void _open(int index) {
  setState(() => _index = index);   // which item the viewer starts on
  _viewer.show();
}

AstryxLightbox(
  controller: _viewer,
  initialIndex: _index,             // read every time it opens, not once
  items: items,
)'''),
    DocHeading('A picture is not the thing’s name'),
    DocProse(
      'Every tile carries its name in text as well as in the picture, and the '
      'card announces `"{name}, {album}"`. That is not a courtesy: a thumbnail '
      'that has not loaded, or a reader who cannot see it, leaves the name as '
      'the only thing there is — which is why the name is required on '
      '[AstryxThumbnail](thumbnail) and [AstryxAvatar](avatar) rather than '
      'optional.',
    ),
    DocHeading('Anything over media goes through AstryxMediaTheme'),
    DocProse(
      'The caption sits on the picture, so it cannot use the page’s text '
      'colour — the picture is whatever colour it is. '
      '[AstryxMediaTheme](media_theme) forces the on-dark tokens and puts a '
      'scrim behind them, and the text inside it asks for '
      '`AstryxTextColor.inherit` so that both the caption and the glyph beside '
      'it take that colour without either naming it.',
    ),
    DocCallout.warning(
      '**The wall is a wrapping row of fixed-width tiles, not an '
      '[AstryxGrid](grid).** A grid gives every cell in a row the height of '
      'the tallest, which means measuring each cell intrinsically — and a '
      'pressable tile sits inside the touch-target wrapper, which cannot '
      'answer that measurement in touch density. Uniform tiles look identical '
      'either way; a grid is right for cells of text and figures, like the '
      '[dashboard](dashboard) tiles.',
    ),
    DocCallout.accessibility(
      'The tile is one tab stop and announces its name once. The caption over '
      'the picture is inside the same card, so a second announcement of the '
      'same words would be noise — the card’s `semanticsLabel` is the '
      'sentence, and the visible caption is what a sighted reader gets '
      'instead.',
    ),
    DocProse(
      'Filtering by album rebuilds both the wall and the viewer’s list from '
      'the same `_shown`, so the counter inside the viewer says "3 of 5" about '
      'the set the reader is actually looking at. A viewer paging through '
      'hidden items is a filter that did not apply.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLightbox](lightbox) — the viewer, its paging and its focus trap.',
      '[AstryxAspectRatio](aspect_ratio) — the box, the ground and the clip.',
      '[AstryxMediaTheme](media_theme) — the scrim and the on-dark tokens.',
      '[AstryxThumbnail](thumbnail) — the smaller tile, with a caption and a '
          'selected state built in.',
    ]),
    _notAWidget,
  ],
);

const DocPage _aiChat = DocPage(
  id: 'ai_chat',
  title: 'AI chat',
  group: _group,
  description:
      'A full conversation screen: transcript, composer, tool calls, and the '
      'empty state before the first turn.',
  source: 'example/lib/examples/template_chat_examples.dart',
  upstreamPath: '/templates/ai-chat',
  blocks: <DocBlock>[
    DocExample(
      'template_ai_chat',
      align: DocExampleAlign.stretch,
      note:
          'Send something to see the waiting state, then **Skip the wait** for '
          'the reply. **New chat** empties the transcript, which is how to see '
          'the empty state and its suggestions.',
    ),
    DocHeading('Four states, not one screen'),
    DocTable(
      headers: <String>['State', 'Shown by', 'Why'],
      rows: <List<String>>[
        <String>[
          'Nothing said yet',
          '`empty:` on [AstryxChatLayout](chat_layout)',
          'It is the first thing most people see, so it is a slot rather than '
              'a blank — and centred, which a transcript could not manage on '
              'its own.',
        ],
        <String>[
          'Waiting for the answer',
          '`generating: true` on the composer',
          'The send button becomes stop. A spinner beside a live send button '
              'invites a second request nobody wanted.',
        ],
        <String>[
          'Answered',
          '[AstryxMarkdown](markdown) plus '
              '[AstryxChatToolCalls](chat_tool_calls)',
          'The reply arrives as markdown and the work behind it is '
              'summarised, collapsed, underneath it.',
        ],
        <String>[
          'Answered from sources',
          '[AstryxCitation](citation) spans',
          'The marker is a number, but its **name** is the source — a row of '
              'bare numerals is a puzzle, not a bibliography.',
        ],
      ],
    ),
    DocHeading('The user’s words are never markdown'),
    DocProse(
      'The transcript renders the assistant’s turn with '
      '[AstryxMarkdown](markdown) and the user’s turn with plain '
      '[AstryxText](text). That asymmetry is deliberate. Rendering what '
      'somebody typed changes what they said: an underscore around a variable '
      'name becomes italics, and a line starting with `#` becomes a heading.',
    ),
    DocCode('''
Widget _turnMessage(_Turn turn) {
  if (turn.role == AstryxChatRole.user) {
    return AstryxChatMessage(
      role: AstryxChatRole.user,
      author: 'You',
      child: AstryxText(turn.text),          // ← their words, as typed
    );
  }
  return AstryxChatMessage(
    author: 'Assistant',
    footer: AstryxChatToolCalls(calls: turn.calls),
    child: AstryxMarkdown(turn.text, onLinkPressed: _open),
  );
}'''),
    DocHeading('Suggestions are buttons'),
    DocProse(
      'The empty state offers three prompts and each one is an '
      '[AstryxButton](button) that sends itself. A suggestion you have to '
      'retype is a suggestion nobody uses, and placeholder text that '
      'disappears the moment you type is not a suggestion at all.',
    ),
    DocHeading('Composition'),
    DocTree('''
AstryxLayout(scrollable: false, padding: spacing0)
├── header ← title, turn count, model selector, "New chat"
└── AstryxChatLayout
    ├── messages  ← AstryxChatMessage per turn
    │   ├── actions: copy / good / bad     ← always visible
    │   ├── footer:  AstryxChatToolCalls   ← collapsed
    │   └── child:   AstryxMarkdown + AstryxCitation spans
    ├── empty     ← heading, line, three prompt buttons
    └── composer  ← AstryxChatComposer(generating:, onStop:)'''),
    DocCallout.warning(
      '**Bound the height and turn the layout’s scrolling off.** '
      '`AstryxChatLayout` divides what it is given between the transcript and '
      'the composer, so it needs a bounded height and it owns the scrolling '
      'itself. Inside a scrollable [AstryxLayout](layout) it would be a scroll '
      'view inside a scroll view, and inside a bare column it would be handed '
      'an unbounded height it cannot divide.',
    ),
    DocCallout.accessibility(
      'The per-message actions — copy, good answer, bad answer — are visible '
      'at all times and each names *which* answer it acts on. Feedback buttons '
      'that appear on hover are feedback no touch user can give.',
    ),
    DocProse(
      'The composer’s footer carries the disclaimer. It belongs there rather '
      'than in a [toast](toast) or a [banner](banner) at the top: it is a '
      'standing fact about every answer, and the moment it matters is the '
      'moment somebody is about to ask.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxChatLayout](chat_layout) — the transcript, the scroll behaviour '
          'and the empty slot.',
      '[AstryxChatComposer](chat_composer) — Enter, Shift+Enter, generating '
          'and stop.',
      '[AstryxChatToolCalls](chat_tool_calls) — what the model did, '
          'summarised.',
      '[AstryxMarkdown](markdown) — what it renders, and what it does not.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Applications
// ---------------------------------------------------------------------------

const DocPage _shellNav = DocPage(
  id: 'shell_nav',
  title: 'Shell navigation',
  group: _group,
  description:
      'The application frame with both bars in place: a full-width header and '
      'a collapsible rail beside the content.',
  source: 'example/lib/examples/template_shell_examples.dart',
  upstreamPath: '/templates/shell-nav',
  blocks: <DocBlock>[
    DocExample(
      'template_shell_nav',
      align: DocExampleAlign.stretch,
      note:
          'Collapse the rail with the control in its header, or narrow the '
          'browser window past 720 pixels to send it behind the drawer the '
          'menu button opens.',
    ),
    DocHeading('Two bars, one list of destinations'),
    DocProse(
      'The header is an [AstryxTopNav](top_nav) and the rail is an '
      '[AstryxSideNav](side_nav), and they are not the same navigation twice. '
      'The bar carries the areas of the product — application, docs, status — '
      'while the rail carries the sections *inside* the area you are in. Both '
      'are containers for one `AstryxNavEntry` list, which is why a section, a '
      'divider and a badge look right in either.',
    ),
    DocTree('''
AstryxAppShell(compactBelow: 720)
├── header  ← AstryxTopNav: brand, areas, search, account
├── sidebar ← AstryxSideNav: sections, heading menu, account row
└── child   ← AstryxLayout: breadcrumbs, title, actions, body'''),
    DocHeading('The header asks the shell where the navigation went'),
    DocProse(
      'A header cannot know whether to draw a menu button without knowing '
      'whether the rail is beside the content or behind the drawer, and that '
      'answer belongs to the shell. `AstryxAppShell.of(context)` is the port '
      'of upstream’s `useAppShellMobile`; measuring the window a second time '
      'in the header is how the two disagree at exactly the threshold.',
    ),
    DocCode('''
final shell = AstryxAppShell.of(context);

if (shell.compact)
  AstryxIconButton(
    icon: AstryxIconName.menu,
    label: 'Open navigation',
    onPressed: shell.controller.toggle,
  ),'''),
    DocCallout.note(
      '**`compactBelow` is a number, not a breakpoint.** The width at which '
      '*your* navigation stops fitting is a fact about your navigation. A '
      'global breakpoint table means every screen has to agree about a number '
      'none of them chose.',
    ),
    DocHeading('Collapsed is narrower, not quieter'),
    DocProse(
      'Collapsing the rail takes the labels off the screen and leaves them in '
      'the semantics tree, with a tooltip that shows on focus as well as '
      'hover. The shell’s `sidebarWidth` moves with it — the rail does not '
      'decide its own width, because the content column is the other half of '
      'that decision.',
    ),
    DocHeading('Three layers of "where am I"'),
    DocTable(
      headers: <String>['Layer', 'Widget', 'Answers'],
      rows: <List<String>>[
        <String>[
          'Which product area',
          '[AstryxTopNav](top_nav) selection',
          'Application, docs, status.',
        ],
        <String>[
          'Which section of it',
          '[AstryxSideNav](side_nav) selection',
          'Deploys, incidents, services.',
        ],
        <String>[
          'Where in the hierarchy',
          '[AstryxBreadcrumbs](breadcrumbs)',
          'Acme Corp › Production › Deploys. The last crumb has no link: a '
              'link to the page you are on is how a trail stops telling you '
              'where you are.',
        ],
      ],
    ),
    DocCallout.accessibility(
      'The drawer is a real [AstryxOverlay](overlay): it traps focus, closes '
      'on Escape or a press on the scrim, and hands focus back to the button '
      'that opened it. A shell that hides navigation without any of that loses '
      'keyboard users at the first tap.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxAppShell](app_shell) — the frame, and the compact behaviour.',
      '[AstryxSideNav](side_nav) — the rail, its sections and its collapsed '
          'state.',
      '[AstryxTopNav](top_nav) — the bar, its menus and the mega menu.',
      '[Documentation](documentation) — the same frame with an outline in the '
          'panel.',
    ]),
    _notAWidget,
  ],
);

const DocPage _documentation = DocPage(
  id: 'documentation',
  title: 'Documentation',
  group: _group,
  description:
      'A docs page: side navigation, a measured content column, and an '
      'on-this-page outline that tracks the reader.',
  source: 'example/lib/examples/template_shell_examples.dart',
  upstreamPath: '/templates/documentation',
  blocks: <DocBlock>[
    DocExample(
      'template_documentation',
      align: DocExampleAlign.stretch,
      note:
          'Scroll the middle column: the outline on the right follows. Press '
          'an outline entry and the page scrolls to that heading.',
    ),
    DocHeading('Two different questions'),
    DocProse(
      'The rail answers "where am I in the site" and the outline answers '
      '"where am I on the page". They look similar and they are not '
      'interchangeable: a docs site with only the first makes a long page '
      'unnavigable, and one with only the second makes the site '
      'unbrowsable.',
    ),
    DocTree('''
AstryxAppShell(compactBelow: 840)
├── header  ← brand, search with its shortcut, version badge
├── sidebar ← AstryxSideNav: the site
└── child   ← AstryxLayout(maxContentWidth: 720)
    ├── header ← AstryxBreadcrumbs
    ├── child  ← AstryxSection per heading, each with an anchor key
    ├── panel  ← AstryxOutline: the page
    └── footer ← previous / next'''),
    DocHeading('The outline needs the body’s scroll controller'),
    DocProse(
      'An outline tracks the reader by watching where the headings *are*, not '
      'by dividing the scroll offset — so it needs the scroll position of the '
      'view the anchors live in, and that view belongs to '
      '[AstryxLayout](layout). Hand the same `ScrollController` to both and '
      'the tracking is automatic; give the outline nothing and it is a list of '
      'links with `activeId` for you to set.',
    ),
    DocCode('''
final _scroll = ScrollController();
final _anchors = <String, GlobalKey>{for (final s in sections) s.id: GlobalKey()};

AstryxLayout(
  scrollController: _scroll,          // the body's scroll view
  panel: AstryxOutline(
    controller: _scroll,              // ← the same one
    entries: <AstryxOutlineEntry>[
      for (final s in sections)
        AstryxOutlineEntry(id: s.id, label: s.title, anchor: _anchors[s.id]),
    ],
  ),
  child: AstryxVStack(
    children: <Widget>[
      for (final s in sections)
        AstryxSection(title: s.title, headerKey: _anchors[s.id], child: …),
    ],
  ),
)'''),
    DocProse(
      'The `anchor` is doing both halves of the job. Without it the outline '
      'cannot know where a heading is, and pressing an entry has nowhere to '
      'scroll to. Upstream gets the same thing from the DOM id it links to.',
    ),
    DocCallout.note(
      '**`maxContentWidth: 720`.** Prose is the content here, and a paragraph '
      'that runs the width of a monitor is a paragraph nobody finishes. Leave '
      'the measure off for a table, which has its own reasons to be wide.',
    ),
    DocHeading('The sections carry their own heading level'),
    DocProse(
      '[AstryxSection](section) works out its level from how deeply it is '
      'nested, so the outline’s indents and the document’s heading structure '
      'cannot drift apart. A page whose headings jump from `h1` to `h4` is a '
      'page a screen reader cannot summarise.',
    ),
    DocCallout.accessibility(
      'The search control shows its own shortcut with '
      '[AstryxKbd.hotkey](kbd), which resolves to ⌘K on a Mac and Ctrl+K '
      'elsewhere — the same `AstryxHotkey` the handler listens for, so the cap '
      'cannot claim a chord the application does not answer.',
    ),
    DocProse(
      'The footer is the previous and next page rather than the actions a form '
      'would have. It is pinned for the same reason a Save button is: at the '
      'bottom of a long page, the way onward is the one thing the reader is '
      'looking for.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxOutline](outline) — the tracking, the anchors and `topOffset`.',
      '[AstryxSection](section) — the titled band, and how it picks its level.',
      '[AstryxLayout](layout) — the header, panel, footer and '
          '`scrollController`.',
      '[Shell navigation](shell_nav) — the same frame around an application '
          'rather than a document.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Reference
// ---------------------------------------------------------------------------

const DocPage _themeShowcase = DocPage(
  id: 'theme_showcase',
  title: 'Theme showcase',
  group: _group,
  description:
      'One of everything on one screen, for judging a theme rather than '
      'imagining it.',
  source: 'example/lib/examples/template_screen_examples.dart',
  upstreamPath: '/templates/theme-showcase',
  blocks: <DocBlock>[
    DocExample(
      'template_theme_showcase',
      align: DocExampleAlign.stretch,
      note:
          'Change the theme, the brightness, the density or the text '
          'direction in the bar above: every colour, radius, weight and '
          'duration below moves with it.',
    ),
    DocHeading('What it is for'),
    DocProse(
      'A palette in isolation tells you very little. A theme is right or wrong '
      'in the presence of a disabled button next to a filled one, a warning '
      'badge on a muted card, a focus ring over a striped table row — so this '
      'screen puts one of everything in one place and lets you look.',
    ),
    DocProse(
      'It is also the fastest check on a custom theme built with '
      '`defineTheme`. If the accent has poor contrast against '
      '`--color-on-accent`, the primary button here shows it immediately.',
    ),
    DocHeading('What to look at'),
    DocList(<String>[
      '**The four button variants together** — is `primary` clearly the one '
          'action, and is `ghost` still findable?',
      '**A warning badge and an error badge side by side** — do they differ by '
          'more than hue?',
      '**The focus ring** — tab through the cards; it must be visible on '
          'every surface, including inside the table.',
      '**Dark mode** — switch the brightness. Elevation reads as a lighter '
          'surface rather than a heavier shadow, and that is where a custom '
          'theme usually breaks.',
      '**Touch density** — every tap target grows to 48px and hover styling '
          'stops. Nothing should move that was not meant to.',
    ]),
    DocHeading('Every component the package exports'),
    DocProse(
      'Four cards and a tabbed panel cover the set: actions, forms, status, '
      'overlays, and a table beside a type specimen. If a widget is missing '
      'from this screen, it is missing from the package — which makes this the '
      'quickest answer to "what is actually in here?".',
    ),
    DocHeading('Columns of cards, not a grid'),
    DocProse(
      'The cards sit in two `Expanded` columns behind a `LayoutBuilder`, not '
      'in an [AstryxGrid](grid). That is not a style choice — it is a limit '
      'worth knowing about:',
    ),
    DocCallout.warning(
      '**An `AstryxGrid` cell cannot hold a wrapped row of controls, or an '
      '[AstryxTable](table), in touch density.** A grid gives every cell in a '
      'row the height of the tallest, which means measuring each cell '
      'intrinsically; the touch-target wrapper every interactive widget sits '
      'in cannot answer that measurement, and the layout asserts. Cells of '
      'text, badges and figures — the [dashboard](dashboard) tiles — are fine. '
      'For anything interactive that wraps, use columns of stacks, which is '
      'what this screen does.',
    ),
    DocProse(
      'The same measurement rule is why `AstryxText(truncateTooltip: true)` '
      'cannot go inside a table cell: deciding whether the text is cut off '
      'needs the final width, and a table row is measured before it is laid '
      'out. Use `maxLines` on its own there and let the ellipsis speak.',
    ),
    DocCallout.note(
      'Nesting an `AstryxThemeProvider` re-themes a subtree, which is how the '
      '[theming](theming) page shows all eight themes at once. Here the theme '
      'comes from the chrome instead, so the whole screen changes together — '
      'which is the point.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Theming](theming) — the seven prebuilt themes and `defineTheme`.',
      '[Design tokens](tokens) — what every one of these widgets resolves '
          'through.',
      '[Density](density) — the pointer and touch difference this screen makes '
          'visible.',
    ]),
    _notAWidget,
  ],
);
