/// Three galleries that are not the same gallery.
///
/// `template_gallery_examples.dart` has the uniform wall — every tile the same
/// size, every tile the same weight. These are the three screens that follow
/// once that stops being true: media *supporting* something else, media at
/// sizes that differ on purpose, and one item at a time with the rest beside
/// it.
///
/// None of it is exported. Each is a composition worth copying, built from
/// nothing but what `astryx_ui` ships.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// One picture, everywhere in this library.
///
/// `name` is required rather than optional for the same reason it is on
/// [AstryxThumbnail]: a tile whose picture has not loaded, or whose reader
/// cannot see it, has nothing else.
typedef Shot = ({String name, String caption, double ratio});

// #example template_gallery_hero -> GalleryHeroTemplate
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
// #end

// #example template_mixed_gallery -> MixedGalleryTemplate
class MixedGalleryTemplate extends StatefulWidget {
  const MixedGalleryTemplate({super.key});

  @override
  State<MixedGalleryTemplate> createState() => _MixedGalleryTemplateState();
}

class _MixedGalleryTemplateState extends State<MixedGalleryTemplate> {
  /// The sizes differ because the pictures do.
  ///
  /// A panorama cropped to a square is a panorama nobody can read, and a
  /// portrait letterboxed into a 16:9 tile is mostly ground. Each item carries
  /// its own ratio and its own width, and the row wraps around them.
  static const List<({Shot shot, double width})> _items =
      <({Shot shot, double width})>[
        (
          shot: (
            name: 'Cold aisle, full length',
            caption: 'Panorama · 8064 × 2268',
            ratio: 32 / 9,
          ),
          width: 420,
        ),
        (
          shot: (
            name: 'Rack 14, door open',
            caption: 'Portrait · 3024 × 4032',
            ratio: 3 / 4,
          ),
          width: 170,
        ),
        (
          shot: (
            name: 'Patch panel B',
            caption: 'Square · 3024 × 3024',
            ratio: 1,
          ),
          width: 200,
        ),
        (
          shot: (
            name: 'Generator test',
            caption: 'Video · 1920 × 1080',
            ratio: 16 / 9,
          ),
          width: 300,
        ),
        (
          shot: (
            name: 'Health check log',
            caption: 'Screenshot · 1440 × 900',
            ratio: 8 / 5,
          ),
          width: 260,
        ),
      ];

  final AstryxOverlayController _viewer = AstryxOverlayController();

  int _index = 0;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  void _open(int index) {
    setState(() => _index = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Site visit', level: 1)),
            AstryxText(
              '${_items.length} items',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // A wrapping row, not an `AstryxGrid`. A grid gives every cell in a row
        // the height of the tallest — which is the whole thing this screen is
        // trying not to do, quite apart from the intrinsic measurement a
        // pressable tile cannot answer in touch density.
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          wrap: true,
          runGap: AstryxSpacingToken.spacing3,
          align: AstryxStackAlign.start,
          children: <Widget>[
            for (var i = 0; i < _items.length; i++)
              _MixedTile(
                shot: _items[i].shot,
                width: _items[i].width,
                onPressed: () => _open(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: _viewer,
          initialIndex: _index,
          label: 'Site visit',
          items: <AstryxLightboxItem>[
            for (final item in _items)
              AstryxLightboxItem(
                label: item.shot.name,
                caption: '${item.shot.name} · ${item.shot.caption}',
                // The viewer shows each item at its own ratio too. A gallery
                // that mixes shapes on the wall and squares them in the viewer
                // has lied about one of the two.
                child: SizedBox(
                  width: 640,
                  child: AstryxAspectRatio(
                    ratio: item.shot.ratio,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        item.shot.name,
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// One tile, at whatever size and shape its picture asks for.
class _MixedTile extends StatelessWidget {
  const _MixedTile({
    required this.shot,
    required this.width,
    required this.onPressed,
  });

  final Shot shot;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AstryxCard(
        padding: AstryxSpacingToken.spacing2,
        semanticsLabel: '${shot.name}, ${shot.caption}',
        onPressed: onPressed,
        footer: AstryxVStack(
          gap: AstryxSpacingToken.spacing0_5,
          children: <Widget>[
            AstryxText(shot.name, type: AstryxTextType.label, maxLines: 1),
            AstryxText(
              shot.caption,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 1,
            ),
          ],
        ),
        child: AstryxAspectRatio(
          ratio: shot.ratio,
          child: const Center(
            child: AstryxIcon(AstryxIconName.viewColumns),
          ),
        ),
      ),
    );
  }
}
// #end

// #example template_side_gallery -> SideGalleryTemplate
class SideGalleryTemplate extends StatefulWidget {
  const SideGalleryTemplate({super.key});

  @override
  State<SideGalleryTemplate> createState() => _SideGalleryTemplateState();
}

class _SideGalleryTemplateState extends State<SideGalleryTemplate> {
  static const List<Shot> _shots = <Shot>[
    (
      name: 'Latency, p95',
      caption: 'Captured 14:02 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Queue depth',
      caption: 'Captured 14:03 · scheduler-a',
      ratio: 16 / 9,
    ),
    (
      name: 'Retries per minute',
      caption: 'Captured 14:06 · scheduler-b',
      ratio: 16 / 9,
    ),
    (
      name: 'Error budget burn',
      caption: 'Captured 14:11 · platform',
      ratio: 16 / 9,
    ),
  ];

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final shot = _shots[_index];

    // One item at a time, with the rest reachable without leaving the screen.
    // This is the shape to reach for when the pictures are *evidence* — the
    // reader is comparing them against each other rather than browsing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(
              child: AstryxHeading('Incident 4102 · evidence', level: 1),
            ),
            AstryxText(
              '${_index + 1} of ${_shots.length}',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              tabularNumbers: true,
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final strip = _Strip(
              shots: _shots,
              index: _index,
              vertical: wide,
              onSelected: (index) => setState(() => _index = index),
            );

            final viewer = _Viewer(shot: shot);

            // The strip runs down the trailing edge when there is room for it
            // and across the bottom when there is not. Same widget, same
            // selection — only the axis moves.
            if (!wide) {
              return AstryxVStack(
                gap: AstryxSpacingToken.spacing3,
                align: AstryxStackAlign.stretch,
                children: <Widget>[viewer, strip],
              );
            }

            return AstryxHStack(
              gap: AstryxSpacingToken.spacing3,
              align: AstryxStackAlign.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(child: viewer),
                SizedBox(width: 132, child: strip),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// The item being looked at, and what is known about it.
class _Viewer extends StatelessWidget {
  const _Viewer({required this.shot});

  final Shot shot;

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing3,
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing0_5,
        children: <Widget>[
          AstryxText(shot.name, type: AstryxTextType.label),
          AstryxText(
            shot.caption,
            type: AstryxTextType.supporting,
            color: AstryxTextColor.secondary,
          ),
        ],
      ),
      child: AstryxAspectRatio(
        ratio: shot.ratio,
        semanticsLabel: shot.name,
        child: Center(
          child: AstryxText(shot.name, color: AstryxTextColor.secondary),
        ),
      ),
    );
  }
}

/// The strip of everything else, in whichever axis fits.
class _Strip extends StatelessWidget {
  const _Strip({
    required this.shots,
    required this.index,
    required this.vertical,
    required this.onSelected,
  });

  final List<Shot> shots;
  final int index;
  final bool vertical;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (var i = 0; i < shots.length; i++)
        // `selected` is what marks the current one, and the thumbnail draws it
        // as a ring rather than a tint — a tint over a picture is a change to
        // the picture.
        AstryxThumbnail(
          label: shots[i].name,
          icon: AstryxIconName.viewColumns,
          ratio: 16 / 9,
          width: vertical ? 116 : 104,
          selected: i == index,
          onPressed: () => onSelected(i),
        ),
    ];

    if (vertical) {
      return AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: tiles,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        children: tiles,
      ),
    );
  }
}
// #end
