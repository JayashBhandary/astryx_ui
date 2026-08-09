import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `P9-1` — the overlay positioner, tested as a pure function.
///
/// Deliberately a table of rectangles rather than a rendered popover. Five
/// widgets in Phase 9 and two outside it depend on this geometry, and a bug
/// found through a painted overlay is far harder to diagnose than one found
/// here.
void main() {
  /// A 1000×800 screen, which is what every case below is measured against.
  const viewport = Rect.fromLTWH(0, 0, 1000, 800);

  /// A 100×40 anchor in the middle of it.
  const centreAnchor = Rect.fromLTWH(450, 380, 100, 40);

  const overlay = Size(200, 120);

  AstryxOverlayPosition place({
    Rect anchor = centreAnchor,
    Size size = overlay,
    Rect view = viewport,
    AstryxOverlaySide side = AstryxOverlaySide.bottom,
    AstryxOverlayAlign align = AstryxOverlayAlign.center,
    double gap = 8,
    double padding = 8,
    bool allowFlip = true,
    bool allowShift = true,
  }) => resolveAstryxOverlayPosition(
    anchor: anchor,
    overlaySize: size,
    viewport: view,
    preferredSide: side,
    align: align,
    gap: gap,
    padding: padding,
    allowFlip: allowFlip,
    allowShift: allowShift,
  );

  group('placement with room to spare', () {
    test('sits on the preferred side, gap away from the anchor', () {
      for (final side in AstryxOverlaySide.values) {
        final p = place(side: side);
        expect(p.side, side, reason: side.name);
        expect(p.flipped, isFalse, reason: side.name);
        expect(p.shift, 0, reason: side.name);
        expect(p.constrained, isFalse, reason: side.name);
      }

      expect(place().offset.dy, centreAnchor.bottom + 8);
      expect(
        place(side: AstryxOverlaySide.top).offset.dy,
        centreAnchor.top - 8 - overlay.height,
      );
      expect(
        place(side: AstryxOverlaySide.left).offset.dx,
        centreAnchor.left - 8 - overlay.width,
      );
      expect(
        place(side: AstryxOverlaySide.right).offset.dx,
        centreAnchor.right + 8,
      );
    });

    test('centres on the anchor by default', () {
      final p = place();
      expect(
        p.offset.dx + overlay.width / 2,
        closeTo(centreAnchor.center.dx, 1e-9),
      );
    });

    test('start and end align to the anchor edges', () {
      expect(
        place(align: AstryxOverlayAlign.start).offset.dx,
        centreAnchor.left,
      );
      expect(
        place(align: AstryxOverlayAlign.end).offset.dx,
        centreAnchor.right - overlay.width,
      );
    });

    test('a side overlay aligns on the vertical axis', () {
      expect(
        place(
          side: AstryxOverlaySide.right,
          align: AstryxOverlayAlign.start,
        ).offset.dy,
        centreAnchor.top,
      );
      expect(
        place(
          side: AstryxOverlaySide.right,
          align: AstryxOverlayAlign.end,
        ).offset.dy,
        centreAnchor.bottom - overlay.height,
      );
    });

    test('gap zero puts the overlay flush against the anchor', () {
      expect(place(gap: 0).offset.dy, centreAnchor.bottom);
    });
  });

  group('flip', () {
    test('flips when the preferred side has too little room', () {
      // An anchor near the bottom: `bottom` cannot fit 120px, `top` can.
      const anchor = Rect.fromLTWH(450, 720, 100, 40);
      final p = place(anchor: anchor);

      expect(p.side, AstryxOverlaySide.top);
      expect(p.flipped, isTrue);
      expect(p.offset.dy, anchor.top - 8 - overlay.height);
    });

    test('flips on the inline axis too', () {
      const anchor = Rect.fromLTWH(10, 380, 60, 40);
      final p = place(anchor: anchor, side: AstryxOverlaySide.left);

      expect(p.side, AstryxOverlaySide.right);
      expect(p.flipped, isTrue);
    });

    test('does not flip when the opposite side is no better', () {
      // Neither side fits, and both have exactly 39px: flipping would trade
      // one overflow for an identical one and make the overlay jump.
      const shortView = Rect.fromLTWH(0, 0, 1000, 150);
      const anchor = Rect.fromLTWH(450, 55, 100, 40);
      final p = place(anchor: anchor, view: shortView);

      expect(p.flipped, isFalse);
      expect(p.side, AstryxOverlaySide.bottom);
    });

    test('flips toward more room even when neither side fits', () {
      // With `constrain` in play a bigger-but-still-too-small space is a
      // genuine improvement: the overlay ends up taller.
      const shortView = Rect.fromLTWH(0, 0, 1000, 150);
      const anchor = Rect.fromLTWH(450, 80, 100, 40);
      final p = place(anchor: anchor, view: shortView);

      expect(p.flipped, isTrue);
      expect(p.side, AstryxOverlaySide.top);
      expect(p.constrained, isTrue);
    });

    test('honours allowFlip: false', () {
      const anchor = Rect.fromLTWH(450, 720, 100, 40);
      final p = place(anchor: anchor, allowFlip: false);

      expect(p.side, AstryxOverlaySide.bottom);
      expect(p.flipped, isFalse);
    });

    test('exactly enough room does not flip', () {
      // Room below is exactly 120: bottom edge at 800 - 8 padding = 792,
      // anchor bottom 664, gap 8 → 120 available.
      const anchor = Rect.fromLTWH(450, 624, 100, 40);
      final p = place(anchor: anchor);
      expect(p.flipped, isFalse, reason: 'a perfect fit is a fit');
    });
  });

  group('shift', () {
    test('slides back into view at the leading edge', () {
      const anchor = Rect.fromLTWH(0, 380, 40, 40);
      final p = place(anchor: anchor);

      // Centring would put it at -80; padding pins it to 8.
      expect(p.offset.dx, 8);
      expect(p.shift, greaterThan(0));
    });

    test('slides back into view at the trailing edge', () {
      const anchor = Rect.fromLTWH(960, 380, 40, 40);
      final p = place(anchor: anchor);

      expect(p.offset.dx, 1000 - 8 - overlay.width);
      expect(p.shift, lessThan(0));
    });

    test('records no shift when the overlay already fits', () {
      expect(place().shift, 0);
    });

    test('honours allowShift: false', () {
      const anchor = Rect.fromLTWH(0, 380, 40, 40);
      final p = place(anchor: anchor, allowShift: false);

      expect(p.shift, 0);
      expect(p.offset.dx, lessThan(0), reason: 'left to overflow, as asked');
    });

    test('shifts on the vertical axis for a side overlay', () {
      const anchor = Rect.fromLTWH(450, 0, 100, 40);
      final p = place(anchor: anchor, side: AstryxOverlaySide.right);

      expect(p.offset.dy, 8);
      expect(p.shift, greaterThan(0));
    });
  });

  group('constrain', () {
    test('shrinks an overlay taller than the room available', () {
      // 200px tall in a 300px viewport. Below the anchor there is
      // 292 - 140 - 8 = 144; above there is only 84, so it stays put and is
      // clamped rather than flipping into an even smaller space.
      const shortView = Rect.fromLTWH(0, 0, 1000, 300);
      const anchor = Rect.fromLTWH(450, 100, 100, 40);
      final p = place(
        anchor: anchor,
        size: const Size(200, 200),
        view: shortView,
      );

      expect(p.flipped, isFalse);
      expect(p.constrained, isTrue);
      expect(p.size.height, 144);
      expect(p.size.width, 200);
    });

    test('shrinks an overlay wider than the viewport', () {
      const narrowView = Rect.fromLTWH(0, 0, 150, 800);
      final p = place(
        anchor: const Rect.fromLTWH(50, 380, 50, 40),
        view: narrowView,
      );

      expect(p.constrained, isTrue);
      expect(p.size.width, 150 - 16);
    });

    test('never leaves the safe area, even when it cannot fit', () {
      const tinyView = Rect.fromLTWH(0, 0, 100, 100);
      final p = place(
        anchor: const Rect.fromLTWH(40, 40, 20, 20),
        view: tinyView,
      );

      expect(p.offset.dx, greaterThanOrEqualTo(8));
      expect(p.offset.dy, greaterThanOrEqualTo(8));
      expect(p.size.width, lessThanOrEqualTo(100 - 16));
    });

    test('an unconstrained overlay reports its requested size', () {
      expect(place().size, overlay);
      expect(place().constrained, isFalse);
    });
  });

  group('viewport offset', () {
    test('a viewport not at the origin is respected', () {
      // A safe area: 44px status bar, 34px home indicator.
      const inset = Rect.fromLTRB(0, 44, 1000, 766);
      const anchor = Rect.fromLTWH(450, 60, 100, 40);

      final p = place(anchor: anchor, view: inset, side: AstryxOverlaySide.top);
      // Not enough room above inside the safe area, so it flips down.
      expect(p.flipped, isTrue);
      expect(p.offset.dy, greaterThanOrEqualTo(44 + 8));
    });
  });

  group('logical side resolution', () {
    test('the vertical sides never flip with direction', () {
      for (final side in <AstryxOverlaySide>[
        AstryxOverlaySide.top,
        AstryxOverlaySide.bottom,
      ]) {
        for (final direction in TextDirection.values) {
          expect(AstryxOverlaySide.resolve(side, direction), side);
        }
      }
    });

    test('the inline sides flip under RTL', () {
      expect(
        AstryxOverlaySide.resolve(AstryxOverlaySide.left, TextDirection.ltr),
        AstryxOverlaySide.left,
      );
      expect(
        AstryxOverlaySide.resolve(AstryxOverlaySide.left, TextDirection.rtl),
        AstryxOverlaySide.right,
      );
    });

    test('opposite is its own inverse', () {
      for (final side in AstryxOverlaySide.values) {
        expect(side.opposite.opposite, side);
      }
    });
  });

  group('arrow', () {
    test('points at the anchor centre when nothing shifted', () {
      final p = place();
      final arrow = resolveAstryxOverlayArrowOffset(
        anchor: centreAnchor,
        position: p,
        arrowExtent: 12,
      );
      // The overlay is centred, so the arrow is too.
      expect(arrow, closeTo((p.size.width - 12) / 2, 1e-9));
    });

    test('tracks the anchor after a shift', () {
      const anchor = Rect.fromLTWH(0, 380, 40, 40);
      final p = place(anchor: anchor);
      final arrow = resolveAstryxOverlayArrowOffset(
        anchor: anchor,
        position: p,
        arrowExtent: 12,
      );

      // The overlay slid right to x = 8; the anchor's centre is at 20, so the
      // arrow sits near the overlay's own leading edge — not at its middle.
      expect(arrow, lessThan(p.size.width / 2));
      expect(arrow, greaterThanOrEqualTo(8));
    });

    test('stays clear of the rounded corners', () {
      const anchor = Rect.fromLTWH(960, 380, 40, 40);
      final p = place(anchor: anchor);
      final arrow = resolveAstryxOverlayArrowOffset(
        anchor: anchor,
        position: p,
        arrowExtent: 12,
        cornerInset: 10,
      );

      expect(arrow, greaterThanOrEqualTo(10));
      expect(arrow, lessThanOrEqualTo(p.size.width - 12 - 10));
    });

    test('centres when the overlay is too small for its own corners', () {
      final p = place(size: const Size(20, 20));
      final arrow = resolveAstryxOverlayArrowOffset(
        anchor: centreAnchor,
        position: p,
        arrowExtent: 12,
      );
      expect(arrow, closeTo((20 - 12) / 2, 1e-9));
    });
  });

  group('AstryxOverlayPosition', () {
    test('is a value type', () {
      final a = place();
      final b = place();
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(place(side: AstryxOverlaySide.top)));
    });
  });
}
