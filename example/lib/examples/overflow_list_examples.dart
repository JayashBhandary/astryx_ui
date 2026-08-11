import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example overflow_list_demo -> OverflowListDemoExample
class OverflowListDemoExample extends StatefulWidget {
  const OverflowListDemoExample({super.key});

  @override
  State<OverflowListDemoExample> createState() =>
      _OverflowListDemoExampleState();
}

class _OverflowListDemoExampleState extends State<OverflowListDemoExample> {
  static const List<String> _tags = <String>[
    'billing',
    'infra',
    'urgent',
    'customer-reported',
    'regression',
    'needs-repro',
  ];

  String? _chosen;

  @override
  Widget build(BuildContext context) {
    // Narrow the window and the tail moves into the menu; widen it and the
    // items come back. Nothing is ever unreachable — what does not fit is a
    // real menu row, not a clipped one.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxOverflowList(
          menuLabel: 'More tags',
          items: <AstryxOverflowItem>[
            for (final tag in _tags)
              AstryxOverflowItem(
                label: tag,
                onSelected: () => setState(() => _chosen = tag),
                child: AstryxBadge(tag),
              ),
          ],
        ),
        AstryxText(
          _chosen == null ? 'Nothing chosen yet' : 'Chose $_chosen',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example overflow_list_widths -> OverflowListWidthsExample
class OverflowListWidthsExample extends StatelessWidget {
  const OverflowListWidthsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The same six actions at three widths. The row is measured, not guessed,
    // so the answer is right at every one of them.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        for (final width in const <double>[420, 280, 160])
          AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxText(
                '${width.toInt()} px',
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
              SizedBox(
                width: width,
                child: AstryxOverflowList(
                  items: <AstryxOverflowItem>[
                    for (final action in const <String>[
                      'Rename',
                      'Duplicate',
                      'Move',
                      'Archive',
                      'Export',
                      'Delete',
                    ])
                      AstryxOverflowItem(
                        label: action,
                        onSelected: () {},
                        child: AstryxButton(
                          label: action,
                          size: AstryxButtonSize.sm,
                          onPressed: () {},
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
// #end
