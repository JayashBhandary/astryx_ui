/// Semantics wrappers that make the right annotation easy.
///
/// ARIA does not translate word for word; these encode the mapping from
/// `03-PORTING-GUIDE.md` §3.2 once, so 31 widgets do not each re-derive it.
///
/// The most common mistake the port can make is porting `VisuallyHidden` as a
/// widget. Upstream uses it for two different jobs, and only one of them has a
/// Flutter analogue — see [AstryxVisuallyHidden].
library;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

/// Annotates an interactive control as a button.
///
/// {@tool snippet}
/// ```dart
/// AstryxSemanticsButton(
///   label: 'Save changes',
///   enabled: true,
///   onPressed: _save,
///   child: const _ButtonSurface(),
/// )
/// ```
/// {@end-tool}
class AstryxSemanticsButton extends StatelessWidget {
  /// Creates button semantics.
  const AstryxSemanticsButton({
    required this.child,
    super.key,
    this.label,
    this.hint,
    this.enabled = true,
    this.focusable = true,
    this.focused = false,
    this.onPressed,
    this.excludeChildSemantics = false,
  });

  /// The widget being described.
  final Widget child;

  /// The accessible name.
  ///
  /// Omit when the child already renders the text — a visible label is read
  /// automatically, and setting both makes a screen reader say it twice.
  final String? label;

  /// Supplementary description, for what the label cannot carry.
  final String? hint;

  /// Whether the control can be activated.
  final bool enabled;

  /// Whether the control can take focus.
  final bool focusable;

  /// Whether the control currently holds focus.
  final bool focused;

  /// The action an assistive technology invokes.
  ///
  /// Wire this even where a `GestureDetector` handles taps: a screen reader
  /// activates through the semantics action, not by synthesising a tap.
  final VoidCallback? onPressed;

  /// Whether to hide the child's own semantics.
  ///
  /// Set true only when the child produces nodes that would confuse the
  /// reading — an icon-only button whose glyph carries no meaning.
  final bool excludeChildSemantics;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    label: label,
    hint: hint,
    enabled: enabled,
    focusable: focusable,
    focused: focused,
    onTap: enabled ? onPressed : null,
    excludeSemantics: excludeChildSemantics,
    child: child,
  );
}

/// Annotates a control with an on/off or tri-state value — checkbox, switch,
/// radio, or a toggle button.
class AstryxSemanticsToggle extends StatelessWidget {
  /// Creates toggle semantics.
  const AstryxSemanticsToggle({
    required this.child,
    super.key,
    this.label,
    this.hint,
    this.checked,
    this.selected,
    this.mixed = false,
    this.enabled = true,
    this.focused = false,
    this.isRadio = false,
    this.onToggle,
  });

  /// The widget being described.
  final Widget child;

  /// The accessible name.
  final String? label;

  /// Supplementary description.
  final String? hint;

  /// Whether the control is checked. Null for a control that is not checkable.
  final bool? checked;

  /// Whether the control is selected, for a tab or list item.
  final bool? selected;

  /// Whether the control is in its indeterminate state.
  ///
  /// A checkbox representing a partly-selected group. Takes precedence over
  /// [checked] in what is announced.
  final bool mixed;

  /// Whether the control can be changed.
  final bool enabled;

  /// Whether the control currently holds focus.
  final bool focused;

  /// Whether this is one of a set of mutually exclusive options.
  ///
  /// A radio announces differently from a checkbox, and the two are not
  /// interchangeable to someone navigating by role.
  final bool isRadio;

  /// The action an assistive technology invokes to change the value.
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    inMutuallyExclusiveGroup: isRadio ? true : null,
    checked: mixed ? null : checked,
    mixed: mixed ? true : null,
    selected: selected,
    label: label,
    hint: hint,
    enabled: enabled,
    focusable: true,
    focused: focused,
    onTap: enabled ? onToggle : null,
    child: child,
  );
}

/// Annotates a text entry control.
class AstryxSemanticsField extends StatelessWidget {
  /// Creates field semantics.
  const AstryxSemanticsField({
    required this.child,
    super.key,
    this.label,
    this.hint,
    this.value,
    this.enabled = true,
    this.focused = false,
    this.readOnly = false,
    this.obscured = false,
    this.multiline = false,
    this.errorText,
  });

  /// The widget being described.
  final Widget child;

  /// The field's label.
  final String? label;

  /// Supplementary description — helper text.
  final String? hint;

  /// The current value, for a reader to announce.
  final String? value;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether the field currently holds focus.
  final bool focused;

  /// Whether the value can be read but not changed.
  final bool readOnly;

  /// Whether the value is hidden, as for a password.
  final bool obscured;

  /// Whether the field accepts more than one line.
  final bool multiline;

  /// The validation error, if any.
  ///
  /// Announced through `validationResult`, so a reader reports the field as
  /// invalid *and* says why — a colour change alone conveys nothing.
  final String? errorText;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    textField: true,
    label: label,
    hint: hint,
    value: value,
    enabled: enabled,
    focusable: true,
    focused: focused,
    readOnly: readOnly,
    obscured: obscured,
    multiline: multiline,
    validationResult: errorText == null
        ? SemanticsValidationResult.none
        : SemanticsValidationResult.invalid,
    child: child,
  );
}

/// Content present for assistive technology but not painted.
///
/// **Read this before reaching for it.** Upstream's `VisuallyHidden` does two
/// jobs, and only one of them needs a widget here:
///
///  * *Naming something.* `<VisuallyHidden>Close</VisuallyHidden>` inside a
///    button exists only to give it an accessible name. **Do not port a
///    widget** — put the string in the parent's `Semantics.label`, which is
///    what [AstryxSemanticsButton.label] is for. This is the most common
///    false-friend in the whole port.
///  * *Announcing a change.* A live region reporting "3 characters remaining",
///    with no visual counterpart. That has no parent to name, so it needs this.
///
/// {@tool snippet}
/// ```dart
/// // A live announcement with nothing to attach it to.
/// AstryxVisuallyHidden(
///   liveRegion: true,
///   child: Text(l10n.charactersRemaining(remaining)),
/// )
/// ```
/// {@end-tool}
class AstryxVisuallyHidden extends StatelessWidget {
  /// Creates visually hidden content.
  const AstryxVisuallyHidden({
    required this.child,
    super.key,
    this.liveRegion = false,
  });

  /// The content to announce but not paint.
  final Widget child;

  /// Whether changes should be announced as they happen.
  final bool liveRegion;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    // Merged, so the content is announced as one string rather than as an
    // empty container wrapping a labelled child.
    child: Semantics(
      liveRegion: liveRegion,
      // Zero-size rather than `Offstage` or `Visibility`: both of those drop
      // the subtree from the semantics tree too, which defeats the purpose.
      child: SizedBox.shrink(child: _Invisible(child: child)),
    ),
  );
}

/// Paints nothing while keeping its child laid out and semantically present.
class _Invisible extends StatelessWidget {
  const _Invisible({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: 0,
    // Without this, `RenderOpacity` skips its child when the alpha is zero —
    // so the content would be invisible to a screen reader as well as to the
    // eye, which is the exact opposite of the point.
    alwaysIncludeSemantics: true,
    child: OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: child,
    ),
  );
}
