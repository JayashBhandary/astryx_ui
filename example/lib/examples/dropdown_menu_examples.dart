import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example dropdown_menu_demo -> DropdownMenuDemoExample
class DropdownMenuDemoExample extends StatefulWidget {
  const DropdownMenuDemoExample({super.key});

  @override
  State<DropdownMenuDemoExample> createState() =>
      _DropdownMenuDemoExampleState();
}

class _DropdownMenuDemoExampleState extends State<DropdownMenuDemoExample> {
  String _last = '—';

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxDropdownMenu(
          label: 'Actions',
          width: 220,
          entries: <AstryxMenuEntry>[
            AstryxMenuItem(
              label: 'Rename',
              icon: const AstryxIcon(AstryxIconName.wrench),
              onSelected: () => setState(() => _last = 'Rename'),
            ),
            AstryxMenuItem(
              label: 'Duplicate',
              icon: const AstryxIcon(AstryxIconName.copy),
              onSelected: () => setState(() => _last = 'Duplicate'),
            ),
            const AstryxMenuDivider(),
            AstryxMenuItem(
              label: 'Delete',
              destructive: true,
              onSelected: () => setState(() => _last = 'Delete'),
            ),
          ],
          triggerBuilder: (context, controller) =>
              AstryxButton(label: 'Actions', onPressed: controller.toggle),
        ),
        AstryxText(
          'Last chosen: $_last',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
// #end

// #example dropdown_menu_sections -> DropdownMenuSectionsExample
class DropdownMenuSectionsExample extends StatelessWidget {
  const DropdownMenuSectionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Sections and dividers organise a long menu. Neither is focusable, so the
    // keyboard never lands on one.
    return AstryxDropdownMenu(
      label: 'Project menu',
      width: 260,
      entries: <AstryxMenuEntry>[
        const AstryxMenuSection('Manage'),
        AstryxMenuItem(label: 'Settings', onSelected: () {}),
        AstryxMenuItem(
          label: 'Members',
          trailing: const AstryxBadge('24'),
          onSelected: () {},
        ),
        const AstryxMenuDivider(),
        const AstryxMenuSection('Danger zone'),
        AstryxMenuItem(
          label: 'Transfer ownership',
          description: 'You will lose admin access',
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Delete project',
          destructive: true,
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) => AstryxIconButton(
        icon: AstryxIconName.moreHorizontal,
        label: 'Project menu',
        variant: AstryxButtonVariant.ghost,
        onPressed: controller.toggle,
      ),
    );
  }
}
// #end

// #example dropdown_menu_submenu -> DropdownMenuSubmenuExample
class DropdownMenuSubmenuExample extends StatelessWidget {
  const DropdownMenuSubmenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A non-empty `submenu` turns an item into a flyout. Right opens it and
    // Left closes it — mirrored under RTL.
    return AstryxDropdownMenu(
      width: 220,
      entries: <AstryxMenuEntry>[
        AstryxMenuItem(label: 'Open', onSelected: () {}),
        AstryxMenuItem(
          label: 'Move to',
          submenu: <AstryxMenuEntry>[
            const AstryxMenuSection('Boards'),
            AstryxMenuItem(label: 'Backlog', onSelected: () {}),
            AstryxMenuItem(label: 'In progress', onSelected: () {}),
            AstryxMenuItem(
              label: 'Archive',
              submenu: <AstryxMenuEntry>[
                AstryxMenuItem(label: '2024', onSelected: () {}),
                AstryxMenuItem(label: '2025', onSelected: () {}),
              ],
            ),
          ],
        ),
        AstryxMenuItem(
          label: 'Requires the Editor role',
          enabled: false,
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'With submenus', onPressed: controller.toggle),
    );
  }
}
// #end

// #example dropdown_menu_trailing -> DropdownMenuTrailingExample
class DropdownMenuTrailingExample extends StatelessWidget {
  const DropdownMenuTrailingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxDropdownMenu(
      width: 240,
      entries: <AstryxMenuEntry>[
        AstryxMenuItem(
          label: 'Save',
          trailing: const AstryxText(
            'Ctrl S',
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
          onSelected: () {},
        ),
        AstryxMenuItem(
          label: 'Save as…',
          trailing: const AstryxText(
            'Ctrl ⇧ S',
            type: AstryxTextType.code,
            color: AstryxTextColor.secondary,
          ),
          onSelected: () {},
        ),
      ],
      triggerBuilder: (context, controller) =>
          AstryxButton(label: 'File', onPressed: controller.toggle),
    );
  }
}
// #end

// #example dropdown_menu_placement -> DropdownMenuPlacementExample
class DropdownMenuPlacementExample extends StatelessWidget {
  const DropdownMenuPlacementExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A menu matches its trigger's width by default, which is what makes it
    // read as belonging to the control. `width` overrides that.
    return SizedBox(
      width: 280,
      child: AstryxDropdownMenu(
        side: AstryxOverlaySide.top,
        align: AstryxOverlayAlign.end,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Newest first', onSelected: () {}),
          AstryxMenuItem(label: 'Oldest first', onSelected: () {}),
          AstryxMenuItem(label: 'Most requests', onSelected: () {}),
        ],
        triggerBuilder: (context, controller) => AstryxButton(
          label: 'Sort',
          width: double.infinity,
          trailing: const AstryxIcon(AstryxIconName.chevronDown),
          onPressed: controller.toggle,
        ),
      ),
    );
  }
}
// #end
