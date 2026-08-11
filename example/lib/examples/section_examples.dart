import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example section_demo -> SectionDemoExample
class SectionDemoExample extends StatelessWidget {
  const SectionDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxSection(
      title: 'Environments',
      description: 'Where this project is deployed.',
      showDivider: true,
      actions: <Widget>[
        AstryxButton(
          label: 'New environment',
          size: AstryxButtonSize.sm,
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
      ],
      child: AstryxGrid(
        minWidth: 160,
        gap: AstryxSpacingToken.spacing3,
        children: <Widget>[
          for (final env in const <String>['production', 'staging', 'preview'])
            AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText(env),
            ),
        ],
      ),
    );
  }
}
// #end

// #example section_nesting -> SectionNestingExample
class SectionNestingExample extends StatelessWidget {
  const SectionNestingExample({super.key});

  @override
  Widget build(BuildContext context) {
    // No section here is told its level. A page assembled from parts nobody
    // wrote together still produces an outline a screen reader can navigate —
    // which is the fault this exists to prevent, and one nobody can see by
    // looking at the screen.
    return const AstryxSection(
      title: 'Environments',
      child: AstryxSection(
        title: 'Production',
        description: 'Heading level 3, without being told.',
        child: AstryxSection(
          title: 'Regions',
          description: 'And 4 here.',
          child: AstryxText('us-east-1, eu-central-1'),
        ),
      ),
    );
  }
}
// #end

// #example resize_handle_demo -> ResizeHandleDemoExample
class ResizeHandleDemoExample extends StatefulWidget {
  const ResizeHandleDemoExample({super.key});

  @override
  State<ResizeHandleDemoExample> createState() =>
      _ResizeHandleDemoExampleState();
}

class _ResizeHandleDemoExampleState extends State<ResizeHandleDemoExample> {
  double _width = 200;

  @override
  Widget build(BuildContext context) {
    // Tab to the handle and use the arrow keys: a divider only a pointer can
    // move is a layout only some people can use.
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: _width,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('${_width.round()} px'),
            ),
          ),
          AstryxResizeHandle(
            label: 'Resize the filters',
            size: _width,
            min: 120,
            max: 360,
            onResize: (width) => setState(() => _width = width),
          ),
          const Expanded(
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxText('Results'),
            ),
          ),
        ],
      ),
    );
  }
}
// #end

// #example outline_demo -> OutlineDemoExample
class OutlineDemoExample extends StatefulWidget {
  const OutlineDemoExample({super.key});

  @override
  State<OutlineDemoExample> createState() => _OutlineDemoExampleState();
}

class _OutlineDemoExampleState extends State<OutlineDemoExample> {
  final ScrollController _scroll = ScrollController();
  final Map<String, GlobalKey> _anchors = <String, GlobalKey>{
    'setup': GlobalKey(),
    'usage': GlobalKey(),
    'tokens': GlobalKey(),
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scroll the page, and the outline follows: what it tracks is where the
    // headings are, not what the scroll offset says.
    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing4,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  for (final section in const <List<String>>[
                    <String>['setup', 'Setup'],
                    <String>['usage', 'Usage'],
                    <String>['tokens', 'Tokens'],
                  ])
                    AstryxSection(
                      title: section[1],
                      headerKey: _anchors[section[0]],
                      child: const AstryxText(
                        'Enough copy to push the next heading past the top of '
                        'the viewport, which is the event the outline is '
                        'listening for.\n\n'
                        'Scroll on, and the entry beside this one takes the '
                        'accent rule.',
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 160,
            child: AstryxOutline(
              label: 'On this page',
              controller: _scroll,
              entries: <AstryxOutlineEntry>[
                for (final section in const <List<String>>[
                  <String>['setup', 'Setup'],
                  <String>['usage', 'Usage'],
                  <String>['tokens', 'Tokens'],
                ])
                  AstryxOutlineEntry(
                    id: section[0],
                    label: section[1],
                    anchor: _anchors[section[0]],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// #end
