---
title: Motion
description: Durations, easings, and what must not move when motion is reduced.
group: Getting started
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Nine durations — three bands of min, base and max — and one easing curve. A band is chosen by what is moving: a control gives feedback `fast`, a panel arrives `medium`, and `slow` is for something crossing the whole screen.

```dart
class MotionDurationsExample extends StatefulWidget {
  const MotionDurationsExample({super.key});

  @override
  State<MotionDurationsExample> createState() => _MotionDurationsExampleState();
}

class _MotionDurationsExampleState extends State<MotionDurationsExample> {
  /// The three bases. Each has a `-min` and a `-max` variant beside it.
  static const List<AstryxDurationToken> _bases = <AstryxDurationToken>[
    AstryxDurationToken.fast,
    AstryxDurationToken.medium,
    AstryxDurationToken.slow,
  ];

  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    // Durations come from `AstryxMotion`, never from the theme directly: it is
    // the layer that returns zero when the platform asks for reduced motion.
    final motion = AstryxMotion.of(context);

    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final token in _bases)
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxText(
                '${token.name} · ${motion.duration(token).inMilliseconds}ms',
                type: AstryxTextType.code,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.color(AstryxColorToken.backgroundMuted),
                  borderRadius: theme.borderRadius(AstryxRadiusToken.full),
                ),
                child: SizedBox(
                  height: 28,
                  child: AnimatedAlign(
                    duration: motion.duration(token),
                    curve: motion.curve(),
                    alignment: _moved
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing(AstryxSpacingToken.spacing1),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color(AstryxColorToken.accent),
                          borderRadius: theme.borderRadius(
                            AstryxRadiusToken.full,
                          ),
                        ),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          children: <Widget>[
            AstryxButton(
              label: _moved ? 'Send back' : 'Send across',
              onPressed: () => setState(() => _moved = !_moved),
            ),
          ],
        ),
      ],
    );
  }
}
```


| Band | Default | For |
| --- | --- | --- |
| `fastMin` · `fast` · `fastMax` | 130 · 175 · 230ms | Micro-interactions: hover, a toggle, a checkbox. |
| `mediumMin` · `medium` · `mediumMax` | 310 · 410 · 550ms | Entrances and exits: a dialog, a drawer, a panel. |
| `slowMin` · `slow` · `slowMax` | 730 · 975 · 1300ms | The long ones. Rare in a tool. |

The single easing, `--ease-standard`, is `cubic-bezier(0.24, 1, 0.4, 1)` — a fast start that settles. One curve, because a design system with five is a design system where nobody agrees which to use.

## Always through AstryxMotion

Read a duration from `AstryxMotion`, never from the theme. It is the layer that returns `Duration.zero` when the platform asks for reduced motion — zero rather than merely shorter, because the setting exists for people whom movement makes unwell, and a fast animation is still an animation.

```dart
final motion = AstryxMotion.of(context);

AnimatedContainer(
  duration: motion.duration(AstryxDurationToken.fast),
  curve: motion.curve(),
  // …
)
```

For the cases a zero duration cannot express — a looping spinner, a shimmer — ask `motion.animate`, or `AstryxMotionAccess.animate(context)` where there is no theme to resolve. The honest response to reduced motion is to stop, not to race.

## What reduced motion does

- Transitions become instantaneous. The end state is the same state — nothing is skipped, only the travel.
- The spinner paints a complete ring instead of rotating.
- The indeterminate progress bar stops travelling.
- Nothing disappears. A stopped indicator still says "working", because the alternative is a screen that looks finished when it is not.

> **Accessibility**
>
> The switch is the platform’s, read through `MediaQuery.disableAnimationsOf`. Use the device’s own reduce-motion setting to check a screen — there is nothing to turn on in the package.

## A faster or slower theme

Give the two bases and a ratio; each band expands into a min, base and max triple where `min = base × ratio` and `max = base ÷ ratio`. A snappy theme lowers the bases, a cinematic one raises them, and the proportions survive either change.

```dart
// The default motion scale.
const AstryxMotionScaleConfig(
  fast: 175,
  medium: 410,
  slow: 975,
  ratio: 0.75,
);

final acmeSnappy = defineTheme(
  const AstryxDefineThemeInput(
    name: 'acme-snappy',
    motion: AstryxMotionScaleConfig(fast: 120, medium: 260, ratio: 0.75),
  ),
);
```

## Related

- [Accessibility](accessibility.md) — the rest of the rules, in one place.
- [AstryxSpinner](../components/spinner.md) — what stopping looks like.
- [Design tokens](tokens.md) — the other token families.

