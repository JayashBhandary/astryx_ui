/// The application entry point.
library;

import 'package:astryx_ui/src/app/astryx_theme_provider.dart';
import 'package:astryx_ui/src/foundation/density.dart';
import 'package:astryx_ui/src/foundation/link_delegate.dart';
import 'package:astryx_ui/src/icons/icon_registry.dart';
import 'package:astryx_ui/src/localizations/astryx_localizations.dart';
import 'package:astryx_ui/src/theme/astryx_theme.dart';
import 'package:astryx_ui/src/theme/engine/define_theme.dart';
import 'package:astryx_ui/src/theme/tokens/tokens.dart';
import 'package:astryx_ui/src/theme/type_role.dart';
import 'package:flutter/widgets.dart';

/// A `WidgetsApp` wrapped in an [AstryxThemeProvider].
///
/// Use this for an app built on Astryx alone. To adopt `astryx_ui` inside an
/// existing `MaterialApp` or `CupertinoApp`, use [AstryxThemeProvider]
/// directly — this widget composes it, so the two behave identically.
///
/// Deliberately built on `WidgetsApp`, not `MaterialApp`: Astryx has its own
/// colour, typography and spacing model, and inheriting Material's would mean
/// every widget neutralising its defaults (ADR-002).
///
/// {@tool snippet}
/// ```dart
/// AstryxApp(
///   theme: neutralTheme,
///   home: const HomePage(),
/// )
/// ```
/// {@end-tool}
class AstryxApp extends StatelessWidget {
  /// Creates an app with a [home] widget.
  const AstryxApp({
    super.key,
    this.home,
    this.theme,
    this.mode = AstryxColorMode.system,
    this.density,
    this.icons,
    this.localizations = const AstryxLocalizations(),
    this.platform,
    this.linkDelegate,
    this.title = '',
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : routerConfig = null;

  /// Creates an app driven by a [routerConfig], for `go_router` and friends.
  const AstryxApp.router({
    required this.routerConfig,
    super.key,
    this.theme,
    this.mode = AstryxColorMode.system,
    this.density,
    this.icons,
    this.localizations = const AstryxLocalizations(),
    this.platform,
    this.linkDelegate,
    this.title = '',
    this.builder,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : home = null,
       routes = const <String, WidgetBuilder>{},
       initialRoute = null,
       onGenerateRoute = null,
       onUnknownRoute = null,
       navigatorKey = null,
       navigatorObservers = const <NavigatorObserver>[];

  /// The widget for the default route.
  final Widget? home;

  /// {@template AstryxApp.theme}
  /// The theme to resolve. Null uses the Astryx defaults.
  /// {@endtemplate}
  final AstryxDefinedTheme? theme;

  /// {@template AstryxApp.mode}
  /// Which colour mode to resolve. Defaults to following the platform.
  /// {@endtemplate}
  final AstryxColorMode mode;

  /// {@template AstryxApp.density}
  /// Overrides the resolved interaction density.
  /// {@endtemplate}
  final AstryxDensity? density;

  /// {@template AstryxApp.icons}
  /// The icon registry. Null uses the Lucide-backed defaults.
  /// {@endtemplate}
  final AstryxIconRegistry? icons;

  /// {@template AstryxApp.localizations}
  /// The strings the widgets use. English by default.
  /// {@endtemplate}
  final AstryxLocalizations localizations;

  /// {@template AstryxApp.platform}
  /// Overrides the platform used for density and font-stack resolution.
  /// {@endtemplate}
  final TargetPlatform? platform;

  /// {@template AstryxApp.linkDelegate}
  /// Handles activation of a link. Null means links do nothing.
  /// {@endtemplate}
  final AstryxLinkDelegate? linkDelegate;

  /// A one-line description used by the device to identify the app.
  final String title;

  /// The app's top-level routing table.
  final Map<String, WidgetBuilder> routes;

  /// The name of the first route to show.
  final String? initialRoute;

  /// Builds a route for routes the [routes] table does not cover.
  final RouteFactory? onGenerateRoute;

  /// Builds a route when everything else fails.
  final RouteFactory? onUnknownRoute;

  /// A key for the app's navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Observers for the app's navigator.
  final List<NavigatorObserver> navigatorObservers;

  /// The routing configuration, for [AstryxApp.router].
  final RouterConfig<Object>? routerConfig;

  /// Inserts a widget between the navigator and the theme scope.
  final TransitionBuilder? builder;

  /// The app's current locale.
  final Locale? locale;

  /// Delegates producing localised resources.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The locales this app has been localised for.
  final Iterable<Locale> supportedLocales;

  /// Whether to show the performance overlay.
  final bool showPerformanceOverlay;

  /// Whether to show the semantics debugger.
  final bool showSemanticsDebugger;

  /// Whether to show the debug banner in debug builds.
  final bool debugShowCheckedModeBanner;

  /// Keyboard shortcuts for the app.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Actions bound to the app's intents.
  final Map<Type, Action<Intent>>? actions;

  /// An identifier for state restoration.
  final String? restorationScopeId;

  /// Wraps [child] in the theme scope.
  ///
  /// `WidgetsApp` needs a `color`, and the theme has to exist before that can
  /// be read — so the provider sits *inside* the app and the colour is taken
  /// from the token defaults, which no theme is required to override.
  Widget _wrap(BuildContext context, Widget? child) => AstryxThemeProvider(
    theme: theme,
    mode: mode,
    density: density,
    icons: icons,
    localizations: localizations,
    platform: platform,
    linkDelegate: linkDelegate,
    child: Builder(
      builder: (context) {
        final wrapped = child ?? const SizedBox.shrink();
        // A default text style, so a bare `Text` inherits the design system
        // rather than Flutter's red-on-transparent debug style.
        final data = AstryxTheme.of(context);
        return DefaultTextStyle(
          style: data
              .textStyle(AstryxTypeRole.body)
              .copyWith(color: data.color(AstryxColorToken.textPrimary)),
          child: builder == null ? wrapped : builder!(context, wrapped),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    // `WidgetsApp.color` is used by the OS task switcher, before any theme
    // exists. The default accent is the honest answer.
    const seed = Color(0xFF0064E0);

    if (routerConfig != null) {
      return WidgetsApp.router(
        routerConfig: routerConfig,
        title: title,
        color: seed,
        builder: _wrap,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
      );
    }

    return WidgetsApp(
      home: home,
      title: title,
      color: seed,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      navigatorKey: navigatorKey,
      navigatorObservers: navigatorObservers,
      // `WidgetsApp` demands a route factory when there is no `onGenerateRoute`
      // and no `home`; this keeps a bare `AstryxApp()` from asserting.
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
      builder: _wrap,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }
}
