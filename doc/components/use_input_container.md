---
title: useInputContainer → the field
description: Sharing focus, hover and validation state between a field and its affixes.
component: true
group: Hooks & controllers
source: lib/src/components/forms/input_container.dart
upstream: useInputContainer
---

<!-- GENERATED FILE — DO NOT EDIT.
     Source: example/lib/docs/pages/
     Regenerate: cd example && dart run tool/gen_docs_md.dart
-->

Upstream needs a hook because a text field, its icon, its clear button and its unit suffix are separate elements that must agree about one state: focused, hovered, invalid, disabled. Here that agreement is a widget — `AstryxInputContainer` — and it is **internal on purpose**.

> **Note**
>
> It is not exported. Three controls drifting apart on border colour and focus ring is exactly how a design system stops looking like one, so the container is shared between the text inputs and the selector and is not offered as a building block. What is public is everything you would reach for it *through*.

| To… | Use |
| --- | --- |
| put an icon, a unit or a button inside a field | `leading` and `trailing` on `AstryxTextInput` — the slots the container lays out |
| join several controls into one bordered row | [AstryxInputGroup](input_group.md), with `AstryxInputGroupText` for the affixes |
| give your own control a label, a description and validation | [AstryxField](field.md), which publishes them through `AstryxFieldScope` |
| read that state in your own control | `AstryxFieldScope.maybeOf(context)` — the label, the status and whether the field is enabled |

```dart
class FieldScopeExample extends StatelessWidget {
  const FieldScopeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Controls that *do* have their own label read the scope instead of
    // repeating it: `enabled` and `status` cascade down from the field.
    return SizedBox(
      width: 320,
      child: AstryxField(
        label: 'Region',
        description: 'Both controls inherit the field being disabled.',
        enabled: false,
        child: AstryxVStack(
          gap: AstryxSpacingToken.spacing2,
          align: AstryxStackAlign.stretch,
          children: <Widget>[
            const AstryxTextInput(label: 'Region', labelHidden: true),
            AstryxCheckbox(
              label: 'Replicate to a second region',
              value: false,
            ),
          ],
        ),
      ),
    );
  }
}
```


## What the container guarantees

- **A press anywhere focuses the control.** A user who clicks the padding of a text field expects a caret, not nothing — upstream’s `useInputContainer` does the same.
- **The affixes stay announced.** Only the editable is excluded from semantics, not the whole box: excluding the container once took the `leading` and `trailing` slots with it, so a clear button announced as nothing at all while staying perfectly clickable.
- **One border, one status.** Focus doubles the border rather than adding a ring outside it, and a status colours the whole box — including affixes that did not cause it.

> **Accessibility**
>
> Flutter has no `<label for>`, so a label rendered merely *next to* a control is invisible to a screen reader. `AstryxField` publishes its label, description and status through a scope and each input folds them into the semantics node it already owns — which is the entire reason that widget exists.

## Related

- [AstryxField](field.md) — the label and validation wrapper.
- [AstryxInputGroup](input_group.md) — adjacent controls as one box.
- [AstryxTextInput](text_input.md) — the field the container was built for.

---

Something wrong with `useInputContainer → the field`, or missing from it? [Report a bug](https://github.com/JayashBhandary/astryx_ui/issues/new?template=bug_report.yml&title=%5Bbug%5D+useInputContainer+%E2%86%92+the+field&component=useInputContainer+%E2%86%92+the+field) · [Request a change](https://github.com/JayashBhandary/astryx_ui/issues/new?template=feature_request.yml&title=%5Bfeature%5D+useInputContainer+%E2%86%92+the+field&area=useInputContainer+%E2%86%92+the+field) — both templates arrive with the component filled in.
