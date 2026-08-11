# Patterns

<!-- GENERATED FILE — DO NOT EDIT.
     Curated half:  example/tool/gen_skill.dart
     Generated half: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_skill.dart
-->

Each of these is lifted from a widget that compiles and renders in `example/lib/examples/`. Copy the shape, not just the call.

## A form in a card

Header, body, footer. The footer stretches its buttons because the stack asks for `AstryxStackAlign.stretch`.

```dart
class CardDemoExample extends StatefulWidget {
  const CardDemoExample({super.key});

  @override
  State<CardDemoExample> createState() => _CardDemoExampleState();
}

class _CardDemoExampleState extends State<CardDemoExample> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AstryxCard(
      maxWidth: 380,
      header: AstryxHStack(
        justify: AstryxStackJustify.between,
        align: AstryxStackAlign.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Flexible(
            child: AstryxVStack(
              gap: AstryxSpacingToken.spacing1,
              children: <Widget>[
                AstryxHeading('Login to your account', level: 4),
                AstryxText(
                  'Enter your email below to login.',
                  type: AstryxTextType.supporting,
                  color: AstryxTextColor.secondary,
                ),
              ],
            ),
          ),
          AstryxButton(
            label: 'Sign up',
            variant: AstryxButtonVariant.ghost,
            size: AstryxButtonSize.sm,
            onPressed: () {},
          ),
        ],
      ),
      footer: AstryxVStack(
        gap: AstryxSpacingToken.spacing2,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxButton(
            label: 'Login',
            variant: AstryxButtonVariant.primary,
            onPressed: () {},
          ),
          AstryxButton(label: 'Login with SSO', onPressed: () {}),
        ],
      ),
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          AstryxTextInput(
            label: 'Password',
            controller: _password,
            required: true,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
```

## Validation that is announced, not just coloured

An `AstryxFieldStatus` draws the ring, shows the icon and prints the message. Validate on blur or submit in a real form.

```dart
class TextInputValidationExample extends StatefulWidget {
  const TextInputValidationExample({super.key});

  @override
  State<TextInputValidationExample> createState() =>
      _TextInputValidationExampleState();
}

class _TextInputValidationExampleState
    extends State<TextInputValidationExample> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  /// Validate on change here so the example reacts as you type. In a real form,
  /// validating on blur or on submit is usually kinder.
  AstryxFieldStatus? get _status {
    final value = _email.text.trim();
    if (value.isEmpty) return null;
    return value.contains('@')
        ? const AstryxFieldStatus.success('That looks right')
        : const AstryxFieldStatus.error('Enter a valid email address');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            status: _status,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const AstryxTextInput(
            label: 'Subdomain',
            optional: true,
            status: AstryxFieldStatus.warning('This name is nearly taken'),
          ),
        ],
      ),
    );
  }
}
```

## A settings list

Label at the reading edge, control at the trailing one: `labelPosition: start` plus `labelSpacing: spread`.

```dart
class SwitchSettingsListExample extends StatefulWidget {
  const SwitchSettingsListExample({super.key});

  @override
  State<SwitchSettingsListExample> createState() =>
      _SwitchSettingsListExampleState();
}

class _SwitchSettingsListExampleState extends State<SwitchSettingsListExample> {
  final Set<String> _on = <String>{'digest'};

  @override
  Widget build(BuildContext context) {
    // The settings-list shape: label at the reading edge, switch at the
    // trailing one, the row spread between them.
    return AstryxCard(
      maxWidth: 380,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final setting in const <List<String>>[
            <String>['digest', 'Weekly digest', 'Every Monday, 9am'],
            <String>['mentions', 'Mentions', 'When someone @s you'],
            <String>['deploys', 'Deploy failures', 'Errors only'],
          ])
            AstryxSwitch(
              label: setting[1],
              description: setting[2],
              value: _on.contains(setting[0]),
              labelPosition: AstryxToggleLabelPosition.start,
              labelSpacing: AstryxToggleLabelSpacing.spread,
              onChanged: (value) => setState(() {
                if (value) {
                  _on.add(setting[0]);
                } else {
                  _on.remove(setting[0]);
                }
              }),
            ),
        ],
      ),
    );
  }
}
```

## A destructive flow

The dialog is a widget in the tree. Note the controller is disposed with the state.

```dart
class DialogDemoExample extends StatefulWidget {
  const DialogDemoExample({super.key});

  @override
  State<DialogDemoExample> createState() => _DialogDemoExampleState();
}

class _DialogDemoExampleState extends State<DialogDemoExample> {
  final AstryxDialogController _controller = AstryxDialogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The dialog is a widget in the tree, not a `showDialog` call. It renders
    // nothing until its controller opens it — so it can sit next to whatever
    // opens it, and the state that drives it stays yours.
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete project',
          variant: AstryxButtonVariant.destructive,
          onPressed: _controller.show,
        ),
        AstryxDialog(
          controller: _controller,
          title: 'Delete project',
          description: 'This cannot be undone.',
          footer: AstryxHStack(
            gap: AstryxSpacingToken.spacing2,
            justify: AstryxStackJustify.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AstryxButton(label: 'Cancel', onPressed: _controller.hide),
              AstryxButton(
                label: 'Delete',
                variant: AstryxButtonVariant.destructive,
                onPressed: _controller.hide,
              ),
            ],
          ),
          child: const AstryxText(
            'Everything in this project will be permanently removed, '
            'including its request history.',
          ),
        ),
      ],
    );
  }
}
```

## A table with sorting

Sorting state lives in the caller. Only columns with `compare` become buttons, and the cycle ends in unsorted.

```dart
class TableSortingExample extends StatefulWidget {
  const TableSortingExample({super.key});

  @override
  State<TableSortingExample> createState() => _TableSortingExampleState();
}

class _TableSortingExampleState extends State<TableSortingExample> {
  AstryxTableSort? _sort = const AstryxTableSort(
    'name',
    AstryxSortDirection.ascending,
  );

  @override
  Widget build(BuildContext context) {
    // A column is sortable when — and only when — it has a `compare`. Pressing
    // a header cycles ascending → descending → unsorted, because without that
    // third state a user cannot get back to the order the data arrived in.
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTable<Project>(
          label: 'Projects',
          rows: projects,
          keyOf: (row) => row.id,
          sort: _sort,
          onSortChanged: (sort) => setState(() => _sort = sort),
          columns: <AstryxTableColumn<Project>>[
            AstryxTableColumn<Project>(
              id: 'name',
              header: 'Project',
              compare: (a, b) => a.name.compareTo(b.name),
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
            AstryxTableColumn<Project>(
              id: 'owner',
              header: 'Owner',
              compare: (a, b) => a.owner.compareTo(b.owner),
              cellBuilder: (context, row) => AstryxText(row.owner),
            ),
            AstryxTableColumn<Project>(
              id: 'requests',
              header: 'Requests',
              width: const AstryxTableColumnWidth.fixed(120),
              alignment: AstryxTableAlignment.end,
              compare: (a, b) => a.requests.compareTo(b.requests),
              cellBuilder: (context, row) =>
                  AstryxText('${row.requests}', tabularNumbers: true),
            ),
          ],
        ),
        AstryxText(
          _sort == null
              ? 'Unsorted — the order the rows arrived in'
              : 'Sorted by ${_sort!.columnId}, ${_sort!.direction.name}',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

## A table with selection

The header checkbox governs the visible rows. `rowLabelOf` is what names each row's checkbox.

```dart
class TableSelectionExample extends StatefulWidget {
  const TableSelectionExample({super.key});

  @override
  State<TableSelectionExample> createState() => _TableSelectionExampleState();
}

class _TableSelectionExampleState extends State<TableSelectionExample> {
  Set<Object> _selected = <Object>{'p2'};

  @override
  Widget build(BuildContext context) {
    // The header checkbox governs the *visible* rows, and goes indeterminate
    // when only some are selected. `rowLabelOf` is what names each row's
    // checkbox — without it every one announces "Select row".
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxTable<Project>(
          label: 'Projects',
          rows: projects,
          keyOf: (row) => row.id,
          selectionMode: AstryxTableSelectionMode.multiple,
          selected: _selected,
          onSelectionChanged: (value) => setState(() => _selected = value),
          rowLabelOf: (row) => row.name,
          columns: <AstryxTableColumn<Project>>[
            AstryxTableColumn<Project>(
              id: 'name',
              header: 'Project',
              cellBuilder: (context, row) => AstryxText(row.name),
            ),
            AstryxTableColumn<Project>(
              id: 'health',
              header: 'Health',
              width: const AstryxTableColumnWidth.intrinsic(min: 96),
              cellBuilder: (context, row) =>
                  AstryxBadge(row.health, variant: variantFor(row.health)),
            ),
          ],
        ),
        AstryxText(
          '${_selected.length} selected',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

## A table with row actions

Always visible, never hover-only.

```dart
class TableRowActionsExample extends StatelessWidget {
  const TableRowActionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Row actions are **always visible**, never hover-only: hover does not
    // exist on touch, and an action nobody can reach is not an action.
    return AstryxTable<Project>(
      label: 'Projects',
      rows: projects,
      keyOf: (row) => row.id,
      striped: true,
      maxHeight: 260,
      rowActionsBuilder: (context, row) => AstryxDropdownMenu(
        width: 180,
        entries: <AstryxMenuEntry>[
          AstryxMenuItem(label: 'Open ${row.name}', onSelected: () {}),
          const AstryxMenuDivider(),
          AstryxMenuItem(label: 'Delete', destructive: true, onSelected: () {}),
        ],
        triggerBuilder: (context, controller) => AstryxIconButton(
          icon: AstryxIconName.moreHorizontal,
          label: 'Actions for ${row.name}',
          variant: AstryxButtonVariant.ghost,
          size: AstryxButtonSize.sm,
          onPressed: controller.toggle,
        ),
      ),
      columns: <AstryxTableColumn<Project>>[
        AstryxTableColumn<Project>(
          id: 'name',
          header: 'Project',
          cellBuilder: (context, row) => AstryxText(row.name),
        ),
        AstryxTableColumn<Project>(
          id: 'owner',
          header: 'Owner',
          headerTooltip: 'Who gets paged first',
          cellBuilder: (context, row) => AstryxText(row.owner),
        ),
      ],
    );
  }
}
```

## An undoable action

Hover and focus pause the timeout, so the Undo button cannot vanish mid-reach.

```dart
class ToastActionExample extends StatefulWidget {
  const ToastActionExample({super.key});

  @override
  State<ToastActionExample> createState() => _ToastActionExampleState();
}

class _ToastActionExampleState extends State<ToastActionExample> {
  bool _deleted = false;

  @override
  Widget build(BuildContext context) {
    return AstryxHStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        AstryxButton(
          label: 'Delete row',
          onPressed: () {
            setState(() => _deleted = true);
            AstryxToastScope.of(context).show(
              AstryxToast(
                message: 'Row deleted',
                action: AstryxButton(
                  label: 'Undo',
                  variant: AstryxButtonVariant.ghost,
                  size: AstryxButtonSize.sm,
                  onPressed: () => setState(() => _deleted = false),
                ),
              ),
            );
          },
        ),
        AstryxText(
          _deleted ? 'Row is deleted' : 'Row is present',
          type: AstryxTextType.supporting,
          color: AstryxTextColor.secondary,
        ),
      ],
    );
  }
}
```

## A menu with sections and a destructive item

Sections and dividers are skipped by the keyboard.

```dart
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
```

## A responsive tile wall

No breakpoints: the column count falls out of the available width.

```dart
class GridResponsiveExample extends StatelessWidget {
  const GridResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    // No breakpoints. The column count falls out of the width available, the
    // way `repeat(auto-fit, minmax(180px, 1fr))` does upstream. Resize the
    // window to watch it re-flow.
    return const AstryxGrid(
      minWidth: 180,
      maxColumns: 4,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        _Metric('Requests', '4,201'),
        _Metric('Errors', '12'),
        _Metric('p95', '318 ms'),
        _Metric('Uptime', '99.98%'),
        _Metric('Projects', '7'),
      ],
    );
  }
}
```

## An empty state

What `AstryxList.empty` and `AstryxTable.emptyState` hold. Say why it is empty and offer the way out.

```dart
class EmptyStateDemoExample extends StatelessWidget {
  const EmptyStateDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxEmptyState(
      icon: const AstryxIcon(AstryxIconName.search),
      title: 'No deploys yet',
      description: 'Push to the main branch and the first one will show here.',
      actions: <Widget>[
        AstryxButton(
          label: 'Read the guide',
          variant: AstryxButtonVariant.primary,
          onPressed: () {},
        ),
        AstryxButton(label: 'Import a project', onPressed: () {}),
      ],
    );
  }
}
```

## A list of rows

The list carries the dividers, the density and the name; the rows carry nothing but themselves.

```dart
class ListDemoExample extends StatefulWidget {
  const ListDemoExample({super.key});

  @override
  State<ListDemoExample> createState() => _ListDemoExampleState();
}

class _ListDemoExampleState extends State<ListDemoExample> {
  String? _open;

  @override
  Widget build(BuildContext context) {
    return AstryxList(
      label: 'Recent deploys',
      showDividers: true,
      children: <Widget>[
        for (final deploy in const <List<String>>[
          <String>['api', '2 minutes ago', 'Live'],
          <String>['web', '1 hour ago', 'Live'],
          <String>['worker', 'yesterday', 'Rolled back'],
        ])
          AstryxItem(
            label: deploy[0],
            description: deploy[1],
            selected: _open == deploy[0],
            trailing: AstryxBadge(
              deploy[2],
              variant: deploy[2] == 'Live'
                  ? AstryxBadgeVariant.success
                  : AstryxBadgeVariant.neutral,
            ),
            onPressed: () => setState(() => _open = deploy[0]),
          ),
      ],
    );
  }
}
```

## A custom theme, and re-theming a subtree

A theme is a value. Nesting a provider re-themes everything below it.

```dart
class ThemingThemesExample extends StatelessWidget {
  const ThemingThemesExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Every theme is a value. Nesting a provider re-themes a subtree, which is
    // how a preview like this one can show all seven at once.
    return AstryxGrid(
      minWidth: 150,
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final theme in <(String, AstryxDefinedTheme)>[
          ('neutral', neutralTheme),
          ('matcha', matchaTheme),
          ('stone', stoneTheme),
          ('gothic', gothicTheme),
          ('chocolate', chocolateTheme),
          ('y2k', y2kTheme),
          ('butter', butterTheme),
          ('acme (custom)', acmeTheme),
        ])
          AstryxThemeProvider(
            theme: theme.$2,
            child: AstryxCard(
              padding: AstryxSpacingToken.spacing3,
              child: AstryxVStack(
                gap: AstryxSpacingToken.spacing2,
                align: AstryxStackAlign.stretch,
                children: <Widget>[
                  AstryxText(theme.$1, type: AstryxTextType.label),
                  AstryxButton(
                    label: 'Primary',
                    variant: AstryxButtonVariant.primary,
                    size: AstryxButtonSize.sm,
                    onPressed: () {},
                  ),
                  const AstryxHStack(
                    gap: AstryxSpacingToken.spacing1,
                    wrap: true,
                    runGap: AstryxSpacingToken.spacing1,
                    children: <Widget>[
                      AstryxBadge('A', variant: AstryxBadgeVariant.info),
                      AstryxBadge('B', variant: AstryxBadgeVariant.success),
                      AstryxBadge('C', variant: AstryxBadgeVariant.error),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```

