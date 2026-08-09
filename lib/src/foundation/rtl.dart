/// Right-to-left helpers.
///
/// Astryx uses CSS logical properties throughout — `paddingInline`,
/// `marginBlockStart`, `insetInlineEnd` — which flip automatically under
/// `dir="rtl"`. Flutter's equivalent is the `*Directional` family, which flips
/// under [Directionality]. The translation is mechanical, and these helpers
/// exist so components reach for the directional form by default rather than
/// remembering to.
///
/// The rule for the port: **`EdgeInsets.only(left:)` is almost always a bug.**
/// If a value came from a logical property upstream, it must be directional
/// here.
library;

import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:flutter/widgets.dart';

/// Insets from the CSS logical properties.
///
/// [start] and [end] are the inline axis, flipping under RTL. [top] and
/// [bottom] are the block axis, which does not flip in any locale Astryx
/// supports.
///
/// {@tool snippet}
/// ```dart
/// // CSS: padding-inline: 12px; padding-block: 6px;
/// astryxInsets(inline: 12, block: 6);
/// ```
/// {@end-tool}
EdgeInsetsDirectional astryxInsets({
  double? inline,
  double? block,
  double? start,
  double? end,
  double? top,
  double? bottom,
}) => EdgeInsetsDirectional.only(
  start: start ?? inline ?? 0,
  end: end ?? inline ?? 0,
  top: top ?? block ?? 0,
  bottom: bottom ?? block ?? 0,
);

/// A directional border radius, from the CSS logical corner properties.
BorderRadiusDirectional astryxRadius({
  double? all,
  double? topStart,
  double? topEnd,
  double? bottomStart,
  double? bottomEnd,
}) => BorderRadiusDirectional.only(
  topStart: Radius.circular(topStart ?? all ?? 0),
  topEnd: Radius.circular(topEnd ?? all ?? 0),
  bottomStart: Radius.circular(bottomStart ?? all ?? 0),
  bottomEnd: Radius.circular(bottomEnd ?? all ?? 0),
);

/// Whether [context] is laid out right-to-left.
bool astryxIsRtl(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl;

/// The icons that must mirror under RTL.
///
/// A directional icon points *forward* or *back*, and forward is left in an RTL
/// locale. A chevron that opens a submenu must flip; one that expands a
/// disclosure downward must not.
///
/// The distinction is not cosmetic. Mirroring a clock or a checkmark makes it
/// wrong; failing to mirror a "next page" arrow makes it point backwards.
const Set<AstryxIconName> astryxMirroredIcons = <AstryxIconName>{
  AstryxIconName.chevronLeft,
  AstryxIconName.chevronRight,
  AstryxIconName.chevronsLeft,
  AstryxIconName.chevronsRight,
  AstryxIconName.externalLink,
};

/// The icons that must **not** mirror, though they might look as if they
/// should.
///
/// Recorded explicitly because each is a plausible mistake:
///
///  * [AstryxIconName.arrowUp] and [AstryxIconName.arrowDown] express sort
///    direction on the block axis, which does not flip.
///  * [AstryxIconName.clock] and [AstryxIconName.calendar] depict objects, and
///    clocks run clockwise in every locale.
///  * [AstryxIconName.check] and [AstryxIconName.checkDouble] are glyphs, not
///    directions.
///  * [AstryxIconName.search] has a handle, but mirroring it conveys nothing
///    and reads as an error.
const Set<AstryxIconName> astryxNeverMirroredIcons = <AstryxIconName>{
  AstryxIconName.arrowUp,
  AstryxIconName.arrowDown,
  AstryxIconName.arrowsUpDown,
  AstryxIconName.chevronDown,
  AstryxIconName.clock,
  AstryxIconName.calendar,
  AstryxIconName.check,
  AstryxIconName.checkDouble,
  AstryxIconName.search,
};

/// Whether [icon] should be mirrored under RTL.
bool astryxShouldMirrorIcon(AstryxIconName icon) =>
    astryxMirroredIcons.contains(icon);

/// Mirrors its child horizontally under a right-to-left [Directionality].
///
/// For a directional icon, or any glyph whose meaning depends on which way it
/// points.
///
/// {@tool snippet}
/// ```dart
/// AstryxMirrorForRtl(
///   enabled: astryxShouldMirrorIcon(AstryxIconName.chevronRight),
///   child: Icon(registry.icon(AstryxIconName.chevronRight)),
/// )
/// ```
/// {@end-tool}
class AstryxMirrorForRtl extends StatelessWidget {
  /// Creates a conditional mirror.
  const AstryxMirrorForRtl({
    required this.child,
    super.key,
    this.enabled = true,
  });

  /// The widget to mirror.
  final Widget child;

  /// Whether mirroring should happen at all.
  ///
  /// False leaves the child untouched even under RTL — for the icons in
  /// [astryxNeverMirroredIcons].
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || !astryxIsRtl(context)) return child;
    return Transform.flip(flipX: true, child: child);
  }
}
