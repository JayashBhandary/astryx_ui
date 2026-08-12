/// A small fixed-ratio preview of an image or a file.
library;

import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/stack.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/media/aspect_ratio.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A small preview of an image or a file.
///
/// Upstream's `Thumbnail`. An [AstryxAspectRatio] with a picture in it, a glyph
/// when there is no picture, and an optional caption under it — which covers
/// the
/// two cases a thumbnail actually has: something that can be shown, and
/// something that can only be named.
///
/// {@tool snippet}
/// ```dart
/// AstryxThumbnail(
///   label: 'atlas-scheduler.png',
///   image: NetworkImage(file.url),
///   onPressed: () => _lightbox.show(),
/// )
/// ```
/// {@end-tool}
///
/// **[label] is required.** A thumbnail is a picture of a thing, and the thing
/// has a name: without it, a wall of them is a wall of unlabelled images, and a
/// failed load is a grey square with nothing to say for itself.
class AstryxThumbnail extends StatelessWidget {
  /// Creates a thumbnail.
  const AstryxThumbnail({
    required this.label,
    super.key,
    this.image,
    this.icon,
    this.ratio = 1,
    this.width = 96,
    this.showCaption = false,
    this.onPressed,
    this.selected = false,
  });

  /// What this is a picture of. The accessible name, and the caption.
  final String label;

  /// The picture, if there is one.
  final ImageProvider? image;

  /// A glyph for a file that cannot be previewed.
  ///
  /// Defaults to a document. A PDF, a spreadsheet and a log are all "a file
  /// with
  /// a name", and a generic glyph is more honest than a rendering of the first
  /// page nobody can read at this size.
  final AstryxIconName? icon;

  /// Width divided by height. Square by default.
  final double ratio;

  /// How wide the thumbnail is. The height follows from [ratio].
  final double width;

  /// Whether to draw [label] under the picture.
  ///
  /// Off by default: in a grid the names are usually beside the grid, and a
  /// caption under every tile doubles the wall's height. On for a single
  /// thumbnail standing on its own.
  final bool showCaption;

  /// Called when the thumbnail is pressed — usually to open a lightbox.
  final VoidCallback? onPressed;

  /// Whether this is the chosen one in a set.
  ///
  /// Drawn as an accent border **and** announced as selected: a ring alone is
  /// invisible to a screen reader and to anybody who cannot separate the hues.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final picture = AstryxAspectRatio(
      ratio: ratio,
      showBorder: !selected,
      child: image == null
          ? Center(
              child: AstryxIcon(
                icon ?? AstryxIconName.copy,
                color: AstryxIconColor.secondary,
              ),
            )
          : Image(
              image: image!,
              fit: BoxFit.cover,
              // A failed load falls back to the glyph, so the tile keeps its
              // shape and the name underneath still means something.
              errorBuilder: (context, error, stack) => Center(
                child: AstryxIcon(
                  icon ?? AstryxIconName.copy,
                  color: AstryxIconColor.secondary,
                ),
              ),
            ),
    );

    Widget tile = SizedBox(
      width: width,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing1,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          if (selected)
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: theme.borderRadius(AstryxRadiusToken.container),
                border: Border.all(
                  color: theme.color(AstryxColorToken.accent),
                  width: theme.borderWidth() * 2,
                ),
              ),
              child: picture,
            )
          else
            picture,
          if (showCaption)
            AstryxText(
              label,
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
              maxLines: 2,
            ),
        ],
      ),
    );

    if (onPressed != null) {
      tile = AstryxFocusRing(
        focused: false,
        borderRadius: theme.borderRadius(AstryxRadiusToken.container),
        child: GestureDetector(onTap: onPressed, child: tile),
      );
    }

    return Semantics(
      container: true,
      image: image != null,
      button: onPressed != null,
      selected: selected ? true : null,
      label: label,
      onTap: onPressed,
      child: ExcludeSemantics(child: tile),
    );
  }
}
