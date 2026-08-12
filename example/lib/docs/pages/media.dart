import 'package:example/docs/groups.dart';
import 'package:example/docs/model.dart';

/// Media — avatars, thumbnails, the ratio box, the carousel and the viewer.
///
/// Two rules run through the whole group. A picture of a thing **is not the
/// thing's name**, so every widget here takes one and announces it. And a
/// picture is whatever colour it happens to be, so anything drawn over one goes
/// through `AstryxMediaTheme` rather than guessing.
final List<DocPage> mediaPages = <DocPage>[
  _avatar,
  _avatarGroup,
  _thumbnail,
  _aspectRatio,
  _carousel,
  _lightbox,
  _mediaTheme,
];

const String _group = DocGroup.media;

const DocPage _avatar = DocPage(
  id: 'avatar',
  title: 'AstryxAvatar',
  group: _group,
  description:
      'A person or entity as an image, initials or icon, with an optional '
      'status dot.',
  source: 'lib/src/components/media/avatar.dart',
  upstream: 'Avatar / AvatarStatusDot',
  upstreamPath: '/components/Avatar',
  blocks: <DocBlock>[
    DocExample('avatar_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxAvatar(
  name: 'Ada Lovelace',
  image: NetworkImage(user.avatarUrl),
  status: AstryxStatusDotVariant.success,
  statusLabel: 'Online',
)'''),
    DocProse(
      'Upstream ships `AvatarStatusDot` separately. It is folded in here '
      'because a dot *beside* an avatar is two things a reader has to '
      'associate, and the association is the whole point of it.',
    ),
    DocHeading('The name is not optional'),
    DocCallout.accessibility(
      '**`name` is required, and it is the accessible name.** An avatar is a '
      'picture of a person: without the name it is an unlabelled image, and a '
      'row of them is a row of unlabelled images. It is also where the '
      'initials come from, so there is nothing to keep in step — and a status '
      'is appended to it, so a reader hears "Ada Lovelace, Online".',
    ),
    DocProse(
      'The fallbacks run image → initials → icon. A **failed** image falls '
      'back to the initials rather than to a broken glyph: the name is known '
      'either way, so there is no reason to show less than it.',
    ),
    DocTable(
      headers: <String>['Show', 'When'],
      rows: <List<String>>[
        <String>['An image', 'There is one, and it loads.'],
        <String>[
          'Initials',
          'The default. First letter of the first and last words — "Ada '
              'Lovelace" is AL.',
        ],
        <String>[
          'An `icon`',
          'For an entity a person’s initials would misrepresent: a service, a '
              'bot, a deleted account.',
        ],
      ],
    ),
    DocHeading('Round or square'),
    DocProse(
      '`AstryxAvatarShape.circle` for a person and `rounded` for anything else '
      '— a team, a service, an organisation. That distinction is the only '
      'thing the shape is for, and using it the other way round makes both '
      'meanings useless.',
    ),
    DocCallout.warning(
      'A `status` without a `statusLabel` **asserts**. A coloured dot on its '
      'own says nothing to a screen reader and nothing to anybody who cannot '
      'tell the hues apart, which is the rule the whole widget set is built '
      'to.',
    ),
    DocApi('AstryxAvatar', <DocProp>[
      DocProp(
        'name',
        'String',
        'Who or what this is. The accessible name, and the source of the '
            'initials.',
        required: true,
      ),
      DocProp('image', 'ImageProvider?', 'The picture, if there is one.'),
      DocProp(
        'icon',
        'AstryxIconName?',
        'A glyph instead of initials.',
      ),
      DocProp(
        'size',
        'AstryxAvatarSize',
        'xs 20, sm 24, md 32, lg 40, xl 64.',
        defaultValue: 'AstryxAvatarSize.md',
      ),
      DocProp(
        'shape',
        'AstryxAvatarShape',
        'Circle for a person, rounded for anything else.',
        defaultValue: 'AstryxAvatarShape.circle',
      ),
      DocProp('status', 'AstryxStatusDotVariant?', 'A state, as a corner dot.'),
      DocProp(
        'statusLabel',
        'String?',
        'What the dot means. Required whenever `status` is given.',
      ),
      DocProp('onPressed', 'VoidCallback?', 'Makes the avatar a button.'),
      DocProp('initials', 'String', 'What `name` reduces to. Read-only.'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxAvatarGroup](avatar_group) — several of these, overlapping.',
      '[AstryxStatusDot](status_dot) — the dot, and the pair-it-with-text '
          'rule.',
      '[AstryxThumbnail](thumbnail) — a picture of a *thing* rather than a '
          'person.',
    ]),
  ],
);

const DocPage _avatarGroup = DocPage(
  id: 'avatar_group',
  title: 'AstryxAvatarGroup',
  group: _group,
  description:
      'Overlapping avatars with a count for the ones that did not fit.',
  source: 'lib/src/components/media/avatar_group.dart',
  upstream: 'AvatarGroup / AvatarGroupOverflow',
  upstreamPath: '/components/AvatarGroup',
  blocks: <DocBlock>[
    DocExample('avatar_group_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxAvatarGroup(
  label: 'Reviewers',
  max: 4,
  avatars: <AstryxAvatar>[
    for (final person in reviewers) AstryxAvatar(name: person.name),
  ],
)'''),
    DocProse(
      'The overflow chip is part of the same widget rather than upstream’s '
      'separate `AvatarGroupOverflow`, because the count is not decoration: '
      '"+4" is the only thing telling a reader the row is a **sample** rather '
      'than the whole set.',
    ),
    DocProse(
      'Wire `onOverflowPressed`. The names behind a "+4" are otherwise '
      'unreachable, and a count nobody can expand is a count nobody can act '
      'on.',
    ),
    DocProse(
      'Every avatar takes the group’s `size`, whatever its own says: avatars '
      'of different sizes overlapping read as a mistake rather than as a '
      'hierarchy.',
    ),
    DocCallout.accessibility(
      '**The group is announced as a group** — "Reviewers, Ada Lovelace, Grace '
      'Hopper, 2 more" — with the count as its value. Four overlapping '
      'pictures are four unlabelled images to anybody who cannot see them, and '
      'the stack that makes them read as a set conveys nothing at all '
      'otherwise.',
    ),
    DocApi('AstryxAvatarGroup', <DocProp>[
      DocProp(
        'avatars',
        'List<AstryxAvatar>',
        'The avatars, in order.',
        required: true,
      ),
      DocProp(
        'max',
        'int',
        'How many to draw before the overflow chip.',
        defaultValue: '5',
      ),
      DocProp(
        'size',
        'AstryxAvatarSize',
        'The size every avatar in the row takes.',
        defaultValue: 'AstryxAvatarSize.md',
      ),
      DocProp(
        'onOverflowPressed',
        'VoidCallback?',
        'Called when the count is pressed — usually to show the whole set.',
      ),
      DocProp('label', 'String?', 'What the group is: "Reviewers", "On call".'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxAvatar](avatar) — one, and where the name rule is documented.',
      '[AstryxOverflowList](overflow_list) — when the row is items rather than '
          'people, and the tail should stay reachable.',
    ]),
  ],
);

const DocPage _thumbnail = DocPage(
  id: 'thumbnail',
  title: 'AstryxThumbnail',
  group: _group,
  description: 'A small fixed-ratio preview of an image or file.',
  source: 'lib/src/components/media/thumbnail.dart',
  upstream: 'Thumbnail',
  upstreamPath: '/components/Thumbnail',
  blocks: <DocBlock>[
    DocExample('thumbnail_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxThumbnail(
  label: 'atlas-scheduler.png',
  image: NetworkImage(file.url),
  onPressed: () => _lightbox.show(),
)'''),
    DocProse(
      'An [AstryxAspectRatio](aspect_ratio) with a picture in it, a glyph when '
      'there is no picture, and an optional caption — which covers the two '
      'cases a thumbnail actually has: something that can be shown, and '
      'something that can only be named.',
    ),
    DocCallout.accessibility(
      '**`label` is required**, for the same reason an avatar’s `name` is: a '
      'wall of thumbnails with no names is a wall of unlabelled images, and a '
      'failed load is a grey square with nothing to say for itself. `selected` '
      'is announced as well as ringed — a ring alone is invisible to a screen '
      'reader and to anybody who cannot separate the hues.',
    ),
    DocProse(
      'A file that cannot be previewed gets a glyph rather than a rendering of '
      'its first page: a PDF, a spreadsheet and a log are all "a file with a '
      'name" at 96 pixels, and a picture nobody can read at that size is worse '
      'than an honest icon.',
    ),
    DocProse(
      '`showCaption` is off by default. In a grid the names are usually beside '
      'the grid, and a caption under every tile doubles the wall’s height; '
      'turn it on for a thumbnail standing on its own.',
    ),
    DocApi('AstryxThumbnail', <DocProp>[
      DocProp(
        'label',
        'String',
        'What this is a picture of. The accessible name, and the caption.',
        required: true,
      ),
      DocProp('image', 'ImageProvider?', 'The picture, if there is one.'),
      DocProp(
        'icon',
        'AstryxIconName?',
        'A glyph for a file that cannot be previewed.',
      ),
      DocProp('ratio', 'double', 'Width over height.', defaultValue: '1'),
      DocProp('width', 'double', 'How wide the tile is.', defaultValue: '96'),
      DocProp(
        'showCaption',
        'bool',
        'Whether to draw the label under the picture.',
        defaultValue: 'false',
      ),
      DocProp(
        'selected',
        'bool',
        'Whether this is the chosen one in a set.',
        defaultValue: 'false',
      ),
      DocProp('onPressed', 'VoidCallback?', 'Usually opens a lightbox.'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLightbox](lightbox) — what a thumbnail usually opens.',
      '[AstryxAspectRatio](aspect_ratio) — the box underneath it.',
      '[AstryxFileInput](file_input) — choosing the files these preview.',
    ]),
  ],
);

const DocPage _aspectRatio = DocPage(
  id: 'aspect_ratio',
  title: 'AstryxAspectRatio',
  group: _group,
  description: 'A box that keeps its width-to-height ratio as it resizes.',
  source: 'lib/src/components/media/aspect_ratio.dart',
  upstream: 'AspectRatio',
  upstreamPath: '/components/AspectRatio',
  blocks: <DocBlock>[
    DocExample('aspect_ratio_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxAspectRatio(
  ratio: 16 / 9,
  child: Image.network(url, fit: BoxFit.cover),
)'''),
    DocCallout.note(
      'Flutter already has `AspectRatio` and this does not replace it. What it '
      'adds is the **radius, the ground and the clip** from the token layer — '
      'the part every media surface in a design system has to agree about. Use '
      'Flutter’s directly when none of that applies.',
    ),
    DocHeading('The ground is a placeholder'),
    DocProse(
      'It matters more than it looks. An image that has not loaded yet leaves '
      'a hole, and a hole in the middle of a page reads as a **bug** rather '
      'than as a wait; a tinted box of the right shape reads as the picture '
      'arriving. That is why the ground has a token and not a null.',
    ),
    DocProse(
      '`showBorder` is worth turning on over a photograph that might be nearly '
      'the page’s own colour at its edges — without it the frame ends nowhere '
      'in particular.',
    ),
    DocApi('AstryxAspectRatio', <DocProp>[
      DocProp(
        'ratio',
        'double',
        'Width divided by height. `16 / 9`, `1`, `4 / 3`.',
        required: true,
      ),
      DocProp(
        'child',
        'Widget?',
        'What fills the box. Null leaves the ground.',
      ),
      DocProp(
        'radius',
        'AstryxRadiusToken',
        'The corner radius.',
        defaultValue: 'AstryxRadiusToken.container',
      ),
      DocProp(
        'background',
        'AstryxColorToken',
        'The ground behind the child.',
        defaultValue: 'AstryxColorToken.backgroundMuted',
      ),
      DocProp(
        'showBorder',
        'bool',
        'Whether to draw a hairline border.',
        defaultValue: 'false',
      ),
      DocProp(
        'semanticsLabel',
        'String?',
        'What a screen reader announces. Null leaves whatever the child says — '
            'and an `Image` with no `semanticLabel` says nothing at all, which '
            'is right for decoration and wrong for a diagram.',
      ),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxThumbnail](thumbnail) — this with a picture and a name.',
      '[AstryxSkeleton](skeleton) — a placeholder for a wait whose shape is '
          'known but whose ratio is not.',
    ]),
  ],
);

const DocPage _carousel = DocPage(
  id: 'carousel',
  title: 'AstryxCarousel',
  group: _group,
  description:
      'A horizontally paged strip of items, with the controls and keyboard '
      'traversal.',
  source: 'lib/src/components/media/carousel.dart',
  upstream: 'Carousel',
  upstreamPath: '/components/Carousel',
  blocks: <DocBlock>[
    DocExample('carousel_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxCarousel(
  label: 'Screenshots',
  items: <Widget>[
    for (final shot in shots) AstryxAspectRatio(ratio: 16 / 9, child: shot),
  ],
)'''),
    DocHeading('There is no autoplay'),
    DocCallout.warning(
      '**And there is no way to ask for one.** Content that moves on its own '
      'for more than five seconds has to be pausable (WCAG 2.2.1); it takes '
      'the thing a reader was looking at away mid-sentence; and the pause '
      'control is invariably the least obvious thing on the screen. If a set '
      'of items deserves attention on its own schedule, it deserves a page '
      'rather than a timer.',
    ),
    DocHeading('Keyboard'),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`Tab`', 'Moves onto the strip, and off it. **One stop.**'],
        <String>['`←` / `→`', 'One item. Mirrored under RTL.'],
        <String>['`Home` / `End`', 'The first and last item.'],
      ],
    ),
    DocProse(
      'One tab stop for the whole strip: a carousel of forty screenshots is '
      'otherwise forty presses to walk past. The controls stay drawn and '
      '**disable at the ends** rather than disappearing, because a control '
      'that vanishes moves the one beside it.',
    ),
    DocProse(
      '`viewportFraction` below one leaves the next item peeking in — the only '
      'reliable way to say "there is more this way" on a touch device with no '
      'hover and no visible controls.',
    ),
    DocCallout.accessibility(
      'The position is the container’s **value**, so a reader landing on the '
      'strip is told "Item 3 of 8" before anything else. The same string is '
      'drawn beside the controls, because a sighted keyboard user needs it too '
      'and a scrollbar does not say it.',
    ),
    DocApi('AstryxCarousel', <DocProp>[
      DocProp('items', 'List<Widget>', 'The items, in order.', required: true),
      DocProp('label', 'String?', 'What the strip is.'),
      DocProp(
        'initialIndex',
        'int',
        'Which item to open on.',
        defaultValue: '0',
      ),
      DocProp(
        'onIndexChanged',
        'ValueChanged<int>?',
        'Called with the item now showing.',
      ),
      DocProp(
        'showControls',
        'bool',
        'Whether to draw the previous and next controls.',
        defaultValue: 'true',
      ),
      DocProp(
        'showPosition',
        'bool',
        'Whether to draw the "3 of 8" readout.',
        defaultValue: 'true',
      ),
      DocProp('height', 'double?', 'A fixed height for the strip.'),
      DocProp(
        'viewportFraction',
        'double',
        'How much of the viewport one item takes.',
        defaultValue: '1',
      ),
      DocProp('focusNode', 'FocusNode?', 'The strip’s focus node.'),
    ]),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLightbox](lightbox) — for looking at one item properly.',
      '[AstryxTabList](tab_list) — when the items are alternatives rather than '
          'a sequence.',
      '[AstryxScrollOverflow](use_scroll_overflow) — for a strip that scrolls '
          'freely rather than paging.',
    ]),
  ],
);

const DocPage _lightbox = DocPage(
  id: 'lightbox',
  title: 'AstryxLightbox',
  group: _group,
  description: 'A full-screen media viewer, navigable between items.',
  source: 'lib/src/components/media/lightbox.dart',
  upstream: 'Lightbox',
  upstreamPath: '/components/Lightbox',
  blocks: <DocBlock>[
    DocExample('lightbox_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
AstryxLightbox(
  controller: _lightbox,
  initialIndex: _tapped,
  items: <AstryxLightboxItem>[
    for (final shot in shots)
      AstryxLightboxItem(label: shot.name, child: Image.network(shot.url)),
  ],
)'''),
    DocProse(
      '[AstryxOverlay](overlay) for the modal half — the scrim, the focus '
      'trap, Escape, the entry animation — with the paging, the counter and '
      'the caption on top. A widget in the tree, like every overlay here: it '
      'renders nothing until the controller opens it.',
    ),
    DocProse(
      'It opens on `initialIndex` **every time**, not on whatever was showing '
      'when it last closed. A thumbnail grid opens the thumbnail that was '
      'pressed, and remembering the previous one would make the second press '
      'of the same tile open something else.',
    ),
    DocProse(
      'A single item drops the paging controls and the counter: "1 of 1" with '
      'two dead arrows beside it is three pieces of furniture saying nothing.',
    ),
    DocTable(
      headers: <String>['Key', 'Does'],
      rows: <List<String>>[
        <String>['`←` / `→`', 'One item. Mirrored under RTL.'],
        <String>['`Esc`', 'Closes, and returns focus to what opened it.'],
      ],
    ),
    DocCallout.accessibility(
      'The item’s label is the viewer’s accessible name and the position is '
      'its value, so a reader is told what they are looking at and where it '
      'sits. The top and bottom bars go through '
      '[AstryxMediaTheme](media_theme), which is what keeps a caption legible '
      'over a photograph of any colour.',
    ),
    DocApi('AstryxLightbox', <DocProp>[
      DocProp(
        'controller',
        'AstryxOverlayController',
        'Opens and closes the viewer.',
        required: true,
      ),
      DocProp(
        'items',
        'List<AstryxLightboxItem>',
        'The items, in order.',
        required: true,
      ),
      DocProp(
        'initialIndex',
        'int',
        'Which item to open on.',
        defaultValue: '0',
      ),
      DocProp(
        'onIndexChanged',
        'ValueChanged<int>?',
        'Called with the item now showing.',
      ),
      DocProp(
        'actions',
        'List<Widget>',
        'Controls in the top bar beside the close button.',
        defaultValue: 'const <Widget>[]',
      ),
    ]),
    DocApi(
      'AstryxLightboxItem',
      <DocProp>[
        DocProp(
          'label',
          'String',
          'What it is. Never optional.',
          required: true,
        ),
        DocProp('child', 'Widget', 'The media itself.', required: true),
        DocProp('caption', 'String?', 'A line under it.'),
      ],
      description: 'One item in the viewer.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxThumbnail](thumbnail) — what usually opens it.',
      '[AstryxOverlay](overlay) — the layer underneath, and its contract.',
      '[AstryxMediaTheme](media_theme) — how its bars stay readable.',
    ]),
  ],
);

const DocPage _mediaTheme = DocPage(
  id: 'media_theme',
  title: 'AstryxMediaTheme',
  group: _group,
  description:
      'The theme overrides that apply to media surfaces — captions and '
      'controls over an image.',
  source: 'lib/src/components/media/media_theme.dart',
  upstream: 'MediaTheme',
  upstreamPath: '/components/MediaTheme',
  blocks: <DocBlock>[
    DocExample('media_theme_demo', align: DocExampleAlign.stretch),
    DocHeading('Usage'),
    DocCode('''
Stack(
  children: <Widget>[
    Image.network(url, fit: BoxFit.cover),
    Positioned(
      left: 0, right: 0, bottom: 0,
      child: AstryxMediaTheme(child: AstryxText('Atlas, 14:02')),
    ),
  ],
)'''),
    DocProse(
      'A caption over a photograph cannot use `--color-text-primary`: the '
      'photograph is whatever colour it is, and a near-black caption over a '
      'near-black corner is a caption nobody reads. This forces the '
      '**on-dark** tokens for its subtree and puts a scrim behind them.',
    ),
    DocCallout.note(
      '`onDark`, not `textPrimary` inverted by hand. The token exists '
      'precisely so "legible on something dark" is one decision the theme owns '
      'rather than a guess each caller makes — and a theme that changes it '
      'changes this too.',
    ),
    DocHeading('It does not change the theme'),
    DocProse(
      'Spacing, radius, type and motion stay exactly as they are. **Only the '
      'foreground colours and the ground behind them move**, because those are '
      'the only two things a picture underneath can break. A caller’s own '
      'tokens keep working, and nothing inside has to be re-specified.',
    ),
    DocProse(
      'Inside it, use `AstryxTextColor.inherit` and `AstryxIconColor.inherit`: '
      'both take the colour set here, which is how a caption and the glyph '
      'beside it stay the same shade without either naming it.',
    ),
    DocHeading('Scrims'),
    DocTable(
      headers: <String>['`AstryxMediaScrim`', 'For'],
      rows: <List<String>>[
        <String>['`bottom`', 'A caption or a control bar. The default.'],
        <String>['`top`', 'A close button or a counter.'],
        <String>['`full`', 'Content that covers the picture.'],
        <String>[
          '`none`',
          'A surface already dark enough — a chart on an inverted ground.',
        ],
      ],
    ),
    DocProse(
      'A scrim rather than a shadow on the text: a drop shadow under white '
      'type is a trick that works on some photographs and fails on the rest, '
      'and there is no way to tell which from here.',
    ),
    DocApi('AstryxMediaTheme', <DocProp>[
      DocProp(
        'child',
        'Widget',
        'The content drawn over the media.',
        required: true,
      ),
      DocProp(
        'scrim',
        'AstryxMediaScrim',
        'Which scrim to put behind it.',
        defaultValue: 'AstryxMediaScrim.bottom',
      ),
      DocProp(
        'padding',
        'AstryxSpacingToken',
        'Inner padding around the child.',
        defaultValue: 'AstryxSpacingToken.spacing3',
      ),
    ]),
    DocCallout.accessibility(
      'A scrim is what makes the contrast ratio survive a picture nobody has '
      'seen yet — and contrast is not optional over media any more than it is '
      'over a page. Text that must be read cannot rely on the image being dark '
      'in the corner it happens to sit in.',
    ),
    DocHeading('Related'),
    DocList(<String>[
      '[AstryxLightbox](lightbox) — the viewer whose bars use it.',
      '[Colour](color) — where `onDark` sits among the roles.',
      '[Accessibility](accessibility) — the contrast rules this exists to '
          'keep.',
    ]),
  ],
);
