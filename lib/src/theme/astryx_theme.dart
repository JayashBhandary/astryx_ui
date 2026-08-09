/// The inherited theme scope.
library;

import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/theme/astryx_theme_data.dart';
import 'package:astryx_ui/src/theme/engine/token_resolver.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The colour mode a consumer asks for, which may defer to the platform.
///
/// Distinct from `AstryxThemeMode`, the engine's *resolved* light-or-dark. This
/// is the setting; that is the answer. [resolve] turns one into the other.
enum AstryxColorMode {
  /// Follow the platform's own light/dark preference.
  system,

  /// Always light.
  light,

  /// Always dark.
  dark;

  /// The resolved mode, consulting [platformBrightness] only for [system].
  AstryxThemeMode resolve(Brightness platformBrightness) => switch (this) {
    AstryxColorMode.light => AstryxThemeMode.light,
    AstryxColorMode.dark => AstryxThemeMode.dark,
    AstryxColorMode.system =>
      platformBrightness == Brightness.dark
          ? AstryxThemeMode.dark
          : AstryxThemeMode.light,
  };
}

/// Makes an [AstryxThemeData] available to the widgets beneath it.
///
/// Usually installed by `AstryxApp` or `AstryxThemeProvider` rather than
/// directly. Use it on its own to re-theme a subtree — an inverted toolbar, a
/// preview pane showing another theme.
///
/// {@tool snippet}
/// ```dart
/// AstryxTheme(
///   data: myThemeData,
///   child: const MyPane(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * `AstryxThemeProvider`, which resolves a theme from a definition and
///    installs this along with the icon registry and localisations.
class AstryxTheme extends InheritedWidget {
  /// Creates a theme scope.
  AstryxTheme({
    required this.data,
    required Widget child,
    super.key,
    this.density,
    this.icons,
  }) : super(
         // An ambient `IconTheme`, so an icon with no explicit colour picks up
         // the Astryx palette rather than Flutter's black-on-nothing fallback.
         //
         // This is what lets a component impose a colour on an icon it did not
         // build — a badge tints its icon to the badge's foreground, a menu
         // greys a disabled row's icon — including one the *caller* supplied.
         // Without it, `AstryxIcon` would have to name a fixed role and would
         // ignore the surface it sits on (ADR-044).
         child: IconTheme(
           data: IconThemeData(
             color: data.color(AstryxColorToken.iconPrimary),
             // The `md` step, 1.25rem against the 16px root. A literal rather
             // than `AstryxIconSize.md.pixels`, because that enum lives in the
             // component layer and this is the theme layer — the dependency
             // only runs one way. Pinned by a test so the two cannot drift.
             size: 20,
           ),
           child: child,
         ),
       );

  /// The resolved theme values.
  final AstryxThemeData data;

  /// The density for this subtree.
  ///
  /// When null, the density is inherited from an enclosing [AstryxTheme], or
  /// derived from [AstryxThemeData.platform] if there is none.
  final AstryxDensity? density;

  /// The icon registry for this subtree.
  ///
  /// When null, the registry is inherited, falling back to
  /// [AstryxIconRegistry.defaults].
  final AstryxIconRegistry? icons;

  /// The theme data from the nearest enclosing [AstryxTheme].
  ///
  /// Throws a [FlutterError] with a fix-it if there is none. Reach for
  /// [maybeOf] where a theme is genuinely optional.
  static AstryxThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    if (theme == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No AstryxTheme found in the widget tree.'),
        ErrorDescription(
          '${context.widget.runtimeType} asked for the Astryx theme, but no '
          'AstryxTheme ancestor was found.',
        ),
        ErrorHint(
          'Wrap your app in AstryxApp, or in AstryxThemeProvider if you are '
          'adopting astryx_ui inside an existing MaterialApp or CupertinoApp.',
        ),
        context.describeElement('The context used was'),
      ]);
    }
    return theme;
  }

  /// The theme data from the nearest enclosing [AstryxTheme], or null.
  static AstryxThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxTheme>()?.data;

  /// The density in effect at [context].
  ///
  /// Falls back to resolving [AstryxThemeData.platform] when no enclosing
  /// theme sets one, and to the platform default when there is no theme at all.
  static AstryxDensity densityOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AstryxTheme>();
    return scope?.density ??
        AstryxDensity.resolve(
          scope?.data.platform ?? defaultTargetPlatform,
        );
  }

  /// The icon registry in effect at [context].
  ///
  /// Falls back to [AstryxIconRegistry.defaults], so an icon always resolves.
  static AstryxIconRegistry iconsOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AstryxTheme>()?.icons ??
      AstryxIconRegistry.defaults;

  @override
  bool updateShouldNotify(AstryxTheme oldWidget) =>
      data != oldWidget.data ||
      density != oldWidget.density ||
      icons != oldWidget.icons;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AstryxThemeData>('data', data))
      ..add(EnumProperty<AstryxDensity>('density', density, defaultValue: null))
      ..add(
        DiagnosticsProperty<AstryxIconRegistry>(
          'icons',
          icons,
          defaultValue: null,
        ),
      );
  }
}
