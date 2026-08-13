---
title: Centred hero
description: A headline, a supporting line, and one action.
component: true
group: Templates
source: example/lib/examples/template_screen_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CenteredHeroTemplate extends StatelessWidget {
  const CenteredHeroTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    // One measure, one heading, one action. `maxWidth` is what keeps the
    // supporting line readable — a hero that runs the full width of a desktop
    // window is a paragraph nobody finishes.
    return AstryxCenter(
      maxWidth: 620,
      minHeight: 360,
      padding: AstryxSpacingToken.spacing8,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing5,
        align: AstryxStackAlign.center,
        children: <Widget>[
          const AstryxBadge(
            'Now in every region',
            variant: AstryxBadgeVariant.info,
            icon: AstryxIcon(AstryxIconName.info),
          ),
          const AstryxHeading(
            'Every deploy, every incident, one timeline',
            level: 1,
            type: AstryxHeadingType.display2,
            justify: AstryxTextJustify.center,
          ),
          const AstryxText(
            'Atlas watches the services you already run and tells you which '
            'change caused the graph to bend.',
            type: AstryxTextType.large,
            color: AstryxTextColor.secondary,
            justify: AstryxTextJustify.center,
          ),
          // One `primary` in the view. The second action is secondary, not a
          // second primary: two of them side by side is a question.
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            wrap: true,
            runGap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.center,
            children: <Widget>[
              AstryxButton(
                label: 'Start free',
                variant: AstryxButtonVariant.primary,
                size: AstryxButtonSize.lg,
                onPressed: () {},
              ),
              AstryxButton(
                label: 'Read the docs',
                size: AstryxButtonSize.lg,
                trailing: const AstryxIcon(
                  AstryxIconName.externalLink,
                  size: AstryxIconSize.sm,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const AstryxText(
            'No card. Two minutes to the first graph.',
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
    );
  }
}
```


## The measure is the design

`AstryxCenter(maxWidth: 620)` is what makes this readable. A supporting line that runs the full width of a desktop window is a paragraph nobody finishes, and no amount of type scale fixes it.

The heading uses `type: AstryxHeadingType.display2` for the size and keeps `level: 1` for the outline. Those are two different jobs: the display types are marketing scale, the level is what a screen reader navigates by. Reaching for a bigger `level` to get a bigger size is how a page ends up with three h1s.

## One primary action

**Start free** is `primary`; **Read the docs** is `secondary` with an `externalLink` icon. Two primary buttons side by side is a question, not a recommendation — the whole point of the variant is that exactly one thing in a view is the thing to do.

Both are `AstryxButtonSize.lg`, and the row is `wrap: true` so the two actions stack on a phone rather than shrinking below a comfortable tap target.

```text
AstryxCenter(maxWidth: 620, minHeight: 360)
└── AstryxVStack(gap: spacing5, align: center)
    ├── AstryxBadge      ← the one-line claim
    ├── AstryxHeading(display2, level: 1)
    ├── AstryxText(large, secondary)
    ├── AstryxHStack(wrap: true) ← primary + secondary
    └── AstryxText(supporting)   ← what it costs to try
```

## Related

- [AstryxHeading](heading.md) — levels, display types, and why they differ.
- [AstryxCenter](center.md) — the measure, the padding and the minimum height.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Centred hero`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Centred+hero&component=Centred+hero) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Centred+hero&area=Centred+hero) — both templates arrive with the component filled in.
