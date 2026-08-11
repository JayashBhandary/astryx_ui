/// A card that carries selection state.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/forms/selection_indicator.dart';
import 'package:astryx_ui/src/components/forms/toggle_row.dart';
import 'package:astryx_ui/src/components/surface/block_width.dart';
import 'package:astryx_ui/src/components/surface/card.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/utils/color_mix.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Which control a [AstryxSelectableCard] shows, and therefore what the card
/// means.
///
/// The same distinction as `AstryxCheckbox` against `AstryxRadioList`, moved
/// onto a card: a checkbox card is one of several independent choices, a radio
/// card is one choice out of several.
enum AstryxSelectableCardControl {
  /// A checkbox. Any number of cards in the set may be selected.
  ///
  /// Pressing a selected card deselects it.
  checkbox,

  /// A radio. One card in the set is selected.
  ///
  /// Pressing a selected card reports nothing, as a native radio does — a
  /// choice out of several cannot be un-made by pressing it again.
  radio,
}

/// A card that is also a checkbox or a radio.
///
/// For a choice that needs more than a line of text — a plan with a price, a
/// region with a latency, an integration with a logo. Below that, the choice
/// belongs in an `AstryxRadioList` or an `AstryxCheckboxList`, which are
/// cheaper to scan and cheaper to operate.
///
/// The whole card is the target: pressing anywhere in it, or Space and Enter
/// while it holds focus, reports through [onSelectedChanged]. Selection shows
/// three ways at once — the control fills, the border takes the accent, and the
/// surface takes `--color-accent-muted` — because a card is large enough that a
/// user scanning for the selected one should not have to hunt for a small tick.
///
/// {@tool snippet}
/// ```dart
/// AstryxSelectableCard(
///   label: 'Pro plan',
///   control: AstryxSelectableCardControl.radio,
///   selected: _plan == Plan.pro,
///   onSelectedChanged: (_) => setState(() => _plan = Plan.pro),
///   child: const AstryxVStack(
///     gap: AstryxSpacingToken.spacing1,
///     children: <Widget>[
///       AstryxText('Pro', type: AstryxTextType.large),
///       AstryxText('\$20 per month', type: AstryxTextType.supporting),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AstryxCard], for a surface that groups content, pressable or not. A
///    pressable card *does* something; a selectable card *records* something.
///  * `AstryxRadioList` and `AstryxCheckboxList`, for the same choices as rows.
class AstryxSelectableCard extends StatefulWidget {
  /// Creates a selectable card.
  const AstryxSelectableCard({
    required this.child,
    required this.label,
    required this.selected,
    super.key,
    this.onSelectedChanged,
    this.control = AstryxSelectableCardControl.checkbox,
    this.controlSize = AstryxToggleSize.md,
    this.variant = AstryxCardVariant.standard,
    this.elevation = AstryxElevation.none,
    this.padding = AstryxSpacingToken.spacing4,
    this.enabled = true,
    this.semanticsHint,
    this.width,
    this.maxWidth,
    this.minHeight,
    this.focusNode,
    this.autofocus = false,
  });

  /// The content beside the control.
  final Widget child;

  /// The card's accessible name.
  ///
  /// Required, unlike [AstryxCard.semanticsLabel], because a selectable card is
  /// always a control: without a name a screen reader announces the card's
  /// whole contents as the checkbox's label, which for a heading, a price and a
  /// badge is a sentence nobody can act on. The name is not painted — the
  /// card's own content is what a sighted user reads.
  final String label;

  /// Whether the card is selected.
  final bool selected;

  /// Called with the selection a press would produce.
  ///
  /// Null makes the card inert without dimming it — for a selection made
  /// elsewhere and only shown here. Use [enabled] for a choice that is
  /// genuinely unavailable.
  final ValueChanged<bool>? onSelectedChanged;

  /// Whether the card behaves as a checkbox or as a radio.
  final AstryxSelectableCardControl control;

  /// The size of the control, not of the card.
  ///
  /// [AstryxToggleSize.sm] for a compact card, where a 24px box beside two
  /// lines of text is the largest thing in it.
  final AstryxToggleSize controlSize;

  /// The unselected fill. Selection overrides it.
  final AstryxCardVariant variant;

  /// The resting shadow.
  final AstryxElevation elevation;

  /// The inner padding, and the gap between the control and the content.
  final AstryxSpacingToken padding;

  /// Whether the card accepts input.
  final bool enabled;

  /// What a screen reader reads after the name — a price, a caveat, why the
  /// card is unavailable.
  final String? semanticsHint;

  /// A fixed width. Null sizes to the parent.
  final double? width;

  /// A ceiling on the width.
  final double? maxWidth;

  /// A floor under the height.
  final double? minHeight;

  /// The focus node, if the caller owns one.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  @override
  State<AstryxSelectableCard> createState() => _AstryxSelectableCardState();
}

class _AstryxSelectableCardState extends State<AstryxSelectableCard> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _interactive => widget.enabled && widget.onSelectedChanged != null;

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  void _toggle() {
    if (!_interactive) return;
    // A radio reports only the transition into selection. Pressing the chosen
    // card again is not a change, and reporting `false` would let a group end
    // up with nothing selected — which is the one state a radio group cannot
    // be put into by hand.
    if (widget.selected &&
        widget.control == AstryxSelectableCardControl.radio) {
      return;
    }
    widget.onSelectedChanged!(!widget.selected);
  }

  /// Space and Enter both activate, as they do on a pressable
  /// [AstryxCard] — the card is the control here, so the button's key map is
  /// the one a user will try, not the checkbox's Space-only one.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !_interactive) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter && key != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    _toggle();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);
    final density = AstryxTheme.densityOf(context);

    final pad = theme.spacing(widget.padding);
    final radius = theme.borderRadius(AstryxRadiusToken.container);
    final hovered = _hovered && density.supportsHover;

    // Upstream tints a selected row with `--color-accent-muted`, and not when
    // the control cannot be operated: a tint that survives that reads as an
    // affordance the card does not have. The same rule as `AstryxCheckboxList`,
    // and the control itself still fills, so a card the user cannot change is
    // still visibly the selected one.
    final showsSelection = widget.selected && _interactive;
    final baseToken = widget.variant.backgroundToken;
    var background = showsSelection
        ? theme.color(AstryxColorToken.accentMuted)
        : baseToken == null
        ? const Color(0x00000000)
        : theme.color(baseToken);

    // Hover and press tint the fill rather than swapping it, so a selected card
    // stays visibly selected while it is pressed.
    if (_interactive) {
      final tint = theme.color(AstryxColorToken.tintHover);
      if (_pressed) {
        background = astryxMixColors(background, tint, 12);
      } else if (hovered) {
        background = astryxMixColors(background, tint, 6);
      }
    }

    // The border follows the fill rather than the selection, so the two can
    // never disagree — an accent border around an untinted card reads as a
    // rendering fault, not as a state.
    final border = showsSelection
        ? theme.color(AstryxColorToken.accent)
        : theme.color(AstryxColorToken.border);

    final indicator = AstryxSelectionIndicator(
      shape: widget.control == AstryxSelectableCardControl.radio
          ? AstryxSelectionIndicatorShape.circle
          : AstryxSelectionIndicatorShape.square,
      filled: widget.selected,
      extent: AstryxToggleRow.extent(widget.controlSize),
      enabled: widget.enabled,
      // The whole card is one control, so hovering anywhere in it hovers the
      // box — the pointer never has to find the 24px square.
      hovered: hovered && _interactive,
      theme: theme,
      child: _mark(theme, motion),
    );

    // The control sits at the reading-start edge and the content takes the
    // rest, as every other toggle in the package lays out. Top-aligned, not
    // centred: a card two lines taller than its box would otherwise float the
    // box in the middle, away from the heading it belongs to.
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: pad,
      children: <Widget>[
        indicator,
        Expanded(child: widget.child),
      ],
    );

    content = Padding(padding: EdgeInsets.all(pad), child: content);
    // The `Expanded` above fills the card's width, so the card has to
    // shrink-wrap when the width it is handed is unbounded.
    content = AstryxBlockWidth(child: content);

    Widget card = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: Border.all(color: border, width: theme.borderWidth()),
        boxShadow: widget.elevation.token == null
            ? null
            : theme.boxShadows(widget.elevation.token!),
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (widget.width != null ||
        widget.maxWidth != null ||
        widget.minHeight != null) {
      card = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
          minHeight: widget.minHeight ?? 0,
        ),
        child: SizedBox(width: widget.width, child: card),
      );
    }

    card = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: radius,
      child: card,
    );

    if (_interactive) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(() => _pressed = true),
          onTapUp: (_) => _set(() => _pressed = false),
          onTapCancel: () => _set(() => _pressed = false),
          onTap: _toggle,
          child: card,
        ),
      );
    }

    card = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.enabled,
      onFocusChange: (value) => _set(() => _focused = value),
      onKeyEvent: _handleKey,
      child: card,
    );

    return Semantics(
      container: true,
      // The content keeps its own nodes: unlike a checkbox, whose label is the
      // whole of it, a card holds text a screen-reader user needs to read
      // *after* being told what the card is.
      explicitChildNodes: true,
      checked: widget.selected,
      inMutuallyExclusiveGroup:
          widget.control == AstryxSelectableCardControl.radio,
      enabled: widget.enabled,
      label: widget.label,
      hint: widget.semanticsHint,
      onTap: _interactive ? _toggle : null,
      child: AstryxTapTarget(expandHorizontally: false, child: card),
    );
  }

  /// The mark inside the control: a tick for a checkbox, a dot for a radio.
  Widget _mark(AstryxThemeData theme, AstryxMotion motion) {
    final onAccent = theme.color(AstryxColorToken.onAccent);
    final small = widget.controlSize == AstryxToggleSize.sm;

    if (widget.control == AstryxSelectableCardControl.checkbox) {
      return widget.selected
          ? AstryxCheckmark(extent: small ? 12 : 14, color: onAccent)
          : const SizedBox.shrink();
    }

    return AnimatedScale(
      scale: widget.selected ? 1 : 0,
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      child: Container(
        width: small ? 8 : 10,
        height: small ? 8 : 10,
        decoration: BoxDecoration(color: onAccent, shape: BoxShape.circle),
      ),
    );
  }
}
