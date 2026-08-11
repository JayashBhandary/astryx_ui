import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example context_menu_demo -> ContextMenuDemoExample
class ContextMenuDemoExample extends StatefulWidget {
  const ContextMenuDemoExample({super.key});

  @override
  State<ContextMenuDemoExample> createState() => _ContextMenuDemoExampleState();
}

class _ContextMenuDemoExampleState extends State<ContextMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    // Secondary-click the card — or long-press it on a touch screen. The menu
    // opens where the pointer is, not against the card's edge.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxContextMenu(
          label: 'Request actions',
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Open in new tab',
              onSelected: () => setState(() => _last = 'opened'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              onSelected: () => setState(() => _last = 'duplicated'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'deleted'),
            ),
          ],
          child: const AstryxCard(
            width: 300,
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxText('GET /v1/projects/atlas'),
                AstryxText(
                  'Last run 14:02 · 204 ms',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
        ),
        AstryxText(
          'Last action: $_last',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example context_menu_sections -> ContextMenuSectionsExample
class ContextMenuSectionsExample extends StatelessWidget {
  const ContextMenuSectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // The same entry vocabulary as a dropdown menu: sections, dividers,
    // descriptions, submenus, destructive rows.
    return AstryxContextMenu(
      entries: <AstryxMenuEntry>[
        const AstryxMenuSection('This row'),
        AstryxMenuItem(label: 'Copy value', onSelected: () {}),
        AstryxMenuItem(
          label: 'Copy as',
          submenu: <AstryxMenuEntry>[
            AstryxMenuItem(label: 'JSON', onSelected: () {}),
            AstryxMenuItem(label: 'CSV', onSelected: () {}),
            AstryxMenuItem(label: 'cURL', onSelected: () {}),
          ],
        ),
        const AstryxMenuDivider(),
        const AstryxMenuSection('This column'),
        AstryxMenuItem(
          label: 'Sort ascending',
          icon: const AstryxIcon(AstryxIconName.arrowUp),
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Hide column',
          icon: const AstryxIcon(AstryxIconName.eyeSlash),
          description: 'Still exported',
          onSelected: () {},
        ),
      ],
      child: const AstryxCard(
        width: 300,
        child: AstryxText('Right-click this cell'),
      ),
    );
  }
}
// #end
