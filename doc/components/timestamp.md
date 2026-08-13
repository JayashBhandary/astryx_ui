---
title: AstryxTimestamp
description: 'An absolute time rendered relative — "3 minutes ago" — and re-rendered as it ages.'
component: true
group: Date & time
source: lib/src/components/date_time/timestamp.dart
upstream: Timestamp
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class TimestampDemoExample extends StatelessWidget {
  const TimestampDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Relative, and re-rendered as it ages: "just now" becomes "5 minutes ago"
    // without the caller rebuilding anything. Past a week it writes the date
    // instead, because "43 days ago" is arithmetic nobody asked for.
    return AstryxMetadataList(
      items: <AstryxMetadataItem>[
        AstryxMetadataItem(
          label: 'Deployed',
          value: AstryxTimestamp(now.subtract(const Duration(seconds: 20))),
        ),
        AstryxMetadataItem(
          label: 'Last error',
          value: AstryxTimestamp(now.subtract(const Duration(minutes: 42))),
        ),
        AstryxMetadataItem(
          label: 'Created',
          value: AstryxTimestamp(now.subtract(const Duration(days: 3))),
        ),
        AstryxMetadataItem(
          label: 'Certificate issued',
          value: AstryxTimestamp(now.subtract(const Duration(days: 40))),
        ),
        AstryxMetadataItem(
          label: 'Next run',
          value: AstryxTimestamp(now.add(const Duration(hours: 6))),
        ),
      ],
    );
  }
}
```


## Usage

```dart
AstryxTimestamp(deployedAt)
```

"3 minutes ago" is the right answer for something that just happened and the wrong one for something from March, so a relative timestamp **falls back to a date** once it is older than `threshold` — a week by default.

## Staying current

A relative stamp re-renders as it ages: a row that said "just now" when the page loaded says "5 minutes ago" five minutes later, without the caller rebuilding anything. The timer is a single shot that re-books itself at a distance matching how fast the text can change — 30 seconds while the stamp is minutes old, an hour once it is days old — because a stamp from last March cannot change this minute, and a list of two hundred rows should not wake the framework two hundred times a second to prove it.

> **Note**
>
> Pass `live: false` in a long list that is rebuilt often anyway, and `now` to fix the clock — which is what makes a test of a relative stamp deterministic.

## Formats

| `AstryxTimestampFormat` | Writes |
| --- | --- |
| `relative` | "just now", "42 minutes ago", "in 6 hours" — then a date past the threshold. |
| `date` | `04/08/2026` |
| `time` | `14:30` |
| `dateTime` | `04/08/2026 14:30` |

```dart
class TimestampFormatsExample extends StatelessWidget {
  const TimestampFormatsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final at = DateTime.now().subtract(const Duration(hours: 5));

    // The absolute formats are for a column that has to line up, or a record
    // where the exact instant is the point rather than its age.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxTimestamp(at),
        AstryxTimestamp(at, format: AstryxTimestampFormat.time),
        AstryxTimestamp(at, format: AstryxTimestampFormat.date),
        AstryxTimestamp(
          at,
          format: AstryxTimestampFormat.dateTime,
          timeFormat: AstryxTimeFormat.h12,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```


> **Accessibility**
>
> The exact instant is the widget’s **accessible name** — "Tuesday, 4 August 2026, 14:27" — so a screen reader never gets only a relative phrase whose anchor it cannot see. It is in the tooltip for everybody else, and the relative text stays visible either way: a tooltip is never the only source of a fact.

### AstryxTimestamp

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `value` *(required)* | `DateTime` | — | The instant being written. |
| `format` | `AstryxTimestampFormat` | `AstryxTimestampFormat.relative` | How to write it. |
| `dateFormat` | `AstryxDateFormat` | `AstryxDateFormat.dayMonthYear` | The order the parts of a date are written in. |
| `timeFormat` | `AstryxTimeFormat` | `AstryxTimeFormat.h24` | Which clock a time is written on. |
| `threshold` | `Duration` | `Duration(days: 7)` | How old a relative stamp may get before it is written as a date. |
| `tooltip` | `bool` | `true` | Whether to show the exact instant on hover, focus or long-press. |
| `live` | `bool` | `true` | Whether to re-render as the instant ages. |
| `type` | `AstryxTextType` | `AstryxTextType.body` | The type-scale role of the rendered text. |
| `now` | `DateTime?` | — | What counts as now. Passing one also stops the ticking. |


## Related

- [AstryxMetadataList](metadata_list.md) — where most timestamps end up.
- [AstryxTable](table.md) — a column of these needs `live: false` more often than not.

---

Something wrong with `AstryxTimestamp`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxTimestamp&component=AstryxTimestamp) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxTimestamp&area=AstryxTimestamp) — both templates arrive with the component filled in.
