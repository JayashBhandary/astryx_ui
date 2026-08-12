import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// The people a media example pretends to know about.
const List<({String name, AstryxStatusDotVariant? status, String? state})>
_people = <({String name, AstryxStatusDotVariant? status, String? state})>[
  (
    name: 'Ada Lovelace',
    status: AstryxStatusDotVariant.success,
    state: 'Online',
  ),
  (name: 'Grace Hopper', status: AstryxStatusDotVariant.warning, state: 'Away'),
  (name: 'Linus Pauling', status: null, state: null),
  (name: 'Katherine Johnson', status: null, state: null),
  (name: 'Alan Turing', status: null, state: null),
  (name: 'Barbara Liskov', status: null, state: null),
];

// #example avatar_demo -> AvatarDemoExample
class AvatarDemoExample extends StatelessWidget {
  const AvatarDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Initials from the name, a glyph where initials would misrepresent, and a
    // status dot that is always paired with a word.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (final size in AstryxAvatarSize.values)
              AstryxAvatar(name: 'Ada Lovelace', size: size),
          ],
        ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            const AstryxAvatar(
              name: 'Ada Lovelace',
              size: AstryxAvatarSize.lg,
              status: AstryxStatusDotVariant.success,
              statusLabel: 'Online',
            ),
            const AstryxAvatar(
              name: 'Atlas scheduler',
              size: AstryxAvatarSize.lg,
              shape: AstryxAvatarShape.rounded,
              icon: AstryxIconName.wrench,
            ),
            AstryxAvatar(
              name: 'Deploy bot',
              size: AstryxAvatarSize.lg,
              shape: AstryxAvatarShape.rounded,
              icon: AstryxIconName.arrowUp,
              onPressed: () {},
            ),
          ],
        ),
        const AstryxText(
          'Rounded for anything that is not a person — that distinction is '
          'what the shape carries.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example avatar_group_demo -> AvatarGroupDemoExample
class AvatarGroupDemoExample extends StatefulWidget {
  const AvatarGroupDemoExample({super.key});

  @override
  State<AvatarGroupDemoExample> createState() => _AvatarGroupDemoExampleState();
}

class _AvatarGroupDemoExampleState extends State<AvatarGroupDemoExample> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    // "+3" is the only thing saying the row is a sample rather than the whole
    // set, so it is pressable and the names behind it are reachable.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxAvatarGroup(
          label: 'Reviewers',
          max: _all ? _people.length : 3,
          onOverflowPressed: () => setState(() => _all = true),
          avatars: <AstryxAvatar>[
            for (final person in _people)
              AstryxAvatar(
                name: person.name,
                status: person.status,
                statusLabel: person.state,
              ),
          ],
        ),
        if (_all)
          AstryxButton(
            label: 'Collapse',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () => setState(() => _all = false),
          ),
      ],
    );
  }
}
// #end

// #example aspect_ratio_demo -> AspectRatioDemoExample
class AspectRatioDemoExample extends StatelessWidget {
  const AspectRatioDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // With nothing in it the box is a placeholder: the right shape in the
    // right colour reads as the picture arriving, where a hole reads as a bug.
    return AstryxGrid(
      minWidth: 160,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final entry in <({String label, double ratio})>[
          (label: '16 / 9', ratio: 16 / 9),
          (label: '1', ratio: 1),
          (label: '4 / 3', ratio: 4 / 3),
        ])
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxAspectRatio(ratio: entry.ratio, showBorder: true),
              AstryxText(
                entry.label,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
      ],
    );
  }
}
// #end

// #example thumbnail_demo -> ThumbnailDemoExample
class ThumbnailDemoExample extends StatefulWidget {
  const ThumbnailDemoExample({super.key});

  @override
  State<ThumbnailDemoExample> createState() => _ThumbnailDemoExampleState();
}

class _ThumbnailDemoExampleState extends State<ThumbnailDemoExample> {
  static const List<({String label, AstryxIconName icon})> _files =
      <({String label, AstryxIconName icon})>[
        (label: 'atlas-scheduler.png', icon: AstryxIconName.copy),
        (label: 'deploy-log.txt', icon: AstryxIconName.copy),
        (label: 'metrics.csv', icon: AstryxIconName.viewColumns),
        (label: 'runbook.md', icon: AstryxIconName.copy),
      ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    // Nothing here can be previewed, so every tile falls back to a glyph and
    // leans on its name — which is why the name is required.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      wrap: true,
      runGap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.start,
      children: <Widget>[
        for (var i = 0; i < _files.length; i++)
          AstryxThumbnail(
            label: _files[i].label,
            icon: _files[i].icon,
            showCaption: true,
            selected: i == _selected,
            onPressed: () => setState(() => _selected = i),
          ),
      ],
    );
  }
}
// #end

// #example carousel_demo -> CarouselDemoExample
class CarouselDemoExample extends StatelessWidget {
  const CarouselDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tab onto the strip and use the arrows — one tab stop for the whole set.
    // There is no autoplay, and there is no way to ask for one.
    return AstryxCarousel(
      label: 'Screenshots',
      height: 180,
      items: <Widget>[
        for (var i = 1; i <= 5; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AstryxAspectRatio(
              ratio: 16 / 9,
              showBorder: true,
              child: Center(
                child: AstryxText(
                  'Screenshot $i',
                  color: AstryxTextColor.secondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
// #end

// #example lightbox_demo -> LightboxDemoExample
class LightboxDemoExample extends StatefulWidget {
  const LightboxDemoExample({super.key});

  @override
  State<LightboxDemoExample> createState() => _LightboxDemoExampleState();
}

class _LightboxDemoExampleState extends State<LightboxDemoExample> {
  final AstryxOverlayController _viewer = AstryxOverlayController();
  int _opened = 0;

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  void _open(int index) {
    setState(() => _opened = index);
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Press a thumbnail. The viewer opens on *that* one, pages with the arrow
    // keys, and closes on Escape.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (var i = 0; i < 3; i++)
              AstryxThumbnail(
                label: 'Screenshot ${i + 1}',
                width: 80,
                onPressed: () => _open(i),
              ),
          ],
        ),
        AstryxLightbox(
          controller: _viewer,
          initialIndex: _opened,
          items: <AstryxLightboxItem>[
            for (var i = 1; i <= 3; i++)
              AstryxLightboxItem(
                label: 'Screenshot $i',
                caption: 'Screenshot $i — the deploy at 14:0$i',
                child: SizedBox(
                  width: 420,
                  child: AstryxAspectRatio(
                    ratio: 16 / 9,
                    background: AstryxColorToken.backgroundCard,
                    child: Center(
                      child: AstryxText(
                        'Screenshot $i',
                        color: AstryxTextColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        AstryxText(
          'Opens on the thumbnail that was pressed — currently '
          '${_opened + 1}. Radius token: '
          '${theme.radius(AstryxRadiusToken.container)}px.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example media_theme_demo -> MediaThemeDemoExample
class MediaThemeDemoExample extends StatelessWidget {
  const MediaThemeDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // A caption over a picture cannot use the page's text colour: the picture
    // is whatever colour it is. `AstryxMediaTheme` forces the on-dark tokens
    // and puts a scrim behind them.
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Stands in for a photograph.
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.backgroundInverted),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AstryxMediaTheme(
                scrim: AstryxMediaScrim.top,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  mainAxisSize: MainAxisSize.max,
                  justify: AstryxStackJustify.between,
                  children: <Widget>[
                    const AstryxText(
                      '2 of 8',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.inherit,
                    ),
                    AstryxIconButton(
                      icon: AstryxIconName.close,
                      label: 'Close',
                      variant: AstryxButtonVariant.ghost,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: AstryxMediaTheme(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  children: <Widget>[
                    AstryxText(
                      'atlas-scheduler.png',
                      color: AstryxTextColor.inherit,
                    ),
                    AstryxText(
                      'Captured at 14:02, three seconds before the timeout',
                      type: AstryxTextType.supporting,
                      color: AstryxTextColor.inherit,
                    ),
                  ],
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
