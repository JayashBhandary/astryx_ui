---
title: AstryxMetadataList
description: Label-and-value pairs, for the details panel of a record.
component: true
group: Data display
source: lib/src/components/data/metadata_list.dart
upstream: MetadataList / MetadataListItem
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class MetadataListDemoExample extends StatelessWidget {
  const MetadataListDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstryxMetadataList(
      items: <AstryxMetadataItem>[
        AstryxMetadataItem(
          label: 'Owner',
          value: AstryxText('Ada Lovelace'),
          semanticsValue: 'Ada Lovelace',
        ),
        AstryxMetadataItem(
          label: 'Created',
          value: AstryxText('3 March 2026'),
          semanticsValue: '3 March 2026',
        ),
        AstryxMetadataItem(
          label: 'Status',
          // A widget value needs `semanticsValue`: without it a screen reader
          // is read the badge's colour story rather than the word "Live".
          semanticsValue: 'Live',
          value: AstryxBadge('Live', variant: AstryxBadgeVariant.success),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxMetadataList(
  items: <AstryxMetadataItem>[
    AstryxMetadataItem.text(label: 'Owner', value: 'Ada Lovelace'),
    AstryxMetadataItem(label: 'Status', value: const AstryxBadge('Live')),
  ],
)
```

For facts about **one** thing. For rows *of* things use [AstryxList](list.md), and for many things sharing the same fields use [AstryxTable](table.md).

## Stacked or inline

Inline reads faster when the values are short and there are many of them; stacked survives a narrow column, which inline does not.

```dart
class MetadataListInlineExample extends StatelessWidget {
  const MetadataListInlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Inline reads faster when the values are short and there are many of
    // them; stacked survives a narrow column, which inline does not.
    return const AstryxMetadataList(
      direction: AstryxMetadataListDirection.inline,
      labelWidth: 120,
      items: <AstryxMetadataItem>[
        AstryxMetadataItem(
          label: 'Region',
          icon: AstryxIcon(AstryxIconName.info),
          value: AstryxText('us-east-1'),
          semanticsValue: 'us-east-1',
        ),
        AstryxMetadataItem(
          label: 'Instance',
          value: AstryxText('c6g.2xlarge'),
          semanticsValue: 'c6g.2xlarge',
        ),
        AstryxMetadataItem(
          label: 'Uptime',
          value: AstryxText('42 days'),
          semanticsValue: '42 days',
        ),
      ],
    );
  }
}
```


`labelWidth` is a number rather than "as wide as the widest label", which CSS grid does for free and Flutter would pay for by laying every label out twice — the same trade [AstryxFormLayout](form_layout.md) makes.

> **Accessibility**
>
> A pair is one semantics node, so a screen reader reads "Owner, Ada Lovelace" rather than stopping between the two halves of one fact. Set `semanticsValue` whenever the value is not plain text: a badge announces its own contents, and "green dot, Healthy" has one word of information in it.

### AstryxMetadataList

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `items` *(required)* | `List<AstryxMetadataItem>` | — | The pairs, in order. |
| `direction` | `AstryxMetadataListDirection` | `AstryxMetadataListDirection.stacked` | Whether a label sits above its value (`stacked`) or beside it (`inline`). |
| `labelWidth` | `double` | `140` | The width of the label column when inline. |
| `gap` | `AstryxSpacingToken` | `AstryxSpacingToken.spacing3` | The space between pairs. |


### AstryxMetadataItem

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | What the value is. |
| `value` *(required)* | `Widget` | — | The value itself. `AstryxMetadataItem.text` builds it from a string and sets the announcement to match. |
| `icon` | `Widget?` | — | An icon before the label. |
| `semanticsValue` | `String?` | — | What a screen reader reads as the value. Required in practice whenever `value` is not plain text. |


---

Something wrong with `AstryxMetadataList`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxMetadataList&component=AstryxMetadataList) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxMetadataList&area=AstryxMetadataList) — both templates arrive with the component filled in.
