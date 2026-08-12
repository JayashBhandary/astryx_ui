/// The overrides that apply to content drawn over media.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Where a scrim sits behind content over media.
enum AstryxMediaScrim {
  /// No scrim. For content over a surface that is already dark enough.
  none,

  /// A gradient from the bottom, for a caption or a control bar.
  bottom,

  /// A gradient from the top, for a close button or a counter.
  top,

  /// A flat wash over the whole thing, for content that covers it.
  full,
}

/// Makes text and icons legible over a picture.
///
/// Upstream's `MediaTheme`. A caption over a photograph cannot use
/// `--color-text-primary`: the photograph is whatever colour it is, and a
/// near-black caption over a near-black corner is a caption nobody reads. This
/// forces the **on-dark** tokens for its subtree and puts a scrim behind them.
///
/// {@tool snippet}
/// ```dart
/// Stack(
///   children: <Widget>[
///     Image.network(url, fit: BoxFit.cover),
///     Positioned(
///       left: 0, right: 0, bottom: 0,
///       child: AstryxMediaTheme(
///         child: AstryxText('Atlas, 14:02'),
///       ),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// **It does not change the resolved theme.** Spacing, radius, type and motion
/// stay exactly as they are — only the foreground colours and the ground behind
/// them move, because those are the only two things a picture underneath can
/// break. A caller's own tokens keep working.
///
/// Inside it, use `AstryxIconColor.inherit` and `AstryxTextColor.inherit`: both
/// take the colour set here, which is how a caption and the glyph beside it
/// stay
/// the same shade without either naming it.
class AstryxMediaTheme extends StatelessWidget {
  /// Creates a media overlay scope.
  const AstryxMediaTheme({
    required this.child,
    super.key,
    this.scrim = AstryxMediaScrim.bottom,
    this.padding = AstryxSpacingToken.spacing3,
  });

  /// The content drawn over the media.
  final Widget child;

  /// Which scrim to put behind it.
  ///
  /// A scrim rather than a shadow on the text: a drop shadow under white type
  /// is
  /// a trick that works on some photographs and fails on the rest, and there is
  /// no way to tell which from here.
  final AstryxMediaScrim scrim;

  /// Inner padding around [child].
  final AstryxSpacingToken padding;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final foreground = theme.color(AstryxColorToken.onDark);

    // `onDark`, not `textPrimary` inverted by hand: the token exists precisely
    // so "legible on something dark" is one decision the theme owns rather than
    // a guess each caller makes.
    final content = DefaultTextStyle.merge(
      style: TextStyle(color: foreground),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground),
        child: Padding(
          padding: EdgeInsets.all(theme.spacing(padding)),
          child: child,
        ),
      ),
    );

    if (scrim == AstryxMediaScrim.none) return content;

    final overlay = theme.color(AstryxColorToken.overlay);
    final gradient = switch (scrim) {
      AstryxMediaScrim.bottom => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[overlay, overlay.withValues(alpha: 0)],
      ),
      AstryxMediaScrim.top => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[overlay, overlay.withValues(alpha: 0)],
      ),
      AstryxMediaScrim.full || AstryxMediaScrim.none => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[overlay, overlay],
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: content,
    );
  }
}
