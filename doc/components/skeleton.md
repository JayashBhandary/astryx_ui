---
title: AstryxSkeleton
description: A placeholder in the shape of the content that is coming.
component: true
group: Status
source: lib/src/components/feedback/skeleton.dart
upstream: Skeleton
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SkeletonDemoExample extends StatelessWidget {
  const SkeletonDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxSkeleton.text(),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.6),
        ],
      ),
    );
  }
}
```


## Usage

```dart
const AstryxVStack(
  gap: AstryxSpacingToken.spacing2,
  align: AstryxStackAlign.stretch,
  children: <Widget>[
    AstryxSkeleton.text(),
    AstryxSkeleton.text(),
    AstryxSkeleton.text(widthFactor: 0.6),
  ],
)
```

## Shapes

Three constructors: the default rectangle, `.text()` for a line of copy, and `.circle()` for an avatar. `widthFactor` shortens a text line — a paragraph’s last line is rarely full width, and placeholders that are all the same length read as a table.

```dart
class SkeletonShapesExample extends StatelessWidget {
  const SkeletonShapesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxHStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSkeleton.circle(size: 40),
        SizedBox(width: 120, child: AstryxSkeleton.text()),
        AstryxSkeleton(width: 96, height: 32),
      ],
    );
  }
}
```


## Matching the real thing

A placeholder earns its place only when it has the shape of what arrives. Mirror the real card’s slots; a generic grey box is a worse answer than a spinner.

```dart
class SkeletonCardExample extends StatelessWidget {
  const SkeletonCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A placeholder is worth having only when it has the shape of what
    // arrives. Match the real card's slots, not a generic grey box.
    return const AstryxCard(
      maxWidth: 360,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxSkeleton.circle(size: 40),
              Expanded(
                child: AstryxVStack(
                  gap: AstryxSpacingToken.spacing1,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxSkeleton.text(widthFactor: 0.5),
                    AstryxSkeleton.text(widthFactor: 0.3, height: 12),
                  ],
                ),
              ),
            ],
          ),
          AstryxSkeleton.text(),
          AstryxSkeleton.text(widthFactor: 0.8),
          AstryxSkeleton(height: 32, radius: AstryxRadiusToken.element),
        ],
      ),
    );
  }
}
```


## The delay

The block is visible immediately; only the pulse waits — 250ms by default. Content that loads quickly should not flash an animation on its way past.

```dart
class SkeletonDelayExample extends StatefulWidget {
  const SkeletonDelayExample({super.key});

  @override
  State<SkeletonDelayExample> createState() => _SkeletonDelayExampleState();
}

class _SkeletonDelayExampleState extends State<SkeletonDelayExample> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    // The block appears at once; only the pulse waits. Content that arrives
    // quickly should not flash an animation on its way past.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        SizedBox(
          width: 280,
          child: AstryxVStack(
            key: ValueKey<int>(_run),
            gap: AstryxSpacingToken.spacing2,
            align: AstryxStackAlign.stretch,
            children: const <Widget>[
              AstryxSkeleton.text(delay: Duration.zero),
              AstryxSkeleton.text(delay: Duration(milliseconds: 600)),
              AstryxSkeleton.text(delay: Duration(seconds: 1)),
            ],
          ),
        ),
        AstryxButton(
          label: 'Restart',
          size: AstryxButtonSize.sm,
          onPressed: () => setState(() => _run++),
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> A skeleton is decoration and is hidden from assistive technology. Announce the wait once, at the container — a screen reader reading twelve "loading" boxes has been told nothing twelve times.

### AstryxSkeleton

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `double?` | — | A fixed width. Null fills the available space. Default constructor only. |
| `widthFactor` | `double?` | — | The fraction of the available width to fill. `AstryxSkeleton.text` only. |
| `height` | `double` | `16 (14 for `.text`)` | The height. |
| `radius` | `AstryxRadiusToken` | `AstryxRadiusToken.inner` | The corner radius token. |
| `delay` | `Duration` | `Duration(milliseconds: 250)` | How long to wait before the pulse begins. |


---

Something wrong with `AstryxSkeleton`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxSkeleton&component=AstryxSkeleton) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxSkeleton&area=AstryxSkeleton) — both templates arrive with the component filled in.
