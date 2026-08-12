import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example timestamp_demo -> TimestampDemoExample
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
// #end

// #example timestamp_formats -> TimestampFormatsExample
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
// #end
