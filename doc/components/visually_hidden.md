---
title: AstryxVisuallyHidden
description: Content present for a screen reader and absent from the screen.
component: true
group: Layout & typography
source: lib/src/foundation/semantics.dart
upstream: VisuallyHidden
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

A child that is announced but never painted, and that measures nothing. It exists for one situation: a change the user has to hear about, with no widget for it to be the name of.

> **Careful**
>
> Upstream’s `VisuallyHidden` does **two** jobs, and only one of them needs a widget here. Reaching for it to name a control is the most common false friend in the whole port — read both sections below before using it.

## The job it is for

A count, a result total, a status that has just changed. Nothing on screen owns the string, so there is no label to hang it on; a region of its own is the only place it can go.

```dart
class VisuallyHiddenLiveExample extends StatefulWidget {
  const VisuallyHiddenLiveExample({super.key});

  @override
  State<VisuallyHiddenLiveExample> createState() =>
      _VisuallyHiddenLiveExampleState();
}

class _VisuallyHiddenLiveExampleState extends State<VisuallyHiddenLiveExample> {
  static const int _limit = 40;

  final TextEditingController _controller = TextEditingController();
  int _remaining = _limit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The count is the announcement. There is no widget it could be the name
    // of — the input is already named "Summary" — so the only way to report it
    // is a region of its own.
    final announcement = '$_remaining characters remaining';

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTextInput(
          label: 'Summary',
          controller: _controller,
          maxLength: _limit,
          placeholder: 'What changed, in one line',
          onChanged: (value) =>
              setState(() => _remaining = _limit - value.length),
        ),
        AstryxVisuallyHidden(
          liveRegion: true,
          child: Text(announcement),
        ),
        // The same string, painted, so this page can show what is otherwise
        // only audible. A real form would not draw it twice.
        AstryxText(
          'A screen reader hears: “$announcement”',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


```dart
AstryxVisuallyHidden(
  liveRegion: true,
  child: Text('$remaining characters remaining'),
)
```

Rebuilding it with different content is what announces the change. `liveRegion` is what makes that announcement interrupt, rather than wait to be found.

## The job it is not for

In React, hidden text inside a button is how the button gets its accessible name. Flutter has a better answer, and using this widget for it produces a control with an empty name and a stray label loose in the tree beside it.

```dart
// Wrong — a hidden label is not how a control is named.
AstryxIconButton(
  icon: AstryxIconName.close,
  label: '',
  onPressed: _close,
)

// Right — the name is a parameter, and it is required.
AstryxIconButton(
  icon: AstryxIconName.close,
  label: 'Close',
  onPressed: _close,
)
```

Every control in the package takes its accessible name directly: `label` on [AstryxButton](button.md) and [AstryxIconButton](icon_button.md), `label` on [AstryxField](field.md) and on every input. Where a name has to be kept but not shown, that is `labelHidden` on the control itself — [AstryxTextInput](text_input.md), [AstryxCheckbox](checkbox.md), [AstryxSwitch](switch.md), [AstryxSelector](selector.md) and [AstryxTable](table.md) all have one.

> **Accessibility**
>
> A live region interrupts whatever is being read. Reserve it for changes the user must hear — an error, a destructive result, a limit reached. Progress that merely happens should not talk over the thing the reader is trying to listen to. See [Accessibility](../guides/accessibility.md).

## It occupies no space

The hidden child below sits between the two badges, and the row is laid out exactly as it would be without it.

```dart
class VisuallyHiddenSpaceExample extends StatelessWidget {
  const VisuallyHiddenSpaceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The hidden child sits between the two badges and measures `Size.zero`,
    // so the row looks exactly as it would without it. A test pins that.
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxBadge('Queued', variant: AstryxBadgeVariant.info),
        AstryxVisuallyHidden(
          child: Text('and it has been queued for eleven minutes'),
        ),
        AstryxBadge('Building', variant: AstryxBadgeVariant.warning),
      ],
    );
  }
}
```


A zero-sized box around a fully transparent child — not an `Offstage`, and not a `Visibility`. Both of those drop the subtree from the semantics tree as well as from the screen, which is the opposite of the point, and a plain `Opacity` would too: `alwaysIncludeSemantics` is what keeps the content readable. A test pins the size at `Size.zero` and the label in the tree.

### AstryxVisuallyHidden

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content to announce but not paint. |
| `liveRegion` | `bool` | `false` | Whether a change to the content is announced as it happens, interrupting. |


## Related

- [Accessibility](../guides/accessibility.md) — the announcement rules in full.
- [AstryxField](field.md) — labelling anything, including a control the package does not supply.
- [Migration](../guides/migration.md) — the other React and Material habits that do not carry over.

---

Something wrong with `AstryxVisuallyHidden`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxVisuallyHidden&component=AstryxVisuallyHidden) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxVisuallyHidden&area=AstryxVisuallyHidden) — both templates arrive with the component filled in.
