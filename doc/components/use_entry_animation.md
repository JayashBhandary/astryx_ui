---
title: AstryxEntryAnimation
description: Animating an element as it enters, respecting reduced-motion.
component: true
group: Hooks & controllers
source: lib/src/foundation/entry_animation.dart
upstream: useEntryAnimation
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class HookEntryAnimationExample extends StatefulWidget {
  const HookEntryAnimationExample({super.key});

  @override
  State<HookEntryAnimationExample> createState() =>
      _HookEntryAnimationExampleState();
}

class _HookEntryAnimationExampleState extends State<HookEntryAnimationExample> {
  int _generation = 0;
  AstryxEntryTransition _transition = AstryxEntryTransition.fadeUp;

  @override
  Widget build(BuildContext context) {
    // It runs once per element. Replaying it is a *key* change, not a flag: a
    // new key tells Flutter this is new content rather than the old content
    // updated, which is the same thing the animation is trying to say.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxSegmentedControl<AstryxEntryTransition>(
              label: 'Transition',
              value: _transition,
              segments: const <AstryxSegment<AstryxEntryTransition>>[
                AstryxSegment(
                  value: AstryxEntryTransition.fade,
                  label: 'Fade',
                ),
                AstryxSegment(
                  value: AstryxEntryTransition.fadeUp,
                  label: 'Up',
                ),
                AstryxSegment(
                  value: AstryxEntryTransition.fadeScale,
                  label: 'Scale',
                ),
              ],
              onChanged: (value) => setState(() {
                _transition = value;
                _generation++;
              }),
            ),
            AstryxButton(
              label: 'Replay',
              onPressed: () => setState(() => _generation++),
            ),
          ],
        ),
        AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 0; i < 3; i++)
              AstryxEntryAnimation(
                key: ValueKey<String>('$_generation.$i'),
                transition: _transition,
                // A stagger, kept short: one a user has to wait out has become
                // a loading state.
                delay: Duration(milliseconds: 60 * i),
                child: AstryxCard(
                  child: AstryxText('Row ${i + 1}'),
                ),
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
AstryxEntryAnimation(
  transition: AstryxEntryTransition.fadeUp,
  child: AstryxCard(child: summary),
)
```

Two things a hand-rolled `AnimationController` in a `StatefulWidget` routinely gets wrong, and this does not: the duration and easing come from **tokens**, and reduced motion means *not animating* rather than animating quickly.

| `AstryxEntryTransition` | For |
| --- | --- |
| `fade` | The safe default. Nothing moves, so nothing can be read as a layout shift. |
| `fadeUp` | Says "this is new" rather than "this was always here", which a fade alone cannot. |
| `fadeScale` | Something that appeared *at* a point — a card just created, a panel with a source. |

## Once per element

The animation runs when the element is first built and never again. To replay it — a list that re-animates when its filter changes — give it a `key` that changes with the content. That is not a workaround: a new key tells Flutter this is new content rather than the old content updated, which is the same thing the animation is trying to say.

Once it has finished, the transition widgets are dropped from the tree rather than left behind — an opacity layer on every card that ever entered is a repaint cost for the rest of the session.

> **Careful**
>
> A `delay` is for staggering a list, and the total matters more than the step: keep it under about a quarter of a second. A stagger a user has to wait out has stopped being an animation and become a loading state.

> **Accessibility**
>
> Under `prefers-reduced-motion` the child is simply *there* — no frame of it is animated. A shorter animation is still an animation, and the setting exists for people whom motion makes unwell. Nothing about the content, the layout or the semantics differs between the two paths.

### AstryxEntryAnimation

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `child` *(required)* | `Widget` | — | The content that enters. |
| `transition` | `AstryxEntryTransition` | `AstryxEntryTransition.fade` | How it enters. |
| `duration` | `AstryxDurationToken` | `AstryxDurationToken.mediumMin` | How long the entry takes. |
| `ease` | `AstryxEaseToken` | `AstryxEaseToken.standard` | The easing curve. |
| `delay` | `Duration` | `Duration.zero` | How long to wait before starting. |
| `offset` | `double` | `8` | How far `fadeUp` rises, in logical pixels. |
| `enabled` | `bool` | `true` | Whether to animate at all. |


## Related

- [useContainerReveal](use_container_reveal.md) — the same entry, triggered by a scroll.
- [Motion](../guides/motion.md) — the tokens, and what must not move.

---

Something wrong with `AstryxEntryAnimation`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxEntryAnimation&component=AstryxEntryAnimation) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxEntryAnimation&area=AstryxEntryAnimation) — both templates arrive with the component filled in.
