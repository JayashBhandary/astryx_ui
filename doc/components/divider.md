---
title: AstryxDivider
description: A rule between sections, optionally labelled.
component: true
group: Layout & typography
source: lib/src/components/layout/divider.dart
upstream: Divider
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class DividerDemoExample extends StatelessWidget {
  const DividerDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('Personal details'),
        AstryxDivider(),
        AstryxText('Billing'),
      ],
    );
  }
}
```


## Usage

```dart
const AstryxDivider()
```

## Variants

```dart
class DividerVariantsExample extends StatelessWidget {
  const DividerVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxText('subtle', type: AstryxTextType.label),
        AstryxDivider(),
        AstryxText('strong', type: AstryxTextType.label),
        AstryxDivider(variant: AstryxDividerVariant.strong),
      ],
    );
  }
}
```


> **Careful**
>
> The `subtle` variant is roughly 1.1:1 against its background — deliberately, matching upstream. It is decoration. Never use it as a control's only visible boundary, and never to convey information.

## Labelled

A label sits in the middle of the rule. Horizontal dividers only. A labelled divider is announced; an unlabelled one is not, because a rule with nothing to say should not interrupt.

```dart
class DividerLabelledExample extends StatelessWidget {
  const DividerLabelledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Continue with email',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          const AstryxDivider(label: 'or'),
          AstryxButton(label: 'Continue with SSO', onPressed: () {}),
        ],
      ),
    );
  }
}
```


## Vertical

A vertical rule needs a bounded height from its parent — a stretched row, or an `IntrinsicHeight`. Without one it has nothing to measure and paints nothing.

```dart
class DividerVerticalExample extends StatelessWidget {
  const DividerVerticalExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A vertical rule needs a bounded height. `align: stretch` inside a row of
    // known height gives it one; an `IntrinsicHeight` also works.
    return const SizedBox(
      height: 24,
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxText('Edited 2h ago', type: AstryxTextType.supporting),
          AstryxDivider(axis: Axis.vertical),
          AstryxText('4 collaborators', type: AstryxTextType.supporting),
          AstryxDivider(axis: Axis.vertical),
          AstryxText('Public', type: AstryxTextType.supporting),
        ],
      ),
    );
  }
}
```


### AstryxDivider

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `axis` | `Axis` | `Axis.horizontal` | Whether the rule runs horizontally or vertically. |
| `variant` | `AstryxDividerVariant` | `AstryxDividerVariant.subtle` | How prominent the rule is. |
| `label` | `String?` | — | Text shown in the middle of the rule. Horizontal only. |
| `theme` | `AstryxDividerTheme?` | — | Visual overrides, merged over `AstryxThemeData.divider`. |


---

Something wrong with `AstryxDivider`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxDivider&component=AstryxDivider) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxDivider&area=AstryxDivider) — both templates arrive with the component filled in.
