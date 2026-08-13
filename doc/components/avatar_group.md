---
title: AstryxAvatarGroup
description: Overlapping avatars with a count for the ones that did not fit.
component: true
group: Media
source: lib/src/components/media/avatar_group.dart
upstream: AvatarGroup / AvatarGroupOverflow
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

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


## Usage

```dart
AstryxAvatarGroup(
  label: 'Reviewers',
  max: 4,
  avatars: <AstryxAvatar>[
    for (final person in reviewers) AstryxAvatar(name: person.name),
  ],
)
```

The overflow chip is part of the same widget rather than upstream’s separate `AvatarGroupOverflow`, because the count is not decoration: "+4" is the only thing telling a reader the row is a **sample** rather than the whole set.

Wire `onOverflowPressed`. The names behind a "+4" are otherwise unreachable, and a count nobody can expand is a count nobody can act on.

Every avatar takes the group’s `size`, whatever its own says: avatars of different sizes overlapping read as a mistake rather than as a hierarchy.

> **Accessibility**
>
> **The group is announced as a group** — "Reviewers, Ada Lovelace, Grace Hopper, 2 more" — with the count as its value. Four overlapping pictures are four unlabelled images to anybody who cannot see them, and the stack that makes them read as a set conveys nothing at all otherwise.

### AstryxAvatarGroup

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `avatars` *(required)* | `List<AstryxAvatar>` | — | The avatars, in order. |
| `max` | `int` | `5` | How many to draw before the overflow chip. |
| `size` | `AstryxAvatarSize` | `AstryxAvatarSize.md` | The size every avatar in the row takes. |
| `onOverflowPressed` | `VoidCallback?` | — | Called when the count is pressed — usually to show the whole set. |
| `label` | `String?` | — | What the group is: "Reviewers", "On call". |


## Related

- [AstryxAvatar](avatar.md) — one, and where the name rule is documented.
- [AstryxOverflowList](overflow_list.md) — when the row is items rather than people, and the tail should stay reachable.

---

Something wrong with `AstryxAvatarGroup`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxAvatarGroup&component=AstryxAvatarGroup) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxAvatarGroup&area=AstryxAvatarGroup) — both templates arrive with the component filled in.
