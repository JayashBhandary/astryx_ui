// This is a command-line tool: printing is how it reports.
// ignore_for_file: avoid_print

/// Renders the documentation as a skill for AI coding agents.
///
/// An agent writing `astryx_ui` code needs different things from a person
/// reading a page: the rules it would otherwise break, the valid enum values,
/// one canonical snippet per component, and a property table it can check a
/// call against. It does not need the prose. So this emits a short `SKILL.md`
/// with the rules and an index, plus one reference file per component group for
/// it to open when it gets there.
///
/// The curated half — the rules, the mistakes, the widget-choosing table —
/// lives in this file. The rest comes from `lib/docs/pages/`, the same source
/// the site and `doc/` are built from, so the three cannot disagree.
///
/// Run it from the `example/` directory, after `gen_snippets.dart`:
///
/// ```bash
/// dart run tool/gen_snippets.dart
/// dart run tool/gen_skill.dart
/// ```
library;

import 'dart:io';

import 'package:example/docs/pages.dart';
import 'package:example/docs/snippets.g.dart';

/// Where the skill goes, relative to `example/`.
const String _root = '../.claude/skills/astryx-ui';

/// The package source, for scraping enum values.
const String _packageLib = '../lib/src';

/// The plugin manifest, whose version tracks the package's.
const String _pluginManifest = '../.claude-plugin/plugin.json';

/// The group that documents the package rather than a component.
const String _guideGroup = DocGroup.gettingStarted;

/// The reference file each group is written to.
///
/// From `lib/docs/groups.dart`, so adding a group cannot leave this behind.
const Map<String, String> _groupFiles = docGroupFiles;

/// Written pages that are still not the skill's business.
///
/// Not an omission the way a placeholder is: an agent gains nothing from the
/// release history or from how to file an issue, and `changelog` alone would
/// put every bullet of every release into `references/guides.md`, which is the
/// file it opens to learn what a token is.
///
/// Everything else that is written is published. If a page here ever grows a
/// rule an agent must follow, the rule belongs in `_rules` below, not in a
/// reference nobody opens.
const Set<String> _notForAgents = <String>{'changelog', 'community'};

/// Whether [page] is published to the skill.
bool _forAgents(DocPage page) =>
    page.isWritten && !_notForAgents.contains(page.id);

void main() {
  if (!Directory('lib/docs').existsSync()) {
    stderr.writeln('Run this from the example/ directory.');
    exit(1);
  }

  Directory('$_root/references').createSync(recursive: true);

  File('$_root/SKILL.md').writeAsStringSync(_skill());

  var groups = 0;
  for (final entry in docPagesByGroup.entries) {
    final file = _groupFiles[entry.key];
    if (file == null) {
      stderr.writeln('No reference file mapped for group "${entry.key}".');
      exit(1);
    }

    // Written pages only: an agent told about a widget the package does not
    // export yet will call it, and the call will not compile. A group whose
    // pages are all placeholders gets no reference file at all.
    final pages = entry.value.where(_forAgents).toList();
    if (pages.isEmpty) continue;

    File(
      '$_root/references/$file',
    ).writeAsStringSync(_reference(entry.key, pages));
    groups++;
  }

  File('$_root/references/enums.md').writeAsStringSync(_enums());
  File('$_root/references/patterns.md').writeAsStringSync(_patterns());

  print('Wrote SKILL.md and ${groups + 2} references to $_root/.');

  _syncPluginVersion();
}

/// Copies the package version into the plugin manifest.
///
/// The skill is released as a Claude Code plugin, and a plugin's `version`
/// is what decides whether installed users are offered an update. Deriving it
/// from `pubspec.yaml` means a release cannot ship a new skill under the old
/// version by accident.
void _syncPluginVersion() {
  final manifest = File(_pluginManifest);
  if (!manifest.existsSync()) {
    stderr.writeln('No $_pluginManifest — skipping the version sync.');
    return;
  }

  final pubspec = File('../pubspec.yaml').readAsStringSync();
  final version = RegExp(
    r'^version:\s*(\S+)\s*$',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);

  if (version == null) {
    stderr.writeln('No version in ../pubspec.yaml — skipping the sync.');
    return;
  }

  final source = manifest.readAsStringSync();
  final updated = source.replaceFirst(
    RegExp('"version": "[^"]*"'),
    '"version": "$version"',
  );

  if (updated == source) {
    print('Plugin version already $version.');
    return;
  }

  manifest.writeAsStringSync(updated);
  print('Set the plugin version to $version.');
}

// ---------------------------------------------------------------------------
// SKILL.md
// ---------------------------------------------------------------------------

String _skill() {
  final out = StringBuffer()
    ..writeln('---')
    ..writeln('name: astryx-ui')
    ..writeln('description: >-')
    ..writeln(_description)
    ..writeln('---')
    ..writeln()
    ..writeln(_generatedNote)
    ..writeln()
    ..writeln(_preamble)
    ..writeln(_rules)
    ..writeln(_choosing)
    ..writeln(_mistakes)
    ..writeln('## Components')
    ..writeln()
    ..writeln(
      'Open the reference before writing a component you have not written '
      'before. Each entry there has a canonical snippet, the rules that apply, '
      'and the full property table.',
    )
    ..writeln()
    ..writeln('| Component | For | Reference |')
    ..writeln('| --- | --- | --- |');

  for (final page in docPages.where(_forAgents)) {
    if (page.group == _guideGroup) continue;
    out.writeln(
      '| `${page.title}` | ${_plain(page.description)} '
      '| `references/${_groupFiles[page.group]}` |',
    );
  }

  out
    ..writeln()
    ..writeln('## Guides')
    ..writeln()
    ..writeln('| Topic | Covers | Reference |')
    ..writeln('| --- | --- | --- |');

  for (final page in docPages.where(
    (p) => _forAgents(p) && p.group == _guideGroup,
  )) {
    out.writeln(
      '| ${page.title} | ${_plain(page.description)} '
      '| `references/guides.md` |',
    );
  }

  out
    ..writeln()
    ..writeln('## All references')
    ..writeln()
    ..writeln(
      '- `references/enums.md` — **every public enum and its values.** Check '
      'here before naming a variant, a size or a token; the names are not '
      'always the obvious ones.',
    )
    ..writeln(
      '- `references/patterns.md` — whole screens: a form in a card, a table '
      'with row actions, a destructive flow, a settings list.',
    );

  // Only the groups that actually have pages: `_groupFiles` covers every group
  // the site may grow into, and pointing an agent at a file that was never
  // written is worse than not mentioning it.
  for (final entry in docPagesByGroup.entries) {
    if (!entry.value.any(_forAgents)) continue;
    out.writeln('- `references/${_groupFiles[entry.key]}` — ${entry.key}.');
  }

  out
    ..writeln()
    ..writeln(
      'The prose versions of these pages, for a human, are in `doc/` at the '
      'repository root. The live site is `example/`.',
    );

  return out.toString();
}

const String _description =
    '  Use when writing or reviewing Flutter UI built with the astryx_ui\n'
    '  package — screens, forms, tables, dialogs, menus, toasts or custom\n'
    '  themes using AstryxButton, AstryxCard, AstryxTable and the rest of\n'
    '  the widget set. Covers all 30 components, the token system (never a\n'
    '  raw colour or pixel value), pointer/touch density, right-to-left\n'
    '  support, and the accessibility rules the widget set enforces —\n'
    '  required labels, focus behaviour, and never putting anything behind\n'
    '  hover alone. Also use when asked to theme an app, pick between two\n'
    '  similar components, or explain why an astryx_ui widget behaves as it\n'
    '  does.';

const String _generatedNote = '''
<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->''';

const String _preamble = '''
# astryx_ui

An unofficial Flutter port of Astryx, Meta's design system for internal tools.
Built on `flutter/widgets`, **not Material**. Roughly 30 components, all
themeable through one token layer.

## Setup

```dart
import 'package:astryx_ui/astryx_ui.dart';

void main() => runApp(
  AstryxApp(
    title: 'My internal tool',
    home: const HomePage(),
  ),
);
```

Inside an existing `MaterialApp` or `CupertinoApp`, wrap a subtree instead —
this is the incremental adoption path and behaves identically:

```dart
MaterialApp(
  home: AstryxThemeProvider(
    theme: matchaTheme,          // optional. Defaults to neutralTheme
    mode: AstryxColorMode.system,
    child: const HomePage(),
  ),
)
```

Either one installs the theme, the icon registry, the localisations, the
focus-visible scope and the toast host. Nothing else to wire: toasts, tooltips,
dialogs and focus rings work from here.

For tokens without widgets — a chart, a custom painter, a test — import
`package:astryx_ui/theme.dart` instead.
''';

const String _rules = '''
## Hard rules

Break these and the result compiles, looks fine, and is wrong.

1. **No raw values.** Never a `Color`, a padding number, a radius, a duration or
   a `TextStyle` literal. Read the token:

   ```dart
   final theme = AstryxTheme.of(context);
   theme.color(AstryxColorToken.accent);
   theme.spacing(AstryxSpacingToken.spacing3);
   theme.borderRadius(AstryxRadiusToken.container);
   theme.textStyle(AstryxTypeRole.body);
   ```

   Widget parameters take tokens directly — `gap:`, `padding:`, `variant:`.
   Reach for `AstryxTheme.of` only when building something the design system
   has no widget for.

2. **Everything interactive has an accessible name.** `AstryxButton.label`,
   `AstryxIconButton.label` (required even though nothing is painted),
   `AstryxCheckbox.label`, `AstryxCard.semanticsLabel` when pressable,
   `AstryxTable.label` and `rowLabelOf`, `AstryxTabList.label`, an overlay's
   `label`. Use `labelHidden: true` to hide a label from sight — never to skip
   one.

3. **Nothing lives behind hover.** No hover-only actions, no information that
   appears only in a tooltip. Touch has no hover, and the density system
   actively suppresses hover styling there. Gate any hover styling you write
   yourself on `AstryxTheme.densityOf(context).supportsHover`.

4. **Colour is never the only signal.** Pair every status with an icon or text.
   The nine `AstryxPalette` families are *categorical* — "the Red team" — never
   severity.

5. **Composite controls are one tab stop.** `AstryxRadioList`, `AstryxTabList`,
   `AstryxTreeList`, `AstryxDropdownMenu` and `AstryxSelector` handle their own
   arrow-key navigation. Do not wrap their children in `Focus` or `InkWell`.

6. **Overlays take a `triggerBuilder`, not a child.** A button consumes its own
   taps, so the overlay hands you a controller:

   ```dart
   AstryxPopover(
     content: panel,
     triggerBuilder: (context, controller) =>
         AstryxButton(label: 'Filters', onPressed: controller.toggle),
   )
   ```

   `AstryxDialog` is the exception: it is a widget in the tree driven by an
   `AstryxDialogController`, not a `showDialog` call. Put it next to whatever
   opens it and dispose the controller with your state.

7. **`AstryxHStack` and `AstryxVStack` default to `MainAxisSize.min`**, unlike
   Flutter's `Row` and `Column`. `justify` appears to do nothing until you ask
   for `MainAxisSize.max`. In a spreading row, wrap text in `Flexible` or it
   will overflow.

8. **There is one card.** No `ClickableCard`: a non-null `onPressed` makes
   `AstryxCard` a button, with hover, press, a focus ring, `Semantics(button:
   true)` and tap-target enforcement. The one exception is
   `AstryxSelectableCard`, which is a *control*, not a surface: it reports a
   selection instead of a press, and announces itself as a checkbox or a radio.

9. **Logical directions only.** `start`/`end`, `paddingInline`,
   `EdgeInsetsDirectional`. Never `left`/`right`. RTL is then a
   `Directionality` and nothing else.

10. **A switch applies immediately; a checkbox applies on submit.** Do not put
    an `AstryxSwitch` in a form with a Save button.

11. **`AstryxSelector` picks a value; `AstryxDropdownMenu` performs actions.**
    A menu reports nothing and shows no current selection.
''';

const String _choosing = '''
## Choosing a widget

| Want | Use |
| --- | --- |
| An action with words | `AstryxButton` |
| An action with a glyph | `AstryxIconButton` (still needs `label`) |
| A related set of actions | `AstryxButtonGroup(attached: false)` |
| A segmented control | `AstryxButtonGroup`, selected child takes a louder `variant` |
| One choice, ≤7 options, all visible | `AstryxRadioList` |
| One choice, many options | `AstryxSelector` |
| One choice, options needing a price or a badge | `AstryxSelectableCard` |
| A boolean that applies now | `AstryxSwitch` |
| A boolean that applies on submit | `AstryxCheckbox` |
| A label + validation around your own control | `AstryxField` |
| A message tied to the page | `AstryxBanner` |
| A message about something that just happened | toast via `AstryxToastScope.of(context).show(...)` |
| A status word or count | `AstryxBadge` |
| A container, maybe pressable | `AstryxCard` |
| A floating panel | `AstryxPopover` |
| A list of actions | `AstryxDropdownMenu` |
| Something that must be dealt with | `AstryxDialog` |
| A phrase on hover | `AstryxTooltip` (never the only source of the fact) |
| Rows of data | `AstryxTable` (does **not** virtualise — hundreds, not thousands) |
| Switching views | `AstryxTabList` |
| A wait with no known extent | `AstryxSpinner` |
| A wait with a known extent | `AstryxProgressBar` |
| A wait whose result has a known shape | `AstryxSkeleton` |
| Row/column with token spacing | `AstryxHStack` / `AstryxVStack` |
| A responsive tile wall | `AstryxGrid(minWidth: …)` |
| An empty state | `AstryxEmptyState` |
| The frame around an application | `AstryxAppShell` |
| The destinations of an application | `AstryxSideNav` / `AstryxTopNav` / `AstryxMobileNav` (one `AstryxNavEntry` list, three containers) |
| The icon slot in a nav row | `AstryxNavIcon` |
| A workspace switcher | `AstryxNavHeadingMenu` |
| The trail back up a hierarchy | `AstryxBreadcrumbs` |
| A page inside that frame | `AstryxLayout` (pinned header and footer) |
| A titled band of a page | `AstryxSection` (works out its own heading level) |
| A draggable panel edge | `AstryxResizeHandle` |
| An on-this-page contents | `AstryxOutline` |
| A row: something, a label, something | `AstryxItem` |
| A stack of rows | `AstryxList` (does **not** virtualise) |
| Rows that nest | `AstryxTreeList` |
| A row that must not wrap | `AstryxOverflowList` |
| Facts about one record | `AstryxMetadataList` |
| A symbol inside a sentence | `AstryxCode` (`AstryxCode.span` in `Text.rich`) |
| More than a phrase of code | `AstryxCodeBlock` (no highlighting) |
| Someone else's words | `AstryxBlockquote` |
| A keyboard shortcut | `AstryxKbd` |
''';

const String _mistakes = '''
## Common mistakes

| Wrong | Right |
| --- | --- |
| `AstryxButton(child: Text('Save'))` | `AstryxButton(label: 'Save')` — there is no `child` |
| `AstryxIconButton(icon: …, onPressed: …)` | add `label:` — it is required |
| `padding: EdgeInsets.all(16)` | `padding: AstryxSpacingToken.spacing4` |
| `SizedBox(height: 12)` between children | `gap:` on the enclosing stack |
| `Color(0xFF0F62FE)` | `theme.color(AstryxColorToken.accent)` |
| `TextStyle(fontSize: 14)` | `AstryxText(…, type: AstryxTextType.supporting)` |
| `Text('Hello')` | `AstryxText('Hello')` |
| `ClickableCard(…)` | `AstryxCard(onPressed: …, semanticsLabel: …)` |
| `showDialog(context: context, …)` | an `AstryxDialog` in the tree + `AstryxDialogController` |
| `AstryxPopover(child: button)` | `triggerBuilder: (context, controller) => …` |
| `onChanged` omitted "because it is read-only" | `readOnly: true` — a null `onChanged` is silently inert |
| `enabled: false` for a value shown but not editable | `readOnly: true`; `enabled: false` dims it |
| `EdgeInsets.only(left: 8)` | `EdgeInsetsDirectional.only(start: 8)` |
| Row actions revealed on hover | always visible — `rowActionsBuilder` |
| `AstryxHStack(justify: …)` and nothing moves | add `mainAxisSize: MainAxisSize.max` |
| Long text in a spreading row | wrap it in `Flexible` |
| `AstryxTable` fed 10,000 rows | paginate; it does not virtualise |
| Sorting wired to `onSortChanged` only | a column is sortable only if it has `compare` |
''';

// ---------------------------------------------------------------------------
// references/<group>.md
// ---------------------------------------------------------------------------

String _reference(String group, List<DocPage> pages) {
  final out = StringBuffer()
    ..writeln('# $group')
    ..writeln()
    ..writeln(_generatedNote)
    ..writeln();

  for (final page in pages) {
    out
      ..writeln('## ${page.title}')
      ..writeln();

    final provenance = <String>[
      if (page.source != null) '`${page.source}`',
      if (page.upstream != null) 'upstream `${page.upstream}`',
    ];
    if (provenance.isNotEmpty) {
      out
        ..writeln(provenance.join(' · '))
        ..writeln();
    }

    out
      ..writeln(_plain(page.description))
      ..writeln();

    final snippet = _canonicalSnippet(page);
    if (snippet != null) {
      out
        ..writeln('```dart')
        ..writeln(snippet.trimRight())
        ..writeln('```')
        ..writeln();
    }

    final rules = page.blocks.whereType<DocCallout>().toList();
    if (rules.isNotEmpty) {
      out
        ..writeln('**Rules**')
        ..writeln();
      for (final rule in rules) {
        out.writeln('- **${rule.kind.label}:** ${_plain(rule.text)}');
      }
      out.writeln();
    }

    for (final table in page.blocks.whereType<DocTable>()) {
      out.writeln(_table(table.headers, table.rows, title: table.title));
    }

    for (final api in page.blocks.whereType<DocApi>()) {
      out
        ..writeln('### ${api.title}')
        ..writeln()
        ..writeln(
          _table(
            const <String>['Property', 'Type', 'Default', 'Notes'],
            <List<String>>[
              for (final prop in api.props)
                <String>[
                  '`${prop.name}`${prop.required ? ' **(required)**' : ''}',
                  '`${prop.type}`',
                  _default(prop.defaultValue),
                  prop.description,
                ],
            ],
          ),
        );
    }

    out
      ..writeln('---')
      ..writeln();
  }

  return out.toString();
}

/// A default, or an em dash where there is none.
String _default(String? value) => value == null ? '—' : '`$value`';

/// The snippet an agent should copy first: the page's opening example.
String? _canonicalSnippet(DocPage page) {
  for (final block in page.blocks) {
    if (block is DocExample) return docSnippets[block.snippetId];
    if (block is DocCode && block.language == 'dart') return block.code;
  }
  return null;
}

// ---------------------------------------------------------------------------
// references/enums.md
// ---------------------------------------------------------------------------

/// Scrapes every public `Astryx*` enum out of the package source.
///
/// Read from the source rather than restated here, because a list of valid
/// values that has drifted is worse than no list at all.
String _enums() {
  final files =
      Directory(_packageLib)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final found = <String, List<String>>{};

  for (final file in files) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final match = RegExp(r'^enum (Astryx\w+)').firstMatch(lines[i]);
      if (match == null) continue;
      // `@internal` sits directly above the declaration it applies to.
      if (i > 0 && lines[i - 1].trim() == '@internal') continue;

      final values = <String>[];
      for (var j = i + 1; j < lines.length; j++) {
        final line = lines[j];
        if (RegExp(
          '^  (const |final |static |[A-Z]|bool |double |int )',
        ).hasMatch(line)) {
          break;
        }
        if (line.startsWith('}')) break;
        final value = RegExp(
          r'^  ([a-z][A-Za-z0-9_]*)\s*[,;(]',
        ).firstMatch(line);
        if (value != null) values.add(value.group(1)!);
      }
      if (values.isNotEmpty) found[match.group(1)!] = values;
    }
  }

  final names = found.keys.toList()..sort();

  final out = StringBuffer()
    ..writeln('# Enums')
    ..writeln()
    ..writeln(_generatedNote)
    ..writeln()
    ..writeln(
      'Scraped from the package source, so this is what the analyser will '
      'accept. ${names.length} public enums.',
    )
    ..writeln()
    ..writeln('| Enum | Values |')
    ..writeln('| --- | --- |');

  for (final name in names) {
    final values = found[name]!.map((v) => '`$v`').join(', ');
    out.writeln('| `$name` | $values |');
  }

  out
    ..writeln()
    ..writeln('## Notes')
    ..writeln()
    ..writeln(
      '- `AstryxCardVariant` and `AstryxBadgeVariant` are **not** enums: they '
      'are classes with `static const` members (`standard`, `muted`, '
      '`transparent`, `neutral`, `info`, `success`, `warning`, `error`) plus a '
      '`.palette(AstryxPalette)` constructor.',
    )
    ..writeln(
      '- `AstryxTableColumnWidth` is a sealed class with three constructors: '
      '`.flex([factor])`, `.fixed(width)` and `.intrinsic(min:, max:)`.',
    )
    ..writeln(
      '- `AstryxFieldStatus` is a class: `AstryxFieldStatus.error(message)`, '
      '`.warning(message)`, `.success(message)`.',
    )
    ..writeln(
      '- The token enums (`AstryxColorToken`, `AstryxSpacingToken`, …) name '
      "upstream's CSS custom properties one for one: "
      '`AstryxColorToken.backgroundCard` is `--color-background-card`.',
    );

  return out.toString();
}

// ---------------------------------------------------------------------------
// references/patterns.md
// ---------------------------------------------------------------------------

/// Whole-screen recipes, each pointing at an example that compiles.
const List<(String, String, String)> _patternIds = <(String, String, String)>[
  (
    'A form in a card',
    'card_demo',
    'Header, body, footer. The footer stretches its buttons because the stack '
        'asks for `AstryxStackAlign.stretch`.',
  ),
  (
    'Validation that is announced, not just coloured',
    'text_input_validation',
    'An `AstryxFieldStatus` draws the ring, shows the icon and prints the '
        'message. Validate on blur or submit in a real form.',
  ),
  (
    'A settings list',
    'switch_settings_list',
    'Label at the reading edge, control at the trailing one: '
        '`labelPosition: start` plus `labelSpacing: spread`.',
  ),
  (
    'A destructive flow',
    'dialog_demo',
    'The dialog is a widget in the tree. Note the controller is disposed with '
        'the state.',
  ),
  (
    'A table with sorting',
    'table_sorting',
    'Sorting state lives in the caller. Only columns with `compare` become '
        'buttons, and the cycle ends in unsorted.',
  ),
  (
    'A table with selection',
    'table_selection',
    'The header checkbox governs the visible rows. `rowLabelOf` is what names '
        "each row's checkbox.",
  ),
  (
    'A table with row actions',
    'table_row_actions',
    'Always visible, never hover-only.',
  ),
  (
    'An undoable action',
    'toast_action',
    'Hover and focus pause the timeout, so the Undo button cannot vanish '
        'mid-reach.',
  ),
  (
    'A menu with sections and a destructive item',
    'dropdown_menu_sections',
    'Sections and dividers are skipped by the keyboard.',
  ),
  (
    'A responsive tile wall',
    'grid_responsive',
    'No breakpoints: the column count falls out of the available width.',
  ),
  (
    'An empty state',
    'empty_state_demo',
    'What `AstryxList.empty` and `AstryxTable.emptyState` hold. Say why it is '
        'empty and offer the way out.',
  ),
  (
    'A list of rows',
    'list_demo',
    'The list carries the dividers, the density and the name; the rows carry '
        'nothing but themselves.',
  ),
  (
    'A custom theme, and re-theming a subtree',
    'theming_themes',
    'A theme is a value. Nesting a provider re-themes everything below it.',
  ),
];

String _patterns() {
  final out = StringBuffer()
    ..writeln('# Patterns')
    ..writeln()
    ..writeln(_generatedNote)
    ..writeln()
    ..writeln(
      'Each of these is lifted from a widget that compiles and renders in '
      '`example/lib/examples/`. Copy the shape, not just the call.',
    )
    ..writeln();

  for (final (title, id, note) in _patternIds) {
    final source = docSnippets[id];
    if (source == null) {
      stderr.writeln('No snippet "$id" — run gen_snippets.dart first.');
      exit(1);
    }
    out
      ..writeln('## $title')
      ..writeln()
      ..writeln(note)
      ..writeln()
      ..writeln('```dart')
      ..writeln(source.trimRight())
      ..writeln('```')
      ..writeln();
  }

  return out.toString();
}

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

String _table(
  List<String> headers,
  List<List<String>> rows, {
  String? title,
}) {
  final out = StringBuffer();
  if (title != null) out.writeln('**${_plain(title)}**\n');

  out
    ..writeln('| ${headers.map((h) => h.isEmpty ? ' ' : h).join(' | ')} |')
    ..writeln('| ${headers.map((_) => '---').join(' | ')} |');

  for (final row in rows) {
    final cells = row.map((cell) => _plain(cell).replaceAll('|', r'\|'));
    out.writeln('| ${cells.join(' | ')} |');
  }

  return out.toString();
}

/// Turns a page-id link into something an agent can act on.
///
/// `[AstryxBanner](banner)` becomes ``` `AstryxBanner` (references/surfaces.md)
/// ```, because a relative path out of a skill directory is noise and a bare
/// label loses the pointer.
String _plain(String text) => text.replaceAllMapped(
  RegExp(r'\[([^\]]+)\]\(([^)]+)\)'),
  (match) {
    final label = match.group(1)!;
    final page = docPageOrNull(match.group(2)!);
    if (page == null) return '$label (${match.group(2)})';
    return '$label (references/${_groupFiles[page.group]})';
  },
);
