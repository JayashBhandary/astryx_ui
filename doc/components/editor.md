---
title: Editor
description: 'A document editor: toolbar, canvas, and an inspector panel.'
component: true
group: Templates
source: example/lib/examples/template_workspace_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // The same width the layout's own panel makes its mind up at, so the
        // frame and the panel change together rather than one at a time.
        final compact = constraints.maxWidth < 640;

        return SizedBox(
          // A header that has wrapped onto three lines and a panel that has
          // become a band above the canvas both cost height the wide frame
          // never had to find. Bands do not shrink, so the frame grows.
          height: compact ? 720 : 560,
          child: _layout(context, compact: compact),
        );
      },
    );
  }

  Widget _layout(BuildContext context, {required bool compact}) {
    return AstryxLayout(
      scrollable: false,
      panelWidth: 260,
      panelLabel: 'Document',
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
        // The count and the two actions take a line each rather than the
        // count being pushed off the start of the band.
        wrap: true,
        runGap: AstryxSpacingToken.spacing2,
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
      // The canvas, and the only thing on the screen that scrolls — in both
      // modes, and for the same reason. `minLines` becomes a minimum in
      // *pixels* once it has been measured, and it wins against the frame: a
      // field asking for twelve lines inside a band with room for nine
      // overflows rather than shrinking. Given a scroll view it keeps the
      // height it asked for and the reader gets at the rest by scrolling.
      child: SingleChildScrollView(
        child: _mode == 'write'
            ? AstryxTextArea(
                controller: _body,
                label: 'Document body',
                labelHidden: true,
                // Fewer lines on a phone all the same: a canvas that opens
                // taller than the window it is in has put the Save button
                // behind a scroll nobody was told about.
                minLines: compact ? 6 : 12,
                maxLines: 40,
              )
            : AstryxMarkdown(_body.text),
      ),
    );
  }
}
```

Select a phrase in the canvas and press **Bold**. Then switch to **Preview** — the toolbar disables, because there is nothing there to format.


## The toolbar edits the document, it does not style a model

This package ships no rich-text editing controller, and a toolbar that pretended otherwise would be three buttons that do nothing. So the document is its own markup and the buttons are *edits to it*: **Bold** wraps the selection in `**`, and the caret lands after it.

```dart
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
}
```

That is also why **Write** and **Preview** exist. The reader can see what the markup becomes, which is the thing a rich-text field would have been showing them all along.

> **Careful**
>
> **`scrollable: false` on the layout.** The canvas is an [AstryxTextArea](text_area.md) — or, in preview, a scroller of its own. Leaving the layout scrollable puts one scroll view inside another, and the inner one then measures unbounded, which is a layout assertion rather than a subtle bug.

## One tab stop for the whole band

[AstryxToolbar](toolbar.md) is what makes a formatting band usable by keyboard: Tab reaches it once and leaves it once, however many controls sit between, and the arrows move inside. Twelve buttons without it is twelve presses to walk past.

The tail is an [AstryxMoreMenu](more_menu.md) rather than four more buttons — and `label` is the trigger’s name, its tooltip *and* the menu’s name, because they are one answer to one question.

## The inspector is a panel, not a dialog

```text
AstryxLayout(scrollable: false, panelWidth: 260)
├── header ← the title field, the dirty badge, the toolbar, Write/Preview
├── child  ← the canvas (AstryxTextArea, or AstryxMarkdown in preview)
├── panel  ← status, tags, and the document’s history
└── footer ← the word count, Discard and Save
```

Status and tags belong beside the document, not behind a button: they are things the writer changes while writing. A dialog would make each one an interruption, and the reader would stop setting them.

> **Note**
>
> **Checkboxes and a selector here, because there is a Save button.** Nothing on this screen takes effect until it is pressed, so nothing on it may be an [AstryxSwitch](switch.md) — a switch would promise it already had. The [settings](settings.md) template is the other half of that rule.

> **Accessibility**
>
> The dirty state is a badge with an icon and words — *Unsaved changes* or *Saved* — and both footer buttons are `enabled: _dirty`. A disabled Save with no stated reason reads as broken; the badge is what turns it into a state the reader can see and act on.

## Related

- [IDE](ide.md) — the same shape when the document is code.
- [Two-column form](form_two_column.md) — the other screen with a Save button, and the same badge.
- [AstryxToolbar](toolbar.md) — the band, the divider and the traversal.
- [AstryxMarkdown](markdown.md) — what preview renders, and what it does not.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Editor`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Editor&component=Editor) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Editor&area=Editor) — both templates arrive with the component filled in.
