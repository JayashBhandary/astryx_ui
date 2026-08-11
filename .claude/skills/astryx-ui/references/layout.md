# Layout & typography

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxText

`lib/src/components/layout/text.dart` · upstream `Text`

A run of text, sized and coloured from the type scale.

```dart
class TextDemoExample extends StatelessWidget {
  const TextDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxText('Requests are up 12% this week.'),
        AstryxText(
          'Compared with the seven days before.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Truncation is a painting concern and never reaches the semantics tree: a screen reader always gets the whole string, ellipsis or not.

| Type | For |
| --- | --- |
| `display1` … `display3` | Marketing-scale numbers and hero text. Rarely inside a tool. |
| `large` | Body copy one step up, for emphasis. |
| `body` | The default. |
| `label` | Form and control labels. |
| `supporting` | Hints, captions, helper text. |
| `code` | Inline and block code, in the code family. |

### AstryxText

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `data` **(required)** | `String` | — | The text to display. The positional first argument. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The semantic role, which selects the type-scale row. |
| `color` | `AstryxTextColor` | `AstryxTextColor.primary` | The semantic colour. |
| `weight` | `AstryxTextWeight?` | — | Overrides the weight the `type` would give. |
| `size` | `AstryxTextSizeToken?` | — | Overrides the size from the raw ramp. The line height stays the role’s, so this changes the leading ratio — usually not what you want. |
| `justify` | `AstryxTextJustify?` | — | Alignment within the box. Logical, so it flips under RTL. |
| `maxLines` | `int?` | — | Lines before the text is truncated. |
| `overflow` | `TextOverflow?` | — | How overflow is handled. Defaults to `ellipsis` when `maxLines` is set, `clip` otherwise. |
| `truncateTooltip` | `bool` | `false` | Whether to show the full text in a tooltip when — and only when — it is cut off. |
| `softWrap` | `bool` | `true` | Whether the text wraps at soft breaks. |
| `strikethrough` | `bool` | `false` | Whether to strike the text through. |
| `tabularNumbers` | `bool` | `false` | Whether digits use fixed-width figures. |
| `semanticsLabel` | `String?` | — | An alternative string for a screen reader. |
| `style` | `TextStyle?` | — | Applied over the resolved style. |
| `theme` | `AstryxTextTheme?` | — | Visual overrides, merged over `AstryxThemeData.text`. |

---

## AstryxHeading

`lib/src/components/layout/heading.dart` · upstream `Heading`

A heading: a size from the scale, and a level in the outline.

```dart
class HeadingDemoExample extends StatelessWidget {
  const HeadingDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxHeading('Workspace settings'),
        AstryxText(
          'Who can join, and what they can do once they have.',
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

**Rules**

- **Accessibility:** Do not skip levels to get a size. An h2 followed by an h4 tells a screen-reader user a section is missing. Use `type` for the size and keep `level` honest.

### AstryxHeading

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `data` **(required)** | `String` | — | The heading text. The positional first argument. |
| `level` | `int` | `2` | The heading level, 1–6. Drives both size and semantics. |
| `type` | `AstryxHeadingType?` | — | A display size to use instead of `level`’s own. The semantic level is unaffected. |
| `color` | `AstryxTextColor` | `AstryxTextColor.primary` | The semantic colour. |
| `accessibilityLevel` | `int?` | — | Overrides the level announced to assistive technology. |
| `justify` | `AstryxTextJustify?` | — | Alignment within the box. |
| `maxLines` | `int?` | — | Lines before truncation. |
| `overflow` | `TextOverflow?` | — | How overflow is handled. |
| `softWrap` | `bool` | `true` | Whether the heading wraps. |
| `strikethrough` | `bool` | `false` | Whether to strike it through. |
| `semanticsLabel` | `String?` | — | An alternative string for a screen reader. |
| `style` | `TextStyle?` | — | Applied over the resolved style. |
| `theme` | `AstryxTextTheme?` | — | Visual overrides, merged over `AstryxThemeData.heading`. |

---

## AstryxHStack & AstryxVStack

`lib/src/components/layout/stack.dart` · upstream `HStack / VStack`

A row and a column whose gap comes from the spacing scale.

```dart
class StackDemoExample extends StatelessWidget {
  const StackDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxHeading('Invite teammates', level: 4),
        const AstryxText(
          'They will get an email with a link that expires in seven days.',
          color: AstryxTextColor.secondary,
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(label: 'Cancel', onPressed: () {}),
            AstryxButton(
              label: 'Send invites',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
```

**Rules**

- **Careful:** `justify` appears to do nothing when the stack is only as wide as its children. That is `mainAxisSize: min` doing its job — ask for `MainAxisSize.max` when you want the space distributed.

### AstryxHStack

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The widgets to lay out, in order. |
| `gap` | `AstryxSpacingToken?` | — | The space between children. |
| `justify` | `AstryxStackJustify` | `AstryxStackJustify.start` | Distribution along the main axis. |
| `align` | `AstryxStackAlign` | `center (HStack) / start (VStack)` | Alignment across the cross axis. |
| `wrap` | `bool` | `false` | Whether children wrap onto further lines. |
| `runGap` | `AstryxSpacingToken?` | — | The space between wrapped lines. Defaults to `gap`. |
| `mainAxisSize` | `MainAxisSize` | `MainAxisSize.min` | Whether the stack takes all the main-axis space or only what it needs. |

---

## AstryxGrid

`lib/src/components/layout/grid.dart` · upstream `Grid / GridSpan`

A CSS-style grid: fixed tracks, or as many as the width allows.

```dart
class GridDemoExample extends StatelessWidget {
  const GridDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxGrid(
      columns: 3,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
        _Metric('Seats', '24'),
      ],
    );
  }
}
```

**Rules**

- **Note:** The grid lays its children out in rows and never scrolls. For hundreds of tiles, put it in a scroll view — or reach for a Flutter sliver grid, which builds lazily.

### AstryxGrid

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `children` **(required)** | `List<Widget>` | — | The widgets to lay out, in order. |
| `columns` | `int?` | — | A fixed number of equal columns. |
| `minWidth` | `double?` | — | The minimum column width, for a responsive track list. |
| `maxColumns` | `int?` | — | A ceiling on the responsive column count. |
| `repeat` | `AstryxGridRepeat` | `AstryxGridRepeat.fit` | Whether empty tracks collapse. Only meaningful with `minWidth`. |
| `gap` | `AstryxSpacingToken?` | — | The space between items on both axes. |
| `rowGap` | `AstryxSpacingToken?` | — | The space between rows. |
| `columnGap` | `AstryxSpacingToken?` | — | The space between columns. |

---

## AstryxCenter

`lib/src/components/layout/center.dart` · upstream `Center`

Centres a child, with token padding and a measure.

```dart
class CenterDemoExample extends StatelessWidget {
  const CenterDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCenter(
      minHeight: 200,
      padding: AstryxSpacingToken.spacing6,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxIcon(
            AstryxIconName.search,
            size: AstryxIconSize.lg,
            color: AstryxIconColor.secondary,
          ),
          const AstryxHeading('No projects yet', level: 4),
          const AstryxText(
            'Create one to start collecting requests.',
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          AstryxButton(
            label: 'New project',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```

### AstryxCenter

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The widget to centre. |
| `axis` | `AstryxCenterAxis` | `AstryxCenterAxis.both` | Which axes to centre on. |
| `padding` | `AstryxSpacingToken?` | — | Padding on every side. The two axis-specific values override it. |
| `paddingInline` | `AstryxSpacingToken?` | — | Padding on the inline axis — start and end, so it flips under RTL. |
| `paddingBlock` | `AstryxSpacingToken?` | — | Padding on the block axis — top and bottom. |
| `width` | `double?` | — | A fixed width. |
| `height` | `double?` | — | A fixed height. |
| `maxWidth` | `double?` | — | A ceiling on the width, for a centred column of text. |
| `minHeight` | `double?` | — | A floor under the height, so an empty state does not collapse. |

---

## AstryxDivider

`lib/src/components/layout/divider.dart` · upstream `Divider`

A rule between sections, optionally labelled.

```dart
class DividerDemoExample extends StatelessWidget {
  const DividerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('Personal details'),
        AstryxDivider(),
        AstryxText('Billing'),
      ],
    );
  }
}
```

**Rules**

- **Careful:** The `subtle` variant is roughly 1.1:1 against its background — deliberately, matching upstream. It is decoration. Never use it as a control's only visible boundary, and never to convey information.

### AstryxDivider

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `axis` | `Axis` | `Axis.horizontal` | Whether the rule runs horizontally or vertically. |
| `variant` | `AstryxDividerVariant` | `AstryxDividerVariant.subtle` | How prominent the rule is. |
| `label` | `String?` | — | Text shown in the middle of the rule. Horizontal only. |
| `theme` | `AstryxDividerTheme?` | — | Visual overrides, merged over `AstryxThemeData.divider`. |

---

## AstryxIcon

`lib/src/components/layout/icon.dart` · upstream `Icon`

A glyph named semantically and resolved through the theme.

```dart
class IconDemoExample extends StatelessWidget {
  const IconDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxIcon(AstryxIconName.success, color: AstryxIconColor.success),
        AstryxText('Deployment finished'),
      ],
    );
  }
}
```

### AstryxIcon

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `name` **(required)** | `AstryxIconName` | — | The semantic name. The positional first argument. |
| `size` | `AstryxIconSize?` | — | The size step. Null inherits from the enclosing `IconTheme`, then falls back to `md`. |
| `color` | `AstryxIconColor` | `AstryxIconColor.inherit` | The semantic colour. |
| `label` | `String?` | — | An accessible name. Null — the default — marks the icon decorative. |
| `mirrorForRtl` | `bool?` | — | Overrides whether the glyph mirrors under RTL. |
| `theme` | `AstryxIconTheme?` | — | Visual overrides, merged over `AstryxThemeData.icon`. |

---

## AstryxVisuallyHidden

`lib/src/foundation/semantics.dart` · upstream `VisuallyHidden`

Content present for a screen reader and absent from the screen.

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

**Rules**

- **Careful:** Upstream’s `VisuallyHidden` does **two** jobs, and only one of them needs a widget here. Reaching for it to name a control is the most common false friend in the whole port — read both sections below before using it.
- **Accessibility:** A live region interrupts whatever is being read. Reserve it for changes the user must hear — an error, a destructive result, a limit reached. Progress that merely happens should not talk over the thing the reader is trying to listen to. See Accessibility (references/guides.md).

### AstryxVisuallyHidden

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content to announce but not paint. |
| `liveRegion` | `bool` | `false` | Whether a change to the content is announced as it happens, interrupting. |

---

