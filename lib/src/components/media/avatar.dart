/// A person or entity, as a small square.
library;

import 'package:astryx_ui/src/components/feedback/status_dot.dart';
import 'package:astryx_ui/src/components/layout/icon.dart';
import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/foundation/focus_ring.dart';
import 'package:astryx_ui/src/foundation/tap_target.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// How large an avatar is drawn.
enum AstryxAvatarSize {
  /// 20px. Inside a table cell or a dense row.
  xs(20, AstryxTextSizeToken.threeXs),

  /// 24px. Beside a line of body text.
  sm(24, AstryxTextSizeToken.twoXs),

  /// 32px. The default — a list row, a comment.
  md(32, AstryxTextSizeToken.xs),

  /// 40px. A card header.
  lg(40, AstryxTextSizeToken.sm),

  /// 64px. A profile.
  xl(64, AstryxTextSizeToken.lg);

  const AstryxAvatarSize(this.extent, this.textSize);

  /// The edge length, in logical pixels.
  final double extent;

  /// The size initials are drawn at.
  final AstryxTextSizeToken textSize;
}

/// Whether an avatar is round or square-ish.
enum AstryxAvatarShape {
  /// A circle. A person.
  circle,

  /// A rounded square. A team, a service, an organisation — anything that is
  /// not a person, which is the distinction this exists to carry.
  rounded,
}

/// A person or entity as an image, initials or an icon.
///
/// Upstream's `Avatar` and `AvatarStatusDot` as one widget: an avatar with a
/// status dot beside it rather than on it is two things a reader has to
/// associate, and the association is the whole point.
///
/// {@tool snippet}
/// ```dart
/// AstryxAvatar(
///   name: 'Ada Lovelace',
///   image: NetworkImage(user.avatarUrl),
///   status: AstryxStatusDotVariant.success,
///   statusLabel: 'Online',
/// )
/// ```
/// {@end-tool}
///
/// **[name] is required and is the accessible name.** An avatar is a picture of
/// a person: without the name it is an unlabelled image, and a row of them is a
/// row of unlabelled images. It is also where the initials come from, so there
/// is nothing to keep in step.
class AstryxAvatar extends StatelessWidget {
  /// Creates an avatar.
  const AstryxAvatar({
    required this.name,
    super.key,
    this.image,
    this.icon,
    this.size = AstryxAvatarSize.md,
    this.shape = AstryxAvatarShape.circle,
    this.status,
    this.statusLabel,
    this.onPressed,
    this.semanticsLabel,
  }) : assert(
         status == null || statusLabel != null,
         'A status needs a statusLabel: a coloured dot on its own says nothing '
         'to a screen reader, and nothing to anybody who cannot tell the hues '
         'apart.',
       );

  /// Who or what this is. The accessible name, and the source of the initials.
  final String name;

  /// The picture, if there is one.
  final ImageProvider? image;

  /// A glyph to use instead of initials when there is no image.
  ///
  /// For an entity a person's initials would misrepresent — a service, a bot, a
  /// deleted account.
  final AstryxIconName? icon;

  /// How large it is drawn.
  final AstryxAvatarSize size;

  /// Round for a person, rounded-square for anything else.
  final AstryxAvatarShape shape;

  /// A state to show as a dot on the corner.
  final AstryxStatusDotVariant? status;

  /// What the dot means — "Online", "Away", "Suspended".
  final String? statusLabel;

  /// Called when the avatar is pressed.
  final VoidCallback? onPressed;

  /// Overrides the accessible name. Defaults to [name] and the status.
  final String? semanticsLabel;

  /// The initials [name] reduces to.
  ///
  /// The first letter of the first and last words: "Ada Lovelace" is AL, "ada"
  /// is A, and a name written in a script with no case is left as it is rather
  /// than mangled by an uppercase that means nothing there.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);
    final extent = size.extent;

    final corners = shape == AstryxAvatarShape.circle
        ? BorderRadius.circular(extent)
        : theme.borderRadius(AstryxRadiusToken.element);

    Widget content;
    if (image != null) {
      content = Image(
        image: image!,
        fit: BoxFit.cover,
        width: extent,
        height: extent,
        // A failed image falls back to the initials rather than to a broken
        // glyph: the name is known either way, so there is no reason to show
        // less than it.
        errorBuilder: (context, error, stack) => _fallback(theme, extent),
      );
    } else {
      content = _fallback(theme, extent);
    }

    Widget avatar = Container(
      width: extent,
      height: extent,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        borderRadius: corners,
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      child: content,
    );

    if (status != null) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          avatar,
          PositionedDirectional(
            end: -1,
            bottom: -1,
            // A ring in the page's own colour, so the dot reads as sitting on
            // the avatar rather than as part of the picture.
            child: Container(
              padding: EdgeInsets.all(theme.borderWidth() * 2),
              decoration: BoxDecoration(
                color: theme.color(AstryxColorToken.backgroundBody),
                shape: BoxShape.circle,
              ),
              child: AstryxStatusDot(status!, label: statusLabel!),
            ),
          ),
        ],
      );
    }

    final name = semanticsLabel ??
        (statusLabel == null ? this.name : '${this.name}, $statusLabel');

    if (onPressed == null) {
      return Semantics(
        container: true,
        image: image != null,
        label: name,
        child: ExcludeSemantics(child: avatar),
      );
    }

    return Semantics(
      container: true,
      button: true,
      label: name,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: AstryxFocusRing(
          focused: false,
          borderRadius: corners,
          child: AstryxTapTarget(
            child: GestureDetector(onTap: onPressed, child: avatar),
          ),
        ),
      ),
    );
  }

  Widget _fallback(AstryxThemeData theme, double extent) => icon != null
      ? Center(
          child: AstryxIcon(
            icon!,
            size: extent <= 24 ? AstryxIconSize.xsm : AstryxIconSize.sm,
            color: AstryxIconColor.secondary,
          ),
        )
      : Center(
          child: AstryxText(
            initials,
            size: size.textSize,
            color: AstryxTextColor.secondary,
            weight: AstryxTextWeight.medium,
          ),
        );
}
