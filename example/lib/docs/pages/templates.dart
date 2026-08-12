/// Templates — whole screens, assembled from the components.
///
/// A template is not a widget the package exports. It is a composition worth
/// copying, and the only thing that makes it worth copying is that it is real:
/// every one of these is extracted from a compiling widget in
/// `lib/examples/template_*.dart`, built from nothing but what `astryx_ui`
/// ships.
///
/// Six of these screens need something the package does not have — a chart, a
/// drag gesture, row grouping, a colour scale. None of them fakes it. Each
/// names the gap on its own page, fills it from `flutter/widgets` or from the
/// token layer in as few lines as the screen needs, and marks the seam where a
/// real implementation goes. There is no `planned/templates.dart` any more:
/// every template upstream ships now has a written page here.
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
  _settingsSidebar,
  _centeredHero,
  _galleryHero,
  _detailPage,
  _dashboard,
  _dashboardPortfolio,
  _table,
  _tableGrouped,
  _tablePage,
  _tablePageChart,
  _tablePageHeatmapStatus,
  _tablePageShoeStoreHeatmap,
  _kanbanBoard,
  _incidentConsole,
  _classicGallery,
  _mixedGallery,
  _sideGallery,
  _productGallery,
  _productDetail,
  _aiChat,
  _aiChatLanding,
  _shellNav,
  _shellSideNav,
  _shellTopNav,
  _documentation,
  _documentationDesign,
  _documentationTechnical,
  _editor,
  _fileExplorer,
  _ide,
  _library,
  _messagingShell,
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

const DocPage _settingsSidebar = DocPage(
  id: 'settings_sidebar',
  title: 'Settings with sidebar',
  group: _group,
  description: 'Settings sections reached from a sidebar.',
  source: 'example/lib/examples/template_settings_examples.dart',
  upstreamPath: '/templates/settings-sidebar',
  blocks: <DocBlock>[
    DocExample('template_settings_sidebar', align: DocExampleAlign.stretch),
    DocHeading('Three shapes, one rule'),
    DocProse(
      'This is the third framing of the same screen, and the only thing that '
      'changes between them is how a section is reached. Which one to reach '
      'for is a question about how many sections there are, not about taste:',
    ),
    DocTable(
      headers: <String>['Sections', 'Shape', 'Reached by'],
      rows: <List<String>>[
        <String>[
          'Two or three',
          '[Settings](settings)',
          'Scrolling. Every section is on screen, or one flick away.',
        ],
        <String>[
          'Three or four, in a modal',
          '[Settings dialog](settings_dialog)',
          'An [AstryxTabList](tab_list) inside the dialog.',
        ],
        <String>[
          'Five or more',
          'This one',
          'An [AstryxSideNav](side_nav) beside the content. Past about four, '
              'a long page stops being scannable and the reader is scrolling '
              'to find out what exists.',
        ],
      ],
    ),
    DocProse(
      'The rule underneath all three is the same one: every control here is '
      'an [AstryxSwitch](switch) or an [AstryxSelector](selector) and applies '
      'immediately, so there is no Save button anywhere. A form with a Save '
      'button is the other shape entirely — see the '
      '[two-column form](form_two_column).',
    ),
    DocHeading('A rail, not a tab strip'),
    DocProse(
      'These are *places* in a settings area rather than views of one thing, '
      'which is the line between [AstryxSideNav](side_nav) and '
      '[AstryxTabList](tab_list). A rail also holds headings over groups — '
      '**You** and **Workspace** here — and a strip has no room for one.',
    ),
    DocTree('''
Row
├── SizedBox(232) → AstryxSideNav: You · Workspace · Delete workspace
├── AstryxDivider(axis: vertical)
└── Expanded → AstryxLayout(maxContentWidth: 620)
    ├── header ← the section’s title and its one-line description
    └── child  ← switch (_section) → the section’s controls'''),
    DocCallout.warning(
      '**The rail sits beside the layout, not in its `panel`.** '
      '[AstryxLayout](layout) wraps a panel in a scroll view, so a panel is '
      'handed an *unbounded* height — and [AstryxSideNav](side_nav) pins its '
      'own footer with an `Expanded`, which cannot be laid out against one. '
      'Beside the layout, in a `Row` with `crossAxisAlignment: stretch`, the '
      'rail gets the height of the frame, which is what it wants. A panel is '
      'the right slot for content that sizes itself — the filter list on '
      '[library](library), the outline on [documentation](documentation).',
    ),
    DocProse(
      'The section on screen is one field of state and a `switch` expression, '
      'exactly as it is in the dialog. That is what makes a settings area '
      'with a rail no harder to build than one without — and what makes each '
      'section linkable from a route.',
    ),
    DocHeading('The destructive section becomes a destination'),
    DocProse(
      'On the [one-page version](settings) the red card is the last thing on '
      'the page, because that is the only place it can be. Here it is a '
      'navigation row of its own — which is better: nobody scrolls past it by '
      'accident, and nobody has to scroll to it on purpose.',
    ),
    DocCallout.warning(
      'The row is still not the confirmation. It leads to a screen that '
      'states what is lost — eleven members immediately, everything after '
      'thirty days — and an [AstryxAlertDialog](alert_dialog) states it again '
      'before anything happens. "Are you sure?" is a question nobody has ever '
      'answered no to on the strength of the question alone.',
    ),
    DocCallout.accessibility(
      "The rail carries `label: 'Settings sections'`, and the section "
      'heading in the layout header is `level: 1`. Without both, a '
      'screen-reader user moving between sections is told the name of the '
      'application and nothing about where they have just arrived.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Settings](settings) — the same content as one page.',
      '[Settings dialog](settings_dialog) — the same content in a modal.',
      '[AstryxSideNav](side_nav) — the rail, its sections and its rows.',
      '[AstryxSwitch](switch) — and why there is no Save button here.',
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

const DocPage _galleryHero = DocPage(
  id: 'gallery_hero',
  title: 'Gallery hero',
  group: _group,
  description: 'A hero whose supporting content is a media grid.',
  source: 'example/lib/examples/template_media_examples.dart',
  upstreamPath: '/templates/gallery-hero',
  blocks: <DocBlock>[
    DocExample(
      'template_gallery_hero',
      align: DocExampleAlign.stretch,
      note:
          'Page the strip with the controls or the arrow keys: the caption '
          'under it follows, because it is on the page rather than over the '
          'picture.',
    ),
    DocHeading('The pictures are evidence, not decoration'),
    DocProse(
      'A [centred hero](centered_hero) makes a claim and offers one action. '
      'This one makes the same claim and then *shows* it — which is a '
      'different job from a picture behind a headline, and it is why the '
      'media is a strip the reader can page rather than a wall they have to '
      'scan.',
    ),
    DocProse(
      '[AstryxCarousel](carousel) is doing that work: one tab stop, arrow '
      'keys, and a "2 of 3" readout the reader is given rather than left to '
      'infer from how far a scrollbar has moved.',
    ),
    DocCode('''
AstryxCarousel(
  label: 'Product screens',
  height: 260,
  viewportFraction: 0.86,     // ← the next panel peeks, so there is one
  onIndexChanged: (index) => setState(() => _index = index),
  items: <Widget>[for (final shot in _shots) _HeroPanel(shot: shot)],
)'''),
    DocProse(
      '`viewportFraction: 0.86` is the whole affordance. A strip whose items '
      'each fill the viewport looks like one picture, and nobody presses an '
      'arrow to find out whether there is a second.',
    ),
    DocHeading('The caption is on the page'),
    DocProse(
      'The name and the supporting line under the strip are content, and '
      'they change with the panel. Only the panel’s own short title sits over '
      'the picture, through [AstryxMediaTheme](media_theme) — content behind '
      'a scrim is content somebody has already decided was decoration.',
    ),
    DocTree('''
AstryxVStack(gap: spacing8)
├── AstryxCenter(maxWidth: 620)   ← badge, display heading, line, two actions
├── AstryxCarousel(height: 260)   ← the panels
└── AstryxCenter(maxWidth: 620)   ← the current panel’s name and caption'''),
    DocCallout.note(
      'The heading is `type: display2` with `level: 1`. Those are two '
      'different jobs — the display types are the size, the level is the '
      'outline a screen reader navigates — and reaching for a bigger level to '
      'get a bigger size is how a page ends up with three h1s.',
    ),
    DocCallout.accessibility(
      'Every panel carries a `semanticsLabel` on its '
      '[AstryxAspectRatio](aspect_ratio). A hero whose pictures announce '
      'nothing is a hero that reads, to a screen reader, as a headline and '
      'two buttons — which is the [centred hero](centered_hero), not this.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Centred hero](centered_hero) — the same claim, with no media at all.',
      '[AstryxCarousel](carousel) — the paging, the keyboard map and the '
          'position readout.',
      '[Classic gallery](classic_gallery) — media as the content rather than '
          'the evidence.',
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

const DocPage _incidentConsole = DocPage(
  id: 'incident_console',
  title: 'Incident console',
  group: _group,
  description:
      'A live operations view: severity, timeline, and the current on-call.',
  source: 'example/lib/examples/template_console_examples.dart',
  upstreamPath: '/templates/incident-console',
  blocks: <DocBlock>[
    DocExample(
      'template_incident_console',
      align: DocExampleAlign.stretch,
      note:
          'Press a row to change what the timeline and the panel are about. '
          'Leave the page open and the relative times keep moving.',
    ),
    DocHeading('It is left open on a wall'),
    DocProse(
      'That one fact decides everything else about this screen. Nobody is '
      'hovering it, nobody is about to interact with it, and the person who '
      'looks up at it has three seconds. So: nothing important is behind an '
      'interaction, every fact a glance needs is already rendered, and the '
      'clock has to be moving.',
    ),
    DocTable(
      headers: <String>['Because it is live', 'It uses', 'Rather than'],
      rows: <List<String>>[
        <String>[
          'Ages must be current',
          '[AstryxTimestamp](timestamp) with `live: true` — the default',
          'A formatted string, which freezes at load. "41 minutes" that '
              'stopped being true an hour ago is worse than no clock.',
        ],
        <String>[
          'The screen must look alive',
          '`AstryxStatusDot(pulsing: true)` with a real label',
          'An animation with no name. The pulse honours reduced motion; the '
              'words carry the meaning either way.',
        ],
        <String>[
          'Severity must be readable at a glance',
          'A badge reading **Sev-1**, with an icon',
          'A red row. Colour is never the only signal, and the palettes are '
              'categorical rather than severities.',
        ],
      ],
    ),
    DocHeading('One instant, not many nows'),
    DocProse(
      'Every relative stamp on the screen is measured from a single '
      '`DateTime` captured once. Two rows the same age that disagree by a '
      'second is the kind of thing nobody can explain at three in the '
      'morning, and it is what happens when each row asks for the time itself.',
    ),
    DocCode('''
/// A single instant every relative stamp is measured from.
late final DateTime _opened = DateTime.now();

AstryxTimestamp(_opened.subtract(incident.age))'''),
    DocHeading('The panel answers "who has this?"'),
    DocProse(
      'Not a table column — a panel, because it is about the *selected* '
      'incident rather than about all of them. It carries the owner, everyone '
      'else on it as an [AstryxAvatarGroup](avatar_group), the escalation '
      'button, and the error budget the incident is spending.',
    ),
    DocTree('''
AstryxLayout(panelWidth: 280)
├── header ← "Incidents", the live dot, severity filter, declare
├── child
│   ├── one card per incident   ← pressable, selected, always-visible facts
│   └── AstryxSection           ← the timeline of the selected one
└── panel
    ├── on call: owner, AstryxAvatarGroup, page the escalation
    ├── AstryxMetadataList      ← id, service, opened, severity
    └── AstryxProgressBar       ← error budget consumed'''),
    DocCallout.warning(
      '**Every timeline entry names who did it.** "Acknowledged" with no name '
      'is the entry nobody can follow up, and it is the one an operations '
      'screen most often gets wrong — the actor is obvious to the system and '
      'invisible to the reader.',
    ),
    DocCallout.accessibility(
      'The pressable incident card carries a `semanticsLabel` that assembles '
      'the whole row into one sentence — id, severity, title, owner. A '
      'screen-reader user moving down the list hears four rows, not sixteen '
      'nodes, which is the difference between a triage list and a wall of '
      'text.',
    ),
    DocProse(
      'The severity filter is an [AstryxSegmentedControl](segmented_control) '
      'over `int?`, with `null` as **All**. A nullable value type is the '
      'honest way to say "no filter" — it keeps the unfiltered state inside '
      'the same control rather than in a separate clear button beside it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Detail page](detail_page) — one incident, in full.',
      '[Dashboard](dashboard) — the same fleet, summarised rather than live.',
      '[AstryxTimestamp](timestamp) — relative, live, and what `now` is for.',
      '[AstryxStatusDot](status_dot) — the dot, its label, and the pulse.',
    ]),
    _notAWidget,
  ],
);

const DocPage _dashboardPortfolio = DocPage(
  id: 'dashboard_portfolio',
  title: 'Portfolio dashboard',
  group: _group,
  description: 'A dashboard built around a chart and a holdings table.',
  source: 'example/lib/examples/template_chart_examples.dart',
  upstreamPath: '/templates/dashboard-portfolio',
  blocks: <DocBlock>[
    DocExample(
      'template_dashboard_portfolio',
      align: DocExampleAlign.stretch,
      note:
          'Change the range: the chart, the headline change and its colour all '
          'move together. Sort the table by pressing a column header.',
    ),
    DocCallout.warning(
      '**`astryx_ui` ships no charting widget, and does not intend to.** A '
      'chart is a domain of its own — scales, axes, ticks, legends, tooltips, '
      'and an accessibility story for all of them — and a design system that '
      'shipped half of one would be shipping something nobody could finish. So '
      'this screen draws its own, in about forty lines of `CustomPainter`, and '
      'the point of that painter is not that it is good. It is that the seam '
      'is visible: swap it for your charting package and nothing around it '
      'changes.',
    ),
    DocHeading('A painter takes tokens, not colours'),
    DocProse(
      'This is the whole rule for wiring up a chart library, and it is the one '
      'that gets broken first. Resolve the colours in `build`, from the token '
      'layer, and hand them to the painter. A painter holding a hex is right '
      'in one theme out of eight and one brightness out of two — and nobody '
      'notices until somebody switches to dark mode in a meeting.',
    ),
    DocCode('''
CustomPaint(
  painter: _TrendPainter(
    values: values,
    line: theme.color(color),
    fill: theme.color(color).withValues(alpha: 0.14),
    baseline: theme.color(AstryxColorToken.border),
  ),
)'''),
    DocHeading('The headline figure is text'),
    DocProse(
      'The portfolio total is an `AstryxText` at display size, above the '
      'chart, and the change beside it is a badge with an arrow. A dashboard '
      'whose headline number can only be read off a curve is a dashboard '
      'nobody can quote — and the curve is what a reader uses to *check* that '
      'number, not to discover it.',
    ),
    DocTree('''
AstryxVStack(gap: spacing6)
├── the total, the change badge, the range control
├── AstryxCard → TrendChart, with the first and last value in the footer
├── AstryxSection("Allocation") → one AstryxProgressBar per sector
└── AstryxSection("Holdings")   → AstryxTable, sorted in the caller'''),
    DocHeading('Bars, not a pie'),
    DocProse(
      'The allocation section is a stack of [progress bars](progress_bar), '
      'one per sector, each with its percentage and its value in the label. '
      'A proportion the reader can compare against the one beneath it beats a '
      'wedge nobody can measure — and a progress bar is already a proportion '
      'with an announced label, so there was nothing to draw.',
    ),
    DocCallout.accessibility(
      '`TrendChart` takes a required `label` **and** a required '
      '`semanticsValue`, and the value is the chart in a sentence: "From '
      '£31.2k to £40.1k, +28.53%". Everything a sighted reader takes from the '
      'shape is stated there instead. The painter itself sits inside an '
      '`ExcludeSemantics`, because a canvas has nothing to announce.',
    ),
    DocProse(
      'The change column pairs its colour with an arrow and a sign. Red and '
      'green are the two hues most colour-blind readers cannot separate, and '
      'a gains column is exactly where that matters.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Dashboard](dashboard) — the same shape with no chart at all, carried '
          'by tiles.',
      '[Table page with chart](table_page_chart) — the same painter over a '
          'paginated table.',
      '[AstryxProgressBar](progress_bar) — the proportion, and its label.',
      '[Design tokens](tokens) — reaching a colour when no widget owns it.',
    ]),
    _notAWidget,
  ],
);

const DocPage _tableGrouped = DocPage(
  id: 'table_grouped',
  title: 'Grouped table',
  group: _group,
  description: 'A table whose rows are grouped under collapsible headers.',
  source: 'example/lib/examples/template_grouped_table_examples.dart',
  upstreamPath: '/templates/table-grouped',
  blocks: <DocBlock>[
    DocExample(
      'template_table_grouped',
      align: DocExampleAlign.stretch,
      note:
          'Sort by Amount and every group reorders. Tick rows in two different '
          'groups: the count in the bar is the whole screen’s.',
    ),
    DocHeading('Not one table with special rows'),
    DocProse(
      '[AstryxTable](table) has no row grouping, and the usual workaround — a '
      'data row drawn to look like a header — is worse than not having the '
      'feature. A screen reader announces it as data. Sorting moves it into '
      'the middle of the set. The checkbox column offers to select it. It is a '
      'header in appearance only, and every one of those is a bug the reader '
      'finds before you do.',
    ),
    DocProse(
      'So this is **one table per group**, each inside an '
      '[AstryxCollapsible](collapsible). The group header is then a real '
      'disclosure: it can carry a count, a subtotal and a share of the whole '
      'without any of them pretending to be a row.',
    ),
    DocTree('''
AstryxCollapsibleGroup
├── AstryxCollapsible("Platform", description: "3 lines · £6,646.00")
│   └── AstryxTable  ← the Platform rows
├── AstryxCollapsible("Sales",    …)
│   └── AstryxTable  ← the Sales rows
└── AstryxCollapsible("Design",   …)
    └── AstryxTable  ← the Design rows'''),
    DocCallout.warning(
      '**Declare the columns once and give them widths.** Each table works out '
      'its own layout from its own rows, so a column left to size itself is '
      'one width under Platform and another under Design — and a grouped table '
      'whose columns do not line up is a stack of unrelated tables. Every '
      'column here except the first takes an '
      '`AstryxTableColumnWidth.fixed`, and all four groups share one '
      '`List<AstryxTableColumn>`.',
    ),
    DocHeading('One sort, one selection, however many tables'),
    DocProse(
      'Both live on the screen’s state rather than inside a table, which is '
      'what makes the group boundaries invisible to the reader: a sort press '
      'in one group reorders all of them, and a selection survives crossing '
      'from one to the next.',
    ),
    DocCode('''
onSelectionChanged: (value) => setState(() {
  // The set is the whole screen's, so a group's "select all" has to add
  // its own keys without dropping anyone else's.
  final keys = group.rows.map((row) => row.id).toSet();
  _selected = <Object>{
    ..._selected.where((key) => !keys.contains(key)),
    ...value.where(keys.contains),
  };
}),'''),
    DocProse(
      'That merge is the one piece of real work on the page, and it is the '
      'piece a single grouped table would have done for you. It is four lines, '
      'and it is the price of the header rows being honest.',
    ),
    DocHeading('Grouping is the caller’s decision'),
    DocProse(
      'The **Group by** control switches between team and status, and the '
      'buckets are rebuilt from the same rows. A table cannot work out which '
      'field is worth grouping by — that is a fact about the question being '
      'asked, not about the data.',
    ),
    DocCallout.accessibility(
      'Each table is named for its group — "Platform expenses", not '
      '"Expenses". Four tables sharing one name is four identical '
      'announcements, and a reader who tabs into the third has no way to tell '
      'which they are in.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Table](table_template) — the ungrouped version, with filters and row '
          'actions.',
      '[AstryxCollapsibleGroup](collapsible_group) — the sections, and the '
          'accordion behaviour.',
      '[AstryxTable](table) — the sort cycle, the selection and the widths.',
    ]),
    _notAWidget,
  ],
);

const DocPage _tablePageChart = DocPage(
  id: 'table_page_chart',
  title: 'Table page with chart',
  group: _group,
  description: 'A table screen with a summary chart above it.',
  source: 'example/lib/examples/template_chart_examples.dart',
  upstreamPath: '/templates/table-page-chart',
  blocks: <DocBlock>[
    DocExample(
      'template_table_page_chart',
      align: DocExampleAlign.stretch,
      note:
          'Turn the page: the rows change and the chart does not. Filter by '
          'desk and the page resets to one.',
    ),
    DocHeading('The chart summarises the set, not the page'),
    DocProse(
      'This is the decision the screen is built around, and the one that is '
      'usually got wrong. A chart that redrew every time the reader turned a '
      'page would be a chart *of that page* — which the page already is, in '
      'more detail. The summary is only worth its space if it says something '
      'the rows on screen cannot.',
    ),
    DocTree('''
AstryxLayout(scrollable: false)
├── header ← title, desk filter, and the chart, in a muted card
├── child  ← AstryxTable, scrolling its own body
└── footer ← "1–5 of 12" and AstryxPagination'''),
    DocProse(
      'The chart lives in the pinned header for the same reason the filters '
      'do: on a screen where the table is the work, a summary you have to '
      'scroll up to reach is a summary nobody consults.',
    ),
    DocHeading('Every filter resets the page'),
    DocCode('''
void _refilter(VoidCallback change) => setState(() {
  change();
  _page = 1;      // ← the whole point
});'''),
    DocProse(
      'Without it, narrowing a twelve-row set while on page three shows an '
      'empty table — which reads as "no data" rather than "you are past the '
      'end", and is the single most common bug on a screen like this.',
    ),
    DocCallout.warning(
      '**`scrollable: false`.** [AstryxTable](table) scrolls its own body '
      'under its header row. Leaving the layout scrollable puts one scroll '
      'view inside another, and the inner one then measures unbounded — a '
      'layout assertion rather than a subtle bug.',
    ),
    DocCallout.accessibility(
      'The chart is a `TrendChart` with a `semanticsValue` that states the '
      'shape in words — where it starts, where it ends, and where the '
      'drawdowns are. The same painter, and the same rule, as the '
      '[portfolio dashboard](dashboard_portfolio): the picture is never the '
      'only copy of the fact.',
    ),
    DocProse(
      'The limit column is a badge with an icon and a word — *Breached* or '
      '*Within* — rather than a red row. A row tinted by its status is a row '
      'whose status is invisible in greyscale and unreadable to a screen '
      'reader.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Table page](table_page) — the same screen with no chart.',
      '[Portfolio dashboard](dashboard_portfolio) — the same painter, and the '
          'note about why there is no chart component.',
      '[AstryxPagination](pagination) — one-based pages, and the disabled '
          'ends.',
    ]),
    _notAWidget,
  ],
);

const DocPage _tablePageHeatmapStatus = DocPage(
  id: 'table_page_heatmap_status',
  title: 'Table page with heatmap',
  group: _group,
  description:
      'A table screen whose cells carry heatmap and status colouring.',
  source: 'example/lib/examples/template_heatmap_examples.dart',
  upstreamPath: '/templates/table-page-heatmap-status',
  blocks: <DocBlock>[
    DocExample(
      'template_table_page_heatmap_status',
      align: DocExampleAlign.stretch,
      note:
          'Filter by owner and turn the page: a cell keeps its colour, because '
          'the scale spans the whole grid rather than what is on screen.',
    ),
    DocCallout.warning(
      '**There is no heatmap component, and no colour scale in the token '
      'system either.** The ten [palette](color) families are *categorical* — '
      '"the Red team" — so none of them is a ramp, and picking one would be '
      'asserting a severity the data has not got. What a heatmap needs is a '
      'continuous scale between two tokens, and that is one `Color.lerp`.',
    ),
    DocCode('''
final fill = Color.lerp(
  theme.color(AstryxColorToken.backgroundMuted),   // the page's own ground
  theme.color(tint),                               // error, or success
  intensity.clamp(0.0, 1.0),
)!;

// Past about half way the ground is dark enough that the page's text
// colour stops being legible on it, and the paired foreground takes over.
final foreground = intensity > 0.55
    ? theme.color(onTint)
    : theme.color(AstryxColorToken.textPrimary);'''),
    DocProse(
      'Both ends are tokens, so the ramp moves with the theme and the '
      'brightness instead of being correct only in the one it was picked in. '
      '`onError` is the foreground paired with `error` — every filled token in '
      'the system has one, and reaching for a ground without its pair is how '
      'contrast is lost.',
    ),
    DocHeading('Text on a ground you painted yourself'),
    DocProse(
      '[AstryxText](text) takes a token, not a `Color`, which is deliberate. '
      'The way to put text on a surface of your own is to set the ambient '
      'style and ask for `AstryxTextColor.inherit` — the same route '
      '[AstryxMediaTheme](media_theme) takes over a photograph.',
    ),
    DocCode('''
DefaultTextStyle.merge(
  style: TextStyle(color: foreground),
  child: AstryxText(text, color: AstryxTextColor.inherit),
)'''),
    DocHeading('The scale spans the grid, not the page'),
    DocProse(
      'The busiest cell in the *whole* data set is what one maps to. A ramp '
      'recomputed per page would recolour every cell when the reader turned '
      'it: the same 412 ms pale on one page and saturated on the next, which '
      'makes the colour a fact about the page rather than about the number.',
    ),
    DocHeading('Two kinds of colour, and they must not look alike'),
    DocTable(
      headers: <String>['Column', 'Colour means', 'Drawn as'],
      rows: <List<String>>[
        <String>[
          'The five regions',
          'Where this value sits on a continuous scale',
          'A `HeatCell` — a ground lerped toward `error`, with the figure on '
              'top.',
        ],
        <String>[
          'Objective',
          'A threshold somebody agreed',
          'An [AstryxBadge](badge) with an icon and a word. *Breaching* is not '
              'a position on a ramp.',
        ],
      ],
    ),
    DocCallout.accessibility(
      '**Every cell prints its own number, and the screen carries a legend.** '
      'The figure is the half of the cell that survives greyscale, a '
      'screenshot and a colour-blind reader; the legend is what says which end '
      'of the ramp is which, because a hue does not imply a direction. Each '
      'cell also announces itself in full — "902 milliseconds in us-east" — '
      'rather than reading out a bare number in a grid whose column headers '
      'are somewhere above.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Retail heatmap table](table_page_shoe_store_heatmap) — the same screen '
          'with the ramp running the other way.',
      '[Table page](table_page) — the frame, without the colouring.',
      '[Colour](color) — the semantic roles, and why the palettes are not '
          'severities.',
    ]),
    _notAWidget,
  ],
);

const DocPage _tablePageShoeStoreHeatmap = DocPage(
  id: 'table_page_shoe_store_heatmap',
  title: 'Retail heatmap table',
  group: _group,
  description: 'The heatmap table screen with a retail data set.',
  source: 'example/lib/examples/template_heatmap_examples.dart',
  upstreamPath: '/templates/table-page-shoe-store-heatmap',
  blocks: <DocBlock>[
    DocExample(
      'template_table_page_shoe_store_heatmap',
      align: DocExampleAlign.stretch,
      note:
          'Filter by range: the busiest size in the header is recomputed, and '
          'the ramp is not.',
    ),
    DocHeading('The same widget, the opposite meaning'),
    DocProse(
      'This screen and the [latency heatmap](table_page_heatmap_status) share '
      '`HeatCell` and `HeatLegend` exactly. What differs is the direction of '
      'the value: high latency is bad and runs toward `error`, high sales are '
      'good and run toward `success`.',
    ),
    DocCallout.warning(
      '**Which is why the legend is not decoration.** A hue does not imply a '
      'direction — a reader arriving at a saturated grid has no way to know '
      'whether they are looking at a triumph or a fire. The legend states both '
      'ends in words, and the header states the conclusion outright.',
    ),
    DocHeading('Say the answer, then show the grid'),
    DocProse(
      '"Busiest size: UK 9" sits above the table, in text, and it is '
      'recomputed from whatever the filters have left. A heatmap is a good way '
      'for a reader to *check* an answer and a poor way to be told one — the '
      'grid is the evidence, and the sentence is the finding.',
    ),
    DocTree('''
AstryxLayout(scrollable: false)
├── header ← the finding, the range filter, HeatLegend(success)
├── child  ← AstryxTable: style · six sizes · stock
└── footer ← the count, and AstryxPagination'''),
    DocHeading('The stock column is a threshold, not a scale'),
    DocProse(
      'Zero is *Out of stock* in the error variant, under fifty is "12 left" '
      'as a warning, and anything else is a success badge. Those are three '
      'decisions somebody made about a business, and a ramp would blur them '
      'into a gradient that means nothing at either end.',
    ),
    DocCode(r'''
cellBuilder: (context, row) => switch (row.stock) {
  0 => const AstryxBadge('Out of stock', variant: AstryxBadgeVariant.error, …),
  < 50 => AstryxBadge('\${row.stock} left', variant: AstryxBadgeVariant.warning, …),
  _ => AstryxBadge('\${row.stock} in stock', variant: AstryxBadgeVariant.success, …),
},'''),
    DocCallout.accessibility(
      'Each cell announces "141 pairs in UK 9". A screen-reader user moving '
      'across a row of six figures has no column header in earshot, so a cell '
      'that announces only its number has told them a number about nothing.',
    ),
    DocProse(
      'Every size column is sortable, because ranking one size across every '
      'style is the second question this screen gets asked — and a column is '
      'sortable only if it has a `compare`.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Table page with heatmap](table_page_heatmap_status) — the same widgets '
          'with the ramp reversed, and the notes on how it is built.',
      '[Product gallery](product_gallery) — the shop these figures come from.',
      '[AstryxBadge](badge) — the variants, and what each one claims.',
    ]),
    _notAWidget,
  ],
);

const DocPage _kanbanBoard = DocPage(
  id: 'kanban_board',
  title: 'Kanban board',
  group: _group,
  description: 'Columns of draggable cards.',
  source: 'example/lib/examples/template_board_examples.dart',
  upstreamPath: '/templates/kanban-board',
  blocks: <DocBlock>[
    DocExample(
      'template_kanban_board',
      align: DocExampleAlign.stretch,
      note:
          'Drag a card between columns — and then do the same thing from the '
          'menu on the card, which is the path that works without a pointer.',
    ),
    DocCallout.warning(
      '**Nothing in `astryx_ui` moves under a pointer, and nothing needs to.** '
      'Dragging is a gesture, not a surface: `Draggable` and `DragTarget` '
      'already live in `flutter/widgets`, and a design system that wrapped '
      'them would be adding a name rather than a capability. This template '
      'uses the framework’s own, with `astryx_ui` cards riding on top.',
    ),
    DocHeading('The drag is the enhancement; the menu is the feature'),
    DocProse(
      'A drag is a pointer affordance and nothing else. No keyboard reaches '
      'it, no screen reader announces it, and a touch user gets a long-press '
      'at best. A board that can only be rearranged by dragging is a board '
      'that a good share of a team cannot use at all — and it is the single '
      'most common accessibility failure of this whole screen shape.',
    ),
    DocProse(
      'So every card carries an [AstryxMoreMenu](more_menu) listing the other '
      'columns, and both routes call the same function. The board is one '
      '`Map<String, String>`, and a drag and a menu row are the same edit to '
      'it.',
    ),
    DocCode(r'''
/// The one edit this screen makes. A drag calls it; so does a menu row.
void _move(String ticket, String lane) {
  if (_lane[ticket] == lane) return;
  setState(() => _lane[ticket] = lane);
  AstryxToastScope.of(context).show(
    AstryxToast(message: '\$ticket moved to \$title'),
  );
}'''),
    DocProse(
      'The toast is the other half of the accessibility story. A drop is '
      'silent and a menu press is silent, so without it neither route '
      'confirms anything — and a card that moved somewhere off screen has, as '
      'far as the reader knows, vanished.',
    ),
    DocHeading('The column says where to let go'),
    DocProse(
      'A `DragTarget` builder gets the candidates hovering over it, and the '
      'column swaps `muted` for `standard` and takes one step of elevation '
      'while one is there. This is the one place a hover-only signal is '
      'allowed: it is feedback *during* a gesture only a pointer can perform, '
      'and it says nothing the menu route does not also say.',
    ),
    DocTree('''
AstryxLayout(scrollable: false)
└── horizontal scroller
    └── one _Lane per column, 268 wide
        └── DragTarget<String>
            └── AstryxCard(variant: active ? standard : muted)
                ├── header ← the title, and the WIP badge
                └── Draggable<String> per ticket
                    └── AstryxCard ← id, AstryxMoreMenu, title, assignee'''),
    DocHeading('The limit is a number and a word'),
    DocProse(
      'A column with a work-in-progress limit shows `2/2`, and turns to the '
      'warning variant with an icon when it is over. A column that turned red '
      'and said nothing is a rule the reader cannot look up — and the badge’s '
      '`semanticsLabel` spells it out: "3 of 2, over the limit".',
    ),
    DocCallout.accessibility(
      'The move menu is named for its ticket — "Move ATL-412", not "More". '
      'Seven identical **More** buttons on one board is seven identical '
      'announcements, and the reader has no way to tell which card they are '
      'about to move.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Incident console](incident_console) — work that arrives rather than '
          'being planned.',
      '[Table](table_template) — the same tickets when the question is '
          '"which", not "where".',
      '[AstryxMoreMenu](more_menu) — the trigger’s name, its tooltip and the '
          'menu’s name.',
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

const DocPage _mixedGallery = DocPage(
  id: 'mixed_gallery',
  title: 'Mixed gallery',
  group: _group,
  description: 'A gallery of items at mixed sizes.',
  source: 'example/lib/examples/template_media_examples.dart',
  upstreamPath: '/templates/mixed-gallery',
  blocks: <DocBlock>[
    DocExample(
      'template_mixed_gallery',
      align: DocExampleAlign.stretch,
      note:
          'Press any tile: the viewer opens on it, and shows it at the same '
          'shape the tile did.',
    ),
    DocHeading('The sizes differ because the pictures do'),
    DocProse(
      'This is the whole argument for the screen. A panorama cropped to a '
      'square is a panorama nobody can read; a portrait letterboxed into 16:9 '
      'is mostly ground. The [classic gallery](classic_gallery) is right when '
      'the items really are interchangeable — this one is right when they are '
      'not, and pretending otherwise loses information.',
    ),
    DocCode('''
typedef Shot = ({String name, String caption, double ratio});

// Each item carries its own ratio *and* its own width. The row wraps
// around whatever those turn out to be.
(shot: (name: 'Cold aisle, full length', ratio: 32 / 9), width: 420),
(shot: (name: 'Rack 14, door open',      ratio:  3 / 4), width: 170),'''),
    DocCallout.warning(
      '**Not an [AstryxGrid](grid).** A grid gives every cell in a row the '
      'height of the tallest — which is precisely what this screen exists not '
      'to do. (It also measures each cell intrinsically, and a pressable tile '
      'sits inside the touch-target wrapper, which cannot answer that '
      'measurement in touch density.) A wrapping `AstryxHStack` of '
      'fixed-width tiles is the shape.',
    ),
    DocHeading('The viewer keeps the promise the wall made'),
    DocProse(
      'Each [AstryxLightbox](lightbox) item is drawn at its own ratio too. A '
      'gallery that mixes shapes on the wall and squares them in the viewer '
      'has lied about one of the two, and the reader finds out at exactly the '
      'moment they wanted a closer look.',
    ),
    DocProse(
      'One viewer sits beside the wall and takes the whole list — a tile sets '
      'an index and shows it. Five tiles with five lightboxes is five overlay '
      'controllers, five focus traps, and a good chance of two being open at '
      'once.',
    ),
    DocCallout.accessibility(
      'The tile’s `semanticsLabel` is the name *and* the caption as one '
      'sentence: "Cold aisle, full length, Panorama · 8064 × 2268". The size '
      'and shape of a picture are facts about it, and on this screen they are '
      'the facts the layout is conveying visually — so they have to be '
      'conveyed some other way as well.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Classic gallery](classic_gallery) — the uniform wall, and when it is '
          'right.',
      '[Side gallery](side_gallery) — one at a time, with the rest beside it.',
      '[AstryxAspectRatio](aspect_ratio) — the box, the ground and the clip.',
    ]),
    _notAWidget,
  ],
);

const DocPage _sideGallery = DocPage(
  id: 'side_gallery',
  title: 'Side gallery',
  group: _group,
  description: 'A gallery with the selected item beside the strip.',
  source: 'example/lib/examples/template_media_examples.dart',
  upstreamPath: '/templates/side-gallery',
  blocks: <DocBlock>[
    DocExample(
      'template_side_gallery',
      align: DocExampleAlign.stretch,
      note:
          'Narrow the window past 640: the strip moves from the trailing edge '
          'to under the picture, and the selection is untouched.',
    ),
    DocHeading('For comparing, not for browsing'),
    DocProse(
      'A wall is for finding one item among many. This is for going back and '
      'forth between four — which is what "evidence" means on an incident, '
      'and why the item on screen never leaves it. An '
      '[AstryxLightbox](lightbox) would be wrong here: a modal that has to be '
      'closed between comparisons is a modal the reader stops using.',
    ),
    DocTree('''
LayoutBuilder
├── wide   → AstryxHStack ── Expanded  → the viewer
│                         └── SizedBox(132) → the strip, vertical
└── narrow → AstryxVStack ── the viewer, then the strip, horizontal'''),
    DocProse(
      'One widget, one selection, and only the axis moves. The breakpoint is '
      'a `LayoutBuilder` and one constant — the width at which a picture and '
      'a strip stop both fitting is a fact about this screen, not an entry in '
      'a table every other screen has to agree with.',
    ),
    DocHeading('The strip is thumbnails, and `selected` is the mark'),
    DocProse(
      '[AstryxThumbnail](thumbnail) draws the current one as a ring rather '
      'than a tint, and that is not a style choice: a tint over a picture is '
      'a change to the picture, and on a screen whose whole job is comparing '
      'pictures that is the one thing that must not happen.',
    ),
    DocCode('''
AstryxThumbnail(
  label: shots[i].name,          // required — the accessible name
  ratio: 16 / 9,
  width: vertical ? 116 : 104,
  selected: i == index,          // ← a ring, not a tint
  onPressed: () => onSelected(i),
)'''),
    DocCallout.accessibility(
      'The count — "2 of 4" — is on the page in text, beside the heading. A '
      'reader who cannot see which thumbnail has the ring still needs to know '
      'where they are in the set, and a selected state alone does not say how '
      'many there are.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Mixed gallery](mixed_gallery) — everything at once, at its own size.',
      '[Product detail](product_detail) — the same shape, with a price beside '
          'it.',
      '[AstryxThumbnail](thumbnail) — the tile, the caption and the selected '
          'state.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Commerce
// ---------------------------------------------------------------------------

const DocPage _productGallery = DocPage(
  id: 'product_gallery',
  title: 'Product gallery',
  group: _group,
  description: 'A filterable grid of products.',
  source: 'example/lib/examples/template_commerce_examples.dart',
  upstreamPath: '/templates/product-gallery',
  blocks: <DocBlock>[
    DocExample(
      'template_product_gallery',
      align: DocExampleAlign.stretch,
      note:
          'Drag the price range down to nothing to see the empty state, which '
          'offers the way out rather than describing the problem.',
    ),
    DocHeading('The wall does not filter itself'),
    DocProse(
      'Search, the category boxes, the price range and the stock tick all '
      'narrow the list in the caller, and the result is what gets rendered. '
      'That is the same rule the [table](table_template) template is built '
      'on, and for the same reason: a wall that filtered itself could not '
      'tell "nothing matched" from "nothing to sell", and those need '
      'different words and a different way out.',
    ),
    DocProse(
      'The empty state here says the products are still there and the filters '
      'are what is hiding them — then offers one button that clears them. An '
      'empty state that only describes the problem leaves the reader to work '
      'out which of four controls to undo.',
    ),
    DocHeading('Which control for which filter'),
    DocTable(
      headers: <String>['Filter', 'Control', 'Because'],
      rows: <List<String>>[
        <String>[
          'Category',
          '[AstryxCheckboxList](checkbox_list)',
          'Several at once, all worth seeing. One label and one validation '
              'state over the group.',
        ],
        <String>[
          'Price',
          '`AstryxSlider.range`',
          'Two values that constrain each other. `formatValue` gives both the '
              'label and the announcement — a thumb that announces "84" is a '
              'thumb about nothing.',
        ],
        <String>[
          'In stock',
          '[AstryxCheckbox](checkbox)',
          'One of a set of filters rather than a setting of its own — which '
              'is why it is not a [switch](switch), even though it applies '
              'immediately.',
        ],
        <String>[
          'Sort',
          '[AstryxSelector](selector)',
          'Picks a value and shows the current one. A '
              '[menu](dropdown_menu) performs actions and reports nothing.',
        ],
      ],
    ),
    DocCallout.accessibility(
      'A tile carries one `semanticsLabel` — name, price, rating, and "out of '
      'stock" when it applies — instead of four separate nodes. Somebody '
      'moving through a wall of eight products hears eight sentences rather '
      'than thirty-two fragments they have to reassemble.',
    ),
    DocCallout.warning(
      '**The wall is a wrapping row, not an [AstryxGrid](grid).** Each tile is '
      'pressable, and a pressable widget sits inside the touch-target '
      'wrapper, which cannot answer the intrinsic measurement a grid row '
      'needs in touch density. Uniform tiles look identical either way.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Product detail](product_detail) — where a tile leads.',
      '[Library](library) — the same filter-beside-results shape, for things '
          'you already own.',
      '[AstryxEmptyState](empty_state) — the title, the line and the way out.',
    ]),
    _notAWidget,
  ],
);

const DocPage _productDetail = DocPage(
  id: 'product_detail',
  title: 'Product detail',
  group: _group,
  description: 'Gallery, price, options, and the add-to-cart action.',
  source: 'example/lib/examples/template_commerce_examples.dart',
  upstreamPath: '/templates/product-detail',
  blocks: <DocBlock>[
    DocExample(
      'template_product_detail',
      align: DocExampleAlign.stretch,
      note:
          'Press **Add to basket** without choosing a size to see the '
          'validation, then choose one. Narrow the window past 720 and the '
          'two columns become one.',
    ),
    DocHeading('One button spends money'),
    DocProse(
      'Everything else on the screen changes what is *shown*: a thumbnail, a '
      'size, a quantity, a collapsed section. Exactly one control commits the '
      'reader to anything, it is the only `primary` button on the page, and '
      'its label says what it is about to do — including the figure.',
    ),
    DocCode(r'''
AstryxButton(
  label: 'Add to basket · ${money(_price * quantity)}',
  variant: AstryxButtonVariant.primary,
  size: AstryxButtonSize.lg,
  onPressed: () => _add(context),
)'''),
    DocHeading('Validate on submit, not on arrival'),
    DocProse(
      'Nothing is red until **Add to basket** has been pressed once. A page '
      'that marks the size field invalid before the reader has looked at it '
      'is telling them off for arriving — and the same rule the '
      '[login](login) template follows for exactly the same reason.',
    ),
    DocHeading('Out of stock is disabled, not missing'),
    DocProse(
      'The UK 10 option is `enabled: false` with a description saying when it '
      'comes back. Removing it instead would leave the reader wondering '
      'whether it ever existed — and "do you make my size at all" is a '
      'different question from "can I have it today".',
    ),
    DocProse(
      'Sizes are an [AstryxRadioList](radio_list) rather than an '
      '[AstryxSelector](selector): four options, all worth seeing at once. A '
      'size behind a dropdown is a size the reader has to go looking for.',
    ),
    DocHeading('Figures'),
    DocProse(
      'Every price is `tabularNumbers: true`, and the was-price is its own '
      'node with its own words — "£150.00 before the discount" — rather than '
      'a strikethrough on the same one. A screen reader given "£125.00 '
      '£150.00" with no explanation has said the wrong thing twice.',
    ),
    DocTree('''
AstryxVStack
├── AstryxBreadcrumbs
└── LayoutBuilder
    ├── wide   → AstryxHStack ── Expanded          → media
    │                         └── SizedBox(340)    → the details column
    └── narrow → AstryxVStack ── media, then details

media   = a large AstryxAspectRatio (pressable → AstryxLightbox)
          + a row of AstryxThumbnails
details = price · size · quantity · add · AstryxCollapsibleGroup'''),
    DocCallout.note(
      'The details below the button are an '
      '[AstryxCollapsibleGroup](collapsible_group) rather than three headings '
      'and three paragraphs. Everything a reader might want and most will '
      'not, collapsed, keeps the page below the primary action short enough '
      'to end.',
    ),
    DocCallout.accessibility(
      'The confirmation is a [toast](toast) that names what was added and how '
      'many — "Added 2 × Trail Runner GTX, UK 9 to the basket". A basket '
      'count that silently increments in a corner is a change half the '
      'readers of the page will not notice at all.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Product gallery](product_gallery) — where this page is opened from.',
      '[Payment form](payment_form) — the screen after the basket.',
      '[Side gallery](side_gallery) — the same media shape without a price '
          'beside it.',
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

const DocPage _aiChatLanding = DocPage(
  id: 'ai_chat_landing',
  title: 'AI chat landing',
  group: _group,
  description:
      'The pre-conversation screen: prompt suggestions and a centred composer.',
  source: 'example/lib/examples/template_chat_examples.dart',
  upstreamPath: '/templates/ai-chat-landing',
  blocks: <DocBlock>[
    DocExample(
      'template_ai_chat_landing',
      align: DocExampleAlign.stretch,
      note:
          'Press a suggestion, or type something: the composer moves from the '
          'middle of the page to the bottom of a transcript. **New chat** '
          'brings the landing back.',
    ),
    DocHeading('Not the same as an empty state'),
    DocProse(
      'The [AI chat](ai_chat) template has an `empty:` slot, and it is a slot '
      '*above a composer pinned to the bottom*. This screen is the other '
      'thing: there is no transcript for the composer to be beneath, so it '
      'goes where the reader is already looking — the middle of the page.',
    ),
    DocProse(
      'Which to build is a question about what the product is. If the '
      'conversation is a feature inside an application, the empty slot is '
      'right: the frame stays put and the transcript fills in. If the '
      'conversation *is* the application, the landing is right, and the '
      'handover to the transcript is a real change of screen.',
    ),
    DocCallout.note(
      '**It is the same [AstryxChatComposer](chat_composer) in both states.** '
      'A landing that drew its own input would be a second field with its own '
      'Enter handling, its own send button, its own disclaimer and its own '
      'bugs — and the reader would notice the swap at exactly the moment they '
      'pressed Enter.',
    ),
    DocHeading('Suggestions are grouped, and each one sends itself'),
    DocProse(
      'Twelve ungrouped prompts is a menu nobody reads. Three groups of two '
      'or three — **Diagnose**, **Summarise**, **Write** — is a statement '
      'about what the assistant is *for*, which is the actual question a '
      'first-time reader has.',
    ),
    DocProse(
      'Every suggestion is an [AstryxButton](button) that sends its own text. '
      'A prompt you have to retype is a prompt nobody uses, and placeholder '
      'text that vanishes the moment you type is not a suggestion at all.',
    ),
    DocTree('''
AstryxCenter(maxWidth: 680)          ← before the first turn
├── heading + one supporting line
├── AstryxChatComposer               ← in the middle of the page
├── AstryxSection per group          ← the prompt buttons
└── AstryxSection("Recent")          ← AstryxList of previous threads

AstryxLayout(scrollable: false)      ← after it
└── AstryxChatLayout(messages:, composer:)   ← the same composer, pinned'''),
    DocProse(
      'The **Recent** list is the other half of a landing: for anybody who '
      'has used the product before, going back to a thread is the more likely '
      'errand than starting a new one, and it should not require remembering '
      'what the thread was called.',
    ),
    DocCallout.accessibility(
      'The composer takes an explicit `label` — "Ask a question" — because '
      'its placeholder disappears the moment anything is typed. A field whose '
      'only name is its placeholder is a field with no name for exactly the '
      'reader who most needs one.',
    ),
    DocProse(
      'The disclaimer is in the composer’s `footer` on both screens. It is a '
      'standing fact about every answer, and the moment it matters is the '
      'moment somebody is about to ask — not a [banner](banner) at the top '
      'they scrolled past on the way here.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AI chat](ai_chat) — the conversation, with tool calls and citations.',
      '[AstryxChatComposer](chat_composer) — Enter, Shift+Enter, generating '
          'and stop.',
      '[AstryxChatLayout](chat_layout) — the transcript, and the `empty:` '
          'slot this screen is the alternative to.',
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

const DocPage _shellSideNav = DocPage(
  id: 'shell_side_nav',
  title: 'Shell with side nav',
  group: _group,
  description: 'The shell with a vertical rail only.',
  source: 'example/lib/examples/template_shell_variant_examples.dart',
  upstreamPath: '/templates/shell-side-nav',
  blocks: <DocBlock>[
    DocExample(
      'template_shell_side_nav',
      align: DocExampleAlign.stretch,
      note:
          'Collapse the rail with the control under the account row, or '
          'narrow the window past 680 to send it behind the drawer the menu '
          'button in the page header opens.',
    ),
    DocHeading('One bar, and it is vertical'),
    DocProse(
      'The [shell navigation](shell_nav) template has both bars. Most '
      'applications need one, and which one is a fact about how many '
      'destinations there are rather than a matter of taste. A rail is right '
      'when the list is long enough to need headings, or deep enough to need '
      'indenting — a bar has room for neither.',
    ),
    DocTree('''
AstryxAppShell(compactBelow: 680)   ← no `header:` at all
├── sidebar ← AstryxSideNav
│   ├── header ← AstryxNavHeadingMenu: the workspace switcher
│   ├── rows   ← sections, indented children, a badge
│   └── footer ← the account row, pinned above the collapse control
└── child   ← AstryxLayout: the page, and its own header'''),
    DocProse(
      'Everything a top bar would have carried is in the rail: identity at '
      'the top through [AstryxNavHeadingMenu](nav_heading_menu), the account '
      'at the bottom. A full-width band holding only a logo is a band spent '
      'on nothing.',
    ),
    DocHeading('Where the menu button goes when there is no header'),
    DocProse(
      'The shell still moves the rail behind a drawer when the window is '
      'narrow — but with no shell header, there is nowhere obvious to put the '
      'control that opens it. It goes in the *page’s* own header, and '
      '[AstryxMobileNavToggle](mobile_nav) with no `controller` reaches for '
      'the enclosing shell’s.',
    ),
    DocCode('''
final shell = AstryxAppShell.of(context);

if (shell.compact)
  const AstryxMobileNavToggle(       // ← no controller: it finds the shell's
    label: 'Open navigation',
    size: AstryxButtonSize.sm,
  ),'''),
    DocCallout.note(
      '`sidebarWidth` moves with the collapsed state — `_collapsed ? 72 : '
      '244` — because the rail does not decide its own width. The content '
      'column is the other half of that decision, and only the shell knows '
      'about both.',
    ),
    DocHeading('Children indent here; on a bar they would be a menu'),
    DocProse(
      'The **Runs** destination has `children`, and a rail draws them as '
      'indented rows under their parent. The same list on an '
      '[AstryxTopNav](top_nav) becomes a menu that row opens — one entry '
      'type, two containers, and no second list to keep in step.',
    ),
    DocCallout.accessibility(
      'Collapsing takes the labels off the screen and leaves them in the '
      'semantics tree, with a tooltip that shows on **focus as well as '
      'hover**. That is the one place this widget set puts anything near a '
      'tooltip, and it is allowed only because the name is still announced '
      'and still reachable without a pointer.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Shell navigation](shell_nav) — both bars, and what each is for.',
      '[Shell with top nav](shell_top_nav) — the other half of this split.',
      '[AstryxSideNav](side_nav) — the rail, its sections and its collapsed '
          'state.',
      '[AstryxAppShell](app_shell) — the frame, and `compactBelow`.',
    ]),
    _notAWidget,
  ],
);

const DocPage _shellTopNav = DocPage(
  id: 'shell_top_nav',
  title: 'Shell with top nav',
  group: _group,
  description: 'The shell with a horizontal bar only.',
  source: 'example/lib/examples/template_shell_variant_examples.dart',
  upstreamPath: '/templates/shell-top-nav',
  blocks: <DocBlock>[
    DocExample(
      'template_shell_top_nav',
      align: DocExampleAlign.stretch,
      note:
          'Narrow the window: the destinations scroll sideways rather than '
          'disappearing, and the account menu never moves.',
    ),
    DocHeading('No sidebar means no drawer'),
    DocProse(
      'With nothing in `sidebar:`, `compactBelow` has nothing to do — there '
      'is no navigation for the shell to move anywhere. The bar handles its '
      'own narrow case instead: the destinations sit in a horizontal scroller '
      'and the actions stay pinned at the trailing edge, so adding a '
      'destination never moves the account menu.',
    ),
    DocTree('''
AstryxAppShell                     ← no `sidebar:`, so no drawer
├── header ← AstryxTopNav
│   ├── leading ← the brand
│   ├── entries ← Inbox · Reports · Admin (a section → a menu)
│   └── actions ← search, the account menu
└── child  ← AstryxLayout(maxContentWidth: 900)
    ├── header ← the page title and its one action
    └── child  ← AstryxTabList, then the rows'''),
    DocHeading('A section becomes a menu'),
    DocProse(
      'The **Admin** entry is an `AstryxNavSection` with three items. A rail '
      'would draw that as a heading over a group; a bar has no room for a '
      'heading, and a menu is exactly what holds one. Same '
      '`List<AstryxNavEntry>`, different container, and nothing in the '
      'application has to know which one it is in.',
    ),
    DocHeading('The second level goes inside the page'),
    DocProse(
      'A bar has room for about five destinations. Anything past that has to '
      'live somewhere, and on this shape it lives *in* the page rather than '
      'beside it — an [AstryxTabList](tab_list) under the title, because Open '
      'and Waiting and Done are views of one thing rather than places in the '
      'product.',
    ),
    DocCallout.note(
      '**That is the trade.** A rail can hold twenty destinations and a bar '
      'cannot. If the second level of navigation keeps growing, the answer is '
      'not a wider bar — it is the [rail](shell_side_nav), or '
      '[both](shell_nav).',
    ),
    DocProse(
      '`maxContentWidth: 900` on the layout is doing what the rail would '
      'otherwise have done. Without a rail eating 240 pixels, the content '
      'column runs the full width of a monitor, and a row of text that wide '
      'is a row nobody reads to the end of.',
    ),
    DocCallout.accessibility(
      "The bar carries `label: 'Areas'`, and the account trigger is an "
      "[AstryxAvatar](avatar) with `semanticsLabel: 'Account — Grace "
      "Hopper'`. A picture of a person is not a name for the menu behind it, "
      'and "Grace Hopper" alone does not say that pressing it opens '
      'preferences and sign-out.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Shell with side nav](shell_side_nav) — the other half of this split.',
      '[Shell navigation](shell_nav) — both, and the three layers of "where '
          'am I".',
      '[AstryxTopNav](top_nav) — the bar, its menus and the mega menu.',
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

const DocPage _documentationDesign = DocPage(
  id: 'documentation_design',
  title: 'Design documentation',
  group: _group,
  description: 'A docs page for a design topic, heavy on specimens.',
  source: 'example/lib/examples/template_docs_examples.dart',
  upstreamPath: '/templates/documentation-design',
  blocks: <DocBlock>[
    DocExample(
      'template_documentation_design',
      align: DocExampleAlign.stretch,
      note:
          'Scroll the column: the outline on the right follows. Switch the '
          'brightness in the chrome above and every swatch moves with it.',
    ),
    DocHeading('A design page is read by looking'),
    DocProse(
      'Which makes the specimens the content and the prose the caption — the '
      'opposite of the [technical page](documentation_technical), where the '
      'prose has to carry a reader who cannot run the code. It is also why '
      '`maxContentWidth` is 840 here rather than 720: the sentences still '
      'want a measure, and the specimen wall is allowed to be wider than one.',
    ),
    DocHeading('A specimen comes from the token, or it is a lie'),
    DocProse(
      'The swatches are the one place in this site where a raw `Container` is '
      'the right answer: the colour *is* the content, so nothing should sit '
      'between the token and the reader’s eye. It still comes from '
      '`theme.color`, which is why the page is correct in all eight themes '
      'and both brightnesses rather than in the one it was drawn in.',
    ),
    DocCode('''
Container(
  width: 56,
  height: 40,
  decoration: BoxDecoration(
    color: theme.color(swatch.token),                      // ← the specimen
    borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
    border: Border.all(color: theme.color(AstryxColorToken.border)),
  ),
)'''),
    DocCallout.warning(
      '**A hard-coded hex in a design document is worse than no document.** '
      'It is right on the day it is written and quietly wrong from the first '
      'theme change onward — and the readers most likely to trust it are the '
      'ones who cannot check.',
    ),
    DocHeading('Do and don’t, side by side'),
    DocProse(
      'The pair sits in an [AstryxGrid](grid) rather than one above the '
      'other. The comparison is the whole point, and a reader who has to '
      'scroll between the two is not comparing anything.',
    ),
    DocProse(
      'The "don’t" example is a bare [AstryxStatusDot](status_dot) — which '
      'never paints its label, because the string is its accessible name. '
      'That is the demonstration rather than an accident: a sighted reader '
      'gets a red circle and nothing else.',
    ),
    DocTree('''
AstryxLayout(maxContentWidth: 840, panelWidth: 190)
├── header ← AstryxBreadcrumbs
├── panel  ← AstryxOutline, tracking the body’s scroll controller
└── child
    ├── AstryxSection("Semantic roles")      ← swatch, token name, when
    ├── AstryxSection("Categorical families")← palette cards and badges
    ├── AstryxSection("Text on ground")      ← the pairing, as code
    └── AstryxSection("What goes wrong")     ← a banner, and the pair'''),
    DocCallout.accessibility(
      'Each swatch is named in text beside it, as '
      '`AstryxTextType.code`. A colour reference whose entries are '
      'distinguished only by their colour is a reference that documents '
      'nothing for the reader most likely to be consulting it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Technical documentation](documentation_technical) — the same frame '
          'around an API.',
      '[Documentation](documentation) — the site around both, with a rail.',
      '[Colour](color) — the system this page is a specimen of.',
      '[AstryxOutline](outline) — the tracking, the anchors and `topOffset`.',
    ]),
    _notAWidget,
  ],
);

const DocPage _documentationTechnical = DocPage(
  id: 'documentation_technical',
  title: 'Technical documentation',
  group: _group,
  description: 'A docs page for an API, heavy on code and property tables.',
  source: 'example/lib/examples/template_docs_examples.dart',
  upstreamPath: '/templates/documentation-technical',
  blocks: <DocBlock>[
    DocExample(
      'template_documentation_technical',
      align: DocExampleAlign.stretch,
      note:
          'Switch the sample between Dart and curl: the tab strip reports a '
          'value and the block is a lookup, which is what makes the choice '
          'linkable from a route.',
    ),
    DocHeading('The method and the path are on the page'),
    DocProse(
      'Not inside the first code block. They are the first thing anybody '
      'looks for on a reference page, and a reader who has to parse a curl '
      'invocation to find out whether this is a `POST` has been made to work '
      'for the one fact the page exists to state.',
    ),
    DocProse(
      'The **Idempotent** badge carries a `semanticsLabel` that says what the '
      'word means — "repeating this request is safe" — because a one-word '
      'badge is a term of art, and a term of art with no expansion is a badge '
      'for people who already knew.',
    ),
    DocHeading('The property table is an AstryxTable'),
    DocProse(
      'Not a hand-built grid of rows. It gets the column widths, the header '
      'semantics, the row dividers and — where a `compare` is given — the '
      'sorting, for free. The **Property** column mixes an '
      '[AstryxCode](code) name with a `req` badge, which is what a '
      '`cellBuilder` is for.',
    ),
    DocCode('''
AstryxTableColumn<ApiProperty>(
  id: 'name',
  header: 'Property',
  width: const AstryxTableColumnWidth.fixed(150),
  cellBuilder: (context, row) => AstryxHStack(
    children: <Widget>[
      Flexible(child: AstryxCode(row.name)),
      if (row.required)
        const AstryxBadge('req', semanticsLabel: 'Required'),
    ],
  ),
)'''),
    DocCallout.warning(
      '**No `truncateTooltip: true` in a table cell.** Deciding whether text '
      'is cut off needs the cell’s final width, and a table row is measured '
      'before it is laid out — the layout asserts in touch density. '
      '`maxLines` on its own is what these cells use; the ellipsis is the '
      'signal, and a screen reader gets the whole string either way.',
    ),
    DocHeading('Two samples, one field of state'),
    DocProse(
      'The language switch is an [AstryxTabList](tab_list), which reports a '
      'value and owns no panel — so the sample on screen is `_samples[_lang]` '
      'and nothing else. Every sample is written out in full rather than '
      'diffed against the one above it: a reader copies one block, and a '
      'block that only makes sense beside another is a block that does not '
      'survive the clipboard.',
    ),
    DocProse(
      "The curl sample is a raw string — `r'''…'''` — so the "
      r'continuation backslashes and the `$TOKEN` are what the reader sees. '
      'Escaping them into a normal string is how a documented command ends up '
      'shipping a double backslash.',
    ),
    DocHeading('Errors are a list, and they are matched on the code'),
    DocProse(
      'The banner above them says it out loud: match on the code, never on '
      'the message. The message is translated and the code is not, and the '
      'reader who is going to get that wrong is the one skimming for a status '
      'number.',
    ),
    DocCallout.accessibility(
      'The inline links in the Authentication section are '
      '`AstryxLink.span` inside a `Text.rich`, not a button after the '
      'paragraph. Flutter has no inline element, and the alternative — a link '
      'lifted out of the sentence it belongs to — takes the context with it.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Design documentation](documentation_design) — the same frame around '
          'specimens.',
      '[Documentation](documentation) — the site around both.',
      '[AstryxTable](table) — the three width strategies, and sorting.',
      '[AstryxCodeBlock](code_block) — the language label, copy, and line '
          'numbers.',
    ]),
    _notAWidget,
  ],
);

// ---------------------------------------------------------------------------
// Workspaces
// ---------------------------------------------------------------------------

const DocPage _editor = DocPage(
  id: 'editor',
  title: 'Editor',
  group: _group,
  description: 'A document editor: toolbar, canvas, and an inspector panel.',
  source: 'example/lib/examples/template_workspace_examples.dart',
  upstreamPath: '/templates/editor',
  blocks: <DocBlock>[
    DocExample(
      'template_editor',
      align: DocExampleAlign.stretch,
      note:
          'Select a phrase in the canvas and press **Bold**. Then switch to '
          '**Preview** — the toolbar disables, because there is nothing there '
          'to format.',
    ),
    DocHeading('The toolbar edits the document, it does not style a model'),
    DocProse(
      'This package ships no rich-text editing controller, and a toolbar that '
      'pretended otherwise would be three buttons that do nothing. So the '
      'document is its own markup and the buttons are *edits to it*: **Bold** '
      'wraps the selection in `**`, and the caret lands after it.',
    ),
    DocCode(r'''
void _wrap(String marker) {
  final value = _body.value;
  final selection = value.selection;
  if (!selection.isValid) return;

  final replaced = '\$marker\${selection.textInside(value.text)}\$marker';
  _body.value = value.copyWith(
    text: selection.textBefore(value.text) +
        replaced +
        selection.textAfter(value.text),
    selection: TextSelection.collapsed(
      offset: selection.start + replaced.length,
    ),
    composing: TextRange.empty,
  );
}'''),
    DocProse(
      'That is also why **Write** and **Preview** exist. The reader can see '
      'what the markup becomes, which is the thing a rich-text field would '
      'have been showing them all along.',
    ),
    DocCallout.warning(
      '**`scrollable: false` on the layout.** The canvas is an '
      '[AstryxTextArea](text_area) — or, in preview, a scroller of its own. '
      'Leaving the layout scrollable puts one scroll view inside another, and '
      'the inner one then measures unbounded, which is a layout assertion '
      'rather than a subtle bug.',
    ),
    DocHeading('One tab stop for the whole band'),
    DocProse(
      '[AstryxToolbar](toolbar) is what makes a formatting band usable by '
      'keyboard: Tab reaches it once and leaves it once, however many '
      'controls sit between, and the arrows move inside. Twelve buttons '
      'without it is twelve presses to walk past.',
    ),
    DocProse(
      'The tail is an [AstryxMoreMenu](more_menu) rather than four more '
      'buttons — and `label` is the trigger’s name, its tooltip *and* the '
      'menu’s name, because they are one answer to one question.',
    ),
    DocHeading('The inspector is a panel, not a dialog'),
    DocTree('''
AstryxLayout(scrollable: false, panelWidth: 260)
├── header ← the title field, the dirty badge, the toolbar, Write/Preview
├── child  ← the canvas (AstryxTextArea, or AstryxMarkdown in preview)
├── panel  ← status, tags, and the document’s history
└── footer ← the word count, Discard and Save'''),
    DocProse(
      'Status and tags belong beside the document, not behind a button: they '
      'are things the writer changes while writing. A dialog would make each '
      'one an interruption, and the reader would stop setting them.',
    ),
    DocCallout.note(
      '**Checkboxes and a selector here, because there is a Save button.** '
      'Nothing on this screen takes effect until it is pressed, so nothing on '
      'it may be an [AstryxSwitch](switch) — a switch would promise it '
      'already had. The [settings](settings) template is the other half of '
      'that rule.',
    ),
    DocCallout.accessibility(
      'The dirty state is a badge with an icon and words — *Unsaved changes* '
      'or *Saved* — and both footer buttons are `enabled: _dirty`. A disabled '
      'Save with no stated reason reads as broken; the badge is what turns it '
      'into a state the reader can see and act on.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[IDE](ide) — the same shape when the document is code.',
      '[Two-column form](form_two_column) — the other screen with a Save '
          'button, and the same badge.',
      '[AstryxToolbar](toolbar) — the band, the divider and the traversal.',
      '[AstryxMarkdown](markdown) — what preview renders, and what it does '
          'not.',
    ]),
    _notAWidget,
  ],
);

const DocPage _fileExplorer = DocPage(
  id: 'file_explorer',
  title: 'File explorer',
  group: _group,
  description: 'A tree of folders beside a list of files.',
  source: 'example/lib/examples/template_workspace_examples.dart',
  upstreamPath: '/templates/file-explorer',
  blocks: <DocBlock>[
    DocExample(
      'template_file_explorer',
      align: DocExampleAlign.stretch,
      note:
          'Tab to the tree and use the arrows: Right opens a branch and steps '
          'into it, Left closes it and steps out. Open **Post-mortems** twice '
          'to reach a folder with one file, and **Archive** to find a '
          'disabled one.',
    ),
    DocHeading('The tree is where you came from; the table is what you see'),
    DocProse(
      'Which is why the tree is at the *reading-start* edge — '
      '`panelSide: AstryxLayoutPanelSide.start` — and the table fills the '
      'body. A details panel about the selected thing goes at the other edge; '
      'a way of getting to it goes at this one.',
    ),
    DocTree('''
AstryxLayout(scrollable: false, panelSide: start, panelWidth: 240)
├── header ← the folder’s name, its count, and Upload
├── panel  ← AstryxTreeList: the folders
└── child  ← AstryxTable: the files in the selected one'''),
    DocHeading('One tab stop, and the arrows do the rest'),
    DocProse(
      '[AstryxTreeList](tree_list) owns its own traversal, and it is the '
      'traversal a file tree has had for thirty years: Down and Up move '
      'between visible rows, Right opens and steps in, Left closes and steps '
      'out, Home and End go to the ends. Do not wrap the nodes in `Focus` — '
      'they are already one control.',
    ),
    DocProse(
      'A closed branch builds none of its children, so a tree of a thousand '
      'nodes costs only what is open. What *is* open is built in full: this '
      'is a `Column`, like [AstryxList](list), and it does not virtualise.',
    ),
    DocHeading('Selection lives in the caller'),
    DocProse(
      'Changing folder clears it. That is a decision, not an oversight — a '
      'selection that survives a change of folder is a set of files the '
      'reader can no longer see, and the next thing they press acts on it.',
    ),
    DocCode('''
onSelectedChanged: (id) => setState(() {
  _folder = id;
  _selected = <Object>{};    // ← the selection belonged to the old folder
}),'''),
    DocCallout.warning(
      '**Row actions are always visible.** The overflow menu on each file is '
      'an [AstryxMoreMenu](more_menu) named for *that* file — "Actions for '
      'rollback.md". Hover does not exist on touch, and the density system '
      'actively suppresses hover styling there, so a menu that appears under '
      'a pointer is a menu half the readers do not have.',
    ),
    DocProse(
      'The empty state is per-folder and offers the way out: **Archive** is '
      'disabled in the tree, and a folder with nothing in it says so and '
      'offers Upload rather than looking like a table that failed to load.',
    ),
    DocCallout.accessibility(
      '`rowLabelOf` names each row’s checkbox with the file’s own name. '
      'Without it every checkbox in the table announces "Select row", which '
      'is true of all of them and therefore tells a screen-reader user '
      'nothing about which one they are ticking.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[IDE](ide) — the same tree, beside editors rather than a table.',
      '[Library](library) — a flat collection with filters instead of a '
          'hierarchy.',
      '[AstryxTreeList](tree_list) — the nodes, the keyboard map and the '
          'expansion state.',
      '[AstryxTable](table) — selection, row actions and the width '
          'strategies.',
    ]),
    _notAWidget,
  ],
);

const DocPage _ide = DocPage(
  id: 'ide',
  title: 'IDE',
  group: _group,
  description: 'A code workspace: file tree, tabbed editors, and a panel.',
  source: 'example/lib/examples/template_workspace_examples.dart',
  upstreamPath: '/templates/ide',
  blocks: <DocBlock>[
    DocExample(
      'template_ide',
      align: DocExampleAlign.stretch,
      note:
          'Tab to either divider and press the arrow keys — both regions '
          'resize from the keyboard. Open a file from the tree and close it '
          'from the editor menu.',
    ),
    DocHeading('Two resize handles, and the caller owns both sizes'),
    DocProse(
      'An [AstryxResizeHandle](resize_handle) reports the size the region '
      'beside it should take; remembering it is the caller’s job. That is why '
      'the widths and heights are fields here, and it is what lets a real '
      'application persist them.',
    ),
    DocCode('''
AstryxResizeHandle(
  label: 'Resize the file tree',   // required — nothing is painted on a handle
  size: _treeWidth,
  min: 140,
  max: 320,
  onResize: (width) => setState(() => _treeWidth = width),
),

AstryxResizeHandle(
  label: 'Resize the panel',
  edge: AstryxResizeEdge.bottom,   // ← a band at the bottom grows upward
  size: _drawerHeight,
  min: 80,
  max: 260,
  onResize: (height) => setState(() => _drawerHeight = height),
),'''),
    DocCallout.accessibility(
      '**Tab reaches a handle and the arrow keys move it**, with Home and End '
      'at `min` and `max`. It announces itself as a slider carrying the '
      'current size, and `label` is required because nothing is painted on a '
      'handle. A divider only a pointer can drag is a layout only some people '
      'can use — the part hand-rolled splitters almost always miss.',
    ),
    DocHeading('Tabs report a value and own no panel'),
    DocProse(
      'Which file is showing is one field of state, so closing a tab is a '
      'list edit rather than surgery on a panel stack. The same is true of '
      'the drawer at the bottom: **Problems** or **Output** is a second '
      'field, and each is a lookup.',
    ),
    DocTree('''
SizedBox(height: 520)          ← every region is measured against this
└── Column(crossAxisAlignment: stretch)
    ├── Expanded → Row
    │   ├── SizedBox(_treeWidth) → AstryxTreeList
    │   ├── AstryxResizeHandle
    │   └── Expanded → AstryxTabList(open files) + the editor surface
    ├── AstryxResizeHandle(edge: bottom)
    ├── SizedBox(_drawerHeight) → AstryxTabList(Problems · Output)
    └── the status bar'''),
    DocCallout.warning(
      '**A bare `Column`, not an [AstryxCard](card).** A card sizes itself to '
      'its body, so it hands that body an unbounded height — and every region '
      'here is either an `Expanded` or a band measured against the frame. The '
      'bounded `SizedBox` is what the whole layout is built against; put a '
      'card around it and nothing inside can be laid out at all.',
    ),
    DocCallout.warning(
      '**The editor surface is an [AstryxCodeBlock](code_block), which is '
      'read-only and does no highlighting.** A code editor is a text control '
      'with a language server behind it, and this package does not ship one. '
      'Everything around it — the tree, the tabs, the drawer, the handles, '
      'the status bar — is real; the box in the middle is where your editor '
      'goes.',
    ),
    DocHeading('The status bar is one line and no interaction'),
    DocProse(
      'Analyser state as an [AstryxStatusDot](status_dot) with a real label, '
      'the branch, the caret position in tabular figures, the language. '
      'Everything on it is a fact a glance needs — which is the test for what '
      'belongs on a status bar and what belongs in a menu.',
    ),
    DocProse(
      'When every tab is closed the editor shows an '
      '[AstryxEmptyState](empty_state) pointing back at the tree. A blank '
      'panel where a file used to be looks like a file that failed to open.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[Editor](editor) — the same shape when the document is prose.',
      '[File explorer](file_explorer) — the same tree, beside a table.',
      '[AstryxResizeHandle](resize_handle) — the edges, the step and the '
          'keyboard.',
      '[AstryxTreeList](tree_list) — the nodes and the traversal.',
    ]),
    _notAWidget,
  ],
);

const DocPage _library = DocPage(
  id: 'library',
  title: 'Library',
  group: _group,
  description: 'A browsable collection with filters beside the results.',
  source: 'example/lib/examples/template_split_examples.dart',
  upstreamPath: '/templates/library',
  blocks: <DocBlock>[
    DocExample(
      'template_library',
      align: DocExampleAlign.stretch,
      note:
          'Tick a few assets, then switch between grid and list: the '
          'selection is the same set, because it belongs to the screen rather '
          'than to either view.',
    ),
    DocHeading('One set, one selection, two views'),
    DocProse(
      'That is the whole design. `_selected` is a `Set<Object>` on the state, '
      'and both views read and write it — the grid through '
      '[AstryxSelectableCard](selectable_card), the list through '
      '`AstryxTable`’s `selected` and `onSelectionChanged`. A selection that '
      'reset when the reader changed view would make the view control '
      'something nobody would press twice.',
    ),
    DocProse(
      'The view switch is an [AstryxSegmentedControl](segmented_control): a '
      'small set of mutually exclusive ways of looking at one thing, '
      'announced as a radio group, with all its labels present even when they '
      'are `labelHidden` behind an icon.',
    ),
    DocHeading('A selectable card is a control, not a surface'),
    DocProse(
      'This is the one exception to "there is one card". '
      '[AstryxSelectableCard](selectable_card) reports a *selection* rather '
      'than a press, and announces itself as a checkbox — which is what it '
      'is. A pressable [AstryxCard](card) with a checkbox drawn on it '
      'announces a button that happens to tick something, and a '
      'screen-reader user has to work out which.',
    ),
    DocCode(r'''
AstryxSelectableCard(
  label: asset.name,                        // required, never painted
  semanticsHint: '\${asset.kind}, \${asset.size}',
  selected: _selected.contains(asset.id),
  onSelectedChanged: (value) => _toggle(asset.id, selected: value),
  child: /* the thumbnail, the name, the kind */,
)'''),
    DocHeading('The panel is a filter; the header is what it did'),
    DocTree('''
AstryxLayout(panelSide: start, panelWidth: 210)
├── header ← title, "5 of 7 assets", search, grid/list, the selection bar
├── panel  ← collections (with counts), then kind checkboxes
└── child  ← the wall, the table, or the empty state'''),
    DocProse(
      'Every collection row carries its own count. A filter list that does '
      'not say how much is behind each entry makes the reader press them one '
      'at a time to find out — and the count is also what makes an empty '
      'result legible rather than alarming.',
    ),
    DocCallout.note(
      '**The selection bar appears only once something is ticked, and it says '
      'how many.** "Remove" with no count is a question the reader cannot '
      'answer, and it is the one destructive control on the screen.',
    ),
    DocCallout.accessibility(
      'Every asset is announced as its name plus a `semanticsHint` carrying '
      'the kind and the size. In the grid those two facts are a line of small '
      'grey text; in the list they are columns. The announcement is the same '
      'either way, which is what "two views of one set" has to mean.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[File explorer](file_explorer) — a hierarchy rather than a flat set.',
      '[Product gallery](product_gallery) — the same shape for things you do '
          'not own yet.',
      '[AstryxSelectableCard](selectable_card) — the card that is a control.',
      '[AstryxTable](table) — the other half of the selection.',
    ]),
    _notAWidget,
  ],
);

const DocPage _messagingShell = DocPage(
  id: 'messaging_shell',
  title: 'Messaging shell',
  group: _group,
  description: 'A conversation list beside the open conversation.',
  source: 'example/lib/examples/template_split_examples.dart',
  upstreamPath: '/templates/messaging-shell',
  blocks: <DocBlock>[
    DocExample(
      'template_messaging_shell',
      align: DocExampleAlign.stretch,
      note:
          'Pick another conversation, then send something: the draft goes to '
          'the thread it was written in.',
    ),
    DocHeading('A list that selects, not a list that filters'),
    DocProse(
      'It looks like the [library](library) and it is the opposite: there, '
      'the panel narrows what the body shows and several things may be '
      'selected at once. Here exactly one conversation is open, and the panel '
      'is how it is chosen. That is why `_thread` is a `String` rather than a '
      '`Set` — the type is the design.',
    ),
    DocTree('''
AstryxLayout(scrollable: false, padding: spacing0, panelSide: start)
├── panel ← the conversations: avatar, preview, unread count
└── child ← AstryxChatLayout
    ├── header   ← who this is, their status, the conversation menu
    ├── messages ← AstryxChatMessage per line
    └── composer ← AstryxChatComposer'''),
    DocProse(
      '`scrollable: false` and `padding: spacing0`, because neither column is '
      'the layout’s to scroll or to inset: the transcript owns its scrolling '
      'and opens at the newest turn, and the thread list owns its own.',
    ),
    DocHeading('The chat roles are about sides, not about machines'),
    DocCallout.warning(
      '`AstryxChatRole.user` is whoever is composing, and '
      '`AstryxChatRole.assistant` is the other side of the transcript. In a '
      'conversation between two people that mapping reads oddly in the source '
      'and correctly on the screen — `user` is the bubble at the trailing '
      'edge, which is where the reader’s own words belong.',
    ),
    DocProse(
      'The other side gets a `leading:` [AstryxAvatar](avatar) and the '
      'reader’s own turns do not. Repeating your own face beside every line '
      'you wrote is a column of noise down the edge nobody is reading.',
    ),
    DocHeading('Never markdown'),
    DocProse(
      'Every message is [AstryxText](text). The [AI chat](ai_chat) template '
      'renders the *assistant’s* turn as [AstryxMarkdown](markdown) because '
      'that is the format it arrives in — but rendering what a person typed '
      'changes what they said, and in a person-to-person thread there is no '
      'markdown to render in the first place.',
    ),
    DocCallout.accessibility(
      'The unread badge carries a `semanticsLabel` — "2 unread messages" — '
      'because "2" beside a name is a number about nothing. The presence dot '
      'on the avatar takes a `statusLabel` for the same reason: a green ring '
      'is not the word "online".',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AI chat](ai_chat) — the same transcript when the other side is a '
          'model.',
      '[Library](library) — the panel that filters rather than selects.',
      '[AstryxChatLayout](chat_layout) — the transcript, the scroll behaviour '
          'and the composer slot.',
      '[AstryxAvatar](avatar) — initials, status and the label it needs.',
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
