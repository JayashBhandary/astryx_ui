/// The segmented control the documentation chrome uses for its pickers.
///
/// Upstream ships `SegmentedControl`; this port does not, so the pattern is an
/// attached [AstryxButtonGroup] whose selected child takes the louder variant —
/// which is what `.claude/skills/astryx-ui` tells an agent to do too. It lives
/// here rather than in one of its callers because both the top bar and every
/// example card need it, and two copies would drift.
library;

import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';

/// A row of mutually exclusive choices, all labels visible.
///
/// The group holds no selection of its own: [selected] comes in and
/// [onSelected] goes out, which is what lets the same control drive a field on
/// a controller and a field on a `State`.
class DocsSegmented<T> extends StatelessWidget {
  /// Creates a segmented control.
  const DocsSegmented({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.label,
    this.iconOf,
    super.key,
  });

  /// The choices, in the order they are shown.
  final List<T> values;

  /// Which one is current.
  final T selected;

  /// The visible text for a choice, which is also its accessible name.
  final String Function(T value) labelOf;

  /// Called with the choice the user pressed.
  final ValueChanged<T> onSelected;

  /// What the group as a whole is choosing between.
  ///
  /// Announced as the name of the container the buttons sit in, so a screen
  /// reader says what "Mobile" is a choice *about*. Without it the top bar is
  /// eleven unrelated buttons. Null leaves the group unnamed.
  final String? label;

  /// A glyph for a choice, when the control should be icons rather than words.
  ///
  /// [labelOf] stays required and stays the accessible name — an icon-only
  /// button without one is announced as "button" and nothing more — and it
  /// becomes the tooltip, which is the sighted reader's version of the same
  /// fact. Null keeps the labels visible, which is right for anything whose
  /// choices have no conventional picture.
  final Widget Function(T value)? iconOf;

  @override
  Widget build(BuildContext context) {
    final iconOf = this.iconOf;

    // The selected segment differs by fill and by foreground colour, not by hue
    // alone, so the choice survives greyscale without a second signal.
    final group = AstryxButtonGroup(
      size: AstryxButtonSize.sm,
      children: <Widget>[
        for (final value in values)
          if (iconOf == null)
            AstryxButton(
              label: labelOf(value),
              variant: value == selected
                  ? AstryxButtonVariant.primary
                  : AstryxButtonVariant.secondary,
              onPressed: () => onSelected(value),
            )
          else
            AstryxIconButton.custom(
              label: labelOf(value),
              tooltip: labelOf(value),
              variant: value == selected
                  ? AstryxButtonVariant.primary
                  : AstryxButtonVariant.secondary,
              onPressed: () => onSelected(value),
              child: iconOf(value),
            ),
      ],
    );

    if (label == null) return group;
    return Semantics(container: true, label: label, child: group);
  }
}
