/// A theme scope that animates between themes instead of snapping.
library;

import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:flutter/widgets.dart';

/// Interpolates between two [AstryxThemeData]s with [AstryxThemeData.lerp].
///
/// The Material equivalent is `ThemeDataTween`.
class AstryxThemeDataTween extends Tween<AstryxThemeData> {
  /// Creates a tween between [begin] and [end].
  AstryxThemeDataTween({super.begin, super.end});

  @override
  AstryxThemeData lerp(double t) => AstryxThemeData.lerp(begin!, end!, t);
}

/// An [AstryxTheme] that cross-fades to a new [data] over [duration].
///
/// The Material equivalent is `AnimatedTheme`. `AstryxThemeProvider` and
/// `AstryxApp` install one, so flipping `mode:` or swapping `theme:` blends
/// every colour, shadow and length in the app instead of repainting it in one
/// frame. Use it directly to animate a subtree's theme.
///
/// Under reduced motion pass [Duration.zero]; the provider does this for you.
///
/// {@tool snippet}
/// ```dart
/// AstryxAnimatedTheme(
///   data: _dark ? darkData : lightData,
///   child: const Preview(),
/// )
/// ```
/// {@end-tool}
class AstryxAnimatedTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme scope.
  const AstryxAnimatedTheme({
    required this.data,
    required this.child,
    super.key,
    this.density,
    this.icons,
    super.curve,
    super.duration = const Duration(milliseconds: 200),
    super.onEnd,
  });

  /// The theme to animate to.
  final AstryxThemeData data;

  /// See [AstryxTheme.density].
  final AstryxDensity? density;

  /// See [AstryxTheme.icons].
  final AstryxIconRegistry? icons;

  /// The widget below this in the tree.
  final Widget child;

  @override
  AnimatedWidgetBaseState<AstryxAnimatedTheme> createState() =>
      _AstryxAnimatedThemeState();
}

class _AstryxAnimatedThemeState
    extends AnimatedWidgetBaseState<AstryxAnimatedTheme> {
  AstryxThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (value) => AstryxThemeDataTween(begin: value as AstryxThemeData),
            )
            as AstryxThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) => AstryxTheme(
    data: _data!.evaluate(animation),
    density: widget.density,
    icons: widget.icons,
    child: widget.child,
  );
}
