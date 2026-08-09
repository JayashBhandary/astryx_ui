/// Motion, with reduced-motion handling applied once.
library;

import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

/// Resolves motion tokens, honouring the platform's reduced-motion setting.
///
/// Upstream applies `@media (prefers-reduced-motion: reduce)` to every
/// transition. The Flutter equivalent is `MediaQuery.disableAnimationsOf`, and
/// the equivalent of "every transition" is: no widget reads a duration token
/// directly. Going through here means no widget can forget the check.
///
/// {@tool snippet}
/// ```dart
/// final motion = AstryxMotion.of(context);
///
/// AnimatedContainer(
///   duration: motion.duration(AstryxDurationToken.fast),
///   curve: motion.curve(),
///   …
/// )
/// ```
/// {@end-tool}
@immutable
class AstryxMotion {
  /// Creates a motion resolver.
  const AstryxMotion({required this.theme, required this.reduced});

  /// Reads the motion configuration from [context].
  factory AstryxMotion.of(BuildContext context) => AstryxMotion(
    theme: AstryxTheme.of(context),
    reduced: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
  );

  /// The theme the durations and curves come from.
  final AstryxThemeData theme;

  /// Whether the platform asks for reduced motion.
  final bool reduced;

  /// The duration for [token], or [Duration.zero] under reduced motion.
  ///
  /// Zero rather than merely shorter: the setting exists for people whom motion
  /// makes unwell, and a fast animation is still an animation.
  Duration duration(AstryxDurationToken token) =>
      reduced ? Duration.zero : theme.duration(token);

  /// The easing curve for [token].
  ///
  /// Not neutralised under reduced motion — with a zero duration the curve is
  /// never sampled, and returning [Curves.linear] would only mislead a caller
  /// that uses it for something else.
  Curve curve([AstryxEaseToken token = AstryxEaseToken.standard]) =>
      theme.ease(token);

  /// Whether an animation should run at all.
  ///
  /// For the cases a zero duration cannot express — a looping spinner, a
  /// shimmer — where the honest response is to stop rather than to race.
  bool get animate => !reduced;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AstryxMotion && other.theme == theme && other.reduced == reduced;

  @override
  int get hashCode => Object.hash(theme, reduced);

  @override
  String toString() => 'AstryxMotion(reduced: $reduced)';
}

/// Reduced-motion checks that do not need a resolved theme.
///
/// [AstryxMotion.of] requires an `AstryxTheme` ancestor, which is right for
/// resolving a duration but too much to ask of a widget that only wants to know
/// whether to run a loop.
abstract final class AstryxMotionAccess {
  /// Whether animation should run at [context].
  ///
  /// For the cases a zero duration cannot express — a looping spinner, a
  /// shimmer — where the honest response is to stop rather than to race.
  static bool animate(BuildContext context) =>
      !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
}
