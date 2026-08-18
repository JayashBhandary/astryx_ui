/// The settings templates.
///
/// A settings screen and the same thing inside a modal. Both follow the one
/// rule that decides which control a preference gets: a switch applies the
/// moment it moves, a checkbox waits for Save. Mixing them on one screen asks
/// the user to guess which kind of change they just made.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

// #example template_settings -> SettingsTemplate
class SettingsTemplate extends StatefulWidget {
  const SettingsTemplate({super.key});

  @override
  State<SettingsTemplate> createState() => _SettingsTemplateState();
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  final Set<String> _on = <String>{'mentions', 'incidents'};
  final AstryxDialogController _leave = AstryxDialogController();

  String? _theme = 'system';
  String? _startPage = 'dashboard';

  @override
  void dispose() {
    _leave.dispose();
    super.dispose();
  }

  /// Applies a switch immediately, and says so. A setting that takes effect
  /// silently and a setting that failed to save look identical.
  void _toggle(String id, String label, bool value) {
    setState(() {
      if (value) {
        _on.add(id);
      } else {
        _on.remove(id);
      }
    });
    AstryxToastScope.of(context).show(
      AstryxToast(message: '$label ${value ? 'on' : 'off'}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing6,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxVStack(
          gap: AstryxSpacingToken.spacing1,
          children: <Widget>[
            AstryxHeading('Settings', level: 1),
            AstryxText(
              'Yours only. Workspace-wide settings live under Admin.',
              color: AstryxTextColor.secondary,
            ),
          ],
        ),
        // Notifications are switches: each one is in force the moment it moves,
        // and there is no Save button on the screen to suggest otherwise.
        AstryxCard(
          header: const _SectionHeader(
            title: 'Notifications',
            description: 'Applied as you change them.',
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing3,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              for (final row in const <List<String>>[
                <String>['mentions', 'Mentions', 'When someone @s you'],
                <String>['incidents', 'Incidents', 'Sev-1 and Sev-2 only'],
                <String>['digest', 'Weekly digest', 'Mondays, 9am'],
                <String>['marketing', 'Product news', 'About once a month'],
              ]) ...<Widget>[
                if (row.first != 'mentions') const AstryxDivider(),
                AstryxSwitch(
                  label: row[1],
                  description: row[2],
                  value: _on.contains(row.first),
                  labelPosition: AstryxToggleLabelPosition.start,
                  labelSpacing: AstryxToggleLabelSpacing.spread,
                  onChanged: (value) => _toggle(row.first, row[1], value),
                ),
              ],
            ],
          ),
        ),
        AstryxCard(
          header: const _SectionHeader(
            title: 'Appearance',
            description: 'Stored on this device.',
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing4,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxSelector<String>(
                label: 'Colour mode',
                value: _theme,
                onChanged: (value) => setState(() => _theme = value),
                options: const <AstryxSelectorEntry<String>>[
                  AstryxSelectorOption(
                    value: 'system',
                    label: 'Match the system',
                    description: 'Follows your OS setting as it changes',
                  ),
                  AstryxSelectorOption(value: 'light', label: 'Light'),
                  AstryxSelectorOption(value: 'dark', label: 'Dark'),
                ],
              ),
              AstryxSelector<String>(
                label: 'Open on',
                value: _startPage,
                onChanged: (value) => setState(() => _startPage = value),
                options: const <AstryxSelectorEntry<String>>[
                  AstryxSelectorOption(
                    value: 'dashboard',
                    label: 'Dashboard',
                  ),
                  AstryxSelectorOption(value: 'incidents', label: 'Incidents'),
                  AstryxSelectorOption(value: 'projects', label: 'Projects'),
                ],
              ),
            ],
          ),
        ),
        // The destructive section is last, is bordered in its own right, and
        // goes through a dialog. The button alone is not the confirmation.
        AstryxCard(
          variant: const AstryxCardVariant.palette(AstryxPalette.red),
          header: const _SectionHeader(
            title: 'Leave workspace',
            description: 'You will lose access to Atlas immediately.',
          ),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            children: <Widget>[
              AstryxButton(
                label: 'Leave Atlas',
                variant: AstryxButtonVariant.destructive,
                onPressed: _leave.show,
              ),
              AstryxDialog(
                controller: _leave,
                title: 'Leave Atlas?',
                description: 'An admin has to invite you back.',
                footer: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  justify: AstryxStackJustify.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AstryxButton(label: 'Stay', onPressed: _leave.hide),
                    AstryxButton(
                      label: 'Leave',
                      variant: AstryxButtonVariant.destructive,
                      onPressed: _leave.hide,
                    ),
                  ],
                ),
                child: const AstryxText(
                  'Your drafts and saved views are deleted after 30 days. '
                  'Anything you published stays with the workspace.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// #end

// #example template_settings_dialog -> SettingsDialogTemplate
class SettingsDialogTemplate extends StatefulWidget {
  const SettingsDialogTemplate({super.key});

  @override
  State<SettingsDialogTemplate> createState() => _SettingsDialogTemplateState();
}

class _SettingsDialogTemplateState extends State<SettingsDialogTemplate> {
  final AstryxDialogController _controller = AstryxDialogController();
  final TextEditingController _name = TextEditingController(text: 'Ada');

  /// The dialog's own navigation. A tab list reports a value and owns no panel,
  /// so the section on screen is this field and nothing else.
  String _section = 'profile';
  bool _compact = false;
  final Set<String> _on = <String>{'mentions'};

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Open settings',
          leading: const AstryxIcon(AstryxIconName.wrench),
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Settings',
          width: 520,
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Close', onPressed: _controller.hide),
            ],
          ),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing5,
            align: AstryxStackAlign.stretch,
            children: <Widget>[
              AstryxTabList<String>(
                label: 'Settings sections',
                value: _section,
                onChanged: (value) => setState(() => _section = value),
                tabs: const <AstryxTab<String>>[
                  AstryxTab(value: 'profile', label: 'Profile'),
                  AstryxTab(value: 'notifications', label: 'Notifications'),
                  AstryxTab(value: 'advanced', label: 'Advanced'),
                ],
              ),
              switch (_section) {
                'profile' => AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxTextInput(
                      label: 'Display name',
                      controller: _name,
                      required: true,
                    ),
                    const AstryxTextInput(
                      label: 'Email',
                      readOnly: true,
                      // Read-only, not disabled: the value matters, it is just
                      // not yours to change here.
                      description: 'Managed by your identity provider.',
                      placeholder: 'ada@example.com',
                    ),
                  ],
                ),
                'notifications' => AstryxVStack(
                  gap: AstryxSpacingToken.spacing3,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    for (final row in const <List<String>>[
                      <String>['mentions', 'Mentions'],
                      <String>['replies', 'Replies to my comments'],
                      <String>['deploys', 'Deploy failures'],
                    ])
                      AstryxSwitch(
                        label: row[1],
                        value: _on.contains(row.first),
                        labelPosition: AstryxToggleLabelPosition.start,
                        labelSpacing: AstryxToggleLabelSpacing.spread,
                        onChanged: (value) => setState(() {
                          if (value) {
                            _on.add(row.first);
                          } else {
                            _on.remove(row.first);
                          }
                        }),
                      ),
                  ],
                ),
                _ => AstryxVStack(
                  gap: AstryxSpacingToken.spacing4,
                  align: AstryxStackAlign.stretch,
                  children: <Widget>[
                    AstryxSwitch(
                      label: 'Compact tables',
                      description: 'More rows, less room in each.',
                      value: _compact,
                      labelPosition: AstryxToggleLabelPosition.start,
                      labelSpacing: AstryxToggleLabelSpacing.spread,
                      onChanged: (value) => setState(() => _compact = value),
                    ),
                    const AstryxBanner(
                      title: 'Changes here apply immediately',
                      description: 'There is no Save button, by design.',
                      announce: false,
                    ),
                  ],
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}
// #end

/// A settings card's heading and one line about what the section governs.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing1,
      children: <Widget>[
        AstryxHeading(title),
        AstryxText(
          description,
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}

// #example template_settings_sidebar -> SettingsSidebarTemplate
class SettingsSidebarTemplate extends StatefulWidget {
  const SettingsSidebarTemplate({super.key});

  @override
  State<SettingsSidebarTemplate> createState() =>
      _SettingsSidebarTemplateState();
}

class _SettingsSidebarTemplateState extends State<SettingsSidebarTemplate> {
  /// The sections, as navigation rather than as headings on one long page.
  ///
  /// Past about four sections a settings page stops being scannable, and the
  /// reader is scrolling to find out what exists. A rail answers that question
  /// without scrolling anything.
  static const List<AstryxNavEntry> _sections = <AstryxNavEntry>[
    AstryxNavSection(
      label: 'You',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'profile',
          label: 'Profile',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.check)),
        ),
        AstryxNavItem(
          id: 'notifications',
          label: 'Notifications',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.info)),
          trailing: AstryxBadge('2'),
        ),
        AstryxNavItem(
          id: 'appearance',
          label: 'Appearance',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.viewColumns)),
        ),
      ],
    ),
    AstryxNavSection(
      label: 'Workspace',
      items: <AstryxNavItem>[
        AstryxNavItem(
          id: 'members',
          label: 'Members',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.checkDouble)),
        ),
        AstryxNavItem(
          id: 'security',
          label: 'Security',
          icon: AstryxNavIcon(AstryxIcon(AstryxIconName.eyeSlash)),
        ),
      ],
    ),
    AstryxNavDivider(),
    AstryxNavItem(
      id: 'danger',
      label: 'Delete workspace',
      icon: AstryxNavIcon(AstryxIcon(AstryxIconName.warning)),
    ),
  ];

  static const Map<String, ({String title, String description})> _headings =
      <String, ({String title, String description})>{
        'profile': (
          title: 'Profile',
          description: 'How you appear to everyone else in the workspace.',
        ),
        'notifications': (
          title: 'Notifications',
          description: 'What reaches you, and how loudly.',
        ),
        'appearance': (
          title: 'Appearance',
          description: 'Yours only. Nobody else sees these.',
        ),
        'members': (
          title: 'Members',
          description: 'Who is in this workspace, and what they may do.',
        ),
        'security': (
          title: 'Security',
          description: 'Sign-in, sessions and tokens.',
        ),
        'danger': (
          title: 'Delete workspace',
          description: 'Everything in it goes, thirty days later.',
        ),
      };

  final Set<String> _on = <String>{'mentions', 'incidents', 'digest'};
  final AstryxDialogController _confirm = AstryxDialogController();

  String _section = 'notifications';
  String? _theme = 'system';

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  /// Every control here applies the moment it moves, so every one of them
  /// confirms. There is no Save button anywhere on this screen — adding one
  /// would make every switch a lie.
  void _toggle(String id, String label, {required bool value}) {
    setState(() {
      if (value) {
        _on.add(id);
      } else {
        _on.remove(id);
      }
    });
    AstryxToastScope.of(context).show(
      AstryxToast(message: '$label ${value ? 'on' : 'off'}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heading = _headings[_section]!;

    // The rail sits in the *shell* rather than in the layout's `panel`. Two
    // reasons, and the second is the one that matters on a phone: a panel is
    // wrapped in a scroll view, so it is handed an unbounded height — and an
    // `AstryxSideNav` pins its own footer with an `Expanded`, which cannot be
    // laid out against one. And a shell already knows what to do when there is
    // no room beside the content: the rail moves into a drawer, with the
    // focus trap, the Escape key and the return of focus that a hand-rolled
    // `Row` never gets around to.
    return SizedBox(
      height: 620,
      child: AstryxAppShell(
        compactBelow: 640,
        sidebarWidth: 232,
        navLabel: 'Settings sections',
        header: _SettingsBar(title: heading.title),
        // A rail of sections, not a tab strip: these are *places* in a
        // settings area rather than views of one thing, and there are
        // more of them than a strip can hold without scrolling sideways.
        sidebar: AstryxSideNav(
          label: 'Settings sections',
          entries: _sections,
          selectedId: _section,
          onSelected: (id) {
            setState(() => _section = id);
            // Choosing a section in the drawer is the end of what the drawer
            // was opened for. Leaving it up would hide the answer.
            AstryxAppShell.of(context).controller.hide();
          },
        ),
        child: AstryxLayout(
          maxContentWidth: 620,
          header: AstryxVStack(
            gap: AstryxSpacingToken.spacing1,
            children: <Widget>[
              AstryxHeading(heading.title, level: 1),
              AstryxText(
                heading.description,
                type: AstryxTextType.supporting,
                color: AstryxTextColor.secondary,
              ),
            ],
          ),
          child: switch (_section) {
            'notifications' => _notifications(),
            'appearance' => _appearance(),
            'danger' => _danger(context),
            _ => _placeholder(heading.title),
          },
        ),
      ),
    );
  }

  Widget _notifications() {
    return AstryxCard(
      padding: AstryxSpacingToken.spacing0,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing0,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final row in const <List<String>>[
            <String>['mentions', 'Mentions', 'When someone @s you'],
            <String>[
              'incidents',
              'Incidents',
              'Every Sev-1, however it was raised',
            ],
            <String>['digest', 'Weekly digest', 'Monday morning, once'],
            <String>['marketing', 'Product news', 'Roughly monthly'],
          ])
            Padding(
              padding: const EdgeInsets.all(16),
              child: AstryxSwitch(
                label: row[1],
                description: row[2],
                value: _on.contains(row[0]),
                labelPosition: AstryxToggleLabelPosition.start,
                labelSpacing: AstryxToggleLabelSpacing.spread,
                onChanged: (value) => _toggle(row[0], row[1], value: value),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appearance() {
    return AstryxCard(
      child: AstryxSelector<String>(
        label: 'Theme',
        description: 'Applies as soon as it is chosen.',
        value: _theme,
        onChanged: (value) => setState(() => _theme = value),
        options: const <AstryxSelectorOption<String>>[
          AstryxSelectorOption(value: 'system', label: 'Match the system'),
          AstryxSelectorOption(value: 'light', label: 'Light'),
          AstryxSelectorOption(value: 'dark', label: 'Dark'),
        ],
      ),
    );
  }

  /// The destructive section is a destination of its own here, rather than the
  /// bottom of a long page — which is the one thing a sidebar changes about
  /// the [SettingsTemplate] shape.
  Widget _danger(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        const AstryxBanner(
          status: AstryxBannerStatus.warning,
          title: 'This cannot be undone after thirty days',
          description:
              'Drafts, saved views and every uploaded asset go with the '
              'workspace.',
          announce: false,
        ),
        AstryxCard(
          variant: const AstryxCardVariant.palette(AstryxPalette.red),
          child: AstryxHStack(
            gap: AstryxSpacingToken.spacing3,
            justify: AstryxStackJustify.between,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Flexible(
                child: AstryxText(
                  'Deleting removes the workspace for all eleven members.',
                ),
              ),
              AstryxButton(
                label: 'Delete workspace',
                variant: AstryxButtonVariant.destructive,
                onPressed: _confirm.show,
              ),
            ],
          ),
        ),
        // The button is not the confirmation; the dialog is, and it states
        // what is actually lost rather than asking "are you sure?".
        AstryxAlertDialog(
          controller: _confirm,
          title: 'Delete this workspace?',
          description:
              'Eleven members lose access immediately. Everything in the '
              'workspace is deleted permanently after thirty days.',
          confirmLabel: 'Delete workspace',
          destructive: true,
          onConfirm: () => AstryxToastScope.of(context).show(
            const AstryxToast(message: 'Workspace scheduled for deletion'),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(String title) {
    return AstryxCard(
      child: AstryxText(
        'The $title section would go here. It is one field of state and a '
        '`switch` expression away — which is exactly what makes a settings '
        'area with a rail no harder than one without.',
      ),
    );
  }
}

/// The bar above the settings area.
///
/// Its only job on a wide window is to say where you are. Its job on a narrow
/// one is to be the way back to the rail, which has moved into a drawer.
class _SettingsBar extends StatelessWidget {
  const _SettingsBar({required this.title});

  /// The open section, so the bar still says where you are once the rail is
  /// behind a button and the selected row is out of sight.
  final String title;

  @override
  Widget build(BuildContext context) {
    // The shell knows where the navigation went. A header cannot decide
    // whether to draw a menu button without that, which is why it asks rather
    // than measuring the window a second time.
    final shell = AstryxAppShell.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: AstryxHStack(
        gap: AstryxSpacingToken.spacing2,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (shell.compact)
            const AstryxMobileNavToggle(
              label: 'Open the settings sections',
              size: AstryxButtonSize.sm,
            ),
          const AstryxText('Settings', type: AstryxTextType.label),
          if (shell.compact) ...<Widget>[
            const AstryxText('/', color: AstryxTextColor.secondary),
            Flexible(
              child: AstryxText(
                title,
                color: AstryxTextColor.secondary,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// #end
