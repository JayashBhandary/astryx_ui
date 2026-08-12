/// A full-screen media viewer.
library;

import 'package:astryx_ui/src/components/action/button_style.dart';
import 'package:astryx_ui/src/components/action/icon_button.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/media/media_theme.dart';
import 'package:astryx_ui/src/components/overlay/anchored_overlay.dart';
import 'package:astryx_ui/src/components/overlay/overlay_layer.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One item in an [AstryxLightbox].
@immutable
class AstryxLightboxItem {
  /// Describes an item.
  const AstryxLightboxItem({
    required this.label,
    required this.child,
    this.caption,
  });

  /// What it is. The accessible name, and never optional for the same reason an
  /// avatar's is not.
  final String label;

  /// The media itself — an `Image`, a chart, a diagram.
  final Widget child;

  /// A line under it.
  final String? caption;
}

/// A full-screen viewer, navigable between items.
///
/// Upstream's `Lightbox`. `AstryxOverlay` for the modal half — the scrim, the
/// focus trap, Escape, the entry animation — with the paging, the counter and
/// the caption on top.
///
/// {@tool snippet}
/// ```dart
/// AstryxLightbox(
///   controller: _lightbox,
///   items: <AstryxLightboxItem>[
///     for (final shot in shots)
///       AstryxLightboxItem(label: shot.name, child: Image.network(shot.url)),
///   ],
///   initialIndex: _tapped,
/// )
/// ```
/// {@end-tool}
///
/// A widget in the tree, like every overlay here: it renders nothing until the
/// controller opens it.
class AstryxLightbox extends StatefulWidget {
  /// Creates a lightbox.
  const AstryxLightbox({
    required this.controller,
    required this.items,
    super.key,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.label,
    this.actions = const <Widget>[],
  });

  /// Opens and closes the viewer.
  final AstryxOverlayController controller;

  /// The items, in order.
  final List<AstryxLightboxItem> items;

  /// Which item to open on.
  final int initialIndex;

  /// Called with the item now showing.
  final ValueChanged<int>? onIndexChanged;

  /// An accessible name for the viewer.
  final String? label;

  /// Controls in the top bar beside the close button — download, share, delete.
  final List<Widget> actions;

  @override
  State<AstryxLightbox> createState() => _AstryxLightboxState();
}

class _AstryxLightboxState extends State<AstryxLightbox> {
  late int _index = widget.initialIndex;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleOpenChange);
  }

  @override
  void didUpdateWidget(AstryxLightbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleOpenChange);
      widget.controller.addListener(_handleOpenChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleOpenChange);
    super.dispose();
  }

  void _handleOpenChange() {
    // Reopened on the item the caller asked for, not the one left showing last
    // time: a thumbnail grid opens the thumbnail that was pressed.
    if (!mounted || !widget.controller.isOpen) return;
    setState(() => _index = widget.initialIndex.clamp(
      0,
      widget.items.isEmpty ? 0 : widget.items.length - 1,
    ));
  }

  void _go(int delta) {
    final next = _index + delta;
    if (next < 0 || next >= widget.items.length) return;
    setState(() => _index = next);
    widget.onIndexChanged?.call(next);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowRight:
        _go(rtl ? -1 : 1);
      case LogicalKeyboardKey.arrowLeft:
        _go(rtl ? 1 : -1);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final l10n = AstryxLocalizations.of(context);

    if (widget.items.isEmpty) {
      return AstryxOverlay(
        controller: widget.controller,
        label: widget.label ?? l10n.lightboxLabel,
        child: const SizedBox.shrink(),
      );
    }

    final item = widget.items[_index.clamp(0, widget.items.length - 1)];
    final position = l10n.lightboxPosition(_index + 1, widget.items.length);
    final many = widget.items.length > 1;

    return AstryxOverlay(
      controller: widget.controller,
      label: widget.label ?? l10n.lightboxLabel,
      // A media viewer is the one overlay that should take the whole window,
      // because padding around a photograph is a smaller photograph.
      padding: EdgeInsets.zero,
      child: Focus(
        // Holds the focus the layer hands out, so the arrow keys reach this
        // handler: a key event walks up from whatever is focused, and the
        // trap's own scope node sits *above* here. Skipped by Tab, so the close
        // button is still the first stop.
        autofocus: true,
        skipTraversal: true,
        onKeyEvent: _handleKey,
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: item.label,
          value: many ? position : null,
          child: Column(
            children: <Widget>[
              AstryxMediaTheme(
                scrim: AstryxMediaScrim.top,
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing2,
                  justify: AstryxStackJustify.between,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (many)
                      AstryxText(
                        position,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.inherit,
                        tabularNumbers: true,
                      )
                    else
                      const SizedBox.shrink(),
                    AstryxHStack(
                      gap: AstryxSpacingToken.spacing1,
                      children: <Widget>[
                        ...widget.actions,
                        AstryxIconButton(
                          icon: AstryxIconName.close,
                          label: l10n.lightboxClose,
                          tooltip: l10n.lightboxClose,
                          variant: AstryxButtonVariant.ghost,
                          onPressed: widget.controller.hide,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing(AstryxSpacingToken.spacing4),
                  ),
                  child: Center(child: item.child),
                ),
              ),
              AstryxMediaTheme(
                child: AstryxHStack(
                  gap: AstryxSpacingToken.spacing3,
                  justify: AstryxStackJustify.between,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (many)
                      AstryxIconButton(
                        icon: AstryxIconName.chevronLeft,
                        label: l10n.lightboxPrevious,
                        tooltip: l10n.lightboxPrevious,
                        variant: AstryxButtonVariant.ghost,
                        enabled: _index > 0,
                        onPressed: () => _go(-1),
                      )
                    else
                      const SizedBox.shrink(),
                    Flexible(
                      child: AstryxText(
                        item.caption ?? item.label,
                        type: AstryxTextType.supporting,
                        color: AstryxTextColor.inherit,
                        justify: AstryxTextJustify.center,
                        maxLines: 2,
                      ),
                    ),
                    if (many)
                      AstryxIconButton(
                        icon: AstryxIconName.chevronRight,
                        label: l10n.lightboxNext,
                        tooltip: l10n.lightboxNext,
                        variant: AstryxButtonVariant.ghost,
                        enabled: _index < widget.items.length - 1,
                        onPressed: () => _go(1),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
