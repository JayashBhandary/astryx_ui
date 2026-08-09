/// Selection handles and the cut/copy/paste menu, without Material.
///
/// `EditableText` supplies neither. Flutter's ready-made answers —
/// `materialTextSelectionHandleControls` and `AdaptiveTextSelectionToolbar` —
/// both require a `MaterialLocalizations` ancestor and pull Material theming
/// into a package that ADR-002 says must not depend on it. So the handles and
/// the menu are built here, from Astryx tokens and [AstryxLocalizations].
library;

import 'dart:math' as math;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/motion.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The radius of the round part of a selection handle.
const double _handleRadius = 6;

/// Selection handles drawn from theme tokens.
///
/// One shape for every platform, coloured by `--color-accent`. Upstream is a
/// web design system and inherits whatever handles the browser draws; there is
/// no upstream shape to match, so the choice here is to look like Astryx rather
/// than to imitate a platform Astryx never ran on.
@internal
class AstryxTextSelectionControls extends TextSelectionControls {
  /// Creates selection controls painted from [color].
  AstryxTextSelectionControls({required this.color});

  /// The handle colour, normally `--color-accent`.
  final Color color;

  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_handleRadius * 2, _handleRadius * 2);

  /// Where the handle's own origin sits relative to the selection endpoint.
  ///
  /// The collapsed handle centres under the caret; the two range handles sit
  /// just inside their end of the selection, which is what makes a selection
  /// look "gripped" rather than bracketed.
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) =>
      switch (type) {
        TextSelectionHandleType.left => const Offset(
          _handleRadius * 2,
          _handleRadius,
        ),
        TextSelectionHandleType.right => const Offset(0, _handleRadius),
        TextSelectionHandleType.collapsed => const Offset(
          _handleRadius,
          _handleRadius,
        ),
      };

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    // The visual is one circle; only its rotation differs, so that the flat
    // quadrant faces the text on each side.
    final quarterTurns = switch (type) {
      TextSelectionHandleType.left => 3,
      TextSelectionHandleType.right => 0,
      TextSelectionHandleType.collapsed => 0,
    };

    return GestureDetector(
      onTap: onTap,
      // The handle's own hit box is 12px; a finger needs more, and this is a
      // drag target the user cannot see the edges of.
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: _handleRadius * 4,
        height: _handleRadius * 4,
        child: Center(
          child: RotatedBox(
            quarterTurns: quarterTurns,
            child: CustomPaint(
              size: const Size(_handleRadius * 2, _handleRadius * 2),
              painter: _HandlePainter(
                color: color,
                square: type != TextSelectionHandleType.collapsed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Unused: the toolbar comes from `contextMenuBuilder`, which is the modern
  /// hook. This override exists because the base class still demands it.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) => const SizedBox.shrink();
}

/// A circle with one square corner, so it reads as pointing at the text.
class _HandlePainter extends CustomPainter {
  const _HandlePainter({required this.color, required this.square});

  final Color color;
  final bool square;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final r = size.width / 2;
    if (!square) {
      canvas.drawCircle(Offset(r, r), r, paint);
      return;
    }
    canvas
      ..drawCircle(Offset(r, r), r, paint)
      ..drawRect(Rect.fromLTWH(r, 0, r, r), paint);
  }

  @override
  bool shouldRepaint(_HandlePainter oldDelegate) =>
      color != oldDelegate.color || square != oldDelegate.square;
}

/// The cut / copy / paste / select-all menu.
///
/// Built from the button items `EditableText` already computes, so the set of
/// entries stays correct — paste hidden when the clipboard is empty, "Look Up"
/// and "Search Web" on iOS — while the labels come from [AstryxLocalizations]
/// rather than `MaterialLocalizations`.
@internal
class AstryxTextSelectionToolbar extends StatelessWidget {
  /// Creates a selection toolbar.
  const AstryxTextSelectionToolbar({
    required this.anchorAbove,
    required this.anchorBelow,
    required this.items,
    super.key,
  });

  /// Builds the toolbar for [editableState].
  static Widget forEditableText(
    BuildContext context,
    EditableTextState editableState,
  ) {
    final items = editableState.contextMenuButtonItems;
    if (items.isEmpty) return const SizedBox.shrink();
    final anchors = editableState.contextMenuAnchors;
    return AstryxTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      items: items,
    );
  }

  /// Where the toolbar points when it sits above the selection.
  final Offset anchorAbove;

  /// Where it points when it sits below.
  final Offset anchorBelow;

  /// The actions to offer.
  final List<ContextMenuButtonItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);
    final padding = MediaQuery.paddingOf(context);

    // The framework's own delegate: it puts the toolbar above the selection
    // when there is room and below it otherwise, which is the behaviour users
    // already expect from every other text field on the device.
    return CustomSingleChildLayout(
      delegate: TextSelectionToolbarLayoutDelegate(
        anchorAbove: anchorAbove - Offset(0, padding.top),
        anchorBelow: anchorBelow - Offset(0, padding.top),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: math.max(padding.left, 8),
          right: math.max(padding.right, 8),
          top: padding.top,
          bottom: padding.bottom,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.color(AstryxColorToken.backgroundPopover),
            borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            border: Border.all(
              color: theme.color(AstryxColorToken.border),
              width: theme.borderWidth(),
            ),
            boxShadow: theme.boxShadows(AstryxShadowToken.med),
          ),
          child: ClipRRect(
            borderRadius: theme.borderRadius(AstryxRadiusToken.container),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final item in items)
                  _ToolbarButton(
                    label: item.label ?? _labelFor(item.type, l10n),
                    onPressed: item.onPressed,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _labelFor(
    ContextMenuButtonType type,
    AstryxLocalizations l10n,
  ) => switch (type) {
    ContextMenuButtonType.cut => l10n.textCut,
    ContextMenuButtonType.copy => l10n.textCopy,
    ContextMenuButtonType.paste => l10n.textPaste,
    ContextMenuButtonType.selectAll => l10n.textSelectAll,
    ContextMenuButtonType.delete => l10n.textDelete,
    ContextMenuButtonType.lookUp => l10n.textLookUp,
    ContextMenuButtonType.searchWeb => l10n.textSearchWeb,
    ContextMenuButtonType.share => l10n.textShare,
    ContextMenuButtonType.liveTextInput => l10n.textLiveTextInput,
    ContextMenuButtonType.custom => '',
  };
}

/// One entry in the selection toolbar.
///
/// Not an `AstryxButton`: the entries are flush cells in a strip, with no gap,
/// no radius of their own and a full-bleed hover — a shape the button API
/// deliberately does not offer.
class _ToolbarButton extends StatefulWidget {
  const _ToolbarButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final motion = AstryxMotion.of(context);

    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: motion.duration(AstryxDurationToken.fastMin),
            curve: motion.curve(),
            height: theme.size(AstryxSizeToken.elementMd),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing(AstryxSpacingToken.spacing3),
            ),
            alignment: Alignment.center,
            color: _hovered
                ? theme.color(AstryxColorToken.overlayHover)
                : const Color(0x00000000),
            child: ExcludeSemantics(
              child: AstryxText(widget.label, type: AstryxTextType.label),
            ),
          ),
        ),
      ),
    );
  }
}
