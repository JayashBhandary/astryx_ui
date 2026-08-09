/// The floating panel every overlay paints on.
library;

import 'package:astryx_ui/src/foundation/overlay_positioner.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// How much of the arrow sticks out of the surface.
const double _arrowExtent = 12;

/// How far the arrow stays from a rounded corner.
const double _arrowCornerInset = 12;

/// The background, radius and shadow shared by popovers, menus and tooltips.
///
/// One widget so the three cannot drift apart. Upstream gets the same guarantee
/// from `usePopover`'s single `surface` style, which is applied automatically
/// unless a consumer opts out.
@internal
class AstryxOverlaySurface extends StatelessWidget {
  /// Creates an overlay surface.
  const AstryxOverlaySurface({
    required this.child,
    super.key,
    this.background,
    this.foreground,
    this.shadow = AstryxShadowToken.low,
    this.radius = AstryxRadiusToken.container,
    this.padding,
    this.showBorder = true,
    this.arrow,
    this.anchor,
    this.position,
  });

  /// The panel's content.
  final Widget child;

  /// The fill. Defaults to `--color-background-popover`.
  final AstryxColorToken? background;

  /// The default text colour. Defaults to `--color-text-primary`.
  final AstryxColorToken? foreground;

  /// The elevation token.
  final AstryxShadowToken shadow;

  /// The corner radius token.
  final AstryxRadiusToken radius;

  /// Inner padding. Null leaves the content flush, for a menu whose own rows
  /// carry the padding.
  final EdgeInsetsGeometry? padding;

  /// Whether to draw a hairline border.
  ///
  /// A shadow alone does not separate a panel from a busy surface behind it,
  /// and in dark mode it barely registers at all.
  final bool showBorder;

  /// Whether to draw a pointer at the anchor.
  final bool? arrow;

  /// The anchor rect, needed to aim the arrow.
  final Rect? anchor;

  /// The resolved position, needed to know which side the arrow is on.
  final AstryxOverlayPosition? position;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final fill = theme.color(background ?? AstryxColorToken.backgroundPopover);

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: theme.borderRadius(radius),
        border: showBorder
            ? Border.all(
                color: theme.color(AstryxColorToken.border),
                width: theme.borderWidth(),
              )
            : null,
        boxShadow: theme.boxShadows(shadow),
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );

    surface = DefaultTextStyle.merge(
      style: TextStyle(
        color: theme.color(foreground ?? AstryxColorToken.textPrimary),
      ),
      child: surface,
    );

    final position = this.position;
    final anchor = this.anchor;
    if (arrow != true || position == null || anchor == null) return surface;

    return CustomPaint(
      // Behind, not in front: the arrow is part of the panel's silhouette, and
      // painting it over the content would clip whatever sits at that edge.
      painter: _ArrowPainter(
        color: fill,
        borderColor: showBorder ? theme.color(AstryxColorToken.border) : null,
        borderWidth: theme.borderWidth(),
        side: position.side,
        offset: resolveAstryxOverlayArrowOffset(
          anchor: anchor,
          position: position,
          arrowExtent: _arrowExtent,
          cornerInset: _arrowCornerInset,
        ),
      ),
      child: surface,
    );
  }
}

/// A triangle on one edge of the surface, aimed at the anchor.
class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.side,
    required this.offset,
  });

  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final AstryxOverlaySide side;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    // The arrow points *away* from the surface, on the side facing the anchor —
    // an overlay below its trigger has its arrow on top.
    final base = switch (side) {
      AstryxOverlaySide.bottom => Offset(offset, 0),
      AstryxOverlaySide.top => Offset(offset, size.height),
      AstryxOverlaySide.right => Offset(0, offset),
      AstryxOverlaySide.left => Offset(size.width, offset),
    };

    final path = Path();
    switch (side) {
      case AstryxOverlaySide.bottom:
        path
          ..moveTo(base.dx, base.dy)
          ..lineTo(base.dx + _arrowExtent / 2, base.dy - _arrowExtent / 2)
          ..lineTo(base.dx + _arrowExtent, base.dy);
      case AstryxOverlaySide.top:
        path
          ..moveTo(base.dx, base.dy)
          ..lineTo(base.dx + _arrowExtent / 2, base.dy + _arrowExtent / 2)
          ..lineTo(base.dx + _arrowExtent, base.dy);
      case AstryxOverlaySide.right:
        path
          ..moveTo(base.dx, base.dy)
          ..lineTo(base.dx - _arrowExtent / 2, base.dy + _arrowExtent / 2)
          ..lineTo(base.dx, base.dy + _arrowExtent);
      case AstryxOverlaySide.left:
        path
          ..moveTo(base.dx, base.dy)
          ..lineTo(base.dx + _arrowExtent / 2, base.dy + _arrowExtent / 2)
          ..lineTo(base.dx, base.dy + _arrowExtent);
    }
    path.close();

    canvas.drawPath(path, Paint()..color = color);

    final borderColor = this.borderColor;
    if (borderColor == null) return;
    // Only the two outer edges are stroked. The third sits against the panel
    // and stroking it would draw a line across the arrow's own mouth.
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderColor != oldDelegate.borderColor ||
      borderWidth != oldDelegate.borderWidth ||
      side != oldDelegate.side ||
      offset != oldDelegate.offset;
}
