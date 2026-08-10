---
title: AstryxSwitch
description: A setting that takes effect the moment it is flipped.
component: true
group: Forms
source: lib/src/components/forms/switch.dart
upstream: Switch
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class SwitchDemoExample extends StatefulWidget {
  const SwitchDemoExample({super.key});

  @override
  State<SwitchDemoExample> createState() => _SwitchDemoExampleState();
}

class _SwitchDemoExampleState extends State<SwitchDemoExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return AstryxSwitch(
      label: 'Email notifications',
      description: 'Applies immediately.',
      value: _enabled,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
```


## Usage

```dart
AstryxSwitch(
  label: 'Email notifications',
  description: 'Applies immediately.',
  value: _enabled,
  onChanged: (value) => setState(() => _enabled = value),
)
```

> **Note**
>
> A switch means **applies now**. A checkbox means *will apply when you submit*. Putting a switch in a form with a Save button asks the user to guess which one you meant.

## In a settings list

`labelPosition: start` with `labelSpacing: spread` gives the settings row shape: label at the reading edge, control at the trailing one.

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


## Sizes

The thumb grows when the switch is on — upstream’s own behaviour, and what makes the on state legible without relying on the track colour alone.

```dart
class SwitchSizesExample extends StatelessWidget {
  const SwitchSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxSwitch(
            label: size.name,
            size: size,
            value: true,
            onChanged: (_) {},
          ),
      ],
    );
  }
}
```


## States

```dart
class SwitchStatesExample extends StatelessWidget {
  const SwitchStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing3,
      children: <Widget>[
        const AstryxSwitch(
          label: 'Managed by your admin',
          value: true,
          enabled: false,
        ),
        const AstryxSwitch(label: 'Saving', value: false, loading: true),
        AstryxSwitch(
          label: 'Read-only',
          value: true,
          readOnly: true,
          onChanged: (_) {},
        ),
        const AstryxSwitch(
          label: 'Beta features',
          value: false,
          status: AstryxFieldStatus.warning('These can change without notice'),
        ),
      ],
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Space` | Toggles it. |
| `→` | Turns it on. Mirrored under RTL. |
| `←` | Turns it off. Mirrored under RTL. |

### AstryxSwitch

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the accessible name. |
| `value` *(required)* | `bool` | — | Whether the switch is on. |
| `onChanged` | `ValueChanged<bool>?` | — | Called with the state a press would produce. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size. |
| `enabled` | `bool` | `true` | Whether the control accepts input. |
| `readOnly` | `bool` | `false` | Shown but not changeable. Does not dim. |
| `loading` | `bool` | `false` | Whether a change is in flight, which shows a spinner in the thumb. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `labelPosition` | `AstryxToggleLabelPosition` | `AstryxToggleLabelPosition.end` | Which side the label sits on. |
| `labelSpacing` | `AstryxToggleLabelSpacing` | `AstryxToggleLabelSpacing.hug` | Whether the row hugs its contents or spreads them. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


