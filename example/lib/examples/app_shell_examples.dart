import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example app_shell_demo -> AppShellDemoExample
class AppShellDemoExample extends StatefulWidget {
  const AppShellDemoExample({super.key});

  @override
  State<AppShellDemoExample> createState() => _AppShellDemoExampleState();
}

class _AppShellDemoExampleState extends State<AppShellDemoExample> {
  String _section = 'deploys';

  @override
  Widget build(BuildContext context) {
    // Narrow the frame and the navigation moves behind a drawer; widen it and
    // it comes back beside the content. The threshold is `compactBelow`, a
    // number that lives beside the widget that needs it.
    return SizedBox(
      height: 420,
      child: AstryxAppShell(
        compactBelow: 600,
        navLabel: 'Sections',
        header: const _ShellHeader(),
        sidebar: AstryxList(
          label: 'Sections',
          density: AstryxItemDensity.compact,
          children: <Widget>[
            for (final section in const <List<String>>[
              <String>['deploys', 'Deploys'],
              <String>['environments', 'Environments'],
              <String>['settings', 'Settings'],
            ])
              AstryxItem(
                label: section[1],
                selected: _section == section[0],
                onPressed: () => setState(() => _section = section[0]),
              ),
          ],
        ),
        child: AstryxLayout(
          header: AstryxHeading(_section, level: 1),
          child: const AstryxText(
            'The shell holds the application together. The page inside it is '
            'an AstryxLayout, which holds this heading still while the body '
            'scrolls under it.',
          ),
        ),
      ),
    );
  }
}

/// The bar across the top, with the menu button the compact layout needs.
class _ShellHeader extends StatelessWidget {
  const _ShellHeader();

  @override
  Widget build(BuildContext context) {
    // `AstryxAppShell.of` is the port of upstream's `useAppShellMobile`: a
    // header cannot know whether to draw a menu button without knowing where
    // the navigation went, and that answer belongs to the shell.
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            AstryxIconButton(
              icon: AstryxIconName.menu,
              label: 'Open navigation',
              variant: AstryxButtonVariant.ghost,
              size: AstryxButtonSize.sm,
              onPressed: shell.controller.toggle,
            ),
          const AstryxText('Acme', type: AstryxTextType.label),
          const Spacer(),
          const AstryxBadge('Production'),
        ],
      ),
    );
  }
}
// #end

// #example layout_demo -> LayoutDemoExample
class LayoutDemoExample extends StatelessWidget {
  const LayoutDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The header and the footer hold still; the body scrolls under them. A
    // page title that scrolls away takes the reader's place in the hierarchy
    // with it, and a Save button that scrolls away cannot be found.
    return SizedBox(
      height: 360,
      child: AstryxLayout(
        header: AstryxHStack(
          justify: AstryxStackJustify.between,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Flexible(child: AstryxHeading('Deploys', level: 1)),
            AstryxButton(
              label: 'New deploy',
              variant: AstryxButtonVariant.primary,
              size: AstryxButtonSize.sm,
              onPressed: () {},
            ),
          ],
        ),
        footer: AstryxHStack(
          gap: AstryxSpacingToken.spacing2,
          justify: AstryxStackJustify.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AstryxButton(label: 'Discard', onPressed: () {}),
            AstryxButton(
              label: 'Save',
              variant: AstryxButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 1; i <= 12; i++)
              AstryxCard(
                padding: AstryxSpacingToken.spacing3,
                child: AstryxText('Deploy #$i'),
              ),
          ],
        ),
      ),
    );
  }
}
// #end

// #example layout_panel -> LayoutPanelExample
class LayoutPanelExample extends StatelessWidget {
  const LayoutPanelExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The panel scrolls on its own: one tied to the body's scroll position is
    // a panel that disappears while you are reading it.
    return SizedBox(
      height: 300,
      child: AstryxLayout(
        header: const AstryxHeading('Deploy #412'),
        panelWidth: 220,
        panel: const AstryxMetadataList(
          items: <AstryxMetadataItem>[
            AstryxMetadataItem(
              label: 'Status',
              value: AstryxBadge('Live', variant: AstryxBadgeVariant.success),
              semanticsValue: 'Live',
            ),
            AstryxMetadataItem(
              label: 'Owner',
              value: AstryxText('Ada Lovelace'),
              semanticsValue: 'Ada Lovelace',
            ),
            AstryxMetadataItem(
              label: 'Duration',
              value: AstryxText('11 minutes'),
              semanticsValue: '11 minutes',
            ),
          ],
        ),
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            for (var i = 1; i <= 10; i++)
              AstryxText('Step $i finished in ${i * 3} seconds.'),
          ],
        ),
      ),
    );
  }
}
// #end
