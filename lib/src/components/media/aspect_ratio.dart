/// A box that keeps its width-to-height ratio.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A box that keeps its ratio as it resizes, with the tokens applied.
///
/// Upstream's `AspectRatio`. Flutter already has [AspectRatio] and this does
/// not replace it: what it adds is the **radius, the ground and the clip** from
/// the token layer, which is the part every media surface in a design system
/// has to agree about. Reach for Flutter's directly when none of that applies.
///
/// {@tool snippet}
/// ```dart
/// AstryxAspectRatio(
///   ratio: 16 / 9,
///   child: Image.network(url, fit: BoxFit.cover),
/// )
/// ```
/// {@end-tool}
///
/// The **ground matters more than it looks**: an image that has not loaded yet
/// leaves a hole, and a hole in the middle of a page reads as a bug rather than
/// as a wait. A tinted box of the right shape reads as the picture arriving.
class AstryxAspectRatio extends StatelessWidget {
  /// Creates a fixed-ratio box.
  const AstryxAspectRatio({
    required this.ratio,
    super.key,
    this.child,
    this.radius = AstryxRadiusToken.container,
    this.background = AstryxColorToken.backgroundMuted,
    this.showBorder = false,
    this.clip = true,
    this.semanticsLabel,
  }) : assert(ratio > 0, 'ratio must be positive');

  /// Width divided by height. `16 / 9`, `1`, `4 / 3`.
  final double ratio;

  /// What fills the box. Null leaves the ground, which is a placeholder.
  final Widget? child;

  /// The corner radius token.
  final AstryxRadiusToken radius;

  /// The ground behind [child].
  final AstryxColorToken background;

  /// Whether to draw a hairline border.
  ///
  /// Worth it over a photograph that might be nearly the page's own colour at
  /// its edges — without it the frame ends nowhere in particular.
  final bool showBorder;

  /// Whether to clip [child] to the rounded rectangle.
  final bool clip;

  /// What a screen reader announces for the whole box.
  ///
  /// Null leaves whatever the child says. An `Image` with no `semanticLabel`
  /// says nothing at all, which is right for decoration and wrong for a
  /// photograph carrying information.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final corners = theme.borderRadius(radius);

    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.color(background),
        borderRadius: corners,
        border: showBorder
            ? Border.all(
                color: theme.color(AstryxColorToken.border),
                width: theme.borderWidth(),
              )
            : null,
      ),
      child: child == null
          ? const SizedBox.expand()
          : (clip
                ? ClipRRect(borderRadius: corners, child: child)
                : child),
    );

    box = AspectRatio(aspectRatio: ratio, child: box);

    if (semanticsLabel == null) return box;
    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel,
      child: ExcludeSemantics(child: box),
    );
  }
}
