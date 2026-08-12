# Media

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

## AstryxAvatar

`lib/src/components/media/avatar.dart` · upstream `Avatar / AvatarStatusDot`

A person or entity as an image, initials or icon, with an optional status dot.

```dart
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
```

**Rules**

- **Accessibility:** **`name` is required, and it is the accessible name.** An avatar is a picture of a person: without the name it is an unlabelled image, and a row of them is a row of unlabelled images. It is also where the initials come from, so there is nothing to keep in step — and a status is appended to it, so a reader hears "Ada Lovelace, Online".
- **Careful:** A `status` without a `statusLabel` **asserts**. A coloured dot on its own says nothing to a screen reader and nothing to anybody who cannot tell the hues apart, which is the rule the whole widget set is built to.

| Show | When |
| --- | --- |
| An image | There is one, and it loads. |
| Initials | The default. First letter of the first and last words — "Ada Lovelace" is AL. |
| An `icon` | For an entity a person’s initials would misrepresent: a service, a bot, a deleted account. |

### AstryxAvatar

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `name` **(required)** | `String` | — | Who or what this is. The accessible name, and the source of the initials. |
| `image` | `ImageProvider?` | — | The picture, if there is one. |
| `icon` | `AstryxIconName?` | — | A glyph instead of initials. |
| `size` | `AstryxAvatarSize` | `AstryxAvatarSize.md` | xs 20, sm 24, md 32, lg 40, xl 64. |
| `shape` | `AstryxAvatarShape` | `AstryxAvatarShape.circle` | Circle for a person, rounded for anything else. |
| `status` | `AstryxStatusDotVariant?` | — | A state, as a corner dot. |
| `statusLabel` | `String?` | — | What the dot means. Required whenever `status` is given. |
| `onPressed` | `VoidCallback?` | — | Makes the avatar a button. |
| `initials` | `String` | — | What `name` reduces to. Read-only. |

---

## AstryxAvatarGroup

`lib/src/components/media/avatar_group.dart` · upstream `AvatarGroup / AvatarGroupOverflow`

Overlapping avatars with a count for the ones that did not fit.

```dart
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
```

**Rules**

- **Accessibility:** **The group is announced as a group** — "Reviewers, Ada Lovelace, Grace Hopper, 2 more" — with the count as its value. Four overlapping pictures are four unlabelled images to anybody who cannot see them, and the stack that makes them read as a set conveys nothing at all otherwise.

### AstryxAvatarGroup

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `avatars` **(required)** | `List<AstryxAvatar>` | — | The avatars, in order. |
| `max` | `int` | `5` | How many to draw before the overflow chip. |
| `size` | `AstryxAvatarSize` | `AstryxAvatarSize.md` | The size every avatar in the row takes. |
| `onOverflowPressed` | `VoidCallback?` | — | Called when the count is pressed — usually to show the whole set. |
| `label` | `String?` | — | What the group is: "Reviewers", "On call". |

---

## AstryxThumbnail

`lib/src/components/media/thumbnail.dart` · upstream `Thumbnail`

A small fixed-ratio preview of an image or file.

```dart
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
```

**Rules**

- **Accessibility:** **`label` is required**, for the same reason an avatar’s `name` is: a wall of thumbnails with no names is a wall of unlabelled images, and a failed load is a grey square with nothing to say for itself. `selected` is announced as well as ringed — a ring alone is invisible to a screen reader and to anybody who cannot separate the hues.

### AstryxThumbnail

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | What this is a picture of. The accessible name, and the caption. |
| `image` | `ImageProvider?` | — | The picture, if there is one. |
| `icon` | `AstryxIconName?` | — | A glyph for a file that cannot be previewed. |
| `ratio` | `double` | `1` | Width over height. |
| `width` | `double` | `96` | How wide the tile is. |
| `showCaption` | `bool` | `false` | Whether to draw the label under the picture. |
| `selected` | `bool` | `false` | Whether this is the chosen one in a set. |
| `onPressed` | `VoidCallback?` | — | Usually opens a lightbox. |

---

## AstryxAspectRatio

`lib/src/components/media/aspect_ratio.dart` · upstream `AspectRatio`

A box that keeps its width-to-height ratio as it resizes.

```dart
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
```

**Rules**

- **Note:** Flutter already has `AspectRatio` and this does not replace it. What it adds is the **radius, the ground and the clip** from the token layer — the part every media surface in a design system has to agree about. Use Flutter’s directly when none of that applies.

### AstryxAspectRatio

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `ratio` **(required)** | `double` | — | Width divided by height. `16 / 9`, `1`, `4 / 3`. |
| `child` | `Widget?` | — | What fills the box. Null leaves the ground. |
| `radius` | `AstryxRadiusToken` | `AstryxRadiusToken.container` | The corner radius. |
| `background` | `AstryxColorToken` | `AstryxColorToken.backgroundMuted` | The ground behind the child. |
| `showBorder` | `bool` | `false` | Whether to draw a hairline border. |
| `semanticsLabel` | `String?` | — | What a screen reader announces. Null leaves whatever the child says — and an `Image` with no `semanticLabel` says nothing at all, which is right for decoration and wrong for a diagram. |

---

## AstryxCarousel

`lib/src/components/media/carousel.dart` · upstream `Carousel`

A horizontally paged strip of items, with the controls and keyboard traversal.

```dart
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
```

**Rules**

- **Careful:** **And there is no way to ask for one.** Content that moves on its own for more than five seconds has to be pausable (WCAG 2.2.1); it takes the thing a reader was looking at away mid-sentence; and the pause control is invariably the least obvious thing on the screen. If a set of items deserves attention on its own schedule, it deserves a page rather than a timer.
- **Accessibility:** The position is the container’s **value**, so a reader landing on the strip is told "Item 3 of 8" before anything else. The same string is drawn beside the controls, because a sighted keyboard user needs it too and a scrollbar does not say it.

| Key | Does |
| --- | --- |
| `Tab` | Moves onto the strip, and off it. **One stop.** |
| `←` / `→` | One item. Mirrored under RTL. |
| `Home` / `End` | The first and last item. |

### AstryxCarousel

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `items` **(required)** | `List<Widget>` | — | The items, in order. |
| `label` | `String?` | — | What the strip is. |
| `initialIndex` | `int` | `0` | Which item to open on. |
| `onIndexChanged` | `ValueChanged<int>?` | — | Called with the item now showing. |
| `showControls` | `bool` | `true` | Whether to draw the previous and next controls. |
| `showPosition` | `bool` | `true` | Whether to draw the "3 of 8" readout. |
| `height` | `double?` | — | A fixed height for the strip. |
| `viewportFraction` | `double` | `1` | How much of the viewport one item takes. |
| `focusNode` | `FocusNode?` | — | The strip’s focus node. |

---

## AstryxLightbox

`lib/src/components/media/lightbox.dart` · upstream `Lightbox`

A full-screen media viewer, navigable between items.

```dart
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
```

**Rules**

- **Accessibility:** The item’s label is the viewer’s accessible name and the position is its value, so a reader is told what they are looking at and where it sits. The top and bottom bars go through AstryxMediaTheme (references/media.md), which is what keeps a caption legible over a photograph of any colour.

| Key | Does |
| --- | --- |
| `←` / `→` | One item. Mirrored under RTL. |
| `Esc` | Closes, and returns focus to what opened it. |

### AstryxLightbox

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `controller` **(required)** | `AstryxOverlayController` | — | Opens and closes the viewer. |
| `items` **(required)** | `List<AstryxLightboxItem>` | — | The items, in order. |
| `initialIndex` | `int` | `0` | Which item to open on. |
| `onIndexChanged` | `ValueChanged<int>?` | — | Called with the item now showing. |
| `actions` | `List<Widget>` | `const <Widget>[]` | Controls in the top bar beside the close button. |

### AstryxLightboxItem

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `label` **(required)** | `String` | — | What it is. Never optional. |
| `child` **(required)** | `Widget` | — | The media itself. |
| `caption` | `String?` | — | A line under it. |

---

## AstryxMediaTheme

`lib/src/components/media/media_theme.dart` · upstream `MediaTheme`

The theme overrides that apply to media surfaces — captions and controls over an image.

```dart
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
```

**Rules**

- **Note:** `onDark`, not `textPrimary` inverted by hand. The token exists precisely so "legible on something dark" is one decision the theme owns rather than a guess each caller makes — and a theme that changes it changes this too.
- **Accessibility:** A scrim is what makes the contrast ratio survive a picture nobody has seen yet — and contrast is not optional over media any more than it is over a page. Text that must be read cannot rely on the image being dark in the corner it happens to sit in.

| `AstryxMediaScrim` | For |
| --- | --- |
| `bottom` | A caption or a control bar. The default. |
| `top` | A close button or a counter. |
| `full` | Content that covers the picture. |
| `none` | A surface already dark enough — a chart on an inverted ground. |

### AstryxMediaTheme

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `child` **(required)** | `Widget` | — | The content drawn over the media. |
| `scrim` | `AstryxMediaScrim` | `AstryxMediaScrim.bottom` | Which scrim to put behind it. |
| `padding` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | Inner padding around the child. |

---

