import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example link_demo -> LinkDemoExample
class LinkDemoExample extends StatelessWidget {
  const LinkDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Flutter has no inline element, so `AstryxLink.span` is how one sits in a
    // sentence. An external link says so in its accessible name as well as in
    // its glyph: the user who cannot see the glyph is the one most disrupted
    // by a window they did not expect.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: AstryxTheme.of(context).textStyle(AstryxTypeRole.body),
            children: <InlineSpan>[
              const TextSpan(text: 'Start with the '),
              AstryxLink.span('installation guide', onPressed: () {}),
              const TextSpan(text: ', then read about '),
              AstryxLink.span('theming', onPressed: () {}),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        AstryxLink('The Flutter docs', external: true, onPressed: () {}),
        AstryxLink('Already read', visited: true, onPressed: () {}),
        const AstryxLink('Unavailable', enabled: false),
      ],
    );
  }
}
// #end

// #example segmented_control_demo -> SegmentedControlDemoExample
class SegmentedControlDemoExample extends StatefulWidget {
  const SegmentedControlDemoExample({super.key});

  @override
  State<SegmentedControlDemoExample> createState() =>
      _SegmentedControlDemoExampleState();
}

class _SegmentedControlDemoExampleState
    extends State<SegmentedControlDemoExample> {
  String _range = 'week';
  String _density = 'balanced';

  @override
  Widget build(BuildContext context) {
    // One tab stop; the arrows move *and* choose, and wrap at both ends. It
    // announces itself as a radio group, which is what it is.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing4,
      children: <Widget>[
        AstryxSegmentedControl<String>(
          label: 'Range',
          value: _range,
          onChanged: (value) => setState(() => _range = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(value: 'day', label: 'Day'),
            AstryxSegment(value: 'week', label: 'Week'),
            AstryxSegment(value: 'month', label: 'Month'),
            AstryxSegment(value: 'year', label: 'Year', enabled: false),
          ],
        ),
        AstryxSegmentedControl<String>(
          label: 'Density',
          value: _density,
          onChanged: (value) => setState(() => _density = value),
          segments: const <AstryxSegment<String>>[
            AstryxSegment(
              value: 'compact',
              label: 'Compact',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.menu),
            ),
            AstryxSegment(
              value: 'balanced',
              label: 'Balanced',
              labelHidden: true,
              icon: AstryxIcon(AstryxIconName.viewColumns),
            ),
          ],
        ),
        AstryxText(
          'Showing $_range, $_density',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example toolbar_demo -> ToolbarDemoExample
class ToolbarDemoExample extends StatefulWidget {
  const ToolbarDemoExample({super.key});

  @override
  State<ToolbarDemoExample> createState() => _ToolbarDemoExampleState();
}

class _ToolbarDemoExampleState extends State<ToolbarDemoExample> {
  final Set<String> _marks = <String>{'bold'};

  @override
  Widget build(BuildContext context) {
    // Tab reaches the band once and leaves it once, however many controls sit
    // between; the arrows move inside it. A formatting bar of twelve buttons
    // is twelve presses to walk past otherwise.
    return AstryxCard(
      padding: AstryxSpacingToken.spacing1,
      child: AstryxToolbar(
        label: 'Formatting',
        children: <Widget>[
          for (final mark in const <List<String>>[
            <String>['bold', 'Bold'],
            <String>['italic', 'Italic'],
            <String>['code', 'Code'],
          ])
            AstryxToggleButton(
              label: mark[1],
              pressed: _marks.contains(mark[0]),
              size: AstryxButtonSize.sm,
              onChanged: (on) => setState(() {
                on ? _marks.add(mark[0]) : _marks.remove(mark[0]);
              }),
            ),
          const AstryxToolbarDivider(),
          AstryxMoreMenu(
            label: 'More formatting',
            entries: <AstryxMenuEntry>[
              AstryxMenuItem(label: 'Strikethrough', onSelected: () {}),
              AstryxMenuItem(label: 'Superscript', onSelected: () {}),
              const AstryxMenuDivider(),
              AstryxMenuItem(
                label: 'Clear formatting',
                destructive: true,
                onSelected: () => setState(_marks.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// #end

// #example tab_menu_demo -> TabMenuDemoExample
class TabMenuDemoExample extends StatefulWidget {
  const TabMenuDemoExample({super.key});

  @override
  State<TabMenuDemoExample> createState() => _TabMenuDemoExampleState();
}

class _TabMenuDemoExampleState extends State<TabMenuDemoExample> {
  String _view = 'overview';

  static const Set<String> _reports = <String>{'usage', 'billing'};

  @override
  Widget build(BuildContext context) {
    // Most tabs are views; this one is a *set* of them. It is drawn as a tab so
    // it reads as one, and announced as a menu button so nobody is told it is
    // a tab and then handed a menu.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxHStack(
          children: <Widget>[
            AstryxTabList<String>(
              label: 'Views',
              value: _reports.contains(_view) ? null : _view,
              onChanged: (value) => setState(() => _view = value),
              tabs: const <AstryxTab<String>>[
                AstryxTab(value: 'overview', label: 'Overview'),
                AstryxTab(value: 'activity', label: 'Activity'),
              ],
            ),
            AstryxTabMenu(
              label: 'Reports',
              selected: _reports.contains(_view),
              entries: <AstryxMenuEntry>[
                for (final report in _reports)
                  AstryxMenuItem(
                    label: report,
                    onSelected: () => setState(() => _view = report),
                  ),
              ],
            ),
          ],
        ),
        AstryxText('Showing $_view'),
      ],
    );
  }
}
// #end

// #example pagination_demo -> PaginationDemoExample
class PaginationDemoExample extends StatefulWidget {
  const PaginationDemoExample({super.key});

  @override
  State<PaginationDemoExample> createState() => _PaginationDemoExampleState();
}

class _PaginationDemoExampleState extends State<PaginationDemoExample> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    // Pages are one-based, as they are to the person reading them. The ends
    // are always shown, the middle gaps, and the arrows disable rather than
    // disappear — a control that vanishes moves everything beside it.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxPagination(
          page: _page,
          pageCount: 20,
          onPageChanged: (page) => setState(() => _page = page),
        ),
        AstryxText(
          'Page $_page of 20',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}

// #end
