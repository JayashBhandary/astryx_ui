import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example metadata_list_demo -> MetadataListDemoExample
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
// #end

// #example metadata_list_inline -> MetadataListInlineExample
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
// #end
