/// The row every list in this package is built from.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// How tightly a row is packed.
///
/// The same two names `AstryxCheckboxList` uses, because they mean the same
/// thing: a screen showing forty rows and a screen showing five want different
/// vertical rhythm, and nothing else about the row changes.
enum AstryxItemDensity {
  /// Tight rows, for a long list in a dense screen.
  compact(AstryxSpacingToken.spacing1),

  /// The default.
  balanced(AstryxSpacingToken.spacing2);

  const AstryxItemDensity(this.verticalPadding);

  /// The padding above and below a row's content.
  final AstryxSpacingToken verticalPadding;
}

/// The density and indent a list hands down to its rows.
///
/// Without this every row in a compact list would have to repeat
/// `density: AstryxItemDensity.compact`, and a list whose rows disagreed with
/// it would look like a rendering fault rather than a mistake in the call.
class AstryxItemScope extends InheritedWidget {
  /// Puts [density] in scope for the rows below.
  const AstryxItemScope({
    required this.density,
    required super.child,
    super.key,
  });

  /// The density rows take unless they say otherwise.
  final AstryxItemDensity density;

  /// The nearest scope, or null.
  static AstryxItemScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxItemScope>();

  @override
  bool updateShouldNotify(AstryxItemScope oldWidget) =>
      density != oldWidget.density;
}

/// A row: something at the start, a label, and something at the end.
///
/// The primitive `AstryxList` and `AstryxTreeList` are built from, and usable
/// on its own for a row that belongs to neither. A non-null [onPressed] makes
/// it a button — the same rule `AstryxCard` follows, for the same reason.
///
/// {@tool snippet}
/// ```dart
/// AstryxItem(
///   label: 'ada@example.com',
///   description: 'Owner',
///   leading: const AstryxIcon(AstryxIconName.user),
///   trailing: const AstryxBadge('Active'),
///   onPressed: _open,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxList`, which stacks these with dividers and one density.
///  * `AstryxMetadataList`, for label-and-value pairs rather than rows.
class AstryxItem extends StatefulWidget {
  /// Creates a row.
  const AstryxItem({
    required this.label,
    super.key,
    this.leading,
    this.description,
    this.trailing,
    this.onPressed,
    this.selected = false,
    this.enabled = true,
    this.density,
    this.maxLines = 1,
    this.labelHidden = false,
    this.semanticsLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// The visible text, and the row's accessible name.
  final String label;

  /// Content at the reading-start edge — an icon, an avatar, a checkbox.
  ///
  /// Size and colour come from the enclosing `IconTheme`, so an `AstryxIcon`
  /// with the default `AstryxIconColor.inherit` comes out looking right.
  final Widget? leading;

  /// Secondary text below the label.
  final String? description;

  /// Content at the reading-end edge — a badge, a count, a chevron.
  final Widget? trailing;

  /// Makes the whole row a button. Null leaves it inert.
  final VoidCallback? onPressed;

  /// Whether the row is the chosen one, which tints it.
  ///
  /// A *selection*, not a press state: it survives the pointer leaving.
  final bool selected;

  /// Whether the row accepts input.
  final bool enabled;

  /// Overrides the density inherited from the enclosing list.
  final AstryxItemDensity? density;

  /// How many lines the label and the description may each take.
  ///
  /// One by default: rows that wrap turn a scannable list into a wall. Pass
  /// null to let them wrap as far as they like.
  final int? maxLines;

  /// Whether the label is a name for a screen reader only.
  ///
  /// The row then shows [leading] and [trailing] alone — what a collapsed
  /// navigation rail is. **Never to skip a label**: the name is still required,
  /// still announced, and should still be reachable by sight, which is what
  /// `AstryxTooltip` is for.
  final bool labelHidden;

  /// Overrides what a screen reader announces instead of [label].
  final String? semanticsLabel;

  /// The focus node, if the caller owns one. Only used when pressable.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxItem> createState() => _AstryxItemState();
}

class _AstryxItemState extends State<AstryxItem> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  /// Whether the row is a control at all.
  ///
  /// Not the same as [_interactive]: a disabled row is still a button, and has
  /// to announce itself as one — a control that vanishes from the semantics
  /// tree when it is disabled tells a screen-reader user the option does not
  /// exist rather than that it is unavailable.
  bool get _pressable => widget.onPressed != null;

  bool get _interactive => widget.enabled && _pressable;

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !_interactive) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter && key != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    widget.onPressed!.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final density =
        widget.density ??
        AstryxItemScope.maybeOf(context)?.density ??
        AstryxItemDensity.balanced;
    final hovered = _hovered && AstryxTheme.densityOf(context).supportsHover;

    Widget row = AstryxItemSurface(
      label: widget.label,
      leading: widget.leading,
      description: widget.description,
      trailing: widget.trailing,
      density: density,
      enabled: widget.enabled,
      selected: widget.selected,
      hovered: hovered && _interactive,
      pressed: _pressed && _interactive,
      maxLines: widget.maxLines,
      labelHidden: widget.labelHidden,
    );

    if (!_pressable) return row;

    row = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      child: row,
    );

    if (_interactive) {
      row = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(() => _pressed = true),
          onTapUp: (_) => _set(() => _pressed = false),
          onTapCancel: () => _set(() => _pressed = false),
          onTap: widget.onPressed,
          child: row,
        ),
      );
    }

    row = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.enabled,
      onFocusChange: (value) => _set(() => _focused = value),
      onKeyEvent: _handleKey,
      child: row,
    );

    return Semantics(
      container: true,
      button: true,
      // Absent rather than false on an unselectable row: a list of links has
      // nothing to say about selection, and "not selected" on every row is
      // noise. The same rule `AstryxButtonSurface` follows for `selected`.
      selected: widget.selected ? true : null,
      enabled: widget.enabled,
      label: widget.semanticsLabel ?? widget.label,
      hint: widget.description,
      onTap: _interactive ? widget.onPressed : null,
      child: ExcludeSemantics(
        // The row's text is already the name. A second node for the same words
        // is heard twice.
        child: AstryxTapTarget(expandHorizontally: false, child: row),
      ),
    );
  }
}

/// The visual row, without any behaviour.
///
/// `AstryxItem` adds the gesture, the focus and the semantics; `AstryxTreeList`
/// adds none of those, because a tree is one tab stop and its rows are moved
/// between with the arrow keys. Both draw the same row, which is the point.
@internal
class AstryxItemSurface extends StatelessWidget {
  /// Creates the visual row.
  const AstryxItemSurface({
    required this.label,
    required this.density,
    super.key,
    this.leading,
    this.description,
    this.trailing,
    this.enabled = true,
    this.selected = false,
    this.hovered = false,
    this.pressed = false,
    this.indent = 0,
    this.maxLines = 1,
    this.labelHidden = false,
  });

  /// The visible text.
  final String label;

  /// The row's vertical rhythm.
  final AstryxItemDensity density;

  /// Content at the reading-start edge.
  final Widget? leading;

  /// Secondary text below the label.
  final String? description;

  /// Content at the reading-end edge.
  final Widget? trailing;

  /// Whether the row is dimmed.
  final bool enabled;

  /// Whether the row is tinted as the chosen one.
  final bool selected;

  /// Whether to paint the hover background.
  final bool hovered;

  /// Whether to paint the pressed background.
  final bool pressed;

  /// Extra padding at the reading-start edge, for a nested row.
  final double indent;

  /// How many lines the label and description may each take.
  final int? maxLines;

  /// Whether to paint the label at all.
  final bool labelHidden;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);

    final Color background;
    if (pressed) {
      background = theme.color(AstryxColorToken.overlayPressed);
    } else if (selected) {
      background = theme.color(AstryxColorToken.accentMuted);
    } else if (hovered) {
      background = theme.color(AstryxColorToken.overlayHover);
    } else {
      background = const Color(0x00000000);
    }

    final gap = theme.spacing(AstryxSpacingToken.spacing2);

    return AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      padding: EdgeInsetsDirectional.only(
        start: theme.spacing(AstryxSpacingToken.spacing2) + indent,
        end: theme.spacing(AstryxSpacingToken.spacing2),
        top: theme.spacing(density.verticalPadding),
        bottom: theme.spacing(density.verticalPadding),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: theme.borderRadius(AstryxRadiusToken.inner),
      ),
      child: Row(
        spacing: gap,
        // A row with nothing but its icon hugs it, so a collapsed rail is a
        // column of icons rather than a column of mostly-empty rows.
        mainAxisSize: labelHidden ? MainAxisSize.min : MainAxisSize.max,
        children: <Widget>[
          if (leading != null)
            IconTheme.merge(
              data: IconThemeData(
                size: AstryxIconSize.sm.pixels,
                color: theme.color(
                  enabled
                      ? AstryxColorToken.iconSecondary
                      : AstryxColorToken.iconDisabled,
                ),
              ),
              child: leading!,
            ),
          if (!labelHidden)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AstryxText(
                    label,
                    type: AstryxTextType.label,
                    color: enabled
                        ? AstryxTextColor.primary
                        : AstryxTextColor.disabled,
                    maxLines: maxLines,
                  ),
                  if (description != null)
                    AstryxText(
                      description!,
                      type: AstryxTextType.supporting,
                      color: enabled
                          ? AstryxTextColor.secondary
                          : AstryxTextColor.disabled,
                      maxLines: maxLines,
                    ),
                ],
              ),
            ),
          ?trailing,
        ],
      ),
    );
  }
}
