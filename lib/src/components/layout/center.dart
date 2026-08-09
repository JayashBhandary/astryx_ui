/// Centring.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Which axes a child is centred on.
enum AstryxCenterAxis {
  /// Centred both ways.
  both,

  /// Centred horizontally; the vertical position is left alone.
  horizontal,

  /// Centred vertically; the horizontal position is left alone.
  vertical,
}

/// Centres its child, with optional token-valued padding and sizing.
///
/// Trivial by design. It exists so layout code reads consistently and so
/// padding stays on the spacing scale — `AstryxCenter(padding: spacing4)` next
/// to `AstryxHStack(gap: spacing4)`, rather than a `Center` beside a `Padding`
/// holding a bare `16.0`.
///
/// {@tool snippet}
/// ```dart
/// AstryxCenter(
///   minHeight: 200,
///   padding: AstryxSpacingToken.spacing6,
///   child: const AstryxText('Nothing here yet'),
/// )
/// ```
/// {@end-tool}
class AstryxCenter extends StatelessWidget {
  /// Creates a centring box.
  const AstryxCenter({
    required this.child,
    super.key,
    this.axis = AstryxCenterAxis.both,
    this.padding,
    this.paddingInline,
    this.paddingBlock,
    this.width,
    this.height,
    this.maxWidth,
    this.minHeight,
  });

  /// The widget to centre.
  final Widget child;

  /// Which axes to centre on.
  final AstryxCenterAxis axis;

  /// Padding on every side.
  ///
  /// [paddingInline] and [paddingBlock] override it per axis.
  final AstryxSpacingToken? padding;

  /// Padding on the inline axis — start and end, so it flips under RTL.
  final AstryxSpacingToken? paddingInline;

  /// Padding on the block axis — top and bottom.
  final AstryxSpacingToken? paddingBlock;

  /// A fixed width.
  final double? width;

  /// A fixed height.
  final double? height;

  /// A maximum width, for constraining a centred column of text.
  final double? maxWidth;

  /// A minimum height, for an empty state that should not collapse.
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    double? space(AstryxSpacingToken? token) =>
        token == null ? null : theme.spacing(token);

    final all = space(padding);
    final inline = space(paddingInline) ?? all;
    final block = space(paddingBlock) ?? all;

    Widget result = Align(
      alignment: switch (axis) {
        AstryxCenterAxis.both => Alignment.center,
        AstryxCenterAxis.horizontal => Alignment.topCenter,
        AstryxCenterAxis.vertical => Alignment.centerLeft,
      },
      // Shrink-wrap the axis being centred so the box does not claim the whole
      // parent unless it was given a size.
      widthFactor: axis == AstryxCenterAxis.vertical ? 1.0 : null,
      heightFactor: axis == AstryxCenterAxis.horizontal ? 1.0 : null,
      child: child,
    );

    if (inline != null || block != null) {
      result = Padding(
        padding: EdgeInsetsDirectional.only(
          start: inline ?? 0,
          end: inline ?? 0,
          top: block ?? 0,
          bottom: block ?? 0,
        ),
        child: result,
      );
    }

    if (width != null ||
        height != null ||
        maxWidth != null ||
        minHeight != null) {
      result = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          maxWidth: width ?? maxWidth ?? double.infinity,
          minHeight: height ?? minHeight ?? 0,
          maxHeight: height ?? double.infinity,
        ),
        child: result,
      );
    }

    return result;
  }
}
