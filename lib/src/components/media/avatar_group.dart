/// Overlapping avatars, and a count for the rest.
library;

import 'package:astryx_ui/src/components/layout/text.dart';
import 'package:astryx_ui/src/components/media/avatar.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// A row of overlapping avatars, with a count for the ones that did not fit.
///
/// Upstream's `AvatarGroup` and `AvatarGroupOverflow`. The overflow chip is
/// part
/// of the same widget because the count is not decoration: "+4" is the only
/// thing telling a reader the row is a *sample* rather than the whole set.
///
/// {@tool snippet}
/// ```dart
/// AstryxAvatarGroup(
///   avatars: <AstryxAvatar>[
///     for (final person in reviewers) AstryxAvatar(name: person.name),
///   ],
///   max: 4,
/// )
/// ```
/// {@end-tool}
///
/// **The group is announced as a group.** A reader hears "4 reviewers: Ada
/// Lovelace, Grace Hopper, and 2 more" rather than four unlabelled images —
/// which is what a row of avatars is to anybody who cannot see it.
class AstryxAvatarGroup extends StatelessWidget {
  /// Creates an avatar group.
  const AstryxAvatarGroup({
    required this.avatars,
    super.key,
    this.max = 5,
    this.size = AstryxAvatarSize.md,
    this.onOverflowPressed,
    this.label,
  }) : assert(max > 0, 'max must be at least one');

  /// The avatars, in order. Their own `size` is overridden by [size].
  final List<AstryxAvatar> avatars;

  /// How many to draw before the overflow chip.
  final int max;

  /// The size every avatar in the group takes.
  ///
  /// One size for the row: avatars of different sizes overlapping read as a
  /// mistake rather than as a hierarchy.
  final AstryxAvatarSize size;

  /// Called when the overflow chip is pressed — usually to show the whole set.
  ///
  /// Null leaves it as a label. Worth wiring: the names behind a "+4" are
  /// otherwise unreachable, and a count nobody can expand is a count nobody can
  /// act on.
  final VoidCallback? onOverflowPressed;

  /// What the group is. "Reviewers", "Attendees", "On call".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = AstryxLocalizations.of(context);

    final shown = avatars.take(max).toList();
    final hidden = avatars.length - shown.length;

    // A quarter of the avatar, which is enough to read as a stack and not so
    // much that a face is lost behind its neighbour.
    final overlap = size.extent / 4;

    final names = avatars.map((avatar) => avatar.name).toList();
    final spoken = <String>[
      ?label,
      ...shown.map((avatar) => avatar.name),
      if (hidden > 0) l10n.avatarGroupMore(hidden),
    ].join(', ');

    return Semantics(
      container: true,
      label: spoken,
      value: names.length == 1 ? null : l10n.avatarGroupCount(names.length),
      child: ExcludeSemantics(
        child: SizedBox(
          height: size.extent,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              for (var i = 0; i < shown.length; i++)
                PositionedDirectional(
                  start: i * (size.extent - overlap),
                  child: _Ringed(child: _sized(shown[i])),
                ),
              if (hidden > 0)
                PositionedDirectional(
                  start: shown.length * (size.extent - overlap),
                  child: _Ringed(
                    child: _Overflow(
                      count: hidden,
                      size: size,
                      onPressed: onOverflowPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// The same avatar at the group's size.
  AstryxAvatar _sized(AstryxAvatar avatar) => AstryxAvatar(
    name: avatar.name,
    image: avatar.image,
    icon: avatar.icon,
    size: size,
    shape: avatar.shape,
    status: avatar.status,
    statusLabel: avatar.statusLabel,
    onPressed: avatar.onPressed,
    semanticsLabel: avatar.semanticsLabel,
  );
}

/// A ring in the page's colour, so overlapping avatars stay separable.
class _Ringed extends StatelessWidget {
  const _Ringed({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    return Container(
      padding: EdgeInsets.all(theme.borderWidth() * 2),
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundBody),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

/// The "+4".
class _Overflow extends StatelessWidget {
  const _Overflow({
    required this.count,
    required this.size,
    required this.onPressed,
  });

  final int count;
  final AstryxAvatarSize size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AstryxTheme.of(context);

    final chip = Container(
      width: size.extent,
      height: size.extent,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.color(AstryxColorToken.backgroundMuted),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.color(AstryxColorToken.border),
          width: theme.borderWidth(),
        ),
      ),
      child: AstryxText(
        '+$count',
        size: size.textSize,
        color: AstryxTextColor.secondary,
        weight: AstryxTextWeight.medium,
      ),
    );

    if (onPressed == null) return chip;
    return GestureDetector(onTap: onPressed, child: chip);
  }
}
