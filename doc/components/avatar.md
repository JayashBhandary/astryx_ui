---
title: AstryxAvatar
description: A person or entity as an image, initials or icon, with an optional status dot.
component: true
group: Media
source: lib/src/components/media/avatar.dart
upstream: Avatar / AvatarStatusDot
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
AstryxAvatar(
  name: 'Ada Lovelace',
  image: NetworkImage(user.avatarUrl),
  status: AstryxStatusDotVariant.success,
  statusLabel: 'Online',
)
```

Upstream ships `AvatarStatusDot` separately. It is folded in here because a dot *beside* an avatar is two things a reader has to associate, and the association is the whole point of it.

## The name is not optional

> **Accessibility**
>
> **`name` is required, and it is the accessible name.** An avatar is a picture of a person: without the name it is an unlabelled image, and a row of them is a row of unlabelled images. It is also where the initials come from, so there is nothing to keep in step — and a status is appended to it, so a reader hears "Ada Lovelace, Online".

The fallbacks run image → initials → icon. A **failed** image falls back to the initials rather than to a broken glyph: the name is known either way, so there is no reason to show less than it.

| Show | When |
| --- | --- |
| An image | There is one, and it loads. |
| Initials | The default. First letter of the first and last words — "Ada Lovelace" is AL. |
| An `icon` | For an entity a person’s initials would misrepresent: a service, a bot, a deleted account. |

## Round or square

`AstryxAvatarShape.circle` for a person and `rounded` for anything else — a team, a service, an organisation. That distinction is the only thing the shape is for, and using it the other way round makes both meanings useless.

> **Careful**
>
> A `status` without a `statusLabel` **asserts**. A coloured dot on its own says nothing to a screen reader and nothing to anybody who cannot tell the hues apart, which is the rule the whole widget set is built to.

### AstryxAvatar

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` *(required)* | `String` | — | Who or what this is. The accessible name, and the source of the initials. |
| `image` | `ImageProvider?` | — | The picture, if there is one. |
| `icon` | `AstryxIconName?` | — | A glyph instead of initials. |
| `size` | `AstryxAvatarSize` | `AstryxAvatarSize.md` | xs 20, sm 24, md 32, lg 40, xl 64. |
| `shape` | `AstryxAvatarShape` | `AstryxAvatarShape.circle` | Circle for a person, rounded for anything else. |
| `status` | `AstryxStatusDotVariant?` | — | A state, as a corner dot. |
| `statusLabel` | `String?` | — | What the dot means. Required whenever `status` is given. |
| `onPressed` | `VoidCallback?` | — | Makes the avatar a button. |
| `initials` | `String` | — | What `name` reduces to. Read-only. |


## Related

- [AstryxAvatarGroup](avatar_group.md) — several of these, overlapping.
- [AstryxStatusDot](status_dot.md) — the dot, and the pair-it-with-text rule.
- [AstryxThumbnail](thumbnail.md) — a picture of a *thing* rather than a person.

