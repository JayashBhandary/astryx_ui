/// A bordered surface, optionally pressable.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/surface/palette.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/focus_visible.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/utils/color_mix.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A card's fill.
///
/// The three neutral options plus the nine categorical families, matching
/// upstream's thirteen `variantStyles` exactly.
@immutable
class AstryxCardVariant {
  const AstryxCardVariant._(this._token, this._palette);

  /// Creates a card filled with a categorical [palette].
  const AstryxCardVariant.palette(AstryxPalette palette)
    : _token = null,
      _palette = palette;

  /// `--color-background-card`. The default.
  static const AstryxCardVariant standard = AstryxCardVariant._(
    AstryxColorToken.backgroundCard,
    null,
  );

  /// No fill at all.
  ///
  /// For grouping without visual weight — a card that gives structure to a
  /// layout without claiming to be a distinct surface.
  static const AstryxCardVariant transparent = AstryxCardVariant._(null, null);

  /// `--color-background-muted`, for a de-emphasised card.
  static const AstryxCardVariant muted = AstryxCardVariant._(
    AstryxColorToken.backgroundMuted,
    null,
  );

  final AstryxColorToken? _token;
  final AstryxPalette? _palette;

  /// The fill token, or null for a transparent card.
  AstryxColorToken? get backgroundToken => _palette?.background ?? _token;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxCardVariant &&
          other._token == _token &&
          other._palette == _palette;

  @override
  int get hashCode => Object.hash(_token, _palette);
}

/// A bordered surface for grouping related content.
///
/// **Upstream ships two widgets — `Card` and `ClickableCard` — and this is
/// one.** In React the split earns its keep: the clickable version renders a
/// different element and needs different props. In Flutter a nullable
/// [onPressed] says the same thing with half the API, which is how every other
/// Flutter widget expresses the distinction (ADR-038).
///
/// With [onPressed] set the card gains hover and press states, a focus ring,
/// `Semantics(button: true)` and tap-target enforcement. Without it, it is
/// inert and contributes nothing to the semantics tree beyond its children.
///
/// {@tool snippet}
/// ```dart
/// AstryxCard(
///   header: const AstryxHeading('Usage'),
///   footer: AstryxButton(label: 'See details', onPressed: _open),
///   child: const AstryxText('4,201 requests this month.'),
/// )
/// ```
/// {@end-tool}
class AstryxCard extends StatefulWidget {
  /// Creates a card.
  const AstryxCard({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.variant = AstryxCardVariant.standard,
    this.elevation = AstryxElevation.none,
    this.padding = AstryxSpacingToken.spacing4,
    this.showBorder = true,
    this.onPressed,
    this.semanticsLabel,
    this.width,
    this.height,
    this.maxWidth,
    this.minHeight,
    this.focusNode,
    this.autofocus = false,
    this.scrollable = false,
  });

  /// The body.
  final Widget child;

  /// Content above the body, separated by the card's own padding.
  final Widget? header;

  /// Content below the body.
  final Widget? footer;

  /// The fill.
  final AstryxCardVariant variant;

  /// The resting shadow.
  final AstryxElevation elevation;

  /// The inner padding, as a spacing token.
  final AstryxSpacingToken padding;

  /// Whether to draw a hairline border.
  final bool showBorder;

  /// Makes the whole card a button.
  ///
  /// Null leaves it inert.
  final VoidCallback? onPressed;

  /// The card's accessible name when it is pressable.
  ///
  /// Without one a screen reader announces the card's entire contents as the
  /// button's name, which is rarely what anyone wants.
  final String? semanticsLabel;

  /// A fixed width. Null sizes to the parent.
  final double? width;

  /// A fixed height.
  final double? height;

  /// A ceiling on the width.
  final double? maxWidth;

  /// A floor under the height.
  final double? minHeight;

  /// The focus node, if the caller owns one. Only used when pressable.
  final FocusNode? focusNode;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Whether the body scrolls when it exceeds [height].
  ///
  /// Only meaningful with a fixed [height]; without one the card grows instead.
  final bool scrollable;

  @override
  State<AstryxCard> createState() => _AstryxCardState();
}

class _AstryxCardState extends State<AstryxCard> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _pressable => widget.onPressed != null;

  void _set(void Function() change) {
    if (!mounted) return;
    setState(change);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !_pressable) return KeyEventResult.ignored;
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
    final motion = AstryxMotion.of(context);
    final density = AstryxTheme.densityOf(context);

    final pad = theme.spacing(widget.padding);
    final radius = theme.borderRadius(AstryxRadiusToken.container);

    final baseToken = widget.variant.backgroundToken;
    var background = baseToken == null
        ? const Color(0x00000000)
        : theme.color(baseToken);

    // Hover and press tint the fill rather than swapping it, so a categorical
    // card keeps its family. A transparent card gets the overlay tokens
    // instead — there is nothing to tint.
    if (_pressable && baseToken == null) {
      if (_pressed) {
        background = theme.color(AstryxColorToken.overlayPressed);
      } else if (_hovered && density.supportsHover) {
        background = theme.color(AstryxColorToken.overlayHover);
      }
    } else if (_pressable) {
      final tint = theme.color(AstryxColorToken.tintHover);
      if (_pressed) {
        background = astryxMixColors(background, tint, 12);
      } else if (_hovered && density.supportsHover) {
        background = astryxMixColors(background, tint, 6);
      }
    }

    var body = widget.child;
    if (widget.scrollable) {
      body = SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: body,
      );
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: pad,
      children: <Widget>[
        ?widget.header,
        // `Flexible`, not `Expanded`: a card with no fixed height must still
        // shrink-wrap its body.
        if (widget.height != null || widget.scrollable)
          Flexible(child: body)
        else
          body,
        ?widget.footer,
      ],
    );

    content = Padding(padding: EdgeInsets.all(pad), child: content);

    // The `stretch` above hands the slots the card's full width, which is what
    // a block box does — and what asserts the moment the card is handed an
    // unbounded width, as a `Row` or a horizontal list does. Shrinking to the
    // content in exactly that case is CSS's own rule: a block box fills a
    // definite width and shrinks to fit an indefinite one.
    content = _CardWidth(child: content);

    Widget card = AnimatedContainer(
      duration: motion.duration(AstryxDurationToken.fast),
      curve: motion.curve(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: widget.showBorder
            ? Border.all(
                color: theme.color(AstryxColorToken.border),
                width: theme.borderWidth(),
              )
            : null,
        boxShadow: widget.elevation.token == null
            ? null
            : theme.boxShadows(widget.elevation.token!),
      ),
      // Clipped so a full-bleed image or a coloured header respects the
      // corner radius — upstream's `overflow: clip`.
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (widget.width != null ||
        widget.height != null ||
        widget.maxWidth != null ||
        widget.minHeight != null) {
      card = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
          minHeight: widget.minHeight ?? 0,
        ),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: card,
        ),
      );
    }

    if (!_pressable) return card;

    card = AstryxFocusRing(
      focused: _focused && AstryxFocusVisible.of(context),
      borderRadius: radius,
      child: card,
    );

    card = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _set(() => _hovered = true),
      onExit: (_) => _set(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(() => _pressed = true),
        onTapUp: (_) => _set(() => _pressed = false),
        onTapCancel: () => _set(() => _pressed = false),
        onTap: widget.onPressed,
        child: card,
      ),
    );

    card = Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) => _set(() => _focused = value),
      onKeyEvent: _handleKey,
      child: card,
    );

    return Semantics(
      container: true,
      button: true,
      label: widget.semanticsLabel,
      onTap: widget.onPressed,
      // Wrapping the tap target, never wrapped *by* it — `meetsGuideline`
      // measures the semantics node, so the order decides whether the check
      // sees the enlarged region (ADR-020).
      child: AstryxTapTarget(expandHorizontally: false, child: card),
    );
  }
}

/// Gives [child] the incoming width when there is one, and its own preferred
/// width when there is not.
///
/// This is not [IntrinsicWidth]. That keys on whether the width is *tight*, so
/// it also shrinks a card sitting in a merely loose parent — a `Center`, a
/// `ConstrainedBox` — where filling is the correct block-box behaviour and what
/// the card has always done. This keys on whether the width is *bounded*, so
/// only the genuinely unbounded case changes, and pays for an intrinsic pass
/// only in that case.
class _CardWidth extends SingleChildRenderObjectWidget {
  const _CardWidth({required Widget super.child});

  @override
  _RenderCardWidth createRenderObject(BuildContext context) =>
      _RenderCardWidth();
}

class _RenderCardWidth extends RenderProxyBox {
  BoxConstraints _innerConstraints(BoxConstraints constraints) {
    final child = this.child;
    if (child == null || constraints.hasBoundedWidth) return constraints;
    return constraints.tighten(
      width: child.getMaxIntrinsicWidth(constraints.maxHeight),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_innerConstraints(constraints), parentUsesSize: true);
    size = child.size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      child?.getDryLayout(_innerConstraints(constraints)) ??
      constraints.smallest;
}
