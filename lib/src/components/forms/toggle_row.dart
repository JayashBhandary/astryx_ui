/// The control-beside-label layout the three toggles share.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The two sizes a toggle control comes in.
///
/// Upstream calls them `sm` and `md` and hard-codes the pixel values rather
/// than deriving them from `--size-element-*`; a 20px checkbox is not a 28px
/// button. Those literals are carried over here for the same reason.
enum AstryxToggleSize {
  /// The compact size: a 20px control.
  sm,

  /// The default: a 24px control.
  md,
}

/// Where the label sits relative to the control.
enum AstryxToggleLabelPosition {
  /// Label after the control. The default for checkboxes and radios.
  end,

  /// Label before the control. Upstream's default for a switch in a
  /// settings list, where the switch belongs at the trailing edge.
  start,
}

/// How the space between label and control is distributed.
enum AstryxToggleLabelSpacing {
  /// The row is only as wide as its contents.
  hug,

  /// The row fills its parent and pushes the label and control apart.
  spread,
}

/// Lays out a toggle control with its label and description.
///
/// The whole row is the hit target and the whole row is one semantics node —
/// a checkbox whose label is not clickable is a checkbox that fails every
/// usability test, and one whose label is a separate semantics node is read
/// twice.
@internal
class AstryxToggleRow extends StatelessWidget {
  /// Creates a toggle row.
  const AstryxToggleRow({
    required this.control,
    required this.label,
    required this.size,
    super.key,
    this.description,
    this.labelHidden = false,
    this.enabled = true,
    this.labelPosition = AstryxToggleLabelPosition.end,
    this.labelSpacing = AstryxToggleLabelSpacing.hug,
    this.onTap,
  });

  /// The checkbox, radio or switch itself.
  final Widget control;

  /// The visible text, and the control's accessible name.
  final String label;

  /// The control size, which also sets the row's minimum height.
  final AstryxToggleSize size;

  /// Helper text below the label.
  final String? description;

  /// Whether to hide the label visually while keeping it as the name.
  final bool labelHidden;

  /// Whether the control accepts input.
  final bool enabled;

  /// Which side the label sits on.
  final AstryxToggleLabelPosition labelPosition;

  /// Whether the row hugs its contents or spreads them.
  final AstryxToggleLabelSpacing labelSpacing;

  /// Called when any part of the row is activated.
  final VoidCallback? onTap;

  /// The control's edge length in logical pixels.
  static double extent(AstryxToggleSize size) =>
      size == AstryxToggleSize.sm ? 20 : 24;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final labelBlock = labelHidden
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AstryxText(
                label,
                type: AstryxTextType.label,
                color: enabled
                    ? AstryxTextColor.primary
                    : AstryxTextColor.disabled,
              ),
              if (description != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: theme.spacing(AstryxSpacingToken.spacing0_5),
                  ),
                  child: AstryxText(
                    description!,
                    type: AstryxTextType.supporting,
                    color: enabled
                        ? AstryxTextColor.secondary
                        : AstryxTextColor.disabled,
                  ),
                ),
            ],
          );

    // A spread row gives the label the slack; a hugging row lets it wrap only
    // if the parent is narrower than the text.
    final labelWidget = labelBlock == null
        ? null
        : (labelSpacing == AstryxToggleLabelSpacing.spread
              ? Expanded(child: labelBlock)
              : Flexible(child: labelBlock));

    final children = <Widget>[
      if (labelPosition == AstryxToggleLabelPosition.start) ...<Widget>[
        ?labelWidget,
        if (labelWidget != null)
          SizedBox(width: theme.spacing(AstryxSpacingToken.spacing2)),
      ],
      control,
      if (labelPosition == AstryxToggleLabelPosition.end) ...<Widget>[
        if (labelWidget != null)
          SizedBox(width: theme.spacing(AstryxSpacingToken.spacing2)),
        ?labelWidget,
      ],
    ];

    Widget row = Row(
      mainAxisSize: labelSpacing == AstryxToggleLabelSpacing.spread
          ? MainAxisSize.max
          : MainAxisSize.min,
      children: children,
    );

    row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: extent(size)),
      child: row,
    );

    if (onTap != null && enabled) {
      row = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          // The label is part of the target — upstream gets this from the
          // native `<label for>` association, which Flutter has no equivalent
          // of, so the row carries the gesture instead.
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: row,
        ),
      );
    }

    // Touch density floors the row's height. `expandHorizontally: false`
    // because a spread row is already full width and extra horizontal slop
    // would overlap whatever sits beside it.
    return AstryxTapTarget(expandHorizontally: false, child: row);
  }
}

/// Tracks hover and focus for a toggle control.
///
/// Upstream expresses both through `stylex.when.ancestor` on a scoped marker,
/// which is a CSS mechanism with no Flutter counterpart; this is the same
/// behaviour expressed as state a widget can rebuild on.
@internal
mixin AstryxToggleStateMixin<T extends StatefulWidget> on State<T> {
  /// Whether a pointer is over the control's row.
  bool get hovered => _hovered;
  bool _hovered = false;

  /// Whether the control holds focus.
  bool get focused => _focused;
  bool _focused = false;

  /// Whether the focus ring should be drawn.
  ///
  /// Focus alone is not enough: a control focused by a click gets no ring, per
  /// the `:focus-visible` port in Phase 4.
  bool focusVisible(BuildContext context) =>
      _focused && AstryxFocusVisible.of(context);

  /// Whether hover styling applies, which touch density never enables.
  bool hoverApplies(BuildContext context) =>
      _hovered && AstryxTheme.densityOf(context).supportsHover;

  /// Wraps [child] so that hovering it updates [hovered].
  Widget withHover(Widget child) => MouseRegion(
    onEnter: (_) => _setHovered(true),
    onExit: (_) => _setHovered(false),
    child: child,
  );

  /// Records a focus change.
  ///
  /// A closure rather than a method so it can be handed straight to
  /// `Focus.onFocusChange` — a `bool` method parameter would have to be named,
  /// and a named parameter is not a [ValueChanged].
  ValueChanged<bool> get handleFocusChange => (value) {
    if (!mounted || _focused == value) return;
    setState(() => _focused = value);
  };

  void _setHovered(bool value) {
    if (!mounted || _hovered == value) return;
    setState(() => _hovered = value);
  }
}
