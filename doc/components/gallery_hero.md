---
title: Gallery hero
description: A hero whose supporting content is a media grid.
component: true
group: Templates
source: example/lib/examples/template_media_examples.dart
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class GalleryHeroTemplate extends StatefulWidget {
  const GalleryHeroTemplate({super.key});

  @override
  State<GalleryHeroTemplate> createState() => _GalleryHeroTemplateState();
}

class _GalleryHeroTemplateState extends State<GalleryHeroTemplate> {
  static const List<Shot> _shots = <Shot>[
    (
      name: 'The rack view',
      caption: 'Every machine in a region, and what it is doing right now.',
      ratio: 16 / 9,
    ),
    (
      name: 'The deploy timeline',
      caption: 'One row per service, one column per minute.',
      ratio: 16 / 9,
    ),
    (
      name: 'The incident console',
      caption: 'Severity, the people on it, and the last thing that changed.',
      ratio: 16 / 9,
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // A hero is a claim and one action. The media underneath it is *evidence*
    // for the claim, which is why it is a strip the reader can page rather
    // than a wall they have to scan.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing8,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxCenter(
          maxWidth: 620,
          padding: AstryxSpacingToken.spacing0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.center,
            children: <Widget>[
              const AstryxBadge(
                'Atlas 4',
                variant: AstryxBadgeVariant.info,
                icon: AstryxIcon(AstryxIconName.info),
              ),
              const AstryxHeading(
                'See the whole fleet at once',
                level: 1,
                type: AstryxHeadingType.display2,
                justify: AstryxTextJustify.center,
              ),
              const AstryxText(
                'Every deploy, every incident and every machine on one screen '
                '— and the same screen on a phone at three in the morning.',
                type: AstryxTextType.large,
                color: AstryxTextColor.secondary,
                justify: AstryxTextJustify.center,
              ),
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
                    label: 'Watch the tour',
                    size: AstryxButtonSize.lg,
                    trailing: const AstryxIcon(
                      AstryxIconName.externalLink,
                      size: AstryxIconSize.sm,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        // The strip is one tab stop with its own arrow keys and its own "2 of
        // 3" readout, so the position is never something the reader has to
        // infer from how far a scrollbar has moved.
        AstryxCarousel(
          label: 'Product screens',
          height: 260,
          viewportFraction: 0.86,
          onIndexChanged: (index) => setState(() => _index = index),
          items: <Widget>[
            for (final shot in _shots) _HeroPanel(shot: shot),
          ],
        ),
        // The caption is on the page, not over the picture. A hero's
        // supporting line is content, and content behind a scrim is content
        // somebody decided was decoration.
        AstryxCenter(
          maxWidth: 620,
          padding: AstryxSpacingToken.spacing0,
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.center,
            children: <Widget>[
              AstryxText(
                _shots[_index].name,
                type: AstryxTextType.label,
                justify: AstryxTextJustify.center,
              ),
              AstryxText(
                _shots[_index].caption,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
                justify: AstryxTextJustify.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One panel of the hero strip: a picture, and its name over it.
class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.shot});

  final Shot shot;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing(AstryxSpacingToken.spacing2),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AstryxAspectRatio(
              ratio: shot.ratio,
              background: AstryxColorToken.backgroundInverted,
              semanticsLabel: shot.name,
              child: const Center(
                child: AstryxMediaTheme(
                  scrim: AstryxMediaScrim.none,
                  padding: AstryxSpacingToken.spacing0,
                  child: AstryxIcon(
                    AstryxIconName.viewColumns,
                    size: AstryxIconSize.lg,
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: 0,
              end: 0,
              bottom: 0,
              child: AstryxMediaTheme(
                child: AstryxText(
                  shot.name,
                  color: AstryxTextColor.inherit,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Page the strip with the controls or the arrow keys: the caption under it follows, because it is on the page rather than over the picture.


## The pictures are evidence, not decoration

A [centred hero](centered_hero.md) makes a claim and offers one action. This one makes the same claim and then *shows* it — which is a different job from a picture behind a headline, and it is why the media is a strip the reader can page rather than a wall they have to scan.

[AstryxCarousel](carousel.md) is doing that work: one tab stop, arrow keys, and a "2 of 3" readout the reader is given rather than left to infer from how far a scrollbar has moved.

```dart
AstryxCarousel(
  label: 'Product screens',
  height: 260,
  viewportFraction: 0.86,     // ← the next panel peeks, so there is one
  onIndexChanged: (index) => setState(() => _index = index),
  items: <Widget>[for (final shot in _shots) _HeroPanel(shot: shot)],
)
```

`viewportFraction: 0.86` is the whole affordance. A strip whose items each fill the viewport looks like one picture, and nobody presses an arrow to find out whether there is a second.

## The caption is on the page

The name and the supporting line under the strip are content, and they change with the panel. Only the panel’s own short title sits over the picture, through [AstryxMediaTheme](media_theme.md) — content behind a scrim is content somebody has already decided was decoration.

```text
AstryxVStack(gap: spacing8)
├── AstryxCenter(maxWidth: 620)   ← badge, display heading, line, two actions
├── AstryxCarousel(height: 260)   ← the panels
└── AstryxCenter(maxWidth: 620)   ← the current panel’s name and caption
```

> **Note**
>
> The heading is `type: display2` with `level: 1`. Those are two different jobs — the display types are the size, the level is the outline a screen reader navigates — and reaching for a bigger level to get a bigger size is how a page ends up with three h1s.

> **Accessibility**
>
> Every panel carries a `semanticsLabel` on its [AstryxAspectRatio](aspect_ratio.md). A hero whose pictures announce nothing is a hero that reads, to a screen reader, as a headline and two buttons — which is the [centred hero](centered_hero.md), not this.

## Related

- [Centred hero](centered_hero.md) — the same claim, with no media at all.
- [AstryxCarousel](carousel.md) — the paging, the keyboard map and the position readout.
- [Classic gallery](classic_gallery.md) — media as the content rather than the evidence.

> **Note**
>
> None of this is exported. `LoginTemplate` and the rest live in the documentation site, not in the package — copy the composition into your own widget and rename it. A design system that shipped your login screen would be shipping your product.

---

Something wrong with `Gallery hero`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+Gallery+hero&component=Gallery+hero) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+Gallery+hero&area=Gallery+hero) — both templates arrive with the component filled in.
