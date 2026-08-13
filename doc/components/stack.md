---
title: AstryxHStack & AstryxVStack
description: A row and a column whose gap comes from the spacing scale.
component: true
group: Layout & typography
source: lib/src/components/layout/stack.dart
upstream: HStack / VStack
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
AstryxVStack(
  gap: AstryxSpacingToken.spacing3,
  align: AstryxStackAlign.stretch,
  children: <Widget>[
    const AstryxHeading('Invite teammates', level: 4),
    AstryxButton(label: 'Send invites', onPressed: send),
  ],
)
```

A `Row` with a token gap, in short — plus two differences from Flutter that are worth knowing. `mainAxisSize` defaults to `min`, not `max`, because a design-system stack is usually a small cluster inside a larger layout; and `AstryxHStack` centres on the cross axis by default, which is what puts an icon on the text’s optical centre.

> **Careful**
>
> `justify` appears to do nothing when the stack is only as wide as its children. That is `mainAxisSize: min` doing its job — ask for `MainAxisSize.max` when you want the space distributed.

## Justify

```dart
class StackJustifyExample extends StatelessWidget {
  const StackJustifyExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `justify` only bites when the stack has room to distribute, which is why
    // each row asks for `MainAxisSize.max`.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final justify in AstryxStackJustify.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(justify.name, type: AstryxTextType.label),
              AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                justify: justify,
                mainAxisSize: MainAxisSize.max,
                children: const <Widget>[
                  _Box('one'),
                  _Box('two'),
                  _Box('three'),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
```


## Align

The cross axis. `stretch` is what makes a column of buttons the same width. It has no `Wrap` equivalent, so a wrapping stack falls back to `start`.

```dart
class StackAlignExample extends StatelessWidget {
  const StackAlignExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final align in AstryxStackAlign.values)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(align.name, type: AstryxTextType.label),
              SizedBox(
                height: 72,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  align: align,
                  children: const <Widget>[
                    _Box('24', height: 24),
                    _Box('40', height: 40),
                    _Box('56', height: 56),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
```


## Wrapping

`wrap: true` flows children onto further lines, spaced by `runGap` — the right shape for a bag of tags, and never for a form.

```dart
class StackWrapExample extends StatelessWidget {
  const StackWrapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 280,
      child: AstryxHStack(
        wrap: true,
        gap: AstryxSpacingToken.spacing2,
        runGap: AstryxSpacingToken.spacing2,
        children: <Widget>[
          AstryxBadge('flutter'),
          AstryxBadge('design-system'),
          AstryxBadge('tokens'),
          AstryxBadge('accessibility'),
          AstryxBadge('theming'),
          AstryxBadge('rtl'),
        ],
      ),
    );
  }
}
```


## Nesting

The everyday shape of a settings row: a spreading row holding a column that hugs.

```dart
class StackNestedExample extends StatelessWidget {
  const StackNestedExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The everyday shape: a row that spreads, holding a column that does not.
    return AstryxCard(
      maxWidth: 420,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing4,
        justify: AstryxStackJustify.between,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // `Flexible`, because a spreading row hands its children their
          // natural width — and two lines of copy will happily exceed a card.
          const Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing0_5,
              children: <Widget>[
                AstryxText('Two-factor authentication'),
                AstryxText(
                  'Required for every admin',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
          AstryxButton(
            label: 'Manage',
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```


### AstryxHStack

A horizontal stack. `AstryxVStack` takes exactly the same parameters; only the default `align` differs — `start` rather than `center`.

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `children` *(required)* | `List<Widget>` | — | The widgets to lay out, in order. |
| `gap` | `AstryxSpacingToken?` | — | The space between children. |
| `justify` | `AstryxStackJustify` | `AstryxStackJustify.start` | Distribution along the main axis. |
| `align` | `AstryxStackAlign` | `center (HStack) / start (VStack)` | Alignment across the cross axis. |
| `wrap` | `bool` | `false` | Whether children wrap onto further lines. |
| `runGap` | `AstryxSpacingToken?` | — | The space between wrapped lines. Defaults to `gap`. |
| `mainAxisSize` | `MainAxisSize` | `MainAxisSize.min` | Whether the stack takes all the main-axis space or only what it needs. |


## Related

- [AstryxGrid](grid.md) — for two-dimensional layout.
- [AstryxCenter](center.md) — for centring one child.
- [Design tokens](../guides/tokens.md) — the spacing scale `gap` names.

---

Something wrong with `AstryxHStack & AstryxVStack`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxHStack+%26+AstryxVStack&component=AstryxHStack+%26+AstryxVStack) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxHStack+%26+AstryxVStack&area=AstryxHStack+%26+AstryxVStack) — both templates arrive with the component filled in.
