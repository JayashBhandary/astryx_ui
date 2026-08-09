import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/demos/layout_demos.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// `AstryxPopover` and `AstryxTooltip`.
abstract final class PopoverDemo {
  static Widget build(BuildContext context) => const _PopoverDemo();
}

class _PopoverDemo extends StatefulWidget {
  const _PopoverDemo();

  @override
  State<_PopoverDemo> createState() => _PopoverDemoState();
}

class _PopoverDemoState extends State<_PopoverDemo> {
  final AstryxOverlayController _controlled = AstryxOverlayController();
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controlled.addListener(() => setState(() => _open = _controlled.isOpen));
  }

  @override
  void dispose() {
    _controlled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Every side — the positioner flips when there is no room',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            for (final side in AstryxOverlaySide.values)
              AstryxPopover(
                side: side,
                width: 180,
                showArrow: true,
                label: side.name,
                content: AstryxVStack(
                  gap: AstryxSpacingToken.spacing2,
                  children: <Widget>[
                    AstryxText('Anchored ${side.name}.'),
                    AstryxButton(label: 'An action', onPressed: () {}),
                  ],
                ),
                triggerBuilder: (context, controller) => AstryxButton(
                  label: side.name,
                  onPressed: controller.toggle,
                ),
              ),
          ],
        ),
      ),
      DemoSection(
        title: 'Controlled — the caller owns the open state',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxPopover(
              controller: _controlled,
              label: 'Filters',
              width: 220,
              content: const AstryxText('Focus is trapped in here.'),
              triggerBuilder: (context, controller) =>
                  AstryxButton(label: 'Filters', onPressed: controller.toggle),
            ),
            AstryxButton(
              label: _open ? 'Close from outside' : 'Open from outside',
              variant: AstryxButtonVariant.secondary,
              onPressed: _controlled.toggle,
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Tooltip — hover, focus, or long-press on touch',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxTooltip(
              message: 'Archive this conversation',
              showArrow: true,
              child: AstryxIconButton(
                icon: AstryxIconName.check,
                label: 'Archive',
                onPressed: () {},
              ),
            ),
            AstryxTooltip(
              message: 'Never put essential information in a tooltip alone.',
              side: AstryxOverlaySide.right,
              child: AstryxButton(
                label: 'Hover me',
                variant: AstryxButtonVariant.secondary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// `AstryxDropdownMenu`.
abstract final class DropdownMenuDemo {
  static Widget build(BuildContext context) => const _DropdownMenuDemo();
}

class _DropdownMenuDemo extends StatefulWidget {
  const _DropdownMenuDemo();

  @override
  State<_DropdownMenuDemo> createState() => _DropdownMenuDemoState();
}

class _DropdownMenuDemoState extends State<_DropdownMenuDemo> {
  String _last = '—';

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Sections, dividers, a submenu and a destructive action',
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxDropdownMenu(
              label: 'Actions',
              width: 240,
              entries: <AstryxMenuEntry>[
                const AstryxMenuSection('Manage'),
                AstryxMenuItem(
                  label: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onSelected: () => setState(() => _last = 'Edit'),
                ),
                AstryxMenuItem(
                  label: 'Duplicate',
                  icon: const AstryxIcon(AstryxIconName.copy),
                  description: 'Requires the Editor role',
                  enabled: false,
                  onSelected: () => setState(() => _last = 'Duplicate'),
                ),
                const AstryxMenuDivider(),
                AstryxMenuItem(
                  label: 'Move to',
                  icon: const Icon(Icons.drive_file_move_outlined),
                  submenu: <AstryxMenuEntry>[
                    AstryxMenuItem(
                      label: 'Archive',
                      onSelected: () => setState(() => _last = 'Archive'),
                    ),
                    AstryxMenuItem(
                      label: 'Backlog',
                      onSelected: () => setState(() => _last = 'Backlog'),
                    ),
                  ],
                ),
                const AstryxMenuDivider(),
                AstryxMenuItem(
                  label: 'Delete',
                  icon: const Icon(Icons.delete_outline),
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
        ),
      ),
      const DemoSection(
        title: 'Icons come from anywhere',
        child: AstryxText(
          'The three icons above are Material icons, not Astryx ones. A menu '
          'item takes any widget, because a design system with 28 semantic '
          'names cannot cover the icons a consuming app needs (ADR-043).',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
      const DemoSection(
        title: 'Keyboard',
        child: AstryxText(
          'Tab to the trigger, then Enter to open. Arrows move the highlight '
          'without choosing anything; Home and End jump; typing jumps to the '
          'first match; Right opens a submenu and Left closes it — mirrored '
          'under RTL. Escape closes the menu, not the page behind it.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
    ],
  );
}

/// `AstryxDialog` and `AstryxToast`.
abstract final class DialogToastDemo {
  static Widget build(BuildContext context) => const _DialogToastDemo();
}

class _DialogToastDemo extends StatefulWidget {
  const _DialogToastDemo();

  @override
  State<_DialogToastDemo> createState() => _DialogToastDemoState();
}

class _DialogToastDemoState extends State<_DialogToastDemo> {
  final AstryxDialogController _dialog = AstryxDialogController();
  final AstryxDialogController _long = AstryxDialogController();

  @override
  void dispose() {
    _dialog.dispose();
    _long.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoPage(
    children: <Widget>[
      DemoSection(
        title: 'Dialog — focus is trapped, and returns to the trigger',
        child: AstryxHStack(
          gap: AstryxSpacingToken.spacing3,
          children: <Widget>[
            AstryxButton(label: 'Delete project', onPressed: _dialog.show),
            AstryxButton(
              label: 'A long one',
              variant: AstryxButtonVariant.secondary,
              onPressed: _long.show,
            ),
            AstryxDialog(
              controller: _dialog,
              title: 'Delete project',
              description: 'This cannot be undone.',
              footer: AstryxHStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  AstryxButton(label: 'Cancel', onPressed: _dialog.hide),
                  AstryxButton(
                    label: 'Delete',
                    variant: AstryxButtonVariant.destructive,
                    onPressed: () {
                      _dialog.hide();
                      AstryxToastScope.of(context).show(
                        const AstryxToast(message: 'Project deleted'),
                      );
                    },
                  ),
                ],
              ),
              child: const AstryxText(
                'Everything in this project will be permanently removed, '
                'including its history.',
              ),
            ),
            AstryxDialog(
              controller: _long,
              title: 'Terms of service',
              footer: AstryxButton(label: 'Close', onPressed: _long.hide),
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                children: <Widget>[
                  for (var i = 1; i <= 30; i++)
                    AstryxText(
                      'Clause $i. The body scrolls; the footer does '
                      'not.',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      DemoSection(
        title: 'Toast — the provider installs the host, so nothing to wire',
        child: Builder(
          builder: (context) => AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxButton(
                label: 'Show one',
                onPressed: () => AstryxToastScope.of(context).show(
                  const AstryxToast(message: 'Project archived'),
                ),
              ),
              AstryxButton(
                label: 'Show an error',
                variant: AstryxButtonVariant.secondary,
                onPressed: () => AstryxToastScope.of(context).show(
                  const AstryxToast(
                    message: 'Could not reach the server',
                    type: AstryxToastType.error,
                  ),
                ),
              ),
              AstryxButton(
                label: 'One that stays',
                variant: AstryxButtonVariant.secondary,
                onPressed: () => AstryxToastScope.of(context).show(
                  const AstryxToast(
                    message: 'Pinned until dismissed',
                    duration: Duration.zero,
                  ),
                ),
              ),
              AstryxButton(
                label: 'Six at once',
                variant: AstryxButtonVariant.ghost,
                onPressed: () {
                  final toasts = AstryxToastScope.of(context);
                  for (var i = 1; i <= 6; i++) {
                    toasts.show(AstryxToast(message: 'Notification $i'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      const DemoSection(
        title: 'Nesting',
        child: AstryxText(
          'Open the dialog, then a popover inside it, then press Escape. The '
          'popover closes and the dialog stays — one layer at a time.',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ),
    ],
  );
}
