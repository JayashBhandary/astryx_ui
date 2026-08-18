import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example tab_list_demo -> TabListDemoExample
class TabListDemoExample extends StatefulWidget {
  const TabListDemoExample({super.key});

  @override
  State<TabListDemoExample> createState() => _TabListDemoExampleState();
}

class _TabListDemoExampleState extends State<TabListDemoExample> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    // The strip owns no panel. It reports a value; the application decides what
    // that value shows — which is what keeps a tab bar usable with routing.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Project sections',
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'overview', label: 'Overview'),
            AstryxTab(value: 'activity', label: 'Activity'),
            AstryxTab(value: 'settings', label: 'Settings'),
          ],
        ),
        AstryxText(switch (_tab) {
          'overview' => '4,201 requests this month.',
          'activity' => 'Ada deployed 20 minutes ago.',
          _ => 'Two admins, twenty-two members.',
        }),
      ],
    );
  }
}
// #end

// #example tab_list_icons -> TabListIconsExample
class TabListIconsExample extends StatefulWidget {
  const TabListIconsExample({super.key});

  @override
  State<TabListIconsExample> createState() => _TabListIconsExampleState();
}

class _TabListIconsExampleState extends State<TabListIconsExample> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    return AstryxTabList<String>(
      value: _tab,
      onChanged: (value) => setState(() => _tab = value),
      tabs: const <AstryxTab<String>>[
        AstryxTab(
          value: 'overview',
          label: 'Overview',
          icon: AstryxIcon(AstryxIconName.info),
        ),
        AstryxTab(
          value: 'activity',
          label: 'Activity',
          badge: AstryxBadge(
            '12',
            semanticsLabel: '12 new',
            variant: AstryxBadgeVariant.info,
          ),
        ),
        AstryxTab(
          value: 'settings',
          label: 'Settings',
          icon: AstryxIcon(AstryxIconName.wrench),
        ),
        AstryxTab(value: 'archive', label: 'Archive', enabled: false),
      ],
    );
  }
}
// #end

// #example tab_list_sizes -> TabListSizesExample
class TabListSizesExample extends StatefulWidget {
  const TabListSizesExample({super.key});

  @override
  State<TabListSizesExample> createState() => _TabListSizesExampleState();
}

class _TabListSizesExampleState extends State<TabListSizesExample> {
  String _tab = 'a';

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        for (final size in AstryxTabSize.values)
          AstryxTabList<String>(
            size: size,
            value: _tab,
            onChanged: (value) => setState(() => _tab = value),
            tabs: const <AstryxTab<String>>[
              AstryxTab(value: 'a', label: 'First'),
              AstryxTab(value: 'b', label: 'Second'),
              AstryxTab(value: 'c', label: 'Third'),
            ],
          ),
      ],
    );
  }
}
// #end

// #example tab_list_fill -> TabListFillExample
class TabListFillExample extends StatefulWidget {
  const TabListFillExample({super.key});

  @override
  State<TabListFillExample> createState() => _TabListFillExampleState();
}

class _TabListFillExampleState extends State<TabListFillExample> {
  String _tab = 'a';

  @override
  Widget build(BuildContext context) {
    // `fill` splits the width equally — for two or three tabs in a narrow
    // panel, where a left-packed strip looks unfinished.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          fill: true,
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'Monthly'),
            AstryxTab(value: 'b', label: 'Yearly'),
          ],
        ),
        AstryxTabList<String>(
          showDivider: false,
          value: _tab,
          onChanged: (value) => setState(() => _tab = value),
          tabs: const <AstryxTab<String>>[
            AstryxTab(value: 'a', label: 'No divider'),
            AstryxTab(value: 'b', label: 'Under the strip'),
          ],
        ),
      ],
    );
  }
}
// #end

// #example tab_list_overflow -> TabListOverflowExample
class TabListOverflowExample extends StatefulWidget {
  const TabListOverflowExample({super.key});

  @override
  State<TabListOverflowExample> createState() => _TabListOverflowExampleState();
}

class _TabListOverflowExampleState extends State<TabListOverflowExample> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    // Too many tabs scroll rather than shrink, with a fade at whichever edge
    // has more. Arrowing to an off-screen tab scrolls it into view — a
    // selection you cannot see is worse than none.
    return SizedBox(
      width: 360,
      child: AstryxTabList<int>(
        value: _tab,
        onChanged: (value) => setState(() => _tab = value),
        tabs: <AstryxTab<int>>[
          for (var i = 0; i < 16; i++)
            AstryxTab<int>(value: i, label: 'Section $i'),
        ],
      ),
    );
  }
}
// #end

// #example tab_list_closable -> TabListClosableExample
class TabListClosableExample extends StatefulWidget {
  const TabListClosableExample({super.key});

  @override
  State<TabListClosableExample> createState() => _TabListClosableExampleState();
}

class _TabListClosableExampleState extends State<TabListClosableExample> {
  List<String> _open = <String>['card.dart', 'table.dart', 'tab_list.dart'];
  String _file = 'table.dart';

  void _close(String file) {
    setState(() {
      final index = _open.indexOf(file);
      _open = List<String>.of(_open)..removeAt(index);
      if (_file != file) return;
      // The neighbour, not the first tab: closing what you were reading should
      // not move you to the other end of the strip.
      _file = _open.isEmpty
          ? ''
          : _open[index < _open.length ? index : _open.length - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    // An onClose puts a close button after the label. The strip owns no list,
    // so removing the tab — and deciding what is selected afterwards — is the
    // caller's job.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTabList<String>(
          label: 'Open files',
          value: _file,
          size: AstryxTabSize.sm,
          onChanged: (value) => setState(() => _file = value),
          tabs: <AstryxTab<String>>[
            for (final file in _open)
              AstryxTab<String>(
                value: file,
                label: file,
                onClose: () => _close(file),
              ),
          ],
        ),
        AstryxText(_open.isEmpty ? 'Nothing open.' : 'Editing $_file.'),
      ],
    );
  }
}

// #end
