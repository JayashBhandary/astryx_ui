---
title: AstryxCheckbox
description: A two-state or three-state checkbox with a required label.
component: true
group: Forms
source: lib/src/components/forms/checkbox.dart
upstream: CheckboxInput
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

```dart
class CheckboxDemoExample extends StatefulWidget {
  const CheckboxDemoExample({super.key});

  @override
  State<CheckboxDemoExample> createState() => _CheckboxDemoExampleState();
}

class _CheckboxDemoExampleState extends State<CheckboxDemoExample> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AstryxCheckbox(
      label: 'Accept the terms of service',
      description: 'You can withdraw consent at any time.',
      value: _accepted,
      onChanged: (value) => setState(() => _accepted = value),
    );
  }
}
```


## Usage

```dart
AstryxCheckbox(
  label: 'Accept the terms of service',
  value: _accepted,
  onChanged: (value) => setState(() => _accepted = value),
)
```

> **Accessibility**
>
> `label` is required — unlike on most controls, and for the same reason upstream requires it: an unlabelled checkbox is unusable with a screen reader. Use `labelHidden` when the label would be redundant to a sighted user; the name survives.

## Indeterminate

`AstryxCheckbox.tristate` takes an `AstryxCheckboxValue` instead of a bool. Indeterminate is what a parent looks like when only some of its children are on; pressing it resolves to checked, matching both the HTML behaviour and the expectation that pressing a half-filled "select all" selects all.

```dart
class CheckboxTristateExample extends StatefulWidget {
  const CheckboxTristateExample({super.key});

  @override
  State<CheckboxTristateExample> createState() =>
      _CheckboxTristateExampleState();
}

class _CheckboxTristateExampleState extends State<CheckboxTristateExample> {
  static const List<String> _all = <String>['read', 'write', 'admin'];
  final Set<String> _scopes = <String>{'read'};

  /// Indeterminate is what a parent looks like when only some of its children
  /// are on — the case the tri-state constructor exists for.
  AstryxCheckboxValue get _parent => switch (_scopes.length) {
    0 => AstryxCheckboxValue.unchecked,
    3 => AstryxCheckboxValue.checked,
    _ => AstryxCheckboxValue.indeterminate,
  };

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCheckbox.tristate(
          label: 'All scopes',
          value: _parent,
          onChanged: (value) => setState(() {
            _scopes
              ..clear()
              ..addAll(
                value == AstryxCheckboxValue.checked ? _all : const <String>[],
              );
          }),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 28),
          child: AstryxVStack(
            gap: AstryxSpacingToken.spacing2,
            children: <Widget>[
              for (final scope in _all)
                AstryxCheckbox(
                  label: scope,
                  value: _scopes.contains(scope),
                  onChanged: (value) => setState(() {
                    if (value) {
                      _scopes.add(scope);
                    } else {
                      _scopes.remove(scope);
                    }
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
```


| Value | Box | Pressing it gives |
| --- | --- | --- |
| `unchecked` | empty | `checked` |
| `checked` | filled, tick | `unchecked` |
| `indeterminate` | filled, dash | `checked` |

## Sizes

```dart
class CheckboxSizesExample extends StatelessWidget {
  const CheckboxSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        for (final size in AstryxToggleSize.values)
          AstryxCheckbox(
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

A null `onChanged` makes the checkbox non-interactive **without dimming it** — for a box reflecting state the user changes elsewhere. `readOnly` says the same thing more loudly; `enabled: false` is the one that dims.

```dart
class CheckboxStatesExample extends StatelessWidget {
  const CheckboxStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      children: <Widget>[
        AstryxCheckbox(label: 'Disabled', value: true, enabled: false),
        // Read-only is not disabled: the value still means something, it is
        // just not yours to change here. So it is not dimmed.
        AstryxCheckbox(label: 'Read-only', value: true, readOnly: true),
        AstryxCheckbox(label: 'Saving', value: true, loading: true),
        AstryxCheckbox(
          label: 'With an error',
          value: false,
          status: const AstryxFieldStatus.error('This must be checked'),
          onChanged: (_) {},
        ),
        AstryxCheckbox(
          label: 'Label hidden — still announced',
          labelHidden: true,
          value: false,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
```


## Keyboard

| Key | Does |
| --- | --- |
| `Tab` | Moves focus to the checkbox. |
| `Space` | Toggles it, as on the native control. |
| `Enter` | Deliberately nothing — in a form, Enter submits, and a checkbox that swallows it breaks that. |

### AstryxCheckbox

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `label` *(required)* | `String` | — | The visible text, and the accessible name. Required. |
| `value` *(required)* | `bool / AstryxCheckboxValue` | — | The current state. A bool on the default constructor, an `AstryxCheckboxValue` on `.tristate`. |
| `onChanged` | `ValueChanged<bool>? / ValueChanged<AstryxCheckboxValue>?` | — | Called with the state a press would produce. Null is non-interactive but not dimmed. |
| `description` | `String?` | — | Helper text below the label. |
| `status` | `AstryxFieldStatus?` | — | The validation state. |
| `size` | `AstryxToggleSize` | `AstryxToggleSize.md` | The control size: `sm` is 20px, `md` 24px. |
| `enabled` | `bool` | `true` | Whether the control accepts interaction. |
| `readOnly` | `bool` | `false` | Shown but not changeable. Does not dim. |
| `loading` | `bool` | `false` | Whether a change is in flight, which shows a spinner in the box. |
| `labelHidden` | `bool` | `false` | Hides the label visually. |
| `focusNode` | `FocusNode?` | — | The focus node. |
| `autofocus` | `bool` | `false` | Whether to take focus when first built. |


## Related

- [AstryxSwitch](switch.md) — for a setting that applies immediately.
- [AstryxRadioList](radio_list.md) — for one choice out of several.

---

Something wrong with `AstryxCheckbox`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+AstryxCheckbox&component=AstryxCheckbox) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+AstryxCheckbox&area=AstryxCheckbox) — both templates arrive with the component filled in.
